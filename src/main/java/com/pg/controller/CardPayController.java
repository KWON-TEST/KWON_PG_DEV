package com.pg.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.pg.dao.PaymentDao;
import com.pg.model.OrderInfoModel;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CardPayController {
	@Autowired 
	PaymentDao paymentService;
	
	@RequestMapping(value="/cardPay") 
	public void cardPay(OrderInfoModel orderInfo) throws Exception{
		ModelAndView mv = new ModelAndView();
		
		//OrderInfoModel check = paymentService.selectCheck();
		
		log.info("orderInfo : " + orderInfo.toString());
	}
}
