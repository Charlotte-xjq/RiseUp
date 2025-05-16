<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>我的订单 - 演唱会票务系统</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }
        .order-list {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .order-item {
            padding: 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
        }
        .order-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 4px;
            margin-right: 20px;
        }
        .order-info {
            flex: 1;
        }
        .order-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .order-details {
            color: #666;
            margin-bottom: 5px;
        }
        .order-status {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 14px;
            margin-left: 10px;
        }
        .status-1 { background: #e3f2fd; color: #1976d2; }
        .status-2 { background: #e8f5e9; color: #388e3c; }
        .status-3 { background: #ffebee; color: #d32f2f; }
        .btn-cancel {
            background: #f44336;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-cancel:hover {
            background: #d32f2f;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/include/header.jsp"/>
    
    <div class="container">
        <h2>我的订单</h2>
        
        <div class="order-list">
            <c:forEach items="${orders}" var="order">
                <div class="order-item">
                    <img src="${pageContext.request.contextPath}/uploads/${order.concert.image}" 
                         alt="${order.concert.name}" class="order-image">
                    <div class="order-info">
                        <div class="order-title">
                            ${order.concert.name}
                            <span class="order-status status-${order.status}">
                                ${order.status == 1 ? '已预订' : order.status == 2 ? '已支付' : '已取消'}
                            </span>
                        </div>
                        <div class="order-details">演出时间: ${order.concert.date}</div>
                        <div class="order-details">演出地点: ${order.concert.location}</div>
                        <div class="order-details">购买数量: ${order.quantity}张</div>
                        <div class="order-details">订单金额: ¥${order.totalPrice}</div>
                        <div class="order-details">下单时间: ${order.orderTime}</div>
                        
                        <c:if test="${order.status == 1}">
                            <button class="btn-cancel" onclick="if(confirm('确定要取消订单吗？')) location.href='${pageContext.request.contextPath}/order?action=cancel&id=${order.id}'">
                                取消订单
                            </button>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html> 
