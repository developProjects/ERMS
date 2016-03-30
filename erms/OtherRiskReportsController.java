package com.bioc.erms;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class OtherRiskReportsController {
	@RequestMapping(value = "/countryRiskMonCollateral", method = RequestMethod.GET)
	public String countryRiskMonCollateral() {
		return "countryRiskMonCollateral";
	}
	@RequestMapping(value = "/countryRiskMonExpBreakdown", method = RequestMethod.GET)
	public String countryRiskMonExpBreakdown() {
		return "countryRiskMonExpBreakdown";
	}
	
	@RequestMapping(value = "/issuerRiskMonCollateral", method = RequestMethod.GET)
	public String issuerRiskMonCollateral() {
		return "issuerRiskMonCollateral";
	}
	
	@RequestMapping(value = "/issuerRiskMonExpBreakdown", method = RequestMethod.GET)
	public String issuerRiskMonExpBreakdown() {
		return "issuerRiskMonExpBreakdown";
	}
}
