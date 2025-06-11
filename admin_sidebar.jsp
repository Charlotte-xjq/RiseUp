<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="sidebar">
    <h2>管理后台</h2>
    <div class="menu-item">
        <a href="${pageContext.request.contextPath}/admin/index.jsp">首页</a>
    </div>
    <div class="menu-item">
        <a href="${pageContext.request.contextPath}/concert?action=page">演唱会管理</a>
    </div>
    <div class="menu-item">
        <a href="${pageContext.request.contextPath}/admin/concert_add.jsp">添加演唱会</a>
    </div>
    <div class="menu-item">
        <a href="${pageContext.request.contextPath}/order?action=list">订单管理</a>
    </div>
    <div class="menu-item">
        <a href="${pageContext.request.contextPath}/admin/user_manage.jsp">用户管理</a>
    </div>
    <div class="menu-item">
        <a href="${pageContext.request.contextPath}/user?action=logout">退出登录</a>
    </div>
</div>

<style>
.sidebar {
    width: 250px;
    background: #333;
    color: white;
    padding: 20px;
    min-height: 100vh;
}
.menu-item {
    padding: 10px;
    margin: 5px 0;
    border-radius: 4px;
    cursor: pointer;
}
.menu-item:hover {
    background: #444;
}
.menu-item a {
    color: white;
    text-decoration: none;
    display: block;
}
</style> 
