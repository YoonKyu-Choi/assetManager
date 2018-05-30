<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
<meta name="description" content="">
<meta name="author" content="">

<title>사용자 상세보기</title>

<!-- Bootstrap core CSS -->
<link href="${pageContext.request.contextPath}/resources/css/bootstrap.css" rel="stylesheet">
<!-- Custom styles for this template -->
<link href="${pageContext.request.contextPath}/resources/css/dashboard.css" rel="stylesheet">
<script src="${pageContext.request.contextPath}/resources/js/jquery-2-1-1.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/moment-2-20-1.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap-table.js"></script>
<link href="${pageContext.request.contextPath}/resources/css/bootstrap-table.css" rel="stylesheet" />

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>

<style>
        .mask {
            position:absolute;
            left:0;
            top:0;
            z-index:9999;
            background-color:#000;
            display:none;
        }
        .window {
            display: none;
            background-color: #ffffff;
            z-index:99999;
        }
    </style>


<script>
	function modifyConfirm() {
		if (!confirm("수정하시겠습니까?")) {
			return false;
		} else {
			$("#modifyForm").submit();
		}
	}
	function outConfirm() {
		if (!confirm("반출/수리 하겠습니까?")) {
			return false;
		} else {
	        wrapWindowByMask();
		}
	}
	function dispReqConfirm() {
		if (!confirm("폐기 신청을 하시겠습니까?")) {
			return false;
		} else {
			$("#modifyForm").submit();
		}
	}
	
	$(function(){
		var flashmsg = "<c:out value="${msg}"/>";
//		if(flashmsg != "")
			alert(flashmsg);
	});

	function wrapWindowByMask(){
	    // 화면의 높이와 너비를 변수로 만듭니다.
	    var maskHeight = $(window).height();
	    var maskWidth = $(window).width();
	
	    // 마스크의 높이와 너비를 화면의 높이와 너비 변수로 설정합니다.
	    $('.mask').css({'width':maskWidth,'height':maskHeight});
	
	    // fade 애니메이션 : 1초 동안 검게 됐다가 80%의 불투명으로 변합니다.
	    $('.mask').fadeTo("slow",0.8);
	
		var position = $("#delbtn").offset();
		
	    // 레이어 팝업을 가운데로 띄우기 위해 화면의 높이와 너비의 가운데 값과 스크롤 값을 더하여 변수로 만듭니다.
	    var left = $(window).scrollLeft() +position['left'];
	    var top = $(window).scrollLeft() +position['top'];
	
	    // css 스타일을 변경합니다.
	    $('.window').css({'left':left,'top':top, 'position':'absolute'});
	
	    // 레이어 팝업을 띄웁니다.
	    $('.window').show();
	}
	
	$(function(){
	    // 닫기(close)를 눌렀을 때 작동합니다.
	    $('.window .close').click(function (e) {
	        e.preventDefault();
	        $('.mask, .window').hide();
	    });

	    // 뒤 검은 마스크를 클릭시에도 모두 제거하도록 처리합니다.
        $('.mask').click(function () {
            $(this).hide();
            $('.window').hide();
        });	
	});
</script>
</head>

<body>
	<div class="container-fluid">
		<div class="row">
			<div class="main">
				<h1 class="page-header">${requestScope.assetVO.assetId}의 자산 정보</h1>
				<div class="table-responsive">
				<h3>자산 공통사항</h3>
					<table class="table table-striped">
						<tr>
							<th>분류</th>
							<th>${requestScope.assetVO.assetCategory}</th>
							<th>이름</th>
							<th>${requestScope.assetVO.assetUser}</th>
						</tr>
						<tr>
							<th>관리 번호</th>
							<th>${requestScope.assetVO.assetId}</th>
							<th>자산 상태</th>
							<th>${requestScope.assetVO.assetStatus}</th>
						</tr>
						<tr>
							<th>시리얼 번호</th>
							<th>${requestScope.assetVO.assetSerial}</th>
							<th>구입일</th>
							<th>${requestScope.assetVO.assetPurchaseDate}</th>
						</tr>
						<tr>
							<th>제조사</th>
							<th>${requestScope.assetVO.assetMaker}</th>
							<th>구입가</th>
							<th>${requestScope.assetVO.assetPurchasePrice}</th>
						</tr>
						<tr>
							<th>모델명</th>
							<th>${requestScope.assetVO.assetModel}</th>
							<th>구입처</th>
							<th>${requestScope.assetVO.assetPurchaseShop}</th>
						</tr>
						<tr>
							<th>용도</th>
							<th>${requestScope.assetVO.assetUsage}</th>
							<th>책임자</th>
							<th>${requestScope.assetVO.assetManager}</th>
						</tr>
						<tr>
							<th>사용 위치</th>
							<th>${requestScope.assetVO.assetLocation}</th>
						</tr>
					</table>
				</div>

				<form id="modifyForm" action="userModify" method="POST">
					<input type="hidden" name="employeeSeq" value=${requestScope.assetVO.employeeSeq } />
				</form>
				<input type="button" class="btn btn-lg btn-primary" onclick="location.href='/assetmanager/assetList'" value="목록" />
				<div style="display: flex; float: right">
					<button class="btn btn-lg btn-primary" style="margin-right: 10px" onclick="modifyConfirm();">수정</button>
					<button class="btn btn-lg btn-primary" id="delbtn" onclick="outConfirm();">반출/수리</button>
					<button class="btn btn-lg btn-primary" style="margin-right: 10px" onclick="dispReqConfirm();">폐기 신청</button>
					<button class="btn btn-lg btn-primary" style="margin-right: 10px" onclick="">자산 이력</button>
					<div class="mask"></div>
			    </div>
				
			</div>
		</div>
	</div>

</body>
</html>