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
		.k-animation-container{width:250px !important;}
		
	</style>
    <!-- jQuery JavaScript -->
    <script src="/ermsweb/resources/js/jquery.min.js"></script>

   	<script src="/ermsweb/resources/js/jszip.min.js"></script>
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>

 	<script type="text/javascript">
				
 	 $(document).ready(function () {

					$("#bizUnit").kendoDropDownList();
						//var getLargeExpoMonByGrpURL = "/ermsweb/resources/js/getErmsLargeExpoMonByGrp.json?userId="+window.sessionStorage.getItem('username');
					//grid layer for second call
						$(document).on('click', '#submitBtn', function(){
	        					var input = $("input:text, select");
	        					var valid=0;
	        					for(var i=0;i<input.length;i++){
	        						if($.trim($(input[i]).val()).length > 0){
	        							valid = valid + 1;
	        						}
	        					}
	        					if(valid >0){
	        						dataGrids();
	        					}
	        					else{
	        						alert("Atleast One Field is Required");
	        					}				
	        				
						});
						//Reset button click
	        			$("#resetBtn").kendoButton({
	        				click: function(){
	        					$("#dropValue").data("kendoDropDownList").value("ALL");
	        					$("#dropValue1").data("kendoDropDownList").value("ALL");
	        					$("#dropValue2").data("kendoDropDownList").value("BOCIH");
	        				}
	        			});
						//Export button click
	        			$("#exportBtn").kendoButton({
	        				click: function(){
	        					// trigger export of the AccDetails grid
	        					var activeListDetailsKendoGrid = $("#list").data("kendoGrid");
	        					activeListDetailsKendoGrid.saveAsExcel();
	        					
	        				}
	        			});
						
						var limitOperatorData = [
						                			{ text: "ALL", value: "ALL" },
						                			{ text: "Bond", value: "Bond" },
													{ text: "Stock", value: "Stock" },
													{ text: "Mutual Fund", value: "Mutual Fund" },
													{ text: "Cash", value: "Cash" },
													{ text: "Plain Notes", value: "Plain Notes" },
													{ text: "Structured Notes", value: "Structured Notes" },
													{ text: "Plain Deposits", value: "Plain Deposits" },
													{ text: "Structured Deposits", value: "Structured Deposits" },
													{ text: "Insurance Policy", value: "Insurance Policy" },
													{ text: "Real Estate", value: "Real Estate" },
													{ text: "Leveraged Deposit", value: "Leveraged Deposit" },
													{ text: "Private Shares", value: "Private Shares" },
													{ text: "Others", value: "Others" },
													{ text: "No Collateral", value: "No Collateral" }
													
						                		];
						                  				
						                		$("#dropValue").kendoDropDownList({
						                			dataTextField: "text",
						                			dataValueField: "value",
						                			dataSource: limitOperatorData,
						                			index: 0
						                		});
			
						                		$('#dropValue1').kendoDropDownList({
						    						optionLabel: "Select",
						    						dataTextField: "text",
						    						dataValueField: "value",
						    						dataSource: {
						    							transport: {
						    								read: {
						    									url: "/ermsweb/resources/js/businessunit.json",
						    									dataType: "json"
						    								}
						    							}
						    						},
						    						index:0,
						    						value:"ALL"
						    					}); 
								 var limitOperatorData2 = [
																{ text: "BOCIH", value: "BOCIH" },
																{ text: "BOCIL", value: "BOCIL" },
																{ text: "BOCIS", value: "BOCIS" },
																{ text: "BOCIF", value: "BOCIF" },
																{ text: "BOCICA", value: "BOCICA" },
																{ text: "BOCIPA", value: "BOCIPA" }
																
																
						                                    ];		
						                	$("#dropValue2").kendoDropDownList({
						                			dataTextField: "text",
						                			dataValueField: "value",
						                			dataSource: limitOperatorData2,
						                			index: 0
						                		});	
					});
 	 		
		//Displaying Data in the Grids
		function dataGrids(){
			$('#list').html('');
			 $('#capitalBOCIH').html('');
			 $('#capitalBOCIL').html('');
			 $('#capitalAsDate').html('');
			 
			$('#dailyReport').css('display', 'block');
			$(".empty-height").hide();
			openModal();
			var dataParams = {
					userId : window.sessionStorage.getItem('username'),
					assetClass : $('#dropValue').val(),
					acctBizUnit : $("#dropValue1").val(),
					acctEntity : $("#dropValue2").val(),
					skip : 0,
					pageSize: 5
				}
			
			var getCountryRiskMonCaptialBaseURL = window.sessionStorage.getItem('serverPath')+"otherRisk/getCountryRiskMonCaptialBase?userId="+window.sessionStorage.getItem('username');
			//var getCountryRiskMonCaptialBaseURL = "/ermsweb/resources/js/getCountryRiskMonCaptialBase.json";
			
			$.ajax({
			    url: getCountryRiskMonCaptialBaseURL,
			    type: "GET",
			    datatype: 'json',
			    xhrFields: {
                    withCredentials: true
                },
			    success: function(data){
			    	$('#bociTab').css('display', 'block');
					console.log(data);
		        $('#capitalBOCIH').html(data.bocihCapitalBaseAmt);
		        $('#capitalBOCIL').html(data.bocilCapitalBaseAmt);
		        $('#capitalAsDate').html(data.bocihAsOfDate);
			    }
		    });
			
			var getCountryRiskMonUrl = window.sessionStorage.getItem('serverPath')+"otherRisk/getCountryRiskMon";
			//var getCountryRiskMonUrl = 	"/ermsweb/resources/js/getCountryRiskMon.json"
			var activeDataSource = new kendo.data.DataSource({
												transport: {
													read: {
														url: getCountryRiskMonUrl,
														
														dataType: "json",
														xhrFields: {
								                              withCredentials: true
								                          },
														data:dataParams
													}
												},
												error:function(e){
							if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
						},
												pageSize: 3
											});
											
			function entityChk(){
				
				if($('#dropValue2').val() == 'BOCIH'){
					return [

					        { field: "assetCountryRisk", title: "Collateral Country", width: 120},
							{ field: "creditRatingInr", title: "Internal Rating" , width: 120},
							{ field: "creditRatingSnp", title: "S&P Rating" , width: 120},
							{ field: "creditRatingMoodys", title: "Moody's Rating" , width: 120},
							{ field: "creditRatingFitch", title: "Fitch Rating" , width: 120},
							
							{ field: "bocihLimitHkd", title: "BOCIH - Limit (HKD)" , width: 120},
							{ field: "bocihCapitalRatio", title: "BOCIH - % of Capital" , width: 120},
							{ field: "bocihExpoHkd", title: "BOCIH - Exposure" , width: 120},
							{ field: "bocihUsageRatio", title: "BOCIH - Usage %" , width: 120},
							
							{ field: "bocilLimitHkd", title: "BOCIL - Limit (HKD)" , width: 120},
							{ field: "bocilCapitalRatio", title: "BOCIL - % of Capital" , width: 120},
							{ field: "bocilExpoHkd", title: "BOCIL - Exposure" , width: 120},
							{ field: "bocilUsageRatio", title: "BOCIL - Usage %" , width: 120},
							
							{ field: "bocisLimitHkd", title: "BOCIS - Limit (HKD)" , width: 120},
							{ field: "bocisCapitalRatio", title: "BOCIS - % of Capital" , width: 120},
							{ field: "bocisExpoHkd", title: "BOCIS - Exposure" , width: 120},
							{ field: "bocisUsageRatio", title: "BOCIS - Usage %" , width: 120},
							
							{ field: "bocifLimitHkd", title: "BOCIF - Limit (HKD)" , width: 120},
							{ field: "bocifCapitalRatio", title: "BOCIF - % of Capital" , width: 120},
							{ field: "bocifExpoHkd", title: "BOCIF - Exposure" , width: 120},
							{ field: "bocifUsageRatio", title: "BOCIF - Usage %" , width: 120},
							
							{ field: "bocCaymanLimitHkd", title: "BOC Cayman - Limit (HKD)" , width: 120},
							{ field: "bocCaymanCapitalRatio", title: "BOC Cayman - % of Capital" , width: 120},
							{ field: "bocCaymanExpoHkd", title: "BOC Cayman - Exposure" , width: 120},
							{ field: "bocCaymanUsageRatio", title: "BOC Cayman - Usage %" , width: 120},
							
							{ field: "bocPanamaLimitHkd", title: "BOC Panama - Limit (HKD)" , width: 120},
							{ field: "bocPanamaCapitalRatio", title: "BOC Panama - % of Capital" , width: 120},
							{ field: "bocPanamaExpoHkd", title: "BOC Panama - Exposure" , width: 120},
							{ field: "bocPanamaUsageRatio", title: "BOC Panama - Usage %" , width: 120}
									]
				 }
				if($('#dropValue2').val() != 'BOCIH'){
					return [
							{ field: "assetCountryRisk", title: "Collateral Country", width: 120},
							{ field: "creditRatingInr", title: "Internal Rating" , width: 120},
							{ field: "creditRatingSnp", title: "S&P Rating" , width: 120},
							{ field: "creditRatingMoodys", title: "Moody's Rating" , width: 120},
							{ field: "creditRatingFitch", title: "Fitch Rating" , width: 120},
	    				
							{ field: "", title: "Selected Entity - Limit" , width: 120},
							{ field: "", title: "Selected Entity - % of Capital" , width: 120},
							{ field: "", title: "Selected Entity - Exposure" , width: 120},
							{ field: "", title: "Selected Entity - Usage %" , width: 120}
						]
				}
				
			}
			
			$("#list").kendoGrid({
				excel: {
					 allPages: true,
					 fileName:"CountryRisk Collateral"
				},
				dataSource: activeDataSource,
					pageSize: 1,
					scrollable:true,
	    			pageable: true,
	    			columns: entityChk()
			    			});
						closeModal();
		}
		
		
		function expandCriteria(){
			var filterBody = document.getElementById("search-filter-body").style.display;
			if(filterBody == "block"){
				document.getElementById("search-filter-body").style.display = "none";
				document.getElementById("filter-table-heading").innerHTML = "(+) Filter Criteria";
			}else{
				document.getElementById("search-filter-body").style.display = "block";
				document.getElementById("filter-table-heading").innerHTML= "(-) Filter Criteria";
			}
		}
		
		 
		function openModal() {
		   $("#modal, #modal1").show();
		}
		
		function closeModal() {
		   $("#modal, #modal1").hide();	    
		}
	
	</script>
	</head>
	
			<!-- <div width="1000"> -->
				<!-- <script type="text/javascript" src="/ermsweb/resources/js/header.js"></script> -->
				<%-- <%@include file="header.jsp"%> --%> 
				<br>
				<div id="limitHeader" style="background-color:#B54D4D; color:#fff;padding:4px 0px 4px 0px;">Country Risk Monitoring (Collateral)</div>
				<div>
                <table id="listTable" width="100%" style="background-color:#DBE5F1; overflow-x:scroll; ">
                    <tr>
                        <td colspan="3">
                            <div id="filter-table-heading" onclick="expandCriteria()">(-) Filter Criteria BOCIH</div>
                        </td>
                    </tr>
                    <tbody id="search-filter-body" style="display: block">
                         <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
						<td>Asset Class</td>
						<td>&nbsp;  &nbsp; </td>
						<td style="width: 150px;"><select  id="dropValue"></select></span></td>
						<td>&nbsp;  &nbsp; </td>
						<td>Business Unit</td>
						 <td>&nbsp;  &nbsp; </td>
						 <td style="width: 150px;"><select  id="dropValue1"></select></span></td>
						 <td>&nbsp;  &nbsp; </td>
						 <td>Entity</td>
						 <td>&nbsp;  &nbsp; </td>
						 <td style="width: 150px;"><select  id="dropValue2"></select></span></td>
						</tr>
						
						 <tr style="float:right;">
							 <td colspan="6" align="right">
								<button id="submitBtn" class="k-button" type="button">Search</button>
								<button id="resetBtn" class="k-button" type="button">Reset</button>
								<button id="exportBtn" class="k-button" type="button">Export</button>
							</td>
						</tr>
					
                    </tbody>
                </table>
            	</div>
            	<br><br>
            	
            	<div id="bociTab" style="display : none;">
                <table style="background-color:#DBE5F1;">
                	<thead>
	                    <tr>
	                        <td colspan="9" style="background-color:#ccc;">
	                            <div id="limitHeader" style="background-color:#6D4D4D; color:#fff;padding:4px 0px 4px 0px;">Result</div>
	                        </td>
	                    </tr>
                    </thead>
                    <tbody>
                    <tr  style="background-color:#B54D4D">
						<td>BOCIH Capital Base Amount &nbsp; &nbsp;&nbsp; : &nbsp; &nbsp;<span id="capitalBOCIH" style="float:right"></span></td>
						<td colspan="3">BOCIH Capital Base Amount as of Date&nbsp; &nbsp;&nbsp; : &nbsp; &nbsp;<span id="capitalAsDate" style="float:right"></span></td>
					</tr>
					<tr style="background-color:#B54D4D">
						 <td>BOCIL Capital Base Amount&nbsp; &nbsp;&nbsp; : &nbsp; &nbsp;<span id="capitalBOCIL" style="float:right"></span></td>
					</tr>
                    </tbody>
                </table>
            	</div>
            	<br/><br/>
				<div id="list"></div>
            	
            	
				
		
</html>
