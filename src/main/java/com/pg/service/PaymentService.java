package com.pg.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.pg.dao.PaymentDao;
import com.pg.model.CardIspModel;
import com.pg.model.KsnetReqModel;
import com.pg.model.KsnetResModel;
import com.pg.model.OrderInfoModel; 

@Service 
public class PaymentService {
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
	 * isp결제일 경우 결제 카드코드 isp결제호출 규격에 맞게 수정
	 * @param orderInfo
	 * @return
	 */
	public CardIspModel IspCardCodeConvert(OrderInfoModel orderInfo, CardIspModel cardIspReqModel) {
		if("1001".equals(orderInfo.getCardGb())){ //비씨카드
			cardIspReqModel.setKVP_CARDCOMPANY("0100");
			cardIspReqModel.setVP_BC_ISSUERCODE("");
		}else if("1002".equals(orderInfo.getCardGb())){ //국민카드
			cardIspReqModel.setKVP_CARDCOMPANY("0204");
			cardIspReqModel.setVP_BC_ISSUERCODE("");
		}else if("1007".equals(orderInfo.getCardGb())){ //우리카드
			cardIspReqModel.setKVP_CARDCOMPANY("0100");
			cardIspReqModel.setVP_BC_ISSUERCODE("WR");
		}else if("1017".equals(orderInfo.getCardGb())){ //광주
			cardIspReqModel.setKVP_CARDCOMPANY("1500");
			cardIspReqModel.setVP_BC_ISSUERCODE("");
		}else if("1018".equals(orderInfo.getCardGb())){ //전북
			cardIspReqModel.setKVP_CARDCOMPANY("1600");
			cardIspReqModel.setVP_BC_ISSUERCODE("");
		}else if("1012".equals(orderInfo.getCardGb())){ //수협
			cardIspReqModel.setKVP_CARDCOMPANY("1800");
			cardIspReqModel.setVP_BC_ISSUERCODE("");
		}
		
		return cardIspReqModel;
	}

	/**
	 * ISP결제호출 데이터 세팅
	 * @param orderInfo
	 * @return
	 */
	public CardIspModel makeIspData(OrderInfoModel orderInfo, CardIspModel ispReqData) {
		ispReqData.setKVP_GOODNAME(orderInfo.getPrdtNm());
		ispReqData.setKVP_PRICE(orderInfo.getAmt());
		ispReqData.setKVP_PGID("19038");
		
		//무이자정보 불러와서 세팅
		//NONE : 무이자없음
		//ALL: 모두 무이자 적용
		//EX)0100-3:6:9,0204-4:5:7
		//BC카드(0100)는 3개월, 6개월, 9개월에 무이자 할부 적용
		//KB카드(0204)는 4개월, 5개월, 7개월 무이자 할부 적용
		ispReqData.setKVP_NOINT_INF("NONE");
		
		//선택가능 할부개월
		//NONE : 일시불만 선택가능
		//EX) 3:5:7:12
		//3,5,7,12개월 할부 및 일시불 선택가능
		ispReqData.setKVP_QUOTA_INF("3:5:7:12");
		
		//할부상태(일반, 무이자)표시 제거 여부
		//결제창 할부개월 수 옆 글자 노출
		ispReqData.setKVP_NOINT_FLAG("");
		
		//추가인증 적용 금액 정보 (KB의 경우)
		ispReqData.setKVP_OACERT_INF("NONE");
		
		//추가인증 적용 금액 정보 (KB의 경우)
		ispReqData.setKVP_OACERT_INF("NONE");
		
		//추가인증 적용 금액 정보 (수협카드의 경우)
		ispReqData.setKVP_SH_OACERT_INF("NONE");
		
		//추가인증 적용 금액 정보 (전북카드의 경우)
		ispReqData.setKVP_JB_OACERT_INF("NONE");
		
		//추가인증 적용 금액 정보 (광주카드의 경우)
		ispReqData.setKVP_KJ_OACERT_INF("NONE");
		
		//추가인증 적용 금액 정보 (BC, 우리카드의 경우)
		ispReqData.setKVP_BC_OACERT_INF("NONE");
		
		return ispReqData;
	}
	
	/**
	 * 카드결제 처리 프로세스
	 * @param cardIspModel
	 * @param orderInfo
	 * @return
	 * @throws Exception
	 */
	public KsnetResModel cardPaymentProc(CardIspModel cardIspModel, OrderInfoModel orderInfo) throws Exception {
		VanService van = new VanService();
		KsnetReqModel reqInfo = new KsnetReqModel();
		KsnetResModel resInfo = new KsnetResModel();
		
		String sendData = "";
		
		orderInfo.setCardType("I");
		
		reqInfo = van.reqDataSetting(orderInfo, cardIspModel);
		
		sendData = van.getReqBody(reqInfo);
		
		resInfo = van.vanProc(sendData);
		
		updateTrans(resInfo);
		
		return resInfo;
	}
	
	/**
	 * 거래번호로 주문정보 검색
	 * @param trNo
	 * @return
	 */
	public OrderInfoModel getOrderInfo(String trNo) {
		OrderInfoModel orderInfo = new OrderInfoModel();
		
		
		return orderInfo;
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
	 * @param resInfo
	 */
	public void updateTrans(KsnetResModel resInfo) { 
		dao.updateTrans(resInfo);
	}
}
