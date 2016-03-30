<html lang="en">

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
<link href="/ermsweb/resources/css/layout.css" rel="stylesheet"
	type="text/css">
	
<!-- jQuery JavaScript -->
<script src="/ermsweb/resources/js/jquery.min.js"></script>
<script src="/ermsweb/resources/js/common_tools.js"></script>

<!-- Kendo UI combined JavaScript -->
<script src="/ermsweb/resources/js/kendo.all.min.js"></script>
<script src="/ermsweb/resources/js/common_tools.js"></script>

<style type="text/css">
.k-grid-header tr th.k-header, .grid-container tr th {
	background-color: #B54D4D;
	font-size: 13px;
	color: #fff;
	white-space: pre-line;
}

.grid-container tr th {
	min-width: 150px;
	padding: 5px;
	white-space: nowrap;
	border-right: 1px solid #c5c5c5;
	background-image: none,
		linear-gradient(to bottom, rgba(255, 255, 255, 0.6) 0px,
		rgba(255, 255, 255, 0) 100%);
}

#filterBody tr td:nth-child(even) {
	padding-right: 10px;
}

.empty-height {
	padding: 10px;
	margin: 0;
}
</style>
<script>
	var objPastToPager = null; // This value will be used to pass the value to another list

	var initialLoad = true; // Nothing
		$(document).ready(
		function(){
			/* Control and initialize the menu bar of header
			 (8 options of menu)
			*/
			$("#menu1").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			$("#menu2").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			$("#menu3").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			$("#menu4").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			$("#menu5").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			$("#menu6").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			$("#menu7").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});

			/* Calling the ajax loader image */
			openModal();
			
			var paramCCDID = '${ccdId}';// ${ccdId} is from server which returns ccdID 
			
			/*Datasource for ClientCounterDetails*/
			var dataSource = new kendo.data.DataSource({
				transport: {
					read: {
						url: window.sessionStorage.getItem('serverPath')+"legalParty/getRecord?ccdId="+paramCCDID+"&userId="+window.sessionStorage.getItem("username"),
						
						dataType: "json",
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
			/*Binding Data for ClientCounter Details*/
			dataSource.fetch(function(){
				var jsonObj = this.view();
				$.each(jsonObj, function(i){
					if(jsonObj[i].ccdId == paramCCDID){
						$("#ccd_id_label").html("<label>"+jsonObj[i].ccdId+"</label>");
						$("#client_counterparty_name_label").html("<label>"+validateResponse(jsonObj[i].legalPartyEngName)+"</label>");
						$("#client_counterparty_chinese_name_label").html("<label>"+validateResponse(jsonObj[i].legalPartyChiName)+"</label>");
						$("#client_counterparty_category_label").html("<label>"+validateResponse(jsonObj[i].legalPartyCat)+"</label>");
						
						$("#ultimate_controller_label").html("<label>"+validateResponse(jsonObj[i].ultimateController)+"</label>");
						$("#financial_report_date_label").html("<label>"+validateResponse(toDateFormat(jsonObj[i].latestFinRptDate))+"</label>");
						$("#op_inv_label").html("<label>"+validateResponse(jsonObj[i].holdingType)+"</label>");
						$("#staff_indicator_label").html("<label>"+validateResponse(jsonObj[i].isStaffInd)+"</label>");
						$("#is_public_listed_label").html("<label>"+validateResponse(jsonObj[i].publicListedCompaniesIdr)+"</label>");
						
						$("#exc_deals_internal_ccp_label").html("<label>"+validateResponse(jsonObj[i].excludeDealInternalCpty)+"</label>");
						$("#cust_type_HKMA_label").html("<label>"+validateResponse(jsonObj[i].hkmaCustTypeCode)+"</label>");
						$("#is_HKMA_auth_institute_label").html("<label>"+validateResponse(jsonObj[i].isHkmaAuthInst)+"</label>");
						$("#warehouse_LME_label").html("<label>"+validateResponse(jsonObj[i].lmeRegisteredWarehouse)+"</label>");
						$("#boci_branch_label").html("<label>"+validateResponse(jsonObj[i].bociBranch)+"</label>");
						
						$("#cp_branch_label").html("<label>"+validateResponse(jsonObj[i].cptyBranch)+"</label>");
						$("#company_desc_label").html("<label>"+validateResponse(jsonObj[i].companyDesc)+"</label>");
						$("#company_bussiness_rel_strategy_label").html("<label>"+validateResponse(jsonObj[i].companyBizRelStrategy)+"</label>");
						$("#company_risk_analysis_business_label").html("<label>"+validateResponse(jsonObj[i].bizRiskProfile)+"</label>");						
						$("#company_risk_analysis_finance_label").html("<label>"+validateResponse(jsonObj[i].finRiskProfile)+"</label>");
						$("#company_market_indicators_label").html("<label>"+validateResponse(jsonObj[i].companyMarketInd)+"</label>");
						$("#company_credit_rec_strategy_label").html("<label>"+validateResponse(jsonObj[i].companyCrRecomStrategy)+"</label>");
						$("#company_reference_label").html("<label>"+validateResponse(jsonObj[i].companyReference)+"</label>");
						$("#insurance_provider_ccdid_label").html("<label>"+validateResponse(jsonObj[i].insuranceProviderCcdId)+"</label>");
						$("#portfolio_code_label").html("<label>"+validateResponse(jsonObj[i].portfolioCode)+"</label>");
						$("#portfolio_name_label").html("<label>"+validateResponse(jsonObj[i].portfolioName)+"</label>");
												
						$("#domicile_label").html("<label>"+validateResponse(jsonObj[i].domicile)+"</label>");
						$("#nationality_label").html("<label>"+validateResponse(jsonObj[i].nationality)+"</label>");
						$("#business_nature_label").html("<label>"+validateResponse(jsonObj[i].natureOfBiz)+"</label>");
						$("#annual_income_label").html("<label>"+validateResponse(jsonObj[i].annualIncome)+"</label>");
						$("#estimate_net_worth_label").html("<label>"+validateResponse(jsonObj[i].estimateNetWorth)+"</label>");						
						$("#stock_code_for_listed_company_label").html("<label>"+validateResponse(jsonObj[i].clientStockCode)+"</label>");
						$("#aum_in_boci_group_label").html("<label>"+validateResponse(jsonObj[i].aumBOCIGrp)+"</label>");	
						$("#last_credit_check_approved_condition_remark_label").html("<label>"+validateResponse(jsonObj[i].lastApproveCondRem)+"</label>");
						
						$("#country_of_risk_label").html("<label>"+validateResponse(jsonObj[i].countryRisk)+"</label>");
						$("#industry_group_label").html("<label>"+validateResponse(jsonObj[i].industryGroup)+"</label>");
						$("#industry_subgroup_label").html("<label>"+validateResponse(jsonObj[i].industrySubGroup)+"</label>");
						$("#industry_sector_label").html("<label>"+validateResponse(jsonObj[i].industrySector)+"</label>");
						$("#market_capitalization_label").html("<label>"+validateResponse(jsonObj[i].marketCapitalizaion)+"</label>");
						
						$("#credit_rating_internal_basel_label").html("<label>"+validateResponse(jsonObj[i].creditRatingInt)+"</label>");
						$("#credit_rating_moodys_label").html("<label>"+validateResponse(jsonObj[i].creditRatingMoodys)+"</label>");
						$("#credit_rating_s_p_label").html("<label>"+validateResponse(jsonObj[i].creditRatingSnp)+"</label>");
						$("#credit_rating_fitch_label").html("<label>"+validateResponse(jsonObj[i].creditRatingFitch)+"</label>");
						
						$("#risk_rating_approval_label").html("<label>"+validateResponse(jsonObj[i].creditRatingForApprove)+"</label>");
						$("#overall_loan_classification_label").html("<label>"+validateResponse(jsonObj[i].overallLoanClassification)+"</label>");
						$("#down_grade_date_label").html("<label>"+validateResponse(jsonObj[i].downgradeDate)+"</label>");
						$("#bbg_ticker_label").html("<label>"+validateResponse(jsonObj[i].bbgTicker)+"</label>");
						$("#bbg_companyid_label").html("<label>"+validateResponse(jsonObj[i].bbgCompanyId)+"</label>");						
						$("#cds_ticker_label").html("<label>"+validateResponse(jsonObj[i].cdsTicker)+"</label>");
						$("#remarks_label").html("<label>"+validateResponse(jsonObj[i].remarks)+"</label>");
						$("#primary_legal_name_label").html("<label>"+validateResponse(jsonObj[i].priLegalName)+"</label>");
						$("#primary_legal_doc_no_label").html("<label>"+validateResponse(jsonObj[i].priLegalDocNo)+"</label>");
						$("#DOB_incorporation_label").html("<label>"+validateResponse(jsonObj[i].dateOfBirth)+"</label>");						
						$("#gender_label").html("<label>"+validateResponse(jsonObj[i].gender)+"</label>");
						$("#primary_legal_address_label").html("<label>"+validateResponse(jsonObj[i].priLegalAddr)+"</label>");
						$("#primary_contact_no_label").html("<label>"+validateResponse(jsonObj[i].priContact)+"</label>");
						
						$("#checkEXTKey1").html("<label>"+validateResponse(jsonObj[i].externalKey1)+"</label>");
						$("#checkEXTKey2").html("<label>"+validateResponse(jsonObj[i].externalKey2)+"</label>");
						$("#checkEXTKey3").html("<label>"+validateResponse(jsonObj[i].externalKey3)+"</label>");
						$("#checkEXTKey4").html("<label>"+validateResponse(jsonObj[i].externalKey4)+"</label>");
						$("#checkEXTKey5").html("<label>"+validateResponse(jsonObj[i].externalKey5)+"</label>");
						$("#checkEXTKey6").html("<label>"+validateResponse(jsonObj[i].externalKey6)+"</label>");
						$("#checkEXTKey7").html("<label>"+validateResponse(jsonObj[i].externalKey7)+"</label>");
						$("#checkEXTKey8").html("<label>"+validateResponse(jsonObj[i].externalKey8)+"</label>");
						$("#checkEXTKey9").html("<label>"+validateResponse(jsonObj[i].externalKey9)+"</label>");
						$("#checkEXTKey10").html("<label>"+validateResponse(jsonObj[i].externalKey10)+"</label>");
						$("#created_by").html(jsonObj[i].createdBy);
						$("#created_at").html(jsonObj[i].createdAt);
						$("#updated_by").html(jsonObj[i].updatedBy);
						$("#updated_at").html(jsonObj[i].updatedAt);
						$("#verified_by").html(jsonObj[i].verifiedBy);
						$("#verified_at").html(jsonObj[i].verifiedAt);
						$("#status_last").html(jsonObj[i].status);
						$("#buttonType").html("<label>    </label><button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Back</button>");
					}
				});
			});
		
		/*Datasource for Guarantor List*/
		var accountList = new kendo.data.DataSource({
			transport: {
				read: {
					url: window.sessionStorage.getItem('serverPath')+"legalParty/getLegalPartyAccounts?ccdId="+paramCCDID+"&userId="+window.sessionStorage.getItem("username"),
					dataType: "json",
					xhrFields: {
			    		withCredentials: true
			    	}
				}
			},
			pageSize:3		
		});
		/*Binding Data for account List to the Grid*/
		$("#accountList").kendoGrid({
			dataSource: accountList,
			scrollable:true,
			pageable: true,
			columns: [
				{field: "ccdId", title: "CCD_ID", width: 30},
				{field: "cmdCustId", title: "CMD Cust ID", width: 30},
				{field: "legalPartyName", title: "Legal Party Name", width: 30},
				{field: "acctId", title: "Acct ID", width: 30},
				{field: "subAcctId", title: "Sub Account ID", width: 30},
				{field: "acctName", title: "Acct Name", width: 30},
				{field: "isJointAcctInd", title: "", width: 30},
				{field: "acctType", title: "Account Type", width: 30},
				{field: "acctOpenDate", title: "Account Open Date", width: 30},
				{field: "cmdAcctStatus", title: "CMD Acct Status", width: 30},
				{field: "bookEntity", title: "Book Entity", width: 30},
				{field: "bizUnit", title: "Business Unit", width: 30},
				{field: "salesmanCode", title: "Salemen Code", width: 30},
				{field: "salesmanName", title: "Salemen Name", width: 30},
				{field: "salesmanDept", title: "Salemen Dept", width: 30},
				{field: "dateSourceAppId", title: "Date Source App ID", width: 30}
			]
		});

		/*Datasource for Guarantor List*/
		var guarantordataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: window.sessionStorage.getItem('serverPath')+"legalParty/getLegalPartyGuarantor?ccdId="+paramCCDID+"&userId="+window.sessionStorage.getItem("username"),
					dataType: "json",
					xhrFields: {
			    		withCredentials: true
			    	}
				}
			},
			pageSize:3		
		});
		/*Binding Data for Guarantor List to the Grid*/
		$("#guarantorList").kendoGrid({
			dataSource: guarantordataSource,
			scrollable:true,
			pageable: true,
			columns: [
				{ field: "guarId", title: "Guarantor ID " , width: 30},
				{ field: "limitType", title: "Limit Type ", width: 30},
				{ field: "facId", title: "Facility ID", width: 30},
				{ field: "guarName", title: "Guarantor Name", width: 30},
				{ field: "relWithBwr", title: "Relationship with Borrower", width: 30},
				{ field: "guarDomicile", title: "Guarantor Domicile", width: 30},
				{ field: "guarAddr", title: "Guarantor Address", width: 30},
				{ field: "creditSupScope", title: "Credit Support Scope ", width: 30},
				{ field: "Support_Type", title: "Support Type", width: 30},
				{ field: "guarCollAmtCapCcy", title: "Guarantee / Collateral Amount Cap Ccy ", width: 30},
				{ field: "guatColAmtCap", title: "Guarantee / Collateral Amount Cap ", width: 30},
				{ field: "guarExpDate", title: "Guarantee Expiry Date ", width: 30},
				{ field: "noticePeriod", title: "Notice Period", width:30}
			]
		});
		
		/*Datasource for ThirdPartyCollateral List*/
		var collateraldataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: window.sessionStorage.getItem('serverPath')+"legalParty/getLegalParty3rdPtyCollProvider?ccdId="+paramCCDID+"&userId="+window.sessionStorage.getItem("username"),
					dataType: "json",
					xhrFields: {
			    		withCredentials: true
			    	}
				}
			},
			pageSize:1									
		});
		/*Binding Data for ThirdPartyCollateral List to the Grid*/
		$("#collateralList").kendoGrid({
			dataSource: collateraldataSource,
			scrollable:true,
			pageable: true,
			columns: [
				{ field: "relationship", title: "Relationship" , width: 30},
				{ field: "chargorBwrName", title: "Chargor/Borrower Name", width: 30},
				{ field: "crossCollCapCcyOnRel", title: "Cross collateral cap currency on Relationship", width: 30},
				{ field: "crossCollCapAmtOnRel", title: "Cross collateral cap amount on Relationship ", width: 30},
				{ field: "relExpDate", title: "Relationship Expiry Date", width: 30}
			 ]
		});
	 	
		
		/*Calling the method for hiding the ajaxloader image*/
		closeModal();
	});
	
	function validateResponse(data){
		return (data != null) ? data : "";
	}
	
	/* Open spinner while getting the data from back-end*/
	function openModal() {
		$("#modal, #modal1, #modal2, #modal3").show();
	}
	/* Close spinner after getting the data from back-end*/
	function closeModal() {
		$("#modal, #modal1, #modal2, #modal3").hide();	    
	}

	/* Action - Save button */
	function toUpdate(uid){
		window.location = "/ermsweb/viewUpdate?ccdId="+uid;
	}
	
	/* Action - Back button */
	function toBack(){
		//window.history.back();
		window.location = "/ermsweb/ccprmddetailmaintenance";
	}
		
    </script>

