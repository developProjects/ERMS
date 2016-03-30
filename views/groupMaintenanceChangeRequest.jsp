<!DOCTYPE html>

<html lang="en">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 
<script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>


<!-- jQuery JavaScript -->
<script src="/ermsweb/resources/js/jquery.min.js"></script>

<!-- Kendo UI combined JavaScript -->
<script src="/ermsweb/resources/js/kendo.all.min.js"></script>

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
	
<script src="/ermsweb/resources/js/common_tools.js"></script>

<script>
	 	var objPastToPager = null; // This value will be used to pass the value to another list

	 	var initialLoad = true; // Nothing
 			$(document).ready(
 				function(){
 				
				$("#nextReviewDate").kendoDatePicker({
                    value: "",
                    format: "dd/MM/yyyy"          
                });
                $("#initialOnboardDate").kendoDatePicker({
                    value: "",
                    format: "dd/MM/yyyy"  
                });
				$("#latestFinancialReport").kendoDatePicker({
                    value: "",
                    format: "dd/MM/yyyy"  
                });
                $("#bfNextReviewDate").kendoDatePicker({
                    value: "",
                    format: "dd/MM/yyyy"  
                });
                $("#bfInitialOnboardDate").kendoDatePicker({
                	value: "",
                	format: "dd/MM/yyyy"  
                });
                $("#bfLatestFinancialReport").kendoDatePicker({
                	value: "",
                	format: "dd/MM/yyyy"  
                });            
                $("#bizUnitRespRiskOfficer").kendoDropDownList({
					height: '1em',
					optionLabel: 'Others'
				});
				$("#domicileField").kendoDropDownList({
					height: '1em',
					optionLabel: 'Others'
				});
				$("#countryOfRisk").kendoDropDownList({
					height: '1em',
					optionLabel: 'Others'
				});
				$("#nextReviewDate").attr("readonly","readonly" );
				$("#initialOnboardDate").attr("readonly","readonly" );
				$("#latestFinancialReport").attr("readonly","readonly" );
				$("#bfNextReviewDate").attr("readonly","readonly" );
				$("#bfInitialOnboardDate").attr("readonly","readonly" );
				$("#bfLatestFinancialReport").attr("readonly","readonly" );
                    
				var url = window.sessionStorage.getItem('serverPath')+"groupDetail/getRecord?crId="+getURLParameters("crId")+"&userId="+window.sessionStorage.getItem("username");
				/* ============================================================================================================= */
				var dataSource = new kendo.data.DataSource({
			    		transport: {
			    			read: {
			    	   		  	type: "GET",
			    			    url: url,
			    			    dataType: "json",
			    			    xhrFields: {
						    		withCredentials: true
						    	}
			    			}
			    		},
			    		schema: { 
				            model:{
				            	id: "crId",
				            	fields:{
				            		crId: {type: "string"}    
				            	}
				            }
				        },
			    		requestEnd: function(e) {
			    	        var response = e.response; 
			    	       	if(new RegExp("action\=view").test($(location).attr('href'))){
				     		
					     		document.getElementById("groupId").innerHTML = checkUndefinedElement(response.rmdGroupId);	
					     		document.getElementById("groupType").innerHTML = checkUndefinedElement(response.groupTypeDesc);		     	
					     		document.getElementById("groupName").innerHTML = checkUndefinedElement(response.rmdGroupDesc);
					     		document.getElementById("groupNameChi").innerHTML = checkUndefinedElement(response.rmdGroupDescChi);
					     		document.getElementById("groupBocGroupId").innerHTML = checkUndefinedElement(response.bocGroupId);
					     		document.getElementById("responsibleRiskOfficer").innerHTML = checkUndefinedElement(response.respRiskOfficer);
					     		document.getElementById("busUnitOfResponsibleRiskOfficer").innerHTML = checkUndefinedElement(response.bizUnitRespRiskOfficer);

     		 					document.getElementById("nextReviewDate").value = toDateFormat(checkUndefinedElement(response.nextReviewDate));
     		 					document.getElementById("initialOnboardDate").value = toDateFormat(checkUndefinedElement(response.initialOnboardDate));
     		 					document.getElementById("latestFinancialReport").value = toDateFormat(checkUndefinedElement(response.latestFinancialRptDate));

     		 					document.getElementById("domicileField").innerHTML = checkUndefinedElement(response.domicile);
     		 					document.getElementById("countryOfRisk").innerHTML = checkUndefinedElement(response.countryOfRisk);
     		 					document.getElementById("industryGroup").innerHTML = checkUndefinedElement(response.industryGroup);
     		 					document.getElementById("industrySubGroup").innerHTML = checkUndefinedElement(response.industrySubGroup);
     		 					document.getElementById("industrySector").innerHTML = checkUndefinedElement(response.industrySector);
     		 					document.getElementById("internalCreditRatingBasel").innerHTML = checkUndefinedElement(response.creditRatingInr);
     		 					document.getElementById("marketCapitalization").innerHTML = checkUndefinedElement(response.marketCapitalization);
     		 					document.getElementById("credit_rating_snp").innerHTML = checkUndefinedElement(response.creditRatingSnp);
     		 					document.getElementById("creditRatingMoodys").innerHTML = checkUndefinedElement(response.creditRatingMoodys);
     		 					document.getElementById("creditRatingFitch").innerHTML = checkUndefinedElement(response.creditRatingFitch);
     		 					document.getElementById("approvalRiskRating").innerHTML = checkUndefinedElement(response.riskRatingForApproval);
     		 					document.getElementById("overallLoanClass").innerHTML = checkUndefinedElement(response.overallLoanClassification);
     		 					document.getElementById("bbgTicker").innerHTML = checkUndefinedElement(response.bbgTicker);
     		 					document.getElementById("RemarksField").innerHTML = checkUndefinedElement(response.rmdGroupRemark);
					     		document.getElementById("extKey1").innerHTML = checkUndefinedElement(response.externalKey1);
					     		document.getElementById("extKey2").innerHTML = checkUndefinedElement(response.externalKey2);
					     		document.getElementById("extKey3").innerHTML = checkUndefinedElement(response.externalKey3);
					     		document.getElementById("extKey4").innerHTML = checkUndefinedElement(response.externalKey4);
					     		document.getElementById("extKey5").innerHTML = checkUndefinedElement(response.externalKey5);
								document.getElementById("extKey6").innerHTML = checkUndefinedElement(response.externalKey6);
								document.getElementById("extKey7").innerHTML = checkUndefinedElement(response.externalKey7);
								document.getElementById("extKey8").innerHTML = checkUndefinedElement(response.externalKey8); 
								document.getElementById("extKey9").innerHTML = checkUndefinedElement(response.externalKey9);
								document.getElementById("extKey10").innerHTML = checkUndefinedElement(response.externalKey10);	;
				     			document.getElementById("remarkArea").value = checkUndefinedElement(response.crRemark);

					     	}else{

					     		if(new RegExp("action\=update").test($(location).attr('href'))){
						     		document.getElementById("groupId").innerHTML = checkUndefinedElement(response.rmdGroupId);		     	
						     		document.getElementById("groupType").innerHTML = checkUndefinedElement(response.groupTypeDesc);		     	
						     		document.getElementById("groupName").innerHTML = checkUndefinedElement(response.rmdGroupDesc);
						     		document.getElementById("groupNameChi").innerHTML = checkUndefinedElement(response.rmdGroupDescChi);
						     		document.getElementById("groupBocGroupId").value = checkUndefinedElement(response.bocGroupId);
						     		document.getElementById("responsibleRiskOfficer").value = checkUndefinedElement(response.respRiskOfficer);

						     		var option = document.createElement("option");
						     		option.text = checkUndefinedElement(response.bizUnitRespRiskOfficer);
						     		option.value = checkUndefinedElement(response.bizUnitRespRiskOfficer);
						     		document.getElementById("busUnitOfResponsibleRiskOfficer").appendChild(option);
						     		document.getElementById("busUnitOfResponsibleRiskOfficer").selectedIndex = document.getElementById("busUnitOfResponsibleRiskOfficer").options.length - 1;
						     		option = null;

						     		/* ----------------------- */

	     		 					document.getElementById("nextReviewDate").value = toDateFormat(checkUndefinedElement(response.nextReviewDate));
	     		 					document.getElementById("initialOnboardDate").value = toDateFormat(checkUndefinedElement(response.initialOnboardDate));
	     		 					document.getElementById("latestFinancialReport").value = toDateFormat(checkUndefinedElement(response.latestFinancialRptDate));

	     		 					/* ----------------------- */

	     		 					var option = document.createElement("option");
						     		option.text = checkUndefinedElement(response.domicile);
						     		option.value = checkUndefinedElement(response.domicile);
						     		document.getElementById("domicileField").appendChild(option);
						     		document.getElementById("domicileField").selectedIndex = document.getElementById("domicileField").options.length - 1;
						     		option = null;
						     		/*document.getElementById("domicileField").value = checkUndefinedElement(response.domicile);*/

						     		/* ----------------------- */
						     		var option = document.createElement("option");
						     		option.text = checkUndefinedElement(response.countryOfRisk);
						     		option.value = checkUndefinedElement(response.countryOfRisk);
						     		document.getElementById("countryOfRisk").appendChild(option);
						     		document.getElementById("countryOfRisk").selectedIndex = document.getElementById("countryOfRisk").options.length - 1;
						     		option = null;
						     		/*document.getElementById("countryOfRisk").value = checkUndefinedElement(response.countryOfRisk);*/
	     		 					/* ----------------------- */
	     		 					
	     		 					document.getElementById("industryGroup").value = checkUndefinedElement(response.industryGroup);
	     		 					document.getElementById("industrySubGroup").value = checkUndefinedElement(response.industrySubGroup);
	     		 					document.getElementById("industrySector").value = checkUndefinedElement(response.industrySector);
	     		 					document.getElementById("internalCreditRatingBasel").value = checkUndefinedElement(response.creditRatingInr);
	     		 					document.getElementById("marketCapitalization").value = checkUndefinedElement(response.marketCapitalization);
	     		 					document.getElementById("creditRatingSnp").value = checkUndefinedElement(response.creditRatingSnp);
	     		 					document.getElementById("creditRatingMoodys").value = checkUndefinedElement(response.creditRatingMoodys);
	     		 					document.getElementById("creditRatingFitch").value = checkUndefinedElement(response.creditRatingFitch);
	     		 					document.getElementById("approvalRiskRating").value = checkUndefinedElement(response.riskRatingForApproval);
	     		 					document.getElementById("overallLoanClass").value = checkUndefinedElement(response.overallLoanClassification);
	     		 					document.getElementById("bbgTicker").value = checkUndefinedElement(response.bbgTicker);
	     		 					document.getElementById("RemarksField").value = checkUndefinedElement(response.rmdGroupRemark);
	     		 					
						     		document.getElementById("extKey1").value = checkUndefinedElement(response.externalKey1);
						     		document.getElementById("extKey2").value = checkUndefinedElement(response.externalKey2);
						     		document.getElementById("extKey3").value = checkUndefinedElement(response.externalKey3);
						     		document.getElementById("extKey4").value = checkUndefinedElement(response.externalKey4);
						     		document.getElementById("extKey5").value = checkUndefinedElement(response.externalKey5);
						     		document.getElementById("extKey6").value = checkUndefinedElement(response.externalKey6);
						     		document.getElementById("extKey7").value = checkUndefinedElement(response.externalKey7);
						     		document.getElementById("extKey8").value = checkUndefinedElement(response.externalKey8);
						     		document.getElementById("extKey9").value = checkUndefinedElement(response.externalKey9);
						     		document.getElementById("extKey10").value = checkUndefinedElement(response.externalKey10);
						     		document.getElementById("remarkArea").innerHTML = checkUndefinedElement(response.crRemark);
						     	}
					     	}
					    	
					    	if(new RegExp("action\=verify").test($(location).attr('href'))){
					    		
					    		document.getElementById("groupId").innerHTML = checkUndefinedElement(response.rmdGroupId);	
					    		document.getElementById("groupType").innerHTML = checkUndefinedElement(response.groupTypeDesc);
					     		document.getElementById("groupName").innerHTML = checkUndefinedElement(response.rmdGroupDesc);
					     		document.getElementById("groupNameChi").innerHTML = checkUndefinedElement(response.rmdGroupDescChi);
					     		document.getElementById("groupBocGroupId").innerHTML = checkUndefinedElement(response.bocGroupId);
					     		document.getElementById("responsibleRiskOfficer").innerHTML = checkUndefinedElement(response.respRiskOfficer);
					     		document.getElementById("busUnitOfResponsibleRiskOfficer").innerHTML = checkUndefinedElement(response.bizUnitRespRiskOfficer);

					     		document.getElementById("nextReviewDate").value = toDateFormat(checkUndefinedElement(response.nextReviewDate));
     		 					document.getElementById("initialOnboardDate").value = toDateFormat(checkUndefinedElement(response.initialOnboardDate));
     		 					document.getElementById("latestFinancialReport").value = toDateFormat(checkUndefinedElement(response.latestFinancialRptDate));

     		 					document.getElementById("domicileField").innerHTML = checkUndefinedElement(response.domicile);
     		 					document.getElementById("countryOfRisk").innerHTML = checkUndefinedElement(response.countryOfRisk);
     		 					document.getElementById("industryGroup").innerHTML = checkUndefinedElement(response.industryGroup);
     		 					document.getElementById("industrySubGroup").innerHTML = checkUndefinedElement(response.industrySubGroup);
     		 					document.getElementById("industrySector").innerHTML = checkUndefinedElement(response.industrySector);
     		 					document.getElementById("internalCreditRatingBasel").innerHTML = checkUndefinedElement(response.creditRatingInr);
     		 					document.getElementById("marketCapitalization").innerHTML = checkUndefinedElement(response.marketCapitalization);
     		 					document.getElementById("credit_rating_snp").innerHTML = checkUndefinedElement(response.creditRatingSnp);
     		 					document.getElementById("creditRatingMoodys").innerHTML = checkUndefinedElement(response.creditRatingMoodys);
     		 					document.getElementById("creditRatingFitch").innerHTML = checkUndefinedElement(response.creditRatingFitch);
     		 					document.getElementById("approvalRiskRating").innerHTML = checkUndefinedElement(response.riskRatingForApproval);
     		 					document.getElementById("overallLoanClass").innerHTML = checkUndefinedElement(response.overallLoanClassification);
     		 					document.getElementById("bbgTicker").innerHTML = checkUndefinedElement(response.bbgTicker);
     		 					document.getElementById("RemarksField").innerHTML = checkUndefinedElement(response.rmdGroupRemark);


     		 					comparingWithBefore(document.getElementById('nextReviewDate'), document.getElementById('bfNextReviewDate'), checkUndefinedElement(toDateFormat(response.bfNextReviewDate)) ,checkUndefinedElement(toDateFormat(response.nextReviewDate)));
     		 					
     		 					comparingWithBefore(document.getElementById('initialOnboardDate'), document.getElementById('bfInitialOnboardDate'), checkUndefinedElement(toDateFormat(response.bfInitialOnboardDate)) ,checkUndefinedElement(toDateFormat(response.initialOnboardDate)));

     		 					comparingWithBefore(document.getElementById('latestFinancialReport'), document.getElementById('bfLatestFinancialReport'), checkUndefinedElement(toDateFormat(response.bfLatestFinancialRptDate)) ,checkUndefinedElement(toDateFormat(response.latestFinancialRptDate)));



								comparingWithBefore(document.getElementById('domicileField'), document.getElementById('bfDomicileField'), checkUndefinedElement(response.bfDomicile) ,checkUndefinedElement(response.domicile));

								comparingWithBefore(document.getElementById('groupBocGroupId'), document.getElementById('bfGroupBocGroupId'), checkUndefinedElement(response.bfBocGroupId) ,checkUndefinedElement(response.bocGroupId));

								comparingWithBefore(document.getElementById('responsibleRiskOfficer'), document.getElementById('bfResponsibleRiskOfficer'), checkUndefinedElement(response.bfRespRiskOfficer) ,checkUndefinedElement(response.respRiskOfficer));

     		 					comparingWithBefore(document.getElementById('busUnitOfResponsibleRiskOfficer'), document.getElementById('bfBusUnitOfResponsibleRiskOfficer'), checkUndefinedElement(response.bfBizUnitRespRiskOfficer) ,checkUndefinedElement(response.bizUnitRespRiskOfficer));

								comparingWithBefore(document.getElementById('countryOfRisk'), document.getElementById('bfCountryOfRisk'), checkUndefinedElement(response.bfCountryOfRisk) ,checkUndefinedElement(response.countryOfRisk));

     		 					comparingWithBefore(document.getElementById('industryGroup'), document.getElementById('bfIndustryGroup'), checkUndefinedElement(response.bfIndustryGroup) ,checkUndefinedElement(response.industryGroup));

     		 					comparingWithBefore(document.getElementById('industrySector'), document.getElementById('bfIndustrySector'), checkUndefinedElement(response.bfIndustrySector) ,checkUndefinedElement(response.industrySector));

								comparingWithBefore(document.getElementById('industrySubGroup'), document.getElementById('bfIndustrySubGroup'), checkUndefinedElement(response.bfIndustrySubGroup) ,checkUndefinedElement(response.industrySubGroup));

     		 					comparingWithBefore(document.getElementById('internalCreditRatingBasel'), document.getElementById('bfInternalCreditRatingBasel'),checkUndefinedElement(response.bfCreditRatingInr) ,checkUndefinedElement(response.creditRatingInr));

     		 					comparingWithBefore(document.getElementById('marketCapitalization'), document.getElementById('bfMarketCapitalization'),checkUndefinedElement(response.bfMarketCapitalization) ,checkUndefinedElement(response.marketCapitalization));
								
     		 					comparingWithBefore(document.getElementById('credit_rating_snp'), document.getElementById('bfCredit_rating_snp'),checkUndefinedElement(response.bfCreditRatingSnp) ,checkUndefinedElement(response.creditRatingSnp));
     		 					
     		 					comparingWithBefore(document.getElementById('creditRatingMoodys'), document.getElementById('bfCreditRatingMoodys'),checkUndefinedElement(response.bfCreditRatingMoodys) ,checkUndefinedElement(response.creditRatingMoodys));

     		 					comparingWithBefore(document.getElementById('creditRatingFitch'), document.getElementById('bfCreditRatingFitch'),checkUndefinedElement(response.bfCreditRatingFitch) ,checkUndefinedElement(response.creditRatingFitch));
								
     		 					comparingWithBefore(document.getElementById('approvalRiskRating'), document.getElementById('bfApprovalRiskRating'),checkUndefinedElement(response.bfRiskRatingForApproval) ,checkUndefinedElement(response.riskRatingForApproval));

								comparingWithBefore(document.getElementById('overallLoanClass'), document.getElementById('bfOverallLoanClass'),checkUndefinedElement(response.bfOverallLoanClassification) ,checkUndefinedElement(response.overallLoanClassification));

								comparingWithBefore(document.getElementById('RemarksField'), document.getElementById('bfRemarksField'),checkUndefinedElement(response.bfRmdGroupRemark) ,checkUndefinedElement(response.rmdGroupRemark));

								comparingWithBefore(document.getElementById('bbgTicker'), document.getElementById('bfBbgTicker'), checkUndefinedElement(response.bfBbgTicker) ,checkUndefinedElement(response.bbgTicker));

				     			comparingWithBefore(document.getElementById("extKey1"), document.getElementById("bfExtKey1"), checkUndefinedElement(response.bfExternalKey1), checkUndefinedElement(response.externalKey1));

				     			comparingWithBefore(document.getElementById("extKey2"), document.getElementById("bfExtKey2"), checkUndefinedElement(response.bfExternalKey2), checkUndefinedElement(response.externalKey2));

				     			comparingWithBefore(document.getElementById("extKey3"), document.getElementById("bfExtKey3"), checkUndefinedElement(response.bfExternalKey3), checkUndefinedElement(response.externalKey3));

				     			comparingWithBefore(document.getElementById("extKey4"), document.getElementById("bfExtKey4"), checkUndefinedElement(response.bfExternalKey4), checkUndefinedElement(response.externalKey4));

				     			comparingWithBefore(document.getElementById("extKey5"), document.getElementById("bfExtKey5"), checkUndefinedElement(response.bfExternalKey5), checkUndefinedElement(response.externalKey5));

				     			comparingWithBefore(document.getElementById("extKey6"), document.getElementById("bfExtKey6"), checkUndefinedElement(response.bfExternalKey6), checkUndefinedElement(response.externalKey6));

				     			comparingWithBefore(document.getElementById("extKey7"), document.getElementById("bfExtKey7"), checkUndefinedElement(response.bfExternalKey7), checkUndefinedElement(response.externalKey7));

				     			comparingWithBefore(document.getElementById("extKey8"), document.getElementById("bfExtKey8"), checkUndefinedElement(response.bfExternalKey8), checkUndefinedElement(response.externalKey8));

				     			comparingWithBefore(document.getElementById("extKey9"), document.getElementById("bfExtKey9"), checkUndefinedElement(response.bfExternalKey9), checkUndefinedElement(response.externalKey9));

				     			comparingWithBefore(document.getElementById("extKey10"), document.getElementById("bfExtKey10"), checkUndefinedElement(response.bfExternalKey10), checkUndefinedElement(response.externalKey10));

					     	
					     		document.getElementById("remarkArea").value = checkUndefinedElement(response.crRemark);
					     		
					     	}
					     	if(new RegExp("action\=discard").test($(location).attr('href'))){
					    		
					    		document.getElementById("groupId").innerHTML = checkUndefinedElement(response.rmdGroupId);	
					     		document.getElementById("groupType").innerHTML = checkUndefinedElement(response.groupTypeDesc);		     	
					     		document.getElementById("groupName").innerHTML = checkUndefinedElement(response.rmdGroupDesc);
					     		document.getElementById("groupNameChi").innerHTML = checkUndefinedElement(response.rmdGroupDescChi);
					     		document.getElementById("groupBocGroupId").innerHTML = checkUndefinedElement(response.bocGroupId);
					     		document.getElementById("responsibleRiskOfficer").innerHTML = checkUndefinedElement(response.respRiskOfficer);
					     		document.getElementById("busUnitOfResponsibleRiskOfficer").innerHTML = checkUndefinedElement(response.bizUnitRespRiskOfficer);

     		 					document.getElementById("nextReviewDate").value = toDateFormat(checkUndefinedElement(response.nextReviewDate));
     		 					document.getElementById("initialOnboardDate").value = toDateFormat(checkUndefinedElement(response.initialOnboardDate));
     		 					document.getElementById("latestFinancialReport").value = toDateFormat(checkUndefinedElement(response.latestFinancialRptDate));

     		 					document.getElementById("domicileField").innerHTML = checkUndefinedElement(response.domicile);
     		 					document.getElementById("countryOfRisk").innerHTML = checkUndefinedElement(response.countryOfRisk);
     		 					document.getElementById("industryGroup").innerHTML = checkUndefinedElement(response.industryGroup);
     		 					document.getElementById("industrySubGroup").innerHTML = checkUndefinedElement(response.industrySubGroup);
     		 					document.getElementById("industrySector").innerHTML = checkUndefinedElement(response.industrySector);
     		 					document.getElementById("internalCreditRatingBasel").innerHTML = checkUndefinedElement(response.creditRatingInr);
     		 					document.getElementById("marketCapitalization").innerHTML = checkUndefinedElement(response.marketCapitalization);
     		 					document.getElementById("credit_rating_snp").innerHTML = checkUndefinedElement(response.creditRatingSnp);
     		 					document.getElementById("creditRatingMoodys").innerHTML = checkUndefinedElement(response.creditRatingMoodys);
     		 					document.getElementById("creditRatingFitch").innerHTML = checkUndefinedElement(response.creditRatingFitch);
     		 					document.getElementById("approvalRiskRating").innerHTML = checkUndefinedElement(response.riskRatingForApproval);
     		 					document.getElementById("overallLoanClass").innerHTML = checkUndefinedElement(response.overallLoanClassification);
     		 					document.getElementById("bbgTicker").innerHTML = checkUndefinedElement(response.bbgTicker);
     		 					document.getElementById("RemarksField").innerHTML = checkUndefinedElement(response.rmdGroupRemark);
					     		document.getElementById("extKey1").innerHTML = checkUndefinedElement(response.externalKey1);
					     		document.getElementById("extKey2").innerHTML = checkUndefinedElement(response.externalKey2);
					     		document.getElementById("extKey3").innerHTML = checkUndefinedElement(response.externalKey3);
					     		document.getElementById("extKey4").innerHTML = checkUndefinedElement(response.externalKey4);
					     		document.getElementById("extKey5").innerHTML = checkUndefinedElement(response.externalKey5);
								document.getElementById("extKey6").innerHTML = checkUndefinedElement(response.externalKey6);
								document.getElementById("extKey7").innerHTML = checkUndefinedElement(response.externalKey7);
								document.getElementById("extKey8").innerHTML = checkUndefinedElement(response.externalKey8); 
								document.getElementById("extKey9").innerHTML = checkUndefinedElement(response.externalKey9);
								document.getElementById("extKey10").innerHTML = checkUndefinedElement(response.externalKey10);	;
				     			document.getElementById("remarkArea").value = checkUndefinedElement(response.crRemark);
					     	}
					    	
					     	document.getElementById("createdBy").innerHTML = checkUndefinedElement(response.createBy);
					     	document.getElementById("createdAt").innerHTML = toDateFormat(checkUndefinedElement(response.createDt));
					     	document.getElementById("updateBy").innerHTML = checkUndefinedElement(response.crBy);
					     	document.getElementById("updateAt").innerHTML = toDateFormat(checkUndefinedElement(response.crDt));
					     	document.getElementById("verifiedBy").innerHTML = checkUndefinedElement(response.verifyBy);
					     	document.getElementById("verifiedAt").innerHTML = toDateFormat(checkUndefinedElement(response.verifyDt));
					     	document.getElementById("status").innerHTML = checkUndefinedElement(response.status);
					    }   
			    	
		    	});   
		
			    dataSource.read(); 

				/* ============================================================================================================= */

				/* Get the action type - view for directing to the view mode on this page */
				/* Replacing the button, label from update to view */
				/* Checker action -> */
	 					
	 					if(new RegExp("action\=view").test($(location).attr('href'))){

	 						$(".compareCol").hide();

	 						$("#pagetitle").html("Maintenance - Group Detail Maintenance Change Request - View Group Detail");
	 						$("#group_id").html("<label id=\"groupId\"></label>");
	 						$("#group_type_label").html("<label id=\"groupType\"></label>");
	 						$("#group_name_label").html("<label id=\"groupName\"></label>");
	 						$("#group_name_chi").html("<label id=\"groupNameChi\"></label>");
							$("#group_boc_group_id").html("<label id=\"groupBocGroupId\"></label>");
							$("#responsible_risk_officer").html("<label id=\"responsibleRiskOfficer\"></label>");
							$("#bus_unit_of_responsible_risk_officer").html("<label id=\"busUnitOfResponsibleRiskOfficer\"></label>");

							$("#nextReviewDate").data('kendoDatePicker').enable(false);
							$("#initialOnboardDate").data('kendoDatePicker').enable(false);
							$("#latestFinancialReport").data('kendoDatePicker').enable(false);

							$("#domicile").html("<label id=\"domicileField\"></label>");
							$("#country_of_risk").html("<label id=\"countryOfRisk\"></label>");
							$("#industry_group").html("<label id=\"industryGroup\"></label>");
							$("#industry_sub_group").html("<label id=\"industrySubGroup\"></label>");
							$("#industry_sector").html("<label id=\"industrySector\"></label>");
							$("#internal_credit_rating_basel").html("<label id=\"internalCreditRatingBasel\"></label>");
							$("#market_capitalization").html("<label id=\"marketCapitalization\"></label>");
							$("#credit_rating_snp").html("<label id=\"credit_rating_snp\"></label>");
							$("#credit_rating_moodys").html("<label id=\"creditRatingMoodys\"></label>");
							$("#credit_rating_fitch").html("<label id=\"creditRatingFitch\"></label>");
							$("#approval_risk_rating").html("<label id=\"approvalRiskRating\"></label>");
							$("#overall_loan_class").html("<label id=\"overallLoanClass\"></label>");
							$("#bbg_ticker").html("<label id=\"bbgTicker\"></label>");
							$("#Remarks").html("<label id=\"RemarksField\"></label>");
	 						$("#checkEXTKey1").html("<label id=\"extKey1\"></label>");
	 						$("#checkEXTKey2").html("<label id=\"extKey2\"></label>");
	 						$("#checkEXTKey3").html("<label id=\"extKey3\"></label>");
	 						$("#checkEXTKey4").html("<label id=\"extKey4\"></label>");
	 						$("#checkEXTKey5").html("<label id=\"extKey5\"></label>");
	 						$("#checkEXTKey6").html("<label id=\"extKey6\"></label>");
	 						$("#checkEXTKey7").html("<label id=\"extKey7\"></label>");
	 						$("#checkEXTKey8").html("<label id=\"extKey8\"></label>");
	 						$("#checkEXTKey9").html("<label id=\"extKey9\"></label>");
	 						$("#checkEXTKey10").html("<label id=\"extKey10\"></label>");

	 						$("#bfNextReviewDate").data('kendoDatePicker').enable(false);
									$("#bfInitialOnboardDate").data('kendoDatePicker').enable(false);
									$("#bfLatestFinancialReport").data('kendoDatePicker').enable(false);

	 						$("#remarks").html("<textarea style=\"width:100%\" id=\"remarkArea\" class=\"k-textbox\" style=\"background-color: #FFD7B5; color: black\" disabled rows=\"4\" cols=\"28\"></textarea>");
	 						
	 						if(new RegExp("update").test($(location).attr('href'))){
	 							$("#buttonType").html("<button id=\"updateBtn\" style=\"\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" onclick=\"toUpdate()\">Update</button><label>    </label><button id=\"discardBtn\" style=\"\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" onclick=\"toDiscard()\">Discard</button><label>    </label><button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Back</button>");
	 						}else{
	 							$("#buttonType").html("<button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Back</button>");
	 						}
	 					}else{

	 						/* Get the action type - update for directing to the update mode on this page. */
	 						/* Replacing the button, label from view to update */
	 						$(".compareCol").hide();

	 						if(new RegExp("action\=update").test($(location).attr('href'))){
	 							$("#pagetitle").html("Maintenance - Group Detail Maintenance Change Request - Update Group Detail");
	 							$("#group_id").html("<label id=\"groupId\"></label>");
	 							$("#group_type_label").html("<label id=\"groupType\"></label>");
	 							$("#group_name_label").html("<label id=\"groupName\"></label>");
		 						$("#group_name_chi").html("<label id=\"groupNameChi\"></input>");
								$("#group_boc_group_id").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"groupBocGroupId\"></input>");
								$("#responsible_risk_officer").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"responsibleRiskOfficer\"></input>");

								$("#bus_unit_of_responsible_risk_officer").html("<select style=\"width:100%\" id=\"busUnitOfResponsibleRiskOfficer\"> <option value=\"1\">1</option> <option value=\"2\">2</option> <option value=\"3\">3</option> </select>");

								$("#nextReviewDate").data('kendoDatePicker').enable(true);
								$("#initialOnboardDate").data('kendoDatePicker').enable(true);
								$("#latestFinancialReport").data('kendoDatePicker').enable(true);

								$("#domicile").html("<select style=\"width:100%\" id=\"domicileField\">  <option value=\"1\">1</option> <option value=\"2\">2</option> <option value=\"3\">3</option>  </select>");
								$("#country_of_risk").html("<select style=\"width:100%\" id=\"countryOfRisk\"> <option value=\"1\">1</option> <option value=\"2\">2</option> <option value=\"3\">3</option> </select>");

								$("#industry_group").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"industryGroup\"></input>");
								$("#industry_sub_group").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"industrySubGroup\"></label>");
								$("#industry_sector").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"industrySector\"></input>");
								$("#internal_credit_rating_basel").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"internalCreditRatingBasel\"></input>");
								$("#market_capitalization").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"marketCapitalization\"></input>");
								$("#credit_rating_snp").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"creditRatingSnp\"></input>");
								$("#credit_rating_moodys").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"creditRatingMoodys\"></input>");
								$("#credit_rating_fitch").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"creditRatingFitch\"></input>");
								$("#approval_risk_rating").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"approvalRiskRating\"></input>");
								$("#overall_loan_class").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"overallLoanClass\"></input>");
								$("#bbg_ticker").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"bbgTicker\"></input>");
								$("#Remarks").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"RemarksField\"></input>");

	 							$("#checkEXTKey1").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"extKey1\" type=\"text\"/>");
	 							$("#checkEXTKey2").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"extKey2\" type=\"text\"/>");
	 							$("#checkEXTKey3").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"extKey3\" type=\"text\"/>");
	 							$("#checkEXTKey4").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"extKey4\" type=\"text\"/>");
	 							$("#checkEXTKey5").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"extKey5\" type=\"text\"/>");
	 							$("#checkEXTKey6").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"extKey6\" type=\"text\"></input>");
	 							$("#checkEXTKey7").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"extKey7\" type=\"text\"></input>");
	 							$("#checkEXTKey8").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"extKey8\" type=\"text\"></input>");
	 							$("#checkEXTKey9").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"extKey9\" type=\"text\"></input>");
	 							$("#checkEXTKey10").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"extKey10\" type=\"text\"></input>");

	 							$("#bfNextReviewDate").data('kendoDatePicker').enable(false);
								$("#bfInitialOnboardDate").data('kendoDatePicker').enable(false);
								$("#bfLatestFinancialReport").data('kendoDatePicker').enable(false);

	 							$("#remarks").html("<textarea style=\"width:100%\" id=\"remarkArea\" class=\"k-textbox\" style=\"background-color: #FFD7B5; color: black\" disabled rows=\"4\" cols=\"28\"></textarea>");

	 							$("#buttonType").html("<button id=\"submitBtn\" style=\"\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" onclick=\"toSubmit()\">Submit</button><label>     </label><button id=\"saveBtn\" style=\"\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" onclick=\"toSave()\">Save</button><label>     </label><button id=\"discardBtn\" style=\"\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" onclick=\"toDiscard()\">Discard</button><label>     </label><button id=\"saveBtn\" style=\"\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" onclick=\"toClear()\">Clear</button><label>     </label><button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Back</button>");
	 							
	 						}else{
	 							$(".compareCol").show();
	 							if(new RegExp("action\=verify").test($(location).attr('href'))){
	 								$("#pagetitle").html("Maintenance - Group Detail Maintenance Change Request - Verify Group Detail");
	 								$("#group_id").html("<label id=\"groupId\"></label>");
			 						$("#group_type_label").html("<label id=\"groupType\"></label>");
			 						$("#group_name_label").html("<label id=\"groupName\"></label>");
			 						$("#group_name_chi").html("<label id=\"groupNameChi\"></label>");
									$("#group_boc_group_id").html("<label id=\"groupBocGroupId\"></label>");
									$("#responsible_risk_officer").html("<label id=\"responsibleRiskOfficer\"></label>");
									$("#bus_unit_of_responsible_risk_officer").html("<label id=\"busUnitOfResponsibleRiskOfficer\"></label>");

									$("#nextReviewDate").data('kendoDatePicker').enable(false);
									$("#initialOnboardDate").data('kendoDatePicker').enable(false);
									$("#latestFinancialReport").data('kendoDatePicker').enable(false);

									$("#domicile").html("<label id=\"domicileField\"></label>");
									$("#country_of_risk").html("<label id=\"countryOfRisk\"></label>");
									$("#industry_group").html("<label id=\"industryGroup\"></label>");
									$("#industry_sub_group").html("<label id=\"industrySubGroup\"></label>");
									$("#industry_sector").html("<label id=\"industrySector\"></label>");
									$("#internal_credit_rating_basel").html("<label id=\"internalCreditRatingBasel\"></label>");
									$("#market_capitalization").html("<label id=\"marketCapitalization\"></label>");
									$("#credit_rating_snp").html("<label id=\"credit_rating_snp\"></label>");
									$("#credit_rating_moodys").html("<label id=\"creditRatingMoodys\"></label>");
									$("#credit_rating_fitch").html("<label id=\"creditRatingFitch\"></label>");
									$("#approval_risk_rating").html("<label id=\"approvalRiskRating\"></label>");
									$("#overall_loan_class").html("<label id=\"overallLoanClass\"></label>");
									$("#bbg_ticker").html("<label id=\"bbgTicker\"></label>");
									$("#Remarks").html("<label id=\"RemarksField\"></label>");

			 						$("#checkEXTKey1").html("<label id=\"extKey1\"></label>");
			 						$("#checkEXTKey2").html("<label id=\"extKey2\"></label>");
			 						$("#checkEXTKey3").html("<label id=\"extKey3\"></label>");
			 						$("#checkEXTKey4").html("<label id=\"extKey4\"></label>");
			 						$("#checkEXTKey5").html("<label id=\"extKey5\"></label>");
			 						$("#checkEXTKey6").html("<label id=\"extKey6\"></label>");
			 						$("#checkEXTKey7").html("<label id=\"extKey7\"></label>");
			 						$("#checkEXTKey8").html("<label id=\"extKey8\"></label>");
			 						$("#checkEXTKey9").html("<label id=\"extKey9\"></label>");
			 						$("#checkEXTKey10").html("<label id=\"extKey10\"></label>");
									
									$("#bfNextReviewDate").data('kendoDatePicker').enable(false);
									$("#bfInitialOnboardDate").data('kendoDatePicker').enable(false);
									$("#bfLatestFinancialReport").data('kendoDatePicker').enable(false);

			 						$("#bfDomicile").html("<label id=\"bfDomicileField\"></label>");
			 						$("#bfGroup_boc_group_id").html("<label id=\"bfGroupBocGroupId\"></label>");
			 						$("#bfResponsible_risk_officer").html("<label id=\"bfResponsibleRiskOfficer\"></label>");
			 						$("#bfBus_unit_of_responsible_risk_officer").html("<label id=\"bfBusUnitOfResponsibleRiskOfficer\"></label>");
			 						$("#bfCountry_of_risk").html("<label id=\"bfCountryOfRisk\"></label>");
			 						$("#bfIndustry_group").html("<label id=\"bfIndustryGroup\"></label>");
			 						$("#bfIndustry_sector").html("<label id=\"bfIndustrySector\"></label>");
			 						$("#bfIndustry_sub_group").html("<label id=\"bfIndustrySubGroup\"></label>");
									$("#bfInternal_credit_rating_basel").html("<label id=\"bfInternalCreditRatingBasel\"></label>");
									$("#bfMarket_capitalization").html("<label id=\"bfMarketCapitalization\"></label>");
									$("#bfCredit_rating_snp").html("<label id=\"bfCredit_rating_snp\"></label>");
									$("#bfCredit_rating_moodys").html("<label id=\"bfCreditRatingMoodys\"></label>");
									$("#bfCredit_rating_fitch").html("<label id=\"bfCreditRatingFitch\"></label>");
									$("#bfApproval_risk_rating").html("<label id=\"bfApprovalRiskRating\"></label>");
									$("#bfOverall_loan_class").html("<label id=\"bfOverallLoanClass\"></label>");
									$("#bfBbg_ticker").html("<label id=\"bfBbgTicker\"></label>");
									$("#bfRemarks").html("<label id=\"bfRemarksField\"></label>");
									$("#bfCheckEXTKey1").html("<label id=\"bfExtKey1\"></label>");
			 						$("#bfCheckEXTKey2").html("<label id=\"bfExtKey2\"></label>");
			 						$("#bfCheckEXTKey3").html("<label id=\"bfExtKey3\"></label>");
			 						$("#bfCheckEXTKey4").html("<label id=\"bfExtKey4\"></label>");
			 						$("#bfCheckEXTKey5").html("<label id=\"bfExtKey5\"></label>");
			 						$("#bfCheckEXTKey6").html("<label id=\"bfExtKey6\"></label>");
			 						$("#bfCheckEXTKey7").html("<label id=\"bfExtKey7\"></label>");
			 						$("#bfCheckEXTKey8").html("<label id=\"bfExtKey8\"></label>");
			 						$("#bfCheckEXTKey9").html("<label id=\"bfExtKey9\"></label>");
			 						$("#bfCheckEXTKey10").html("<label id=\"bfExtKey10\"></label>");

			 						$("#remarks").html("<textarea style=\"width:100%\" id=\"remarkArea\" class=\"k-textbox\" rows=\"4\" cols=\"28\"></textarea>");

			 						$("#buttonType").html("<button id=\"verifyBtn\" style=\"\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" onclick=\"toVerify()\">Verify</button><label>    </label><button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Back</button><label>    </label><button id=\"returnBtn\" onclick=\"toReturned()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" style=\"\">Return</button>");
								
	 							}else{
	 								$(".compareCol").hide();
	 								if(new RegExp("action\=discard").test($(location).attr('href'))){
	 									$("#pagetitle").html("Maintenance - Group Detail Maintenance Change Request - Discard Group Detail");
	 									$("#group_id").html("<label id=\"groupId\"></label>");
				 						$("#group_type_label").html("<label id=\"groupType\"></label>");
				 						$("#group_name_label").html("<label id=\"groupName\"></label>");
				 						$("#group_name_chi").html("<label id=\"groupNameChi\"></label>");
										$("#group_boc_group_id").html("<label id=\"groupBocGroupId\"></label>");
										$("#responsible_risk_officer").html("<label id=\"responsibleRiskOfficer\"></label>");
										$("#bus_unit_of_responsible_risk_officer").html("<label id=\"busUnitOfResponsibleRiskOfficer\"></label>");

										$("#nextReviewDate").data('kendoDatePicker').enable(false);
										$("#initialOnboardDate").data('kendoDatePicker').enable(false);
										$("#latestFinancialReport").data('kendoDatePicker').enable(false);

										$("#domicile").html("<label id=\"domicileField\"></label>");
										$("#country_of_risk").html("<label id=\"countryOfRisk\"></label>");
										$("#industry_group").html("<label id=\"industryGroup\"></label>");
										$("#industry_sub_group").html("<label id=\"industrySubGroup\"></label>");
										$("#industry_sector").html("<label id=\"industrySector\"></label>");
										$("#internal_credit_rating_basel").html("<label id=\"internalCreditRatingBasel\"></label>");
										$("#market_capitalization").html("<label id=\"marketCapitalization\"></label>");
										$("#credit_rating_snp").html("<label id=\"credit_rating_snp\"></label>");
										$("#credit_rating_moodys").html("<label id=\"creditRatingMoodys\"></label>");
										$("#credit_rating_fitch").html("<label id=\"creditRatingFitch\"></label>");
										$("#approval_risk_rating").html("<label id=\"approvalRiskRating\"></label>");
										$("#overall_loan_class").html("<label id=\"overallLoanClass\"></label>");
										$("#bbg_ticker").html("<label id=\"bbgTicker\"></label>");
										$("#Remarks").html("<label id=\"RemarksField\"></label>");
				 						$("#checkEXTKey1").html("<label id=\"extKey1\"></label>");
				 						$("#checkEXTKey2").html("<label id=\"extKey2\"></label>");
				 						$("#checkEXTKey3").html("<label id=\"extKey3\"></label>");
				 						$("#checkEXTKey4").html("<label id=\"extKey4\"></label>");
				 						$("#checkEXTKey5").html("<label id=\"extKey5\"></label>");
				 						$("#checkEXTKey6").html("<label id=\"extKey6\"></label>");
				 						$("#checkEXTKey7").html("<label id=\"extKey7\"></label>");
				 						$("#checkEXTKey8").html("<label id=\"extKey8\"></label>");
				 						$("#checkEXTKey9").html("<label id=\"extKey9\"></label>");
				 						$("#checkEXTKey10").html("<label id=\"extKey10\"></label>");

				 						$("#bfNextReviewDate").data('kendoDatePicker').enable(false);
										$("#bfInitialOnboardDate").data('kendoDatePicker').enable(false);
										$("#bfLatestFinancialReport").data('kendoDatePicker').enable(false);

				 						$("#remarks").html("<textarea style=\"width:100%\" id=\"remarkArea\" class=\"k-textbox\" style=\"background-color: #FFD7B5; color: black\" disabled rows=\"4\" cols=\"28\"></textarea>");				 						
				 						
				 						$("#buttonType").html("<div style=\"display: inline; color: red\">Discard the change ? </div><button id=\"yesBtn\" style=\"\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" onclick=\"toDelete()\">Yes</button><label>    </label><button id=\"noBtn\" style=\"\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" onclick=\"toBack()\">No</button>");

	 								}
	 							}
	 						}
	 					}
	 					    $("#nextReviewDate").attr("readonly","readonly" );
	 						$("#initialOnboardDate").attr("readonly","readonly" );
	 						$("#latestFinancialReport").attr("readonly","readonly" );
	 						$("#bfNextReviewDate").attr("readonly","readonly" );
	 						$("#bfInitialOnboardDate").attr("readonly","readonly" );
	 						$("#bfLatestFinancialReport").attr("readonly","readonly" );

	        	     	var oRows = document.getElementById('listTable').getElementsByTagName('tr');
	        	     	var iRowCount = oRows.length;

	        	     	for (var i = 0; i < iRowCount; i++) {
        	                 		$('#tabRow'+i).remove();
	                 	};
	                 	
						var getMemberURL = window.sessionStorage.getItem('serverPath')+"groupDetail/getMember?crId="+getURLParameters("crId")+"&userId="+window.sessionStorage.getItem("username");
						
						var dataSource = new kendo.data.DataSource({
							transport: {
								read: {
						   		  	type: "get",
								    url: getMemberURL,
								    dataType: "json",
			        			    xhrFields: {
			    			    		withCredentials: true
			    			    	}
								}
							},
		                 	requestEnd: function(e) {
						        var response = e.response; // responses content
						       	for (var i = 0; i < response.length; i++) {
						       		$('#list tr:last').before('<tr style=\"font-size:13px;\" id="tabRow'+i+'"> <td>'+checkUndefinedElement(response[i].ccdId)+'&nbsp;&nbsp;</td> <td>'+checkUndefinedElement(response[i].legalPartyEngName)+'&nbsp;&nbsp;</td> <td>'+checkUndefinedElement(response[i].acctId)+'&nbsp;&nbsp;</td> <td>'+checkUndefinedElement(response[i].subAcctId)+'&nbsp;&nbsp;</td> <td>'+checkUndefinedElement(response[i].accName)+'&nbsp;&nbsp;</td> <td>'+checkUndefinedElement(response[i].accBizUnit)+'&nbsp;&nbsp;</td> </tr>');
						        };        
						        $("#countRow").text("No. of Record : " +response.length);	 
							}

						});
							
						openModal();								
						dataSource.fetch();
						closeModal();
		        	     
			        	 $("#resetBtn").kendoButton(); // Reset button event
			        	 $("#exportBtn").kendoButton(); // Export button event
		        	}
	 			);

	function displayFilterResults() {
	  // Gets the data source from the grid.
	  var dataSource = $("#MyGrid").data("kendoGrid").dataSource;
	  
	  // Gets the filter from the dataSource
	     var filters = dataSource.filter();
	     
	     // Gets the full set of data from the data source
	     var allData = dataSource.data();
	     
	     // Applies the filter to the data
	     var query = new kendo.data.Query(allData);
	     var filteredData = query.filter(filters).data;
	     
	     // Output the results
	     $('#FilterCount').html(filteredData.length);
	     $('#TotalCount').html(allData.length);
	     $('#FilterResults').html('');
	     $.each(filteredData, function(index, item){
	       $('#FilterResults').append('<li>'+item.Site+' : '+item.Visitors+'</li>')
	     });
	}
	/* Open spinner while getting the data from back-end*/
	function openModal() {
	     document.getElementById('modal').style.display = 'block';
	     document.getElementById('modal2').style.display = 'block';
	}
	
	/* Close spinner when all the data have been received*/
	function closeModal() {
	    document.getElementById('modal').style.display = 'none';
	    document.getElementById('modal2').style.display = 'none';
	}

	/* Action - Update button */
	function toUpdate(){ /* Direct me to update page */
		window.location = "groupMaintenanceChangeRequest?action=update&crId="+getURLParameters("crId")+"&userId="+window.sessionStorage.getItem("username");
	}

	/* Action - View button */
	function toView(){ /* Direct me to view page */
		var updateBtn = document.getElementById("submitBtn");
	}
	function strToDate(dateStr){
		var date = new Date();
		if(checkUndefinedElement(dateStr) != "" && checkUndefinedElement(dateStr) != null){

		    var date = new Date();
		    var m = dateStr.match(/^(\d{1,2})\/(\d{1,2})\/(\d{4})$/);
		    console.log(m[3],m[2],m[1]);

		    date.setDate(m[1]);
		    date.setMonth(m[2]-1);
		    date.setFullYear(m[3]);
		    return date;

		}else{
			return "";
		} 
	}

	function toSave(){

		if(strToDate(document.getElementById("nextReviewDate").value) <= new Date()){

			alert("Next Review Date must be greater than today");

		}else if(checkUndefinedElement(document.getElementById("responsibleRiskOfficer").value) == ""){

			alert("Please input a valid Responsible Risk Officer");
					
		}else if(checkUndefinedElement(document.getElementById("busUnitOfResponsibleRiskOfficer").value) == ""){

			alert("Please input a valid Business Unit of Responsible Risk Officer.");

		}else{

			var url = window.sessionStorage.getItem('serverPath')+"groupDetail/save";

			var jsonArr = { 
				crId: getURLParameters("crId"), 
				userId: window.sessionStorage.getItem("username"), 
				bocGroupId: checkUndefinedElement(document.getElementById("groupBocGroupId").value),
				respRiskOfficer: checkUndefinedElement(document.getElementById("responsibleRiskOfficer").value),
				bizUnitRespRiskOfficer: checkUndefinedElement(document.getElementById("busUnitOfResponsibleRiskOfficer").value),
				nextReviewDate: strToDate(document.getElementById("nextReviewDate").value),
				initialOnboardDate: strToDate(document.getElementById("initialOnboardDate").value),
				latestFinancialRptDate: strToDate(document.getElementById("latestFinancialReport").value),
				domicile: checkUndefinedElement(document.getElementById("domicileField").value),
				countryOfRisk: checkUndefinedElement(document.getElementById("countryOfRisk").value),
				industryGroup: checkUndefinedElement(document.getElementById("industryGroup").value),
				industrySubGroup: checkUndefinedElement(document.getElementById("industrySubGroup").value),
				industrySector: checkUndefinedElement(document.getElementById("industrySector").value),
				marketCapitalization: checkUndefinedElement(document.getElementById("marketCapitalization").value),
				creditRatingInr: checkUndefinedElement(document.getElementById("internalCreditRatingBasel").value),
				creditRatingSnp: checkUndefinedElement(document.getElementById("creditRatingSnp").value),
				creditRatingMoodys: checkUndefinedElement(document.getElementById("creditRatingMoodys").value),
				creditRatingFitch: checkUndefinedElement(document.getElementById("creditRatingFitch").value),
				riskRatingForApproval: checkUndefinedElement(document.getElementById("approvalRiskRating").value),
				overallLoanClassification: checkUndefinedElement(document.getElementById("overallLoanClass").value),
				bbgTicker: checkUndefinedElement(document.getElementById("bbgTicker").value),
				rmdGroupRemark: checkUndefinedElement(document.getElementById("Remarks").value),
				externalKey1: checkUndefinedElement(document.getElementById("extKey1").value), 
				externalKey2: checkUndefinedElement(document.getElementById("extKey2").value), 
				externalKey3: checkUndefinedElement(document.getElementById("extKey3").value), 
				externalKey4: checkUndefinedElement(document.getElementById("extKey4").value), 
				externalKey5: checkUndefinedElement(document.getElementById("extKey5").value), 
				externalKey6: checkUndefinedElement(document.getElementById("extKey6").value), 
				externalKey7: checkUndefinedElement(document.getElementById("extKey7").value), 
				externalKey8: checkUndefinedElement(document.getElementById("extKey8").value), 
				externalKey9: checkUndefinedElement(document.getElementById("extKey9").value), 
				externalKey10: checkUndefinedElement(document.getElementById("extKey10").value),
				rmdGroupRemark: checkUndefinedElement(document.getElementById("RemarksField").value)
			};

			var dataSource = new kendo.data.DataSource({
				transport: {
					read: {
						url: url,
						type: "POST",
						contentType: "application/json; charset=utf-8",
						dataType: "json",
						data: jsonArr,
						xhrFields: {
				    		withCredentials: true
				    	},
				    	complete: function(jqXHR, textStatus) {
					    	  var obj = JSON.parse(jqXHR.responseText);
					    	  console.log(obj.message);
					    	  window.sessionStorage.setItem('message', obj.message);
					    	  window.location.href = "groupMaintenanceList";
				    	}
					},
					parameterMap: function(data) {
				      	return kendo.stringify(data);
				    }
				},
				schema: { 
		            model:{
		            	id: "message",
		            	fields:{
		            		message: {type: "string"},     
		            		status: {type: "string"}     
		            	}
		            }
		        }
			});

			dataSource.read();
		}
	}
	
	/* Action - View button */
	function toReturned(){ /* Direct me to view page */
		var url = window.sessionStorage.getItem('serverPath')+"groupDetail/return";

		var jsonArr = { 
			crId: getURLParameters("crId"), 
			userId: window.sessionStorage.getItem("username"),
			crRemark: checkUndefinedElement(document.getElementById("remarkArea").value)
		};

		var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: url,
					type: "POST",
					contentType: "application/json; charset=utf-8",
					dataType: "json",
					data: jsonArr,
					xhrFields: {
			    		withCredentials: true
			    	},
			    	complete: function(jqXHR, textStatus) {
				    	  var obj = JSON.parse(jqXHR.responseText);
				    	  console.log(obj.message);
				    	  window.sessionStorage.setItem('message', obj.message);
				    	  window.location.href = "groupMaintenanceList";
			    	}
				},
				parameterMap: function(data) {
			      	return kendo.stringify(data);
			    }
			},
			schema: { 
	            model:{
	            	id: "message",
	            	fields:{
	            		message: {type: "string"},     
	            		status: {type: "string"}     
	            	}
	            }
	        }
		});

		dataSource.read();
	}
	function toClear(){
		var elements = document.getElementsByTagName("input");
		for (var ii=0; ii < elements.length; ii++) {
		  if (elements[ii].type == "text") {
		    elements[ii].value = "";
		  }
		}
	}
	function toDiscard(){
		window.location = "groupMaintenanceChangeRequest?action=discard&crId="+getURLParameters("crId")+"&userId="+window.sessionStorage.getItem("username");
	}
	function toDelete(){ 
		var url = window.sessionStorage.getItem('serverPath')+"groupDetail/discard";

		var jsonArr = { 
			crId: getURLParameters("crId"), 
			userId: window.sessionStorage.getItem("username")
		};

		var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: url,
					type: "POST",
					contentType: "application/json; charset=utf-8",
					dataType: "json",
					data: jsonArr,
					xhrFields: {
			    		withCredentials: true
			    	},
			    	complete: function(jqXHR, textStatus) {
				    	  var obj = JSON.parse(jqXHR.responseText);
				    	  console.log(obj.message);
				    	  window.sessionStorage.setItem('message', obj.message);
				    	  window.location.href = "groupMaintenanceList";
			    	}
				},
				parameterMap: function(data) {
			      	return kendo.stringify(data);
			    }
			},
			schema: { 
	            model:{
	            	id: "message",
	            	fields:{
	            		message: {type: "string"},     
	            		status: {type: "string"}     
	            	}
	            }
	        }
		});

		dataSource.read();
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
		window.location = "/ermsweb/groupMaintenanceList";
	}
	
	/* Send to submit */
	function toSubmit(){


		if(strToDate(document.getElementById("nextReviewDate").value) <= new Date()){

			alert("Next Review Date must be greater than today");

		}else if(checkUndefinedElement(document.getElementById("responsibleRiskOfficer").value) == ""){

			alert("Please input a valid Responsible Risk Officer");
					
		}else if(checkUndefinedElement(document.getElementById("busUnitOfResponsibleRiskOfficer").value) == ""){

			alert("Please input a valid Business Unit of Responsible Risk Officer.");

		}else{

			var url = window.sessionStorage.getItem('serverPath')+"groupDetail/submit";

			var jsonArr = { 
				crId: getURLParameters("crId"), 
				userId: window.sessionStorage.getItem("username"), 
				bocGroupId: checkUndefinedElement(document.getElementById("groupBocGroupId").value),
				respRiskOfficer: checkUndefinedElement(document.getElementById("responsibleRiskOfficer").value),
				bizUnitRespRiskOfficer: checkUndefinedElement(document.getElementById("busUnitOfResponsibleRiskOfficer").value),
				nextReviewDate: strToDate(document.getElementById("nextReviewDate").value),
				initialOnboardDate: strToDate(document.getElementById("initialOnboardDate").value),
				latestFinancialRptDate: strToDate(document.getElementById("latestFinancialReport").value),
				domicile: checkUndefinedElement(document.getElementById("domicileField").value),
				countryOfRisk: checkUndefinedElement(document.getElementById("countryOfRisk").value),
				industryGroup: checkUndefinedElement(document.getElementById("industryGroup").value),
				industrySubGroup: checkUndefinedElement(document.getElementById("industrySubGroup").value),
				industrySector: checkUndefinedElement(document.getElementById("industrySector").value),
				marketCapitalization: checkUndefinedElement(document.getElementById("marketCapitalization").value),
				creditRatingInr: checkUndefinedElement(document.getElementById("internalCreditRatingBasel").value),
				creditRatingSnp: checkUndefinedElement(document.getElementById("creditRatingSnp").value),
				creditRatingMoodys: checkUndefinedElement(document.getElementById("creditRatingMoodys").value),
				creditRatingFitch: checkUndefinedElement(document.getElementById("creditRatingFitch").value),
				riskRatingForApproval: checkUndefinedElement(document.getElementById("approvalRiskRating").value),
				overallLoanClassification: checkUndefinedElement(document.getElementById("overallLoanClass").value),
				bbgTicker: checkUndefinedElement(document.getElementById("bbgTicker").value),
				rmdGroupRemark: checkUndefinedElement(document.getElementById("Remarks").value),
				externalKey1: checkUndefinedElement(document.getElementById("extKey1").value), 
				externalKey2: checkUndefinedElement(document.getElementById("extKey2").value), 
				externalKey3: checkUndefinedElement(document.getElementById("extKey3").value), 
				externalKey4: checkUndefinedElement(document.getElementById("extKey4").value), 
				externalKey5: checkUndefinedElement(document.getElementById("extKey5").value), 
				externalKey6: checkUndefinedElement(document.getElementById("extKey6").value), 
				externalKey7: checkUndefinedElement(document.getElementById("extKey7").value), 
				externalKey8: checkUndefinedElement(document.getElementById("extKey8").value), 
				externalKey9: checkUndefinedElement(document.getElementById("extKey9").value), 
				externalKey10: checkUndefinedElement(document.getElementById("extKey10").value),
				rmdGroupRemark: checkUndefinedElement(document.getElementById("RemarksField").value)
			};

			var dataSource = new kendo.data.DataSource({
				transport: {
					read: {
						url: url,
						type: "POST",
						contentType: "application/json; charset=utf-8",
						dataType: "json",
						data: jsonArr,
						xhrFields: {
				    		withCredentials: true
				    	},
				    	complete: function(jqXHR, textStatus) {
					    	  var obj = JSON.parse(jqXHR.responseText);
					    	  console.log(obj.message);
					    	  window.sessionStorage.setItem('message', obj.message);
					    	  window.location.href = "groupMaintenanceList";
				    	}
					},
					parameterMap: function(data) {
				      	return kendo.stringify(data);
				    }
				},
				schema: { 
		            model:{
		            	id: "message",
		            	fields:{
		            		message: {type: "string"},     
		            		status: {type: "string"}     
		            	}
		            }
		        }
			});

			dataSource.read();
     	 }
		/*window.location.href = "groupMaintenanceList";*/
	}

	/* Action -> To verify */
	function toVerify(){
		var url = window.sessionStorage.getItem('serverPath')+"groupDetail/verify";

		var jsonArr = { 
			crId: getURLParameters("crId"), 
			userId: window.sessionStorage.getItem("username"),
			crRemark: checkUndefinedElement(document.getElementById("remarkArea").value)
		};

		var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: url,
					type: "POST",
					contentType: "application/json; charset=utf-8",
					dataType: "json",
					data: jsonArr,
					xhrFields: {
			    		withCredentials: true
			    	},
			    	complete: function(jqXHR, textStatus) {
				    	  var obj = JSON.parse(jqXHR.responseText);
				    	  console.log(obj.message);
				    	  window.sessionStorage.setItem('message', obj.message);
				    	  window.location.href = "groupMaintenanceList";
			    	}
				},
				parameterMap: function(data) {
			      	return kendo.stringify(data);
			    }
			},
			schema: { 
	            model:{
	            	id: "message",
	            	fields:{
	            		message: {type: "string"},     
	            		status: {type: "string"}     
	            	}
	            }
	        }
		});

		dataSource.read();
		/*window.location.href = "groupMaintenanceList";*/
	}

	/* The method which is used for capturing the parameters from URL */
	/* Return  : a Parameter  */
	/* Receive : Parameter Name */

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
	/* Handle underfined / null element */
	function checkUndefinedElement(element){
		if(element === null || element === "undefined" || element === "null"){
			return "";
		}else{
			return element;
		}
	}
	/* Data Comparing with previous data and current data */
	function comparingWithBefore(field, bfField, before, current){
		if(before != current){
			field.innerHTML = before;
			bfField.innerHTML = current;
			field.value = before;
			bfField.value = current;
			field.style.color = "black";
			bfField.style.color = "red";
			console.log("before -> " + bfField.value);
			console.log("After -> " + field.value);
		}else{
			field.innerHTML = current;
		}
	}
    </script>

