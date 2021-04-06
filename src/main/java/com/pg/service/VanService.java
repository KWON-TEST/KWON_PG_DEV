package com.pg.service;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ksnet.interfaces.Approval;
import com.pg.dao.PaymentDao;
import com.pg.model.KsnetReqModel;
import com.pg.model.KsnetResModel;
import com.pg.model.OrderInfoModel;

import lombok.extern.slf4j.Slf4j; 

@Slf4j
@Service 
public class VanService {
	@Autowired
	public PaymentDao dao; 
	
	public String serverIp = "";
	public int serverPort = 0;
	
	/**
	 * VAN사 통신 후 응답 수신
	 * @param sendData
	 * @return
	 */
	public KsnetResModel vanProc(String sendData){
		byte[] responseData = new byte[2048];
		KsnetResModel resInfo = new KsnetResModel();
		
		long time = System.currentTimeMillis(); 
		SimpleDateFormat dayTime = new SimpleDateFormat("yyyyMMddHHmmss");
		String strDatetime = dayTime.format(new Date(time));
		
		//테스트
		serverIp = "210.181.28.116";
		serverPort = 47131;
		
		//운영
		//serverIp = "210.181.28.137";
		//serverPort = 7131;
		
		String recvData = "";
		
        try {
            /** VAN통신 시작 */
        	Approval approval = new Approval();
        	
            log.info("KSNET SendData >>> [{}]", sendData);
            
            byte[] requestData = sendData.getBytes();
            
            // 길이 계산하는 Logic
    		byte[] requestTelegram = new byte[requestData.length + 4];
    		String telegramLength = String.format("%04d", requestData.length);
    		System.arraycopy(telegramLength.getBytes(), 0, requestTelegram, 0, 4);
    		System.arraycopy(requestData, 0, requestTelegram, 4, requestData.length);
            
    		//KSNET에 결제요청
    		int rtn = approval.requestPG(serverIp, serverPort, requestData, responseData, 15 * 1000, 0);
    		
    		recvData = new String(responseData, 0, responseData.length, "euc-kr");

    		log.info("KSNET rtn : [{}]", Integer.toString(rtn));
    		log.info("KSNET ResponseData : [{}]", recvData);

            resInfo = parsingKsnetResponse(recvData);
        }  catch (Exception e) {
        	log.info("KSNET vanProc Exception [{}], [{}]", e.getMessage(), e.getStackTrace());
  
        	resInfo.setStatus("X");
        	resInfo.setTranDt(strDatetime.substring(0,8));
        	resInfo.setMsg1("VAN통신 오류");
        }
        
        return resInfo;
	}
	
	
	/**
	 * KSNET 신용카드 요청 데이터 세팅
	 * @param orderInfoModel
	 * @param cardIspModel
	 */
	public KsnetReqModel reqDataSetting(OrderInfoModel orderInfo) {
		KsnetReqModel reqInfo = new KsnetReqModel();
		
		reqInfo.setCryptoYn("2");
		reqInfo.setSpecVersion("0412");
		reqInfo.setTerminalNo("DPT0TEST07");
		reqInfo.setAgencyCd("");
		reqInfo.setSpecSeq(""); //망취소시 필요 유니크번호
		reqInfo.setTimeout("15");
		reqInfo.setManagerNm("KWON");
		reqInfo.setCompanyTel(orderInfo.getTelNo());
		reqInfo.setMobileNo(orderInfo.getMobileNo());
		reqInfo.setFiller("");
		
		if("C".equals(orderInfo.getCardType())) {
			//취소
			reqInfo.setSpecType("1210");
			reqInfo.setApprNo(orderInfo.getOrgApprNo());
			reqInfo.setTranDt(orderInfo.getOrgTrDt());
		}else {
			//결제
			reqInfo.setSpecType("1130");
		}
		
		reqInfo.setTrxType("K");
		reqInfo.setCardNo(orderInfo.getCardNo() +  "=" + orderInfo.getExpYear() + orderInfo.getExpMonth());
		reqInfo.setInstMon(orderInfo.getInstMon());
		reqInfo.setAmt(orderInfo.getAmt());
		reqInfo.setServiceFee(orderInfo.getServiceFee());
		reqInfo.setTax(orderInfo.getTax());
		
		if("S".equals(orderInfo.getCardType())) {
			//수기결제 시 값세팅
			reqInfo.setWorkIdx("AA");
			reqInfo.setPasswd(orderInfo.getPass());
		}
		
		reqInfo.setPrdtCd(orderInfo.getPrdtCd());
		reqInfo.setBuyerAuthNum(orderInfo.getBuyerAuthNum());
		reqInfo.setSecurityLevel("");
		reqInfo.setDomain("");
		reqInfo.setServerIp("");
		reqInfo.setCompanyCd("");
		reqInfo.setCardSendType("1");
		reqInfo.setMchtId("");
		reqInfo.setFiller("");
		reqInfo.setEtc1("");
		reqInfo.setEtc2("");
		
		String certData = "";
		
		if("I".equals(orderInfo.getCardType())) {
			//ISP거래
			reqInfo.setCertType(orderInfo.getCardType());
			reqInfo.setCertMpiLoc("");
			reqInfo.setCertCavvYn("");
			
			certData = orderInfo.getP_KVP_SESSIONKEY().length() + orderInfo.getP_KVP_SESSIONKEY() + 
					orderInfo.getP_KVP_ENCDATA().length() + orderInfo.getP_KVP_ENCDATA() + "080226" + 
					"             " + "                    ";
		}else if("M".equals(orderInfo.getCardType())) {
			//MPI거래
			reqInfo.setCertType(orderInfo.getCardType());
			reqInfo.setCertMpiLoc("");
			reqInfo.setCertCavvYn("");

			certData = orderInfo.getP_CAVV() + orderInfo.getP_XID() + orderInfo.getP_ECI();

		}
		reqInfo.setCertData(certData);
		
		return reqInfo;
	}
	
