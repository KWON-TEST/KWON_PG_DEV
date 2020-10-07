package com.pg.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pg.mapper.CheckMapper; 

@Service 
public class CheckService {
	@Autowired
	public CheckMapper mapper; 
	
	public String check() { 
		return mapper.check();
	} 
}
