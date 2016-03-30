<!DOCTYPE html>
<html lang="en">
	<meta http-equiv="Content-Style-Type" content="text/css">
    <meta http-equiv="Content-Script-Type" content="text/javascript">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 
    <script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>
    
    <!-- General layout Style -->
    <link href="/ermsweb/resources/css/layout.css" rel="stylesheet" type="text/css">

    <!-- Kendo UI API -->
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.common.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.rtl.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.default.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.dataviz.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.dataviz.default.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.mobile.all.min.css">

    <!-- jQuery JavaScript -->
    <script src="/ermsweb/resources/js/jquery.min.js"></script>
	<script src="/ermsweb/resources/js/jszip.min.js"></script>
    <!-- Kendo UI combined JavaScript -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
	<style>
		.k-textbox{width:150px;}
		.filter-operators .k-textbox{width:100px;}
		.select-textbox{width:150px;}
		.filter-operators .select-textbox{width:70px;}
		
		.rightAlign{text-align:right;}		
		.k-grouping-row, .k-group-cell{display:none;}
		.k-group-footer td{background-color:#84e5de;}
		.k-footer-template td{background-color:#cbf0b7;}
	</style>
 	<script type="text/javascript">
				
 	 $(document).ready(function () {
					//alert(true);

					var limitOperatorData = [
						                			{ text: "=", value: "=" },
						                			{ text: ">=", value: ">=" },
						                			{ text: "<=", value: "<=" },
						                			{ text: ">", value: ">" },
						                			{ text: "<", value: "<" }
						                		];
						                  				
						                		$("#dropValue").kendoDropDownList({
						                			dataTextField: "text",
						                			dataValueField: "value",
						                			dataSource: limitOperatorData,
						                			index: 0
						                		});	
                		var limitOperatorData1 = [
						                			{ text: "=", value: "=" },
						                			{ text: ">=", value: ">=" },
						                			{ text: "<=", value: "<=" },
						                			{ text: ">", value: ">" },
						                			{ text: "<", value: "<" }
						                		];
						                  				
						                		$("#dropValue1").kendoDropDownList({
						                			dataTextField: "text",
						                			dataValueField: "value",
						                			dataSource: limitOperatorData1,
						                			index: 0
						                		});	
                		var limitOperatorData2 = [
						                			{ text: "=", value: "=" },
						                			{ text: ">=", value: ">=" },
						                			{ text: "<=", value: "<=" },
						                			{ text: ">", value: ">" },
						                			{ text: "<", value: "<" }
						                		];
						                  				
						                		$("#dropValue2").kendoDropDownList({
						                			dataTextField: "text",
						                			dataValueField: "value",
						                			dataSource: limitOperatorData2,
						                			index: 0
						                		});	
                		
						$("#limitThershold").css("display", "block");
						//var getLargeExpoMonByGrpURL = "/ermsweb/resources/js/getErmsLargeExpoMonByGrp.json?userId="+window.sessionStorage.getItem('username');
					//grid layer for second call
						$(document).on('click', '#searchBy', function(){
								//$('#limit').html('');
								$('#limitData').show();
								$('.limitHeading').hide();
								$('#limitHeader').show();
								$('#limitThershold').hide();
								$('#limit').html('');
						});
						$(document).on('click', '#submitBtn', function(){
							dataGrids();
						});
						$("#resetBtn").kendoButton({
							click : function(){
								$('input[type=text]').val('');
							}
						});
						$("#exportBtn").kendoButton({
	          				click: function(){
	          					
	          					var Grid = $("#lrglist1").data("kendoGrid");
	          					
	          					if(Grid){
	          						Grid.saveAsExcel();
	          					}
	          				}
	          			}); 				
			
					});
					
		//Displaying Data in the Grids
	function dataGrids(){		
	
		var dataParams = {
				userId : window.sessionStorage.getItem('username'),
				rmdGroupDesc : $('#groupName').val(),
				ccdId : $('#ccdId').val(),
				cmdClnId : $('#cmdId').val(),
				acctId : $('#accountNo').val(),
				subAcctId : $('#accontName').val(),
				tdFeFromT24Op : $('#dropValue').val(),
				tdFeFromT24 : 	 $('#FEform').val(),		
				tdSumOfFeOp	: $('#dropValue1').val(),
				tdSumOfFe	:  $('#SumFE').val(),	
				tdCapBasePercentOp : $('#dropValue2').val(),
				tdCapBasePercent :  $('#capBase').val(),
				funcId : "",
				skip : 0,
				pageSize: 5
		}		
		var getLargeExpoMonURL = window.sessionStorage.getItem('serverPath')+"largeExpo/getErmsLargeExpoMon";
		//var getLargeExpoMonURL = "/ermsweb/resources/js/getErmsLargeExpoMon.json";	
		var activeDataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: getLargeExpoMonURL,
					dataType: "json",
					data : dataParams,
					xhrFields: {
                    	withCredentials: true
                   	}
			
				}
			},
			schema: {
				model: {
					fields: {
						rmdGroupId: { type: "string"},
						feFromFiniq: { type: "number"},
						tdFeFromT24: { type: "number"},
						sdFeFromT24: { type: "number"},
						tdSumOfFe: { type: "number"},
						sdSumOfFe: { type: "number"},
						tdCapBasePercent: { type: "number"},
						sdCapBasePercent: { type: "number"},
						matLmtForLargeExpo: { type: "number"},
						matLmtForClusterExpo: { type: "number"},
						hkmaLmtForLargeExpo: { type: "number"},
					  	hkmaLmtForClusterExpo: { type: "number"}
					}
				}                
			},
			pageSize: 5,
			error:function(e){
				if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}													
			},
			allowCopy: true,
			group: {
				field: "rmdGroupId", aggregates: [
					{ field: "feFromFiniq", aggregate: "sum"},
					{ field: "tdFeFromT24", aggregate: "sum"},
					{ field: "sdFeFromT24", aggregate: "sum"},
					{ field: "tdSumOfFe", aggregate: "sum"},
					{ field: "sdSumOfFe", aggregate: "sum"},
					{ field: "tdCapBasePercent", aggregate: "sum"},
					{ field: "sdCapBasePercent", aggregate: "sum"},
					{ field: "matLmtForLargeExpo", aggregate: "sum"},
					{ field: "matLmtForClusterExpo", aggregate: "sum"},
					{ field: "hkmaLmtForLargeExpo", aggregate: "sum"},
					{ field: "hkmaLmtForClusterExpo", aggregate: "sum"}
				]
			},
			aggregate: [ 
				{ field: "feFromFiniq", aggregate: "sum"},
				{ field: "tdFeFromT24", aggregate: "sum"},
				{ field: "sdFeFromT24", aggregate: "sum"},
				{ field: "tdSumOfFe", aggregate: "sum"},
				{ field: "sdSumOfFe", aggregate: "sum"},
				{ field: "tdCapBasePercent", aggregate: "sum"},
				{ field: "sdCapBasePercent", aggregate: "sum"},
				{ field: "matLmtForLargeExpo", aggregate: "sum"},
				{ field: "matLmtForClusterExpo", aggregate: "sum"},
				{ field: "hkmaLmtForLargeExpo", aggregate: "sum"},
				{ field: "hkmaLmtForClusterExpo", aggregate: "sum"}
			]
		});
		$("#lrglist1").kendoGrid({
			excel: {
				 allPages: true,
				 fileName: "Large Exp Violations"
			},
			dataSource: activeDataSource,
			sortable:false,
			scrollable:false,
			pageable: true,	
			dataBound: function(e){
				console.log(e);
				//flag = 
			},
			columns:[
						{ field: "rmdGroupId", title: "Group ID", width: 120},
						{ field:"rmdGroupDesc", title: "Group Name", width: 120},
						{ field: "protfolioCode", title: "Protfolio Code", width: 120},
						{ field: "protfolioName", title: "Protfolio Name", width: 120},
						{ field: "cmdClnId", title: "CMD Client Id", width: 120},
						{ field: "acctNumber", title: "Account No", width: 120},
						{ field: "acctName", title: "Account Name", width: 120, groupFooterTemplate: "<div class='rightAlign'>Total: </div>", footerTemplate: "<div class='rightAlign'>Grand Total : </div>"},
						{ field: "feFromFiniq", title: "FE from FINIQ",  aggregates: "sum", groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
						{ field: "tdFeFromT24", title: "FE from T24 (TD)", aggregates: "sum", groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
						{ field: "sdFeFromT24", title: "FE from T24 (SD)", aggregates: "sum", groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
						{ field: "tdSumOfFe", title: "sum of FE(TD)", aggregates: "sum", groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
						{ field: "sdSumOfFe", title: "Sum of FE(SD)", aggregates: "sum", groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
						{ field: "tdCapBasePercent", title: "% of Capital Base(TD)", aggregates: "sum", groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
						{ field: "sdCapBasePercent", title: "% of Capital Base(SD)", aggregates: "sum", groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
						{ field: "matLmtForLargeExpo", title: "Exceeding MAT Limit(TD)"},
						{ field: "matLmtForClusterExpo", title: "Exceeding MAT Limit(SD)"},
						{ field: "hkmaLmtForLargeExpo", title: "Exceeding HKMA Limit(TD)"},
						{ field: "hkmaLmtForClusterExpo", title: "Exceeding HKMA Limit(SD)"}
			]
		});
			closeModal();
		}

		function boleanCheck(x){
			console.log(x);
			/* if(x >= y){
				return "Y";
			}else{
				return "N";
			} */
		}
		function openModal() {
		     $("#modal, #modal1").show();
		}

		function closeModal() {
		    $("#modal, #modal1").hide();	    
		}
					
					
		
		function expandCriteria(){
			var filterBody = document.getElementById("filterBody").style.display;
			if(filterBody == "block"){
				document.getElementById("filterBody").style.display = "none";
				document.getElementById("filterTable").innerHTML = "(+) Filter Criteria";
			}else{
				document.getElementById("filterBody").style.display = "block";
				document.getElementById("filterTable").innerHTML= "(-) Filter Criteria";
			}
		} 
		
	
	</script>
	</head>
	
			<!-- <div width="1000"> -->
				<!-- <script type="text/javascript" src="/ermsweb/resources/js/header.js"></script> -->
				<%-- <%@include file="header.jsp"%> --%> 
				<br>
				<div id="limitHeader" style="background-color:#B54D4D; color:#fff;margin-bottom: 30px; padding:4px 0px 4px 0px; display:none;">Limit/Exposure Monitoring Alert - Large Exposure Violation</div>
				
				
<!-- Large Exposure Conditinal search criteria starts-->
			<div id="limitData">
			<div style="background-color:pink; width:1000" class="pageTitle">Limit/Exposure Monitoring Alert - Large Exposure </div>
			<table id="listTable" width="1000" style="background-color:#DBE5F1;" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="6" style="background-color:#8DB4E3; width:100%;">
					<b><div id="filterTable" onclick="expandCriteria()">(-) Filter Criteria</div></b></td>
				</tr>
				<tr>
					<td><br/></td>
				</tr>
				<tbody id="filterBody">
					<tr width="100%">
						<td>Group Name : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="groupName" type="text" class="k-textbox"/></td>									
						
						<td>CMD Client ID : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="cmdId" type="text" class="k-textbox"/> &nbsp;&nbsp;&nbsp;</td>
						
						<td>CCD Client ID : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="ccdId" type="text" class="k-textbox"/></td>
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td>Account No : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="accountNo" type="text" class="k-textbox"/></td>
						<td>Account Name : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="accontName" type="text" class="k-textbox"/></td>					
					
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td>FE Form T24(TD) : &nbsp;&nbsp;&nbsp;</td>
						<td>
						<select id="dropValue" style="width:40px;">
							
						</select>
						<input id="FEform" type="text" class="k-textbox"/></td>
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td>Sum of FE(TD) : &nbsp;&nbsp;&nbsp;</td>
						<td>
						<select id="dropValue1" style="width:40px;">
							
						</select>
						<input id="SumFE" type="text" class="k-textbox"/></td>
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td>% Capital Base(TD) : &nbsp;&nbsp;&nbsp;</td>
						<td>
						<select id="dropValue2" style="width:40px;">
						</select>
						<input id="capBase" type="text" class="k-textbox"/></td>
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="6" align="right">
							<button id="submitBtn" class="k-button" type="button">Search</button>
							<button id="resetBtn" type="button" class="k-button">Reset</button>
							<button id="exportBtn" type="button" class="k-button">Export</button>
						</td>
					</tr>
				</tbody>
			</table>
			<br/><br/>
				<div id="dailyReport" style="display:none;">
				<span>Daily Financial Exposure Report ("FE") booked in BOCIL</span>
				<p style="border-bottom: 1px solid black;width: 50%;">Report as of <span style="margin:30%">: Report Date YYYYMMDD</span></p>
					<table style="width:50%;border-bottom:2px solid black">
						<tbody>
							
							<tr style="border-top: 3px solid black;">
								<td style="width:10%;">BOCIL Daily Capital Base</td>
								<td style="width: 30%; " class="dailyCapBase">: 1,424,122,121 (C1 For Calculation)
								</td>
							</tr>
								<tr>
								<td style="width:20%; ">BOCIL Monthly End Capital Base #F&T</td>
								<td style="width: 30%;" class="monthlyCapBase">: 1,424,122,121 (C2 For Reference only)
								</td>
							</tr>
							<tr>
								<td style="width:20%; ">MAT Limit for Large Exposure</td>
								<td style="width: 30%;" class="MATlrgExp">: 20%</td>
							</tr>
							<tr>
								<td style="width:20%; ">HKMA Limit for Large Exposure</td>
								<td style="width: 30%; " class="HKMAlrgExp">: 25%</td>
							</tr>
						</tbody>
					</table>
				</div>
				<br/><br/>
			<div id="lrglist3"></div>
			<div id="lrglist4"></div>
			<div id="lrglist1"></div>
			<div id="lrglist2"></div>
		</div> 
				<!--  ends-->
				<br/><br/>
				<div id="limit"></div>
		
</html>
