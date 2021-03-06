<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<script src="${pageContext.request.contextPath}/resources/js/jquery-3.1.0.min.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/moment-2-20-1.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/bootstrap-menu.js"></script>
	<script src="${pageContext.request.contextPath}/resources/js/bootstrap-table.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/bootstrap.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/dashboard.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/bootstrap-table.css" rel="stylesheet" />

<script>
	var assetUserId = "${assetData['assetUserId']}";
	var loginId = '<%=session.getAttribute("Id") %>';
	var isAdmin = "<%=session.getAttribute("isAdmin")%>";
	var assetStatusStr = "${assetData['assetVO']['assetStatus']}";
	var assetOutStatusStr = "${assetData['assetVO']['assetOutStatus']}";
	var assetStatus = 0;
	var generalMenu = new BootstrapMenu('.container', {
		actionsGroups:[
			['assetHistory', 'assetModify', 'assetDelete', 'assetPay', 'assetTakeout', 'assetDisposeRequest'],
			['assetList', 'printReport']
		],
		actions: {
			assetHistory: {
				name: '자산 이력',
				onClick: function(){
					historyConfirm();
				}
			},
			assetModify: {
				name: '수정',
				onClick: function(){
					modifyConfirm();
				},
				isShown: function(){
					if (isAdmin == "TRUE"){
						return ((assetStatus==1) || (assetStatus==4));
					} else if(isAdmin != "TRUE"){
						if(loginId == assetUserId){
							return ((assetStatus==1) || (assetStatus==4));
						}else {
							return false;
						}
					}
				}
			},
			assetDelete: {
				name: '자산 삭제',
				onClick: function(){
					deleteConfirm();
				},
				isShown: function(){
					if (isAdmin == "TRUE"){
						return (assetStatus == 2);
					} else if(isAdmin != "TRUE"){
						return false;
					}
				}
			},
			assetPay: {
				name: '납입',
				onClick: function(){
					payConfirm();
				},
				isShown: function(){
					if (isAdmin == "TRUE"){
						return assetStatus==3;
					} else if(isAdmin != "TRUE"){
						if(loginId == assetUserId){
							return assetStatus==3;
						}else {
							return false;
						}
					}
				}
			},
			assetTakeout: {
				name: '반출/수리',
				onClick: function(){
					wrapWindowByMask();
//					$("#pop").show();
				},
				isShown: function(){
					if (isAdmin == "TRUE"){
						return assetStatus==4;
					} else if(isAdmin != "TRUE"){
						if(loginId == assetUserId){
							return assetStatus==4;
						}else {
							return false;
						}
					}
				}
			},
			assetDisposeRequest: {
				name: '폐기 신청',
				onClick: function(){
					dispReqConfirm();
				},
				isShown: function(){
					if (isAdmin == "TRUE"){
						return assetStatus==4;
					} else if(isAdmin != "TRUE"){
						if(loginId == assetUserId){
							return assetStatus==4;
						}else {
							return false;
						}
					}
				}
			},
			assetList: {
				name: '목록',
				onClick: function(){
					location.href='/assetmanager/assetList';
				}
			},
			printReport: {
				name: '보고서 출력',
				onClick: function(){
					printReport();
				}
			}
		}
	});
	
	$(function(){
		// 사이드바 활성화
		$("#asstLink").prop("class", "active");

		// 반출/수리 활성/해제
		$('#popSubmit').click(function() {
			submitCheck();
		});
		$('#popClose').click(function() {
			$("form").each(function() {  
                if(this.id == "pop") this.reset();  
             });
			$("#pop").hide();
			$(".mask").hide();
		});

		// 삭제 확인 마스크 
	    // 닫기(close)를 눌렀을 때 작동합니다.
	    $('.window .close').click(function (e) {
	    	alert("hello");
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
		$(".table-responsive").css("height", windowHeight-250);
		$("#pop").css("top", (window.innerHeight-450)/2);
		$("#pop").css("right", (window.innerWidth-400)/2);
		$(".window").css("top", (window.innerHeight-250)/2);
		$(".window").css("right", (window.innerWidth-300)/2);
		$(window).resize(function(){
			windowHeight = $(window).height();
			$(".table-responsive").css("height", windowHeight-250);
			$("#pop").css("top", (window.innerHeight-450)/2);
			$("#pop").css("right", (window.innerWidth-400)/2);
			$(".window").css("top", (window.innerHeight-250)/2);
			$(".window").css("right", (window.innerWidth-300)/2)
		})
		
		// 현재 자산 상태
		switch(assetStatusStr){
		case '폐기 대기':
			assetStatus = 1;
			break;
		case '폐기':
			assetStatus = 2;
			break;
		case '사용 중':
		case '사용 가능':
		case '사용 불가':
			switch(assetOutStatusStr){
				case '반출 중':
				case '수리 중':
					assetStatus = 3;
					break;
				default:
					assetStatus =4;
					break;
			}
			break;
		default:
			assetStatus = 4;
			break;
		}
		
		// 구입가 포맷 
		var assetPurchasePrice = "${assetData['assetVO']['assetPurchasePrice']}";
		if( assetPurchasePrice != "미입력"){
			$("#assetPurchasePrice").text(numberWithCommas(assetPurchasePrice)+" 원");
		} else{
			$("#assetPurchasePrice").text(assetPurchasePrice);
		}
		
	});
	
	function submitCheck() {
		// 반출/수리 신청 시 유효성 검사
		if ($("#assetOutStatus").val() == '0') {
			alert("용도를 선택해주세요.");
			$("#assetOutStatus").focus();
			return false;
		} else if($("#assetOutObjective").val()==''){
			alert("반출/수리 대상을 입력해주세요.");
			$("#assetOutObjective").focus();
			return false;
		} else if($("#assetOutPurpose").val()==''){
			alert("반출/수리 목적을 입력해주세요.");
			$("#assetOutPurpose").focus();
			return false;
		} else if($("#assetOutCost").val()==''){
			alert("반출/수리 비용을 입력해주세요.");
			$("#assetOutCost").focus();
			return false;
		} else{
		// 반출/수리 전 추가내용 확인
			if($("#assetOutComment").val()==''){
				if(!confirm("자산 반출/수리 이력 추가내용이 입력되지 않았습니다.\n입력하지 않으면 빈칸으로 처리됩니다.")){
					return false;
				} else {
					$("#assetOutComment").val("자산 반출/수리 이력 추가내용이 없습니다.");
				}
			}
		
			if (!confirm("반출/수리을(를) 신청하시겠습니까?")) {
				return false;
			} else {
				$('#pop').submit();
			}
		}
	};

	function modifyConfirm() {
		if (!confirm("수정하시겠습니까?")) {
			return false;
		} else {
			$("#assetModifyForm").submit();
		}
	}
	
	function outConfirm() {
		if (!confirm("반출/수리 하겠습니까?")) {
			return false;
		} else {
			$("#pop").show();
		}
	}
	
	function dispReqConfirm() {
		if (!confirm("폐기 신청을 하시겠습니까?")) {
			return false;
		} else {
			var disposalAssetAry = [];
			var assetId = "${assetData['assetVO']['assetId']}";
			disposalAssetAry.push(assetId);
			
			$("#disposalAsset").val(disposalAssetAry);
			$("#assetDispForm").submit();
		}
	}
	
	function historyConfirm() {
		$("#assetHistoryForm").submit();
	}
	
	function deleteConfirm() {
		if (!confirm("자산을 정말 삭제하시겠습니까?")) {
			return false;
		} else {
			DwrapWindowByMask();
		}
	}
	
	function payConfirm(){
		if (!confirm("자산을 정말 납입하시겠습니까?")) {
			return false;
		} else {
			$("#assetPaymentForm").submit();
		}
	}
	
	function disposeConfirm(){
		if(!confirm('선택한 자산을 폐기하겠습니까?')){
				return false;
			}else{
				$("#disposeForm").submit();
		}
	}

	function wrapWindowByMask(){
	    // 화면의 높이와 너비를 변수로 만듭니다.
	    var maskHeight = $(window).height();
	    var maskWidth = $(window).width();
	
	    // 마스크의 높이와 너비를 화면의 높이와 너비 변수로 설정합니다.
	    $('.mask').css({'width':maskWidth,'height':maskHeight});
	    // fade 애니메이션 : 1초 동안 검게 됐다가 80%의 불투명으로 변합니다.
	    $('.mask').fadeTo("slow",0.5);
	
		//var position = $("#hiddenBtn").offset();
		
	    // 레이어 팝업을 가운데로 띄우기 위해 화면의 높이와 너비의 가운데 값과 스크롤 값을 더하여 변수로 만듭니다.
	    //var left = $(window).scrollLeft() +position['left'];
	    //var top = $(window).scrollLeft() +position['top'];
	
	    // css 스타일을 변경합니다.
	    //$('.window').css({'left':left,'top':top, 'position':'absolute'});
	 
	    // 레이어 팝업을 띄웁니다.
	    $('#pop').show();
	}
	
	function DwrapWindowByMask(){
	    // 화면의 높이와 너비를 변수로 만듭니다.
	    var MaskHeight = $(window).height();
	    var MaskWidth = $(window).width();
	
	    // 마스크의 높이와 너비를 화면의 높이와 너비 변수로 설정합니다.
	    $('.mask').css({'width':MaskWidth,'height':MaskHeight});
	    // fade 애니메이션 : 1초 동안 검게 됐다가 80%의 불투명으로 변합니다.
	    $('.mask').fadeTo("slow",0.5);
	
	    $('.window').show();
	}
	
	
	function printReport(){
		if(!confirm('현재 자산의 보고서를 출력하겠습니까?')){
			return false;
		}else{
			var printList = [];
			var assetId = "${assetData['assetVO']['assetId']}";
			printList.push(assetId);
			
			$("#printReportArray").val(printList);
			$("#printReportForm").submit();
			
		}
	}
	
	function numberWithCommas(x) {
	    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
	
	// 입력 키 숫자/한글 판정
	function fn_press(event, type) {
        if(type == "numbers") {
            if(event.keyCode < 48 || event.keyCode > 57){
                return false;
            }
        }
    }
    
    function fn_press_han(obj)  {
        //좌우 방향키, 백스페이스, 딜리트, 탭키에 대한 예외
        if(event.keyCode == 8 || event.keyCode == 9 || event.keyCode == 37 || event.keyCode == 39 || event.keyCode == 46 ){
            return;
        }
        obj.value = obj.value.replace(/[\ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
    }
	
</script>
<style>
	.mask {
		position:absolute;
		left:0;
		top:0;
		z-index:999;
		background-color:#000;
		display:none;
	}
	.window {
		z-index: 99999;
		width : 300px;
		height : 250px;
		background : white;
		color : black;
		position: absolute;
		text-align : center;
		border : 2px solid #000;
		display : none;
	}
	#pop{
		z-index: 99999;
		width : 400px;
		height : 450px;
		background : white;
		color : black;
		position: absolute;
		text-align : center;
		border : 2px solid #000;
		display : none;
	}
	.popInput{
		color : #white;
		width : 50px;
		table-layout: fixed;
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
	th:nth-child(4n+1), th:nth-child(4n+3){
		width: 25%;
		font-weight: bold;
	}
	th:nth-child(4n+2), th:nth-child(4n+4){
		width: 25%;
		font-weight: normal;
	}
	hr {
		height: 1px;
		width: 100%;
		background-color: gray;
		background-image: linear-gradient(to right, #ccc, #333, #ccc);
	}
	#popSubmit, #popClose, #deleteSubmit, #deleteBtn{
		color: black;
		border-color: #999;
		background-color: #aaa;
		font-weight: bold;
	}
	#popSubmit:hover, #popClose:hover {
		color: white;
		background-color: #333;
	}
	.dropdown, input:not([type="button"]), textArea{
		width: 180px
	}
	
</style>

</head>

<body>
	<div class="container-fluid">
		<div class="row">
			<div class="main">
				<h1 class="page-header">
					<font size="6px"><b>자산 정보</b></font>
				</h1>
				<div class="table-responsive" id="inputDiv" style="overflow: scroll;height: 500px;">
					<h3>자산 공통사항</h3>
					<table class="table table-striped">
						<tr>
							<th>분류</th>
							<th>${assetData['assetVO']['assetCategory']}</th>
							<th>이름</th>
							<th>${assetData['assetVO']['assetUser']}</th>
						</tr>
						<tr>
							<th>관리 번호</th>
							<th>${assetData['assetVO']['assetId']}</th>
							<th>시리얼 번호</th>
							<th>${assetData['assetVO']['assetSerial']}</th>
						</tr>
						<tr>
							<th>자산 상태</th>
							<th>${assetData['assetVO']['assetStatus']}</th>
							<th id="hiddenBtn">반출 상태</th>
							<th>${assetData['assetVO']['assetOutStatus']}</th>
						</tr>
						<tr>
							<th>구입일</th>
							
							<c:if test="${assetData['assetVO']['assetPurchaseDate'] == '9999-01-01'}">
								<th>미입력</th>	
							</c:if>
							<c:if test="${assetData['assetVO']['assetPurchaseDate'] != '9999-01-01'}">
								<th>${assetData['assetVO']['assetPurchaseDate']}</th>
							</c:if>
							
							<th>제조사</th>
							<th>${assetData['assetVO']['assetMaker']}</th>
						</tr>
						<tr>
							<th>구입가(원)</th>
							<th id="assetPurchasePrice"></th>
							<th>모델명</th>
							<th>${assetData['assetVO']['assetModel']}</th>
						</tr>
						<tr>
							<th>구입처</th>
							<th>${assetData['assetVO']['assetPurchaseShop']}</th>
							<th>용도</th>
							<th>${assetData['assetVO']['assetUsage']}</th>
						</tr>
						<tr>
							<th>책임자</th>
							<th>${assetData['assetVO']['assetManager']}</th>
							<th>사용 위치</th>
							<th>${assetData['assetVO']['assetLocation']}</th>
						</tr>
					</table>
					<hr>
					<h3>자산 세부사항</h3>
					<table class="table table-striped">
					<c:forEach items="${assetData['assetDetailList']}" varStatus="i" step="2">
						<tr>
							<th>${assetData['assetDetailList'][i.index]['assetItem']}</th>
							<th>${assetData['assetDetailList'][i.index]['assetItemDetail']}</th>
							<th>${assetData['assetDetailList'][i.index+1]['assetItem']}</th>
							<th>${assetData['assetDetailList'][i.index+1]['assetItemDetail']}</th>
						</tr>
					</c:forEach>
					</table>
					<hr>
					<c:if test="${assetData['assetVO']['assetReceiptUrl'] !=null && assetData['assetVO']['assetReceiptUrl'] != ''}">
						<h3>영수증 사진</h3>
						<img style="width:400px;height:400px;" src="${pageContext.request.contextPath}/resources/${assetData['assetVO']['assetReceiptUrl']}">
					</c:if>
					<c:if test="${assetData['assetVO']['assetReceiptUrl'] ==null || assetData['assetVO']['assetReceiptUrl'] == ''}">	
						<h3>영수증 사진이 없습니다.</h3>
					</c:if>
					<hr>					
					<h3>자산 코멘트</h3>
					<textArea style="resize: none; width:600px; height:200px" readonly>${assetData['assetVO']['assetComment']}</textArea>
				</div>
	
				<!-- 컨트롤러 이동 form -->
				<form id="printReportForm" action="printReport" method="post">
					<input type="hidden" id="printReportArray" name="assetIdList"/>
				</form>
				<form id="assetModifyForm" action="assetModify" method="POST">
					<input type="hidden" name="assetId" value=${assetData['assetVO']['assetId'] } />
				</form>
				<form id="assetDispForm" action="assetDisposal" method="post">
					<input type="hidden" id="disposalAsset" name="assetIdList" />
				</form>
				<form id="assetDeleteForm" action="assetDelete" method="POST">
					<input type="hidden" name="assetId" value=${assetData['assetVO']['assetId'] } />
				</form>
				<form id="assetHistoryForm" action="assetHistory" method="post">
					<input type="hidden" name="assetId" value=${assetData['assetVO']['assetId'] } />
				</form>
				<form id="assetPaymentForm" action="assetPayment" method="post">
					<input type="hidden" name="assetId" value=${assetData['assetVO']['assetId'] } />
					<input type="hidden" name="assetUser" value=${assetData['assetVO']['assetUser'] } />
				</form>
				
				<!-- 삭제 비밀번호 -->				    
				<div class="mask"></div>
				<div class="window">
					<h3 class="page-header" style="margin-top: 30px;"><b>자산 삭제</b></h3>
			    	<p>비밀번호를 입력해주세요.</p>
					<form id="assetDeleteCheckForm" action="assetDelete" method="POST">
					<input type="hidden" name="assetId" value=${assetData['assetVO']['assetId'] } />
					<input type="password" name="checkAdminPw" autofocus/>
				    <div style="margin-top: 20px">
					 	<button class="btn btn-lg btn-primary" id="deleteSubmit" type="submit" style="margin-right: 20px">제출</button>
					  	<input class="btn btn-lg btn-primary" type="button" id="deleteBtn" style="margin-left: 20px" value="취소" onclick="$('.mask').click();"/>
				    </div>
					</form>
				</div>
				
				<!-- 반출/수리 레이어 팝업 -->
				<form id="pop" action="assetTakeOutHistory" method="post">
					<h3 class="page-header" style="margin-top: 30px;"><b>반출/수리 신청</b></h3>
					<div style="padding-left: 10px; padding-right: 10px">
						<table style="margin-top: 30px;" class="table table-striped">
							<tr>
								<th>신청날짜</th>
								<th>현재날짜로 등록됩니다.</th>
							</tr>
							<tr>
								<th>용도</th>
								<th class="popInput">
									<select class="form-controlmin dropdown" id="assetOutStatus" name="assetOutStatus">
										<option value="0">용도를 선택하세요.</option>
										<option value="반출 중">반출 중</option>
										<option value="수리 중">수리 중</option>
										<option value="고장">고장</option> 
									</select>
								</th>
							</tr>
							<tr>
								<th>대상</th>
								<th class="popInput"><input type="text" name="assetOutObjective" id="assetOutObjective" maxlength="33"/></th>
							</tr>
							<tr>
								<th>목적</th>
								<th class="popInput"><input type="text" name="assetOutPurpose" id="assetOutPurpose" maxlength="33"/></th>
							</tr>
							<tr>
								<th>비용</th>
								<th class="popInput"><input type="text" name="assetOutCost" id="assetOutCost" maxlength="15" onkeypress="return fn_press(event, 'numbers');" onkeydown="fn_press_han(this);"/></th>
							</tr>
							<tr>
								<th>반출/수리 이력<br>COMMENT</th>
								<th class="popInput"><textArea name="assetOutComment" id="assetOutComment" maxlength="1000"></textArea></th>
							</tr>
						</table>
					</div>
					<input type="hidden" id="assetId" name="assetId" value="${assetData['assetVO']['assetId'] }"/>
					<input type="button" class="btn btn-primary" id="popSubmit" style="margin-right:20px;" value="제출"/>
					<input type="button" class="btn btn-primary" id="popClose" style="margin-left:20px;" value="닫기"/>											
				</form>
				<div style="display: flex; float: left; margin-top: 5px; bottom: 60px; position: absolute">
					<img src="${pageContext.request.contextPath}/resources/mouseRightClick.png" width="25px" height="25px">
					&nbsp;&nbsp;Menu
				</div>
		    </div>
	    </div>
	</div>
</body>