<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page session = "false" %>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<script src="${pageContext.request.contextPath}/resources/js/jquery-3.1.0.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/moment-2-20-1.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/bootstrap-menu.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/bootstrap-table.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/jquery.jqGrid.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/bootstrap.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/dashboard.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/bootstrap-table.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/jquery-ui.css" rel="stylesheet"/>
	<link href="${pageContext.request.contextPath}/resources/css/ui.jqgrid.css" rel="stylesheet"/>
	
<script>
	var trName = "";
    var userMenu = new BootstrapMenu('td', {
    	actions: [{
    		name: '상세 보기',
    		onClick: function() {
    			$("#userDetailForm").submit();
    		}
    	}]
    });

	$(function(){
		// 사이드바 활성화
		$("#userLink").prop("class", "active");
		
		// 플래시 메시지
		var refreshCount = 1;
		var userCount = Number("${userListData['userCount']}");
		$(".table-responsive").on("click", ".table tbody tr", function(){
			if( userCount > 0){
				document.location.href='/assetmanager/userDetail?employeeSeq='+trName;
			}
		});
		var flashmsg = "<c:out value="${msg}"/>";
		
		if(refreshCount > 0){
			if(flashmsg != ""){
				alert(flashmsg);
			}
			refreshCount -= 1;
		}

		// 반응성 윈도우 사이즈
		var windowHeight = window.innerHeight;
		$(".table-responsive").css("height", windowHeight-330);
		$(window).resize(function(){
			windowHeight = $(window).height();
			$(".table-responsive").css("height", windowHeight-330);
			$("#assetTable").setGridHeight(window.innerHeight-380, true);
		});

		// 검색
		// 이미 컨트롤러 단에서 검색해서 넘겨주게 구현됨
		
		// jqGrid 포매팅
		var myData = [];
		<c:forEach items="${userListData['employeeList']}" var="user">
			var dic = {};
			dic['employeeName'] = "${user.employeeName}";
			dic['employeeSeq'] = "${user.employeeSeq}";
			dic['employeeId'] = "${user.employeeId}";
			dic['employeeRankString'] = "${user.rankVO.employeeRankString}";
			dic['employeeDepartmentString'] = "${user.departmentVO.employeeDepartmentString}";
			dic['employeeLocation'] = "${user.employeeLocation}";
			dic['employeeEmail'] = "${user.employeeEmail}";
			dic['employeePhone'] = "${user.employeePhone}";
			dic['employeeStatus'] = "${user.employeeStatus}";
			myData.push(dic);
		</c:forEach>

		var isSelected = false;
		$("#userTable").jqGrid({
			datatype: "local",
			data: myData,
			height: window.innerHeight-380,
			rowNum: userCount,
			multiselect: false,
			viewrecord: true,
			autowidth: true,
			colNames:['번호', '상태', '이름', '아이디', '소속', '직급', '위치', '이메일', '연락처'],
			colModel:[
				{name:'employeeSeq',index:'employeeSeq', width:60, hidden:true},
				{name:'employeeStatus',index:'employeeStatus', width:60, align:'center'},
				{name:'employeeName',index:'employeeName', width:80, align:'center'},
				{name:'employeeId',index:'employeeId', width:100, align:'center'},
				{name:'employeeDepartmentString',index:'employeeDepartmentString', width:220, align:'center'},
				{name:'employeeRankString',index:'employeeRankString', width:100, align:'center'},
				{name:'employeeLocation',index:'employeeLocation', width:60, align:'center'},
				{name:'employeeEmail',index:'employeeEmail', width:160, align:'center'},
				{name:'employeePhone',index:'employeePhone', width:120, align:'center'},
			],
			onRightClickRow: function(rowid){
				trName = $("#userTable").getRowData(rowid)['employeeSeq'];
				$("#employeeSeq").val(trName);
			},
			ondblClickRow: function(rowid){
				trName = $("#userTable").getRowData(rowid)['employeeSeq'];
				$("#employeeSeq").val(trName);
    			$("#userDetailForm").submit();
			}
		});

	});
	
	function searchFunc(){
		$.ajax({
			"type": "GET",
			"url": "userList",
			"dataType": "text",
			"data": {
				employeeName : $("#searchByName").val()
			},
			"success": function(list){
				alert("검색 완료 ");
			},
			"error": function(e){
				alert("오류 발생 : "+ e.responseText);
			}
		});
	}

</script>
	
<style>
	th, td {
		text-align: center;
	}
	th{
		background-color:darkgray;
		color:white;
	}
	.container{
		top:0;
		left:0;
		bottom:0;
		right:0;
		height:100%;
		width:100%;
		margin-top: 1%;
	}
	.main{
		margin-left: 13%;
		width: 76%;
	}
	#button, #searchBtn{
		color: black;
		border-color: #999;
		background-color: #aaa;
		font-weight: bold;
	}
	#button:hover, #searchBtn:hover {
		color: white;
		background-color: #333;
	}
	.ui-jqgrid-hbox{
		background-color: #555;
	}
	.ui-jqgrid .ui-jqgrid-labels th.ui-th-column {
		background-color: #555;
		background-image: none;
		border: #555;
	}
	.ui-widget-content{
		border: #555
	}
	.ui-state-highlight, .ui-widget-content .ui-state-highlight{
		color: black;
		border: black;
	}
	.ui-widget-content .ui-state-hover {
		background-color: #777;
		color: white;
		border: white;
	}
	.ui-jqgrid-hdiv .ui-state-hover {
		font-weight: bold;
	}
	.ui-widget.ui-widget-content{
		border-color: #555
	}
	.ui-jqgrid {
		font-size: 1.0em;
	}
	.ui-state-default, .ui-widget-content .ui-state-default{
		border: white;
	}
	#searchMode, #searchByName, #searchBtn{
		height : 27 px;
		vertical-align:middle;
    }
    #searchBtn{
    	padding-top: 3px;
    }
</style>

</head>
<body>
	<div class="container-fluid">
		<div class="row">
			<div class="main">
				<form class="page-header" id="listRefresh">
					<font size="6px"><b>회원 관리</b></font>
					<label style="float: right; margin-top: 20px">
						<select id="searchMode" style="height:27px">
							<option>회원 이름</option>
						</select>
						<input type="text" id="searchByName" name="employeeName">
						<input type="submit" class="btn btn-primary" id="searchBtn" value="검색" onclick="searchFunc();">
					</label>
				</form>
				<div style="margin-bottom: 10px">
					<font size="4px">&nbsp;&nbsp;회원 수 : </font>
					<span class="badge">${userListData['userCount']}</span>
				</div>
				
				<div class="table-responsive" style="overflow: auto">
					<table id="userTable"></table>
				</div>
				
				<form id="userDetailForm" action="userDetail" method="post">
					<input type="hidden" id="employeeSeq" name="employeeSeq"/>
				</form>

				<div style="display: flex; float: left; margin-top: 5px; bottom: 60px; position: absolute">
					<img src="${pageContext.request.contextPath}/resources/mouseRightClick.png" width="25px" height="25px">
					&nbsp;&nbsp;Menu
				</div>
				<button id="button" class="btn btn-lg btn-primary" style="float:right; margin-top: 10px" onclick="location.href='/assetmanager/register';">회원 추가</button>
			</div>
		</div>
	</div>
</body>
