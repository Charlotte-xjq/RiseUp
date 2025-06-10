package com.example.filter;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class LoginFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession();
        
        String path = req.getRequestURI();
        
      
        if (path.endsWith("login.jsp") || path.endsWith("register.jsp") 
                || path.contains("/css/") || path.contains("/js/") 
                || path.contains("/images/") || path.endsWith("/user")) {
            chain.doFilter(request, response);
            return;
        }
        
        if (session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        
       
        if (path.startsWith(req.getContextPath() + "/admin/")) {
            Integer role = (Integer) session.getAttribute("role");
            if (role == null || role != 1) {
                resp.sendRedirect(req.getContextPath() + "/concert?action=list");
                return;
            }
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void destroy() {}
} 
