<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="确认订单">
    <jsp:attribute name="styles">
        <style>
            .order-confirm {
                max-width: 600px;
                margin: 30px auto;
                padding: 20px;
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .concert-info {
                margin-bottom: 20px;
                padding-bottom: 20px;
                border-bottom: 1px solid #eee;
            }
            .concert-name {
                font-size: 24px;
                color: #333;
                margin-bottom: 15px;
            }
            .info-item {
                margin-bottom: 10px;
                color: #666;
            }
            .price {
                color: #e83e8c;
                font-size: 20px;
                font-weight: bold;
            }
            .form-group {
                margin-bottom: 20px;
            }
            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #495057;
            }
            .form-group select {
                width: 100%;
                padding: 10px;
                border: 1px solid #ced4da;
                border-radius: 4px;
            }
            .btn-submit {
                width: 100%;
                padding: 12px;
                background: #4CAF50;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 16px;
            }
            .btn-submit:hover {
                background: #45a049;
            }
            .error-message {
                color: #dc3545;
                margin-bottom: 15px;
                padding: 10px;
                background: #f8d7da;
                border-radius: 4px;
            }
        </style>
    </jsp:attribute>

    <jsp:body>
        <div class="order-confirm">
            <div class="concert-info">
                <h2 class="concert-name">${concert.name}</h2>
                <p class="info-item">
                    <i class="fas fa-calendar-alt"></i> 
                    演出时间：<fmt:formatDate value="${concert.date}" pattern="yyyy-MM-dd"/>
                </p>
                <p class="info-item">
                    <i class="fas fa-map-marker-alt"></i> 
                    演出地点：${concert.location}
                </p>
                <p class="info-item">
                    <i class="fas fa-ticket-alt"></i> 
                    剩余票数：${concert.remainingTickets}
                </p>
                <p class="info-item price">
                    <i class="fas fa-yen-sign"></i> 
                    票价：￥${concert.ticketPrice}
                </p>
            </div>

            <c:if test="${not empty error}">
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/order?action=create&concertId=${concert.id}" 
                  method="post">
                <div class="form-group">
                    <label for="quantity">购票数量：</label>
                    <select id="quantity" name="quantity" required>
                        <c:forEach begin="1" end="${concert.remainingTickets > 5 ? 5 : concert.remainingTickets}" var="i">
                            <option value="${i}">${i}张</option>
                        </c:forEach>
                    </select>
                </div>
                
                <button type="submit" class="btn-submit">
                    <i class="fas fa-shopping-cart"></i> 确认购票
                </button>
            </form>
        </div>
    </jsp:body>
</t:layout> 
