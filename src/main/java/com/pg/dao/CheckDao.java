package com.pg.dao;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.pg.model.TestModel; 

@Repository
@Mapper 
public interface CheckDao { 
	public String check(); 
}