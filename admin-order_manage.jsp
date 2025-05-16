<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="订单管理">
    <jsp:attribute name="styles">
        <style>
            .page-header {
                margin-bottom: 30px;
                padding-bottom: 15px;
                border-bottom: 1px solid #eee;
            }
            .page-title {
                font-size: 24px;
                margin: 0;
                color: #333;
            }
            .order-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
                background: white;
                box-shadow: 0 1px 3px rgba(0,0,0,0.1);
                border-radius: 4px;
            }
            .order-table th, .order-table td {
                padding: 15px;
                text-align: left;
                border-bottom: 1px solid #eee;
            }
            .order-table th {
                background-color: #f8f9fa;
                font-weight: 600;
                color: #495057;
            }
            .order-table tr:hover {
                background-color: #f8f9fa;
            }
            .order-table tr:last-child td {
                border-bottom: none;
            }
            .status-badge {
                padding: 5px 10px;
                border-radius: 15px;
                font-size: 12px;
                font-weight: 500;
            }
            .status-1 { 
                background-color: #fff3cd;
                color: #856404;
            }
            .status-2 { 
                background-color: #d4edda;
                color: #155724;
            }
            .status-3 { 
                background-color: #f8d7da;
                color: #721c24;
            }
            .price {
                font-family: Monaco, monospace;
                color: #e83e8c;
                font-weight: 600;
            }
            .btn-action {
                padding: 6px 12px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                transition: all 0.2s;
            }
            .btn-cancel {
                background-color: #dc3545;
                color: white;
            }
            .btn-cancel:hover {
                background-color: #c82333;
            }
            .error-message {
                padding: 15px;
                margin-bottom: 20px;
                border: 1px solid #f5c6cb;
                border-radius: 4px;
                color: #721c24;
                background-color: #f8d7da;
            }
            .username {
                font-weight: 500;
                color: #007bff;
            }
            .concert-name {
                color: #495057;
                font-weight: 500;
            }
            .timestamp {
                color: #6c757d;
                font-size: 13px;
            }
        </style>
    </jsp:attribute>

    <jsp:body>
        <div class="page-header">
            <h1 class="page-title">订单管理</h1>
        </div>
        
        <c:if test="${not empty error}">
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i> ${error}
            </div>
        </c:if>
        
        <table class="order-table">
            <thead>
                <tr>
                    <th>订单号</th>
                    <th>用户</th>
                    <th>演唱会</th>
                    <th>数量</th>
                    <th>总价</th>
                    <th>状态</th>
                    <th>下单时间</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${orders}" var="order">
                    <tr>
                        <td>#${order.id}</td>
                        <td class="username">${order.username}</td>
                        <td class="concert-name">${order.concert.name}</td>
                        <td>${order.quantity}张</td>
                        <td class="price">￥${order.totalPrice}</td>
                        <td>
                            <span class="status-badge status-${order.status}">
                                <c:choose>
                                    <c:when test="${order.status == 1}">待支付</c:when>
                                    <c:when test="${order.status == 2}">已支付</c:when>
                                    <c:when test="${order.status == 3}">已取消</c:when>
                                </c:choose>
                            </span>
                        </td>
                        <td class="timestamp">
                            <fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                        </td>
                        <td>
                            <c:if test="${order.status == 1}">
                                <button onclick="cancelOrder(${order.id})" 
                                        class="btn-action btn-cancel">
                                    <i class="fas fa-times"></i> 取消订单
                                </button>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <script>
            function cancelOrder(orderId) {
                if (confirm('确定要取消这个订单吗？')) {
                    window.location.href = '${pageContext.request.contextPath}/order?action=cancel&id=' + orderId;
                }
            }
        </script>
    </jsp:body>
</t:layout> 
