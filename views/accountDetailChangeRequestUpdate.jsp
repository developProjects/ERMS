<!DOCTYPE html>

<html lang="en">
<meta http-equiv='cache-control' content='no-cache'>
<meta http-equiv='expires' content='0'>
<meta http-equiv='pragma' content='no-cache'>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10">
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

<!-- Kendo UI combined JavaScript -->
<script src="/ermsweb/resources/js/kendo.all.min.js"></script>
<script src="/ermsweb/resources/js/common_tools.js"></script>

<!-- <head>Enquiry Loan Sub-Participation Ratio</head> -->
<style type="text/css">
.k-grid-header tr th.k-header {
	background-color: #B54D4D;
	font-size: 13px;
	color: #fff;
	white-space: pre-line;
}
</style>
<script>
		$(document).ready(
			function(){
				
				
				 /* Calling the ajax loader image */
				openModal();
				
				var params = "${dataList}";
				var array = params.split('||');
				var tmpAcctId = "";
				var tmpAcctClientType = "";
				var tmpEntityOfGuarantee = "";

				var dataSource = new kendo.data.DataSource({
					transport: {
						read: {
							url: window.sessionStorage.getItem('serverPath')+"acct/getRecord?crId="+array[0]+"&bizUnit="+array[1]+"&bookEntity="+array[2]+"&dataSourceAppId="+array[3]+"&userId="+window.sessionStorage.getItem("username"),
							dataType: "json",
							contentType: "application/json; charset=utf-8",
							
		    			    xhrFields: {
					    		withCredentials: true
					    	}
						},
						update:{
							type:"POST",
							url : function(options) {
					        	return window.sessionStorage.getItem('serverPath')+"acct/" + options.actionPage
							},
							dataType: "json",
							contentType:"application/json",
							complete: function (jqXHR, textStatus){
								var response = JSON.parse(jqXHR.responseText);
								if(response.action){
									if(response.action == "success"){
										window.sessionStorage.setItem('message', JSON.parse(jqXHR.responseText).message);
										window.location.href = "/ermsweb/accountDetailMaintenance";
									}
								}
								
							},
							xhrFields: {
					    		withCredentials: true
					    	}
						},
						parameterMap: function(options, operation) {
						    if (operation != "read" ) {
						    	if (operation == "update" ) {
							        return JSON.stringify({
							        	crId: options.crId,
							        	bizUnit: options.bizUnit,
							        	dataSourceAppId: options.dataSourceAppId,
							        	bookEntity: options.bookEntity,
							        	userId: options.userId,
							        	acctClientType: options.acctClientType,
							        	guaranteeEntity: options.guaranteeEntity,
							        	externalKey1: options.externalKey1,
							        	externalKey2: options.externalKey2,
							        	externalKey3: options.externalKey3,
							        	externalKey4: options.externalKey4,
							        	externalKey5: options.externalKey5,
							        	externalKey6: options.externalKey6,
							        	externalKey7: options.externalKey7,
							        	externalKey8: options.externalKey8,
							        	externalKey9: options.externalKey9,
							        	externalKey10: options.externalKey10
							        });//JSON.stringify(options);
						    	}else{
						    		return "";
						    	}
							}
						}
					},
					error:function(e){
						if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
					},
					schema: { 
			            model:{
			            	id: "crId",
			            	fields:{
			            		userId: {type: "string"},
			            		bookEntity: {type: "string"},
			            		bizUnit: {type: "string"},
			            		dataSourceAppId: {type: "string"},
			            		guaranteeEntity: {type: "string"},
			            		externalKey1: {type: "string"},
			            		externalKey2: {type: "string"},
			            		externalKey3: {type: "string"},
			            		externalKey4: {type: "string"},
			            		externalKey5: {type: "string"},
			            		externalKey6: {type: "string"},
			            		externalKey7: {type: "string"},
			            		externalKey8: {type: "string"},
			            		externalKey9: {type: "string"},
			            		externalKey10: {type: "string"},
			            		actionPage: {type: "string"},
			            		crId: {type: "string"}
			            	}
			            }
			        }
				});
				
			dataSource.fetch(function(){
				var jsonObj = this.view();
				$.each(jsonObj, function(i){

					tmpAcctClientType = "";
					tmpEntityOfGuarantee = "";

					tmpAcctId = validateResponse(jsonObj[i].acctId);
					$("#ccd_id_label").html("<label>"+validateResponse(jsonObj[i].ccdId)+"</label>");
					$("#cmd_client_id_label").html("<label>"+validateResponse(jsonObj[i].cmdCustId)+"</label>");
					$("#client_counterparty_name_label").html("<label>"+validateResponse(jsonObj[i].legalPartyName)+"</label>");
					$("#Acc_No_label").html("<label>"+validateResponse(jsonObj[i].acctId)+"</label>");
					$("#Acc_Name_label").html("<label>"+validateResponse(jsonObj[i].acctEngName)+"</label>");
					$("#Acc_Name_Chi_label").html("<label>"+validateResponse(jsonObj[i].acctChiName)+"</label>");
					$("#Acc_Client_Type_label").html("<input id='Acc_client_type' value='"+validateResponse(jsonObj[i].acctClientType)+"'/>");

					tmpAcctClientType = validateResponse(jsonObj[i].acctClientType);
					

					$("#Acc_is_Joint_label").html("<label>"+validateResponse(jsonObj[i].isJointAcctInd)+"</label>");
					$("#Acc_Acc_Type_label").html("<label>"+validateResponse(jsonObj[i].acctType)+"</label>");
					$("#Acc_Open_Date_label").html("<label>"+validateResponse(jsonObj[i].acctOpenDate)+"</label>");
					$("#Acc_Status_label").html("<label>"+validateResponse(jsonObj[i].cmdAcctStatus)+"</label>");
					$("#Acc_Entity_label").html("<label>"+validateResponse(jsonObj[i].bookEntity)+"</label>");
					$("#Acc_Biz_Unit_label").html("<label>"+validateResponse(jsonObj[i].bizUnit)+"</label>");
					$("#Acc_Sale_Code_label").html("<label>"+validateResponse(jsonObj[i].salesmanCode)+"</label>");
					$("#Acc_Sale_Name_label").html("<label>"+validateResponse(jsonObj[i].salesmanName)+"</label>");	
					$("#Acc_Dept_Code_label").html("<label>"+validateResponse(jsonObj[i].salesmanDept)+"</label>");	
					$("#Acc_Source_System_label").html("<label>"+validateResponse(jsonObj[i].dataSourceAppId)+"</label>");	

					$("#Entity_Of_Guarantee_label").html("<input id='Entity_Of_Guarantee' value='"+validateResponse(jsonObj[i].guaranteeEntity)+"'/>");

					tmpEntityOfGuarantee = validateResponse(jsonObj[i].guaranteeEntity);

					$("#Country_Of_Parent_label").html("<label>"+validateResponse(jsonObj[i].ultimateParentCountry)+"</label>");	
					$("#Ultimate_Parent_Name_label").html("<label>"+validateResponse(jsonObj[i].ultimateParent)+"</label>");	
					$("#Revenue_Turnover_MTD_label").html("<label>"+validateResponse(jsonObj[i].novaMtdTurnover)+"</label>");	
					$("#Revenue_Turnover_YTD_label").html("<label>"+validateResponse(jsonObj[i].novaYtdTurnover)+"</label>");	
					$("#Revenue_Net_MTD_label").html("<label>"+validateResponse(jsonObj[i].novaMtdNetComm)+"</label>");	
					$("#Revenue_Net_YTD_label").html("<label>"+validateResponse(jsonObj[i].novaYtdNetComm)+"</label>");
					$("#Revenue_Gross_MTD_label").html("<label>"+validateResponse(jsonObj[i].novaMtdGrossComm)+"</label>");	
					$("#Revenue_Gross_YTD_label").html("<label>"+validateResponse(jsonObj[i].novaYtdGrossComm)+"</label>");	
					$("#Revenue_Margin_Interest_MTD_label").html("<label>"+validateResponse(jsonObj[i].novaMtdMarginInt)+"</label>");	
					$("#Revenue_Margin_Interest_YTD_label").html("<label>"+validateResponse(jsonObj[i].novaYtdMarginInt)+"</label>");	
					$("#Revenue_IPO_Interest_YTD_label").html("<label>"+validateResponse(jsonObj[i].novaYtdIpoInt)+"</label>");	
					
					$("#checkEXTKey1").html("<input type='text' class='k-textbox' maxlength='50' value='"+jsonObj[i].externalKey1+"'/>");
					$("#checkEXTKey2").html("<input type='text' class='k-textbox' maxlength='50'value='"+jsonObj[i].externalKey2+"'/>");
					$("#checkEXTKey3").html("<input type='text' class='k-textbox'maxlength='50'value='"+jsonObj[i].externalKey3+"'/>");
					$("#checkEXTKey4").html("<input type='text' class='k-textbox' maxlength='50'value='"+jsonObj[i].externalKey4+"'/>");
					$("#checkEXTKey5").html("<input type='text' class='k-textbox' maxlength='50'value='"+jsonObj[i].externalKey5+"'/>");
					$("#checkEXTKey6").html("<input type='text' class='k-textbox' maxlength='50'value='"+jsonObj[i].externalKey6+"'/>");
					$("#checkEXTKey7").html("<input type='text' class='k-textbox'maxlength='50'value='"+jsonObj[i].externalKey7+"'/>");
					$("#checkEXTKey8").html("<input type='text'class='k-textbox' maxlength='50'value='"+jsonObj[i].externalKey8+"'/>");
					$("#checkEXTKey9").html("<input type='text' class='k-textbox'maxlength='50'value='"+jsonObj[i].externalKey9+"'/>");
					$("#checkEXTKey10").html("<input type='text' class='k-textbox'maxlength='50' value='"+jsonObj[i].externalKey10+"'/>");
					$("#created_by").html(validateResponse(jsonObj[i].createBy));
					$("#created_at").html(validateResponse(toDateFormat(jsonObj[i].createDt)));
					$("#updated_by").html(validateResponse(jsonObj[i].lastUpdateBy));
					$("#updated_at").html(validateResponse(toDateFormat(jsonObj[i].lastUpdateDt)));
					$("#verified_by").html(validateResponse(jsonObj[i].verifyBy));
					$("#verified_at").html(validateResponse(toDateFormat(jsonObj[i].verifyDt)));
					$("#status_last").html(validateResponse(jsonObj[i].status));	
					$("#remarks").html(validateResponse(jsonObj[i].remarks));
					$("#buttonType").html("<button id=\"saveBtn\"  type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" >Save</button><label>    </label><button id=\"submitBtn\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Submit</button><label>    </label><button id=\"discardBtn\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" onclick=\"toDiscard('"+jsonObj[i].crId+"')\">Discard</button><label>    </label><button id=\"clearBtn\"  type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" onclick=\"toClear()\">Clear</button><label>    </label><button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Back</button>");
					
				});
				var data = [
							{ text: "Client", value: "CLN" },
							{ text: "Counterparty", value: "CPT" }
						];
				$("#Acc_client_type").kendoDropDownList({
					dataTextField: "text",
					dataValueField: "value",
					dataSource: data,
					index: 0
				});
				var entitydata = [
					{ text: tmpEntityOfGuarantee, value: tmpEntityOfGuarantee },
					{ text: "BOCI", value: "BOCI" },
					{ text: "BOCIL", value: "BOCIL" },
					{ text: "ALL", value: "ALL" }
				];
				$("#Entity_Of_Guarantee").kendoDropDownList({
					dataTextField: "text",
					dataValueField: "value",
					dataSource: entitydata,
					index: 0
				});
				
				$("#clearBtn").kendoButton({
         			click:function(){
         				$("#countryRisk").data("kendoDropDownList").value("");
         				$("#cc_category").data("kendoDropDownList").value("");
         			}
         		});
				
				/* var validator = $("#account-update-form").kendoValidator().data("kendoValidator");
				
				if (validator.validate()){
					
				}  */
				$("#saveBtn").kendoButton({
        			click: function(){
    					var updateCriteria = {
    						acctClientType:$("#Acc_client_type").val(),
    						guaranteeEntity:$("#Entity_Of_Guarantee").val(),
    						externalKey1:$("#checkEXTKey1 input").val(),
    						externalKey2:$("#checkEXTKey2 input").val(),
    						externalKey3:$("#checkEXTKey3 input").val(),
    						externalKey4:$("#checkEXTKey4 input").val(),
    						externalKey5:$("#checkEXTKey5 input").val(),
    						externalKey6:$("#checkEXTKey6 input").val(),
    						externalKey7:$("#checkEXTKey7 input").val(),
    						externalKey8:$("#checkEXTKey8 input").val(),
    						externalKey9:$("#checkEXTKey9 input").val(),
    						externalKey10:$("#checkEXTKey10 input").val(),
    						userId: window.sessionStorage.getItem("username").replace("\\", "\\"),
    						bizUnit: array[1],
    						dataSourceAppId: array[3],
    						bookEntity: array[2],
    						crId: array[0]
	   					}
	    				var dataDatasource = dataSource.at(0);
	    				dataDatasource.set("acctClientType",updateCriteria.acctClientType);
	    				dataDatasource.set("guaranteeEntity",updateCriteria.guaranteeEntity);
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
	    				dataDatasource.set("userId",updateCriteria.userId);
	    				dataDatasource.set("crId",updateCriteria.crId);
	    				dataDatasource.set("bizUnit",updateCriteria.bizUnit);
	    				dataDatasource.set("dataSourceAppId",updateCriteria.dataSourceAppId);
	    				dataDatasource.set("bookEntity",updateCriteria.bookEntity);
	    				dataDatasource.set("actionPage","save");
	    				dataSource.sync();
	    				
        			}
        		});
          		
          		$("#submitBtn").kendoButton({
        			click: function(){

	    				var updateCriteria = {
    						acctClientType:$("#Acc_client_type").val(),
    						guaranteeEntity:$("#Entity_Of_Guarantee").val(),
    						externalKey1:$("#checkEXTKey1 input").val(),
    						externalKey2:$("#checkEXTKey2 input").val(),
    						externalKey3:$("#checkEXTKey3 input").val(),
    						externalKey4:$("#checkEXTKey4 input").val(),
    						externalKey5:$("#checkEXTKey5 input").val(),
    						externalKey6:$("#checkEXTKey6 input").val(),
    						externalKey7:$("#checkEXTKey7 input").val(),
    						externalKey8:$("#checkEXTKey8 input").val(),
    						externalKey9:$("#checkEXTKey9 input").val(),
    						externalKey10:$("#checkEXTKey10 input").val(),
    						userId: window.sessionStorage.getItem("username").replace("\\", "\\"),
    						bizUnit: array[1],
    						dataSourceAppId: array[3],
    						bookEntity: array[2],
    						crId: array[0]
	   					}
	    				var dataDatasource = dataSource.at(0);
	    				dataDatasource.set("acctClientType",updateCriteria.acctClientType);
	    				dataDatasource.set("guaranteeEntity",updateCriteria.guaranteeEntity);
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
	    				dataDatasource.set("userId",updateCriteria.userId);
	    				dataDatasource.set("crId",updateCriteria.crId);
	    				dataDatasource.set("bizUnit",updateCriteria.bizUnit);
	    				dataDatasource.set("dataSourceAppId",updateCriteria.dataSourceAppId);
	    				dataDatasource.set("bookEntity",updateCriteria.bookEntity);
	    				dataDatasource.set("actionPage","submit");
	    				dataSource.sync();
	    				
	    			}
        		});

			});		
			/*Calling the method for hiding the ajaxloader image*/
			closeModal();
		});			
		/* Open spinner while getting the data from back-end*/
		function openModal() {
			$("#modal, #modal1, #modal2, #modal3").show();
		}
		/* Close spinner after getting the data from back-end*/
		function closeModal() {
			$("#modal, #modal1, #modal2, #modal3").hide();	    
		}
		
		/* Action - Discard button */
		function toDiscard(uid){
			window.location = "/ermsweb/discardAccounts?crId="+uid+"&userId="+window.sessionStorage.getItem("username");
		}
		
		function toClear(){
			$("input:text, select").val("");
			var entityGuaranterDDL = $("#Entity_Of_Guarantee").data("kendoDropDownList");
			var accClientTypeDDL = $("#Acc_client_type").data("kendoDropDownList");
			entityGuaranterDDL.value("");
			accClientTypeDDL.value("");
		}
		
		function validateResponse(data){
			return (data != null) ? data : "";
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
			window.location = "/ermsweb/accountDetailMaintenance";
		}
	</script>
