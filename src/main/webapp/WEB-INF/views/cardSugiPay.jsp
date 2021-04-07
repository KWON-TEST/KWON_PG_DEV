<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    
    <title>KWON 테스트 카드 수기 결제서비스</title>
    
    <script src="//code.jquery.com/jquery.js"></script>
	<script type="text/javascript" src="https://www.vpay.co.kr/eISP/jquery-1.8.3.min.js"></script>
	<script language="javascript" src="https://www.vpay.co.kr/eISP/Wallet_layer_VP.js"></script>
	
    <script type="text/javascript">
    	var fName;
    	
	    $(document).ready(function(){
	    	$(document).bind("contextmenu selectstart dragstart", function(e){
	    		return false;
	    	});
	    		
	    	/* 마우스 우클릭 및 F5 ctl+r */
	    	$(document).keydown(function(e){
	    		key = (e) ? e.keyCode : event.keyCode;
	    		var t = document.activeElement;
	    		if(key == 8 || key == 116 || key == 17 || key == 82 || key == 18){
	    			if(key == 8 || key == 82){
	    				if(t.tagName != "INPUT"){
	    					if(e){
	    						e.preventDefault();
	    					}else{
	    						return false;
	    					}
	    				}
	    			}else{
	    				if(e){
	    					e.preventDefault();
	    				}else{
	    					return false;
	    				}
	    			}
	    		}
	    	});
	    	
	    	$(window).resize(function(){
	    		windowResize();
	    	});
	    	
	    	$("#orderForm").append($("#return_form").html());
	    	$("#return_form").remove();

			$("#btnOK").click(function(){
		    	var order_form = document.orderForm;
		    	
		        order_form.action = order_form.cancUrl.value;
		    	order_form.submit();
			});
			
			$("#btnCanc").click(function(){
				var order_form = document.orderForm;
				$("#_method").val("pay_cancel");
				$("#stateCd").val("0031");
				$("#resCode").val("9999");
				$("#resMsg").val("사용자 취소");

				$("#orderForm").attr("action", order_form.cancUrl.value);
				$("#orderForm").attr("target", "_self");
				$("#orderForm").submit();
			});
			
			$("#btnPay").click(function(){
				var order_form = document.orderForm;
				
				if($("#cardNo").val() == null || $("#cardNo").val() == ""){
					layerAlert("카드번호를 입력해주세요.");
					$("#cardNo").focus();
					return;
				}
				
				if($("#expMonth").val() == null || $("#expMonth").val() == ""){
					layerAlert("유효기간 월을 선택해주세요.");
					$("#expMonth").focus();
					return;
				}
				
				if($("#expYear").val() == null || $("#expYear").val() == ""){
					layerAlert("유효기간 년을 선택해주세요.");
					$("#expYear").focus();
					return;
				}
				
				if($("#instMon").val() == null || $("#instMon").val() == ""){
					layerAlert("할부기간을 선택해주세요.");
					$("#instMon").focus();
					return;
				}
				
				if(fName != null){
					$("#" + fName).remove();
				}
				
				//fName = createFrame();
				
				openLayer();

				$("#kwonPayLayer").show();
				$("#orderForm").attr("target", "_self");
				$("#orderForm").attr("action", "${pageContext.request.contextPath}/sugiPayProc");
				$("#orderForm").submit();
			});
	    });
	  
	    function init(){
	    	expMonthSetting();
	    	expYearSetting();
	    	interestList();
	    }
	    
	    //유효기간 월세팅
	    function expMonthSetting(){
	    	$("#expMonth").empty();
    		$("#expMonth").append($("<option></option>").attr("value", "").text("월선택"));
    		
	    	 for(var i=1; i<13; i++){	
	    		if(i == 10 || i == 11 || i == 12){
	    			$("#expMonth").append($("<option></option>").attr("value", i).text(i + "월"));
    			}else{
    				$("#expMonth").append($("<option></option>").attr("value", "0" + i).text(i + "월"));
    			}
	 		}
	    }
	    
	    //유효기간 년도 세팅
	    function expYearSetting(){
	    	var today = new Date();
	    	var nowYear = today.getFullYear();
	
	    	$("#expYear").empty();
    		$("#expYear").append($("<option></option>").attr("value", "").text("년선택"));
    		
	    	for(var i=0; i<11; i++){
	    		var expYearTxt = nowYear + i;
	    		var expYearVal = expYearTxt.toString().substr(2,4);

	 			$("#expYear").append($("<option></option>").attr("value", expYearVal).text(expYearTxt + "년"));
	 		}
	    }
	    
	    //할부개월 세팅
	    function interestList(){
    		$("#instMon").empty();
    		$("#instMon").append($("<option></option>").attr("value", "00").text("일시불"));
			
    		if($("#amt").val() >= 50000){
    			for(var i=2; i<13; i++){
        			if(i == 10 || i == 11 || i == 12){
        				$("#instMon").append($("<option></option>").attr("value", i).text(i + "개월"));
        			}else{
        				$("#instMon").append($("<option></option>").attr("value", "0" + i).text(i + "개월"));
        			}
     	 		}
    		}
	    }
	    
	    function createFrame(){
	    	var frameNm = "KWON_PAY_" + Math.floor(Math.random() * 100000);
	    	var kwonFrame = document.createElement("iframe");
	    	kwonFrame.id = frameNm;
	    	kwonFrame.name = frameNm;
	    	kwonFrame.scrolling = "no";
	    	$(document.body).append(kwonFrame);
	    	$("#"+frameNm).css("width", "0");
	    	$("#"+frameNm).css("height", "0");
	    	$("#"+frameNm).css("z-index","9");
	    	$("#"+frameNm).css("margin","0");
	    	$("#"+frameNm).css("overflow", "hidden");
	    	$("#"+frameNm).css("position", "absolute");
	    	$("#"+frameNm).attr("frameBorder","0");
	    	return frameNm;
	    }
	    
	    function openLayer(){
	    	var kwonLay = document.createElement("div");
	    	kwonLay.id = "kwonPayLayer";
	    	if($("#kwonPayLayer")){
	    		$("#kwonPayLayer").remove();
	    	}
	    	$(document.body).append(kwonLay);
	    	$("#kwonPayLayer").css("background-color", "#000");
	    	$("#kwonPayLayer").css("opacity", "0.6");
	    	$("#kwonPayLayer").css("z-index","8");
	    	$("#kwonPayLayer").css("position", "absolute");
	    	$("#kwonPayLayer").css("top", 0);
	    	$("#kwonPayLayer").css("left", 0);
	    	$("#kwonPayLayer").css("width", "100%");
	    	$("#kwonPayLayer").css("height", "100%");
	    }
	    
	    function closeLayer(){
	    	$("#" + fName).remove();
	    }
	    
	    function frameResize(width, height){
	    	$("#" + fName).css("width", width);
	    	$("#" + fName).css("height", height);
	    	windowResize();
	    }
	    
	    function windowResize(){
	    	var clientWidth = $(window).width()/2;
	    	var clientHeight = $(window).height()/2;
	    	
	    	$("#kwonPayLayer").css("width", "100%");
	    	$("#kwonPayLayer").css("height", "100%");
	    	$("#" + fName).css("left", Number(clientWidth) - Number($("#" + fName).width()/2));
	    	
	    	if(Number($("#" + fName).height()) < 630){
	    		$("#" + fName).css("top", Number(clientHeight) - Number($("#" + fName).height()/2));
	    	}else{
	    		$("#" + fName).css("top", 0);
	    	}

	    }
	    
	    function layerAlert(msg){
	    	alert(msg);
	    	
	    	/* openLayer();
	    	$("#confirmAlert").hide();
	    	$("#okAlert").show();
	    	$('.alert #alertMsg').text(msg);
	    	$('.alert').show(); */
	    }
	    
	    function inputMoveNumber(num) {
			if(isFinite(num.value) == false) {
				alert("카드번호는 숫자만 입력할 수 있습니다.");
				num.value = "";
				return false;
			}

			max = num.getAttribute("maxlength");

			if(num.value.length >= max) {
				num.nextElementSibling.focus();
			}
		}

    </script>
