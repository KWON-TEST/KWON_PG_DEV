package com.pg.model;

import lombok.Data;

@Data
public class OrderInfoModel { 
	private String trNo; 
	private String mid;
	private String ordNo;
	private String prdtNm;
	private String prdtCd;
	private String ordNm;
	private String buyerId;
	private String buyerIp;
	private String buyerEmail;
	private String trDt;
	private String stateCd;
	private String cardNo;
	private String cardYm;
	private String amt;
	private String tax;
	private String serviceFee;
	private String instMon;
	private String apprNo;
	private String van;
	private String notiUrl;
	private String nextUrl;
}