<body>
	<%@include file="header1.jsp"%>
	<div class="page-title">Client Counterparty RMD Detail Maintenance - View Client Counterparty Detail</div>
	
	<!-- <input type="hidden" id="pagetitle" name="pagetitle"
		value="Client Counterparty RMD Detail section"> -->
	<table id="listTable" width="500" cellpadding="6" cellspacing="1"
		style="overflow-y: scroll">
		<tr>
			<td></td>
			<td align="right"></td>
		</tr>
		<tr>
			<td colspan="4"
				style="background-color: #393052; color: white; width: 500; font-size: 13px">
				Client / Counterparty Details</td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">CCD
				ID.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="ccd_id_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Client/Counterparty
				Name.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="client_counterparty_name_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Client/Counterparty
				Chinese Name.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="client_counterparty_chinese_name_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Client/Counterparty
				Category.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="client_counterparty_category_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Ultimate
				Controller.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="ultimate_controller_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Latest
				Financial Report Date.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="financial_report_date_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Operating
				/ Investment Holding.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="op_inv_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">BOCI
				Staff Indicator.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="staff_indicator_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Is
				Public / Listed Company.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="is_public_listed_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Exclude
				Deals with Internal Counterparty.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="exc_deals_internal_ccp_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">HKMA
				Customer Type.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="cust_type_HKMA_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Is
				HKMA Authorized Institution.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="is_HKMA_auth_institute_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">LME
				Registered Warehouse.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="warehouse_LME_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">BOCI-Branch.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="boci_branch_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Counterparty
				Branch.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="cp_branch_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Company
				Description.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="company_desc_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Company
				Business Relationship & Strategy.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="company_bussiness_rel_strategy_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Company
				Risk Analysis - Business Risk Profile.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="company_risk_analysis_business_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Company
				Risk Analysis - Financial Risk Profile.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="company_risk_analysis_finance_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Company
				Market Indicators.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="company_market_indicators_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Company
				Credit Recommendation & Strategy.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="company_credit_rec_strategy_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Company
				Reference.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="company_reference_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Insurance
				Provider CCD ID.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="insurance_provider_ccdid_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Portfolio
				Code.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="portfolio_code_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Portfolio
				Name.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="portfolio_name_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Domicile.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="domicile_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Nationality.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="nationality_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Business
				Nature.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="business_nature_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Annual
				Income.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="annual_income_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Estimate
				Net Worth.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="estimate_net_worth_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Stock
				Code (for listed company).</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="stock_code_for_listed_company_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">AUM
				in BOCI Group.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="aum_in_boci_group_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Last
				Credit Check Approved Condition Remark.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="last_credit_check_approved_condition_remark_label">
					<label></label>
				</div></td>
		</tr>

		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Country
				of Risk.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="country_of_risk_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Industry
				Group.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="industry_group_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Industry
				Sub-Group.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="industry_subgroup_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Industry
				Sector.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="industry_sector_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Market
				Capitalization.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="market_capitalization_label">
					<label></label>
				</div></td>
		</tr>

		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Internal
				Credit Rating (Basel).</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="credit_rating_internal_basel_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Credit
				Rating - S&amp;P.</td0>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="credit_rating_s_p_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Credit
				Rating - Moody's.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="credit_rating_moodys_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Credit
				Rating - Fitch.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="credit_rating_fitch_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Risk
				Rating - for Approval.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="risk_rating_approval_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Overall
				Loan Classification.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="overall_loan_classification_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Down
				Grade Date.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="down_grade_date_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">BBG
				Ticker.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="bbg_ticker_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">BBG
				Company ID.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="bbg_companyid_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">CDS
				Ticker.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="cds_ticker_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Remarks.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="remarks_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Primary
				Legal Name.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="primary_legal_name_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Primary
				Legal Document No.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="primary_legal_doc_no_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Date
				of Birth / Incorporation.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="DOB_incorporation_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Gender.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="gender_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Primary
				Legal Address.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="primary_legal_address_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">Primary
				Contact Number.</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
					id="primary_contact_no_label">
					<label></label>
				</div></td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
				Key ID #1</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF">
				<div id="checkEXTKey1" />
			</td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
				Key ID #2</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF">
				<div id="checkEXTKey2" />
			</td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
				Key ID #3</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF">
				<div id="checkEXTKey3" />
			</td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
				Key ID #4</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF">
				<div id="checkEXTKey4" />
			</td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
				Key ID #5</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF">
				<div id="checkEXTKey5" />
			</td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
				Key ID #6</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF">
				<div id="checkEXTKey6" />
			</td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
				Key ID #7</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF">
				<div id="checkEXTKey7" />
			</td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
				Key ID #8</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF">
				<div id="checkEXTKey8" />
			</td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
				Key ID #9</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF">
				<div id="checkEXTKey9" />
			</td>
		</tr>
		<tr>
			<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
				Key ID #10</td>
			<td width="333" style="font-size: 13px; background-color: #E7E3EF">
				<div id="checkEXTKey10" />
			</td>
		</tr>
		<tr>
			<td><br></td>
		</tr>
		<tr></tr>
		<tr></tr>
	</table>
	<br />

	<div>
		<table width="100%">
			<tr style="background-color: #082439; color: white">
				<td colspan="16">
					<div style="font-size: 13px">Client Counterparty Account List</div>
				</td>
			</tr>
			<tr>
				<td>
					<div id="accountList">
						<table id="list-header" class="grid-container" cellpadding="0"
							cellspacing="0" border="0">
							<tr>
								<th width="166">CCD ID&nbsp;</th>
								<th width="166">CMD Client ID&nbsp;</th>
								<th width="166">Client/Counterparty&nbsp;</th>
								<th width="166">Account No.&nbsp;</th>
								<th width="166">Sub Acc&nbsp;</th>
								<th width="166">Account_Name&nbsp;</th>
								<th width="166">Acc - is Joint (Y/N)&nbsp;</th>
								<th width="166">Acc - Acc Type&nbsp;</th>
								<th width="166">Acc - Open Date&nbsp;</th>
								<th width="166">Acc - Status&nbsp;</th>
								<th width="166">Acc - Entity&nbsp;</th>
								<th width="166">Acc - Biz Unit&nbsp;</th>
								<th width="166">Acc - Sales Code&nbsp;</th>
								<th width="166">Acc - Sales Name&nbsp;</th>
								<th width="166">Acc - Dept Code&nbsp;</th>
								<th width="166">Acc - Source System&nbsp;</th>
							</tr>
						</table>
					</div>
					

				</td>
			</tr>
		</table>
		<br />
	</div>
	<div style="font-size: 13px" id="countRow1"></div>
	<br />

	<div>
		<table id="list1" width="100%">
			<tr style="background-color: #082439; color: white">
				<td colspan="13">
					<div style="font-size: 13px">Guarantor List section</div>
				</td>
			</tr>
			<tr>
				<td>
					<div id="guarantorList">
						<table id="list-header" class="grid-container" cellpadding="0"
							cellspacing="0" border="0">
							<tr>
								<th width="166">Guarantor ID&nbsp;</th>
								<th width="166">Limit Type&nbsp;</th>
								<th width="166">Facility ID&nbsp;</th>
								<th width="166">Guarantor Name&nbsp;</th>
								<th width="166">Relationship with Borrower&nbsp;</th>
								<th width="166">Guarantor Domicile&nbsp;</th>
								<th width="166">Guarantor Address&nbsp;</th>
								<th width="166">Credit Support Scope&nbsp;</th>
								<th width="166">Support Type&nbsp;</th>
								<th width="166">Guarantee / Collateral Amount Cap Ccy&nbsp;</th>
								<th width="166">Guarantee / Collateral Amount Cap&nbsp;</th>
								<th width="166">Guarantee Expiry Date&nbsp;</th>
								<th width="166">Notice Period&nbsp;</th>
							</tr>
						</table>
					</div>
					

				</td>
			</tr>
		</table>
		<br />
	</div>
	<div style="font-size: 13px" id="countRow2"></div>
	<br />

	<div>
		<table id="list3" width="100%">
			<tr style="background-color: #082439; color: white">
				<td colspan="5">
					<div style="font-size: 13px">3rd Party Collateral Provider
						List</div>
				</td>
			</tr>
			<tr>
				<td>
					<div id="collateralList">
						<table id="list-header" class="grid-container" cellpadding="0"
							cellspacing="0" border="0">
							<tr>
								<th width="166">Relationship&nbsp;</th>
								<th width="166">Chargor/Borrower Name&nbsp;</th>
								<th width="166">Cross collateral cap currency on
									Relationship&nbsp;</th>
								<th width="166">Cross collateral cap amount on
									Relationship&nbsp;</th>
								<th width="166">Relationship Expiry Date&nbsp;</th>
							</tr>
						</table>
					</div>
					

				</td>
			</tr>
		</table>
		<br />
	</div>

	<div style="font-size: 13px" id="countRow3"></div>
	<br />
	<div style="width: 100%" id='MyGrid'></div>
	<table border="0" style="background-color: #B5D5AB; width: 100%;">
		<tr>
			<td width="195.5" style="font-size: 13px"><b>Created By</b></td>
			<td width="195.5" style="font-size: 13px"><label id="created_by"></label></td>
			<td width="195.5" style="font-size: 13px"></td>
			<td width="195.5" style="font-size: 13px"><b>Created At</b></td>
			<td width="195.5" style="font-size: 13px"><label id="created_at"></label></td>
		</tr>
		<tr>
			<td width="195.5" style="font-size: 13px"><b>Updated By</b></td>
			<td width="195.5" style="font-size: 13px"><label id="updated_by"></label></td>
			<td width="195.5" style="font-size: 13px"></td>
			<td width="195.5" style="font-size: 13px"><b>Updated At</b></td>
			<td width="195.5" style="font-size: 13px"><label id="updated_at"></label></td>
		</tr>
		<tr>
			<td width="195.5" style="font-size: 13px"><b>Verified By</b></td>
			<td width="195.5" style="font-size: 13px"><label
				id="verified_by"></label></td>
			<td width="195.5" style="font-size: 13px"></td>
			<td width="195.5" style="font-size: 13px"><b>Verified At</b></td>
			<td width="195.5" style="font-size: 13px"><label
				id="verified_at"></label></td>
		</tr>
		<tr>
			<td width="195.5" style="font-size: 13px"><b>Status</b></td>
			<td width="195.5" style="font-size: 13px"><label
				id="status_last"></label></td>
			<td width="195.5" style="font-size: 13px"></td>
			<td width="195.5" style="font-size: 13px"></td>
			<td width="195.5" style="font-size: 13px"></td>
		</tr>
	</table>
</body>
</html>
