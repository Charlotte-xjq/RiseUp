
            .page-title {
                text-align: center;
                color: #333;
                margin-bottom: 2rem;
                font-size: 2rem;
                font-weight: 600;
            }

            .form-group {
                margin-bottom: 1.5rem;
            }

            .form-group label {
                display: block;
                margin-bottom: 0.5rem;
                color: #555;
                font-weight: 500;
            }

            .form-group input {
                width: 100%;
                padding: 0.8rem;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 1rem;
                transition: all 0.3s ease;
            }

            .form-group input:focus {
                outline: none;
                border-color: #4A90E2;
                box-shadow: 0 0 0 2px rgba(74, 144, 226, 0.2);
            }

            .form-group input[type="file"] {
                padding: 0.5rem;
                background: #f8f9fa;
                border: 2px dashed #ddd;
            }

            .current-image {
                background: #f8f9fa;
                padding: 1rem;
                border-radius: 8px;
                margin-bottom: 1rem;
                text-align: center;
            }

            .current-image img {
                max-width: 300px;
                height: auto;
                border-radius: 4px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                margin-bottom: 0.5rem;
            }

            .current-image p {
                color: #666;
                margin: 0.5rem 0;
                font-size: 0.9rem;
            }

            .form-text {
                color: #666;
                font-size: 0.85rem;
                margin-top: 0.5rem;
                display: block;
            }

            .btn-submit {
                width: 100%;
                padding: 1rem;
                font-size: 1.1rem;
                font-weight: 500;
                color: #fff;
                background: #4A90E2;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                transition: background 0.3s ease;
            }

            .btn-submit:hover {
                background: #357ABD;
            }

            .error-message {
                background: #fff3f3;
                color: #dc3545;
                padding: 1rem;
                border-radius: 6px;
                margin-bottom: 1.5rem;
                border: 1px solid #ffcdd2;
            }

            /* 响应式设计 */
            @media (max-width: 768px) {
                .form-container {
                    margin: 1rem;
                    padding: 1.5rem;
                }
                
                .current-image img {
                    max-width: 100%;
                }
            }
        </style>
    </jsp:attribute>
    
    <jsp:body>
        <div class="form-container">
            <h1 class="page-title">编辑演唱会</h1>
            
            <c:if test="${not empty error}">
                <div class="error-message">
                    ${error}
                </div>
            </c:if>
            
            <form action="${pageContext.request.contextPath}/concert?action=edit" 
                  method="post" enctype="multipart/form-data">
                <input type="hidden" name="id" value="${concert.id}">
                
                <div class="form-group">
                    <label for="name">演唱会名称</label>
                    <input type="text" id="name" name="name" value="${concert.name}" required>
                </div>
                
                <div class="form-group">
                    <label for="date">演出日期</label>
                    <input type="date" id="date" name="date" 
                           value="<fmt:formatDate value='${concert.date}' pattern='yyyy-MM-dd'/>" required>
                </div>
                
                <div class="form-group">
                    <label for="location">演出地点</label>
                    <input type="text" id="location" name="location" value="${concert.location}" required>
                </div>
                
                <div class="form-group">
                    <label for="ticketPrice">票价（元）</label>
                    <input type="number" id="ticketPrice" name="ticketPrice" 
                           step="0.01" min="0" value="${concert.ticketPrice}" required>
                </div>
                
                <div class="form-group">
                    <label for="remainingTickets">剩余票数</label>
                    <input type="number" id="remainingTickets" name="remainingTickets" 
                           min="0" value="${concert.remainingTickets}" required>
                </div>
                
                <div class="form-group">
                    <label for="image">海报图片</label>
                    <div class="current-image">
                        <img src="${pageContext.request.contextPath}/uploads/${concert.image}" 
                             alt="当前海报" style="max-width: 200px; margin-bottom: 10px;">
                        <p>当前海报: ${concert.image}</p>
                    </div>
                    <input type="file" id="image" name="image" accept="image/*">
                    <small class="form-text text-muted">如果不上传新图片，将保持原图片不变</small>
                </div>
                
                <button type="submit" class="btn btn-primary btn-submit">保存修改</button>
            </form>
        </div>
    </jsp:body>
</t:layout> 
