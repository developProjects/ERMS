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

    <!-- Kendo UI combined JavaScript -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>

 	<script type="text/javascript">
				
 	 $(document).ready(function () {

						$(document).on('click', '#submitBtn', function(){
							dataGrids();
						});
						//Reset button click
	        			$("#resetBtn").kendoButton({
	        				click: function(){
	        					$("#dropValue").data("kendoDropDownList").value("ALL");
	        					$("#dropValue1").data("kendoDropDownList").value("ALL");
	        					$("#dropValue2").data("kendoDropDownList").value("BOCIH");
	        					$("#dropValue3").data("kendoDropDownList").value("HK");
	        					$('#issuerCode').val('');
	        					$('#issuerName').val('');
	        				}
	        			});
						$("#exportBtn").kendoButton();	
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
			                		
					                	$("#dropValue3").kendoDropDownList({
					                			dataTextField: "text",
					                			dataValueField: "value",
					                			dataSource: [{ text: "HK", value: "HK" }],
					                			index: 0
					                		});	
					});
 	 		
		//Displaying Data in the Grids
		function dataGrids(){
			$('#list').html('');
			$(".empty-height").hide();
			openModal();
			var dataParams = {
				userId : window.sessionStorage.getItem('username'),
				assetClass : $('#dropValue').val(),
				acctBizUnit : $("#dropValue1").val(),
				acctEntity : $("#dropValue2").val(),
				assetCountryRisk : $("#dropValue3").val(),
				issuerCode : $('#issuerCode').val(),
				issuerName : $('#issuerName').val(),
				skip : 0,
				pageSize: 5
			}
			var getCountryRiskMonBrkDownUrl = window.sessionStorage.getItem('serverPath')+"otherRisk/getCountryRiskMonBreakdown";
			//var getCountryRiskMonBrkDownUrl = 	"/ermsweb/resources/js/getCountryRiskMonBreakdown.json"
			var activeDataSource = new kendo.data.DataSource({
												transport: {
													read: {
														url: getCountryRiskMonBrkDownUrl,
														dataType: "json",
														

														data : dataParams,
														xhrFields: {
								                              withCredentials: true
								                          }
													}
												},
												error:function(e){
							if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
						},
												pageSize: 3
											});
											
			
			
			$("#list").kendoGrid({
				excel: {
					 allPages: true
				},
				dataSource: activeDataSource,
					pageSize: 1,
					scrollable:true,
	    			pageable: true,
	    			columns: [
								{ field: "assetCountryRisk", title: "Collateral Country" , width: 120},
								{ field: "creditGroup", title: "Credit Group" , width: 120},
								{ field: "clnName", title: "Client Name" , width: 120},
								{ field: "acctId", title: "Account No." , width: 120},
								{ field: "subAcctId", title: "Sub Acc" , width: 120},
								{ field: "acctBizUnit", title: "Acc - Biz Unit" , width: 120},
								{ field: "lmtTypeDesc", title: "Limit Type" , width: 120},
								{ field: "facId", title: "Facility ID" , width: 120},
								{ field: "assetClass", title: "Asset Class" , width: 120},
								{ field: "assetType", title: "Asset Type" , width: 120},
								{ field: "assetCode", title: "Asset Code" , width: 120},
								{ field: "assetName", title: "Asset Name" , width: 120},
								{ field: "t24CollCode", title: "T24 Collateral Code" , width: 120},
								{ field: "assetStatus", title: "Asset - Status" , width: 120},
								{ field: "sdAvailQty", title: "Asset - Available Qty (SD)" , width: 120},
								{ field: "tdAvailQty", title: "Asset - Available Qty (TD)" , width: 120},
								{ field: "sdQty", title: "Asset - Quantity (SD)" , width: 120},
								{ field: "tdQty", title: "Asset - Quantity (TD)" , width: 120},
								{ field: "sdMktValBaseCcy", title: "Asset - Market Value in Base Ccy (SD)" , width: 120},
								{ field: "tdMktValBaseCcy", title: "Asset - Market Value in Base Ccy (TD)" , width: 120},
								{ field: "sdMktValHke", title: "Asset - Market Value in HKD Equiv. (SD)" , width: 120},
								{ field: "tdMktValHke", title: "Asset - Market Value in HKD Equiv. (TD)" , width: 120},
								{ field: "marginRatio", title: "Asset - Margin Ratio" , width: 120},
								{ field: "sdCollValBaseCcy", title: "Asset - Collateral Value in base Ccy (SD)" , width: 120},
								{ field: "tdCollValBaseCcy", title: "Asset - Collateral Value in base Ccy (TD)" , width: 120},
								{ field: "sdCollValHke", title: "Asset - Collateral Value in HKD eqv (SD)" , width: 120},
								{ field: "tdCollValHke", title: "Asset - Collateral Value in HKD eqv (TD)" , width: 120},
								{ field: "sdLoanAmtCollSupport", title: "Loan amount supported by this collateral (SD)" , width: 120},
								{ field: "tdLoanAmtCollSupport", title: "Loan amount supported by this collateral (TD)" , width: 120},
								{ field: "sdModiLoanAmtCollSupport", title: "Modified Loan amount supported by this collateral (SD)" , width: 120},
								{ field: "tdModiLoanAmtCollSupport", title: "Modified Loan amount supported by this collateral (TD)" , width: 120},
								{ field: "hhi", title: "HHI" , width: 120},
								{field: "issuerCode", title: "Issuer Code", width:120},
								{field: "instruIssuer", title: "Instrument Issuer", width:120},
								{field: "guarCode", title: "Guarantor Code", width:120},
								{field: "instruGuarantor", title: "Instrument Guarantor", width:120},
								{field: "keepwellProviderCode", title: "Keepwell Provider Code", width:120},
								{field: "keepwellProvider", title: "Keepwell Provider", width:120},
								{field: "epiuPtyCustObligCode", title: "EIPU Party/Custom Obligor Code", width:120},
								{field: "epiuPtyCustInstruOblig", title: "EIPU Party/Custom Instrument Obligor", width:120},
								{field: "entityUtlimateObligCode", title: "Ultimate Obligor Code at Entity Level", width:120},
								{field: "entityUtlimateObligName", title: "Ultimate Obligor Name at Entity Level", width:120}
								
	    			          ]
			    			});
						closeModal();
		}
		
		function hrefLink(projectLink){
				return "<a href='/ermsweb/counterpartyexposure?ProjectName="+projectLink+"'>"+projectLink+"</a>";
		}
		function hrefLink1(projectLink, clientLink){
				return "<a href='/ermsweb/counterpartyexposure?ProjectName="+projectLink+"/&ClientName="+clientLink+"'>"+clientLink+"</a>";
		}
		function hrefLink2(projectLink, clientLink, accLink){
			return "<a href='/ermsweb/counterpartyexposure?ProjectName="+projectLink+"&ClientName="+clientLink+"&accLink="+accLink+"'>"+accLink+"</a>";
		}
		
		function hrefLink3(obj){
			if(obj != null && obj != ''){
				var chk = $('#dropValue').val();
				if(chk == "PE"){
					return  "<a href='/ermsweb/T24InvestmentDetails'>"+kendo.toString( new Date(parseInt(obj)), "MM/dd/yyyy" )+"</a>";
				}else{
					return  "<a href='/ermsweb/ltvMonitoringReport'>"+kendo.toString( new Date(parseInt(obj)), "MM/dd/yyyy" )+"</a>";
				}
			}
			if(obj == null || ''){
				return "";
			}
		} 
		
		function hrefLink4(obj){
			if(obj != null && obj != ''){
				var chk = $('#dropValue').val();
				if(chk == "PE"){
					return  kendo.toString( new Date(parseInt(obj)), "MM/dd/yyyy" );
				}else{
					return  "<a href='/ermsweb/ltvMonitoringReport'>"+kendo.toString( new Date(parseInt(obj)), "MM/dd/yyyy" )+"</a>";
				}
			}
			if(obj == null || ''){
				return "";
			}
		} 
		function hrefLink5(){
			var chk = $('#dropValue').val();
			if(chk == "PE"){
				return  "<a href='/ermsweb/T24InvestmentDetails'>View Details</a>";
			}else{
				return  "<a href='/ermsweb/loanLSFDetails'>View Details</a>";
			}
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
				<div id="limitHeader" style="background-color:#B54D4D; color:#fff;padding:4px 0px 4px 0px;">Country Risk Monitoring (Collateral) - Exposure Breakdown</div>
				<div>
                <table id="listTable" width="100%" style="background-color:#DBE5F1; overflow-x:scroll; ">
                    <tr>
                        <td colspan="3" style="background-color:#8DB4E3; width:100%">
                            <div id="filter-table-heading" onclick="expandCriteria()">(-) Filter Criteria BOCIH</div>
                        </td>
                    </tr>
                    <tbody id="search-filter-body" style="display: block">
                         <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
						 <td>Asset Class</td>
						 
						 <td style="width: 150px;"><select  id="dropValue"></select></span></td>
						 
						
						 <td>Business Unit</td>
						 <td style="width: 150px;"><select  id="dropValue1"></select></span></td>
						 <td colspan="3" width="150px;">&nbsp;</td>
						 
						 <td>Entity</td>
						 <td style="width: 150px;"><select  id="dropValue2"></select></span></td>
						  <td colspan="3" width="150px;">&nbsp;</td>
						  
						 <td>Collateral Country</td>
						 <td style="width: 150px;"><select  id="dropValue3"></select></span></td>
						 <td colspan="3" width="150px;">&nbsp;</td>
						</tr>
						 <tr>
							<td style="width: 150px;">Obligor /Issuer Code: </td><td> <input type="text" class="k-textbox" id="issuerCode"></td>
							<td style="width: 150px;">Obligor /Issuer Name: </td><td> <input type="text" class="k-textbox" id="issuerName"></td>
						</tr>
						 <tr style="float:right;">
							 <td colspan="6" align="right">
								<button id="submitBtn" class="k-button" type="button">Search</button>
								<button id="resetBtn" class="k-button" type="button">Reset</button>
							</td>
						</tr>
					
                    </tbody>
                </table>
            	</div>
            	<br><br>
            	
            	<br/><br/>
				<div id="list"></div>
            	
            	
				
		
</html>
