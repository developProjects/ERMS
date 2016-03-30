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
    	

    	var lmtTypeCode = getURLParameters('lmtTypeCode');
    	var crId = getURLParameters('crId');
		console.log(lmtTypeCode);
		limitviewurl = window.sessionStorage.getItem('serverPath')+"limitTypeHierCr/getLmtTypeHierCr?crId="+crId+"&userId="+window.sessionStorage.getItem("username")+"&funcId=";
		
    	openModal();	
    	
    	var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: limitviewurl,
					//url: window.sessionStorage.getItem('serverPath')+"limitTypeHier/getLmtTypeHier?lmtTypeCode="+lmtTypeCode;
					dataType: "json",
					type:"GET",
					
					xhrFields : {
						withCredentials : true
					}
					
					
				},
				update:{
					type:"POST",
					url: window.sessionStorage.getItem('serverPath')+"limitTypeHierCr/doActionLmtTypeHierCr",
					dataType: "json",
					xhrFields : {
						withCredentials : true
					},
					contentType:"application/json" ,
					complete: function (jqXHR, textStatus){
						var response = JSON.parse(jqXHR.responseText);
						if(response.action){
							if(response.action == "success"){
								window.location = "/ermsweb/limitTypeMaintenance";
							}
							else{
								$(".confirm-del").html(response.message);
							}
						}
						
					}
					
				},
				parameterMap: function(options, operation) {
				      if (operation != "read") {
				     	return kendo.stringify(options);//JSON.stringify(options);
						}
					}
				},
				error:function(e){
					if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
				},
			schema:{
				type: 'json',
				/* data: function(data) {              // the data which the data source will be bound to is in the values field
	                //console.log(data);
	                return data;
	            }, */
			 	model:{
					id:"crId"
				} 
			}
		});
    	
		dataSource.fetch(function(){
				var jsonObj = this.view();
				$.each(jsonObj, function(i){
						$("#limit_group_label").html("<label>"+validateResponse(jsonObj[i].lmtGroup)+"</label>");
						$("#client_counterparty_label").html("<label>"+validateResponse(checkClientCounterparty(jsonObj[i]))+"</label>");
						$("#limit_type_label").html("<label>"+validateResponse(jsonObj[i].lmtTypeDesc)+"</label>");
						$("#base_nature_label").html("<label>"+validateResponse(jsonObj[i].baseNature)+"</label>");
						$("#limit_code_label").html("<label>"+validateResponse(jsonObj[i].lmtTypeCode)+"</label>");						
						$("#category_label").html("<label>"+validateResponse(jsonObj[i].category)+"</label>");
						$("#aggregate_level_label").html("<label>"+validateResponse(jsonObj[i].aggLvl)+"</label>");
						$("#ccf_percentage_label").html("<label>"+validateResponse(jsonObj[i].ccfRatio)+"</label>");
						$("#parent_limittype_label").html("<label>"+validateResponse(jsonObj[i].parentLmtTypeDesc)+"</label>");
						$("#hierarchy_level_label").html("<label>"+validateResponse(jsonObj[i].lmtTypeHierLvlId)+"</label>");						
						$("#approval_matrix_label").html("<label>"+validateResponse(jsonObj[i].limitParameters)+"</label>");
						$("#created_by").html(validateResponse(jsonObj[i].createBy));
						$("#created_at").html(validateResponse(validDate(jsonObj[i].createDt)));
						$("#updated_by").html(validateResponse(jsonObj[i].lastUpdateBy));
						$("#updated_at").html(validateResponse(validDate(jsonObj[i].lastUpdateDt)));
						$("#verified_by").html(validateResponse(jsonObj[i].verifyBy));
						$("#verified_at").html(validateResponse(validDate(jsonObj[i].verifyDt)));
						$("#crAction").html(validateResponse(jsonObj[i].crAction));
						$("#verifierRemarks").val(jsonObj[i].verifierRemarks);
						$(".command-button-Section").html("<button id=\"verifyBtn\"  type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" >Verify</button><label>    </label><button id=\"returnBtn\"  type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Return</button><label>    </label><button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Back</button>");
				});
				
				/*Service Calls*/
				$("#verifyBtn").kendoButton({
	    			click: function(){
	    				var verify_remarks = $("#verifierRemarks").val();
	    				var dataDatasource = dataSource.at(0);
	    				dataDatasource.set("action","A");
	    				dataDatasource.set("crRemark",verify_remarks);
	    				dataDatasource.set("funcId","");
	    				dataDatasource.set("userId",window.sessionStorage.getItem('username'));
	    				dataSource.sync();
	    			}
	    		});
	      		
	      		$("#returnBtn").kendoButton({
	    			click: function(){    				
	    				var verify_remarks = $("#verifierRemarks").val();
	    				var dataDatasource = dataSource.at(0);    				
	    				dataDatasource.set("action","R");
	    				dataDatasource.set("crRemark",verify_remarks);
	    				dataDatasource.set("funcId","");
	    				dataDatasource.set("userId",window.sessionStorage.getItem('username'));
	    				dataSource.sync();
	    			}
	    		});
				closeModal();
		});
			
		
			// Data for lpbyBU and lpByEntity 
			var lpdatabybusinessUnit = new kendo.data.DataSource({
				transport: {
					read: {
						//url: "/ermsweb/resources/js/lpbybu.json",
						url:window.sessionStorage.getItem('serverPath')+"limitTypeHierCr/getLmtTypeHierBuMapCr?crId="+crId+"&userId="+window.sessionStorage.getItem("username")+"&funcId=",
						dataType: "json",
						
						xhrFields : {
							withCredentials : true
						}

					}
				},
				pageSize:2
				  
				});
			
			var lpdatabybusinessEntity = new kendo.data.DataSource({
				transport: {
					read: {
						//url: "/ermsweb/resources/js/lpbyentity.json",
						url:window.sessionStorage.getItem('serverPath')+"limitTypeHierCr/getLmtTypeHierEntityMapCr?crId="+crId+"&userId="+window.sessionStorage.getItem("username")+"&funcId=",
						dataType: "json",
						
						type:"GET",
						xhrFields : {
							withCredentials : true
						}

						
					}
				},
				pageSize:2
				});
			
			$("#limitparams_by_businessUnit").kendoGrid({
				dataSource: lpdatabybusinessUnit,
				scrollable:true,
				pageable: true,
				
				columns: [
	    					{ field: "id.bizUnit", title: "Business Unit" , width: 150},
							{ field: "lmtDeficitBufAmt01Hkd", title: "Limit Deficit Buffer Amount 1 (HKD)", width: 150},
							{ field: "lmtDeficitBufAmt02Hkd", title: "Limit Deficit Buffer Amount 2 (HKD)", width: 150},
							{ field: "lmtUtlzThresholdRatio01", template: '#= ccfConversion(lmtUtlzThresholdRatio01,"%",true)#',title: "Limit Utilization Threshold Percent 1", width: 150},
							{ field: "lmtUtlzThresholdRatio02", template: '#= ccfConversion(lmtUtlzThresholdRatio02,"%",true)#',title: "Limit Utilization Threshold Percent 2", width: 150},
							{ field: "odMarginCallBufAmt01Hkd", title: "Overdue or Margin Call Buffer Amount 1 (HKD)", width: 150},
							{ field: "odMarginCallBufAmt02Hkd", title: "Overdue or Margin Call Buffer Amount 2 (HKD)", width: 150},
							{ field: "marginCallThresholdRatio01",template: '#= ccfConversion(marginCallThresholdRatio01,"%",true)#', title: "Margin Call Threshold Percent 1", width: 150},
							{ field: "marginCallThresholdRatio02", template: '#= ccfConversion(marginCallThresholdRatio02,"%",true)#',title: "Margin Call Threshold Percent 2", width: 150},
							{ field: "collMitigationRatio",template: '#= ccfConversion(collMitigationRatio,"%",true)#', title: "Collateral Mitigation Percent", width: 150},
							{ field: "econCapRatio",template: '#= ccfConversion(econCapRatio,"%",true)#', title: "Economic Capital Percent", width: 150},
							{ field: "rw4LoanExpoGte5PcRatio",template: '#= ccfConversion(rw4LoanExpoGte5PcRatio,"%",true)#', title: "Risk Weight Percent for Loan Exposure >= 5% of BOCI Capital", width: 150},
							{ field: "rw4LoanExpoLt5PcRatio", template: '#= ccfConversion(rw4LoanExpoLt5PcRatio,"%",true)#',title: "Risk Weight Percent for Loan Exposure < 5% of BOCI Capital", width: 150},
							{ field: "boardApproveLmtAmtLmtCcy", title: "Board Aproved Limit Amount",template: '#= boardApproveLmtAmtCcy # #=boardApproveLmtAmtLmtCcy # ', width: 150}
	    				]
				
			
			});
  	
			$("#limitparams_by_businessEntity").kendoGrid({
				dataSource: lpdatabybusinessEntity,
				scrollable:true,
				columns: [
	    					{ field: "id.bookEntity", title: "Entity" , width: 60},
	    					{ field: "id.boardApprLmtCcy", title: "Board Aproved Limit Amount", template: '<span class="currency-span">#= id.boardApprLmtCcy #</span> #=boardApprLmtAmt # ', width: 60},
	    				]
			
			}); 
			closeModal();
			
	
	});	 
	function toBack(){
		//window.history.back();
		window.location = "/ermsweb/limitTypeMaintenance";
	}
	function validateResponse(data){
		return (data != null) ? data : "";
	}
	function ccfConversion(ccf,delim,view){
		
		if(view){
			return ccf*100 + delim;	
		}else{
			return ccf/100;
		}
		
	}
	function checkClientCounterparty(limitjson){
    	if(validateResponse(limitjson.applyToClnInd)=='Y'){
    		return "Client";
    	}else if(validateResponse(limitjson.applyToCptyInd)=='Y'){
    		return "Counterparty";
    	}else{
    		return "";
    	}
    		
    }
	function validDate(obj){
    	return kendo.toString( new Date(parseInt(obj)), "MM/dd/yyyy HH:MM:tt" )
    }
	 /* Open spinner while getting the data from back-end*/
	function openModal() {
		$("#modal, #modal1, #modal2, #modal3").show();
	}
	/* Close spinner after getting the data from back-end*/
	function closeModal() {
		$("#modal, #modal1, #modal2, #modal3").hide();
		$(".empty-height").hide();
	}
	
    </script>
    <body>
    	<div class="boci-limitType-wrapper">
    		<%-- <%@include file="header1.jsp"%> --%>
    		<div class="viewLimitTypeDetails-content-wrapper form">
    			<form id="create_newlimit_form">
					<input type="hidden" id="pagetitle" name="pagetitle" value="Maker Limit Type Change Request View">
					<div class="page-title">Maintenance - Limit Type Maintenance-Maker Limit Type Change Request View</div>	    		
	    			
	    			<div class="command-button-Section">
	    				
	    			</div>
	    			<div class="confirm-del"></div>
	    			<div class="clear"></div>
	    			<div class="limitType-details">
	   					<div class="limitType-details-header">Limit Type Details </div>
	   					<table>
	   						<tr>
	   							<td>Limit Group</td>
	   							<td>
	   								<div id="limit_group_label"><label>Presettlment Limit</label></div>
	   							</td>
	   							<td>
	   								Cient/Counterparty
	   							</td>
	   							<td>
	   								<div id="client_counterparty_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Limit Type</td>
	   							<td>
	   								<div id="limit_type_label"><label>Presettlment Limit</label></div>
	   							</td>
	   							<td>
	   								Base Nature
	   							</td>
	   							<td>
	   								<div id="base_nature_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Limit Code</td>
	   							<td>
	   								<div id="limit_code_label"><label>Presettlment Limit</label></div>
	   							</td>
	   							<td>
	   								Category
	   							</td>
	   							<td>
	   								<div id="category_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Aggregate Level</td>
	   							<td>
	   								<div id="aggregate_level_label"><label>Presettlment Limit</label></div>
	   							</td>
	   							<td>
	   								Credit Conversion Factors (CCF)
	   							</td>
	   							<td>
	   								<div id="ccf_percentage_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   					</table>
	    			</div>
	    			
	    			<div class="hierarchy-structure-details">
	   					<div class="hierarchy-details-header">Hierarchy Structure</div>
	   					<table>
	   						<tr>
	   							<td>Parent Limit Type</td>
	   							<td>
	   								<div id="parent_limittype_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Hierarchy Level</td>
	   							<td>
	   								<div id="hierarchy_level_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   						
	   					</table>
	    			</div>
	    			
	    			<div class="limit-parameter-details">
	   					<div class="limit-parameter-details-header">Limit Parameters</div>
	   					<table>
	   						<tr>
	   							<td>Aproval Matrix Option</td>
	   							<td>
	   								<div id="approval_matrix_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   					</table>
	    			</div>
    			</form>
    			<div class="display-limitparams-section">
    				
 					<table>
 						<tr>
 							<td><div class="list-header">Limit Parameters by Business Unit</div>
 						</tr>
	 					<tr>
							<td>
								<div id="limitparams_by_businessUnit">
																
								</div>
								
								<div id="modal1" class="model-loader" align="center" style="display:none;">
									<img id="loader" src="images/ajax-loader.gif" />
								</div>						
							</td>
						</tr>		
 						
 						
 					</table>
    			</div>
    			
    			<div class="display-limitparams-section">
    				
 					<table>
 						<tr>
 							<td><div class="list-header">Limit Parameters by Entity</div></td>
 						</tr>
 						<tr>
							<td>
								<div id="limitparams_by_businessEntity">
															
								</div>
								
								<div id="modal1" class="model-loader" align="center" style="display:none;">
									<img id="loader" src="images/ajax-loader.gif" />
								</div>						
							</td>
						</tr>		
 						
 					</table>
    			</div>
			<div class="approval-section margin-top">
				<div id="approval-section-header">Approval</div>
					<table id="approval-section-table">
						<tr>
							<td width="195.5" class="bold">Action performed by Maker:</td>
							<td><label class="bold">Create/Update/Delelte of Limit</label></td>
						</tr>
						<tr>
							<td width="195.5" style="vertical-align:top" class="bold">Remarks</td>
							
							<td style="background-color:#FCD5B4;">
								<textarea id="verifierRemarks" class="remarks-textarea"></textarea>
							</td>
						</tr>			
					</table>
			</div>
    		<div class="audit-details-section">
				<table>
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
					<td>Action</td>
					<td><label id="crAction"></label></td>
					<td></td>
					<td></td>
					<td></td>
				</tr>
			</table>
			</div>
    			
    		</div>
    	
    	
    	</div>

    </body>
    </html>
    