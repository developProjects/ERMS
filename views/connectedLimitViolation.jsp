<html lang="en">	
	<head>
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
    
	<style>
		.k-pager-wrap,.k-grid-pager,.k-widget{
			width:100%;
		}
		.dailyReport1 table, .dailyReport1 th, .dailyReport1 td {
    		border-collapse: collapse;
		}
		
		.dailyReport1 table, .dailyReport1 th, .dailyReport1 td {
		    border: 1px solid black;
		}
		
	</style>
    <!-- jQuery JavaScript -->
    <script src="/ermsweb/resources/js/jquery.min.js"></script>

    <!-- Kendo UI combined JavaScript -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>

 	<script type="text/javascript">
				
 	 $(document).ready(function () {
					//alert(true);
					$("#bizUnit").kendoDropDownList();
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
						$("#resetBtn").kendoButton();
						$("#exportBtn").kendoButton();				
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
						                			dataSource: limitOperatorData,
						                			index: 0
						                		});	
					});
					
		//Displaying Data in the Grids
		function dataGrids(){
			$('#dailyReport').css('display', 'block');
			$('.dailyReport1').css('display', 'block');
			$(".empty-height").hide();
			openModal();
			
			var dataParams = {
					userId : window.sessionStorage.getItem('username'),
					porfolioCode : $('#pcode').val(),
					porfolioName : $('#pName').val(),
					connectedWith : $('#connWith').val(),
					tdSumFinqNT24UnsecExp : $('#finIQexp').val(),
					tdSumFinqNT24UnsecExpOp : $('#dropValue').val(),
					tdUnsecCbPercent : $('#capitalBase').val(),
					tdUnsecCbPercentOp : $('#dropValue1').val(),
					sectionId : "",
					rmdGroupDesc : "",
					acctId : "",
					subAcctId : "",
					skip : 0,
					pageSize: 5
			}	
			
			var getErmsConnExpoMonURL = window.sessionStorage.getItem('serverPath')+"connExpo/getErmsConnExpoMon";
			//var getErmsConnExpoMonURL = "/ermsweb/resources/js/getErmsConnExpoMon.json";
			var activeDataSource = new kendo.data.DataSource({
											transport: {
												read: {
													url: getErmsConnExpoMonURL,
													dataType: "json",
													
													data : dataParams,
													 xhrFields: {
															withCredentials: true
													},  
												}
											},
											pageSize: 3
										});
			
			$("#list").kendoGrid({
				excel: {
					 allPages: true
				},
				dataSource: activeDataSource,
				scrollable:true,
				pageable: true, 
				excelExport: function(e) {
					e.preventDefault();
					promises[0].resolve(e.workbook);
				},
				columns: [
						{ field:"tdIcpUnsecExceedInd", title: "Unsecured Exposue Excess Indicator(TD)", width: 120},
						{ field:"sdIcpUnsecExceedInd", title: "Unsecured Exposue Excess Indicator(SD)", width: 120},
						{ field: "severity", title: "S81 Group ID", width: 120},
						{ field: "protfolioCode", title: "Protfolio Code", width: 120},
						{ field: "protfolioName", title: "Protfolio Name", width: 120},
						{ field: "acctNumber", title: "Account No", width: 120},
						{ field: "acctName", title: "Account Name", width: 120},
						{ field: "thresholdHkmaLmtRatio", title: "HKMA Customer Type", width: 120},
						{ field: "sdIpcAgUnsecExpoCbPcent", title: "Is Public/Listed Company?", width: 120},
						{ field: "sdIcpAgUnsecHkmaLmtPcent", title: "Is HKMA Authorized A1", width: 120},
						{ field: "bocilDailyCapitalBase", title: "BOCI Staff Indicator", width: 120},
						{ field: "tdCpAgSecExpo", title: "Controlled By", width: 120},
						{ field: "tdCpAgSecExpoCbPcent", title: "Connected Party Type", width: 120},
						{ field: "tdCpAgSecMatLmtPcent", title: "Conneted with", width: 120},
						{ field: "sdIcpUnsecExpoHkmaLmt", title: "FinIQ Exposure", width: 120},
						{ field: "sdIcpUnsecExpoMatLmt", title: "T24 Unsecured Exposure(TD)", width: 120},
						{ field: "sdNoOfIccpExceedMatLmt", title: "Sum of FinIQ Exposure & T24 Unsecured Exposure(TD)", width: 120},
						{ field: "fntCapitalBase", title: "% of Capital Base (unsecured portion)(TD)", width: 120},
						{ field: "tdCpAgSecExpo", title: "Secured Exposure", width: 120}
				]
			});
			closeModal();
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
				<div id="limitHeader" style="background-color:#B54D4D; color:#fff;margin-bottom: 30px; padding:4px 0px 4px 0px;">Connected Lending Limit/Exposure Monitoring</div>
				
				
<!-- Large Exposure Conditinal search criteria starts-->
			<div id="limitData">
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
						<td>Portfolio Code : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="pcode" class="k-textbox" type="text"/></td>									
						
						<td>Portfolio Name : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="pName" type="text" class="k-textbox"/> &nbsp;&nbsp;&nbsp;</td>
						
						<td>Account No : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="accNo" type="text" class="k-textbox"/></td>
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td>S81 Group ID : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="sGrpId" type="text" class="k-textbox"/></td>
						
						<td>Account Name : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="accName" type="text" class="k-textbox"/></td>
						
						<td>Connected With &nbsp;&nbsp;&nbsp;</td>
						<td><input id="connWith" type="text" class="k-textbox"/></td>					
					
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td>Sum of FinIQ Exposure & T24 Unsecured Exposure (TD) Filter operator : &nbsp;&nbsp;&nbsp;</td>
						<td>
						<select style="width:30px;" id="dropValue">
							</select>
						<input id="finIQexp" type="text" class="k-textbox" style="width:160px;"/></td>
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td>% of Capital Base (Unsecured Portion) (TD) : &nbsp;&nbsp;&nbsp;</td>
						<td>
						<select style="width:30px;" id="dropValue1">
						</select>
						<input id="capitalBase" type="text" class="k-textbox" style="width:160px;"/></td>
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="6" align="right">
							<button id="submitBtn" class="k-button" type="button">Search</button>
							<button id="resetBtn" class="k-button" type="button">Reset</button>
							<button id="exportBtn" class="k-button" type="button">Export</button>
						</td>
					</tr>
				</tbody>
			</table>
			<br/><br/>
				<div id="dailyReport" style="display:none;">
				<span>Daily Report for Connected Leading in BOCIL</span>
				<p style="border-bottom: 1px solid black;width: 50%;">Report as of <span id="reportDate" style="margin:30%">: Report Date</span></p>
					<table style="width:50%;border-bottom:2px solid black">
						<tbody>
							
							<tr style="border-top: 3px solid black;">
								<td style="width:10%;">BOCIL Daily Capital Base</td>
								<td style="width: 30%; " class="dailyCapBase">: 1,434,368,249 (C1 For Calculation)
								</td>
							</tr>
								<tr>
								<td style="width:20%; ">BOCIL Monthly End Capital Base  F&T  Figure As of</td>
								<td style="width: 30%;" class="monthlyCapBase">: 1,423,611,000 (C2 For Reference only)
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<br/><br/>
				<div class="dailyReport1" style="display:none;">
					<table >
						<tbody>
							
							<tr >
								<td><b>Excess Indication</b></td>
								<td><b>Summary for Trade Date Exposure</b></td>
								<td></td>
								<td><b>$</b></td>
								<td><b>% of Capital Base</b></td>
								<td><b>MAT Limit</b></td>
								<td><b>HKMA Limit</b></td>
							</tr>
							<tr>
								<td>N</td>
								<td>Agregate of Unsecured Exposue of Confirmed Connected Parties</td>
								<td>confirmed</td>
								<td>50,000,000</td>
								<td>3%</td>
								<td>8.00%</td>
								<td>10.00%</td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td>Potentiel</td>
								<td>50,000,000</td>
								<td>3%</td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td>N</td>
								<td>Agregate of secured Exposue of Confirmed Connected Parties</td>
								<td>confirmed</td>
								<td>50,000,000</td>
								<td>3%</td>
								<td>25.00%</td>
								<td></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td>Potentiel</td>
								<td>50,000,000</td>
								<td>3%</td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<tr>
								<td>N</td>
								<td>Agregate of Unsecured Exposue of Indiviual Confirmed Connected Parties</td>
								<td>confirmed</td>
								<td>50,000,000</td>
								<td>3%</td>
								<td>4.00%</td>
								<td>5.00%</td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td>Potentiel</td>
								<td>50,000,000</td>
								<td>3%</td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td></td>
								<td>Number Of Individual Connected Parties with unsecured Exposure in excees of MAT Limit </td>
								<td></td>
								<td>3</td>
								<td></td>
								<td>800,000</td>
								<td>1,000,000</td>
							</tr>
						</tbody>
					</table>
				</div>
				<br/><br/>
				<br/><br/>
				<div class="dailyReport1" style="display:none;">
					<table >
						<tbody>
							
							<tr >
								<td><b>Excess Indication</b></td>
								<td><b>Summary for Settlement Date Exposure</b></td>
								<td></td>
								<td><b>$</b></td>
								<td><b>% of Capital Base</b></td>
								<td><b>MAT Limit</b></td>
								<td><b>HKMA Limit</b></td>
							</tr>
							<tr>
								<td>N</td>
								<td>Agregate of Unsecured Exposue of Confirmed Connected Parties</td>
								<td>confirmed</td>
								<td>50,000,000</td>
								<td>3%</td>
								<td>8.00%</td>
								<td>10.00%</td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td>Potentiel</td>
								<td>50,000,000</td>
								<td>3%</td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td>N</td>
								<td>Agregate of secured Exposue of Confirmed Connected Parties</td>
								<td>confirmed</td>
								<td>50,000,000</td>
								<td>3%</td>
								<td>25.00%</td>
								<td></td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td>Potentiel</td>
								<td>50,000,000</td>
								<td>3%</td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<tr>
								<td>N</td>
								<td>Agregate of Unsecured Exposue of Indiviual Confirmed Connected Parties</td>
								<td>confirmed</td>
								<td>50,000,000</td>
								<td>3%</td>
								<td>4.00%</td>
								<td>5.00%</td>
							</tr>
							<tr>
								<td></td>
								<td></td>
								<td>Potentiel</td>
								<td>50,000,000</td>
								<td>3%</td>
								<td></td>
								<td></td>
							</tr>
							<tr>
								<td></td>
								<td>Number Of Individual Connected Parties with unsecured Exposure in excees of MAT Limit </td>
								<td></td>
								<td>3</td>
								<td></td>
								<td>800,000</td>
								<td>1,000,000</td>
							</tr>
						</tbody>
					</table>
				</div>
		</div> 
				<!--  ends-->
				<br/><br/>
				<br/><br/>
				<div id="list"></div>
		
</html>
