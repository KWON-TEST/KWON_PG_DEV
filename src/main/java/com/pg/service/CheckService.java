package com.pg.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pg.dao.CheckDao; 

@Service 
public class CheckService {
	@Autowired
	public CheckDao dao; 
	
	public String check() { 
		return dao.check();
	} 
}
