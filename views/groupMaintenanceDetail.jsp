<!DOCTYPE html>

<html lang="en">
<link rel="shortcut icon" href="/ermsweb/resources/images/boci.ico" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 
<script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>



<!-- Kendo UI API -->

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
	 	var objPastToPager = null; // This value will be used to pass the value='2 to another list

	 	var initialLoad = true; // Nothing
 			$(document).ready(
 				function(){
 				
 					$("#nextReviewDate").kendoDatePicker({
                        value: "",
                        format: "dd/MM/yyyy"
                    });
                    $("#nextReviewDate").attr("readonly","readonly" );
                    $("#initialOnboardDate").kendoDatePicker({
                        value: "",
                        format: "dd/MM/yyyy"
                    });
                    $("#initialOnboardDate").attr("readonly","readonly" );
					$("#latestFinancialReport").kendoDatePicker({
                        value: "",
                        format: "dd/MM/yyyy"
                    });
                    $("#latestFinancialReport").attr("readonly","readonly" );

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

				/* Get the action type - view for directing to the view mode on this page */
				/* Replacing the button, label from update to view */
				/* Maker action -> */

				/* ---------------------------------------------------------------------------------------------------------------------------------------------------- */
					var url = window.sessionStorage.getItem('serverPath')+"groupDetail/getRecord?rmdGroupId="+getURLParameters("rmdGroupId")+"&userId="+window.sessionStorage.getItem("username");

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
				            	id: "rmdGroupId",
				            	fields:{
				            		rmdGroupId: {type: "string"}    
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
     		 					document.getElementById("credit_rating_sp").innerHTML = checkUndefinedElement(response.creditRatingSnp);
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
								document.getElementById("extKey10").innerHTML = checkUndefinedElement(response.externalKey10);	

					     	}else{

					     		if(new RegExp("action\=update").test($(location).attr('href'))){
						     		document.getElementById("groupId").innerHTML = checkUndefinedElement(response.rmdGroupId);		     	
						     		document.getElementById("groupType").innerHTML = checkUndefinedElement(response.groupTypeDesc);		     	
						     		document.getElementById("groupName").innerHTML = checkUndefinedElement(response.rmdGroupDesc);
						     		document.getElementById("groupNameChi").innerHTML = checkUndefinedElement(response.rmdGroupDescChi);
						     		document.getElementById("groupBocGroupId").value = checkUndefinedElement(response.bocGroupId);

						     		document.getElementById("responsibleRiskOfficer").value = checkUndefinedElement(response.respRiskOfficer);
						     		
						     		/* ---------------------------- */
						     		var option = document.createElement("option");
						     		option.text = checkUndefinedElement(response.bizUnitRespRiskOfficer);
						     		option.value = checkUndefinedElement(response.bizUnitRespRiskOfficer);
						     		document.getElementById("busUnitOfResponsibleRiskOfficer").appendChild(option);
						     		document.getElementById("busUnitOfResponsibleRiskOfficer").selectedIndex = document.getElementById("busUnitOfResponsibleRiskOfficer").options.length - 1;
						     		option = null;

						     		/* ---------------------------- */
	     		 					document.getElementById("nextReviewDate").value = toDateFormat(checkUndefinedElement(response.nextReviewDate));
	     		 					document.getElementById("initialOnboardDate").value = toDateFormat(checkUndefinedElement(response.initialOnboardDate));
	     		 					document.getElementById("latestFinancialReport").value = toDateFormat(checkUndefinedElement(response.latestFinancialRptDate));
	     		 					
	     		 					/* ---------------------------- */
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
	     		 					
	     		 					/* ---------------------------- */
	     		 					document.getElementById("industryGroup").value = checkUndefinedElement(response.industryGroup);
	     		 					document.getElementById("industrySubGroup").value = checkUndefinedElement(response.industrySubGroup);
	     		 					document.getElementById("industrySector").value = checkUndefinedElement(response.industrySector);
	     		 					document.getElementById("internalCreditRatingBasel").value = checkUndefinedElement(response.creditRatingInr);
	     		 					document.getElementById("marketCapitalization").value = checkUndefinedElement(response.marketCapitalization);
	     		 					document.getElementById("credit_rating_snp").value = checkUndefinedElement(response.creditRatingSnp);
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
						     	}
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
			    	$("#nextReviewDate").attr("readonly","readonly" );
			    	$("#initialOnboardDate").attr("readonly","readonly" );
			    	$("#latestFinancialReport").attr("readonly","readonly" );

				/* ---------------------------------------------------------------------------------------------------------------------------------------------------- */

				
 					if(new RegExp("action\=view").test($(location).attr('href'))){
 						
 						$("#pagetitle").val("Maintenance - Group Detail Maintenance - View	Group Detail");

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
						$("#credit_rating_sp").html("<label id=\"credit_rating_sp\"></label>");
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
 						
 						if(new RegExp("update").test($(location).attr('href'))){
 							$("#buttonType").html("<button id=\"updateBtn\" style=\"\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" onclick=\"toUpdate()\">Update</button><label>    </label><button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Back</button>");
 						}else{
 							$("#buttonType").html("<button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Back</button>");
 						}
 					}else{
 						
 						/* Get the action type - update for directing to the update mode on this page. */
 						/* Replacing the button, label from view to update */
	
 						if(new RegExp("action\=update").test($(location).attr('href'))){

 							$("#pagetitle").val("Maintenance - Group Detail Maintenance - Update Group Detail");

 							$("#group_id").html("<label id=\"groupId\"></label>");
 							$("#group_type_label").html("<label id=\"groupType\"></label>");
 							$("#group_name_label").html("<label id=\"groupName\"></label>");
	 						$("#group_name_chi").html("<label id=\"groupNameChi\"></input>");
							$("#group_boc_group_id").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"groupBocGroupId\"></input>");
							$("#responsible_risk_officer").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"responsibleRiskOfficer\"></input>");

							/* ------------------------------------ */
							$("#bus_unit_of_responsible_risk_officer").html("<select class=\"select_join\" style=\"width:100%\" id=\"busUnitOfResponsibleRiskOfficer\"> <option value=\"1\">1</option> <option value=\"2\">2</option> <option value=\"3\">3</option> </select>");
							/* ------------------------------------ */
							$("#nextReviewDate").data('kendoDatePicker').enable(true);
							$("#initialOnboardDate").data('kendoDatePicker').enable(true);
							$("#latestFinancialReport").data('kendoDatePicker').enable(true);

							/* ------------------------------------ */
							$("#domicile").html("<select class=\"select_join\" style=\"width:100%\" id=\"domicileField\">  <option value=\"1\">1</option> <option value=\"2\">2</option> <option value=\"3\">3</option>  </select>");
							$("#country_of_risk").html("<select class=\"select_join\" style=\"width:100%\" id=\"countryOfRisk\"> <option value=\"1\">1</option> <option value=\"2\">2</option> <option value=\"3\">3</option> </select>");
							/* ------------------------------------ */

							$("#industry_group").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"industryGroup\"></input>");
							$("#industry_sub_group").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"industrySubGroup\"></label>");
							$("#industry_sector").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"industrySector\"></input>");
							$("#internal_credit_rating_basel").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"internalCreditRatingBasel\"></input>");
							$("#market_capitalization").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"marketCapitalization\"></input>");
							$("#credit_rating_sp").html("<input style=\"width:100%\" class=\"k-textbox\" type=\"text\" id=\"credit_rating_snp\"></input>");
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

 							$("#buttonType").html("<button id=\"submitBtn\" style=\"\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" onclick=\"toSubmit()\">Submit</button><label>     </label><button id=\"saveBtn\" style=\"\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" onclick=\"toSave()\">Save</button><label>     </label><button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Back</button>");
 						}
 					}


        	     	/* 
        	     		Delete / Clean rows for refresh the table by delete all of rows
        	     	 */

        	     	var oRows = document.getElementById('listTable').getElementsByTagName('tr');
        	     	var iRowCount = oRows.length;

        	     	for (var i = 0; i < iRowCount; i++) {
    	                 		$('#tabRow'+i).remove();
                 	};
                 	
                 	 /* Open spinner while getting the data from back-end */

        	     	 // server configuation  //
					var getMemberURL = window.sessionStorage.getItem('serverPath')+"groupDetail/getMember?rmdGroupId="+getURLParameters("rmdGroupId")+"&userId="+window.sessionStorage.getItem("username");
					
					var dataSource = new kendo.data.DataSource({
						transport: {
							read: {
					   		  	type: "GET",
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
					
					dataSource.read();
					
        	     // end //
		        	$("#resetBtn").kendoButton(); // Reset button event
		        	$("#exportBtn").kendoButton(); // Export button event
	        	}
 			);
	
	

	/* Action - Update button */
	function toUpdate(){ /* Direct me to update page */
		window.location = "groupMaintenanceDetail?action=update&rmdGroupId="+getURLParameters("rmdGroupId");
	}

	/* Action - View button */
	function toView(){ /* Direct me to view page */
		var updateBtn = document.getElementById("submitBtn");
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
				rmdGroupId: getURLParameters("rmdGroupId"), 
				userId: window.sessionStorage.getItem("username").replace("\\", "\\"),
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
				creditRatingSnp: checkUndefinedElement(document.getElementById("credit_rating_snp").value),
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
				    read: function(options) {
	                    $.ajax({
	                        type: "POST",
	                        url: url,
	                        data: JSON.stringify(jsonArr),
	                        contentType: "application/json; charset=utf-8",
	                        dataType: "json",
	                        success: function (result) {
	                            options.success(result);
	                        },
	                        complete: function (jqXHR, textStatus){
								if(textStatus == "success"){
									var obj = JSON.parse(jqXHR.responseText);
									console.log(obj.message.toUpperCase());
									window.sessionStorage.setItem('message', obj.message);
									window.location.href = "groupMaintenanceList";
								}
							},
	                        xhrFields: {
					    		withCredentials: true
					    	}
	                    });
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
			toReset ();
		}
		/*window.location.href = "groupMaintenanceList";*/
	}

	function strToDate(dateStr){ // This function is for transforming dd/mm/yyyy -> Data(mm, dd, yyyy)
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

		var url = window.sessionStorage.getItem('serverPath')+"groupDetail/save";

		if(strToDate(document.getElementById("nextReviewDate").value) <= new Date()){

			alert("Next Review Date must be greater than today");

		}else if(checkUndefinedElement(document.getElementById("responsibleRiskOfficer").value) == ""){

			alert("Please input a valid Responsible Risk Officer");
					
		}else if(checkUndefinedElement(document.getElementById("busUnitOfResponsibleRiskOfficer").value) == ""){

			alert("Please input a valid Business Unit of Responsible Risk Officer.");

		}else{

			var jsonArr = { 
				rmdGroupId: getURLParameters("rmdGroupId"), 
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
				creditRatingSnp: checkUndefinedElement(document.getElementById("credit_rating_snp").value),
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
				    read: function(options) {
	                    $.ajax({
	                        type: "POST",
	                        url: url,
	                        data: JSON.stringify(jsonArr),
	                        contentType: "application/json; charset=utf-8",
	                        dataType: "json",
	                        success: function (result) {
	                            options.success(result);
	                        },
	                        complete: function (jqXHR, textStatus){
								if(textStatus == "success"){
									var obj = JSON.parse(jqXHR.responseText);
									console.log(obj.message.toUpperCase());
									window.sessionStorage.setItem('message', obj.message);
									window.location.href = "groupMaintenanceList";
								}
							},
	                        xhrFields: {
					    		withCredentials: true
					    	}
	                    });
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
			toReset();
		}
	}
	
	/* Handle underfined / null element */
	function checkUndefinedElement(element){
		if(element === null || element === "undefined"){
			return "";
		}else{
			return element;
		}
	}
	/* Open spinner while getting the data from back-end*/
	function openModal() {
	     document.getElementById('modal').style.display = 'block';
	     /* document.getElementById('modal2').style.display = 'block'; */
	}
	function toReset(){

		/*sessionStorage.setItem("groupName2",window.sessionStorage.getItem("groupName"));
		sessionStorage.setItem("groupType2",window.sessionStorage.getItem("groupType"));
		sessionStorage.setItem("ccdId2",window.sessionStorage.getItem("ccdId"));
		sessionStorage.setItem("cmdClientId2",window.sessionStorage.getItem("cmdClientId"));
		sessionStorage.setItem("clientCptyName2",window.sessionStorage.getItem("clientCptyName"));
		sessionStorage.setItem("accountNo2",window.sessionStorage.getItem("accountNo"));
		sessionStorage.setItem("subAcc2",window.sessionStorage.getItem("subAcc"));
		sessionStorage.setItem("accName2",window.sessionStorage.getItem("accName"));
		sessionStorage.setItem("accBizUnit2",window.sessionStorage.getItem("accBizUnit"));
		window.sessionStorage.removeItem("groupName");
		window.sessionStorage.removeItem("groupType");
		window.sessionStorage.removeItem("ccdId");
		window.sessionStorage.removeItem("cmdClientId");
		window.sessionStorage.removeItem("clientCptyName");
		window.sessionStorage.removeItem("accountNo");
		window.sessionStorage.removeItem("subAcc");
		window.sessionStorage.removeItem("accName");
		window.sessionStorage.removeItem("accBizUnit");*/
	}	
	/* Close spinner when all the data have been received*/
	function closeModal() {
	    document.getElementById('modal').style.display = 'none';
	    /* document.getElementById('modal2').style.display = 'none'; */
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

    </script>

<body>
<%@include file="header1.jsp"%>
<div class="page-title">Group RMD Maintenace - Detail</div>
	<!-- <input type="hidden" id="pagetitle" name="pagetitle" value="">
	<br> -->
	<table border="0" cellpadding="6" cellspacing="1">
		<tr>
			<td width="50%">
				<table id="listTable" style="overflow-y: scroll" border="0"
					cellpadding="6" cellspacing="1">
					<tr>
						<td align="right" colspan="4">
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
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="group_id"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Group
							Type.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="group_type_label"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Group
							Name.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="group_name_label"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Group
							Name in Chinese.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="group_name_chi"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">BOC.
							Group ID.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="group_boc_group_id"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Responsible
							Risk Officer.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="responsible_risk_officer"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Business
							Unit of Responsible Risk Officer.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="bus_unit_of_responsible_risk_officer"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Next
							Review Date.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"
							valign="center"><input style="width: 100%;"
							id="nextReviewDate" height="50%" /></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Initial
							Onboard Date.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"
							valign="center"><input style="width: 100%;"
							id="initialOnboardDate" height="50%" /></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Latest
							Financial Report Date.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"
							valign="center"><input style="width: 100%;"
							id="latestFinancialReport" height="50%" /></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Domicile.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="domicile"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Country
							of Risk.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="country_of_risk"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Industry
							Group.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="industry_group"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Industry
							Sector.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="industry_sector"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Industry
							Sub Group</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="industry_sub_group"></div></td>
					</tr>

					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Internal
							Credit Rating (Basel).</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="internal_credit_rating_basel"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Market
							Capitalization.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="market_capitalization"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Credit
							Rating - S&P.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="credit_rating_sp"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Credit
							Rating - Moody's.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="credit_rating_moodys"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Credit
							Rating - Fitch.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="credit_rating_fitch"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Risk
							Rating - For Approval.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="approval_risk_rating"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Overall
							Loan Classification.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="overall_loan_class"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">BBG
							Ticker.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="bbg_ticker"></div></td>
					</tr>
					<tr>
						<td width="166" style="font-size: 13px; background-color: #B5A2C6">Remarks.</td>
						<td width="333" style="font-size: 13px; background-color: #E7E3EF"><div
								id="Remarks"></div></td>
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
				</table>
			</td>
			<td width="50%" style="vertical-align: top;" align="center"></td>
		<tr>
	</table>
	<br>

	<div style="overflow-y: scroll; overflow-y: hidden; width: 100%;">
		<table id="list" width="100%">
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

	<table border="0" style="background-color: #B5D5AB" width="100%">
		<tr>
			<td width="195.5" style="font-size: 13px"><b>Created By</b></td>
			<td width="195.5" style="font-size: 13px"><label id="createdBy"></label></td>

			<td width="195.5" style="font-size: 13px"><b>Created At</b></td>
			<td width="195.5" style="font-size: 13px"><label id="createdAt"></label></td>
		</tr>
		<tr>
			<td width="195.5" style="font-size: 13px"><b>Updated By</b></td>
			<td width="195.5" style="font-size: 13px"><label id="updateBy"></label></td>

			<td width="195.5" style="font-size: 13px"><b>Updated At</b></td>
			<td width="195.5" style="font-size: 13px"><label id="updateAt"></label></td>
		</tr>
		<tr>
			<td width="195.5" style="font-size: 13px"><b>Verified By</b></td>
			<td width="195.5" style="font-size: 13px"><label id="verifiedBy"></label></td>

			<td width="195.5" style="font-size: 13px"><b>Verified At</b></td>
			<td width="195.5" style="font-size: 13px"><label id="verifiedAt"></label></td>
		</tr>
		<tr>
			<td width="195.5" style="font-size: 13px"><b>Status</b></td>
			<td width="195.5" style="font-size: 13px"><label id="status"></label></td>

			<td width="195.5" style="font-size: 13px"></td>
			<td width="195.5" style="font-size: 13px"></td>
		</tr>
	</table>
</body>
</html>