<body>
<%@include file="header1.jsp"%>
<div class="page-title">Group RMD Maintenace - Change Requests</div>
	<!-- <input style="" "width:100%\" class=\ "k-textbox\" type="hidden"
		id="pagetitle" name="pagetitle"
		value="Group RMD Maintenace - Change Requests"> -->
	<!-- <script type="text/javascript" src="/ermsweb/resources/js/header.js"></script> -->
	<%-- <%@include file="header.jsp"%> --%>

	<br>
	<table border="0" cellpadding="6" cellspacing="1">
		<tr>
			<td>
				<table id="listTable" width:"100%" style="overflow-y: scroll"
					cellpadding="6" cellspacing="1">
					<tr>
						<td colspan="4" align="right">
							<div id="buttonType">
								<button id="submitBtn" type="button">Submit</button>
								<button id="exportBtn" type="button">Save</button>
								<button id="resetBtn" type="button">Back</button>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="4"
							style="background-color: #393052; color: white; width: 500; font-size: 13px">Group
							Details</td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Group
							ID.</td>
						<td colspan="2" width="333"
							style="font-size: 13px; background-color: #E7E3EF"><div
								id="group_id">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Group
							Type.</td>
						<td colspan="2" width="333"
							style="font-size: 13px; background-color: #E7E3EF"><div
								id="group_type_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Group
							Name.</td>
						<td colspan="2" width="333"
							style="font-size: 13px; background-color: #E7E3EF"><div
								id="group_name_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Group
							Name in Chinese.</td>
						<td colspan="2" width="333"
							style="font-size: 13px; background-color: #E7E3EF"><div
								id="group_name_chi">
								<label></label>
							</div></td>
					</tr>

					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">BOC.
							Group ID.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="group_boc_group_id">
								<label></label>
							</div></td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfGroup_boc_group_id">
								<label></label>
							</div>
						</td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Responsible
							Risk Officer.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="responsible_risk_officer">
								<label></label>
							</div></td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfResponsible_risk_officer">
								<label></label>
							</div>
						</td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Business
							Unit of Responsible Risk Officer.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="bus_unit_of_responsible_risk_officer">
								<label></label>
							</div></td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfBus_unit_of_responsible_risk_officer">
								<label></label>
							</div>
						</td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Next
							Review Date.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"
							valign="center"><input style="width: 100%;"
							id="nextReviewDate" height="50%" /></td>
						<td class="compareCol" width="166"
							style="font-size: 13px; background-color: #E7E3EF"><input
							style="width: 100%;" id="bfNextReviewDate" height="50%" /></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Initial
							Onboard Date.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"
							valign="center"><input style="width: 100%;"
							id="initialOnboardDate" height="50%" /></td>
						<td class="compareCol" width="166"
							style="font-size: 13px; background-color: #E7E3EF"><input
							style="width: 100%;" id="bfInitialOnboardDate" height="50%" /></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Latest
							Financial Report Date.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"
							valign="center"><input style="width: 100%;"
							id="latestFinancialReport" height="50%" /></td>
						<td class="compareCol" width="166"
							style="font-size: 13px; background-color: #E7E3EF"><input
							style="width: 100%;" id="bfLatestFinancialReport" height="50%" />
						</td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Domicile.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="domicile">
								<label></label>
							</div></td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfDomicile">
								<label></label>
							</div>
						</td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Country
							of Risk.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="country_of_risk">
								<label></label>
							</div></td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfCountry_of_risk">
								<label></label>
							</div>
						</td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Industry
							Group.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="industry_group">
								<label></label>
							</div></td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfIndustry_group">
								<label></label>
							</div>
						</td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Industry
							Sector.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="industry_sector">
								<label></label>
							</div></td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfIndustry_sector"></div>
						</td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Industry
							Sub Group</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="industry_sub_group">
								<label></label>
							</div></td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfIndustry_sub_group"></div>
						</td>
					</tr>

					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Internal
							Credit Rating (Basel).</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="internal_credit_rating_basel">
								<label></label>
							</div></td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfInternal_credit_rating_basel" />
						</td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Market
							Capitalization.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="market_capitalization">
								<label></label>
							</div></td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfMarket_capitalization" />
						</td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Credit
							Rating - S&P.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="credit_rating_snp"></div></td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfCredit_rating_snp" />
						</td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Credit
							Rating - Moody's.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="credit_rating_moodys">
								<label></label>
							</div></td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfCredit_rating_moodys" />
						</td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Credit
							Rating - Fitch.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="credit_rating_fitch">
								<label></label>
							</div></td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfCredit_rating_fitch" />
						</td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Risk
							Rating - For Approval.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="approval_risk_rating">
								<label></label>
							</div></td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfApproval_risk_rating"></div>
						</td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Overall
							Loan Classification.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="overall_loan_class">
								<label></label>
							</div></td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfOverall_loan_class"></div>
						</td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">BBG
							Ticker.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="bbg_ticker"></div></td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfBbg_ticker" />
						</td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Remarks.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="Remarks">
								<label></label>
							</div></td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfRemarks" />
						</td>
					</tr>
					<tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #1</td>
						<td width="166" style="font-size: 13px; background-color: #E7E3EF">
							<div id="checkEXTKey1" />
						</td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfCheckEXTKey1" />
						</td>

					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #2</td>
						<td width="166" style="font-size: 13px; background-color: #E7E3EF">
							<div id="checkEXTKey2" />
						</td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfCheckEXTKey2" />
						</td>

					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #3</td>
						<td width="166" style="font-size: 13px; background-color: #E7E3EF">
							<div id="checkEXTKey3" />
						</td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfCheckEXTKey3" />
						</td>

					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #4</td>
						<td width="166" style="font-size: 13px; background-color: #E7E3EF">
							<div id="checkEXTKey4" />
						</td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfCheckEXTKey4" />
						</td>

					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #5</td>
						<td width="166" style="font-size: 13px; background-color: #E7E3EF">
							<div id="checkEXTKey5" />
						</td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfCheckEXTKey5" />
						</td>

					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #6</td>
						<td width="166" style="font-size: 13px; background-color: #E7E3EF">
							<div id="checkEXTKey6" />
						</td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfCheckEXTKey6" />
						</td>

					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #7</td>
						<td width="166" style="font-size: 13px; background-color: #E7E3EF">
							<div id="checkEXTKey7" />
						</td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfCheckEXTKey7" />
						</td>

					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #8</td>
						<td width="166" style="font-size: 13px; background-color: #E7E3EF">
							<div id="checkEXTKey8" />
						</td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfCheckEXTKey8" />
						</td>

					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #9</td>
						<td width="166" style="font-size: 13px; background-color: #E7E3EF">
							<div id="checkEXTKey9" />
						</td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfCheckEXTKey9" />
						</td>

					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #10</td>
						<td width="166" style="font-size: 13px; background-color: #E7E3EF">
							<div id="checkEXTKey10" />
						</td>
						<td class="compareCol" width="333"
							style="font-size: 13px; background-color: #E7E3EF">
							<div id="bfCheckEXTKey10" />
						</td>

					</tr>
				</table>
			</td>
			<td align="center" style="vertical-align: top"></td>
		</tr>
	</table>
	<br>

	<div style="overflow-y: scroll; overflow-y: hidden; width: 1000px;">
		<table id="list" width="1000">
			<tr style="background-color: #082439; color: white">
				<td colspan="15">
					<div style="font-size: 13px">Group Member</div>
				</td>
			</tr>
			<tr style="background-color: #BDCFE7; font-size: 13px;">
				<td width="166">CCD ID&nbsp;</td>
				<td width="166">Client/Counterparty&nbsp;</td>
				<td width="166">Account No.&nbsp;</td>
				<td width="166">Sub Acc&nbsp;</td>
				<td width="166">Account_Name&nbsp;</td>
				<td width="166">Acc - Biz Unit&nbsp;</td>
			</tr>
			<tr>
				<td colspan="8">
					<div id="modal" align="center" style="display: none;">
						<img id="loader" src="/ermsweb/resources/images/ajax-loader.gif" />
					</div>
				</td>
			</tr>
		</table>
		<br>
	</div>
	<div style="font-size: 13px" id="countRow"></div>
	<br>
	<div style="width: 1000" id='MyGrid'>
		<div id="modal2" align="center" style="display: none;">
			<!-- <div style="background-color:grey; color:white">Result</div> -->
			<img id="loader2" src="/ermsweb/resources/images/ajax-loader.gif" />
		</div>
	</div>
	<br>
	<table cellpadding="0" border="0" cellspacing="0"
		style="font-size: 13px; font-weight: bold;" border="1" width="500"
		id="approval">
		<tr>
			<td colspan="2"
				style="font-size: 13px; background-color: #944900; color: white"
				width="250">Approval</td>
		</tr>
		<tr style="background-color: #FFC394">
			<td width="250">Action Performed By Maker</td>
			<td>Update</td>
		</tr>
		<tr style="background-color: #FFC394">
			<td width="250">Remarks</td>
			<td><div id="remarks"></div></td>
		</tr>
	</table>
	<br>
	<br>
	<table border="0" style="background-color: #B5D5AB">
		<tr>
			<td width="195.5" style="font-size: 13px"><b>Created By</b></td>
			<td width="195.5" style="font-size: 13px"><label id="createdBy"></label></td>
			<td width="195.5" style="font-size: 13px"></td>
			<td width="195.5" style="font-size: 13px"><b>Created At</b></td>
			<td width="195.5" style="font-size: 13px"><label id="createdAt"></label></td>
		</tr>
		<tr>
			<td width="195.5" style="font-size: 13px"><b>Updated By</b></td>
			<td width="195.5" style="font-size: 13px"><label id="updateBy"></label></td>
			<td width="195.5" style="font-size: 13px"></td>
			<td width="195.5" style="font-size: 13px"><b>Updated At</b></td>
			<td width="195.5" style="font-size: 13px"><label id="updateAt"></label></td>
		</tr>
		<tr>
			<td width="195.5" style="font-size: 13px"><b>Verified By</b></td>
			<td width="195.5" style="font-size: 13px"><label id="verifiedBy"></label></td>
			<td width="195.5" style="font-size: 13px"></td>
			<td width="195.5" style="font-size: 13px"><b>Verified At</b></td>
			<td width="195.5" style="font-size: 13px"><label id="verifiedAt"></label></td>
		</tr>
		<tr>
			<td width="195.5" style="font-size: 13px"><b>Status</b></td>
			<td width="195.5" style="font-size: 13px"><label id="status"></label></td>
			<td width="195.5" style="font-size: 13px"></td>
			<td width="195.5" style="font-size: 13px"></td>
			<td width="195.5" style="font-size: 13px"></td>
		</tr>
	</table>
</body>
</html>
