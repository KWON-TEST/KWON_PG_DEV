<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

 	<script src="//code.jquery.com/jquery.js"></script>
	<script type="text/javascript" src="https://www.vpay.co.kr/eISP/jquery-1.8.3.min.js"></script>
	<script language="javascript" src="https://www.vpay.co.kr/eISP/Wallet_layer_VP.js"></script>
	
	<title>KWON PG RESPONSE PAGE</title>
	
    <script type="text/javascript">
	    function btnOK() {
	    	if (window.opener && !window.opener.closed){
	    		var form = document.resultForm; 
		    	form.target = "KWONPG_CLIENT";
		    	form.action = "${orderInfo.nextUrl}"; 
		    	form.submit(); 
		    	
		        self.close();
	    	}else{
	    		 self.close();
	    	}
	    }
	</script>
</head>
<body>
<br>
<font size="3"><b>[RESPONSE PAGE]</b></font>
<br><br>
<form id="resultForm" name="resultForm" method="post">
	<table border="0">
		<tr>
	      	<td width="150">mid</td><td>${orderInfo.mid}</td>
		</tr>		
		<tr>
	      	<td>stateCd</td><td>${orderInfo.stateCd}</td>
		</tr>
		<tr>
	      	<td>trNo</td><td>${orderInfo.trNo}</td>
		</tr>
		<tr>
	      	<td>midNm</td><td>${orderInfo.midNm}</td>
		</tr>
		<tr>
	      	<td>ordNo</td><td>${orderInfo.ordNo}</td>
		</tr>	
		<tr>
	      	<td>amt</td><td>${orderInfo.amt}</td>
		</tr>	
		<tr>
		  	<td>notiUrl</td><td>${orderInfo.notiUrl}</td>
		</tr>
		<tr>
	      	<td>resCode</td><td>${orderInfo.resCode}</td>
		</tr>	
		<tr>
	      	<td>resMsg</td><td>${orderInfo.resMsg}</td>
		</tr>		
	</table>
	
	<div class="form-group" style="text-align:center;">
		<button type="button" id="btnOk" onclick="btnOK()">확인</button>
	 </div>
</form>
</body>
</html>