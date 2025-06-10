package com.example.servlet;

import com.example.model.Concert;
import com.example.util.DBUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.sql.Date;
import java.util.*;
import java.nio.file.*;
import java.io.File;

@WebServlet("/concert")
@MultipartConfig(
    maxFileSize = 10485760,    // 10MB
    maxRequestSize = 20971520,  // 20MB
    fileSizeThreshold = 5242880 // 5MB
)
public class ConcertServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "uploads";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("list".equals(action)) {
            listConcerts(request, response);
        } else if ("manage".equals(action)) {
            manageConcerts(request, response);
        } else if ("add".equals(action)) {
            addConcert(request, response);
        } else if ("edit".equals(action)) {
            editConcert(request, response);
        } else if ("delete".equals(action)) {
            deleteConcert(request, response);
        }
    }
    
    private void manageConcerts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer role = (Integer) session.getAttribute("role");
        if (role == null || role != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Concert> concerts = new ArrayList<>();
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM concerts ORDER BY date DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Concert concert = new Concert();
                concert.setId(rs.getInt("id"));
                concert.setName(rs.getString("name"));
                concert.setDate(rs.getDate("date"));
                concert.setLocation(rs.getString("location"));
                concert.setTicketPrice(rs.getBigDecimal("ticketPrice"));
                concert.setImage(rs.getString("image"));
                concert.setRemainingTickets(rs.getInt("remainingTickets"));
                concerts.add(concert);
            }
            
            request.setAttribute("concerts", concerts);
            request.getRequestDispatcher("/admin/concert_manage.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "获取演唱会列表失败");
            request.getRequestDispatcher("/admin/concert_manage.jsp").forward(request, response);
        } finally {
            DBUtil.closeAll(conn, pstmt, rs);
        }
    }
    
    private void addConcert(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
      
        HttpSession session = request.getSession();
        Integer role = (Integer) session.getAttribute("role");
        if (role == null || role != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
       
        Part filePart = request.getPart("image");
        String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        filePart.write(uploadPath + File.separator + fileName);
        
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO concerts (name, date, location, ticketPrice, image, remainingTickets) " +
                         "VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, request.getParameter("name"));
            pstmt.setDate(2, Date.valueOf(request.getParameter("date")));
            pstmt.setString(3, request.getParameter("location"));
            pstmt.setBigDecimal(4, new BigDecimal(request.getParameter("ticketPrice")));
            pstmt.setString(5, fileName);
            pstmt.setInt(6, Integer.parseInt(request.getParameter("remainingTickets")));
            
            pstmt.executeUpdate();
            response.sendRedirect(request.getContextPath() + "/concert?action=manage");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "添加演唱会失败");
            request.getRequestDispatcher("/admin/concert_add.jsp").forward(request, response);
        } finally {
            DBUtil.closeAll(conn, pstmt, null);
        }
    }
    
    private void editConcert(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer role = (Integer) session.getAttribute("role");
        if (role == null || role != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        
        if ("GET".equalsIgnoreCase(request.getMethod())) {
            int id = Integer.parseInt(request.getParameter("id"));
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = DBUtil.getConnection();
                String sql = "SELECT * FROM concerts WHERE id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, id);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    Concert concert = new Concert();
                    concert.setId(rs.getInt("id"));
                    concert.setName(rs.getString("name"));
                    concert.setDate(rs.getDate("date"));
                    concert.setLocation(rs.getString("location"));
                    concert.setTicketPrice(rs.getBigDecimal("ticketPrice"));
                    concert.setRemainingTickets(rs.getInt("remainingTickets"));
                    concert.setImage(rs.getString("image"));
                    
                    request.setAttribute("concert", concert);
                    request.getRequestDispatcher("/admin/concert_edit.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/concert?action=manage");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/concert?action=manage");
            } finally {
                DBUtil.closeAll(conn, pstmt, rs);
            }
            return;
        }

        
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        Date date = Date.valueOf(request.getParameter("date"));
        String location = request.getParameter("location");
        BigDecimal ticketPrice = new BigDecimal(request.getParameter("ticketPrice"));
        int remainingTickets = Integer.parseInt(request.getParameter("remainingTickets"));
        
        
        Part filePart = request.getPart("image");
        String fileName = null;
        if (filePart != null && filePart.getSize() > 0) {
            fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            filePart.write(uploadPath + File.separator + fileName);
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql;
            if (fileName != null) {
                
                sql = "UPDATE concerts SET name=?, date=?, location=?, ticketPrice=?, remainingTickets=?, image=? WHERE id=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, name);
                pstmt.setDate(2, date);
                pstmt.setString(3, location);
                pstmt.setBigDecimal(4, ticketPrice);
                pstmt.setInt(5, remainingTickets);
                pstmt.setString(6, fileName);
                pstmt.setInt(7, id);
            } else {

                sql = "UPDATE concerts SET name=?, date=?, location=?, ticketPrice=?, remainingTickets=? WHERE id=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, name);
                pstmt.setDate(2, date);
                pstmt.setString(3, location);
                pstmt.setBigDecimal(4, ticketPrice);
                pstmt.setInt(5, remainingTickets);
                pstmt.setInt(6, id);
            }
            
            pstmt.executeUpdate();
            response.sendRedirect(request.getContextPath() + "/concert?action=manage");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "修改演唱会失败");
            request.getRequestDispatcher("/admin/concert_edit.jsp").forward(request, response);
        } finally {
            DBUtil.closeAll(conn, pstmt, null);
        }
    }
    
    private void deleteConcert(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "DELETE FROM concerts WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            
            pstmt.executeUpdate();
            response.sendRedirect(request.getContextPath() + "/concert?action=list");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "删除演唱会失败");
            request.getRequestDispatcher("/admin/concert_list.jsp").forward(request, response);
        } finally {
            DBUtil.closeAll(conn, pstmt, null);
        }
    }
    
    private void listConcerts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Concert> concerts = new ArrayList<>();
        
        try {
            conn = DBUtil.getConnection();
            
           
            String countSql = "SELECT COUNT(*) as total FROM concerts";
            pstmt = conn.prepareStatement(countSql);
            rs = pstmt.executeQuery();
            int total = 0;
            if (rs.next()) {
                total = rs.getInt("total");
            }
            
           
            int pageSize = 6;  
            int totalPages = (int) Math.ceil((double) total / pageSize);
            String pageStr = request.getParameter("page");
            int currentPage = (pageStr != null && !pageStr.trim().isEmpty()) ? 
                             Integer.parseInt(pageStr) : 1;
            
         
            if (currentPage < 1) currentPage = 1;
            if (currentPage > totalPages) currentPage = totalPages > 0 ? totalPages : 1;
            
       
            String sql = "SELECT * FROM concerts ORDER BY date ASC LIMIT ? OFFSET ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, pageSize);
            pstmt.setInt(2, (currentPage - 1) * pageSize);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Concert concert = new Concert();
                concert.setId(rs.getInt("id"));
                concert.setName(rs.getString("name"));
                concert.setDate(rs.getDate("date"));
                concert.setLocation(rs.getString("location"));
                concert.setTicketPrice(rs.getBigDecimal("ticketPrice"));
                concert.setImage(rs.getString("image"));
                concert.setRemainingTickets(rs.getInt("remainingTickets"));
                concert.setCreateTime(rs.getTimestamp("create_time"));
                concerts.add(concert);
            }
            
            
            request.setAttribute("concerts", concerts);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("total", total);
            
            request.getRequestDispatcher("/concert_list.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "获取演唱会列表失败");
            request.getRequestDispatcher("/concert_list.jsp").forward(request, response);
        } finally {
            DBUtil.closeAll(conn, pstmt, rs);
        }
    }
} 
