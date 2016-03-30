<!DOCTYPE html>

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
			
				var paraAcctId = getURLParameters("acctId");	
				
				var dataSource = new kendo.data.DataSource({
					transport: {
						read: {
							url: window.sessionStorage.getItem('serverPath')+"acct/getRecord?crId="+getURLParameters("crId")+"&userId="+window.sessionStorage.getItem("username")+"&bizUnit="+getURLParameters("bizUnit")+"&bookEntity="+getURLParameters("bookEntity")+"&dataSourceAppId="+getURLParameters("dataSourceAppId"),
							dataType: "json",
							
		    			    xhrFields: {
					    		withCredentials: true
					    	}
						}	
					},
					error:function(e){
						if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
					},
					schema: { 
			            model:{
			            	id: "acctId",
			            	fields:{
			            		acctId: {type: "string"}
			            	}
			            }
			        }	
				});
					
				
				dataSource.fetch(function(){
					var jsonObj = this.view();
					$.each(jsonObj, function(i){
							$("#ccd_id_label").html("<label>"+validateResponse(jsonObj[i].ccdId)+"</label>");
							$("#cmd_client_id_label").html("<label>"+validateResponse(jsonObj[i].cmdCustId)+"</label>");
							$("#client_counterparty_name_label").html("<label>"+validateResponse(jsonObj[i].legalPartyName)+"</label>");
							$("#Acc_No_label").html("<label>"+validateResponse(jsonObj[i].acctId)+"</label>");
							$("#Acc_Name_label").html("<label>"+validateResponse(jsonObj[i].acctEngName)+"</label>");
							$("#Acc_Name_Chi_label").html("<label>"+validateResponse(jsonObj[i].acctChiName)+"</label>");
							$("#Acc_Client_Type_label").html("<label>"+validateResponse(jsonObj[i].acctClientType)+"</label>");
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
							$("#Entity_Of_Guarantee_label").html("<label>"+validateResponse(jsonObj[i].guaranteeEntity)+"</label>");	
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
							$("#created_by").html(validateResponse(jsonObj[i].createBy));
							$("#created_at").html(validateResponse(toDateFormat(jsonObj[i].createDt)));
							$("#updated_by").html(validateResponse(jsonObj[i].lastUpdateBy));
							$("#updated_at").html(validateResponse(toDateFormat(jsonObj[i].lastUpdateDt)));
							$("#verified_by").html(validateResponse(jsonObj[i].verifyBy));
							$("#verified_at").html(validateResponse(toDateFormat(jsonObj[i].verifyDt)));
							$("#status_last").html(validateResponse(jsonObj[i].status));		
							$("#remarks").html(validateResponse(jsonObj[i].remarks));
							$("#buttonType").html("<label>    </label><button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" >Back</button>");
					});
				});
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
		
		/* Action - Update button */
		function toUpdate(uid){
			window.location = "/ermsweb/viewCrAccountsUpdate?ccdId="+uid;
		}
		
		/* Action - Update button */
		function toDiscard(uid){
			window.location = "/ermsweb/discardAccounts?ccdId="+uid;
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
	</script>
<body>
	<div class="boci-wrapper">
		<%@include file="header1.jsp"%>
		<div class="page-title">Account RMD Change Request Maintenance - View</div>
		<!-- <input type="hidden" id="pagetitle" name="pagetitle" value="Account RMD Change Request Maintenance - View "> -->
		<div id="account-details-section">
			<table id="account-details-section-table" cellpadding="6"
				cellspacing="1">
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
							<div id="checkEXTKey1" />
						</td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #2</td>
						<td>
							<div id="checkEXTKey2" />
						</td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #3</td>
						<td>
							<div id="checkEXTKey3" />
						</td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #4</td>
						<td>
							<div id="checkEXTKey4" />
						</td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #5</td>
						<td>
							<div id="checkEXTKey5" />
						</td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #6</td>
						<td>
							<div id="checkEXTKey6" />
						</td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #7</td>
						<td>
							<div id="checkEXTKey7" />
						</td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #8</td>
						<td>
							<div id="checkEXTKey8" />
						</td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #9</td>
						<td>
							<div id="checkEXTKey9" />
						</td>
					</tr>
					<tr>
						<td style="font-size: 13px; background-color: #B5A2C6">External
							Key ID #10</td>
						<td>
							<div id="checkEXTKey10" />
						</td>
					</tr>
				</tbody>
			</table>
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