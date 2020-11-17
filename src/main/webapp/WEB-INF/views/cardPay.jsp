<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    
    <title>KWON 테스트 결제서비스</title>
    
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
	    	
	    	//카드사 선택
		    $(".cardInfo").click(function(){
				interestList($(this).val(),$(this).attr("alt"));
				$("#selCardGb").val("");
				$("#cardGb").val($(this).val());

				appCardType($(this).val());
			});
			
		  //카드사 기타 선택
			$("#selCardGb").change(function(){
				interestList($("#selCardGb option:selected").val(),$("#selCardGb option:selected").attr("alt"));
				$(".cardInfo").prop("checked", false);
				$("#cardGb").val($(this).val());

				appCardType($(this).val());
			});
			
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
				if($("#cardGb").val() == ""){
					layerAlert("카드를 선택해주세요.");
					return;
				};
				
				if($("#instMon").val() == null || $("#instMon").val() == ""){
					layerAlert("할부기간을 선택해주세요.");
					$("#instMon").focus();
					return;
				}
				
				if(fName != null){
					$("#" + fName).remove();
				}
				
				fName = createFrame();
				
				openLayer();
				
				$("#settlePayLayer").show();
				$("#_method").val("cardAuth");
				$("#orderForm").attr("target", fName);
				$("#orderForm").attr("action", "${pageContext.request.contextPath}/cardAuth");
				$("#orderForm").submit();
			});
	    });
	    
	    //앱카드 노출관련
	    function appCardType(code){
	    	$("#PCardTypeChk").prop("checked", false);
	    	if(code=="1005" || code=="1004" || code=="1008" || code=="1002" || code=="1015"){
	    		$("#appCardType").show();
	    	}else{
	    		$("#appCardType").hide();
	    	}
	    }
	    
	    function initSelectCard(cardGb){
	    	$("input:radio[name=ra01]:input[value="+cardGb+"]").prop("checked", true);
	    	$("#selCardGb").val(cardGb);	
	    	
	    	if($('input:radio[name=ra01]:checked').val() != null){
	    		$("#cardGb").val($('input:radio[name=ra01]:checked').val());
	    	}else{
	    		$("#cardGb").val($("#selCardGb").val());
	    	}
	    	interestList(cardGb, $("#cardGb").attr("alt"));
	    }
	    
	    //카드사 선택에 따른 할부개월 세팅
	    function interestList(code, aquCode){
	    	if($("#instMon").prop("type") == "select-one"){
	    		$("#instMon").empty();
	    		$("#instMon").append($("<option></option>").attr("value", "0").text("일시불"));

	    		var installment = [{"cardCode":"1005","installmentInfo":"2:3:4:5"},{"cardCode":"1015","installmentInfo":"2:3:4:5:6:7:8"},{"cardCode":"1009","installmentInfo":"2:3:4:5:6:7"},{"cardCode":"1008","installmentInfo":"2:3:4:5:6"},{"cardCode":"1004","installmentInfo":"2:3:4"},{"cardCode":"1003","installmentInfo":"2:3"},{"cardCode":"1002","installmentInfo":"2:3:4:5"},{"cardCode":"1001","installmentInfo":"2:3:4:5:6:7:8:9:10:11:12"},{"cardCode":"2001","installmentInfo":"2:3:4:5:6:7:8:9"}];
	    		
	    		$.each(installment, function(key,value){
	    			if(aquCode == value.cardCode){
	    				if(value.installmentInfo!="" && value.installmentInfo!=null){
	    					var instMonArr = value.installmentInfo.split(":");
	    					for(var i=0; i<instMonArr.length; i++){
	    						$("#instMon").append($("<option></option>").attr("value", instMonArr[i]).text(instMonArr[i]+"개월"));
	    					}
	    				}
	    			}
	    		});
	    		
	    		var options = [];
	    		$.each(options, function(key, value){
	    			if(code == value.cardCd){
	    				var interestText = value.interestFreeMon+"개월(무)";
	    				if(value.partInterestFreeYn == "Y"){
	    					interestText = value.interestFreeMon+"개월("+value.partInterestInfo+"회차 부분 무)";
	    				}

	    				$("#instMon").find("option[value='" + value.interestFreeMon + "']").text(interestText);
	    				$("#instMon").find("option[value='" + value.interestFreeMon + "']").attr("title", value.memo);
	    			}
	    		});
	    	}
	    }
	    
	    function createFrame(){
	    	var frameNm = "SETTLE_PAY_" + Math.floor(Math.random() * 100000);
	    	var settleFrame = document.createElement("iframe");
	    	settleFrame.id = frameNm;
	    	settleFrame.name = frameNm;
	    	settleFrame.scrolling = "no";
	    	$(document.body).append(settleFrame);
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
	    	var settleLay = document.createElement("div");
	    	settleLay.id = "settlePayLayer";
	    	if($("#settlePayLayer")){
	    		$("#settlePayLayer").remove();
	    	}
	    	$(document.body).append(settleLay);
	    	$("#settlePayLayer").css("background-color", "#000");
	    	$("#settlePayLayer").css("opacity", "0.6");
	    	$("#settlePayLayer").css("z-index","8");
	    	$("#settlePayLayer").css("position", "absolute");
	    	$("#settlePayLayer").css("top", 0);
	    	$("#settlePayLayer").css("left", 0);
	    	$("#settlePayLayer").css("width", "100%");
	    	$("#settlePayLayer").css("height", "100%");
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
	    	
	    	$("#settlePayLayer").css("width", "100%");
	    	$("#settlePayLayer").css("height", "100%");
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
    </script>
</head>

<body>
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
		<input type="hidden" name="buyerEmail" id="buyerEmail" value="${orderInfo.buyerEmail}">
		<input type="hidden" name="trDt" id="trDt" value="${orderInfo.trDt}">
		<input type="hidden" name="stateCd" id="stateCd" value="${orderInfo.stateCd}">
		<input type="hidden" name="cardNo" id="cardNo" value="${orderInfo.cardNo}">
		<input type="hidden" name="cardYm" id="cardYm" value="${orderInfo.cardYm}">
		<input type="hidden" name="amt" id="amt" value="${orderInfo.amt}">
		<input type="hidden" name="tax" id="tax" value="${orderInfo.tax}">
		<input type="hidden" name="serviceFee" id="serviceFee" value="${orderInfo.serviceFee}">
		<input type="hidden" name="instMon" id="instMon" value="${orderInfo.instMon}">
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
	
	<form id="orderForm" name="orderForm" method="post">
		<c:choose>
			<c:when test="${orderInfo.resCode eq '0000'}">
				<div id="container">
				<!--결제카드 선택-->
		        <h2 id="h2_3">결제카드 선택</h2>
		        <!--선택_상세-->
		        <div class="box_detail" id="box_detail_3">
		          <div class="detail_g">
		            <div class="card">
			            <ul>
					       	<li>
				                <input type="radio" name="ra01" class="cardInfo" id="ra01_simple_0" value="2001" title="삼성페이" alt=""/>
				                <label for="ra01_simple_0">삼성페이</label>
				          	</li>
			              	<li>
				                <input type="radio" name="ra01" class="cardInfo" id="ra01_0" value="1001" title="비씨(페이북)" alt="1001"/>
				                <label for="ra01_0">비씨(페이북)</label>  
			                </li>
			              	<li>
				                <input type="radio" name="ra01" class="cardInfo" id="ra01_1" value="1002" title="국민" alt="1002"/>
				                <label for="ra01_1">국민</label>
				            </li>
			              	<li>
				                <input type="radio" name="ra01" class="cardInfo" id="ra01_2" value="1003" title="하나" alt="1003"/>
				                <label for="ra01_2">하나</label>    
			                </li>
			              	<li>
			              		<input type="radio" name="ra01" class="cardInfo" id="ra01_3" value="1004" title="삼성" alt="1004"/>
				            	<label for="ra01_3">삼성</label>  
			                </li>
			              	<li>
			                    <input type="radio" name="ra01" class="cardInfo" id="ra01_4" value="1005" title="신한" alt="1005"/>
			                    <label for="ra01_4">신한</label>
			                </li>
			              	<li>
			                    <input type="radio" name="ra01" class="cardInfo" id="ra01_5" value="1007" title="우리" alt="1001"/>
			                    <label for="ra01_5">우리</label>
		                	</li>
			              	<li>
			                    <input type="radio" name="ra01" class="cardInfo" id="ra01_6" value="1008" title="현대" alt="1008"/>
			                    <label for="ra01_6">현대</label>
		                	</li>
			              	<li>
			                    <input type="radio" name="ra01" class="cardInfo" id="ra01_7" value="1015" title="NH농협" alt="1015"/>
			                    <label for="ra01_7">NH농협</label>
		                	</li>
			              	<li>
			                    <input type="radio" name="ra01" class="cardInfo" id="ra01_8" value="1020" title="롯데" alt="1009"/>
			                    <label for="ra01_8">롯데</label>
		                	</li>
			              	<li>
			                    <input type="radio" name="ra01" class="cardInfo" id="ra01_9" value="1032" title="카카오뱅크" alt="1002"/>
			                    <label for="ra01_9">카카오뱅크</label>
		                	</li>
			              	<li>
			                    <input type="radio" name="ra01" class="cardInfo" id="ra01_10" value="1033" title="케이뱅크" alt="1001"/>
			                    <label for="ra01_10">케이뱅크</label>
		                	</li>
			                <li class="2sec">
			                  	<select style="width:110px;" name="cardEtc" id="selCardGb">
		                    		<option value="">그 외의 카드</option>
				                	<option value="1012" title="수협" alt="1001">수협</option>
				                	<option value="1016" title="제주" alt="1001">제주</option>
				                	<option value="1017" title="광주" alt="1001">광주</option>
				                	<option value="1018" title="전북" alt="1001">전북</option>
				                	<option value="1026" title="씨티" alt="1001">씨티</option>
				                	<option value="1027" title="KB증권(구,현대증권)" alt="1002">KB증권(구,현대증권)</option>
				                	<option value="1028" title="저축은행" alt="1001">저축은행</option>
				                	<option value="1029" title="우체국" alt="1001">우체국</option>
				                	<option value="1030" title="신협" alt="1001">신협</option>
				                	<option value="1031" title="산업은행" alt="1001">산업은행</option>
			                    </select>
			                </li>
			              </ul>
		            </div>
		          </div>
		          <div class="detail_w">
		            <div class="it_detail"> 
		              <!--라디오버튼 선택에따른 상세(높이고정)-->
		              <div>
		                <div class="set" id="appCardType" style="display: none">
		                  <input type="checkbox" id="PCardTypeChk" name="PCardTypeChk"/>
		                  <label for="PCardTypeChk"> 앱카드로 결제</label>
		                </div>
		                <div class="set"> 
		                	<span class="label">할부기간</span> 
		                	<select name="instMon" id="instMon">
								<option value="00" selected>일시불</option>
							</select>
		                </div>
		                <div class="set">
		                	<p class="des_em" id="memo"></p>
		                </div>
		              </div>
		              <!--//라디오버튼 선택에따른 상세(높이고정)--> 
		            </div>
		            <div class="it_input">
		              <div class="set"> <span class="label">이메일</span>
		                <input type="text" style="width:300px;" name="email" id="email" value="" placeholder="입력 시 결제내역 통보 메일이 발송됩니다." />
		              </div>
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