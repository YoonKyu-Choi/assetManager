<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<script src="${pageContext.request.contextPath}/resources/js/jquery-3.1.0.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/moment-2-20-1.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/bootstrap-table.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/bootstrap.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/dashboard.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/bootstrap-table.css" rel="stylesheet" />
	


<script>

	$(function(){
		// 사이드바 활성화
		$("#catgLink").prop("class", "active");

		// 플래시 메시지
		var flashmsg = "<c:out value="${msg}"/>";
		if(flashmsg != ""){
			alert(flashmsg);
		}
	
		// 마스크 닫기
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

	    // 반응성 윈도우 사이즈
		var windowHeight = window.innerHeight;
		$(".table-responsive").css("height", windowHeight-400);
		$(window).resize(function(){
			windowHeight = $(window).height();
			$(".table-responsive").css("height", windowHeight-400);
		});

	});
	
	function deleteConfirm() {
		if (!confirm("해당 분류의 자산이 모두 삭제됩니다. 계속할까요?")) {
			return false;
		} else {
	        wrapWindowByMask();
		}
	}
	function modifyConfirm() {
		if (!confirm("수정하시겠습니까?")) {
			return false;
		} else {
			$("#modifyForm").submit();
		}
	}

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
	
</script>

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
</style>

</head>

<body>
	<div class="container-fluid">
		<div class="row">
			<div class="main">
				<h1 class="page-header">
					<font size="6px"><b># 분류 정보</b></font>
				</h1>
				
				<h3>분류 이름: ${categoryData["name"]} &nbsp&nbsp&nbsp&nbsp 분류 코드: ${categoryData["code"]}</h3>
				<br>
				<h5>세부 사항</h5>
				<div class="table-responsive">
					<table class="table table-striped" style="text-align: center; width: 100%">
					<c:forEach items="${categoryData.items}" var="categoryItem" varStatus="i" step="2">
					<tr>
						<td style="width: 50%">${categoryData.items[i.index]}</td>
						<td style="width: 50%">${categoryData.items[i.index+1]}</td>
					</tr>
					</c:forEach>
					</table>
				</div>


				<form id="modifyForm" action="categoryModify" method="POST">
 					<input type="hidden" name="categoryName" value=${categoryData["name"]} />
				</form>
				<input type="button" class="btn btn-lg btn-primary" onclick="location.href='/assetmanager/categoryList'" value="목록" />
				<div style="display: flex; float: right">
					<button class="btn btn-lg btn-primary" style="margin-right: 10px" onclick="modifyConfirm();">분류 수정</button>
					<button class="btn btn-lg btn-primary" id="delbtn" onclick="deleteConfirm();">분류 삭제</button>
				
					<div class="mask"></div>
				    <div class="window">
				    	<p>비밀번호를 입력해주세요.</p>

						<form id="idForm" action="categoryDelete" method="POST">
							<input type="hidden" name="categoryName" value=${categoryData["name"]} />
							<input type="password" name="checkAdminPw" autofocus/>
				        	<div style="margin-top: 20px">
					        	<button class="btn btn-lg btn-primary" type="submit">제출</button>
					        	<input class="btn btn-lg btn-primary close" type="button" value="취소"/>
				        	</div>
						</form>

				    </div>
			    </div>
				
			</div>
		</div>
	</div>

</body>
