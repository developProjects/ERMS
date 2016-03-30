<html>
<!DOCTYPE html>

<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 
<script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>

<!-- Kendo UI API -->
<link rel="stylesheet"
	href="/ermsweb/resources/css/kendo.common.min.css">
<link rel="stylesheet" href="/ermsweb/resources/css/kendo.rtl.min.css">
<link rel="stylesheet"
	href="/ermsweb/resources/css/kendo.default.min.css">
<link rel="stylesheet"
	href="/ermsweb/resources/css/kendo.dataviz.min.css">
<link rel="stylesheet"
	href="/ermsweb/resources/css/kendo.dataviz.default.min.css">
<link rel="stylesheet"
	href="/ermsweb/resources/css/kendo.mobile.all.min.css">
<!-- General layout Style -->
<link href="/ermsweb/resources/css/layout.css" rel="stylesheet" type="text/css">

<!-- jQuery JavaScript -->
<script src="/ermsweb/resources/js/jquery.min.js"></script>

<!-- Kendo UI combined JavaScript -->
<script src="/ermsweb/resources/js/kendo.all.min.js"></script>
<style>
/* .main-menu{
		height:50px;
		background-color:#953735;
		color:white;
	}

	.main-menu td{		
		min-width:143px;
		border-right:2px solid #f9ebeb;
		cursor:pointer;
	}

	.menu-item{
		position:relative;
	}
	.main-menu-link{
		color:#fff;
		text-align:center;
	}
	.main-menu-link a{color:#fff;text-decoration:none;}
	.menu-item ul{display:none;}
	ul.sub-menu, .menu-item ul, ul.sub-menu-level2{		
		position:absolute;
		padding:0;margin:0;
		width1:190px;
		left:0;top:50px;
		list-style:none;
		background-color:#953735;
		z-index:999;
	}
	
	ul.sub-menu-level2{
		top:0;
		max-height:300px;
		overflow-x:hidden;
		overflow-y:auto;
	}
	
	.sub-menu li, .menu-item ul li{
		position:relative;
		float:left;		
		text-align:left;
		border-right1:2px solid #f9ebeb;
	}
	.sub-menu li:hover, .menu-item ul li:hover{
		background-color:#f9ebeb;
		border-left:1px solid #920023;
		border-right:1px solid #920023;
	}
	.sub-menu li a, .menu-item ul li a{
		display:block;
		padding:10px;
		color:#fff;
		text-decoration:none;
	}
	.sub-menu li a:hover,.menu-item ul li a:hover{
		color:#920023;
		text-decoration:underline;
	}
	
	.main-menu td:hover, .main-menu td.active{
		background-color:#f9ebeb;
	}
	.main-menu td:hover ul.sub-menu{border-top:2px solid #920023;}
	.main-menu td:hover .main-menu-link, .main-menu td:hover .main-menu-link a, .main-menu td.active .main-menu-link a, .main-menu td.active .main-menu-link {color:#920023;}
	
	.sub-menu li.active-link-hover > a{color:#920023;} */
</style>

