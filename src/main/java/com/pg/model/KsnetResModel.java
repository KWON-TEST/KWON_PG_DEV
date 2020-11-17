package com.pg.model;

import lombok.Data;

@Data
public class KsnetResModel { 
	/** 전문 구분 */
	private String specType 	= "";
	/** VAN-TR - VAN 에서 제공하는 거래 일련번호*/
	private String vanTr		= "";
	/** 상태 - 'O': 정상  'P' : 자동이제정상    'X': 거절 */
	private String status 		= "";
	/** 거래일시 - YYMMDDhhmmss (Van 기준:Van 에서 카드사로 전송한 시각)*/
	private String tranDt		= "";
	/** 카드번호 */
	private String cardNo		= "";
	/** 유효기간 */
	private String expirDt 		= "";
	/** 할부개월수 */
	private String instMon		= "";
	/** 총금액 */
	private String amt			= "";
	/** 봉사료 */
	private String serviceFee	= "";
	/** 메시지1 */
	private String msg1 		= "";
	/** 메시지2 */
	private String msg2 		= "";
	/** 메시지3 */
	private String msg3 		= "";
	/** 메시지4 */
	private String msg4 		= "";
	/** 승인번호 */
	private String apprNo		= "";
	/** 카드종류명 */	
	private String cardNm 	 	= "";
	/** 발급사코드 */
	private String issuerCd		= "";
	/** 매입사코드 */
	private String acquirerCd  	= "";
	/** 가맹점번호 */
	private String mchtNo	 	= "";
	/** 전송구분 */
	private String snedType 	= "";
	/** Notice */
	private String notice		= "";
	/** 발생포인트 */
	private String occurPoint	= "";
	/** 가용포인트 */
	private String availPoint	= "";
	/** 누적포인트 */
	private String savePoint 	= "";
	/** 포인트카드사메시지 */
	private String pointMsg	 	= "";
	/** 가맹점사용ID */
	private String mchtId	 	= "";
	/** 가맹점사용필드 */
	private String mchtFiller	= "";
	/** 여유필드 */
	private String bodyFiller 		= "";
}