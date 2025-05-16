<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="用户管理">
    <jsp:attribute name="styles">
        <style>
            .user-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            .user-table th, .user-table td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }
            .user-table th {
                background-color: #f5f5f5;
                font-weight: bold;
            }
            .user-table tr:hover {
                background-color: #f9f9f9;
            }
            .role-admin {
                color: #e44d26;
                font-weight: bold;
            }
            .role-user {
                color: #4CAF50;
            }
            .btn-action {
                padding: 5px 10px;
                border: none;
                border-radius: 3px;
                cursor: pointer;
                margin-right: 5px;
            }
            .btn-edit {
                background: #4CAF50;
                color: white;
            }
            .btn-delete {
                background: #f44336;
                color: white;
            }
        </style>
    </jsp:attribute>

    <jsp:body>
        <h1 class="page-title">用户管理</h1>
        
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        
        <table class="user-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>用户名</th>
                    <th>邮箱</th>
                    <th>电话</th>
                    <th>角色</th>
                    <th>注册时间</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${users}" var="user">
                    <tr>
                        <td>${user.id}</td>
                        <td>${user.username}</td>
                        <td>${user.email}</td>
                        <td>${user.phoneNumber}</td>
                        <td>
                            <span class="${user.role == 1 ? 'role-admin' : 'role-user'}">
                                ${user.role == 1 ? '管理员' : '普通用户'}
                            </span>
                        </td>
                        <td>
                            <fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/user?action=edit&id=${user.id}" 
                               class="btn-action btn-edit">编辑</a>
                            <c:if test="${user.role != 1}">
                                <a href="javascript:void(0)" 
                                   onclick="deleteUser(${user.id})" 
                                   class="btn-action btn-delete">删除</a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <script>
            function deleteUser(userId) {
                if (confirm('确定要删除这个用户吗？')) {
                    window.location.href = '${pageContext.request.contextPath}/user?action=delete&id=' + userId;
                }
            }
        </script>
    </jsp:body>
</t:layout> 