<script>
	
	$(document).ready(function(){
		$(".main-menu").find("td:last").addClass("menu-last-item");// you can add this in the HTML also
		$(".main-menu").find("td").click(function(){
			$(".main-menu").find(".active").removeClass("active");
			$(this).addClass("active");
		});
	
		$(".menu-item").hover(function(){
			var curWidth = $(this).width();
			var menuLastClass = $(this).hasClass("menu-last-item");//$(this).next("td").hasClass("menu-last-item");
			
			$(this).children('ul').width(curWidth * 1);
			
			if($(this).children('ul').hasClass("sub-menu-level2")){			
				$(this).children('ul').css("left",curWidth);
			}
			
			$(this).children('ul').find("li").width(curWidth - 2);
			if(menuLastClass){
				$(this).children('ul').css("left",-curWidth);
			}
			$(this).children('ul').show();
		},function(){
			$(this).children('ul').hide();			
		});
		
		$(".sub-menu-level2").hover(function(){
			$(this).parent("li").addClass("active-link-hover");
		},function(){
			$(this).parent("li").removeClass("active-link-hover");
		});
				
	});
	
	function logout(){

		var redirecturl = "http://lxdapp25:8080/ermsweb/home";
		var logoutUrl = window.sessionStorage.getItem('serverPath')+"logout";

		var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					type: "GET",
					url: logoutUrl,
					dataType: "json",
				 	xhrFields: {
			         	withCredentials: true
				  	},
				  	data: {
				  		userId: window.sessionStorage.getItem("username")
				  	}
				
				}
			},
			schema : {
		        type: "json",
		        model: {
		            fields: {
		                Field1: { field: "Field1", type: "number" },
		                Field2: { field: "Field2", type: "number" }
		            }  
		        }
		    }		
		});
		dataSource.fetch();
		
		var redirecturl = "/ermsweb/home";
		window.location.href = redirecturl; 
	}
	function getHeader(role) {
		
			document
					.write("<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\">");
		
			document
					.write("<tr> <td colspan='3' width=\"200 \"><img src=\"/ermsweb/resources/images/logo.png\"/></img></td><td><img src=\"/ermsweb/resources/images/title.png\"/></td> <td colspan='3' style=\"font-size:13px\" > User:"+ window.sessionStorage.getItem('username')+"<br> Last Login:"+ window.sessionStorage.getItem('lastLogin')+" </td> </tr>");
		
			document.write("<tr><td colspan='6'>");
	
			//document .write("<table id=\"header_menu\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\"><tr class=\"main-menu\"> <td><div class=\"main-menu-link\"><a href=\"dashboard\" target=\"main_frame\">Home</a></div></td><td><div class=\"main-menu-link\"><a href=\"/ermsweb/ccprmddetail?reset=Y\" target=\"main_frame\">Client/Counterparty</a></div></td> <td class=\"menu-item\"> <div class=\"main-menu-link\"> Limit </div> <ul class=\"sub-menu\"> <li><a href=\"/ermsweb/limitApplication?reset=Y\" target=\"main_frame\">Limit Application</a> </li> </ul> </td> <td class=\"menu-item\"><div class=\"main-menu-link\">Daily Monitoring</div> <ul class=\"sub-menu\"><li><a href=\"http://localhost:8080/ermsweb/productMonitoring\" target=\"main_frame\">Product Monitoring</a></li><li><a href=\"/ermsweb/lrgExpViolationMon\" target=\"main_frame\">Large Exposure Violation</a></li></ul></td> <td class=\"menu-item\"><div class=\"main-menu-link\">Report</div><ul class=\"sub-menu\"><li><a href=\"http://localhost:8080/ermsweb/pbMarginCall\" target=\"main_frame\">PB Margin Call Monitoring</a></li><li><a href=\"http://localhost:8080/ermsweb/sblDealerOverride\" target=\"main_frame\">SBL DealerOverrideReport</a></li><li><a href=\"http://localhost:8080/ermsweb/PEDailyMonitoringReport\" target=\"main_frame\">PE Daily Monitoring Report</a></li><li><a href=\"http://localhost:8080/ermsweb/PEValuationReport\" target=\"main_frame\">PE Valuation Report</a></li><li><a href=\"http://localhost:8080/ermsweb/failedRiskReport\" target=\"main_frame\">Failed Risk Report</a></li><li><a href=\"http://localhost:8080/ermsweb/sblTxnDetailRpt\" target=\"main_frame\">Sbl Transaction Detail Report</a></li><li><a href=\"http://localhost:8080/ermsweb/loanStockExpMonRpt\" target=\"main_frame\">Sbl Loan Stock</a></li><li><a href=\"http://localhost:8080/ermsweb/T24LoanSummary\" target=\"main_frame\">T24LoanSummary</a></li> <li><a href=\"http://localhost:8080/ermsweb/LSFPEReminder\" target=\"main_frame\">LSF PE Reminder</a></li> <li><a href=\"http://localhost:8080/ermsweb/LSFLoanDetails\" target=\"main_frame\">LSF Loan Details</a></li></ul> </td> <td class=\"menu-item\"> <div class=\"main-menu-link\">Maintenance</div><ul class=\"sub-menu\"> <li><a href=\"/ermsweb/groupMaintenanceList?reset=Y\" target=\"main_frame\">Group Maintenance</a></li> <li><a href=\"/ermsweb/accountDetailMaintenance?reset=Y\" target=\"main_frame\">Account Maintenance</a></li><li><a href=\"/ermsweb/subAccountDetailMaintenance?reset=Y\" target=\"main_frame\">Sub-Account Maintenance</a></li><li><a href=\"/ermsweb/teamMaintenance\" target=\"main_frame\">Team Maintenance</a></li><li><a href=\"/ermsweb/counterpartyexposure\" target=\"main_frame\">Credit Exposure</a></li><li><a href=\"/ermsweb/functionEntitlement\" target=\"main_frame\">Function Entitlement</a></li><li><a href=\"/ermsweb/auditTrail\" target=\"main_frame\">Audit Trail</a></li><li><a href=\"/ermsweb/enquiryLoanSubParticipationRatio\" target=\"main_frame\">Enquiry Loan Sub Participation</a></li><li><a href=\"/ermsweb/systemParameterMaintenance\" target=\"main_frame\">System Parameters Maintenance</a></li><li><a href=\"/ermsweb/ApprovalMatrix\" target=\"main_frame\">Approval Matrix</a></li><li><a href=\"/ermsweb/UserMaintenance\" target=\"main_frame\">User Maintenance</a><li><a href=\"/ermsweb/limitTypeMaintenance\" target=\"main_frame\">Limit Type Maintenance</a></li><li><a href=\"/ermsweb/annualLimitReviewProcess\" target=\"main_frame\">Annual Limit Review Maintenance</a></li><li><a href=\"/ermsweb/annualLimitReviewSummary\" target=\"main_frame\">Annual Limit Summary</a></li><li><a href=\"/ermsweb/crossCollateralizationGroupMaintenance\" target=\"main_frame\">Cross Collateralization Group Maintenance</a></li><li><a href=\"/ermsweb/crossCcyHaircutMaintenance\" target=\"main_frame\">Cross CCY Haircut Maintenance</a><li><a href=\"/ermsweb/issuerLimitMaintenance\" target=\"main_frame\">Issuer Limit Maintenance</a></li><li><a href=\"/ermsweb/countryLimitMaintenance\" target=\"main_frame\">Country Limit Maintenance</a></li><li><a href=\"/ermsweb/countryRatingMaintenance\" target=\"main_frame\">Country Rating Maintenance</a></li></li><li><a href=\"/ermsweb/productLimitMonitorMaintenance\" target=\"main_frame\">ProductLimit MonitorRule Maintenance</a></li><li><a href=\"/ermsweb/BatchUploadMaintenance\" target=\"main_frame\">BatchUpload</a></li></li></ul></td><td><div class=\"main-menu-link\"><a onclick=\"logout()\">Logout</a></div></td></tr></table>"); 
			
			document.write("<table id=\"header_menu\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\"><tr class=\"main-menu\"><td><div class=\"main-menu-link\"><a href=\"dashboard\" target=\"main_frame\">Home</a></div></td><td class=\"menu-item\"><div class=\"main-menu-link\"><a href=\"dashboard\" target=\"main_frame\">Loan</a></div><ul class=\"sub-menu\"><li><a href=\"/ermsweb/pedailyMonitoringReport\" target=\"main_frame\">LSF / PE Daily Monitoring Enquiry</a></li><li><a href=\"/ermsweb/peReminder\" target=\"main_frame\">LSF / PE Reminder </a></li><li><a href=\"/ermsweb/peValuationReport\" target=\"main_frame\">PE Valuation Report</a></li><li><a href=\"/ermsweb/tloanSummary\" target=\"main_frame\">T24 Loan Summary</a></li><li><a href=\"/ermsweb/LSFLoanDetails\" target=\"main_frame\">LSF Loan Details</a></li></ul></td><td class=\"menu-item\"><div class=\"main-menu-link\"><a href=\"dashboard\" target=\"main_frame\">Limit</a></div><ul class=\"sub-menu\"><li><a href=\"/ermsweb/counterpartyexposure\" target=\"main_frame\">Client/Counterparty Credit Exposure Tree </a></li><li><a href=\"/ermsweb/annualLimitReviewProcess\" target=\"main_frame\">Annual Limit Review Process</a></li><li><a href=\"/ermsweb/annualLimitReviewSummary\" target=\"main_frame\">Annual Limit Review Summary</a></li><li class=\"menu-item\"><a href=\"#\">Setup</a><ul class=\"sub-menu-level2\"><li><a href=\"/ermsweb/limitTypeMaintenance\" target=\"main_frame\">Limit Type </a></li><li><a href=\"/ermsweb/limitApplication\" target=\"main_frame\">Limit Application</a></li><li><a href=\"/ermsweb/productLimitMonitorMaintenance\" target=\"main_frame\">Product Limit Monitor Rule</a></li><li><a href=\"/ermsweb/batchUploadMaintenance\" target=\"main_frame\">BatchUpload</a></li><li><a href=\"/ermsweb/ApprovalMatrix\" target=\"main_frame\">Approval Matrix </a></li></ul></li></ul></td><td class=\"menu-item\"><div class=\"main-menu-link\"><a href=\"dashboard\" target=\"main_frame\">Daily Monitoring</a></div><ul class=\"sub-menu\"><li><a href=\"/ermsweb/enquiryLoanSubParticipationRatio\" target=\"main_frame\">Enquiry Loan Sub Participation</a></li><li><a href=\"/ermsweb/countryRiskMonCollateral\" target=\"main_frame\">Country Risk Monitoring</a></li><li><a href=\"/ermsweb/largeExposureViolationByGrp\" target=\"main_frame\">Large Exposure Violations By Group</a></li><li><a href=\"/ermsweb/lrgExpViolationMon\" target=\"main_frame\">Large Exposure Violations</a></li><li><a href=\"/ermsweb/clusterExposureViolation\" target=\"main_frame\">Clustering Limit/Exposure Monitoring</a></li><li><a href=\"/ermsweb/connectedLimitViolation\" target=\"main_frame\">Connected Lending Limit/Exposure</a></li><li><a href=\"/ermsweb/leeLimitViolations\" target=\"main_frame\">LEE Limit/Exposure Monitoring</a></li><li><a href=\"/ermsweb/expoMarginCallReport\" target=\"main_frame\">PB ISD Margin Call Workflow</a></li></ul></td><td class=\"menu-item\"><div class=\"main-menu-link\"><a href=\"dashboard\" target=\"main_frame\">Report</a></div><ul class=\"sub-menu\"><li class=\"menu-item\"><a href=\"javascript:void(0)\" target=\"main_frame\">Master Reports</a><ul class=\"sub-menu-level2\"><li><a href=\"/ermsweb/EnquiryBOCILRegulatoryReport\" target=\"main_frame\">Enquiry BOCIL Regulatory Report</a></li></ul></li><li class=\"menu-item\"><a href=\"javascript:void(0)\" target=\"main_frame\">Exposure Reports</a><ul class=\"sub-menu-level2\"><li><a href=\"/ermsweb/failedRiskReport\" target=\"main_frame\">Fail settlement Report</a></li><li><a href=\"/ermsweb/sblDealerOverride\" target=\"main_frame\">Dealer Override Report</a></li><li><a href=\"/ermsweb/sblTxnDetailRpt\" target=\"main_frame\">Transaction Details Report</a></li><li><a href=\"/ermsweb/sblLoanStock\" target=\"main_frame\">Loan Stock Details</a></li></ul></li><li class=\"menu-item\"><a href=\"/ermsweb/ccptyRiskPortal\" target=\"main_frame\">Counterparty Credit Risk</a> <ul class=\"sub-menu-level2\"> <li><a href=\"/ermsweb/ccptyRiskDetail?type=pme\" target=\"main_frame\">CPTY Potential Market Exposure (PME) Summary Report</a></li> <li><a href=\"/ermsweb/ccptyRiskDetail?type=dse\" target=\"main_frame\">CPTY Daily Settlement Exposure (DSE) Summary Report</a></li> <li><a href=\"/ermsweb/ccptyRiskDetail?type=dvp\" target=\"main_frame\">CPTY Deliver vs Payment (DVP) Exposure  Summary Report</a></li> <li><a href=\"/ermsweb/ccptyRiskDetail?type=buBudgetLimit\" target=\"main_frame\">CPTY Business Budget Limit Monitoring by Business Unit</a></li> <li><a href=\"/ermsweb/ccptyRiskDetail?type=enBudgetLimit\" target=\"main_frame\">CPTY Business Budget Limit Monitoring by Entity</a></li> <li><a href=\"/ermsweb/ccptyRiskDetail?type=expo\" target=\"main_frame\">CPTY General Exposure Monitoring Report</a></li> <li><a href=\"/ermsweb/ccptyRiskDetail?type=marginUtlSum\" target=\"main_frame\">CPTY GC UK MARGIN CALL & UTLISATION SUMMARY REPORT</a></li> <li><a href=\"/ermsweb/ccptyRiskDetail?type=ccptyExpo\" target=\"main_frame\">CPTY Counterparty Exposure Summary and Margin Call</a></li> <li><a href=\"/ermsweb/ccptyRiskDetail?type=placedMarginDeposit\" target=\"main_frame\">CPTY Placed Margin Deposit Limit Summary Report</a></li> <li><a href=\"/ermsweb/ccptyRiskDetail?type=enBudgetLimit\" target=\"main_frame\">CPTY Daily Margin Call Monitoring Report</a></li> </ul></li></ul></td><td class=\"menu-item\"><div class=\"main-menu-link\">Maintenance</div><ul class=\"sub-menu\"><li class=\"menu-item\"><a href=\"javascript:void(0)\" target=\"main_frame\">Master</a><ul class=\"sub-menu-level2\"><li><a href=\"/ermsweb/groupMaintenanceList?reset=Y\" target=\"main_frame\">Group</a></li><li><a href=\"/ermsweb/ccprmddetailmaintenance?reset=Y\" target=\"main_frame\">Client Counterparty</a></li><li><a href=\"/ermsweb/accountDetailMaintenance?reset=Y\" target=\"main_frame\">Account</a></li><li><a href=\"/ermsweb/subAccountDetailMaintenance?reset=Y\" target=\"main_frame\">Sub Account</a></li><li><a href=\"/ermsweb/teamMaintenance\" target=\"main_frame\">Team</a></li><li><a href=\"/ermsweb/UserMaintenance\" target=\"main_frame\">User</a></li><li><a href=\"/ermsweb/functionEntitlement\" target=\"main_frame\">Function Entitlement</a></li><li><a href=\"/ermsweb/systemParameterMaintenance\" target=\"main_frame\">System Parameter</a></li></ul></li><li class=\"menu-item\"><a href=\"javascript:void(0)\" target=\"main_frame\">Other Risk</a><ul class=\"sub-menu-level2\"><li><a href=\"/ermsweb/countryRatingMaintenance\" target=\"main_frame\">Country Rating </a></li><li><a href=\"/ermsweb/countryLimitMaintenance\" target=\"main_frame\">Country Limit</a></li><li><a href=\"/ermsweb/issuerLimitMaintenance\" target=\"main_frame\">Issuer Limit</a></li><li><a href=\"/ermsweb/countryRiskMonCollateral\" target=\"main_frame\">Country Risk Collateral</a></li><li><a href=\"/ermsweb/countryRiskMonExpBreakdown\" target=\"main_frame\">Country Risk Breakdown</a></li><li><a href=\"/ermsweb/issuerRiskMonCollateral\" target=\"main_frame\">Issuer Risk Collateral</a></li><li><a href=\"/ermsweb/issuerRiskMonExpBreakdown\" target=\"main_frame\">Issuer Risk Breakdown</a></li></ul></li><li class=\"menu-item\"><a href=\"javascript:void(0)\" target=\"main_frame\">Exposure</a><ul class=\"sub-menu-level2\"><li><a href=\"/ermsweb/crossCcyHaircutMaintenance\" target=\"main_frame\">Cross Currency Haircut</a></li><li><a href=\"/ermsweb/crossCollateralizationGroupMaintenance\" target=\"main_frame\">Cross Collateralization</a></li></ul></li><li><a href=\"/ermsweb/auditTrail\" target=\"main_frame\">Audit Trail</a></li></ul></td><td><div class=\"main-menu-link\"><a href=\"dashboard\" onclick=\"logout()\" target=\"main_frame\">Logout</a></div></td></tr></table>");
			document.write("</td></tr>");			
			document.write("</table>");
		
	}
	function onLoadTitle(){		
		var frame = window.frames["main_frame"].document;
		/*document.getElementById("pageTitle").innerHTML = frame.getElementById("pagetitle").value;*/
	}
	
	
</script>
<body>
	<p style="display: inline">
	<script>getHeader(window.parent.getRole());</script>
	</p>
	<!-- <div id="pageTitle" style="background-color: pink; width: 100%;">
	</div>
	<br> -->
</body>

</html>

