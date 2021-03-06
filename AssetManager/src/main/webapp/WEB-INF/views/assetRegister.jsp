<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<script src="${pageContext.request.contextPath}/resources/js/jquery-3.1.0.min.js"></script>
	<link href="${pageContext.request.contextPath}/resources/css/bootstrap.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/dashboard.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/resources/css/jquery-ui-1-12-1.min.css" rel="stylesheet"/>  
	<script src="${pageContext.request.contextPath}/resources/js/jquery-ui-1-12-1.min.js"></script>
	
<script type="text/javascript">
	var counts = 0;
	var selectedFile;
	
	$(function(){
		// 사이드바 활성화
		$("#asstLink").prop("class", "active");
		
		$("#assetUser").val("${sessionScope.Id}").prop("selected", true);
		
		// 이미지 업로드
		$("#uploadImage").on("change", handleImgFileSelect);
		
		// 반출수리 팝업
		$("#popSubmit").click(function(){
			$("#pop").hide();
			$("#assetOutStatus").closest("tr").after('<tr><th>반출/수리 대상</th><th id="newOutObjective"></th><th>반출/수리 목적</th><th id="newOutPurpose"></th></tr><tr><th>반출/수리 비용</th><th id="newOutCost"></th><th>반출/수리 주석</th><th id="newOutComment"></th></tr>');
//			$("#popTable tr:last").after('<tr><th><input type="hidden" id="assetOutStatus" name="assetOutStatus" value="'+$("#assetOutStatus option:selected").val()+'"></th></tr>');
			$("#newOutObjective").text($("#assetOutObjective").val());
			$("#newOutPurpose").text($("#assetOutPurpose").val());
			$("#newOutCost").text($("#assetOutCost").val());
			$("#newOutComment").text($("#assetOutComment").val());
			$("#assetOutStatus").css("background","lightgray");
			$("#assetOutStatus").attr("disabled",true);
		});
		
		$('#assetOutStatus').change(function(){
			var state = $('#assetOutStatus option:selected').val();
				if(state == '반출 중'|| state=='수리 중') {
					$("#pop").show();
				} else {
					$("#pop").hide();
				}			 
		});
		
		// 권한별 버튼 보이기
		var isAdmin = "<%=session.getAttribute("isAdmin")%>";
		if (isAdmin == "TRUE") {
			$(".admin").show();
		}

		// 드롭다운 높이 설정
		var left = $('#rank').height();
		var right = $('.dropdown').height();
		$('.dropdown').height(left);

		// 반응성 윈도우 크기
		var windowHeight = window.innerHeight;
		$(".table-responsive").css("height", windowHeight - 300);
		$(window).resize(function() {
			windowHeight = $(window).height();
			$(".table-responsive").css("height", windowHeight - 300);
		});

    	// 달력
        $("#assetPurchaseDate").datepicker({
			dateFormat : "yy-mm-dd",
			dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], 
			monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
			changeMonth: true, 
			changeYear: true,
			nextText: '다음 달',
			prevText: '이전 달' 
        });
        
        // 표 세로 가운데 정렬
		$("th").css("vertical-align", "middle");
	});
	
	function getCategoryDetailItem(){
		var plusCount = 1;
		$.ajax({
			"type":"POST",
			"url":"getCategoryDetailItem",
			"dataType":"text",
			"data":{
				assetCategory : $("#assetCategory option:selected").val()
			},
			"beforeSend" : function(b){
				$("#assetDetailTable tr:gt(0)").remove();
			},
			"success" : function(a){
				a = a.split("\"},{\"assetCategory\":null,\"assetItem\":\"");
				a[0] = a[0].split("{\"assetCategory\":null,\"assetItem\":\"")[1];
				a[a.length-1] = a[a.length-1].split("\"}]")[0];
				
				counts = a.length;
				for(var i=0;i<a.length;i++){
					if(plusCount % 2 == 1){
						$("#assetDetailTable tr:last").after('<tr><th><input type="hidden" id="assetItem" name="assetItem" value="'+a[i]+'">'+a[i]+'</th><th><input type="text" id="assetItemDetail" name="assetItemDetail" maxlength="33"></th></tr>');
					} else{
						$("#assetDetailTable tr:last th:last").after('<th><input type="hidden" id="assetItem" name="assetItem" value="'+a[i]+'">'+a[i]+'</th><th><input type="text" id="assetItemDetail" name="assetItemDetail" maxlength="33"></th>');
					}
						
						plusCount += 1;
				}
				console.log(items);
			},
			"error":function(){
				alert("에러");
			}					
		});
	}
	
	function submitCheck() {
		if (!confirm("등록하시겠습니까?")) {
			return false;
		} else {
		var items = [];
		var itemsDetail=[];
		for(var i=0;i<counts;i++){
			items.push($("th input[id='assetItem']:eq("+i+")").val());
			itemsDetail.push($("th input[id='assetItemDetail']:eq("+i+")").val());			
		}
		$("#items").val(items);
		$("#itemsDetail").val(itemsDetail);
		
		if ($("#assetCategory").val() == '0') {
			alert("분류를 선택해주세요.");
			$("#assetCategory").focus();
			return false;
		} else if($("#assetUser").val()=='0'){
			alert("이름을 선택해주세요.");
			$("#assetUser").focus();
			return false;
		} else if($("#assetSerial").val()==''){
			alert("시리얼 번호를 입력해주세요.");
			$("#assetSerial").focus();
			return false;
		} else if($("#assetStatus").val()=='0'){
			alert("자산 상태를 선택해주세요.");
			$("#assetStatus").focus();
			return false;
		} else if($("#assetOutStatus").val()=='0'){
			alert("자산 반출 상태를 선택해주세요.");
			$("#assetOutStatus").focus();
			return false;
		} else if($("#assetMaker").val()==''){
			alert("제조사를 입력해주세요.");
			$("#assetMaker").focus();
			return false;
		} else if($("#assetModel").val()==''){
			alert("모델명을 입력해주세요.");
			$("#assetModel").focus();
			return false;
		} else if($("#assetUsage").val()=='0'){
			alert("용도를 선택해주세요.");
			$("#assetUsage").focus();
			return false;
		} else if($("#assetManager").val()=='0'){
			alert("책임자를 선택해주세요.");
			$("#assetManager").focus();
			return false;
		} else if($("#assetLocation").val()=='0'){
			alert("사용 위치를 선택해주세요.");
			$("#assetLocation").focus();
			return false;
		} else {
			
			// 얘네는 not null이 아니기 때문에 미입력 시 default값 지정
			if($("#assetPurchaseDate").val()==''){
				$("#assetPurchaseDate").val("9999-01-01");
			}
			if($("#assetPurchasePrice").val()==''){
				$("#assetPurchasePrice").val("미입력");
			}
			if($("#assetPurchaseShop").val()==''){
				$("#assetPurchaseShop").val("미입력");
			}
			
			// 세부사항 유효성 검사
			for(var i=0;i<counts;i++){
				if($("th input[id='assetItemDetail']:eq("+i+")").val() ==''){
					alert(i+1+"번째 세부사항을 입력해주세요.");
					return false;
				}
			}
				$("#assetUser").prop("disabled",false);
				$("#assetOutStatus").prop("disabled",false);
				$("#registerSend").submit();
			}
		}
	};


	function byteCheck(obj, maxByte) {

		var str = obj.value;
		var strLength = str.length;

		var rbyte = 0;
		var rlen = 0;
		var oneChar = "";
		var str2 = "";

		for (var i = 0; i < strLength; i++) {
			oneChar = str.charAt(i);
			if (escape(oneChar).length > 4) {
				rbyte += 3;
			} else {
				rbyte++;
			}
			if (rbyte <= maxByte) {
				rlen = i + 1;
			}
		}

		if (rbyte > maxByte) {
			alert("글자를 초과했습니다.");
			str2 = str.substr(0, rlen);
			obj.value = str2;
			byteCheck(obj, maxByte);
		} else {
			document.getElementById('byteInfo').innerText = rbyte;
		}
	}


	function handleImgFileSelect(e) {

		var files = e.target.files;
		var filesArr = Array.prototype.slice.call(files);

		filesArr.forEach(function(f) {
			if (!f.type.match("image.*")) {
				alert("이미지 확장자만 가능합니다.");
				return false;
			}

			selectedFile = f;

			var reader = new FileReader();
			reader.onload = function(e) {
				$("#img").attr("src", e.target.result);
			}
			reader.readAsDataURL(f);
		});

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
    
    function popCloseBtn(){
    	$("#assetOutObjective").val(null);
		$("#assetOutPurpose").val(null);
		$("#assetOutCost").val(null);
		$("#assetOutComment").val(null);
		$("#assetOutStatus option:eq(0)").prop("selected",true);
	    $('#pop').hide();
    }
    
	// 등록, 수정 시 자산 상태를 사용 가능,불가능,폐기으로 했을 경우 -> 이름 disabled, 사용자없음 
	function changeFunc(){
		if($("#assetStatus option:selected").val() == "사용 가능"
				|| $("#assetStatus option:selected").val() == "사용 불가"
				|| $("#assetStatus option:selected").val() == "폐기"){
			$("#assetUser").prepend("<option value='NoUser'>사용자 없음</option>");
			$("#assetUser").val("NoUser").prop("selected",true);
			$("#assetUser").prop("disabled",true).css("background-color","lightgray"); 
		} else{
			if($("#assetUser").val()=="NoUser"){
				$("#assetUser option:first").remove();
			}
			$("#assetUser option:eq(0)").prop("selected", true);
			$("#assetUser").prop("disabled",false).css("background-color","white");
		}
	}
    
</script>
<style>
	#pop{
		width : 400px;
		height : 400px;
		background : #3d3d3d;
		color : #fff;
		position: absolute;
		top : 200px;
		right : 350px;
		text-align : center;
		border : 2px solid #000;
		display : none;
	}
	#popTable{
		margin-top: 40px;
		margin-left: 0px; 
	}
	.popInput{
		color : #3d3d3d;
		width : 50px;
		table-layout: fixed;
	}
	.form-controlmin {
		width: 60%;
		height: 32px;
		padding: 6px 12px;
		font-size: 14px;
		line-height: 1.42857143;
		color: #555;
		background-color: #fff;
		background-image: none;
		border: 1px solid #ccc;
		border-radius: 4px;
		-webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
		box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
		-webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow
			ease-in-out .15s;
		-o-transition: border-color ease-in-out .15s, box-shadow ease-in-out
			.15s;
		transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
	}
	.img_wrap {
		margin-top: 50px;
	}
	.img_wrap img {
		max-width: 100%;
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
	
	th:not(".ui-datepicker-week-end")
	th {
		height: 50px;
		width: 25%;
		vertical-align: middle;
	}
	th:nth-child(4n+1), th:nth-child(4n+3){
		font-weight: bold;
	}
	th:nth-child(4n+2), th:nth-child(4n+4){
		font-weight: normal;
	}
	hr {
		height: 1px;
		width: 100%;
		border: 1;
		background-color: gray;
		background-image: linear-gradient(to right, #ccc, #333, #ccc);
	}
	#button, #registerBtn{
		color: black;
		border-color: #999;
		background-color: #aaa;
		font-weight: bold;
	}
	#button:hover, #registerBtn:hover {
		color: white;
		background-color: #333;
	}
	.dropdown, input:not([type="button"]){
		width: 200px
	}
