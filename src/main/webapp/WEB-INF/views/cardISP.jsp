<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta http-equiv="X-UA-Compatible" content="ie=edge">
    
    <title>VP 플러그인 결제 페이지</title>
    
    <script type="text/javascript" src="https://www.vpay.co.kr/eISP/jquery-1.8.3.min.js"></script>
	<script language="javascript" src="https://www.vpay.co.kr/eISP/Wallet_layer_VP.js"></script>
	<script type='text/javascript' src='https://srcode.net/tcode/js/json2.js'></script>
	<script type='text/javascript' src='https://srcode.net/tcode/js/acpay2.js'></script>
    <script src="//code.jquery.com/jquery.js"></script>

    <script language="javascript">
	    $(document).ready(function(){
	    	$(document).bind("contextmenu selectstart dragstart", function(e){
	    		return false;
	    	});
	    		
	    	$(document).keydown(function(e){
	    		key = (e) ? e.keyCode : event.keyCode;
	    		
	    		var t = document.activeElement;
	    		if(key == 8 || key == 116 || key == 17 || key == 82 || key == 18){
	    			return false;
	    		}
	    	});

	    	window.parent.$("#kwonPayLayer").remove();
	    	parent.frameResize("100%", "100%");
	    	
	    	doACPAY2_Cancel();
	    	StartSmartUpdate();
	    	MakePayMessage(document.pay);
	    });

		function VP_Ret_Pay(ret) {
			$("#pay_info_form").append($("#return_form").html());
			$("#return_form").remove();
			
			$("#P_KVP_CARD_CODE").val($("#KVP_CARDCODE").val().substring(2,6));
			$("#P_KVP_NOINT").val($("#KVP_NOINT").val());
			$("#P_KVP_QUOTA").val($("#KVP_QUOTA").val());
			$("#P_VP_RET_SAVEPOINT").val($("#VP_RET_SAVEPOINT").val());
			$("#P_KVP_CARD_PREFIX").val($("#KVP_CARD_PREFIX").val());
			$("#P_KVP_CONAME").val(encodeURL($("#KVP_CONAME").val()));
			$("#P_KVP_SESSIONKEY").val(encodeURL($("#KVP_SESSIONKEY").val()));
			$("#P_KVP_ENCDATA").val(encodeURL($("#KVP_ENCDATA").val()));
			$("#P_KVP_PAYSET_FLAG").val($("#KVP_PAYSET_FLAG").val());
			$("#P_KVP_USING_POINT").val($("#KVP_USING_POINT").val());
			$("#P_KVP_RESERVED1").val($("#KVP_RESERVED1").val());
			$("#P_KVP_RESERVED2").val($("#KVP_RESERVED2").val());
			$("#P_KVP_RESERVED3").val($("#KVP_RESERVED3").val());
			$("#P_VP_CANCEL_CODE").val($("#VP_CANCEL_CODE").val());
			
			if(ret){
				// 인증정상
				$("#pay_info_form").attr("target", "_parent");
				$("#pay_info_form").attr("action", "${pageContext.request.contextPath}/ispPayProc");
				$("#pay_info_form").submit();
			}else{
				//인증실패
				parent.closeLayer();
			}
		}
		
		//결제 선택 팝업창을 닫았을 경우 호출 되는 함수
		function onACPAYCancel() {
			doACPAY2_Cancel();
			parent.layerAlert('결제가 취소 되었습니다.');
			parent.closeLayer();
		}
		
		//결제 도중 오류 발생 시 호출되는 함수
		function onACPAYError(code) {
			doACPAY2_Cancel(); // 결제팝업 초기화
			
			switch(code) {
				case 1001:	// 팝업 차단 설정이 되어 있는 경우
					alert('팝업 차단 설정 해제 후 다시 결제를 해 주십시오(1001)');
					break;
				case 2001:	// 인증 데이터 암호화 실패
					alert('인증 데이터 처리에 실패 하였습니다. 다시 시도해 주십시오(2001)');
					break;
				case 3001:	// 거래키 발급 실패
					alert('거래키 발급에 실패하였습니다. 다시 시도해 주십시오(3001)');
					break;
				case 3002:	// 인증 데이터 복호화 실패
					alert('인증 데이터 처리에 실패하였습니다. 다시 시도해 주십시오(3002)');
					break;
				case 9101:	// 결제 코드 발급 실패 - 시스템 오류
					alert('결제 코드 발급에 실패하였습니다. 다시 시도해 주십시오(9101)');
					break;
				case 9102:	// 결제 코드 발급 실패 - acpKey 복호화 오류
					alert('결제 코드 발급에 실패하였습니다. 다시 시도해 주십시오(9102)');
					break;
				case 9103:	// 결제 코드 발급 실패 - acpKey 타임아웃
					alert('결제 코드 발급에 실패하였습니다. 다시 시도해 주십시오(9103)');
					break;
				case 9104:	// 결제 코드 발급 실패 - acpReq 복호화 오류
					alert('결제 코드 발급에 실패하였습니다. 다시 시도해 주십시오(9104)');
					break;
				case 9105:	// 결제 코드 발급 실패 - Hash mac 불일치
					alert('결제 코드 발급에 실패하였습니다. 다시 시도해 주십시오(9105)');
					break;
				case 9106:	// 결제 코드 발급 실패 - acpReq json 형식 오류
					alert('결제 코드 발급에 실패하였습니다. 다시 시도해 주십시오(9106)');
					break;
				case 9199:	// 거래 코드 발급 실패 - 시스템 오류
					alert('거래 코드 발급에 실패하였습니다. 다시 시도해 주십시오(9199)');
					break;
				case 9201:	// 거래키 요청 실패 - 시스템 오류
					alert('거래키 요청에 실패하였습니다. 다시 시도해 주십시오(9201)');
					break;
				case 9202:	// 거래키 요청 실패 - 유효하지 않은 pollingToken (pollingToken 복호화 오류) 
					alert('거래키 요청에 실패하였습니다. 다시 시도해 주십시오(9202)');
					break;
				case 9203:	// 거래키 요청 실패 - 유효하지 않은 pollingToken (pollingToken 타임아웃)
					alert('거래키 요청에 실패하였습니다. 다시 시도해 주십시오(9203)');
					break;
				case 9204:	// 거래키 요청 실패 - 해당 결제코드가 유효하지 않습니다. (결제코드가 존재하지 않음)
					alert('거래키 요청에 실패하였습니다. 다시 시도해 주십시오(9204)');
					break;
				case 9205:	// 거래키 요청 실패 - 유효하지 않은 pollingToken (결제코드 불일치) 
					alert('거래키 요청에 실패하였습니다. 다시 시도해 주십시오(9205)');
					break;
				case 9206:	// 거래키 요청 실패 - 해당 결제코드의 거래시간이 만료 (결제코드 타임아웃)
					alert('결제 인증 시간이 만료되었습니다. 다시 시도해 주십시오(9206)');
					break;
				case 9207:	// 거래키 요청 실패 - 해당 결제코드는 처리완료 되었습니다. (이미 결제 완료 처리됨)
					alert('이미 결제된 코드입니다. 다시 시도해 주십시오(9207)');
					break;
				case 9299:	// 거래키 요청 실패 - 시스템 오류
					alert('거래키 요청에 실패하였습니다. 다시 시도해 주십시오(9299)');
					break;
				default:	// 기타 오류
					alert('결제 도중 오류가 발생하였습니다. 다시 시도해 주십시오('+code+')');
					break;
			}
		}
		
		function encodeURL(str){
		    var s0, i, s, u;
		    s0 = "";                // encoded str
		    for (i = 0; i < str.length; i++){   // scan the source
		        s = str.charAt(i);
		        u = str.charCodeAt(i);          // get unicode of the char
		        if (s == " "){s0 += "+";}       // SP should be converted to "+"
		        else {
		            if ( u == 0x2a || u == 0x2d || u == 0x2e || u == 0x5f || ((u >= 0x30) && (u <= 0x39)) || ((u >= 0x41) && (u <= 0x5a)) || ((u >= 0x61) && (u <= 0x7a))){       // check for escape
		                s0 = s0 + s;            // don't escape
		            }
		            else {                  // escape
		                if ((u >= 0x0) && (u <= 0x7f)){     // single byte format
		                    s = "0"+u.toString(16);
		                    s0 += "%"+ s.substr(s.length-2);
		                }
		                else if (u > 0x1fffff){     // quaternary byte format (extended)
		                    s0 += "%" + (0xf0 + ((u & 0x1c0000) >> 18)).toString(16);
		                    s0 += "%" + (0x80 + ((u & 0x3f000) >> 12)).toString(16);
		                    s0 += "%" + (0x80 + ((u & 0xfc0) >> 6)).toString(16);
		                    s0 += "%" + (0x80 + (u & 0x3f)).toString(16);
		                }
		                else if (u > 0x7ff){        // triple byte format
		                    s0 += "%" + (0xe0 + ((u & 0xf000) >> 12)).toString(16);
		                    s0 += "%" + (0x80 + ((u & 0xfc0) >> 6)).toString(16);
		                    s0 += "%" + (0x80 + (u & 0x3f)).toString(16);
		                }
		                else {                      // double byte format
		                    s0 += "%" + (0xc0 + ((u & 0x7c0) >> 6)).toString(16);
		                    s0 += "%" + (0x80 + (u & 0x3f)).toString(16);
		                }
		            }
		        }
		    }
		    return s0;
		}
	</script>
