<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- Bootstrap core CSS -->
	<link href="${pageContext.request.contextPath}/resources/css/bootstrap.css" rel="stylesheet">

<script src="${pageContext.request.contextPath}/resources/js/jquery-2-1-1.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/moment-2-20-1.js"></script>

<title>자산관리시스템(관리자)</title>
<style>
.navbar {
	margin-bottom: 0;
	border-radius: 0;
}

.row.content {
	height: 450px
}

.sidenav {
	padding-top: 20px;
	background-color: #f1f1f1;
	height: 100%;
}

footer {
	bottom:0;
	width:100%;
	background-color: #555;
	color: white;
	padding: 15px;
	position:absolute;
}

@media screen and (max-width: 767px) {
	.sidenav {
		height: auto;
		padding: 15px;
	}
	.row.content {
		height: auto;
	}
}
</style>
</head>
<body>
	<header class="navbar navbar-inverse">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar"></button>
				<label class="navbar-brand">ESE</label>
			</div>
				<tiles:insertAttribute name="adminHeader" />
		</div>
	</header>


	<div class="container">
		<tiles:insertAttribute name="content" />
	</div>


	<footer class="container-fluid text-left" >
	<div class="footer-container">
		<tiles:insertAttribute name="footer" />
	</div>
	</footer>
	</div>
</body>

</html>