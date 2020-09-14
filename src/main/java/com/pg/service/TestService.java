package com.pg.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pg.mapper.TestMapper;
import com.pg.model.TestModel; 

@Service 
public class TestService {
	@Autowired
	public TestMapper mapper; 
	
	public List<TestModel> selectTest() { 
		return mapper.selectTest();
	} 
}
