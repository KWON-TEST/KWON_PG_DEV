package com.pg.dao;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository; 

@Repository
@Mapper 
public interface CheckDao { 
	public String check(); 
}