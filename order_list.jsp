<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="我的订单">
    <jsp:attribute name="styles">
        <style>
            .order-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            .order-table th, .order-table td {
                padding: 12px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }
            .order-table th {
                background-color: #f5f5f5;
                font-weight: bold;
            }
            .order-table tr:hover {
                background-color: #f9f9f9;
            }
            .status-1 { color: #ff9800; }  /* 待支付 */
            .status-2 { color: #4CAF50; }  /* 已支付 */
            .status-3 { color: #f44336; }  /* 已取消 */
            .btn-action {
                padding: 5px 10px;
                border: none;
                border-radius: 3px;
                cursor: pointer;
                margin-right: 5px;
                color: white;
            }
            .btn-pay {
                background: #4CAF50;
            }
            .btn-cancel {
                background: #f44336;
            }
        </style>
    </jsp:attribute>

    <jsp:body>
        <h1 class="page-title">我的订单</h1>
        
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        
        <table class="order-table">
            <thead>
                <tr>
                    <th>订单号</th>
                    <th>演唱会</th>
                    <th>演出时间</th>
                    <th>演出地点</th>
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
                        <td>${order.id}</td>
                        <td>${order.concert.name}</td>
                        <td><fmt:formatDate value="${order.concert.date}" pattern="yyyy-MM-dd"/></td>
                        <td>${order.concert.location}</td>
                        <td>${order.quantity}</td>
                        <td>￥${order.totalPrice}</td>
                        <td>
                            <span class="status-${order.status}">
                                <c:choose>
                                    <c:when test="${order.status == 1}">待支付</c:when>
                                    <c:when test="${order.status == 2}">已支付</c:when>
                                    <c:when test="${order.status == 3}">已取消</c:when>
                                </c:choose>
                            </span>
                        </td>
                        <td><fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>
                            <c:if test="${order.status == 1}">
                                <a href="${pageContext.request.contextPath}/order?action=pay&id=${order.id}" 
                                   class="btn-action btn-pay">支付</a>
                                <a href="javascript:void(0)" 
                                   onclick="cancelOrder(${order.id})"
                                   class="btn-action btn-cancel">取消</a>
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
