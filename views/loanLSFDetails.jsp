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
    $(document).ready(function () {
    	
   		var loanTxNo = getURLParameters("loanTxNo");
		
		//var getGlobalListDetailsURL = "/ermsweb/resources/js/getLsfLoanDetail.json";
			
		var globalDataSource = new kendo.data.DataSource({
			transport: {
				read: {
					//url: getGlobalListDetailsURL,
					url: window.sessionStorage.getItem('serverPath')+"t24loan/getLsfLoanDetail?userId="+window.sessionStorage.getItem("username")+"&loanTxNo="+loanTxNo,
					
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
			schema:{
				data: function(data){
					return [data];
				}
			},
			pageSize:3
		});
		
		globalDataSource.fetch(function(){
			var dsData = this.view()[0];
			$("#projectName").html(validateResponse(dsData.projectName));
			$("#ltvRatio").html(validateResponse(dsData.ltvRatio));
			/*Borrower Information*/
			$("#borrower-list").kendoGrid({
				dataSource: globalDataSource,				
				scrollable:false,
				pageable: true,				
				columns:[
					{ field: "clientName"},
					{ field: "clientAcctId"},
					{ field: "clientNationality"},
					{ field: "clientIndustryGroup"},
					{ field: "clientCountryRisk"}
				]
			});
			/*Limit Information*/
			$("#facId").html(validateResponse(dsData.facId));
			$("#t24FacId").html(validateResponse(dsData.t24FacId));
			$("#facPurpose").html(validateResponse(dsData.facPurpose));
			$("#placeOfUse").html(validateResponse(dsData.placeOfUse));
			$("#approvalDate").html(validateResponse(validDate(dsData.approvalDate)));
			$("#t24facType").html(validateResponse(dsData.t24facType));
			$("#lmtCcy").html(validateResponse(dsData.lmtCcy));
			$("#lmtAmt").html(validateResponse(dsData.lmtAmt));
			$("#tenor").html(validateResponse(dsData.tenor));
			$("#repaymentSchedule").html(validateResponse(dsData.repaymentSchedule));
			$("#initDrawdownDate").html(validateResponse(validDate(dsData.initDrawdownDate)));
			$("#osExpo").html(validateResponse(dsData.osExpo));			
			$("#loanClassification").html(validateResponse(dsData.loanClassification));
			/*Sub Participation Ratio Information*/
			$("#spRatio-list").kendoGrid({
				dataSource: {
					data:dsData.lsfLoanSubPartRatioResult,
					pageSize:3
				},
				scrollable:false,
				pageable: true,
				columns:[
					{ field: "bookEntity"},
					{ field: "ratio"}
				]
			});
			/*Return Package Information*/
			$("#interest").html(dsData.lsfLoanReturnPackageResult[0]["interest"]);
			
			$("#return-package-list").kendoGrid({
				dataSource: {
					data:dsData.lsfLoanReturnPackageResult,
					pageSize:3
				},
				scrollable:false,
				pageable: true,
				columns:[
					{ field: "fee"},
					{ field: "dueDate", template: '#= kendo.toString( new Date(parseInt(dueDate)), "MM/dd/yyyy HH:MM:tt" ) #'},
					{ field: "paymentAmt", template: '<span class="tdSpan">#=paymentCcy#</span><span>#=paymentAmt#</span>'}
				]
			});
			/*Collateral Information*/
			$("#collateral-info-list").kendoGrid({
				dataSource: {
					data:dsData.lsfLoanCollateralResult,
					pageSize:3
				},
				scrollable:false,
				pageable: true,				
				columns:[
					{ field: "collType"},
					{ field: "description"},
					{ field: "nationality"},
					{ field: "valuationAmt", template: '<span class="tdSpan">#=valuationCcy#</span><span>#=valuationAmt#</span>'},
					{ field: "valueDate", template: '#= kendo.toString( new Date(parseInt(valueDate)), "MM/dd/yyyy HH:MM:tt" ) #'},
					{ field: "reviewFreq"}
				]
			});
			/*Guarantor Information*/
			$("#guarantor-info-list").kendoGrid({
				dataSource: {
					data:dsData.lsfLoanGuarantorResult,
					pageSize:3
				},
				scrollable:false,
				pageable: true,		
				columns:[
					{ field: "name"},
					{ field: "ccdId"},
					{ field: "guarShareInBorrower"},
					{ field: "nationality"},
					{ field: "guarAmt", template: '<span class="tdSpan">#=guarCcy#</span><span>#=guarAmt#</span>'},					
					{ field: "relWBorrower"}
				]
			});
			/*Loan Information*/
			$("#loan-info-list").kendoGrid({
				dataSource: globalDataSource,
				scrollable:false,
				pageable: true,
				columns:[
					{ field: "loanTxNo"},
					{ field: "acctId"},
					{ field: "drawdownAmt", template: '<span class="tdSpan">#=drawdownCcy#</span><span>#=drawdownAmt#</span>'},
					{ field: "drawdownDate", template: '#= kendo.toString( new Date(parseInt(drawdownDate)), "MM/dd/yyyy HH:MM:tt" ) #'}
				]
			});
		});		
	});		
		
	function validDate(obj){
    	return kendo.toString( new Date(parseInt(obj)), "MM/dd/yyyy HH:MM:tt" )
    }
	
	function validateResponse(data){
		return (data != null) ? data : "";
	}
	
	function openModal() {
	     $("#modal, #modal1").show();
	}

	function closeModal() {
	    $("#modal, #modal1").hide();	    
	}
	
    </script>
	<style>
		.tdSpan{
			padding-right:100px;
		}
	</style>
	<body>
	<div class="boci-wrapper">
		<div id="boci-content-wrapper">
			<div id="search_result_container">
				<div class="view-report-details-wrapper">
					<table cellpadding="0" cellspacing="0" border="0" class="full-width">
						<tr>
							<td colspan="4">
								<div class="view-report-details-header">Project Information</div>
							</td>
						</tr>
						<tr>
							<td>Project Name</td>
							<td id="projectName"></td>
							<td>LTV Ratio</td>
							<td id="ltvRatio"></td>
						</tr>					
					</table>
				</div>
				<div class="view-report-details-wrapper">
					<table cellpadding="0" cellspacing="0" border="0" class="full-width">
						<tr>
							<td colspan="5">
								<div class="view-report-details-header">Borrower Information</div>
							</td>
						</tr>
						<tr>
							<td>
								<div id="borrower-list">
									<table id="list-header1" class="grid-container full-width">
										<tr>
											<th>Name</th>
											<th>Account Number</th>
											<th>Country of Incorporation</th>
											<th>Industry</th>
											<th>Country of Risk</th>											
										</tr>								
									</table>							
								</div>
								
								<!-- <div>
									<img id="loader" src="images/ajax-loader.gif" />
								</div> -->						
							</td>
						</tr>					
					</table>
				</div>
				<div class="clear"></div>
				<div class="view-report-details-wrapper">
					<div class="view-report-details-header">Limit Information</div>
					<table cellpadding="0" cellspacing="0" border="0" class="full-width">
						<tr>
							<td>Facility ID</td>
							<td id="facId"></td>
							<td>T24 Facility ID</td>
							<td id="t24FacId"></td>							
						</tr>
						<tr>
							<td>Facility Purpose</td>
							<td id="facPurpose"></td>
							<td>Place of Use</td>
							<td id="placeOfUse"></td>							
						</tr>
						<tr>
							<td>Approval Date</td>
							<td id="approvalDate"></td>
							<td>Facility Type</td>
							<td id="t24facType"></td>							
						</tr>
						<tr>
							<td>Limit Amount</td>
							<td><span class="tdSpan" id="lmtCcy"></span><span class="tdSpan" id="lmtAmt"></span></td>
							<td>Loan Tenor</td>
							<td id="tenor"></td>							
						</tr>
						<tr>
							<td>Repayment Schedule</td>
							<td id="repaymentSchedule"></td>
							<td>Initial Drawdown Date</td>
							<td id="initDrawdownDate"></td>							
						</tr>
						<tr>
							<td>Outstanding Exposure</td>
							<td id="osExpo"></td>
							<td>Loan Classification</td>
							<td id="loanClassification"></td>							
						</tr>
					</table>
					<div class="view-report-details-wrapper">
						<table cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td colspan="5">
									<div class="view-report-details-header">Sub Participation Ratio</div>
								</td>
							</tr>
							<tr>
								<td>
									<div id="spRatio-list">
										<table class="grid-container">
											<tr>
												<th>Entity</th>
												<th>Ratio</th>											
											</tr>								
										</table>							
									</div>
									
									<!-- <div>
										<img id="loader" src="images/ajax-loader.gif" />
									</div> -->						
								</td>
							</tr>					
						</table>
					</div>
					<div class="view-report-details-wrapper">
						<table cellpadding="0" cellspacing="0" border="0" class="full-width">
							<tr>
								<td colspan="2">
									<div class="list-header">Return Package</div>
								</td>
							</tr>
							<tr>
								<td>Interest</td>
								<td id="interest"></td>								
							</tr>					
						</table>
					</div>
					<div class="view-report-details-wrapper">
						<table cellpadding="0" cellspacing="0" border="0" class="full-width">
							<tr>
								<td colspan="5">
									<div class="list-header">Return Package Details</div>
								</td>
							</tr>
							<tr>
								<td>
									<div id="return-package-list">
										<table class="grid-container full-width">
											<tr>
												<th>Fee</th>
												<th>Due Date</th>
												<th colspan="2">Payment Amount</th>												
											</tr>								
										</table>							
									</div>
									
									<!-- <div>
										<img id="loader" src="images/ajax-loader.gif" />
									</div> -->						
								</td>
							</tr>					
						</table>
					</div>
					<div class="view-report-details-wrapper">
						<table cellpadding="0" cellspacing="0" border="0" class="full-width">
							<tr>
								<td colspan="5">
									<div class="list-header">Collateral Information</div>
								</td>
							</tr>
							<tr>
								<td>
									<div id="collateral-info-list">
										<table class="grid-container full-width">
											<tr>
												<th>Type</th>
												<th>Description</th>												
												<th>Country</th>
												<th>Valuation</th>
												<th>Value Date</th>
												<th>Review Frequency</th>												
											</tr>								
										</table>							
									</div>
									
									<!-- <div>
										<img id="loader" src="images/ajax-loader.gif" />
									</div>	 -->					
								</td>
							</tr>					
						</table>
					</div>
					<div class="view-report-details-wrapper">
						<table cellpadding="0" cellspacing="0" border="0" class="full-width">
							<tr>
								<td colspan="5">
									<div class="list-header">Guarantor Information</div>
								</td>
							</tr>
							<tr>
								<td>
									<div id="guarantor-info-list">
										<table class="grid-container full-width">
											<tr>
												<th>Name</th>
												<th>CCD ID</th>
												<th>Guarantor Shareholding in the Borrower</th>
												<th>Nationality</th>
												<th>Guarantee Amount</th>
												<th>Relationship with the Borrower</th>
											</tr>								
										</table>							
									</div>
									
									<!-- <div>
										<img id="loader" src="images/ajax-loader.gif" />
									</div> -->						
								</td>
							</tr>					
						</table>
					</div>					
				</div>
				<div class="view-report-details-wrapper">
					<table cellpadding="0" cellspacing="0" border="0" class="full-width">
						<tr>
							<td colspan="5">
								<div class="list-header">Loan Information</div>
							</td>
						</tr>
						<tr>
							<td>
								<div id="loan-info-list">
									<table class="grid-container full-width">
										<tr>
											<th>Loan Reference ID</th>
											<th>Account Number</th>
											<th>Drawdown Amount</th>
											<th>Drawdown Date</th>	
										</tr>								
									</table>							
								</div>
								
								<!-- <div>
									<img id="loader" src="images/ajax-loader.gif" />
								</div> -->						
							</td>
						</tr>					
					</table>
				</div>
				<div class="view-report-details-wrapper">
					<div class="list-header">Attachments</div>
					<p><a href="#">Open Document Upload</a></p>
				</div>
				<div class="clear"></div>
			</div>									
		</div>
	</div>	
</body>
</html>	