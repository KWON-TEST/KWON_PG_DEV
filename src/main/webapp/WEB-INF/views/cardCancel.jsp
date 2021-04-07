<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
    <title>신규PG 취소 테스트 페이지</title>
    
    <script src="//code.jquery.com/jquery.js"></script>

    <script type="text/javascript">
	    var width = 350;
	    var height = 475;
	    var xpos = (screen.width - width) / 2;
	    var ypos = (screen.width - height) / 6;
	    var position = "top=" + ypos + ",left=" + xpos;
	    var features = position + ", width="+width+", height="+height+",toolbar=no, location=no"; 
		
	    function cardCancel() {
	    	var order_form = document.cancelForm;
	    	window.name = "KWONPG_CLIENT";
	    	wallet = window.open("", "KWONPG_WALLET", position + ", width="+720+", height="+630+",toolbar=no, location=no");

	    	order_form.target = "KWONPG_WALLET";
	        order_form.action = "${pageContext.request.contextPath}/cardCancel";

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

	    	document.orderForm.ordNo.value = "KWONPG_" + year.toString() + month.toString() + day.toString() + hours.toString() + mins.toString() + secs.toString(); 
	    }
    </script>
</head>

<body onload="on_load()">
<h3 class="text-center">신규PG 취소 테스트 페이지</h3>

	<form id="cancelForm" name="cancelForm" method="post" >
		<br>
		<div class="form-group">
			<h4 class="text-center">취소 파라미터</h4>
		</div>

		<table border="0">
			<tr>
				<td>원거래 거래번호</td>
				<td>
					<input type="text" name="orgTrNo" id="orgTrNo" value="">
				</td>
			</tr>
			
			<tr>
				<td>가맹점 주문번호</td>
				<td>
					<input type="text" name="ordNo" id="ordNo" value="">
				</td>
			</tr>
			2
			</tr>
			
			<tr>
				<td>원거래 승인번호</td>
				<td>
					<input type="text" name="orgApprNo" id="orgApprNo" value="">
				</td>
			</tr>
		
			<tr>
				<td>NEXT URL</td>
				<td>
					<input type="text" name="nextUrl" id="nextUrl" value="/result">
				</td>
			</tr>
		</table>
		<br>
		<div class="form-group" style="text-align:center;">
			<div class="col-sm-offset-1 col-sm-10" id="btnCancel">
				<button type="button" id="btnCancel" onclick="cardCancel()">취소</button> 
			</div>
	  	</div>
	</form>
</body>
</html>