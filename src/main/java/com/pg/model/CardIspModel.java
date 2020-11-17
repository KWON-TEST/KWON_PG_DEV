package com.pg.model;

import lombok.Data;

@Data
public class CardIspModel {
	/** 광원거래번호 */
	private String TRANS_NO; 
	
	//isp 인증 요청관련
	/** 카드코드 */
	private String KVP_CARDCOMPANY; 
	/** 발행사 구분 코드, 발행사별 인증서 노출 설정  */
	private String VP_BC_ISSUERCODE;
	/** 로그인 구분 */
	private String KVP_LOGINGUBUN;
	/** 상품가격 */
	private String KVP_PRICE;
	/** 상품명 */
	private String KVP_GOODNAME;
	/** 진행 방식 */
	private String VP_PROC_MTHD = "AUTH";
	/** VAN 취급기관코드 */
	private String KVP_PGID;
	/** 화폐단위(WON) */
	private String KVP_CURRENCY = "WON";
	/** 무이자할부 */
	private String KVP_NOINT_INF = "ALL";
	/** 선택가능 할부개월 */
	private String KVP_QUOTA_INF;
	/** 할부상태(일반, 무이자) 표시 제거 여부, 결제창 할부개월 수 옆 글자 노출 */
	private String KVP_NOINT_FLAG;
	/** KB 세이브포인트리연동 */
	private String KVP_KB_SAVEPOINTREE;
	/** 추가인증 적용 금액 정보 (KB의 경우) */
	private String KVP_OACERT_INF;
	/** 추가인증 적용 금액 정보 (수협카드의 경우) */
	private String KVP_SH_OACERT_INF;
	/** 추가인증 적용 금액 정보 (전북카드의 경우) */
	private String KVP_JB_OACERT_INF;
	/** 추가인증 적용 금액 정보 (광주카드의 경우) */
	private String KVP_KJ_OACERT_INF;
	/** 추가인증 적용 금액 정보 (비씨카드의 경우) */
	private String KVP_BC_OACERT_INF;
	/** 복합결제 연동 여부 */
	private String KVP_FIXPAYFLAG; 
	/** KB 복합결제 연동 가맹점ID */
	private String KVP_MERCHANT_KB="FALSE"; 
	/** 게임가맹점 인증 요청 */
	private String VP_REQ_AUTH; 
	/** 가맹점 번호 */
	private String VP_MERCHANT_ID; 
	/** BC세이브서비스 연동 */
	private String VP_BC_SAVEPOINT; 
	
	//isp 인증 응답관련
	/** 카드 코드 */
	private String KVP_CARDCODE; 
	/** 무이자 할부 값 */
	private String KVP_NOINT; 
	/** 할부 개월수 */
	private String KVP_QUOTA; 
	/** 세이브 포인트 결제 리턴 */
	private String VP_RET_SAVEPOINT; 
	/** 카드 PREFIX */
	private String KVP_CARD_PREFIX; 
	/** 결제 페이지 이미지 */
	private String KVP_IMGURL; 
	/** 카드 제휴명 */
	private String KVP_CONAME; 
	/** Session Key */
	private String KVP_SESSIONKEY; 
	/** Encrypted Data */
	private String KVP_ENCDATA; 
	/** 복합결제 사용여부 */
	private String KVP_PAYSET_FLAG; 
	/** 복합결제 사용포인트 */
	private String KVP_USING_POINT;
	/** Reserved Field */
	private String KVP_RESERVED1;
	/** Reserved Field */
	private String KVP_RESERVED2;
	/** Reserved Field */
	private String KVP_RESERVED3;
	/** 결제 취소 사유 코드 */
	private String VP_CANCEL_CODE;
	
}