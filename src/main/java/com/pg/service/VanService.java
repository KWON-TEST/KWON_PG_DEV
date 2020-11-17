package com.pg.service;

import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.nio.ByteBuffer;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ksnet.interfaces.Approval;
import com.pg.dao.PaymentDao;
import com.pg.model.CardIspModel;
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
		
		serverIp = "210.181.28.116";
		serverPort = 47131;
		
		String recvData = "";
		
        try {
            /** VAN통신 시작 */
        	Approval approval = new Approval();
        	
            log.info("KSNET SendData >>> [{}]", sendData);
            
            byte[] requestData = sendData.getBytes("UTF-8");
            
    		//KSNET에 결제요청
    		int rtn = approval.requestPG(serverIp, serverPort, requestData, responseData, 15 * 1000, 0);
    		
    		recvData = new String(responseData, 0, responseData.length);
    		
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
	public KsnetReqModel reqDataSetting(OrderInfoModel orderInfo, CardIspModel cardIspModel) {
		KsnetReqModel reqInfo = new KsnetReqModel();
		
		reqInfo.setCryptoYn("0");
		//reqInfo.setTerminalNo("");
		reqInfo.setAgencyCd("");
		reqInfo.setSpecSeq("");
		reqInfo.setManagerNm("KWON");
		reqInfo.setCompanyTel(orderInfo.getTelNo());
		reqInfo.setMobileNo(orderInfo.getMobileNo());
		reqInfo.setFiller("");
		
		reqInfo.setSpecType("1120");
		reqInfo.setTrxType("K");
		reqInfo.setCardNo("5236120099298029=2503");
		reqInfo.setInstMon(orderInfo.getInstMon());
		reqInfo.setAmt(orderInfo.getAmt());
		reqInfo.setServiceFee(orderInfo.getServiceFee());
		reqInfo.setTax(orderInfo.getTax());
		reqInfo.setApprNo(orderInfo.getApprNo());
		reqInfo.setTranDt(orderInfo.getTrDt());
		reqInfo.setWorkIdx("AA");
		reqInfo.setPasswd(orderInfo.getPass());
		reqInfo.setPrdtCd(orderInfo.getPrdtCd());
		reqInfo.setBuyerAuthNum(orderInfo.getBuyerAuthNum());
		reqInfo.setSecurityLevel("");
		reqInfo.setDomain("");
		reqInfo.setServerIp("");
		reqInfo.setCompanyCd("");
		reqInfo.setCardSendType("");
		reqInfo.setMchtId("");
		reqInfo.setFiller("");
		reqInfo.setEtc1("");
		reqInfo.setEtc2("");
		reqInfo.setCertType(orderInfo.getCardType());
		reqInfo.setCertCavvYn("");
		
		String certData = "";
		
		if("I".equals(orderInfo.getCardType())) {
			//ISP거래
			certData = cardIspModel.getKVP_SESSIONKEY().length() + cardIspModel.getKVP_SESSIONKEY() + 
					   cardIspModel.getKVP_ENCDATA().length() + cardIspModel.getKVP_ENCDATA() + "080226";
		}else if("M".equals(orderInfo.getCardType())) {
			//MPI거래
			certData = "";
			
			//MPI : CAVV(Ascii 40Byte) + X-ID(Ascii 40Byte) + EC-I(Ascii 2Byte)+이용자IP(20)
			
			reqInfo.setCertMpiLoc("");
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
		transaction.append(common.getRPad(reqModel.getSpecSeq(),12, " "));
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
		transaction.append(common.getLPad(reqModel.getCheckNo(),8, "0"));
		transaction.append(common.getLPad(reqModel.getCheckBankCd(),2, "0"));
		transaction.append(common.getLPad(reqModel.getCheckBranchCd(),4, "0"));
		transaction.append(common.getLPad(reqModel.getCheckType(),2, "0"));
		transaction.append(common.getLPad(reqModel.getCheckAmt(),12, "0"));
		transaction.append(common.getLPad(reqModel.getCheckConfirmDt(),6, "0"));
		transaction.append(common.getLPad(reqModel.getAccntSeq(),6, "0"));
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
		
		resInfo.setSpecType(common.getString(recvData,127,4));
		resInfo.setVanTr(common.getString(recvData,131,12));
		resInfo.setStatus(common.getString(recvData,143,1));
		resInfo.setTranDt(common.getString(recvData,144,12));
		resInfo.setCardNo(common.getString(recvData,156,20));
		resInfo.setExpirDt(common.getString(recvData,176,4));
		resInfo.setInstMon(common.getString(recvData,180,2));
		resInfo.setAmt(common.getString(recvData,182,12));
		resInfo.setMsg1(common.getString(recvData,194,16));
		resInfo.setMsg2(common.getString(recvData,210,16));
		resInfo.setMsg3(common.getString(recvData,226,16));
		resInfo.setMsg4(common.getString(recvData,242,16));
		resInfo.setApprNo(common.getString(recvData,258,12));
		resInfo.setCardNm(common.getString(recvData,270,16));
		resInfo.setIssuerCd(common.getString(recvData,286,2));
		resInfo.setAcquirerCd(common.getString(recvData,288,2));
		resInfo.setMchtNo(common.getString(recvData,290,15));
		resInfo.setSnedType(common.getString(recvData,305,2));
		resInfo.setNotice(common.getString(recvData,307,20));
		resInfo.setOccurPoint(common.getString(recvData,327,12));
		resInfo.setAvailPoint(common.getString(recvData,339,12));
		resInfo.setSavePoint(common.getString(recvData,351,12));
		resInfo.setPointMsg(common.getString(recvData,363,40));
		resInfo.setMchtId(common.getString(recvData,403,2));
		resInfo.setMchtFiller(common.getString(recvData,405,30));
		resInfo.setBodyFiller(common.getString(recvData,433,30));
		
		log.info("RecvData Parsing Success");
		
		return resInfo;
	}
}
