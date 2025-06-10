package com.example.servlet;

import com.example.model.Concert;
import com.example.model.Order;
import com.example.util.DBUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {
    
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
            listOrders(request, response);
        } else if ("create".equals(action)) {
            createOrder(request, response);
        } else if ("cancel".equals(action)) {
            cancelOrder(request, response);
        } else if ("pay".equals(action)) {
            payOrder(request, response);
        } else if ("manage".equals(action)) {
            manageOrders(request, response);
        }
    }
    
    private void listOrders(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        Integer role = (Integer) session.getAttribute("role");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Order> orders = new ArrayList<>();
        
        try {
            conn = DBUtil.getConnection();
            String sql;
            if (role != null && role == 1) {
                
                sql = "SELECT o.*, c.name, c.date, c.location, c.ticketPrice, u.username " +
                      "FROM orders o " +
                      "JOIN concerts c ON o.concertId = c.id " +
                      "JOIN users u ON o.userId = u.id " +
                      "ORDER BY o.create_time DESC";
                pstmt = conn.prepareStatement(sql);
            } else {
               
                sql = "SELECT o.*, c.name, c.date, c.location, c.ticketPrice " +
                      "FROM orders o " +
                      "JOIN concerts c ON o.concertId = c.id " +
                      "WHERE o.userId = ? " +
                      "ORDER BY o.create_time DESC";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, userId);
            }
            
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("userId"));
                order.setConcertId(rs.getInt("concertId"));
                order.setQuantity(rs.getInt("quantity"));
                order.setTotalPrice(rs.getBigDecimal("totalPrice"));
                order.setStatus(rs.getInt("status"));
                order.setCreateTime(rs.getTimestamp("create_time"));
                
                Concert concert = new Concert();
                concert.setName(rs.getString("name"));
                concert.setDate(rs.getDate("date"));
                concert.setLocation(rs.getString("location"));
                concert.setTicketPrice(rs.getBigDecimal("ticketPrice"));
                order.setConcert(concert);
                
                if (role != null && role == 1) {
                    order.setUsername(rs.getString("username"));
                }
                
                orders.add(order);
            }
            
            request.setAttribute("orders", orders);
            String viewPath = (role != null && role == 1) ? "/admin/order_manage.jsp" : "/order_list.jsp";
            request.getRequestDispatcher(viewPath).forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "获取订单列表失败");
            request.getRequestDispatcher("/order_list.jsp").forward(request, response);
        } finally {
            DBUtil.closeAll(conn, pstmt, rs);
        }
    }
    
    private void createOrder(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
       
        String concertIdStr = request.getParameter("concertId");
        if (concertIdStr == null || concertIdStr.trim().isEmpty()) {
            request.setAttribute("error", "无效的演唱会ID");
            request.getRequestDispatcher("/concert?action=list").forward(request, response);
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        int concertId = Integer.parseInt(concertIdStr);
        
        
        if ("GET".equalsIgnoreCase(request.getMethod())) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = DBUtil.getConnection();
                String sql = "SELECT * FROM concerts WHERE id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, concertId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    Concert concert = new Concert();
                    concert.setId(rs.getInt("id"));
                    concert.setName(rs.getString("name"));
                    concert.setDate(rs.getDate("date"));
                    concert.setLocation(rs.getString("location"));
                    concert.setTicketPrice(rs.getBigDecimal("ticketPrice"));
                    concert.setRemainingTickets(rs.getInt("remainingTickets"));
                    
                    request.setAttribute("concert", concert);
                    request.getRequestDispatcher("/order_confirm.jsp").forward(request, response);
                } else {
                    request.setAttribute("error", "演唱会不存在");
                    request.getRequestDispatcher("/concert?action=list").forward(request, response);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "系统错误");
                request.getRequestDispatcher("/concert?action=list").forward(request, response);
            } finally {
                DBUtil.closeAll(conn, pstmt, rs);
            }
            return;
        }
        
        
        String quantityStr = request.getParameter("quantity");
        if (quantityStr == null || quantityStr.trim().isEmpty()) {
            request.setAttribute("error", "请选择购票数量");
            request.getRequestDispatcher("/order_confirm.jsp").forward(request, response);
            return;
        }
        
        int quantity = Integer.parseInt(quantityStr);
        if (quantity <= 0) {
            request.setAttribute("error", "购票数量必须大于0");
            request.getRequestDispatcher("/order_confirm.jsp").forward(request, response);
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            
            String checkSql = "SELECT ticketPrice, remainingTickets FROM concerts WHERE id = ? FOR UPDATE";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, concertId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                int remainingTickets = rs.getInt("remainingTickets");
                BigDecimal ticketPrice = rs.getBigDecimal("ticketPrice");
                
                if (remainingTickets >= quantity) {
                    
                    String insertSql = "INSERT INTO orders (userId, concertId, quantity, totalPrice, status, create_time) " +
                                      "VALUES (?, ?, ?, ?, 1, NOW())";
                    pstmt = conn.prepareStatement(insertSql);
                    pstmt.setInt(1, userId);
                    pstmt.setInt(2, concertId);
                    pstmt.setInt(3, quantity);
                    pstmt.setBigDecimal(4, ticketPrice.multiply(new BigDecimal(quantity)));
                    pstmt.executeUpdate();
                    
                    
                    String updateSql = "UPDATE concerts SET remainingTickets = remainingTickets - ? WHERE id = ?";
                    pstmt = conn.prepareStatement(updateSql);
                    pstmt.setInt(1, quantity);
                    pstmt.setInt(2, concertId);
                    pstmt.executeUpdate();
                    
                    conn.commit();
                    response.sendRedirect(request.getContextPath() + "/order?action=list");
                } else {
                    conn.rollback();
                    request.setAttribute("error", "票数不足");
                    request.getRequestDispatcher("/concert?action=list").forward(request, response);
                }
            }
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            request.setAttribute("error", "创建订单失败");
            request.getRequestDispatcher("/concert?action=list").forward(request, response);
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            DBUtil.closeAll(conn, pstmt, rs);
        }
    }
    
    private void cancelOrder(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        int orderId = Integer.parseInt(request.getParameter("id"));
        Integer userId = (Integer) session.getAttribute("userId");
        Integer role = (Integer) session.getAttribute("role");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);
            
            
            String checkSql = "SELECT o.status, o.quantity, o.concertId, o.userId FROM orders o WHERE o.id = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, orderId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                int status = rs.getInt("status");
                int quantity = rs.getInt("quantity");
                int concertId = rs.getInt("concertId");
                int orderUserId = rs.getInt("userId");
                
                
                if ((orderUserId == userId || (role != null && role == 1)) && status == 1) {
                    // 更新订单状态
                    String updateOrderSql = "UPDATE orders SET status = 3 WHERE id = ?";
                    pstmt = conn.prepareStatement(updateOrderSql);
                    pstmt.setInt(1, orderId);
                    pstmt.executeUpdate();
                    
                    
                    String updateConcertSql = "UPDATE concerts SET remainingTickets = remainingTickets + ? WHERE id = ?";
                    pstmt = conn.prepareStatement(updateConcertSql);
                    pstmt.setInt(1, quantity);
                    pstmt.setInt(2, concertId);
                    pstmt.executeUpdate();
                    
                    conn.commit();
                    response.sendRedirect(request.getContextPath() + "/order?action=list");
                } else {
                    conn.rollback();
                    request.setAttribute("error", "无法取消该订单");
                    request.getRequestDispatcher("/order?action=list").forward(request, response);
                }
            }
        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            request.setAttribute("error", "取消订单失败");
            request.getRequestDispatcher("/order?action=list").forward(request, response);
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            DBUtil.closeAll(conn, pstmt, rs);
        }
    }
    
    private void payOrder(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        int orderId = Integer.parseInt(request.getParameter("id"));
        Integer userId = (Integer) session.getAttribute("userId");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            
           
            String checkSql = "SELECT status, userId FROM orders WHERE id = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, orderId);
            rs = pstmt.executeQuery();
            
            if (rs.next() && rs.getInt("userId") == userId && rs.getInt("status") == 1) {
                String updateSql = "UPDATE orders SET status = 2 WHERE id = ?";
                pstmt = conn.prepareStatement(updateSql);
                pstmt.setInt(1, orderId);
                pstmt.executeUpdate();
                
                response.sendRedirect(request.getContextPath() + "/order?action=list");
            } else {
                request.setAttribute("error", "无法支付该订单");
                request.getRequestDispatcher("/order?action=list").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "支付订单失败");
            request.getRequestDispatcher("/order?action=list").forward(request, response);
        } finally {
            DBUtil.closeAll(conn, pstmt, rs);
        }
    }
    
    private void manageOrders(HttpServletRequest request, HttpServletResponse response) 
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
        List<Order> orders = new ArrayList<>();
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT o.*, c.name as concertName, u.username " +
                        "FROM orders o " +
                        "JOIN concerts c ON o.concertId = c.id " +
                        "JOIN users u ON o.userId = u.id " +
                        "ORDER BY o.create_time DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("userId"));
                order.setConcertId(rs.getInt("concertId"));
                order.setQuantity(rs.getInt("quantity"));
                order.setTotalPrice(rs.getBigDecimal("totalPrice"));
                order.setStatus(rs.getInt("status"));
                order.setCreateTime(rs.getTimestamp("create_time"));
                order.setUsername(rs.getString("username"));
                
                Concert concert = new Concert();
                concert.setName(rs.getString("concertName"));
                order.setConcert(concert);
                
                orders.add(order);
            }
            
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/admin/order_manage.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "获取订单列表失败");
            request.getRequestDispatcher("/admin/order_manage.jsp").forward(request, response);
        } finally {
            DBUtil.closeAll(conn, pstmt, rs);
        }
    }
} 
