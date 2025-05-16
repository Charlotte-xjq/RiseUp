<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="编辑用户">
    <jsp:attribute name="styles">
        <style>
            .form-container {
                max-width: 600px;
                margin: 0 auto;
                padding: 20px;
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .form-group {
                margin-bottom: 20px;
            }
            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 500;
                color: #495057;
            }
            .form-group input,
            .form-group select {
                width: 100%;
                padding: 10px;
                border: 1px solid #ced4da;
                border-radius: 4px;
                font-size: 14px;
            }
            .form-group input:focus,
            .form-group select:focus {
                border-color: #80bdff;
                outline: 0;
                box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
            }
            .btn-submit {
                background: #4CAF50;
                color: white;
                padding: 12px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                width: 100%;
                font-size: 16px;
                font-weight: 500;
                transition: background-color 0.2s;
            }
            .btn-submit:hover {
                background: #45a049;
            }
            .page-header {
                margin-bottom: 30px;
                text-align: center;
            }
            .page-title {
                font-size: 24px;
                color: #333;
                margin: 0;
            }
            .error-message {
                padding: 12px;
                margin-bottom: 20px;
                border: 1px solid #f5c6cb;
                border-radius: 4px;
                color: #721c24;
                background-color: #f8d7da;
            }
        </style>
    </jsp:attribute>

    <jsp:body>
        <div class="form-container">
            <div class="page-header">
                <h1 class="page-title">编辑用户</h1>
            </div>
            
            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/user?action=edit" method="post">
                <input type="hidden" name="id" value="${user.id}">
                
                <div class="form-group">
                    <label for="username">用户名</label>
                    <input type="text" id="username" name="username" value="${user.username}" required>
                </div>
                
                <div class="form-group">
                    <label for="email">邮箱</label>
                    <input type="email" id="email" name="email" value="${user.email}">
                </div>
                
                <div class="form-group">
                    <label for="phoneNumber">电话</label>
                    <input type="tel" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}">
                </div>
                
                <div class="form-group">
                    <label for="role">角色</label>
                    <select id="role" name="role" class="form-control">
                        <option value="0" ${user.role == 0 ? 'selected' : ''}>普通用户</option>
                        <option value="1" ${user.role == 1 ? 'selected' : ''}>管理员</option>
                    </select>
                </div>
                
                <button type="submit" class="btn-submit">
                    <i class="fas fa-save"></i> 保存修改
                </button>
            </form>
        </div>
    </jsp:body>
</t:layout> 
