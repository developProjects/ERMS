<!DOCTYPE html>
<html lang="en">
	<meta http-equiv="Content-Style-Type" content="text/css">
    <meta http-equiv="Content-Script-Type" content="text/javascript">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 
    <script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>
     <script type="text/javascript" src="/ermsweb/resources/js/common_tools.js"></script>
    
    <!-- Kendo UI API -->
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.common.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.rtl.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.default.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.dataviz.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.dataviz.default.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.mobile.all.min.css">
	<!-- General layout Style -->
    <link href="/ermsweb/resources/css/layout.css" rel="stylesheet" type="text/css">
	
    <!-- jQuery JavaScript -->
    <script src="/ermsweb/resources/js/jquery.min.js"></script>

  	<!--   <script src="/ermsweb/resources/js/jszip.js"></script> -->
    
    <!-- Kendo UI combined JavaScript -->
    <!-- <script src="http://kendo.cdn.telerik.com/2014.3.1029/js/kendo.all.min.js"></script> -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
    
    <script>
    $(document).ready(function(){
    	
		var loanTxNo = getURLParameters("loanTxNo");
    	var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					//url: "/ermsweb/resources/js/investmentDetails.json",
					url: window.sessionStorage.getItem('serverPath')+"t24loan/getPeInvestmentDetail?userId="+window.sessionStorage.getItem("username")+"&loanTxNo="+loanTxNo,
					dataType: "json",
					
					type:"GET",
					xhrFields: {
                        withCredentials: true
                    }
					
				}
			},
			error:function(e){
									if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
								},						
			schema: {                               // describe the result format
	            data: function(data) {              // the data which the data source will be bound to is in the values field
	                //console.log(data);
	                return [data];
	            }
	        }
		});
    	
    	dataSource.fetch(function(){
			var jsonObj = this.view();
			$("#clientName").html("<label>"+validateResponse(jsonObj[0].clientName)+"</label>");
			$("#projectName").html("<label>"+validateResponse(jsonObj[0].projectName)+"</label>");
			$("#consortium").html("<label>"+validateResponse(jsonObj[0].consortium)+"</label>");
			$("#intInvesteeName").html("<label>"+validateResponse(jsonObj[0].intInvesteeName)+"</label>");
			$("#clientCountryRisk").html("<label>"+validateResponse(jsonObj[0].clientCountryRisk)+"</label>");
			$("#clientIndustryGroup").html("<label>"+validateResponse(jsonObj[0].clientIndustryGroup)+"</label>");
			$("#investmentType").html("<label>"+validateResponse(jsonObj[0].investmentType)+"</label>");
			$("#fundUsage").html("<label>"+validateResponse(jsonObj[0].fundUsage)+"</label>");
			$("#disburseAmt").html("<label>"+validateResponse(jsonObj[0].disburseAmt)+"</label>");
			$("#disburseDate").html("<label>"+validDate(validateResponse(jsonObj[0].disburseDate))+"</label>");
			$("#initNoOfShares").html("<label>"+validateResponse(jsonObj[0].initNoOfShares)+"</label>");
			$("#initShareholdingRatio").html("<label>"+validateResponse(jsonObj[0].initShareholdingRatio)+"</label>");
			$("#osBalOfSharesHeld").html("<label>"+validateResponse(jsonObj[0].osBalOfSharesHeld)+"</label>");
			$("#osBalOfShareholdingRatio").html("<label>"+validateResponse(jsonObj[0].osBalOfShareholdingRatio)+"</label>");
			$("#entryPrice").html("<label>"+validateResponse(jsonObj[0].entryPrice)+"</label>");
			$("#commRedemptionPeriod").html("<label>"+validDate(validateResponse(jsonObj[0].commRedemptionPeriod))+"</label>");
			$("#exitDate").html("<label>"+validDate(validateResponse(jsonObj[0].exitDate))+"</label>");
			$("#bookEntity").html("<label>"+validateResponse(jsonObj[0].bookEntity)+"</label>");
			$("#noOfBoardSeat").html("<label>"+validateResponse(jsonObj[0].noOfBoardSeat)+"</label>");
			$("#noOfBoardObserver").html("<label>"+validateResponse(jsonObj[0].noOfBoardObserver)+"</label>");
			$("#investmentClass").html("<label>"+validateResponse(jsonObj[0].investmentClass)+"</label>");
			$("#peValuationReportListDaily").html("<a  href='javascript:void(0)' onclick='reportWindow("+jsonObj[0].peValuationReportListDaily+")'>"+validDate(validateResponse(jsonObj[0].peValuationReportListDaily))+"</a>");
			$("#peValuationReportListMonthly").html("<a href='javascript:void(0)' onclick='reportWindow("+jsonObj[0].peValuationReportListMonthly+")'>"+validDate(validateResponse(jsonObj[0].peValuationReportListMonthly))+"</a>");
			$("#peValuationReportNonList").html("<a href='javascript:void(0)' onclick='reportWindow("+jsonObj[0].peValuationReportNonList+")'>"+validDate(validateResponse(jsonObj[0].peValuationReportNonList))+"</a>");
			
			
			$("#peInvestmentApprovalResult").kendoGrid({
				dataSource: {
					data:jsonObj[0].peInvestmentApprovalResult,
					pageSize:3
				},
				scrollable:false,
				pageable: true,
				columns:[
					{ field: "apprLevel",  title:"Approval Level",width:120},
					{ field: "apprDate" ,  title:"Approval Date" ,width:120, template: '#= kendo.toString( new Date(parseInt(apprDate)), "yyyy/MM/dd" ) #'},
				]
			});
	    	
	    	$("#peInvestmentGuarantorResult").kendoGrid({
	    		dataSource: {
					data:jsonObj[0].peInvestmentGuarantorResult,
					pageSize:3
				},
				scrollable:false,
				pageable: true,
				columns:[
					{ field: "name", width:120, title:"Name"},
					{ field: "relWBorrower",width:120,  title:"Relationship with the Investee"},
					{ field: "nationality", width:120, title:"Country of Incorporation (for corporate) / Nationality (for person)"},
					{ field: "guarItem" ,  width:120, title:"Guarantee Items"}
				]
			});
			
    	});
    	
    	
    	
    	
	
	});	 
    function validateResponse(data){
		return (data != null) ? data : "";
	}
	
    function validDate(obj){
    	return kendo.toString( new Date(parseInt(obj)), "yyyy/MM/dd" )
    }
    
    function reportWindow(reportDate){
    	var detailWindow;
    	if(detailWindow){
			detailWindow.close();
		}								
		detailWindow = window.open("expoMarginCallEORectification","_blank","width=768,scrollbars=yes",false);
    }
    </script>
    <body>
    	<div class="boci-wrapper">
    		<header>
    		
    		</header>
    		<div class="content-wrapper">
					<div class="page-title">T24 Investment Details (SCN-PE-INVT-DTL)</div>
					<div class="view-report-details-wrapper margin-top">	
						<div class="view-report-details-header">Investee Information</div>
						<table class="full-width">
							<tr>
	   							<td>Client Name</td>
	   							<td>
	   								<div id="clientName"><label>Client</label></div>
	   							</td>
	   							<td>Project Name</td>
	   							<td>
	   								<div id="projectName"><label>Project</label></div>
	   							</td>
	   						</tr>
							<tr>
	   							<td>Consortium Investment</td>
	   							<td>
	   								<div id="consortium"><label>Client</label></div>
	   							</td>
	   							<td>Intermediate Investee Name</td>
	   							<td>
	   								<div id="intInvesteeName"><label>Project</label></div>
	   							</td>
	   						</tr>
							<tr>
	   							<td>Country</td>
	   							<td>
	   								<div id="clientCountryRisk"><label>Client</label></div>
	   							</td>
	   							<td>Industry</td>
	   							<td>
	   								<div id="clientIndustryGroup"><label>Project</label></div>
	   							</td>
	   						</tr>
						
						
						</table>    		
						    		
					</div>	   
					
					<div class="view-report-details-wrapper">
						<div class="view-report-details-header">Investment Information</div>
						<div class="padding-wrapper">
							<table class="full-width">
								<tr>
		   							<td>Type of Investment</td>
		   							<td>
		   								<div id="investmentType"><label>Client</label></div>
		   							</td>
		   							<td>Fund Usage</td>
		   							<td>
		   								<div id="fundUsage"><label>Project</label></div>
		   							</td>
		   						</tr>
								<tr>
		   							<td>Disbursement Amount</td>
		   							<td>
		   								<div id="disburseAmt"><label>Client</label></div>
		   							</td>
		   							<td>Disbursement Date</td>
		   							<td>
		   								<div id="disburseDate"><label>Project</label></div>
		   							</td>
		   						</tr>
								<tr>
		   							<td>Initial Number of Share Invested</td>
		   							<td>
		   								<div id="initNoOfShares"><label>Client</label></div>
		   							</td>
		   							<td>Initial Shareholding Percentage </td>
		   							<td>
		   								<div id="initShareholdingRatio"><label>Project</label></div>
		   							</td>
		   						</tr>
								<tr>
		   							<td>Outstanding Balance of Number of Shares Held for Investee</td>
		   							<td>
		   								<div id="osBalOfSharesHeld"><label>Client</label></div>
		   							</td>
		   							<td>Outstanding Balance of Shareholding Percentage for Investee</td>
		   							<td>
		   								<div id="osBalOfShareholdingRatio"><label>Project</label></div>
		   							</td>
		   						</tr>
		   						<tr>
		   							<td>Entry Price per Share</td>
		   							<td>
		   								<div id="entryPrice"><label>Client</label></div>
		   							</td>
		   							<td>Committed Redemption Period</td>
		   							<td>
		   								<div id="commRedemptionPeriod"><label>Project</label></div>
		   							</td>
		   						</tr>
		   						<tr>
		   							<td>Proposed Exit Date</td>
		   							<td>
		   								<div id="exitDate"><label>Client</label></div>
		   							</td>
		   							<td>Booking Entity</td>
		   							<td>
		   								<div id="bookEntity"><label>Project</label></div>
		   							</td>
		   						</tr>
		   						<tr>
		   							<td>Number of Seat of the Board</td>
		   							<td>
		   								<div id="noOfBoardSeat"><label>Client</label></div>
		   							</td>
		   							<td>Number of Observer of the Board</td>
		   							<td>
		   								<div id="noOfBoardObserver"><label>Project</label></div>
		   							</td>
		   						</tr>
		   						<tr>
		   							<td>Investment Classification</td>
		   							<td>
		   								<div id="investmentClass"><label>Client</label></div>
		   							</td>
		   							<td>&nbsp;</td>
		   							<td>
		   								&nbsp;
		   							</td>
		   						</tr>
						
						</table>
						<div class="view-report-details-wrapper">	
							<div class="view-report-details-header">Approval Information</div>
							<div id="peInvestmentApprovalResult"></div>
						</div>
						<div class="view-report-details-wrapper">	
							<div class="view-report-details-header">Valuation Information (Listed Company)</div>
							<table class="full-width">
								<tr>
		   							<td>PE Valuation Report(Daily)</td>
		   							<td>
		   								<div id="peValuationReportListDaily"><label>Client</label></div>
		   							</td>
		   							<td>PE Valuation Report(Monthly)</td>
		   							<td>
		   								<div id="peValuationReportListMonthly"><label>Project</label></div>
		   							</td>
		   						</tr>
	   						</table>
						</div>
						
						<div class="view-report-details-wrapper">	
							<div class="view-report-details-header">Valuation Information (Non-Listed Company)</div>
							<table class="full-width">
								<tr>
		   							<td>PE Valuation Report</td>
		   							<td>
		   								<div id="peValuationReportNonList"><label>Client</label></div>
		   							</td>
		   							<td>&nbsp;</td>
		   							<td>
		   								&nbsp;
		   							</td>
		   						</tr>
	   						</table>
						</div>
					</div>	
			</div>	
			<div class="view-report-details-wrapper">	
					<div class="view-report-details-header">Guarantor Information (If Applicable)</div>
					<div id="peInvestmentGuarantorResult"></div>
			</div>		
			<div class="view-report-details-wrapper">	
					<div class="view-report-details-header">Attachments</div>
					<div><a href="LSFLoanDetails">Open Document Upload</a></div>
			</div>		
					 		
	    			
	    	</div>		
    			
  		</div>
  	
  	
  	</div>

    </body>
    </html>
    