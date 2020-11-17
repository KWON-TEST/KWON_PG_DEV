package com.pg.dao;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.pg.model.KsnetResModel;
import com.pg.model.OrderInfoModel; 

@Repository
@Mapper 
public interface PaymentDao { 
	/**
	 * 결제정보 유효성체크
	 * @param orderInfo
	 * @return
	 */
	public int paramCheck(OrderInfoModel orderInfo);
	
	/**
	 * 결제정보 저장
	 * @param orderInfo
	 */
	public void insertTrans(OrderInfoModel orderInfo); 
	
	/**
	 * 결제결과 업데이트
	 * @param orderInfo
	 */
	public void updateTrans(KsnetResModel resInfo); 
}