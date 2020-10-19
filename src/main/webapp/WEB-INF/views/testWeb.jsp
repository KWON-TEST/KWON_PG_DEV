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

		<tr>
			<td>가맹점 아이디</td>
			<td>
				<input type="text" name="mid" id="mid" value="mid_test">
			</td>
		</tr>
	
		<tr>
			<td>VAN</td>
			<td>
				<select class="form-control" id="van">
					<option value="KSNET" data-val="KSNET">KSNET</option>
					<option value="NICE" data-val="NICE">NICE</option>
					<option value="KCP" data-val="KCP">KCP</option>
					<option value="JTNET" data-val="JTNET">JTNET</option>
				</select>
			</td>
		</tr>

		<tr>
			<td>가맹점 주문번호</td>
			<td>
				<input type="text" name="orderNo" id="orderNo" value="">
			</td>
		</tr>
		
		<tr>
			<td>결제금액</td>
			<td>
				<input type="text" name="amt" id="amt" value="1004">
			</td>
		</tr>
		
		<tr>
			<td>부가세</td>
			<td>
				<input type="text" name="tax" id="tax" value="0">
			</td>
		</tr>
		
		<tr>
			<td>봉사료</td>
			<td>
				<input type="text" name="serviceFee" id="serviceFee" value="0">
			</td>
		</tr>
		
		<tr>
			<td>주문자명</td>
			<td>
				<input type="text" name="ordNm" id="ordNm" value="홍길동">
			</td>
		</tr>
	
		<tr>
			<td>구매상품정보</td>
			<td>
				<input type="text" name="prdtNm" id="prdtNm" value="테스트상품">
			</td>
		</tr>

		<tr>
			<td>NOTI URL</td>
			<td>
				<input type="text" name="notiUrl" id="notiUrl" value="http://www.mtouch.com/">
			</td>
		</tr>

		<tr>
			<td>NEXT URL</td>
			<td>
				<input type="text" name="nextUrl" id="nextUrl" value="http://www.mtouch.com/">
			</td>
		</tr>

		<tr>
			<td>주문자 전화번호</td>
			<td>
				<input type="text" name="payerTel" id="payerTel" value="010-1234-1234">
			</td>
		</tr>

		<tr>
			<td>주문자 휴대폰번호</td>
			<td>
				<input type="text" name="payerTel" id="payerMobileNo" value="010-1234-1234">
			</td>
		</tr>
		
		<tr>
			<td>주문자 이메일</td>
			<td>
				<input type="text" name="email" id="email" value="dev@dev.com">
			</td>
		</tr>

		<div class="form-group" style="text-align:center;">
			<div class="col-sm-offset-1 col-sm-10" id="btnPay">
				<button type="button" id="btnPay" onclick="cardPay()">카드결제</button>
			</div>
	  	</div>
	</form>
</body>
</html>