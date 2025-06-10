package com.example.servlet;

import com.example.model.User;
import com.example.util.DBUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/user")
public class UserServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("login".equals(action)) {
            login(request, response);
        } else if ("register".equals(action)) {
            register(request, response);
        } else if ("logout".equals(action)) {
            logout(request, response);
        } else if ("edit".equals(action)) {
            editUser(request, response);
        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("user", username);
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("role", rs.getInt("role"));
                
                response.sendRedirect(request.getContextPath() + "/concert?action=list");
            } else {
                request.setAttribute("error", "用户名或密码错误");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "登录失败");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            DBUtil.closeAll(conn, pstmt, rs);
        }
    }
    
    private void register(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "INSERT INTO users (username, password, email, phoneNumber, role) VALUES (?, ?, ?, ?, 0)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            pstmt.setString(3, email);
            pstmt.setString(4, phoneNumber);
            
            pstmt.executeUpdate();
            response.sendRedirect("login.jsp");
        } catch (SQLException e) {
            if (e.getMessage().contains("idx_username_unique")) {
                request.setAttribute("error", "用户名已存在");
            } else {
                request.setAttribute("error", "注册失败");
            }
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } finally {
            DBUtil.closeAll(conn, pstmt, null);
        }
    }
    
    private void logout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("login.jsp");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("manage".equals(action)) {
            manageUsers(request, response);
        } else if ("edit".equals(action)) {
            editUser(request, response);
        } else if ("delete".equals(action)) {
            deleteUser(request, response);
        } else {
            doPost(request, response);
        }
    }
    
    private void manageUsers(HttpServletRequest request, HttpServletResponse response) 
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
        List<User> users = new ArrayList<>();
        
        try {
            conn = DBUtil.getConnection();
            String sql = "SELECT * FROM users ORDER BY create_time DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setPhoneNumber(rs.getString("phoneNumber"));
                user.setRole(rs.getInt("role"));
                user.setCreateTime(rs.getTimestamp("create_time"));
                users.add(user);
            }
            
            request.setAttribute("users", users);
            request.getRequestDispatcher("/admin/user_manage.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "获取用户列表失败");
            request.getRequestDispatcher("/admin/user_manage.jsp").forward(request, response);
        } finally {
            DBUtil.closeAll(conn, pstmt, rs);
        }
    }
    
    private void editUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer role = (Integer) session.getAttribute("role");
        if (role == null || role != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

       
        if ("GET".equalsIgnoreCase(request.getMethod())) {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/user?action=manage");
                return;
            }

            int id = Integer.parseInt(idStr);
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = DBUtil.getConnection();
                String sql = "SELECT * FROM users WHERE id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, id);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPhoneNumber(rs.getString("phoneNumber"));
                    user.setRole(rs.getInt("role"));
                    user.setCreateTime(rs.getTimestamp("create_time"));
                    
                    request.setAttribute("user", user);
                    request.getRequestDispatcher("/admin/user_edit.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/user?action=manage");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/user?action=manage");
            } finally {
                DBUtil.closeAll(conn, pstmt, rs);
            }
            return;
        }

        
        String idStr = request.getParameter("id");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String roleStr = request.getParameter("role");

        if (idStr == null || idStr.trim().isEmpty() || 
            username == null || username.trim().isEmpty() ||
            roleStr == null || roleStr.trim().isEmpty()) {
            request.setAttribute("error", "请填写必要的信息");
            request.getRequestDispatcher("/admin/user_edit.jsp").forward(request, response);
            return;
        }

        int id = Integer.parseInt(idStr);
        int userRole = Integer.parseInt(roleStr);
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            String sql = "UPDATE users SET username=?, email=?, phoneNumber=?, role=? WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, email);
            pstmt.setString(3, phoneNumber);
            pstmt.setInt(4, userRole);
            pstmt.setInt(5, id);
            
            pstmt.executeUpdate();
            response.sendRedirect(request.getContextPath() + "/user?action=manage");
        } catch (SQLException e) {
            e.printStackTrace();
            
            try {
                String sql = "SELECT * FROM users WHERE id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, id);
                ResultSet rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    user.setPhoneNumber(rs.getString("phoneNumber"));
                    user.setRole(rs.getInt("role"));
                    user.setCreateTime(rs.getTimestamp("create_time"));
                    
                    request.setAttribute("user", user);
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            
            request.setAttribute("error", "更新用户失败");
            request.getRequestDispatcher("/admin/user_edit.jsp").forward(request, response);
        } finally {
            DBUtil.closeAll(conn, pstmt, null);
        }
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer role = (Integer) session.getAttribute("role");
        if (role == null || role != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false);  
            
            
            String checkSql = "SELECT role FROM users WHERE id = ?";
            pstmt = conn.prepareStatement(checkSql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            
            if (rs.next() && rs.getInt("role") == 1) {
                request.setAttribute("error", "不能删除管理员账号");
                response.sendRedirect(request.getContextPath() + "/user?action=manage");
                return;
            }
            
            
            String deleteOrdersSql = "DELETE FROM orders WHERE userId = ?";
            pstmt = conn.prepareStatement(deleteOrdersSql);
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            
            
            String deleteUserSql = "DELETE FROM users WHERE id = ?";
            pstmt = conn.prepareStatement(deleteUserSql);
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            
            conn.commit();  
            response.sendRedirect(request.getContextPath() + "/user?action=manage");
        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback(); 
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            request.setAttribute("error", "删除用户失败");
            response.sendRedirect(request.getContextPath() + "/user?action=manage");
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);  
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
            DBUtil.closeAll(conn, pstmt, rs);
        }
    }
} 