<body>
	<div class="boci-wrapper">
		<%@include file="header1.jsp"%>
		<div class="page-title">Account RMD Change Request Maintenance - Update</div>
<!-- 		<input type="hidden" id="pagetitle" name="pagetitle"
			value="Account RMD Change Request Maintenance - Update "> -->
		<div id="account-details-section">
			<form id="account-update-form">
			<table id="account-details-section-table" cellspacing="1"
				cellpadding="6">
				<tr>

					<td align="right" colspan="2"
						style="background-color: #fff; font-size: 16px;">
						<div id="buttonType"></div>
					</td>
				</tr>
				<tr>
					<td colspan="4"
						style="background-color: #393052; color: white; width: 500; font-size: 13px">Account
						RMD Detail section</td>
				</tr>
				<tbody>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">CCD
							ID.</td>
						<td><div id="ccd_id_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">CMD
							Client ID.</td>
						<td><div id="cmd_client_id_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Client/Counterparty
							Name.</td>
						<td><div id="client_counterparty_name_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Account
							No..</td>
						<td><div id="Acc_No_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Account
							- Name.</td>
						<td><div id="Acc_Name_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Account-Name
							(Chi).</td>
						<td><div id="Acc_Name_Chi_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Account-Client
							Type.</td>
						<td><div id="Acc_Client_Type_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Acc -
							is Joint (Y/N).</td>
						<td><div id="Acc_is_Joint_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Acc -
							Acc Type.</td>
						<td><div id="Acc_Acc_Type_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Acc -
							Open Date.</td>
						<td><div id="Acc_Open_Date_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Acc -
							Status.</td>
						<td><div id="Acc_Status_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Acc -
							Entity.</td>
						<td><div id="Acc_Entity_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Acc -
							Biz Unit.</td>
						<td><div id="Acc_Biz_Unit_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Acc -
							Sale Code.</td>
						<td><div id="Acc_Sale_Code_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Acc -
							Sale Name.</td>
						<td><div id="Acc_Sale_Name_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Acc -
							Dept Code.</td>
						<td><div id="Acc_Dept_Code_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Acc -
							Source System.</td>
						<td><div id="Acc_Source_System_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Entity
							of Guarantee In Favor.</td>
						<td><div id="Entity_Of_Guarantee_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Country
							of incorporation of ultimate parent.</td>
						<td><div id="Country_Of_Parent_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Ultimate
							Parent Name.</td>
						<td><div id="Ultimate_Parent_Name_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Revenue
							generated to BOCIS (Nova) - Turnover MTD.</td>
						<td><div id="Revenue_Turnover_MTD_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Revenue
							generated to BOCIS (Nova) - Turnover YTD.</td>
						<td><div id="Revenue_Turnover_YTD_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Revenue
							generated to BOCIS (Nova) - Net Commission MTD.</td>
						<td><div id="Revenue_Net_MTD_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Revenue
							generated to BOCIS (Nova) - Net Commission YTD.</td>
						<td><div id="Revenue_Net_YTD_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Revenue
							generated to BOCIS (Nova) - Gross Commission MTD.</td>
						<td><div id="Revenue_Gross_MTD_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Revenue
							generated to BOCIS (Nova) - Gross Commission YTD.</td>
						<td><div id="Revenue_Gross_YTD_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Revenue
							generated to BOCIS (Nova) - Margin Interest MTD.</td>
						<td><div id="Revenue_Margin_Interest_MTD_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Revenue
							generated to BOCIS (Nova) - Margin Interest YTD.</td>
						<td><div id="Revenue_Margin_Interest_YTD_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">Revenue
							generated to BOCIS (Nova) - IPO Interest YTD.</td>
						<td><div id="Revenue_IPO_Interest_YTD_label">
								<label></label>
							</div></td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #1</td>
						<td>
							<div id="checkEXTKey1">
								<input type="text" />
							</div>
						</td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #2</td>
						<td>
							<div id="checkEXTKey2">
								<input type="text" />
							</div>
						</td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #3</td>
						<td>
							<div id="checkEXTKey3">
								<input type="text" />
							</div>
						</td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #4</td>
						<td>
							<div id="checkEXTKey4">
								<input type="text" />
							</div>
						</td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #5</td>
						<td>
							<div id="checkEXTKey5">
								<input type="text" />
							</div>
						</td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #6</td>
						<td>
							<div id="checkEXTKey6">
								<input type="text" />
							</div>
						</td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #7</td>
						<td>
							<div id="checkEXTKey7">
								<input type="text" />
							</div>
						</td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #8</td>
						<td>
							<div id="checkEXTKey8">
								<input type="text" />
							</div>
						</td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #9</td>
						<td>
							<div id="checkEXTKey9">
								<input type="text" />
							</div>
						</td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #10</td>
						<td>
							<div id="checkEXTKey10">
								<input type="text" />
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			</form>
		</div>
		<div class="approval-section">
			<table id="approval-section-table">
				<tr>
					<td colspan="2"><div id="approval-section-header">Approval</div></td>
				</tr>
				<tr>
					<td width="195.5"><b>Action performed by Maker:</b></td>
					<td><label><b>Updated</b></label></td>
				</tr>
				<tr>
					<td width="195.5" style="vertical-align: top"><b>Remarks</b></td>
					<td width="250"><label id="remarks"></label></td>
				</tr>
			</table>
		</div>

		<div class="update-details-section">
			<table id="update-details-section-table">
				<tr>
					<td>Created By</td>
					<td><label id="created_by"></label></td>
					<td></td>
					<td></td>
					<td>Created At</td>
					<td><label id="created_at"></label></td>
				</tr>
				<tr>
					<td>Updated By</td>
					<td><label id="updated_by"></label></td>
					<td></td>
					<td></td>
					<td>Updated At</td>
					<td><label id="updated_at"></label></td>
				</tr>
				<tr>
					<td>Verified By</td>
					<td><label id="verified_by"></label></td>
					<td></td>
					<td></td>
					<td>Verified At</td>
					<td><label id="verified_at"></label></td>
				</tr>
				<tr>
					<td>Status</td>
					<td><label id="status_last"></label></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
			</table>
		</div>
	</div>
</body>
</html>