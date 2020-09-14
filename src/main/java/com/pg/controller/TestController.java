package com.pg.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.pg.model.TestModel;
import com.pg.service.TestService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class TestController {
	@Autowired 
	TestService testService;
	
	@RequestMapping(value="/test") 
	public ModelAndView test() throws Exception{
		ModelAndView mv = new ModelAndView();
		
		List<TestModel> testList = testService.selectTest();
		
		log.info("testList:" + testList.toString());
		mv.addObject("list", testList); 
		
		return mv;
	}
	
	@RequestMapping(value="/test2") 
	public String test2(){
        String testStr = "Hi~~";
        System.out.println(testStr);
        return testStr;
    }
}
