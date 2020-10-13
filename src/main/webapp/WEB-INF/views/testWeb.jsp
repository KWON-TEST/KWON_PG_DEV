<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
	Date nowTime = new Date();
	SimpleDateFormat sf = new SimpleDateFormat("yyMMddhhmmss");

	orderNo = sf.format(nowTime);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
    <title>신규PG 테스트 페이지</title>

	<style>
		form { margin: 0 auto; width:250px; }
	</style>
</head>
<body>

<h3 class="text-center">신규PG 테스트 페이지</h3>

	<form name="form1" class="form-horizontal" style="width:50%;">
		<br>
		<div class="form-group">
			<h4 class="text-center">결제 파라미터</h4>
		</div>

		<div class="form-group">
			<label for="van" class="col-sm-2 control-label">VAN</label>
			<div class="col-sm-10">
				<select class="form-control" id="van">
					<option value="KSNET" data-val=""KSNET"">"KSNET"</option>
					<option value="NICE" data-val="NICE">NICE</option>
					<option value="KCP" data-val="KCP">KCP</option>
					<option value="JTNET" data-val="JTNET">JTNET</option>
				</select>
			</div>
		</div>

		<div class="form-group">
			<label for="trackId" class="col-sm-2 control-label">가맹점 주문번호</label>
			<div class="col-sm-10">
				<input type="text" name="orderNo" id="orderNo" value=orderNo class="form-control">
			</div>
		</div>
		
		<div class="form-group">
			<label for="amount" class="col-sm-2 control-label">결제금액</label>
			<div class="col-sm-10">
				<input type="text" name="amt" id="amt" value="1004" class="form-control" placeholder="amount">
			</div>
		</div>

		<div class="form-group">
			<label for="product" class="col-sm-2 control-label">구매상품정보</label>
			<div class="col-sm-10">
				<textarea class="form-control" id="product" style="width:100%;">{"name": "T-Shirts","price": "900","qty": 1,"desc": "description"}</textarea>
			</div>
		</div>

		<div class="form-group">
			<label for="webhook" class="col-sm-2 control-label">NOTI URL</label>
			<div class="col-sm-10">
				<input type="text" name="notiUrl" id="notiUrl" value="http://www.mtouch.com/" class="form-control">
			</div>
		</div>

		<div class="form-group">
			<label for="webhook" class="col-sm-2 control-label">NEXT URL</label>
			<div class="col-sm-10">
				<input type="text" name="nextUrl" id="nextUrl" value="http://www.mtouch.com/" class="form-control">
			</div>
		</div>
		
		<div class="form-group">
			<label for="payerName" class="col-sm-2 control-label">구매자 이름</label>
			<div class="col-sm-10">
				<input type="text" name="payerName" id="payerName" value="구매자" class="form-control">
			</div>
		</div>

		<div class="form-group">
			<label for="payerTel" class="col-sm-2 control-label">구매자 전화번호</label>
			<div class="col-sm-10">
				<input type="text" name="payerTel" id="payerTel" value="010-1234-1234" class="form-control">
			</div>
		</div>

			<div class="form-group">
			<label for="payerTel" class="col-sm-2 control-label">구매자 휴대폰번호</label>
			<div class="col-sm-10">
				<input type="text" name="payerTel" id="payerMobileNo" value="010-1234-1234" class="form-control">
			</div>
		</div>
		
		<div class="form-group">
			<label for="payerEmail" class="col-sm-2 control-label">구매자 이메일</label>
			<div class="col-sm-10">
				<input type="text" name="payerEmail" id="payerEmail" value="dev@dev.com" class="form-control">
			</div>
		</div>

		<div class="form-group" style="text-align:center;">
			<div class="col-sm-offset-1 col-sm-10" id="btnPay">
				<button type="button" class="btn btn-default" id='cardPayBtn' onclick="javascript:cardPay();">카드결제</button>
			</div>
	  	</div>
	</form>

    <script>
	//카드결제
    function javascript:cardPay() {
		var products = [];
		var product = $('#product').val().replace(/\n/gi, "");
		products.push(JSON.parse(product));
	}
	</script>
</body>
</html>