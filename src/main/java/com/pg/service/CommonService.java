package com.pg.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.pg.dao.PaymentDao;
import com.pg.model.KsnetResModel;
import com.pg.model.OrderInfoModel; 

@Service 
public class CommonService{
	@Autowired
	public PaymentDao dao; 
	
	/**
	 * PG거래번호 생성
	 * @param type - 결제타입 : 카드결제 (CARD)
	 * @return
	 */
	public String makeTransNo(String type) {
		String trNo = "";
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMddHHmmss");
		Date date = new Date();
		String nowDate = dateFormat.format(date);
		
		trNo += "PG_" + type + nowDate;
		
		return trNo;
	}
	
	/**
	 * 결제정보 파라메터 체크
	 * 유효성 체크
	 * @param orderInfo
	 * @return
	 */
	public HashMap<String, String> paramCheck(OrderInfoModel orderInfo) {
		HashMap<String, String> responnse = new HashMap<String, String>();
		responnse.put("code", "0000");
		responnse.put("message", "정상");
		
		//거래번호 체크
		//자리수 체크 필요
		if(StringUtils.isEmpty(orderInfo.getTrNo())){
			responnse.put("code", "1000");
			responnse.put("message", "거래번호 확인요망");
			
			return responnse;
		}
		
		//주문번호 체크
		//자리수 체크 필요
		if(StringUtils.isEmpty(orderInfo.getOrdNo())){
			responnse.put("code", "2000");
			responnse.put("message", "주문번호 확인요망");
			
			return responnse;
		}
		
		//가맹점 아이디 체크
		//자리수 체크 필요
		if(StringUtils.isEmpty(orderInfo.getMid())){
			responnse.put("code", "3000");
			responnse.put("message", "가맹점아이디 확인요망");
			
			return responnse;
		}
		
		//결제금액 체크
		//자리수 체크 필요
		//문자 체크 필요
		if(StringUtils.isEmpty(orderInfo.getAmt())){
			responnse.put("code", "4000");
			responnse.put("message", "결제금액 확인요망");
			
			return responnse;
		}
		
		return responnse;
	}
	
	
	/**
	 * 결제요청정보 저장
	 * @param orderInfo
	 */
	public void insertTrans(OrderInfoModel orderInfo) { 
		dao.insertTrans(orderInfo);
	} 
	
	/**
	 * 결제결과 업데이트
	 * @param orderInfo
	 */
	public void updateTrans(KsnetResModel resInfo) { 
		dao.updateTrans(resInfo);
	} 
	
	/**
     * 왼쪽으로 자리수만큼 문자 채우기
     *
     * @param   str         원본 문자열
     * @param   size        총 문자열 사이즈(리턴받을 결과의 문자열 크기)
     * @param   strFillText 원본 문자열 외에 남는 사이즈만큼을 채울 문자
     * @return  
     */
    public String getLPad(String str, int size, String strFillText) {
    	if(str == null) {
    		if(" ".equals(strFillText)) {
    			str = "";
    		}else if("0".equals(strFillText)) {
    			str = "0";
    		}
    	}
    	
        for(int i = (str.getBytes()).length; i < size; i++) {
            str = strFillText + str;
        }
        return str;
    }


    /**
     * 오른쪽으로 자리수만큼 문자 채우기
     *
     * @param   str         원본 문자열
     * @param   size        총 문자열 사이즈(리턴받을 결과의 문자열 크기)
     * @param   strFillText 원본 문자열 외에 남는 사이즈만큼을 채울 문자
     * @return  
     */
    public String getRPad(String str, int size, String strFillText) {
    	if(str == null) {
    		if(" ".equals(strFillText)) {
    			str = "";
    		}else if("0".equals(strFillText)) {
    			str = "0";
    		}
    	}
    	
        for(int i = (str.getBytes()).length; i < size; i++) {
            str += strFillText;
        }
        return str;
    }
    
    public String getString(String str, int sPoint, int length) throws Exception{
    	if(str == null) {
    		str = "";
    	}
    	
        String EncodingLang = "EUC-KR";
        
        byte[] bytes = str.getBytes("EUC-KR");

        byte[] value = new byte[length];

        if(bytes.length < sPoint + length){
            throw new Exception("Length of bytes is less. length : " + bytes.length + " sPoint : " + sPoint + " length : " + length);
        }

        for(int i = 0; i < length; i++){
            value[i] = bytes[sPoint + i];
        }
        return new String(value, EncodingLang).trim();
    }
}
