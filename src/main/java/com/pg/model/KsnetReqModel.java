package com.pg.model;

import lombok.Data;

@Data
public class KsnetReqModel { 
	//HEAD
	/** 전문 길이 */
	private String headerLength 	= "";
	/** 암호구분 0:암호안함,2:암호화(seed) */
	private String cryptoYn			= "2";
	/** 전문버전 0412 */
	private String specVersion 		= "0412";
	/** 단말기번호 */
	private String terminalNo		= "";
	/** 취급기관코드 */
	private String agencyCd			= "";
	/** 전문일련번호 */
	private String specSeq			= "";
	/** 가맹점 Timeout */
	private String timeout			= "15";
	/** 관리자명 */
	private String managerNm		= "KWON";
	/** 회사전화번호 */
	private String companyTel 		= "";
	/** 휴대폰번호 */
	private String mobileNo			= "";
	/** 예비 */
	private String filler			= "";
	
	
	//BODY
	/** 전문 구분 */
	private String specType 	 	= "";
	/** Pos Entry Mode K : Key-IN, S: Swipe */
	private String trxType		 	= "";
	/** VAN-TR 또는 카드번호 */
	private String cardNo 		 	= "";
	/** 할부개월수 */
	private String instMon		 	= "00";
	/** 통화구분 1: 원화 2: 달러 (달러승인 없음) */
	private String currency		 	= "1";
	/** 통화소숫점자릿수 "0": Default, 소수점 이하 자릿수 2자리: "2" */
	private String currencyPoint 	= "0";
	/** 총금액 */
	private String amt			 	= "";
	/** 봉사료 */
	private String serviceFee 		= "";
	/** 세금 */
	private String tax 			 	= "";
	/** 승인번호 */
	private String apprNo		 	= "";
	/** 거래일자 */
	private String tranDt		 	= "";
	/** Working Key Index */	
	private String workIdx 	 	 	= "";
	/** 비밀번호 */
	private String passwd		 	= "";
	/** 상품코드 */
	private String prdtCd 		 	= "";
	/** 주민번호또는사업자번호 */
	private String buyerAuthNum	 	= "";
	/** 전자상거래 경우 - 전자상거래보안등급 */
	private String securityLevel 	= "";
	/** 전자상거래 경우 - 도메인 */
	private String domain		 	= "";
	/** 전자상거래 경우 - 서버 IP */
	private String serverIp		 	= "";
	/** 전자상거래 경우 - 몰사업자번호 */
	private String companyCd	 	= "";
	/** 카드정보전송구분 */
	private String cardSendType  	= "1";
	/** 가맹점사용ID */
	private String mchtId	 		= "";
	/** 가맹점사용필드 */
	private String mchtFiller		= "";
	/** 수표조회 - 수표번호 */
	private String checkNo 		 	= "";
	/** 수표조회 - 수표발행은행코드 */
	private String checkBankCd 		= "";
	/** 수표조회 - 수표발행영업점코드 */
	private String checkBranchCd 	= "";
	/** 수표조회 - 권종코드 */
	private String checkType	 	= "";
	/** 수표조회 - 수표금액 */
	private String checkAmt		 	= "";
	/** 수표조회 - 수표발행일 */
	private String checkConfirmDt	= "";
	/** 수표조회 - 계좌일련번호 */
	private String accntSeq			= "";
	/** 예비1 - cvv2 */
	private String etc1				= "";
	/** 예비2 */
	private String etc2 			= "";
	/** ISP 관련 정보 (I : ISP거래, M : MPI거래 , Space : 일반거래) */
	private String certType			= "";
	/** MPI 모듈 위치 구분 (K:KSNET, R:Remote, C:제3기관 Space : 일반거래) */
	private String certMpiLoc		= "";
	/** PI CAVV 재사용 유무 (Y : 재사용, N : 사용아님) */
	private String certCavvYn		= "";
	/** 공인인증-Data */
	private String certData			= "";
}