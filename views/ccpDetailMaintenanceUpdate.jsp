<!DOCTYPE html>
<html lang="en">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 
<script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>
<script type="text/javascript"
	src="/ermsweb/resources/js/common_tools.js"></script>



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

<!-- <head>Enquiry Loan Sub-Participation Ratio</head> -->
<style type="text/css">
.k-grid-header tr th.k-header {
	background-color: #B54D4D;
	font-size: 13px;
	color: #fff;
	white-space: pre-line;
}

#listTable textarea {
	width: 325px;
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

			/* Get the action type - view for directing to the view mode on this page */
			/* Replacing the button, label from update to view */
			/* Maker action -> */
		
		
		var paramCCDID = '${ccdId}';
		
		var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: window.sessionStorage.getItem('serverPath')+"legalParty/getRecord?ccdId="+paramCCDID+"&userId="+window.sessionStorage.getItem("username"),
					dataType: "json",
					
    			    xhrFields: {
			    		withCredentials: true
			    	},
			    	contentType: "application/json; charset=utf-8"
				},
				update:{
					type:"POST",
					url : function(options) {
			        	return window.sessionStorage.getItem('serverPath')+"legalParty/" + options.actionPage
					},
					dataType: "json",
					contentType:"application/json",
					complete: function (jqXHR, textStatus){
		                var response = JSON.parse(jqXHR.responseText);
		                if(response.action){
		                	if(response.action=="success"){
		                		window.sessionStorage.setItem('message', JSON.parse(jqXHR.responseText).message);
								window.location.href = "/ermsweb/ccprmddetailmaintenance";
		                	}
		                	
		                }
		                
					},
					xhrFields: {
			    		withCredentials: true
			    	}
				},
				parameterMap: function(options, operation) {
			      	if (operation != "read") {
			     		return JSON.stringify({
				        	legalPartyCat: options.legalPartyCat,
				        	ultimateController: options.ultimateController,
				        	latestFinRptDate: options.latestFinRptDate,
				        	holdingType: options.holdingType,
				        	excludeDealInternalCpty: options.excludeDealInternalCpty,
				        	isHkmaAuthInst: options.isHkmaAuthInst,
				        	lmeRegisteredWarehouse: options.lmeRegisteredWarehouse,
				        	bociBranch: options.bociBranch,
				        	cptyBranch: options.cptyBranch,
				        	companyDesc: options.companyDesc,
				        	companyBizRelStrategy: options.companyBizRelStrategy,
				        	bizRiskProfile: options.bizRiskProfile,
				        	finRiskProfile: options.finRiskProfile,
				        	companyMarketInd: options.companyMarketInd,
				        	companyCrRecomStrategy: options.companyCrRecomStrategy,
				        	companyReference: options.companyReference,
				        	insuranceProviderCcdId: options.insuranceProviderCcdId,
				        	countryRisk: options.countryRisk,
				        	industryGroup: options.industryGroup,
				        	industrySubGroup: options.industrySubGroup,
				        	industrySector: options.industrySector,
				        	marketCapitalizaion: options.marketCapitalizaion,
				        	creditRatingInt: options.creditRatingInt,
				        	creditRatingMoodys: options.creditRatingMoodys,
				        	creditRatingSnp: options.creditRatingSnp,
				        	creditRatingFitch: options.creditRatingFitch,
				        	creditRatingForApprove: options.creditRatingForApprove,
				        	overallLoanClassification: options.overallLoanClassification,
				        	downgradeDate: options.downgradeDate,
				        	bbgTicker: options.bbgTicker,
				        	bbgCompanyId: options.bbgCompanyId,
				        	cdsTicker: options.cdsTicker,
				        	remarks: options.remarks,
				        	externalKey1: options.externalKey1,
				        	externalKey2: options.externalKey2,
				        	externalKey3: options.externalKey3,
				        	externalKey4: options.externalKey4,
				        	externalKey5: options.externalKey5,
				        	externalKey6: options.externalKey6,
				        	externalKey7: options.externalKey7,
				        	externalKey8: options.externalKey8,
				        	externalKey9: options.externalKey9,
				        	externalKey10: options.externalKey10,
				        	userId: options.userId,
				        	ccdId: options.ccdId
				        });//JSON.stringify(options);
					}
				}
			},
			error:function(e){
				if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
			},
			schema: {
				model:{                           // describe the result format
		            id: "ccdId",
		            fields:{
		            	actionPage: {type: "string"}
		            }
		        }
	        }
		});
		 
		dataSource.fetch(function(){
			var jsonObj = this.data();
			$.each(jsonObj, function(i){
					$("#ccd_id_label").html("<label>"+jsonObj[i].ccdId+"</label>");
					$("#client_counterparty_name_label").html("<label>"+validateResponse(jsonObj[i].legalPartyEngName)+"</label>");
					$("#client_counterparty_chinese_name_label").html("<label>"+validateResponse(jsonObj[i].legalPartyChiName)+"</label>");
					$("#client_counterparty_category_label").html("<input style=\"width:100%\" id='cc_category' value='"+validateResponse(jsonObj[i].legalPartyCat)+"'/>");
					
					$("#ultimate_controller_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='ultimateController' value='"+validateResponse(jsonObj[i].ultimateController)+"'/>");
					$("#financial_report_date_label").html("<input style=\"width:100%\" id='latestFinRptDate' value='"+toDateFormat(validateResponse(jsonObj[i].latestFinRptDate))+"'/>");
					$("#op_inv_label").html("<span style='display:none;' class='hold_value'>"+validateResponse(jsonObj[i].holdingType)+"</span><input type='radio' name='op_holding' value='Y'/>Operating <input type='radio' name='op_holding' value='N'/>Investment Holding");
					$("#staff_indicator_label").html("<label>"+validateResponse(jsonObj[i].isStaffInd)+"</label>");
					$("#is_public_listed_label").html("<label>"+validateResponse(jsonObj[i].publicListedCompaniesIdr)+"</label>");
					
					$("#exc_deals_internal_ccp_label").html("<span style='display:none;' class='hold_value'>"+validateResponse(jsonObj[i].excludeDealInternalCpty)+"</span><input type='radio' name='exclude_deal' value='Y'/>Yes <input type='radio' name='exclude_deal' value='N'/>No");
					$("#cust_type_HKMA_label").html("<label>"+validateResponse(jsonObj[i].hkmaCustTypeCode)+"</label>");
					$("#is_HKMA_auth_institute_label").html("<span style='display:none;' class='hold_value'>"+validateResponse(jsonObj[i].isHkmaAuthInst)+"</span><input type='radio' name='hkma_auth' value='Y'/>Yes <input type='radio' name='hkma_auth' value='N'/>No");
					$("#warehouse_LME_label").html("<span style='display:none;' class='hold_value'>"+validateResponse(jsonObj[i].lmeRegisteredWarehouse)+"</span><input type='radio' name='lme_warehouse' value='Y'/>Yes <input type='radio' name='lme_warehouse' value='N'/>No");
					$("#boci_branch_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='bociBranch' value='"+validateResponse(jsonObj[i].bociBranch)+"'/>");
					
					$("#cp_branch_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='cptyBranch' value='"+validateResponse(jsonObj[i].cptyBranch)+"'/>");
					$("#company_desc_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='companyDesc' value=\""+validateResponse(jsonObj[i].companyDesc)+"\"></input>");
					$("#company_bussiness_rel_strategy_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='companyBizRelStrategy' value=\""+validateResponse(jsonObj[i].companyBizRelStrategy)+"\"></input>");
					$("#company_risk_analysis_business_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='bizRiskProfile' value='"+validateResponse(jsonObj[i].bizRiskProfile)+"'/>");						
					$("#company_risk_analysis_finance_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='finRiskProfile' value='"+validateResponse(jsonObj[i].finRiskProfile)+"'/>");
					$("#company_market_indicators_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='companyMarketInd' value='"+validateResponse(jsonObj[i].companyMarketInd)+"'/>");
					$("#company_credit_rec_strategy_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='companyCrRecomStrategy' value=\""+validateResponse(jsonObj[i].companyCrRecomStrategy)+"\"></input>");
					$("#company_reference_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='companyReference' value='"+validateResponse(jsonObj[i].companyReference)+"'/>");
					$("#insurance_provider_ccdid_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='insuranceProviderCcdId' value='"+validateResponse(jsonObj[i].insuranceProviderCcdId)+"'/>");
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
					
					$("#country_of_risk_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='countryRisk' value='"+validateResponse(jsonObj[i].countryRisk)+"'/>");
					$("#industry_group_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='industryGroup' value='"+validateResponse(jsonObj[i].industryGroup)+"'/>");
					$("#industry_subgroup_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='industrySubGroup' value='"+validateResponse(jsonObj[i].industrySubGroup)+"'/>");
					$("#industry_sector_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='industrySector' value='"+validateResponse(jsonObj[i].industrySector)+"'/>");
					$("#market_capitalization_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='marketCapitalizaion' value='"+validateResponse(jsonObj[i].marketCapitalizaion)+"'/>");
					
					$("#credit_rating_internal_basel_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='creditRatingInt' value='"+validateResponse(jsonObj[i].creditRatingInt)+"'/>");
					$("#credit_rating_moodys_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='creditRatingMoodys' value='"+validateResponse(jsonObj[i].creditRatingMoodys)+"'/>");
					$("#credit_rating_s_p_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='creditRatingSnp' value='"+validateResponse(jsonObj[i].creditRatingSnp)+"'/>");
					$("#credit_rating_fitch_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='creditRatingFitch' value='"+validateResponse(jsonObj[i].creditRatingFitch)+"'/>");
					
					$("#risk_rating_approval_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='creditRatingForApprove' value='"+validateResponse(jsonObj[i].creditRatingForApprove)+"'/>");
					$("#overall_loan_classification_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='overallLoanClassification' value='"+validateResponse(jsonObj[i].overallLoanClassification)+"'/>");
					$("#down_grade_date_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='downgradeDate' value='"+validateResponse(jsonObj[i].downgradeDate)+"'/>");
					$("#bbg_ticker_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='bbgTicker' value='"+validateResponse(jsonObj[i].bbgTicker)+"'/>");
					$("#bbg_companyid_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='bbgCompanyId' value='"+validateResponse(jsonObj[i].bbgCompanyId)+"'/>");						
					$("#cds_ticker_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='cdsTicker' value='"+validateResponse(jsonObj[i].cdsTicker)+"'/>");
					$("#remarks_label").html("<input style=\"width:100%\" class=\"k-textbox\" id='remarks' value=\""+validateResponse(jsonObj[i].remarks)+"\"></input>");
					$("#primary_legal_name_label").html("<label>"+validateResponse(jsonObj[i].priLegalName)+"</label>");
					$("#primary_legal_doc_no_label").html("<label>"+validateResponse(jsonObj[i].priLegalDocNo)+"</label>");
					$("#DOB_incorporation_label").html("<label>"+validateResponse(jsonObj[i].dateOfBirth)+"</label>");						
					$("#gender_label").html("<label>"+validateResponse(jsonObj[i].gender)+"</label>");
					$("#primary_legal_address_label").html("<label>"+validateResponse(jsonObj[i].priLegalAddr)+"</label>");
					$("#primary_contact_no_label").html("<label>"+validateResponse(jsonObj[i].priContact)+"</label>");
					
					$("#checkEXTKey1").html("<input style=\"width:100%\" class=\"k-textbox\" type='text' value='"+jsonObj[i].externalKey1+"'/>");
					$("#checkEXTKey2").html("<input style=\"width:100%\" class=\"k-textbox\" type='text' value='"+jsonObj[i].externalKey2+"'/>");
					$("#checkEXTKey3").html("<input style=\"width:100%\" class=\"k-textbox\" type='text' value='"+jsonObj[i].externalKey3+"'/>");
					$("#checkEXTKey4").html("<input style=\"width:100%\" class=\"k-textbox\" type='text' value='"+jsonObj[i].externalKey4+"'/>");
					$("#checkEXTKey5").html("<input style=\"width:100%\" class=\"k-textbox\" type='text' value='"+jsonObj[i].externalKey5+"'/>");
					$("#checkEXTKey6").html("<input style=\"width:100%\" class=\"k-textbox\" type='text' value='"+jsonObj[i].externalKey6+"'/>");
					$("#checkEXTKey7").html("<input style=\"width:100%\" class=\"k-textbox\" type='text' value='"+jsonObj[i].externalKey7+"'/>");
					$("#checkEXTKey8").html("<input style=\"width:100%\" class=\"k-textbox\" type='text' value='"+jsonObj[i].externalKey8+"'/>");
					$("#checkEXTKey9").html("<input style=\"width:100%\" class=\"k-textbox\" type='text' value='"+jsonObj[i].externalKey9+"'/>");
					$("#checkEXTKey10").html("<input style=\"width:100%\" class=\"k-textbox\" type='text' value='"+jsonObj[i].externalKey10+"'/>");
					
					$("#created_by").html(jsonObj[i].createdBy);
					$("#created_at").html(jsonObj[i].createdAt);
					$("#updated_by").html(jsonObj[i].updatedBy);
					$("#updated_at").html(jsonObj[i].updatedAt);
					$("#verified_by").html(jsonObj[i].verifiedBy);
					$("#verified_at").html(jsonObj[i].verifiedAt);
					$("#status_last").html(jsonObj[i].status);

					$("#buttonType").html("<button id=\"saveBtn\"  type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" >Save</button><label>    </label><button id=\"submitBtn\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Submit</button><label>    </label><button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Back</button>");   								
				
			});
			
			var categoryData = [
				{ text: "1", value: "1" },
      			{ text: "2", value: "2" },
      			{ text: "3", value: "3" },
      			{ text: "4", value: "4" }
      		];
      				
      		$("#cc_category").kendoDropDownList({
      			dataTextField: "text",
      			dataValueField: "value",
      			dataSource: categoryData,
      			index: 0
      		});	
      		
      		
      		var countryRiskData = [
				{ text: "1", value: "1" },	           
				{ text: "2", value: "2" },
				{ text: "3", value: "3" },
				{ text: "4", value: "4" }
      		];
      		
      		$("#countryRisk").kendoDropDownList({
      			dataTextField: "text",
      			dataValueField: "value",
      			dataSource: countryRiskData,
      			index: 0
      		});	
      		
      		$("#latestFinRptDate").kendoDatePicker({
      			format: "dd/MM/yyyy"
      		});
      		$("#latestFinRptDate").attr("readonly", "readonly");
      		
    		$("input[type='radio']").each(function(){
    			var hold_value = $(this).parent().find(".hold_value").text();
    			if(hold_value == $(this).val()){
    				$(this).prop("checked",true);
    			}
    		});
      		
      		$("#saveBtn").kendoButton({
    			click: function(){
    				
    				var updateCriteria = {
    					legalPartyCat:$("#cc_category").val(),
    					ultimateController:$("#ultimateController").val(),
    					latestFinRptDate:$("#latestFinRptDate").val(),
    					holdingType:$("input[name='op_holding']:checked").val(),
    					excludeDealInternalCpty:$("input[name='exclude_deal']:checked").val(),
    					isHkmaAuthInst:$("input[name='hkma_auth']:checked").val(),
    					lmeRegisteredWarehouse:$("input[name='lme_warehouse']:checked").val(),
    					bociBranch:$("#bociBranch").val(),
    					cptyBranch:$("#cptyBranch").val(),
    					companyDesc:$("#companyDesc").val(),
    					companyBizRelStrategy:$("#companyBizRelStrategy").val(),
    					bizRiskProfile:$("#bizRiskProfile").val(),
    					finRiskProfile:$("#finRiskProfile").val(),
    					companyMarketInd:$("#companyMarketInd").val(),
    					companyCrRecomStrategy:$("#companyCrRecomStrategy").val(),
    					companyReference:$("#companyReference").val(),
    					insuranceProviderCcdId:$("#insuranceProviderCcdId").val(),
    					countryRisk:$("#countryRisk").val(),
    					industryGroup:$("#industryGroup").val(),
    					industrySubGroup:$("#industrySubGroup").val(),
    					industrySector:$("#industrySector").val(),
    					marketCapitalizaion:$("#marketCapitalizaion").val(),
    					creditRatingInt:$("#creditRatingInt").val(),
    					creditRatingMoodys:$("#creditRatingMoodys").val(),
    					creditRatingSnp:$("#creditRatingSnp").val(),
    					creditRatingFitch:$("#creditRatingFitch").val(),
    					creditRatingForApprove:$("#creditRatingForApprove").val(),
    					overallLoanClassification:$("#overallLoanClassification").val(),
    					downgradeDate:$("#downgradeDate").val(),
    					bbgTicker:$("#bbgTicker").val(),
    					bbgCompanyId:$("#bbgCompanyId").val(),
    					cdsTicker:$("#cdsTicker").val(),
    					remarks:$("#remarks").val(),
    					externalKey1:$("#checkEXTKey1 input").val(),externalKey2:$("#checkEXTKey2 input").val(),externalKey3:$("#checkEXTKey3 input").val(),externalKey4:$("#checkEXTKey4 input").val(),externalKey5:$("#checkEXTKey5 input").val(),externalKey6:$("#checkEXTKey6 input").val(),externalKey7:$("#checkEXTKey7 input").val(),externalKey8:$("#checkEXTKey8 input").val(),externalKey9:$("#checkEXTKey9 input").val(),externalKey10:$("#checkEXTKey10 input").val(),
    					actionPage: "save",
    					userId: window.sessionStorage.getItem("username"),
    					ccdId: getURLParameters("ccdId")
   					}
    				
    				var dataDatasource = dataSource.at(0);
    				
    				dataDatasource.set("legalPartyCat", updateCriteria.legalPartyCat);
    				dataDatasource.set("ultimateController", updateCriteria.ultimateController);
    				dataDatasource.set("latestFinRptDate", strToDate(updateCriteria.latestFinRptDate));
    				dataDatasource.set("holdingType", updateCriteria.holdingType);
    				dataDatasource.set("excludeDealInternalCpty", updateCriteria.excludeDealInternalCpty);
    				dataDatasource.set("isHkmaAuthInst", updateCriteria.isHkmaAuthInst);
    				dataDatasource.set("lmeRegisteredWarehouse", updateCriteria.lmeRegisteredWarehouse);
					dataDatasource.set("bociBranch", updateCriteria.bociBranch);
    				dataDatasource.set("cptyBranch", updateCriteria.cptyBranch);
    				dataDatasource.set("companyDesc", updateCriteria.companyDesc);
    				dataDatasource.set("companyBizRelStrategy", updateCriteria.companyBizRelStrategy);
    				dataDatasource.set("bizRiskProfile", updateCriteria.bizRiskProfile);
    				dataDatasource.set("finRiskProfile", updateCriteria.finRiskProfile);
					dataDatasource.set("companyMarketInd", updateCriteria.companyMarketInd);
    				dataDatasource.set("companyCrRecomStrategy", updateCriteria.companyCrRecomStrategy);
    				dataDatasource.set("companyReference", updateCriteria.companyReference);
    				dataDatasource.set("insuranceProviderCcdId", updateCriteria.insuranceProviderCcdId);
					dataDatasource.set("countryRisk", updateCriteria.countryRisk);
    				dataDatasource.set("industryGroup", updateCriteria.industryGroup);
    				dataDatasource.set("industrySubGroup", updateCriteria.industrySubGroup);
    				dataDatasource.set("industrySector", updateCriteria.industrySector);
					dataDatasource.set("marketCapitalizaion", updateCriteria.marketCapitalizaion);
    				dataDatasource.set("creditRatingInt", updateCriteria.creditRatingInt);
    				dataDatasource.set("creditRatingMoodys", updateCriteria.creditRatingMoodys);
    				dataDatasource.set("creditRatingSnp", updateCriteria.creditRatingSnp);
    				dataDatasource.set("creditRatingFitch", updateCriteria.creditRatingFitch);
					dataDatasource.set("creditRatingForApprove", updateCriteria.creditRatingForApprove);
    				dataDatasource.set("overallLoanClassification", updateCriteria.overallLoanClassification);
    				dataDatasource.set("downgradeDate", updateCriteria.downgradeDate);
    				dataDatasource.set("bbgTicker", updateCriteria.bbgTicker);
    				dataDatasource.set("bbgCompanyId", updateCriteria.bbgCompanyId);
					dataDatasource.set("cdsTicker", updateCriteria.cdsTicker);
    				dataDatasource.set("remarks", updateCriteria.remarks);
    				dataDatasource.set("externalKey1",updateCriteria.externalKey1);
    				dataDatasource.set("externalKey2",updateCriteria.externalKey2);
    				dataDatasource.set("externalKey3",updateCriteria.externalKey3);
    				dataDatasource.set("externalKey4",updateCriteria.externalKey4);
    				dataDatasource.set("externalKey5",updateCriteria.externalKey5);
    				dataDatasource.set("externalKey6",updateCriteria.externalKey6);
    				dataDatasource.set("externalKey7",updateCriteria.externalKey7);
    				dataDatasource.set("externalKey8",updateCriteria.externalKey8);
    				dataDatasource.set("externalKey9",updateCriteria.externalKey9);
    				dataDatasource.set("externalKey10",updateCriteria.externalKey10);
    				dataDatasource.set("actionPage",updateCriteria.actionPage);
    				dataDatasource.set("userId",updateCriteria.userId);
    				dataDatasource.set("ccdId",updateCriteria.ccdId);
    				
    				dataSource.sync();
    			}
    		});
      		
      		$("#submitBtn").kendoButton({
    			click: function(){
    				
    				var updateCriteria = {
    					legalPartyCat:$("#cc_category").val(),
       					ultimateController:$("#ultimateController").val(),
       					latestFinRptDate:strToDate($("#latestFinRptDate").val()),
       					holdingType:$("input[name='op_holding']:checked").val(),
       					excludeDealInternalCpty:$("input[name='exclude_deal']:checked").val(),
       					isHkmaAuthInst:$("input[name='hkma_auth']:checked").val(),
       					lmeRegisteredWarehouse:$("input[name='lme_warehouse']:checked").val(),
       					bociBranch:$("#bociBranch").val(),
       					cptyBranch:$("#cptyBranch").val(),
       					companyDesc:$("#companyDesc").val(),
       					companyBizRelStrategy:$("#companyBizRelStrategy").val(),
       					bizRiskProfile:$("#bizRiskProfile").val(),
       					finRiskProfile:$("#finRiskProfile").val(),
       					companyMarketInd:$("#companyMarketInd").val(),
       					companyCrRecomStrategy:$("#companyCrRecomStrategy").val(),
       					companyReference:$("#companyReference").val(),
       					insuranceProviderCcdId:$("#insuranceProviderCcdId").val(),
       					countryRisk:$("#countryRisk").val(),
       					industryGroup:$("#industryGroup").val(),
       					industrySubGroup:$("#industrySubGroup").val(),
       					industrySector:$("#industrySector").val(),
       					marketCapitalizaion:$("#marketCapitalizaion").val(),
       					creditRatingInt:$("#creditRatingInt").val(),
       					creditRatingMoodys:$("#creditRatingMoodys").val(),
       					creditRatingSnp:$("#creditRatingSnp").val(),
       					creditRatingFitch:$("#creditRatingFitch").val(),
       					creditRatingForApprove:$("#creditRatingForApprove").val(),
       					overallLoanClassification:$("#overallLoanClassification").val(),
       					downgradeDate:$("#downgradeDate").val(),
       					bbgTicker:$("#bbgTicker").val(),
       					bbgCompanyId:$("#bbgCompanyId").val(),
       					cdsTicker:$("#cdsTicker").val(),
       					remarks:$("#remarks").val(),
       					externalKey1:$("#checkEXTKey1 input").val(),externalKey2:$("#checkEXTKey2 input").val(),externalKey3:$("#checkEXTKey3 input").val(),externalKey4:$("#checkEXTKey4 input").val(),externalKey5:$("#checkEXTKey5 input").val(),externalKey6:$("#checkEXTKey6 input").val(),externalKey7:$("#checkEXTKey7 input").val(),externalKey8:$("#checkEXTKey8 input").val(),externalKey9:$("#checkEXTKey9 input").val(),externalKey10:$("#checkEXTKey10 input").val(),
       					actionPage: "submit",
    					userId: window.sessionStorage.getItem("username"),
    					ccdId: getURLParameters("ccdId")
      				}
    				
    				var dataDatasource = dataSource.at(0);
    				
    				dataDatasource.set("legalPartyCat", updateCriteria.legalPartyCat);
    				dataDatasource.set("ultimateController", updateCriteria.ultimateController);
    				dataDatasource.set("latestFinRptDate", updateCriteria.latestFinRptDate);
    				dataDatasource.set("holdingType", updateCriteria.holdingType);
    				dataDatasource.set("excludeDealInternalCpty", updateCriteria.excludeDealInternalCpty);
    				dataDatasource.set("isHkmaAuthInst", updateCriteria.isHkmaAuthInst);
    				dataDatasource.set("lmeRegisteredWarehouse", updateCriteria.lmeRegisteredWarehouse);
					dataDatasource.set("bociBranch", updateCriteria.bociBranch);
    				dataDatasource.set("cptyBranch", updateCriteria.cptyBranch);
    				dataDatasource.set("companyDesc", updateCriteria.companyDesc);
    				dataDatasource.set("companyBizRelStrategy", updateCriteria.companyBizRelStrategy);
    				dataDatasource.set("bizRiskProfile", updateCriteria.bizRiskProfile);
    				dataDatasource.set("finRiskProfile", updateCriteria.finRiskProfile);
					dataDatasource.set("companyMarketInd", updateCriteria.companyMarketInd);
    				dataDatasource.set("companyCrRecomStrategy", updateCriteria.companyCrRecomStrategy);
    				dataDatasource.set("companyReference", updateCriteria.companyReference);
    				dataDatasource.set("insuranceProviderCcdId", updateCriteria.insuranceProviderCcdId);
					dataDatasource.set("countryRisk", updateCriteria.countryRisk);
    				dataDatasource.set("industryGroup", updateCriteria.industryGroup);
    				dataDatasource.set("industrySubGroup", updateCriteria.industrySubGroup);
    				dataDatasource.set("industrySector", updateCriteria.industrySector);
					dataDatasource.set("marketCapitalizaion", updateCriteria.marketCapitalizaion);
    				dataDatasource.set("creditRatingInt", updateCriteria.creditRatingInt);
    				dataDatasource.set("creditRatingMoodys", updateCriteria.creditRatingMoodys);
    				dataDatasource.set("creditRatingSnp", updateCriteria.creditRatingSnp);
    				dataDatasource.set("creditRatingFitch", updateCriteria.creditRatingFitch);
					dataDatasource.set("creditRatingForApprove", updateCriteria.creditRatingForApprove);
    				dataDatasource.set("overallLoanClassification", updateCriteria.overallLoanClassification);
    				dataDatasource.set("downgradeDate", updateCriteria.downgradeDate);
    				dataDatasource.set("bbgTicker", updateCriteria.bbgTicker);
    				dataDatasource.set("bbgCompanyId", updateCriteria.bbgCompanyId);
					dataDatasource.set("cdsTicker", updateCriteria.cdsTicker);
    				dataDatasource.set("remarks", updateCriteria.remarks);
    				dataDatasource.set("externalKey1",updateCriteria.externalKey1);
    				dataDatasource.set("externalKey2",updateCriteria.externalKey2);
    				dataDatasource.set("externalKey3",updateCriteria.externalKey3);
    				dataDatasource.set("externalKey4",updateCriteria.externalKey4);
    				dataDatasource.set("externalKey5",updateCriteria.externalKey5);
    				dataDatasource.set("externalKey6",updateCriteria.externalKey6);
    				dataDatasource.set("externalKey7",updateCriteria.externalKey7);
    				dataDatasource.set("externalKey8",updateCriteria.externalKey8);
    				dataDatasource.set("externalKey9",updateCriteria.externalKey9);
    				dataDatasource.set("externalKey10",updateCriteria.externalKey10);
    				dataDatasource.set("actionPage",updateCriteria.actionPage);
    				dataDatasource.set("userId",updateCriteria.userId);
    				dataDatasource.set("ccdId",updateCriteria.ccdId);
    				dataSource.sync();
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
	 		
	});

	function validateResponse(data){
		return (data != null) ? data : "";
	}
	
	function getURLParameters(paramName){
		var sURL = window.document.URL.toString();
		if(sURL.indexOf("?") > 0){
			var arrParams = sURL.split("?");
			var arrURLParams = arrParams[1].split("&");
			var arrParamNames = new Array(arrURLParams.length);
			var arrParamValues = new Array(arrURLParams.length)
		}
		var i = 0;
		for(i = 0; i < arrURLParams.length; i++){
			var sParam = arrURLParams[i].split("=");
			arrParamNames[i] = sParam[0];
			if(sParam[1] != ""){
				arrParamValues[i] = unescape(sParam[1]);
			}else{
				arrParamValues[i] = "No Value";
			}
		}

		for(i = 0; i < arrURLParams.length; i++){
			if(arrParamNames[i] == paramName){
				return arrParamValues[i];
			}
		}
		return "";
	}
	/* Open spinner while getting the data from back-end*/
	function openModal() {
		$("#modal, #modal1, #modal2, #modal3").show();
	}
	/* Close spinner after getting the data from back-end*/
	function closeModal() {
		$("#modal, #modal1, #modal2, #modal3").hide();	    
	}

	
	/* Action - Back button */
		function toBack(){
			sessionStorage.setItem("groupName",window.sessionStorage.getItem("groupName"));
			sessionStorage.setItem("groupType",window.sessionStorage.getItem("groupType"));
			sessionStorage.setItem("ccdId",window.sessionStorage.getItem("ccdId"));
			sessionStorage.setItem("cmdClientId",window.sessionStorage.getItem("cmdClientId"));
			sessionStorage.setItem("clientCptyName",window.sessionStorage.getItem("clientCptyName"));
			sessionStorage.setItem("accountNo",window.sessionStorage.getItem("accountNo"));
			sessionStorage.setItem("subAcc",window.sessionStorage.getItem("subAcc"));
			sessionStorage.setItem("accName",window.sessionStorage.getItem("accName"));
			sessionStorage.setItem("accBizUnit",window.sessionStorage.getItem("accBizUnit"));
			sessionStorage.setItem("message","");
			window.location = "/ermsweb/ccprmddetailmaintenance";
		}

    </script>

<body>
	<%@include file="header1.jsp"%>
	<div class="page-title">Client Counterparty RMD Detail Maintenance - Update Client Counterparty Detail</div>
	
	<table id="listTable" width:"500" cellpadding="6" cellspacing="1"
		style="overflow-y: scroll">
		<tr>
			<td></td>
			<td align="right">
				<div id="buttonType">Client / Counterparty Details</div>
			</td>
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

	<div style="overflow-y: scroll; overflow-y: hidden; width: 100% px;">
		<table id="list" width="100%">
			<tr style="background-color: #082439; color: white">
				<td colspan="16">
					<div style="font-size: 13px">Client Counterparty Account List</div>
				</td>
			</tr>
			<tr style="background-color: #BDCFE7; font-size: 13px;">
				<td width="166"><div id="accountList"></div></td>
			</tr>
			</tr>
		</table>
		<br />
	</div>
	<div style="font-size: 13px" id="countRow1"></div>
	<br />

	<div style="overflow-y: scroll; overflow-y: hidden; width: 100% px;">
		<table id="list1" width="100%">
			<tr style="background-color: #082439; color: white">
				<td colspan="13">
					<div style="font-size: 13px">Guarantor List section</div>
				</td>
			</tr>
			<tr style="background-color: #BDCFE7; font-size: 13px;">
				<td width="166"><div id="guarantorList"></div></td>

			</tr>
			<tr>
				<td colspan="8">
					<div id="modal1" align="center" style="display: none;">
						<img id="loader" src="/ermsweb/resources/images/ajax-loader.gif" />
					</div>
				</td>
			</tr>
		</table>
		<br />
	</div>
	<div style="font-size: 13px" id="countRow2"></div>
	<br />

	<div style="overflow-y: scroll; overflow-y: hidden; width: 100% px;">
		<table id="list2" width="100%">
			<tr style="background-color: #082439; color: white">
				<td colspan="5">
					<div style="font-size: 13px">3rd Party Collateral Provider
						List</div>
				</td>
			</tr>
			<tr style="background-color: #BDCFE7; font-size: 13px;">
				<td width="166"><div id="collateralList"></div></td>

			</tr>
			<tr>
				<td colspan="8">
					<div id="modal2" align="center" style="display: none;">
						<img id="loader" src="/ermsweb/resources/images/ajax-loader.gif" />
					</div>
				</td>
			</tr>
		</table>
		<br />
	</div>

	<div style="font-size: 13px" id="countRow3"></div>
	<br />
	<div style="width: 100%" id='MyGrid'>
		<div id="modal3" align="center" style="display: none;">
			<img id="loader2" src="/ermsweb/resources/images/ajax-loader.gif" />
		</div>
	</div>
	<table border="0" style="background-color: #B5D5AB">
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
