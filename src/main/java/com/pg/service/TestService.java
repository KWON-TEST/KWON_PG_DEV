package com.pg.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pg.dao.TestDao;
import com.pg.model.TestModel; 

@Service 
public class TestService {
	@Autowired
	public TestDao dao; 
	
	public List<TestModel> selectTest() { 
		return dao.selectTest();
	} 
}
