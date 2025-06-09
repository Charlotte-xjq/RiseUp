<%@ tag description="Overall Page template" pageEncoding="UTF-8" %>
<%@ attribute name="title" required="true" %>
<%@ attribute name="styles" fragment="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>${title} - 演唱会票务系统</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        /* 全局样式 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-color: #f4f4f4;
        }

        /* 顶部导航栏 */
        .header {
            background: #333;
            padding: 15px 0;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }

        .nav-brand {
            color: white;
            font-size: 20px;
            text-decoration: none;
            font-weight: bold;
        }

        .nav-links {
            display: flex;
            gap: 20px;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 4px;
            transition: background-color 0.3s;
        }

        .nav-links a:hover {
            background-color: #4CAF50;
        }

        .nav-user {
            color: white;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .nav-user span {
            color: #4CAF50;
            font-weight: bold;
        }
        
        .nav-user a {
            color: white;
            text-decoration: none;
            padding: 5px 10px;
            border-radius: 4px;
            transition: all 0.3s;
        }
        
        .nav-user a:hover {
            background: #4CAF50;
        }
        
        .btn-logout {
            background: #f44336;
            color: white;
            padding: 5px 12px;
            border-radius: 4px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s;
        }
        
        .btn-logout:hover {
            background: #d32f2f;
        }

        /* 主要内容区域 */
        .main-content {
            flex: 1;
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            min-height: calc(100vh - 200px);
        }
        
        /* 底部导航栏 */
        .footer {
            background: #333;
            color: white;
            padding: 20px 0;
            margin-top: auto;
            width: 100%;
        }
        
        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            text-align: center;
            padding: 0 20px;
        }
        
        .footer-nav {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 15px;
        }
        
        .footer-nav a {
            color: white;
            text-decoration: none;
            transition: color 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .footer-nav a:hover {
            color: #4CAF50;
        }

        .copyright {
            font-size: 14px;
            color: #999;
        }
    </style>
    <jsp:invoke fragment="styles"/>
</head>
<body>
    <header class="header">
        <div class="nav-container">
            <a href="${pageContext.request.contextPath}/concert?action=list" class="nav-brand">
                演唱会票务系统
            </a>
            <nav class="nav-links">
                <a href="${pageContext.request.contextPath}/concert?action=list">首页</a>
                <c:if test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/order?action=list">我的订单</a>
                </c:if>
                <c:if test="${sessionScope.role == 1}">
                    <a href="${pageContext.request.contextPath}/concert?action=manage">演唱会管理</a>
                    <a href="${pageContext.request.contextPath}/user?action=manage">用户管理</a>
                </c:if>
            </nav>
            <div class="nav-user">
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/login.jsp">
                            <i class="fas fa-sign-in-alt"></i> 登录
                        </a>
                        <a href="${pageContext.request.contextPath}/register.jsp">
                            <i class="fas fa-user-plus"></i> 注册
                        </a>
                    </c:when>
                    <c:otherwise>
                        <span><i class="fas fa-user"></i> ${sessionScope.user}</span>
                        <a href="${pageContext.request.contextPath}/user?action=logout" class="btn-logout">
                            <i class="fas fa-sign-out-alt"></i> 退出
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>

    <div class="main-content">
        <jsp:doBody/>
    </div>
    
    <footer class="footer">
        <div class="footer-content">
            <div class="copyright">
                &copy; 2025 演唱会票务系统 版权所有
            </div>
        </div>
    </footer>
</body>
</html> 
