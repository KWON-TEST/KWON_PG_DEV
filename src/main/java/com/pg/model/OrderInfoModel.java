package com.pg.model;

import lombok.Data;

@Data
public class OrderInfoModel { 
	/** 광원 거래번호 */
	private String trNo;
	/** 광원 월거래 거래번호 */
	private String orgTrNo;
	/** 가맹점 그룹아이디*/
	private String gMid;
	/** 가맹점아이디 */
	private String mid;
	/** 가맹점명 */
	private String midNm;
	/** 주문번호 */
	private String ordNo;
	/** 상품명 */
	private String prdtNm;
	/** 상품코드 */
	private String prdtCd;
	/** 주문자명 */
	private String ordNm;
	/** 고객ID */
	private String buyerId;
	/** 고객IP */
	private String buyerIp;
	/** 거래일자 */
	private String trDt;
	/** 원거래일자 */
	private String orgTrDt;
	/** 상태코드 */
	private String stateCd;
	/** 카드번호 */
	private String cardNo;
	/** 카드유효기간 년도*/
	private String expYear;
	/** 카드유효기간 월*/
	private String expMonth;
	/** 비밀번호 */
	private String pass;
	/** 주민번호또는사업자번호 */
	private String buyerAuthNum="";
	/** 카드구분 */
	private String cardGb;
	/** 결제금액 */
	private String amt;
	/** 과세 */
	private String tax;
	/** 부가세 */
	private String vat;
	/** 비과세 */
	private String taxFree;
	/** 봉사료 */
	private String serviceFee;
	/** 유효기간 */
	private String instMon;
	/** 승인번호 */
	private String apprNo;
	/** 원거래 승인번호 */
	private String orgApprNo;
	/** VAN */
	private String van;
	/** 결제결과 noti URL */
	private String notiUrl;
	/** 결제결과 처리 URL */
	private String nextUrl;
	/** 결제실패 URL */
	private String cancUrl;
	/** 결과코드 */
	private String resCode;
	/** 결과메시지 */
	private String resMsg;
	/** 이메일 */
	private String email;
	/** 휴대폰번호 */
	private String mobileNo;
	/** 전화번호 */
	private String telNo;
	/** 통화구분 */
	private String currency;
	/** card결제 타입 ISP:I, MPI:M */
	private String cardType;
	
	//mpi 인증 응답관련
	/** CAVV */
	private String P_CAVV; 
	/** X-ID */
	private String P_XID; 
	/** ECI */
	private String P_ECI; 
	
	//isp 인증 응답관련
	/** PG거래번호 */
	private String P_TRANS_NO; 
	/** 카드 코드 */
	private String P_KVP_CARDCODE; 
	/** 무이자 할부 값 */
	private String P_KVP_NOINT; 
	/** 할부 개월수 */
	private String P_KVP_QUOTA; 
	/** 세이브 포인트 결제 리턴 */
	private String P_VP_RET_SAVEPOINT; 
	/** 카드 PREFIX */
	private String P_KVP_CARD_PREFIX; 
	/** 카드 제휴명 */
	private String P_KVP_CONAME; 
	/** Session Key */
	private String P_KVP_SESSIONKEY; 
	/** Encrypted Data */
	private String P_KVP_ENCDATA; 
	/** 복합결제 사용여부 */
	private String P_KVP_PAYSET_FLAG;
	/** 복합결제 사용포인트 */
	private String P_KVP_USING_POINT;
	/** Reserved Field */
	private String P_KVP_RESERVED1;
	/** Reserved Field */
	private String P_KVP_RESERVED2;
	/** Reserved Field */
	private String P_KVP_RESERVED3;
	/** 결제 취소 사유 코드 */
	private String P_VP_CANCEL_CODE;
}