</head>

<body scroll="no">
	<form name="pay_info_form" id="pay_info_form" method="post">
		<input type="hidden" name="_method" id="payMethod"/>
		
		<!-- isp인증 요청 관련 -->
		<input type="hidden" name="P_TRANS_NO" id="P_TRANS_NO" value="${orderInfo.trNo}">
		<input type="hidden" name="P_KVP_CARDCODE" id="P_KVP_CARDCODE">
		<input type="hidden" name="P_KVP_NOINT" id="P_KVP_NOINT">
		<input type="hidden" name="P_KVP_QUOTA" id="P_KVP_QUOTA">
		<input type="hidden" name="P_VP_RET_SAVEPOINT" id="P_VP_RET_SAVEPOINT">
		<input type="hidden" name="P_KVP_CARD_PREFIX" id="P_KVP_CARD_PREFIX">
		<input type="hidden" name="P_KVP_CONAME" id="P_KVP_CONAME">
		<input type="hidden" name="P_KVP_SESSIONKEY" id="P_KVP_SESSIONKEY">
		<input type="hidden" name="P_KVP_ENCDATA" id="P_KVP_ENCDATA">
		<input type="hidden" name="P_KVP_PAYSET_FLAG" id="P_KVP_PAYSET_FLAG">
		<input type="hidden" name="P_KVP_USING_POINT" id="P_KVP_USING_POINT">
		<input type="hidden" name="P_KVP_RESERVED1" id="P_KVP_RESERVED1">
		<input type="hidden" name="P_KVP_RESERVED2" id="P_KVP_RESERVED2">
		<input type="hidden" name="P_KVP_RESERVED3" id="P_KVP_RESERVED3">
		<input type="hidden" name="P_VP_CANCEL_CODE" id="P_VP_CANCEL_CODE">
	</form>
	
	<div id="ispAppLayer">
		<FORM name="pay" id="pay" method="post">
			<input type="hidden" name="_method" id="payMethod"/>
			<input type="hidden" name="KVP_GOODNAME" id="KVP_GOODNAME" value="${cardIspReqModel.KVP_GOODNAME}">
			<input type="hidden" name="KVP_PRICE" id="KVP_PRICE" value="${cardIspReqModel.KVP_PRICE}">
			<input type="hidden" name="KVP_CARDCOMPANY" id="KVP_CARDCOMPANY" value="${cardIspReqModel.KVP_CARDCOMPANY}">
			<input type="hidden" name="KVP_CURRENCY" id="KVP_CURRENCY" value="${cardIspReqModel.KVP_CURRENCY}">
			<input type="hidden" name="VP_BC_ISSUERCODE" id="VP_BC_ISSUERCODE" value="${cardIspReqModel.VP_BC_ISSUERCODE}">
			<input type="hidden" name="KVP_QUOTA_INF" id="KVP_QUOTA_INF" value="${cardIspReqModel.KVP_QUOTA_INF}">
			<input type="hidden" name="KVP_NOINT_INF" id="KVP_NOINT_INF" value="${cardIspReqModel.KVP_NOINT_INF}">
			<input type="hidden" name="KVP_NOINT_FLAG" id="KVP_NOINT_FLAG" value="${cardIspReqModel.KVP_NOINT_FLAG}">
			<input type="hidden" name="KVP_FIXPAYFLAG" id="KVP_FIXPAYFLAG" value="${cardIspReqModel.KVP_FIXPAYFLAG}">
			<input type="hidden" name="KVP_MERCHANT_KB" id="KVP_MERCHANT_KB" value="${cardIspReqModel.KVP_MERCHANT_KB}">
			<input type="hidden" name="KVP_KB_SAVEPOINTREE" id="KVP_KB_SAVEPOINTREE" value="${cardIspReqModel.KVP_KB_SAVEPOINTREE}">
			<input type="hidden" name="VP_BC_SAVEPOINT" id="VP_BC_SAVEPOINT" value="${cardIspReqModel.VP_BC_SAVEPOINT}">
			<input type="hidden" name="KVP_BC_OACERT_INF" id="KVP_BC_OACERT_INF" value="${cardIspReqModel.KVP_BC_OACERT_INF}">
			<input type="hidden" name="KVP_OACERT_INF" id="KVP_OACERT_INF" value="${cardIspReqModel.KVP_OACERT_INF}">
			<input type="hidden" name="KVP_SH_OACERT_INF" id="KVP_SH_OACERT_INF" value="${cardIspReqModel.KVP_SH_OACERT_INF}">
			<input type="hidden" name="KVP_JB_OACERT_INF" id="KVP_JB_OACERT_INF" value="${cardIspReqModel.KVP_JB_OACERT_INF}">
			<input type="hidden" name="VP_MERCHANT_ID" id="VP_MERCHANT_ID" value="${cardIspReqModel.VP_MERCHANT_ID}">
			<input type="hidden" name="VP_REQ_AUTH" id="VP_REQ_AUTH" value="${cardIspReqModel.VP_REQ_AUTH}">
			<input type="hidden" name="VP_CANCEL_CODE" id="VP_CANCEL_CODE" value="${cardIspReqModel.VP_CANCEL_CODE}">
			<input type="hidden" name="VP_RET_SAVEPOINT" id="VP_RET_SAVEPOINT" value="${cardIspReqModel.VP_RET_SAVEPOINT}">
			<input type="hidden" name="KVP_USING_POINT" id="KVP_USING_POINT" value="${cardIspReqModel.KVP_USING_POINT}">
			<input type="hidden" name="KVP_PAYSET_FLAG" id="KVP_PAYSET_FLAG" value="${cardIspReqModel.KVP_PAYSET_FLAG}">
			<input type="hidden" name="KVP_CARD_PREFIX" id="KVP_CARD_PREFIX" value="${cardIspReqModel.KVP_CARD_PREFIX}">
			<input type="hidden" name="KVP_CONAME" id="KVP_CONAME" value="${cardIspReqModel.KVP_CONAME}">
			<input type="hidden" name="KVP_CARDCODE" id="KVP_CARDCODE" value="${cardIspReqModel.KVP_CARDCODE}">
			<input type="hidden" name="KVP_QUOTA" id="KVP_QUOTA" value="${cardIspReqModel.KVP_QUOTA}">
			<input type="hidden" name="KVP_NOINT" id="KVP_NOINT" value="${cardIspReqModel.KVP_NOINT}">
			<input type="hidden" name="KVP_SESSIONKEY" id="KVP_SESSIONKEY" value="${cardIspReqModel.KVP_SESSIONKEY}">
			<input type="hidden" name="KVP_ENCDATA" id="KVP_ENCDATA" value="${cardIspReqModel.KVP_ENCDATA}">
			<input type="hidden" name="KVP_PGID" id="KVP_PGID" value="${cardIspReqModel.KVP_PGID}">
			<input type="hidden" name="KVP_RESERVED1" id="KVP_RESERVED1" value="${cardIspReqModel.KVP_RESERVED1}">
			<input type="hidden" name="KVP_RESERVED2" id="KVP_RESERVED2" value="${cardIspReqModel.KVP_RESERVED2}">
			<input type="hidden" name="KVP_RESERVED3" id="KVP_RESERVED3" value="${cardIspReqModel.KVP_RESERVED3}">
			<input type="hidden" name="KVP_IMGURL" id="KVP_IMGURL" value="${cardIspReqModel.KVP_IMGURL}">
		</FORM>
	</div>
	
	<FORM name="return_form" id="return_form" method="post">
		<input type="hidden" name="trNo" id="trNo" value="${orderInfo.trNo}">
		<input type="hidden" name="mid" id="mid" value="${orderInfo.mid}">
		<input type="hidden" name="midNm" id="midNm" value="${orderInfo.midNm}">
		<input type="hidden" name="ordNo" id="ordNo" value="${orderInfo.ordNo}">
		<input type="hidden" name="prdtNm" id="prdtNm" value="${orderInfo.prdtNm}">
		<input type="hidden" name="prdtCd" id="prdtCd" value="${orderInfo.prdtCd}">
		<input type="hidden" name="ordNm" id="ordNm" value="${orderInfo.ordNm}">
		<input type="hidden" name="buyerId" id="buyerId" value="${orderInfo.buyerId}">
		<input type="hidden" name="buyerIp" id="buyerIp" value="${orderInfo.buyerIp}">
		<input type="hidden" name="email" id="email" value="${orderInfo.email}">
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
</body>
</html>