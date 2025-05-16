<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="演唱会管理">
    <jsp:attribute name="styles">
        <style>
            .manage-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            
            .btn-add {
                background: #4CAF50;
                color: white;
                padding: 10px 20px;
                border-radius: 4px;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                transition: background-color 0.3s;
            }
            
            .btn-add:hover {
                background: #45a049;
            }
            
            .concert-table {
                width: 100%;
                border-collapse: collapse;
                background: white;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            
            .concert-table th,
            .concert-table td {
                padding: 12px 15px;
                text-align: left;
                border-bottom: 1px solid #eee;
            }
            
            .concert-table th {
                background: #f8f9fa;
                font-weight: 600;
                color: #333;
            }
            
            .concert-table tr:hover {
                background: #f5f5f5;
            }
            
            .action-buttons {
                display: flex;
                gap: 10px;
            }
            
            .btn-edit,
            .btn-delete {
                padding: 6px 12px;
                border-radius: 4px;
                text-decoration: none;
                color: white;
                display: inline-flex;
                align-items: center;
                gap: 5px;
                font-size: 14px;
                transition: all 0.3s;
            }
            
            .btn-edit {
                background: #2196F3;
            }
            
            .btn-edit:hover {
                background: #1976D2;
            }
            
            .btn-delete {
                background: #f44336;
            }
            
            .btn-delete:hover {
                background: #d32f2f;
            }
            
            .concert-image {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 4px;
            }
            
            .price {
                color: #e83e8c;
                font-weight: bold;
            }
            
            .tickets {
                color: #28a745;
            }
        </style>
    </jsp:attribute>

    <jsp:body>
        <div class="manage-header">
            <h1>演唱会管理</h1>
            <a href="${pageContext.request.contextPath}/admin/concert_add.jsp" class="btn-add">
                <i class="fas fa-plus"></i> 添加演唱会
            </a>
        </div>

        <table class="concert-table">
            <thead>
                <tr>
                    <th>图片</th>
                    <th>名称</th>
                    <th>日期</th>
                    <th>地点</th>
                    <th>票价</th>
                    <th>剩余票数</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${concerts}" var="concert">
                    <tr>
                        <td>
                            <img src="${pageContext.request.contextPath}/uploads/${concert.image}" 
                                 alt="${concert.name}" 
                                 class="concert-image">
                        </td>
                        <td>${concert.name}</td>
                        <td><fmt:formatDate value="${concert.date}" pattern="yyyy-MM-dd"/></td>
                        <td>${concert.location}</td>
                        <td class="price">￥${concert.ticketPrice}</td>
                        <td class="tickets">${concert.remainingTickets}</td>
                        <td>
                            <div class="action-buttons">
                                <a href="${pageContext.request.contextPath}/concert?action=edit&id=${concert.id}" 
                                   class="btn-edit">
                                    <i class="fas fa-edit"></i> 编辑
                                </a>
                                <a href="javascript:void(0)" 
                                   onclick="if(confirm('确定要删除这场演唱会吗？')) 
                                   window.location.href='${pageContext.request.contextPath}/concert?action=delete&id=${concert.id}'" 
                                   class="btn-delete">
                                    <i class="fas fa-trash-alt"></i> 删除
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </jsp:body>
</t:layout> 
