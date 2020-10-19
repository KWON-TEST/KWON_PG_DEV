package com.pg.dao;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.pg.model.OrderInfoModel; 

@Repository
@Mapper 
public interface PaymentDao { 
	OrderInfoModel selectCheck(); 
}