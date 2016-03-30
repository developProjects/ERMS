<html lang="en">

	<meta http-equiv="Content-Style-Type" content="text/css">
    <meta http-equiv="Content-Script-Type" content="text/javascript">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 
    <script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>
   
	
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

    <!-- Kendo UI combined JavaScript -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
    
	<style type="text/css">
	.margin-call-wrapper .details-wrapper table, th, td {
		border: 1px solid brown;
	}
	</style>
<script>
	$(document).ready(function(){
		
		$(".rectif_approv_expiry_date").kendoDatePicker();
		
		
		
		var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: "/ermsweb/resources/js/getRecordExpoMarginCall.json",
					//url: window.sessionStorage.getItem('serverPath')+"limitTypeHier/getLmtTypeHier?lmtTypeCode="+lmtTypeCode;
					dataType: "json",
					type:"GET"
					
				}
			},
			schema: {                               // describe the result format
	            data: function(data) {              // the data which the data source will be bound to is in the values field
	                //console.log(data);
	                return [data];
	            },
	            model:{
					id:""
				} 
	        }
		});
		
		dataSource.fetch(function(){
			var jsonObj = this.view();
			$.each(jsonObj, function(i){
				
				    $("#creditGroup").html(validateResponse(jsonObj[i].creditGroup));
				    $("#ccdId").html(validateResponse(jsonObj[i].ccdId));
				    $("#acctId").html(validateResponse(jsonObj[i].acctId));
				    $("#subAcctId").html(validateResponse(jsonObj[i].subAcctId));
				    $("#acctName").html(validateResponse(jsonObj[i].acctName));
				    $("#acctSalesmanCode").html(validateResponse(jsonObj[i].acctSalesmanCode));
				    $("#acctSalesmanName").html(validateResponse(jsonObj[i].acctSalesmanName));
				    $("#lmtTypeDesc").html(validateResponse(jsonObj[i].lmtTypeDesc));
				    $("#totalClientLeeDeficit").html(validateResponse(jsonObj[i].totalClientLeeDeficit));
				    $("#totalClientOverdueOrCallAmt").html(validateResponse(jsonObj[i].totalClientOverdueOrCallAmt));
				    $("#odMcStatus").html(validateResponse(jsonObj[i].odMcStatus));   
				    if(jsonObj[i].odMcIsGracePeriod == "Y"){
				    	$("#odMcIsGracePeriod").prop("checked",true);
				    }else{
				    	$("#odMcIsGracePeriod").prop("checked",false);
				    }
				    $("#odMcAssignApprover").html(validateResponse(jsonObj[i].odMcAssignApprover));
				    $("#odMcDaysInOdMarginCall").html(validateResponse(jsonObj[i].odMcDaysInOdMarginCall));
				    $("#odMcConsExposure").html(validateResponse(jsonObj[i].odMcConsExposure));
				    $("#odMcAvailCollValue").html(validateResponse(jsonObj[i].odMcAvailCollValue));
				    $("#odMcTdConsExposure").html(validateResponse(jsonObj[i].odMcTdConsExposure));
				    $("#odMcTdAvailCollValue").html(validateResponse(jsonObj[i].odMcTdAvailCollValue));
				    $("#odMcRelatedAcctId").html(validateResponse(jsonObj[i].odMcRelatedAcctId));
				    $("#odMcTdMrktValueUnderFac").html(validateResponse(jsonObj[i].odMcTdMrktValueUnderFac));
				    $("#odMcHhi").html(validateResponse(jsonObj[i].odMcHhi));
				    $("#odMcIm").html(validateResponse(jsonObj[i].odMcIm));
				    $("#odMcBizApprovalGrp").html(validateResponse(jsonObj[i].odMcBizApprovalGrp));
				    $("#odMcBizApprovalNames").html(validateResponse(jsonObj[i].odMcBizApprovalNames));
				    if(jsonObj[i].odMcIsBizApproval == "Y"){
				    	$("#odMcIsBizApproval").prop("checked",true);
				    }else{
				    	$("#odMcIsBizApproval").prop("checked",false);
				    }
				    //$("#odMcRectificationReason").data("kendoDropDownList").value(validateResponse(jsonObj[i].odMcRectificationReason));
				    $("#odMcMarginSurplusOrCallAmt").html(validateResponse(jsonObj[i].odMcMarginSurplusOrCallAmt));
				    $("#odMcMarginPercent").html(validateResponse(jsonObj[i].odMcMarginPercent));
				    $("#odMcTdMarginSurplusOrCallAmt").html(validateResponse(jsonObj[i].odMcTdMarginSurplusOrCallAmt));
				    $("#odMcTdMarginPercent").html(validateResponse(jsonObj[i].odMcTdMarginPercent));
				    $("#odMcNegativeBalHkd").html(validateResponse(jsonObj[i].odMcNegativeBalHkd));
				    $("#odMcMrktValueCoveragePercent").html(validateResponse(jsonObj[i].odMcMrktValueCoveragePercent));
				    $("#odMcNavOrOverloss").html(validateResponse(jsonObj[i].odMcNavOrOverloss));
				    $("#odMcEqtyImPercent").html(validateResponse(jsonObj[i].odMcEqtyImPercent));
				    $("#odMcRemarks").val(validateResponse(jsonObj[i].odMcRemarks));
				    //$("#odMcExpoMarginCallDoc").html(validateResponse(jsonObj[i].odMcExpoMarginCallDoc));
				    $("#leStatus").html(validateResponse(jsonObj[i].leStatus));
				    if(jsonObj[i].leIsGracePeriod == "Y"){
				    	$("#leIsGracePeriod").prop("checked",true);
				    }else{
				    	$("#leIsGracePeriod").prop("checked",false);
				    }
				    $("#leAssignApprover").html(validateResponse(jsonObj[i].leAssignApprover));
				    $("#leDaysInLmtDeficit").html(validateResponse(jsonObj[i].leDaysInLmtDeficit));
				    
				    $("#leSdConsLmtUtlz").html(validateResponse(jsonObj[i].leSdConsLmtUtlz));
				    $("#leTdConsLmtUtlz").html(validateResponse(jsonObj[i].leTdConsLmtUtlz));
				    $("#leApprovedLmtAmt").html(validateResponse(jsonObj[i].leApprovedLmtAmt));
				    $("#leLmtExpiryDt").html(validateResponse(jsonObj[i].leLmtExpiryDt));
				    $("#leBizApprovalGrp").html(validateResponse(jsonObj[i].leBizApprovalGrp));
				    $("#leBizApprovalNames").html(validateResponse(jsonObj[i].leBizApprovalNames));
				    if(jsonObj[i].leIsBizApproval == "Y"){
				    	$("#leIsBizApproval").prop("checked",true);
				    }else{
				    	$("#leIsBizApproval").prop("checked",false);
				    }
				    //$("#leRectificationReason").data("kendoDropDownList").value(validateResponse(jsonObj[i].leRectificationReason));
				    $("#leLmtSurplusDeficit").html(validateResponse(jsonObj[i].leLmtSurplusDeficit));
				    $("#leTdLmtSurplusDeficit").html(validateResponse(jsonObj[i].leTdLmtSurplusDeficit));
				    $("#leLmtUtlzPercent").html(validateResponse(jsonObj[i].leLmtUtlzPercent));
				    $("#leTdLmtUtlzPercent").html(validateResponse(jsonObj[i].leTdLmtUtlzPercent));
				    $("#leRemarks").val(validateResponse(jsonObj[i].leRemarks));
				    //$("#leExpoMarginCallDoc").html(validateResponse(jsonObj[i].leExpoMarginCallDoc));
				    
					
				
			});
			
			
		});
		
		$(".actionBtn").click(function(){
			var msg = $(this).text();
			$(this).closest("tr").prevAll("tr.msgRow").show().find(".actionMessage").html(msg);
			console.log($(this).parents("table").find("tr.msgRow").length);
		});
		
		$(".noaction").click(function(){
			$(this).closest(".msgRow").hide();
		});
		
		
		
	});
	
	function validateResponse(data){
		return (data != null) ? data : "";
	}
	
	
	</script>
	<body>
	<div class="margin-call-wrapper">
		<div class="details-wrapper">
			<div class="list-header">Rectification or Exceptional Approval</div>
			<table>
				<tr class="table-list-header">
					<td colspan="4" >
						<div>Account Details</div>
					</td>
				</tr>
				<tr>
					<td class="odd-td-format">Credit Group</td>
					<td ><div id="creditGroup"></div></td>
					<td class="odd-td-format">Sales Name</td>
					<td><div id="acctSalesmanName"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">Account No.</td>
					<td><div id="acctId"></div></td>
					<td class="odd-td-format">Sales Code</td>
					<td><div id="acctSalesmanCode"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">Sub Acc</td>
					<td><div id="subAcctId"></div></td>
					<td class="odd-td-format">Limit Type</td>
					<td><div id="lmtTypeDesc"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">Account Name</td>
					<td><div id="acctName"></div></td>
					<td class="odd-td-format">Facility ID</td>
					<td><div id="facId"></div></td>
				</tr>
				<tr class="table-list-header">
					<td colspan="4" >
						<div>Client Level Total</div>
					</td>
				</tr>
				<tr>
					<td class="odd-td-format">Total LEE deficit of Client</td>
					<td><div id="totalClientLeeDeficit"></div></td>
					<td class="odd-td-format">Total Overdue or Call Amount</td>
					<td><div id="totalClientOverdueOrCallAmt"></div></td>
				</tr>
				<tr class="table-list-header">
					<td colspan="4" >
						<div>Cash Overdue or Margin Call Section</div>
					</td>
				</tr>
				<tr class="msgRow">
					<td colspan="4">
						Are you Confirm <span class="actionMessage bold" ></span> Margin Call Section <a href="#" class="anchor">[Yes]</a>|<a class="anchor noaction" href="#">[No]</a> 
					</td>
				</tr>
				<tr>
					<td class="odd-td-format background-color">Overdue or Margin Call workflow Status</td>
					<td><div id="odMcStatus" class="background-color"></div></td>
					<td rowspan="2" colspan="2">
						<div>
							<div class="selection-panel">
								<div><input type="radio" name="" id="graceperiod" disabled/><label>Grace Period</label></div>
								<div><input type="radio" name="" id="table3" disabled/><label>Table 3</label></div>
								<div><input type="radio" name="" id="table4" disabled/><label>Table 4</label></div>
								<div><input type="radio" name="" id="notApplicable" disabled/><label>N/A</label></div>
							</div>
							<div class="marigncall-button-panel margin-call-margin-top">
								<button id="seekapproveBtn" class="k-button actionBtn" type="button">Seek Approval</button>
								<button id="forcedLiqudiatonBtn" class="k-button actionBtn" type="button">Forced Liqudiaton</button>
							</div>
							<div class="clear"></div>
						</div>
					</td>					
				</tr>
				
				<tr>
					<td class="bold" id="odMcAssignApprover">Assign another Approver</td>
					<td>
						<div class="selection-panel">
							<button id="notifyBtn" class="k-button" type="button">Notify</button>
						</div>
						<div class="marigncall-button-panel">
							
						</div>
						<div class="clear"></div>
					</td>					
				</tr>
				<tr>
					<td class="odd-td-format">Days in Margin Call or Overdue</td>
					<td><div id="odMcDaysInOdMarginCall"></div></td>
					<td class="odd-td-format">Expiry Date</td>
					<td><input class="rectif_approv_expiry_date"></input></td>
				</tr>
				<tr>
					<td class="odd-td-format">Consolidated Exposure</td>
					<td ><div id="odMcConsExposure"></div></td>
					<td class="odd-td-format">Overdue or Margin Call Amount</td>
					<td><div id="odMcMarginSurplusOrCallAmt"></div></td>
				</tr>
				
				<tr>
					<td class="odd-td-format">Available Collateral Value</td>
					<td ><div id="odMcAvailCollValue"></div></td>
					<td class="odd-td-format">Margin %</td>
					<td><div id="odMcMarginPercent"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">TD Consolidated Exposure</td>
					<td ><div id="odMcTdConsExposure"></div></td>
					<td class="odd-td-format">TD Margin Call Amount</td>
					<td><div id="odMcTdMarginSurplusOrCallAmt"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">TD Available Collateral Value</td>
					<td ><div id="odMcTdAvailCollValue"></div></td>
					<td class="odd-td-format">TD Margin %</td>
					<td><div id="odMcTdMarginPercent"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">Related PB Account</td>
					<td ><div id="odMcRelatedAcctId"></div></td>
					<td class="odd-td-format">Negative Balance (PB)</td>
					<td><div id="odMcNegativeBalHkd"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">TD Market Value under the Facility</td>
					<td ><div id="odMcTdMrktValueUnderFac"></div></td>
					<td class="odd-td-format">Market Value Coverage %</td>
					<td><div id="odMcMrktValueCoveragePercent"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">HHI</td>
					<td ><div id="odMcHhi"></div></td>
					<td class="odd-td-format">NAV or Overloss</td>
					<td><div id="odMcNavOrOverloss"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">Initial Margin </td>
					<td ><div id="odMcIm"></div></td>
					<td class="odd-td-format">Equity / IM %</td>
					<td><div id="odMcEqtyImPercent"></div></td>
				</tr>
				<tr>
					<td class="dimmed">Business Approval Authority </td>
					<td ><div id="odMcBizApprovalGrp"></div></td>
					<td class="dimmed">Business Approvers</td>
					<td><div id="odMcBizApprovalNames"></div></td>
				</tr>
				<tr>
					<td class="dimmed">Business Approval</td>
					<td colspan="3">
						<input type="checkbox" name="approval" class="dimmed" id="odMcIsBizApproval"/><label for="approval_check" >Approved</label>
						
					</td>
				</tr>
				
				<tr>
					<td class="odd-td-format">Attachments <button id="uploadBtn" class="k-button" type="button">Upload</button><div class="clear"></div>
					</td>
					
					<td rowspan="2" colspan="3">
						<span class="odd-td-format margin-remarks">Remarks</span>
						<textarea class="text-area-style" id="odMcRemarks"></textarea>
					</td>					
				</tr>
				
				<tr>
					<td>
						<div id="odMcExpoMarginCallDoc">
							<div><a href="#" class="anchor">check deposit slip</a></div>
							<div><a href="#" class="anchor">check deposit slip</a></div>
						</div>
					</td>
								
				</tr>
				<tr><td colspan="4">&nbsp;</td></tr>
				
				<tr class="table-list-header">
					<td colspan="4" >
						<div>Limit Deficit Section</div>
					</td>
				</tr>
				<tr class="msgRow">
					<td colspan="4">
						Are you Confirm <span class="actionMessage bold" ></span> Limit Deficit Section  <a href="#" class="anchor">[Yes]</a>|<a class="anchor noaction" href="#">[No]</a> 
					</td>
				</tr>
				<tr>
					<td class="odd-td-format background-color">Limit Deficit workflow status</td>
					<td><div id="leStatus" class="background-color" ></div></td>
					<td rowspan="2" colspan="2">
						<div>
							<div class="selection-panel">
								<div><input type="radio" name="" id="graceperiod" disabled/><label>Grace Period</label></div>
								<div><input type="radio" name="" id="table3" disabled/><label>Table 3</label></div>
								<div><input type="radio" name="" id="table4" disabled/><label>Table 4</label></div>
								<div><input type="radio" name="" id="notApplicable" disabled/><label>N/A</label></div>
							</div>
							<div class="marigncall-button-panel margin-call-margin-top">
								<button id="seekapproveBtn" class="k-button actionBtn" type="button">Seek Approval</button>
								<button id="forcedLiqudiatonBtn" class="k-button actionBtn" type="button">Forced Liqudiaton</button>
							</div>
							<div class="clear"></div>
						</div>
					</td>					
				</tr>
				
				<tr>
					<td class="bold" id="leAssignApprover">Assign another Approver</td>
					<td>
						<div class="selection-panel">
							<button id="notifyBtn" class="k-button" type="button">Notify</button>
						</div>
						<div class="marigncall-button-panel" id="leAssignApprover">
							
						</div>
						<div class="clear"></div>
					</td>					
				</tr>
				<tr>
					<td class="odd-td-format">Days in Limit Deficit</td>
					<td><div id="leDaysInLmtDeficit"></div></td>
					<td class="odd-td-format">Expiry Date</td>
					<td><input class="rectif_approv_expiry_date" id="leRectifyExpiryDt"></input></td>
				</tr>
				<tr>
					<td class="odd-td-format">Cons. Limit Utilization</td>
					<td ><div id="leSdConsLmtUtlz"></div></td>
					<td class="odd-td-format">SD Limit Deficit</td>
					<td><div id="leLmtSurplusDeficit"></div></td>
				</tr>
				
				<tr>
					<td class="odd-td-format">TD Cons. Limit Utilization</td>
					<td ><div id="leTdConsLmtUtlz"></div></td>
					<td class="odd-td-format">TD Limit Deficit</td>
					<td><div id="leTdLmtSurplusDeficit"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">Approved Limit Amount</td>
					<td ><div id="leApprovedLmtAmt"></div></td>
					<td class="odd-td-format">SD Limit Utilization %</td>
					<td><div id="leLmtUtlzPercent"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">Limit Expiry Date</td>
					<td ><div id="leLmtExpiryDt"></div></td>
					<td class="odd-td-format">TD Limit Utilization %</td>
					<td><div id="leTdLmtUtlzPercent"></div></td>
				</tr>
				
				<tr>
					<td class="odd-td-format">Business Approval Authority </td>
					<td ><div id="leBizApprovalGrp"></div></td>
					<td class="odd-td-format">Business Approvers</td>
					<td><div id="leBizApprovalNames"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">Business Approval</td>
					<td colspan="3">
						<input type="checkbox" name="approval" class="dimmed" id="leIsBizApproval"/><label for="approval_check">Approved</label>
						
					</td>
				</tr>
				
				<tr>
					<td class="odd-td-format">Attachments <button id="uploadBtn" class="k-button" type="button">Upload</button><div class="clear"></div>
					</td>
					
					<td rowspan="3" colspan="3">
						<span class="odd-td-format margin-remarks" >Remarks</span>
						<textarea class="text-area-style" id="leRemarks"></textarea>
					</td>					
				</tr>
				
				<tr>
					<td>
						<div id="leExpoMarginCallDoc">
							<div><a href="#" class="anchor" >check deposit slip</a></div>
							<div><a href="#" class="anchor" >check deposit slip</a></div>
						</div>
					</td>
					
								
				</tr>
			</table>
		</div>
	</div>	
	</body>
</html>	