<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
<meta name="description" content="">
<meta name="author" content="">

<title>이에스이 자산관리시스템</title>

<!-- Bootstrap core CSS -->
<link
	href="${pageContext.request.contextPath}/resources/css/bootstrap.css"
	rel="stylesheet">
<!-- Custom styles for this template -->
<link href="${pageContext.request.contextPath}/resources/css/signin.css"
	rel="stylesheet">
<script
	src="${pageContext.request.contextPath}/resources/js/jquery-2-1-1.min.js"></script>

<script type="text/javascript">

	function submitCheck() {
		if ($("#assetCategory").val() == '0') {
			alert("분류를 선택해주세요.");			
			return false;
		} else if($("#assetStatus").val()=='0'){
			alert("자산 상태를 선택해주세요.");
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
			return false;
		} else if($("#assetManager").val()==''){
			alert("책임자를 입력해주세요.");
			return false;
		} else if($("#assetLocation").val()=='0'){
			alert("사용 위치를 선택해주세요.");
			return false;
		} else {
			$("#registerSend").submit();
		}
	};

	$(function(){
		var isAdmin = "<%=session.getAttribute("isAdmin")%>";
		if(isAdmin == "TRUE"){
			$(".admin").show();
		}
	});
	
	$(function(){
		var left = $('#rank').height();
		var right = $('.dropdown').height();
		$('.dropdown').height(left);
	});
</script>
<style>
.form-controlmin {
	  display: block;
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
	  -webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s;
	       -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
	          transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
	}

</style>
</head>

<body>
	<div style="text-align: center;" id="main">
		<form class="form" id="registerSend" method="POST" action="/assetmanager/assetRegister2">
			<h2 style="text-align: center">자산 정보 입력</h2>
			자산 공통사항
			<div style="display: flex; margin-left: 90px">
				<table class="table table-striped">
					<tr>
						<th>분류</th>
						<th><select class="form-controlmin dropdown" id="assetCategory" name="assetCategory">
								<option value="0">분류를 선택하세요.</option>
								<option value="모니터">모니터</option>
								<option value="데스크탑">데스크탑</option>
								<option value="노트북">노트북</option>
								<option value="서버">서버</option>
								<option value="SoftWare">SoftWare</option>
								<option value="IP Wall">IP Wall</option>
								<option value="프린터">프린터</option>
								<option value="책상">책상</option>
								<option value="의자">의자</option>
								<option value="책">책</option>
								<option value="기타">기타</option>
						</select></th>
						<th>이름</th>
						<input type="hidden" value="<%=session.getAttribute("Id") %>" name="assetUser" id="assetUser">
						<th><%=session.getAttribute("Id") %></th>
					</tr>
					<tr>
						<th>관리 번호</th>
						<th>※ 자동 생성됩니다.</th>
						<th>자산 상태</th>
						<th><select class="form-controlmin dropdown" id="assetStatus" name="assetStatus">
								<option value="0">상태를 선택하세요.</option>
								<option value="사용 중">사용 중</option>
								<option value="사용 가능">사용 가능</option>
								<option value="사용 불가">사용 불가</option>
								<option value="폐기">폐기</option>
						</select></th>
					</tr>
					<tr>
						<th>시리얼 번호</th>
						<th><input type="text" id="assetSerial" name="assetSerial"></th>
						<th>구입일</th>
						<th><input type="text" id="assetPurchaseDate" name="assetPurchaseDate"></th>
					</tr>
					<tr>
						<th>제조사</th>
						<th><input type="text" id="assetMaker" name="assetMaker"></th>
						<th>구입가</th>
						<th><input type="text" id="assetPurchasePrice" name="assetPurchasePrice"></th>
					</tr>
					<tr>
						<th>모델명</th>
						<th><input type="text" id="assetModel" name="assetModel"></th>
						<th>구입처</th>
						<th><input type="text" id="assetPurchaseShop" name="assetPurchaseShop"></th>
					</tr>
					<tr>
						<th>용도</th>
						<th><select class="form-controlmin dropdown" id="assetUsage" name="assetUsage">
								<option value="0">용도를 선택하세요.</option>
								<option value="개발용">개발용</option>
								<option value="업무용">업무용</option>
						</select></th>
						<th>책임자</th>
						<th><input type="text" id="assetManager" name="assetManager"></th>
					</tr>
					<tr>
						<th>사용 위치</th>
						<th><select class="form-controlmin dropdown" id="assetLocation" name="assetLocation">
								<option value="0">위치를 선택하세요.</option>
								<option value="4층">4층</option>
								<option value="5층">5층</option>
						</select></th>
					</tr>
				</table>
			</div>
			

			<div style="display: flex; width: 300px; margin-left: 90px">
				<input type="button" class="btn btn-lg btn-primary btn-block"
					id="registerBtn" onclick="submitCheck();" value="회원가입" /> <label
					style="opacity: 0; margin: 10px"></label> <input type="button"
					class="btn btn-lg btn-primary btn-block"
					onclick="location.href='/assetmanager/assetList'" value="취소" />
			</div>
		</form>
	</div>
</body>