</head>

<body onload="init()">
	<FORM name="return_form" id="return_form" method="post">
		<input type="hidden" name="_method" id="_method" value="">
		<input type="hidden" name="trNo" id="trNo" value="${orderInfo.trNo}">
		<input type="hidden" name="mid" id="mid" value="${orderInfo.mid}">
		<input type="hidden" name="midNm" id="midNm" value="${orderInfo.midNm}">
		<input type="hidden" name="ordNo" id="ordNo" value="${orderInfo.ordNo}">
		<input type="hidden" name="prdtNm" id="prdtNm" value="${orderInfo.prdtNm}">
		<input type="hidden" name="prdtCd" id="prdtCd" value="${orderInfo.prdtCd}">
		<input type="hidden" name="ordNm" id="ordNm" value="${orderInfo.ordNm}">
		<input type="hidden" name="buyerId" id="buyerId" value="${orderInfo.buyerId}">
		<input type="hidden" name="buyerIp" id="buyerIp" value="${orderInfo.buyerIp}">
		<input type="hidden" name="trDt" id="trDt" value="${orderInfo.trDt}">
		<input type="hidden" name="stateCd" id="stateCd" value="${orderInfo.stateCd}">
		<input type="hidden" name="amt" id="amt" value="${orderInfo.amt}">
		<input type="hidden" name="tax" id="tax" value="${orderInfo.tax}">
		<input type="hidden" name="vat" id="vat" value="${orderInfo.vat}">
		<input type="hidden" name="serviceFee" id="serviceFee" value="${orderInfo.serviceFee}">
		<input type="hidden" name="apprNo" id="apprNo" value="${orderInfo.apprNo}">
		<input type="hidden" name="van" id="van" value="${orderInfo.van}">
		<input type="hidden" name="notiUrl" id="notiUrl" value="${orderInfo.notiUrl}">
		<input type="hidden" name="nextUrl" id="nextUrl" value="${orderInfo.nextUrl}">
		<input type="hidden" name="cancUrl" id="cancUrl" value="${orderInfo.cancUrl}">
		<input type="hidden" name="resCode" id="resCode" value="${orderInfo.resCode}">
		<input type="hidden" name="resMsg" id="resMsg" value="${orderInfo.resMsg}">
		<input type="hidden" name="cardGb" id="cardGb" value="">
	</FORM>

	<div>
		<div class="form-group">
			<h4 class="text-center">카드결제</h4>
		</div>
		<table border="0">
			<tr>
				<td>상품명</td>
				<td>
					${orderInfo.prdtNm}
				</td>
			</tr>
			<tr>
				<td>결제금액</td>
				<td>
					${orderInfo.amt}
				</td>
			</tr>
		</table>
	</div>
	<br>
	<form id="orderForm" name="orderForm" method="post">
		<c:choose>
			<c:when test="${orderInfo.resCode eq '0000'}">
				<div id="container">
		          <div class="detail_w">
		            <div class="it_input">
		              <div class="set"> <span class="label">카드번호</span>
		                <input type="text" style="width:138px;" name="cardNo" id="cardNo" value="" onKeyup="inputMoveNumber(this);" maxlength="16"//>
		              </div>
		            </div>
		            <br>
		            <div class="set"> 
	                	<span class="label">유효기간</span> 
	                	<select name="expMonth" id="expMonth">
							<option value="" selected>월선택</option>
						</select>
						<select name="expYear" id="expYear">
							<option value="" selected>년선택</option>
						</select>
		            </div>
		            <br>
		            <div class="set"> 
	                	<span class="label">할부기간</span> 
	                	<select name="instMon" id="instMon">
							<option value="00" selected>일시불</option>
						</select>
	                </div>
		          </div>
		        </div>
		        <!--//선택_상세--> 
		        <!--//결제카드 선택--> 
		        <br>
				<div class="form-group" style="text-align:center;">
					<button type="button" id="btnCanc" onclick="btnCanc()">취소</button>
					<button type="button" id="btnPay" onclick="btnPay()">결제</button>
			  	</div>
			 </c:when>
			 <c:otherwise>
				 <table border="0">
					<tr>
						<td>상태코드 : </td>
						<td>
							${orderInfo.stateCd}
						</td>
					</tr>
					<tr>
						<td>결과코드 : </td>
						<td>
							${orderInfo.resCode}
						</td>
					</tr>
					<tr>
						<td>결과메세지 : </td>
						<td>
							${orderInfo.resMsg}
						</td>
					</tr>
				 </table>
				 <br>
					<div class="form-group" style="text-align:center;">
						<button type="button" id="btnOK" onclick="btnOK()">확인</button>
				  	</div>
			 </c:otherwise>
		</c:choose>
	</form>
	
	<!--얼럿창-->
	<div class="alert" id="alert1" style="display:none;">
		<input type="hidden" name="media" id="media" value="PC"/>
		  <p class="tit">알림</p>
		  <p class="txt"><span id="alertMsg"></span></p>
		  <p class="btn_area"><span id="confirmAlert" style="display:none"><span id="alertCanc">취소</span><span id="alertOk">확인</span></span>
							  <span id="okAlert" style="display:block"><span id="alertOk">확인</span></span></p>
	</div>
</body>
</html>