package com.pg.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.pg.service.CheckService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CheckController {
	@Autowired 
	CheckService checkService;
	
	@RequestMapping(value="/check") 
	public ModelAndView test() throws Exception{
		ModelAndView mv = new ModelAndView();
		
		String check = checkService.check();
		
		log.info("check1:" + check);
		
		mv.addObject("status", "OK"); 
		
		return mv;
	}
}