	/**
	 * KSNET 신용카드 요청 전문 조합
	 * @param body
	 * @return
	 */
	public String getReqBody(KsnetReqModel reqModel){
		StringBuffer transaction = new StringBuffer();
		CommonService common = new CommonService();
		
		//head
		transaction.append(common.getLPad(reqModel.getCryptoYn(), 1, "0"));
		transaction.append(common.getLPad(reqModel.getSpecVersion(),4, "0"));
		transaction.append(common.getRPad(reqModel.getTerminalNo(),10, " "));
		transaction.append(common.getRPad(reqModel.getAgencyCd(),5, " "));
		transaction.append(common.getLPad(reqModel.getSpecSeq(),12, "0"));
		transaction.append(common.getLPad(reqModel.getTimeout(),2, "0"));
		transaction.append(common.getRPad(reqModel.getManagerNm(),20, " "));
		transaction.append(common.getRPad(reqModel.getCompanyTel(),13, " "));
		transaction.append(common.getRPad(reqModel.getMobileNo(),13, " "));
		transaction.append(common.getRPad(reqModel.getFiller(),43, " "));
		
		//bodty
		transaction.append(common.getRPad(reqModel.getSpecType(),4, " "));
		transaction.append(common.getRPad(reqModel.getTrxType(),1, " "));
		transaction.append(common.getRPad(reqModel.getCardNo(),37, " "));
		transaction.append(common.getLPad(reqModel.getInstMon(),2, "0"));
		transaction.append(common.getLPad(reqModel.getCurrency(),1, "0"));
		transaction.append(common.getLPad(reqModel.getCurrencyPoint(),1, "0"));
		transaction.append(common.getLPad(reqModel.getAmt(),12, "0"));
		transaction.append(common.getLPad(reqModel.getServiceFee(),12, "0"));
		transaction.append(common.getLPad(reqModel.getTax(),12, "0"));
		transaction.append(common.getRPad(reqModel.getApprNo(),12, " "));
		transaction.append(common.getRPad(reqModel.getTranDt(),6, " "));
		transaction.append(common.getRPad(reqModel.getWorkIdx(),2, " "));
		transaction.append(common.getRPad(reqModel.getPasswd(),16, " "));
		transaction.append(common.getRPad(reqModel.getPrdtCd(),6, " "));
		transaction.append(common.getRPad(reqModel.getBuyerAuthNum(),10, " "));
		transaction.append(common.getRPad(reqModel.getSecurityLevel(),1, " "));
		transaction.append(common.getRPad(reqModel.getDomain(),40, " "));
		transaction.append(common.getRPad(reqModel.getServerIp(),20, " "));
		transaction.append(common.getRPad(reqModel.getCompanyCd(),10, " "));
		transaction.append(common.getLPad(reqModel.getCardSendType(),1, "0"));
		transaction.append(common.getRPad(reqModel.getMchtId(),2, " "));
		transaction.append(common.getRPad(reqModel.getFiller(),30, " "));
		transaction.append(common.getRPad(reqModel.getCheckNo(),8, " "));
		transaction.append(common.getRPad(reqModel.getCheckBankCd(),2, " "));
		transaction.append(common.getRPad(reqModel.getCheckBranchCd(),4, " "));
		transaction.append(common.getRPad(reqModel.getCheckType(),2, " "));
		transaction.append(common.getRPad(reqModel.getCheckAmt(),12, " "));
		transaction.append(common.getRPad(reqModel.getCheckConfirmDt(),6, " "));
		transaction.append(common.getRPad(reqModel.getAccntSeq(),6, " "));
		transaction.append(common.getRPad(reqModel.getEtc1(),3, " "));
		transaction.append(common.getRPad(reqModel.getEtc2(),27, " "));
		transaction.append(common.getRPad(reqModel.getCertType(),1, " "));
		transaction.append(common.getRPad(reqModel.getCertMpiLoc(),1, " "));
		transaction.append(common.getRPad(reqModel.getCertCavvYn(),1, "N"));
		
		return transaction.toString();
	}
	
