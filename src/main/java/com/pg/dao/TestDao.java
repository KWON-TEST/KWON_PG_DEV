package com.pg.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.pg.model.TestModel; 

@Repository
@Mapper 
public interface TestDao { 
	public List<TestModel> selectTest(); 
}