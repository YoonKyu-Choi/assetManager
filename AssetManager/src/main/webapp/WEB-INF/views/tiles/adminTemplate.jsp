<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>ESE 자산관리시스템</title>
<style>

footer {
	bottom:0;
	width:100%;
	background-color: #222;
	color: white;
	padding: 15px;
	position:absolute;
}

ul {
	margin: 0;
	padding: 0;
	width: 12.5%;
	text-align: center;
	background-color: #666;
	position: fixed;
	height: 100%;
}

#systemlogo{
	color: white;
	padding-top: 20px;
	padding-bottom: 20px;
	font-size: 150%;
	font-weight: bold;
}

li a {
	display: block;
	background-color: #eee;
	color: #000;
	padding: 8px 16px;
}

li a.active {
	background-color: #aaa;
	color: white;
}

li a:hover {
	background-color: #444;
	color: white;
}

</style>
</head>
<body>
	<header class="navbar-inverse">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-target="#myNavbar"></button>
				<label class="navbar-brand" style="padding-top: 17px">ESE</label>
			</div>
			<tiles:insertAttribute name="adminHeader" />
		</div>
	</header>

	<ul>
		<li id="systemlogo"><font>자산관리시스템</font></li>
		<li><a id="asstLink" href="/assetmanager/assetList">자산 관리</a></li>
		<li><a id="userLink" href="/assetmanager/userList">회원 관리</a></li>
		<li><a id="dispLink" href="/assetmanager/disposalList">폐기 관리</a></li>
		<li><a id="catgLink" href="/assetmanager/categoryList">분류 관리</a></li>
	</ul>

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