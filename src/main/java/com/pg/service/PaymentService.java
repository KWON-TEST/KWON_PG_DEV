package com.pg.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.pg.mapper.PaymentMapper; 

@Service 
public class PaymentService {
	@Autowired
	public PaymentMapper mapper; 
	
	public String check() { 
		return mapper.selectCheck();
	} 
}
