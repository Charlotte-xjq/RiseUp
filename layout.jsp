<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>${param.title} - 演唱会票务系统</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-color: #f4f4f4;
        }
        .main-content {
            flex: 1;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            width: 100%;
            box-sizing: border-box;
        }
    </style>
    ${param.styles}
</head>
<body>
    <jsp:include page="/WEB-INF/include/header.jsp"/>
    
    <div class="main-content">
        <jsp:doBody/>
    </div>
    
    <jsp:include page="/WEB-INF/include/footer.jsp"/>
</body>
</html> 
