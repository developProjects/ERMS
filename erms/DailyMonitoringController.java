package com.bioc.erms;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class DailyMonitoringController {

	@RequestMapping(value = "/largeExposureViolationByGrp", method= RequestMethod.GET)
		public String lrgExp() {
			return "largeExposureViolationByGrp";
	}
	@RequestMapping(value = "/lrgExpViolationMon", method= RequestMethod.GET)
		public String lrgExpMon() {
			return "largeExpViolationMon";
	}
	@RequestMapping(value = "/clusterExposureViolation", method= RequestMethod.GET)
		public String clusterExp() {
			return "clusterExposureViolation";
	}
	
	
	@RequestMapping(value = "/PEValuationReport", method= RequestMethod.GET)
	public String Pereport() {
		return "PEValuationReport";
	}
	@RequestMapping(value = "/LSFLoanDetails", method= RequestMethod.GET)
	public String LSFLoanDetails() {
		return "LSFLoanDetails";
	}
	@RequestMapping(value = "/connectedLimitViolation", method= RequestMethod.GET)
	public String conLimitV() {
		return "connectedLimitViolation";
	}
	
	
	@RequestMapping(value = "loanStockExpMonRpt", method= RequestMethod.GET)
	public String loanStockExpMonRpt() {
		return "loanStockExpMonRpt";
	}
	
	@RequestMapping(value = "/pbMarginCall", method = RequestMethod.GET)
	public String pbCall() {
		return "pbMarginCall";
	}
	
	@RequestMapping(value = "/expoMarginCallReport", method = RequestMethod.GET)
	public String dailyReportMgCall() {
		return "expoMarginCallReport";
	}
	
	@RequestMapping(value = "/expoMarginCallEORectification", method = RequestMethod.GET)
	public String dailyReportMgCallReflect() {	
		return "expoMarginCallEORectification";
	}
	
	
	
	
}
