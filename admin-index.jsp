<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:layout title="管理后台">
    <jsp:attribute name="styles">
        <style>
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-top: 20px;
            }
            .stat-card {
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .stat-title {
                color: #666;
                margin-bottom: 10px;
            }
            .stat-value {
                font-size: 24px;
                font-weight: bold;
                color: #333;
            }
        </style>
    </jsp:attribute>
    
    <jsp:body>
        <h1>系统概览</h1>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-title">总演唱会数</div>
                <div class="stat-value">${concertCount}</div>
            </div>
            <div class="stat-card">
                <div class="stat-title">总订单数</div>
                <div class="stat-value">${orderCount}</div>
            </div>
            <div class="stat-card">
                <div class="stat-title">总用户数</div>
                <div class="stat-value">${userCount}</div>
            </div>
            <div class="stat-card">
                <div class="stat-title">今日订单数</div>
                <div class="stat-value">${todayOrderCount}</div>
            </div>
        </div>
    </jsp:body>
</t:layout> 
