<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="header">
    <div class="nav">
        <div class="logo">演唱会票务系统</div>
        <ul class="menu">
            <li><a href="${pageContext.request.contextPath}/concert?action=list">演唱会列表</a></li>
            <% if(session.getAttribute("user") != null) { %>
                <li><a href="${pageContext.request.contextPath}/order?action=list">我的订单</a></li>
                <% if(session.getAttribute("role") != null && (Integer)session.getAttribute("role") == 1) { %>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle">系统管理</a>
                        <ul class="dropdown-menu">
                            <li><a href="${pageContext.request.contextPath}/concert?action=manage">演唱会管理</a></li>
                            <li><a href="${pageContext.request.contextPath}/order?action=manage">订单管理</a></li>
                            <li><a href="${pageContext.request.contextPath}/user?action=manage">用户管理</a></li>
                        </ul>
                    </li>
                <% } %>
                <li class="welcome-text">欢迎, <%= session.getAttribute("user") %></li>
                <li><a href="${pageContext.request.contextPath}/user?action=logout">退出</a></li>
            <% } else { %>
                <li><a href="${pageContext.request.contextPath}/login.jsp">登录</a></li>
                <li><a href="${pageContext.request.contextPath}/register.jsp">注册</a></li>
            <% } %>
        </ul>
    </div>
</div>

<style>
.header {
    background: #333;
    padding: 15px 0;
}
.nav {
    max-width: 1200px;
    margin: 0 auto;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 20px;
}
.logo {
    color: white;
    font-size: 24px;
    font-weight: bold;
}
.menu {
    list-style: none;
    display: flex;
    margin: 0;
    padding: 0;
    align-items: center;
}
.menu li {
    margin-left: 20px;
    position: relative;
}
.menu a {
    color: white;
    text-decoration: none;
    padding: 8px 12px;
    border-radius: 4px;
    transition: background-color 0.3s;
}
.menu a:hover {
    background: #444;
}

/* 下拉菜单样式 */
.dropdown-menu {
    display: none;
    position: absolute;
    top: 100%;
    left: 0;
    background: #333;
    list-style: none;
    padding: 8px 0;
    margin: 0;
    min-width: 150px;
    border-radius: 4px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.2);
    z-index: 1000;
}
.dropdown-menu li {
    margin: 0;
}
.dropdown-menu a {
    display: block;
    padding: 8px 16px;
    color: white;
    text-decoration: none;
}
.dropdown-menu a:hover {
    background: #444;
}
.dropdown:hover .dropdown-menu {
    display: block;
}

.welcome-text {
    color: #4CAF50;
    font-weight: bold;
    padding: 8px 12px;
}
</style> 
