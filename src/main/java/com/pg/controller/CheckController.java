package com.pg.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.pg.service.CheckService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CheckController {
	@Autowired 
	CheckService checkService;
	
	@RequestMapping(value="/check") 
	public String test() throws Exception{

		String check = checkService.check();
		
		log.info("check:" + check);
		
		return "OK";
	}
}
