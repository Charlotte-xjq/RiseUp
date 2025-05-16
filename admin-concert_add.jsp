<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="演唱会列表">
    <jsp:attribute name="styles">
        <style>
            .concert-grid {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                gap: 20px;
                padding: 20px;
            }
            .concert-card {
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                overflow: hidden;
                transition: transform 0.2s;
            }
            .concert-card:hover {
                transform: translateY(-5px);
            }
            .concert-image {
                width: 100%;
                height: 200px;
                object-fit: cover;
            }
            .concert-info {
                padding: 15px;
            }
            .concert-name {
                font-size: 18px;
                font-weight: bold;
                margin-bottom: 10px;
                color: #333;
            }
            .concert-details {
                color: #666;
                margin-bottom: 5px;
                font-size: 14px;
            }
            .concert-price {
                color: #e83e8c;
                font-weight: bold;
                font-size: 18px;
                margin: 10px 0;
            }
            .remaining-tickets {
                color: #28a745;
                font-size: 14px;
                margin-bottom: 15px;
            }
            .btn-book {
                display: inline-block;
                padding: 8px 16px;
                background-color: #4CAF50;
                color: white;
                text-decoration: none;
                border-radius: 4px;
                transition: background-color 0.2s;
                border: none;
                cursor: pointer;
                width: 100%;
                text-align: center;
            }
            .btn-book:hover {
                background-color: #45a049;
            }
            .btn-book.disabled {
                background-color: #cccccc;
                cursor: not-allowed;
            }
            .login-prompt {
                font-size: 14px;
                color: #dc3545;
                margin-top: 5px;
                text-align: center;
            }
            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                margin: 30px 0 50px 0;
                gap: 10px;
            }
            .pagination a {
                padding: 8px 16px;
                text-decoration: none;
                border-radius: 4px;
                border: 1px solid #ddd;
                color: #666;
                background: white;
                transition: all 0.3s;
                display: inline-flex;
                align-items: center;
                gap: 5px;
                font-size: 14px;
            }
            .pagination a:hover {
                background-color: #f5f5f5;
                color: #4CAF50;
                border-color: #4CAF50;
            }
            .page-number {
                color: #666;
                font-size: 14px;
                padding: 0 10px;
            }
            .page-info {
                text-align: center;
                color: #666;
                margin-bottom: 10px;
                font-size: 14px;
            }
        </style>
    </jsp:attribute>

    <jsp:body>
        <div class="concert-grid">
            <c:forEach items="${concerts}" var="concert">
                <div class="concert-card">
                    <img src="${pageContext.request.contextPath}/uploads/${concert.image}"
                         alt="${concert.name}" 
                         class="concert-image">
                    <div class="concert-info">
                        <h3 class="concert-name">${concert.name}</h3>
                        <p class="concert-details">
                            <i class="fas fa-calendar-alt"></i> 
                            <fmt:formatDate value="${concert.date}" pattern="yyyy-MM-dd"/>
                        </p>
                        <p class="concert-details">
                            <i class="fas fa-map-marker-alt"></i> 
                            ${concert.location}
                        </p>
                        <p class="concert-price">￥${concert.ticketPrice}</p>
                        <p class="remaining-tickets">
                            <i class="fas fa-ticket-alt"></i> 
                            剩余票数：${concert.remainingTickets}
                        </p>
                        
                        <c:choose>
                            <c:when test="${empty sessionScope.user}">
                                <button class="btn-book disabled" disabled>
                                    <i class="fas fa-lock"></i> 立即预订
                                </button>
                                <p class="login-prompt">请先<a href="${pageContext.request.contextPath}/login.jsp">登录</a>后购票</p>
                            </c:when>
                            <c:when test="${concert.remainingTickets <= 0}">
                                <button class="btn-book disabled" disabled>
                                    <i class="fas fa-times-circle"></i> 已售罄
                                </button>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/order?action=create&concertId=${concert.id}" 
                                   class="btn-book">
                                    <i class="fas fa-shopping-cart"></i> 立即预订
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="page-info">
            共 ${total} 场演唱会
        </div>
        
        <div class="pagination">
            <c:if test="${currentPage > 1}">
                <a href="${pageContext.request.contextPath}/concert?action=list&page=${currentPage - 1}">
                    <i class="fas fa-angle-left"></i> 上一页
                </a>
            </c:if>
            
            <span class="page-number">第 ${currentPage} 页 / 共 ${totalPages} 页</span>
            
            <c:if test="${currentPage < totalPages}">
                <a href="${pageContext.request.contextPath}/concert?action=list&page=${currentPage + 1}">
                    下一页 <i class="fas fa-angle-right"></i>
                </a>
            </c:if>
        </div>
    </jsp:body>
</t:layout> 
