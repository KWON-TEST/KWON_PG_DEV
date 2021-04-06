package com.pg.controller;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.pg.model.CardIspModel;
import com.pg.model.KsnetResModel;
import com.pg.model.OrderInfoModel;
import com.pg.service.PaymentService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CardPayController {
	@Autowired 
	PaymentService paymentService;
	
	@RequestMapping(value="/cardPay") 
	public ModelAndView cardPay(OrderInfoModel orderInfo) throws Exception{
		ModelAndView mv = new ModelAndView();
		
		log.info("cardPay in orderInfo : " + orderInfo.toString());
		
		//거래번호 생성
		String transNo = paymentService.makeTransNo("CARD");
		orderInfo.setTrNo(transNo);
		orderInfo.setStateCd("0051");
		
		log.info("cardPay makeTransNo : " + orderInfo.getOrdNo() + ":" + transNo);
		
		HashMap<String, String> checkRes = paymentService.paramCheck(orderInfo);
		
		//가맹점 정보 체크 추가
		//주문정보 저장 추가
		
		if(!"0000".contentEquals(checkRes.get("code"))) {
			orderInfo.setStateCd("0031");
		}
		orderInfo.setResCode(checkRes.get("code"));
		orderInfo.setResMsg(checkRes.get("message"));
		
		log.info("cardPay out orderInfo : " + orderInfo.toString());
		
		mv.addObject("orderInfo", orderInfo); 
		
		return mv;
	}
	
	@RequestMapping(value="/cardSugiPay") 
	public ModelAndView cardSugiPay(OrderInfoModel orderInfo) throws Exception{
		ModelAndView mv = new ModelAndView();
		
		log.info("cardSugiPay in orderInfo : " + orderInfo.toString());
		
		//거래번호 생성
		String transNo = paymentService.makeTransNo("CARD");
		orderInfo.setTrNo(transNo);
		orderInfo.setStateCd("0051");
		
		log.info("cardSugiPay makeTransNo : " + orderInfo.getOrdNo() + ":" + transNo);
		
		HashMap<String, String> checkRes = paymentService.paramCheck(orderInfo);
		
		//가맹점 정보 체크 추가
		//주문정보 저장 추가
		
		if(!"0000".contentEquals(checkRes.get("code"))) {
			orderInfo.setStateCd("0031");
		}
		orderInfo.setResCode(checkRes.get("code"));
		orderInfo.setResMsg(checkRes.get("message"));
		
		log.info("cardSugiPay out orderInfo : " + orderInfo.toString());
		
		mv.addObject("orderInfo", orderInfo); 
		
		return mv;
	}
	
	@RequestMapping(value="/cardAuth") 
	public ModelAndView cardAuth(OrderInfoModel orderInfo) throws Exception{
		ModelAndView mv = new ModelAndView();
		
		log.info("cardISP in orderInfo : " + orderInfo.toString());
		
		//비씨, 국민, 우리, 광주, 전북, 수협 카드결제일 경우 ISP모듈 호출
		if("1001".equals(orderInfo.getCardGb()) || "1002".equals(orderInfo.getCardGb()) || "1007".equals(orderInfo.getCardGb()) ||
		   "1017".equals(orderInfo.getCardGb()) || "1018".equals(orderInfo.getCardGb()) || "1012".equals(orderInfo.getCardGb())){
			//ISP결제
			mv = new ModelAndView("cardISP");

			CardIspModel cardIspReqModel = new CardIspModel();
			
			paymentService.IspCardCodeConvert(orderInfo, cardIspReqModel);
			
			paymentService.makeIspData(orderInfo, cardIspReqModel);
			
			log.info("cardISP in cardIspReqModel : " + cardIspReqModel.toString());
			log.info("cardISP out orderInfo : " + orderInfo.toString());
			
			mv.addObject("cardIspReqModel", cardIspReqModel);
		}else {
			//MPI결제
			//cardMpi.jsp로 가도록 처리
			orderInfo.setCardType("M");
		}
		mv.addObject("orderInfo", orderInfo); 
		 
		return mv;
	}
	
	@RequestMapping(value="/sugiPayProc") 
	public ModelAndView sugiPayProc(OrderInfoModel orderInfo) throws Exception{
		ModelAndView mv = new ModelAndView();
		PaymentService payment = new PaymentService();
		KsnetResModel resInfo = new KsnetResModel();
		
		orderInfo.setCardType("S");
		
		log.info("sugiPaySubmit orderInfo : " + orderInfo.toString());
		
		//VAN사 결제요청
		resInfo = payment.cardPaymentProc(orderInfo);

		if("O".equals(resInfo.getStatus())) {
			//결제성공
			orderInfo.setStateCd("0021");
			orderInfo.setResCode("0021");
			orderInfo.setResMsg(resInfo.getMsg2());
		}else {
			//결제실패
			orderInfo.setStateCd("0031");
			orderInfo.setResCode("0031");
			orderInfo.setResMsg(resInfo.getMsg2());
		}
		mv.setViewName("result");
		
		mv.addObject("orderInfo", orderInfo); 
		mv.addObject("resInfo", resInfo); 
		
		return mv;
	}
	
	@RequestMapping(value="/ispPayProc") 
	public ModelAndView ispPayProc(OrderInfoModel orderInfo) throws Exception{
		ModelAndView mv = new ModelAndView();
		PaymentService payment = new PaymentService();
		KsnetResModel resInfo = new KsnetResModel();
		
		/*
		 * log.info("authSubmit cardIspInfo : " + cardIspModel.toString());
		 * 
		 * String trNo = cardIspModel.getTRANS_NO();
		 * 
		 * //거래번호로 주문정보 조회추가 orderInfo = payment.getOrderInfo(trNo);
		 */
		orderInfo.setCardType("I");
		
		log.info("ispProc orderInfo : " + orderInfo.toString());
		
		//VAN사 결제요청
		resInfo = payment.cardPaymentProc(orderInfo);

		if("O".equals(resInfo.getStatus())) {
			//결제성공
		}else {
			//결제실패
		}
		
		mv.addObject("orderInfo", orderInfo); 
		mv.addObject("resInfo", resInfo); 
		
		return mv;
	}
	
	@RequestMapping(value="/cardCancelProc") 
	public ModelAndView cardCancelProc(OrderInfoModel orderInfo) throws Exception{
		ModelAndView mv = new ModelAndView();
		PaymentService payment = new PaymentService();
		KsnetResModel resInfo = new KsnetResModel();
		
		//취소요청 정보 체크(금액,원거래 확인 등등)
		//원거래번호로 주문정보 불러오는 로직 추가(원거래 카드정보, 가맹점 정보 등)
		
		orderInfo.setCardType("C");
		
		log.info("cardCancelProc orderInfo : " + orderInfo.toString());
		
		//VAN사 취소요청
		resInfo = payment.cardPaymentProc(orderInfo);

		if("O".equals(resInfo.getStatus())) {
			//결제성공
			orderInfo.setStateCd("0021");
			orderInfo.setResCode("0021");
			orderInfo.setResMsg(resInfo.getMsg2());
		}else {
			//결제실패
			orderInfo.setStateCd("0031");
			orderInfo.setResCode("0031");
			orderInfo.setResMsg(resInfo.getMsg2());
		}
		mv.setViewName("result");
		
		mv.addObject("orderInfo", orderInfo); 
		mv.addObject("resInfo", resInfo); 
		
		return mv;
	}
	
	@RequestMapping(value="/result") 
	public ModelAndView result(OrderInfoModel orderInfo) throws Exception{
		ModelAndView mv = new ModelAndView();
		
		log.info("result orderInfo : " + orderInfo.toString());
		
		mv.addObject("orderInfo", orderInfo); 
		
		return mv;
	}
}