	/**
	 * van응답전문 파싱
	 * @param recvData
	 * @return
	 * @throws Exception
	 */
	public KsnetResModel parsingKsnetResponse(String recvData) throws Exception {
		CommonService common = new CommonService();
		KsnetResModel resInfo = new KsnetResModel();
		
		resInfo.setSpecType(common.getString(recvData,123,4));
		resInfo.setVanTr(common.getString(recvData,127,12));
		resInfo.setStatus(common.getString(recvData,139,1));
		resInfo.setTranDt(common.getString(recvData,140,12));
		resInfo.setCardNo(common.getString(recvData,152,20));
		resInfo.setExpirDt(common.getString(recvData,172,4));
		resInfo.setInstMon(common.getString(recvData,176,2));
		resInfo.setAmt(common.getString(recvData,178,12));
		resInfo.setMsg1(common.getString(recvData,190,16));
		resInfo.setMsg2(common.getString(recvData,206,16));
		resInfo.setMsg3(common.getString(recvData,222,16));
		resInfo.setMsg4(common.getString(recvData,238,16));
		resInfo.setApprNo(common.getString(recvData,254,12));
		resInfo.setCardNm(common.getString(recvData,266,16));
		resInfo.setIssuerCd(common.getString(recvData,282,2));
		resInfo.setAcquirerCd(common.getString(recvData,284,2));
		resInfo.setMchtNo(common.getString(recvData,286,15));
		resInfo.setSnedType(common.getString(recvData,301,2));
		resInfo.setNotice(common.getString(recvData,303,20));
		resInfo.setOccurPoint(common.getString(recvData,323,12));
		resInfo.setAvailPoint(common.getString(recvData,335,12));
		resInfo.setSavePoint(common.getString(recvData,347,12));
		resInfo.setPointMsg(common.getString(recvData,359,40));
		resInfo.setMchtId(common.getString(recvData,399,2));
		resInfo.setMchtFiller(common.getString(recvData,401,30));
		resInfo.setBodyFiller(common.getString(recvData,431,30));
		
		log.info("RecvData Parsing Success");
		
		return resInfo;
	}
}
