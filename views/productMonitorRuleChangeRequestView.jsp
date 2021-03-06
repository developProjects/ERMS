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
    	var crId = getURLParameters('ruleId');
    	
    	var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: window.sessionStorage.getItem('serverPath')+"lmtMonitorRule/getRecord?userId='"+window.sessionStorage.getItem('username')+"'&crId="+crId+"&ruleName=",
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
				$.each(jsonObj, function(i){
					
					$("#mrule_name_label").html("<label>"+validateResponse(jsonObj[i].ruleName)+"</label>");
					$("#mrule_mode_label").html("<label>Batch</label>");
					$("#mrule_limitType_label").html("<label>"+validateResponse(jsonObj[i].lmtTypeDesc)+"</label>");
					
					$("#mrule_productType_label").html("<label>"+validateResponse(jsonObj[i].prodTypeList).toString()+"</label>");
					$("#mrule_entity_label").html("<label>"+validateResponse(jsonObj[i].ruleBookEntity)+"</label>");
					$("#mrule_limitCCY_label").html("<label>"+validateResponse(jsonObj[i].ruleLmtCcy)+"</label>");						
					$("#mrule_limitAmount_label").html("<label>"+validateResponse(jsonObj[i].ruleLmtAmt)+"</label>");
					$("#mrule_firstWarningPercent_label").html("<label>"+validateResponse(jsonObj[i].firstWarnRatio)+"</label>");
					$("#mrule_SecondWarningPercent_label").html("<label>"+validateResponse(jsonObj[i].secondWarnRatio)+"</label>");
					
					
					var acgData = validateResponse(jsonObj[i].partyType)+"<span style='margin-left:200px'>"+validateResponse(jsonObj[i].partyName)+"</span>";
					$("#mrule_acc_ccp_group_label").html("<label>"+acgData+"</label>");
					
					$("#verifierRemarks").html("<label>"+validateResponse(jsonObj[i].crRemark)+"</label>");
					
					$(".command-button-Section").html("<button id=\"updateBtn\"  type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" onclick=\"toEdit('"+jsonObj[i].crId+"')\">Update</button><label>    </label><button id=\"discardBtn\" onclick=\"toDelete('"+jsonObj[i].crId+"')\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Discard</button><label>    </label><button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Back</button>");
					
					$("#created_by").html(jsonObj[i].createBy);
					$("#created_at").html(validDate(jsonObj[i].createDt));
					$("#updated_by").html(jsonObj[i].lastUpdateBy);
					$("#updated_at").html(jsonObj[i].lastUpdateDt);
					$("#verified_by").html(jsonObj[i].verifyBy);
					$("#verified_at").html(jsonObj[i].verifyDt);
					$("#crAction").html(jsonObj[i].crAction);
				});
			});	
	});	 
    /* Action - Save button */
	
	function validateResponse(data){
		return (data != null) ? data : "";
	}
	
	function validDate(obj){
    	return kendo.toString( new Date(parseInt(obj)), "MM/dd/yyyy HH:MM:tt" )
    }
	
	function toEdit(eid){
		window.location = "/ermsweb/productMonitorRuleChangeRequestUpdate?ruleId="+eid;
	}
	function toDelete(did){
		window.location = "/ermsweb/productMonitorRuleDiscardChangeRequest?ruleId="+did;
	}
	function toBack(){
		//window.history.back();
		window.location = "/ermsweb/productLimitMonitorMaintenance";
	}
    </script>
    <body>
    	<div class="boci-limitType-wrapper">
    		<%@include file="header1.jsp"%>
    		<div class="viewLimitTypeDetails-content-wrapper form">
					<div class="page-title">Maintenance -Product Limit Monitor Rule Maintenance - Monitor Rule Change Request View</div>	    		
	    			<div class="command-button-Section">
	    				<button id="editBtn" class="k-button" type="button">Update</button>
	    				<button id="DeleteBtn" class="k-button" type="button">Delete</button>
	    				<button id="backBtn" class="k-button" type="button">Back</button>
	    			</div>
	    			<div class="clear"></div>
	    			<div class="monitor-rule-details">
	   					<div class="monitor-rule-details-header">Monitor Rule Details </div>
	   					<table>
	   						<tr>
	   							<td class="field-label">Monitor Rule Name</td>
	   							<td>
	   								<div id="mrule_name_label"><label>Monitor Rule Name</label></div>
	   							</td>
	   						</tr>
							<tr>
	   							<td>Mode</td>
	   							<td>
	   								<div id="mrule_mode_label"><label>Monitor Rule Name</label></div>
	   							</td>
	   						</tr>
	   						<tr>	
	   							<td>
	   								Limit Type
	   							</td>
	   							<td>
	   								<div id="mrule_limitType_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Product Type</td>
	   							<td>
	   								<div id="mrule_productType_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
							<tr>
	   							<td>&nbsp</td>
	   							<td>
	   								&nbsp
	   							</td>
	   						</tr>							
	   						<tr>
	   							<td>
	   								Entity
	   							</td>
	   							<td>
	   								<div id="mrule_entity_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Limit CCY</td>
	   							<td>
	   								<div id="mrule_limitCCY_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   						<tr>	
	   							<td>
	   								Limit Amount
	   							</td>
	   							<td>
	   								<div id="mrule_limitAmount_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>1<sup>st</sup>Warning %</td>
	   							<td>
	   								<div id="mrule_firstWarningPercent_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>2<sup>nd</sup>Warning %</td>
	   							<td>
	   								<div id="mrule_SecondWarningPercent_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>&nbsp</td>
	   							<td>
	   								&nbsp
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Account/Client/Counterparty/ Group</td>
	   							<td>
	   								<div id="mrule_acc_ccp_group_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>&nbsp</td>
	   							<td>
	   								&nbsp
	   							</td>
	   						</tr>
	   					</table>
	    			</div>
	    			<div class="approval-section margin-top">
	    				<div id="approval-section-header">Approval</div>
							<table id="approval-section-table">
								<tr>
									<td class="bold field-label">Action performed by Maker:</td>
									<td><label class="bold">Create/Update/Delelte of Monitor Rule</label></td>
								</tr>
								<tr>
									<td style="vertical-align:top" class="bold">Remarks</td>
									<td>
										<div style="background-color:#FCD5B4;min-height:80px;"><label id="verifierRemarks">1st Warning Level too High</label></div>
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
    