</style>
</head>

<body>
	<div class="main">
		<form class="form" action="/assetmanager/assetRegisterSend" id="registerSend" method="POST" enctype="multipart/form-data">
			<div class="page-header">
				<font size="6px"><b>자산 등록</b></font>
			</div>
			<div class="table-responsive" style="overflow: scroll;">
				<h3>자산 공통사항</h3><h5>( * : 필수 입력 사항 )</h5>
				<table class="table table-striped" id="assetTable">
					<tr>
						<th>분류 *</th>
						<th>
							<select class="form-controlmin dropdown" id="assetCategory" name="assetCategory" onchange="getCategoryDetailItem();">
								<option value="0" selected>분류를 선택하세요.</option>
								<c:forEach items="${list['categoryList']}" var="category">
									<option value="${category}">${category}</option>
								</c:forEach>
							</select>
						</th>
						<c:if test="${sessionScope.isAdmin != 'TRUE' }">
							<th>사용자 (변경불가)</th>
							<th>
								<select class="form-controlmin dropdown" style="background-color:lightgray;" name="assetUser" id="assetUser" disabled>
									<option value="0">책임자를 선택하세요.</option>
									<c:forEach items="${list['employeeNameList']}" var="employee">
										<option value="${employee.employee_id}">${employee.employee_name}(${employee.employee_department_string})</option>
									</c:forEach>
								</select>
							</th>
							</c:if>
							<c:if test="${sessionScope.isAdmin == 'TRUE' }">
							<th>사용자 *</th>
							<th>
								<select class="form-controlmin dropdown" name="assetUser" id="assetUser">
									<option value="0">책임자를 선택하세요.</option>
									<c:forEach items="${list['employeeNameList']}" var="employee">
										<option value="${employee.employee_id}">${employee.employee_name}(${employee.employee_department_string})</option>
									</c:forEach>
								</select>
							</th>
							</c:if>
						</tr>
					<tr>
						<th>관리 번호</th>
						<th>※ 자동 생성됩니다.</th>
						<th>시리얼 번호 *</th>
						<th><input type="text" id="assetSerial" name="assetSerial"/></th>
					</tr>
					<tr>
						<th>자산 상태 *</th>
							<th>
						<c:if test="${sessionScope.isAdmin == 'TRUE' }">
								<select class="form-controlmin dropdown" id="assetStatus" name="assetStatus" onchange="changeFunc();">
									<option value="0">상태를 선택하세요.</option>
									<option value="사용 중">사용 중</option>
									<option value="사용 가능">사용 가능</option>
									<option value="사용 불가">사용 불가</option>
									<option value="폐기 대기">폐기 대기</option>
									<option value="폐기">폐기</option>
								</select>
						</c:if>
						<c:if test="${sessionScope.isAdmin != 'TRUE' }">
							사용 중
							<input type="hidden" id="assetStatus" name="assetStatus" value="사용 중"/>
						</c:if>
							</th>
						<th>자산 반출 상태 *</th>
						<th>
							<select class="form-controlmin dropdown" id="assetOutStatus" name="assetOutStatus">
								<option value="0">반출 상태를 선택하세요.</option>
								<option value="반출 X">반출 X</option>
								<option value="반출 중">반출 중</option>
								<option value="수리 중">수리 중</option>
								<option value="고장">고장</option>
							</select>
						</th>
					</tr>
					<tr>
						<th>구입일</th>
						<th><input type="text" id="assetPurchaseDate" name="assetPurchaseDate" readonly></th>
						<th>제조사 *</th>
						<th><input type="text" id="assetMaker" name="assetMaker"></th>
					</tr>
					<tr>
						<th>구입가 (원)</th>
						<th><input type="text" id="assetPurchasePrice" name="assetPurchasePrice" maxlength="10" onkeypress="return fn_press(event, 'numbers');" onkeydown="fn_press_han(this);"></th>
						<th>모델명 *</th>
						<th><input type="text" id="assetModel" name="assetModel"></th>
					</tr>
					<tr>
						<th>구입처</th>
						<th><input type="text" id="assetPurchaseShop" name="assetPurchaseShop"></th>
						<th>용도 *</th>
						<th>
							<select class="form-controlmin dropdown" id="assetUsage" name="assetUsage">
								<option value="0">용도를 선택하세요.</option>
								<option value="개발용">개발용</option>
								<option value="업무용">업무용</option>
							</select>
						</th>
					</tr>
					<tr>
						<th>책임자 *</th>
						<th>
							<select class="form-controlmin dropdown" name="assetManager" id="assetManager">
								<option value="0">책임자를 선택하세요.</option>
								<c:forEach items="${list['employeeNameList']}" var="employee">
									<option value="${employee.employee_id}">${employee.employee_name} (${employee.employee_department_string})</option>
								</c:forEach>
							</select>
						</th>
						<th>사용 위치 *</th>
						<th>
							<select class="form-controlmin dropdown" id="assetLocation" name="assetLocation">
								<option value="0">위치를 선택하세요.</option>
								<option value="4층">4층</option>
								<option value="5층">5층</option>
							</select>
						</th>
					</tr>
				</table>
				<hr>
				<h3>자산 세부사항</h3><h5>( 모두 필수 입력 )</h5>
				<table class="table table-striped" id="assetDetailTable">
					<tr>
						<th>항목</th>
						<th>내용</th>
						<th>항목</th>
						<th>내용</th>
					</tr>
				</table>
				<input type="hidden" id="items" name="items">
				<input type="hidden" id="itemsDetail" name="itemsDetail">
				<hr>
				<h3>파일 업로드</h3>
				<input type="file" id="uploadImage" name="uploadImage">
				<div class="img_wrap">
					<img id="img" />
				</div>
				<hr>
				<div>
					<h3>자산 코멘트</h3>
					<textArea name="assetComment" id="assetComment" style="resize: none; width: 600px; height: 200px;" rows="10" cols="40" onKeyUp="javascript:byteCheck(this,'999')"></textArea>
					<span id="byteInfo">0</span> / 999 Byte
				</div>
			</div>
			<!-- 반출/수리 레이어 팝업 -->
			<div id="pop">
				<table id="popTable">
					<tr style="text-align:center;">
						<th>날짜</th>
						<th style="color:white;">&nbsp;&nbsp;오늘 날짜로 등록됩니다.</th>
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
						<th>자산 반출/수리 이력 COMMENT</th>
						<th class="popInput"><textArea name="assetOutComment" id="assetOutComment" maxlength="1000" cols="20" style="height:150px; resize:none;"></textArea></th>
					</tr>
				</table>
				<input type="button" id="popSubmit" style="margin:30px; background:#3d3d3d" value="등록"/>
				<input type="button" id="popClose" style="margin:30px; background:#3d3d3d" onclick="popCloseBtn();" value="취소"/>											
			</div>
		</form>
		
				
		<div style="display: flex; float: right; margin-top: 10px">
			<input type="button" class="btn btn-lg btn-primary" id="registerBtn" onclick="submitCheck();" value="등록" /> 
			&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" id="button" class="btn btn-lg btn-primary" onclick="location.href='/assetmanager/assetList'" value="취소" />
		</div>
	</div>
</body>
