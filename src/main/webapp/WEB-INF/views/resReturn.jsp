<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head><title>KWON PG RESPONSE PAGE</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0, minimum-scale=1.0, maximum-scale=1.0" />
</head>
<body>
<br>
<font size="3"><b>[RESPONSE PAGE]</b></font>
<br><br>
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
</body>
</html>