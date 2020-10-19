<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
    <title>신규PG 테스트 페이지</title>
    
    <script src="//code.jquery.com/jquery.js"></script>

    <script type="text/javascript">
		//카드결제
	    function cardPay() {
	    	var order_form = document.orderForm;
	    	
	    	order_form.action = "${pageContext.request.contextPath}/cardPay";
	    	order_form.submit();
		}
	    
	    function on_load()
	    {
	    	curr_date = new Date();
	    	year = curr_date.getYear();
	    	month = curr_date.getMonth()+1;
	    	day = curr_date.getDate();
	    	hours = curr_date.getHours();
	    	mins = curr_date.getMinutes();
	    	secs = curr_date.getSeconds();
	    	
	    	if(month < 10){
	    		month = "0" + month;
	    	}
	    	
	    	if(day < 10){
	    		day = "0"+day;
	    	}

	    	document.orderForm.orderNo.value = "KWONPG_" + year.toString() + month.toString() + day.toString() + hours.toString() + mins.toString() + secs.toString(); 
	    }
    </script>
</head>

<body onload="on_load()">
<h3 class="text-center">신규PG 테스트 페이지</h3>

	<form id="orderForm" name="orderForm" method="post" >
		<br>
		<div class="form-group">
			<h4 class="text-center">결제 파라미터</h4>
		</div>

		<div class="form-group">
			<label for="mid" class="col-sm-2 control-label">가맹점 아이디</label>
			<div class="col-sm-10">
				<input type="text" name="mid" id="mid" value="mid_test" class="form-control">
			</div>
		</div>
	
		<div class="form-group">
			<label for="van" class="col-sm-2 control-label">VAN</label>
			<div class="col-sm-10">
				<select class="form-control" id="van">
					<option value="KSNET" data-val="KSNET">KSNET</option>
					<option value="NICE" data-val="NICE">NICE</option>
					<option value="KCP" data-val="KCP">KCP</option>
					<option value="JTNET" data-val="JTNET">JTNET</option>
				</select>
			</div>
		</div>

		<div class="form-group">
			<label for="orderNo" class="col-sm-2 control-label">가맹점 주문번호</label>
			<div class="col-sm-10">
				<input type="text" name="orderNo" id="orderNo" value="" class="form-control">
			</div>
		</div>
		
		<div class="form-group">
			<label for="amt" class="col-sm-2 control-label">결제금액</label>
			<div class="col-sm-10">
				<input type="text" name="amt" id="amt" value="1004" class="form-control">
			</div>
		</div>
		
		<div class="form-group">
			<label for="tax" class="col-sm-2 control-label">부가세</label>
			<div class="col-sm-10">
				<input type="text" name="tax" id="tax" value="0" class="form-control">
			</div>
		</div>
		
		<div class="form-group">
			<label for="serviceFee" class="col-sm-2 control-label">봉사료</label>
			<div class="col-sm-10">
				<input type="text" name="serviceFee" id="serviceFee" value="0" class="form-control">
			</div>
		</div>
		
		<div class="form-group">
			<label for="ordNm" class="col-sm-2 control-label">주문자명</label>
			<div class="col-sm-10">
				<input type="text" name="ordNm" id="ordNm" value="홍길동" class="form-control">
			</div>
		</div>
	
		<div class="form-group">
			<label for="prdtNm" class="col-sm-2 control-label">구매상품정보</label>
			<div class="col-sm-10">
				<input type="text" name="prdtNm" id="prdtNm" value="테스트상품" class="form-control">
			</div>
		</div>

		<div class="form-group">
			<label for="notiUrl" class="col-sm-2 control-label">NOTI URL</label>
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
			<label for="payerTel" class="col-sm-2 control-label">주문자 전화번호</label>
			<div class="col-sm-10">
				<input type="text" name="payerTel" id="payerTel" value="010-1234-1234" class="form-control">
			</div>
		</div>

			<div class="form-group">
			<label for="payerTel" class="col-sm-2 control-label">주문자 휴대폰번호</label>
			<div class="col-sm-10">
				<input type="text" name="payerTel" id="payerMobileNo" value="010-1234-1234" class="form-control">
			</div>
		</div>
		
		<div class="form-group">
			<label for="email" class="col-sm-2 control-label">주문자 이메일</label>
			<div class="col-sm-10">
				<input type="text" name="email" id="email" value="dev@dev.com" class="form-control">
			</div>
		</div>

		<div class="form-group" style="text-align:center;">
			<div class="col-sm-offset-1 col-sm-10" id="btnPay">
				<button type="button" id="btnPay" onclick="cardPay()">카드결제</button>
			</div>
	  	</div>
	</form>
</body>
</html>