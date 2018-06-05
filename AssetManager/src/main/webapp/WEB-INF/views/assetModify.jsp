<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script>
	$(document).ready(
			function() {
				$("#assetStatus").val("${requestScope.assetVO.assetStatus}")
						.prop("selected", true);
				$("#assetOutStatus").val(
						"${requestScope.assetVO.assetOutStatus}").prop(
						"selected", true);
				$("#assetUsage").val("${requestScope.assetVO.assetUsage}")
						.prop("selected", true);
				$("#assetManager").val("${requestScope.assetVO.assetManager}")
						.prop("selected", true);
				$("#assetLocation")
						.val("${requestScope.assetVO.assetLocation}").prop(
								"selected", true);

			})
	function cancelConfirm() {
		if (!confirm("취소하겠습니까?")) {
			return false;
		} else {
			$("#idForm").submit();
		}
	}
	function modifyConfirm() {
		if (!confirm("수정하겠습니까?")) {
			return false;
		} else {
			$("#modifySend").submit();
		}
	}
</script>
<style>
</style>

</head>
<body>
	<div class="container-fluid">
		<div class="row">
			<div class="main">
				<form class="form" action="/assetmanager/assetModifySend"
					id="modifySend" method="POST" enctype="multipart/form-data">
					<h1 class="page-header">
						<b>자산 관리 > ${requestScope.assetVO.assetId}의 자산 정보 수정</b>
					</h1>
					<div class="table-responsive" id="inputDiv"
						style="overflow: scroll; height: 500px;">
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
								<th>시리얼 번호</th>
								<th><input type="text" id="assetSerial" name="assetSerial"
									value="${requestScope.assetVO.assetSerial}"></th>
							</tr>
							<tr>
								<th>자산 상태</th>
								<th><select class="form-controlmin dropdown"
									id="assetStatus" name="assetStatus">
										<option value="0">상태를 선택하세요.</option>
										<option value="사용 중">사용 중</option>
										<option value="사용 가능">사용 가능</option>
										<option value="사용 불가">사용 불가</option>
										<option value="폐기 대기">폐기 대기</option>
										<option value="폐기">폐기</option>
								</select></th>
								<th>자산 반출 상태</th>
								<th><select class="form-controlmin dropdown"
									id="assetOutStatus" name="assetOutStatus">
										<option value="0">반출 상태를 선택하세요.</option>
										<option value="없음">반출 X</option>
										<option value="반출 중">반출 중</option>
										<option value="수리 중">수리 중</option>
										<option value="고장">고장</option>
								</select></th>
							</tr>
							<tr>
								<th>구입일</th>
								<th><input type="text" id="assetPurchaseDate"
									name="assetPurchaseDate"
									value="${requestScope.assetVO.assetPurchaseDate}"></th>
								<th>제조사</th>
								<th><input type="text" id="assetMaker" name="assetMaker"
									value="${requestScope.assetVO.assetMaker}"></th>
							</tr>
							<tr>
								<th>구입가</th>
								<th><input type="text" id="assetPurchasePrice"
									name="assetPurchasePrice"
									value="${requestScope.assetVO.assetPurchasePrice}"></th>
								<th>모델명</th>
								<th><input type="text" id="assetModel" name="assetModel"
									value="${requestScope.assetVO.assetModel}"></th>
							</tr>
							<tr>
								<th>구입처</th>
								<th><input type="text" id="assetPurchaseShop"
									name="assetPurchaseShop"
									value="${requestScope.assetVO.assetPurchaseShop}"></th>
								<th>용도</th>
								<th><select class="form-controlmin dropdown"
									id="assetUsage" name="assetUsage">
										<option value="0">용도를 선택하세요.</option>
										<option value="개발용">개발용</option>
										<option value="업무용">업무용</option>
								</select></th>
							</tr>
							<tr>
								<th>책임자</th>
								<th><select class="form-controlmin dropdown"
									name="assetManager" id="assetManager">
										<option value="0">책임자를 선택하세요.</option>
										<c:forEach items="${employeeNameList}" var="employee">
											<option value="${employee}">${employee}</option>
										</c:forEach>
								</select></th>
								<th>사용 위치</th>
								<th><select class="form-controlmin dropdown"
									id="assetLocation" name="assetLocation">
										<option value="0">위치를 선택하세요.</option>
										<option value="4층">4층</option>
										<option value="5층">5층</option>
								</select></th>
							</tr>
						</table>
						<h3>자산 세부사항</h3>
						<table class="table table-striped">
							<c:forEach items="${assetDetailList}" varStatus="i" step="2">
								<tr>
									<th>${assetDetailList[i.index].assetItem}</th>
									<th><input type="text" id="assetItemDetail"
										name="assetItemDetail"
										value="${assetDetailList[i.index].assetItemDetail}"></th>
									<th>${assetDetailList[i.index+1].assetItem}</th>
									<th><input type="text" id="assetItemDetail"
										name="assetItemDetail"
										value="${assetDetailList[i.index+1].assetItemDetail}">
									</th>
								</tr>
							</c:forEach>
						</table>
						<div>
							<h3>영수증 사진</h3>
							<img style="width: 400px; height: 400px;"
								src="${pageContext.request.contextPath}/resources/${requestScope.assetVO.assetReceiptUrl}">
							<h3>자산 코멘트</h3>
							<text border="0" readonly>${requestScope.assetVO.assetComment}</text>
						</div>
					</div>
					</form>
					<form id="modifyForm" action="userModify" method="POST">
						<input type="hidden" name="assetId"
							value="${requestScope.assetVO.assetId}" />
					</form>
					<input type="button" class="btn btn-lg btn-primary"
						onclick="location.href='/assetmanager/assetList'" value="목록" />
					<div style="display: flex; float: right">
						<button class="btn btn-lg btn-primary" style="margin-right: 10px"
							onclick="modifyConfirm();">수정</button>
						<button class="btn btn-lg btn-primary" id="delbtn"
							onclick="cancelConfirm();">취소</button>
						<div class="mask"></div>
					</div>
			</div>
		</div>
	</div>

</body>
