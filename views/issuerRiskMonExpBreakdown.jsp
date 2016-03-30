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
        <!-- General layout Style -->
    <link href="/ermsweb/resources/css/layout.css" rel="stylesheet" type="text/css">
	
    <!-- jQuery JavaScript -->
    <script src="/ermsweb/resources/js/jquery.min.js"></script>
    <!-- Kendo UI combined JavaScript -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>

 	<script type="text/javascript">
 
 	 $(document).ready(function () {
 				var assetClassData = [
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
		                  				
		                		$("#assetClass").kendoDropDownList({
		                			dataTextField: "text",
		                			dataValueField: "value",
		                			dataSource: assetClassData,
		                			index: 0,
		                			value:"ALL"
		                		});
		                		
			 		$('#bizUnit').kendoDropDownList({
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
                	$("#entityList").kendoDropDownList({
                			dataTextField: "text",
                			dataValueField: "value",
                			dataSource: limitOperatorData2,
                			index: 0,
                			value:"BOCIH"
                	});	
                	
                	$("#collateralCountry").kendoDropDownList({
            			dataTextField: "text",
            			dataValueField: "value",
            			dataSource: [{ text: "HK", value: "HK" }],
            			index: 0
            		});	
                	
                	
        			
        			//Fetching Search Criteria values from Session
        			
        			$("#bizUnit").val(checkUndefinedElement(window.sessionStorage.getItem("bizUnit")));
        			$("#issuerCode").val(checkUndefinedElement(window.sessionStorage.getItem("issuerCode")));
        			$("#issuerName").val(checkUndefinedElement(window.sessionStorage.getItem("issuerName")));
        			$("#entityList").val(checkUndefinedElement(window.sessionStorage.getItem("entity")));
        			$("#assetClass").val(checkUndefinedElement(window.sessionStorage.getItem("assetClass")));
        			$("#collateralCountry").val(checkUndefinedElement(window.sessionStorage.getItem("assetCountryRisk")));
        			
        			
        			//Export button click
        			$("#exportBtn").kendoButton({
        				click: function(){
        					// trigger export of the AccDetails grid
        					var activeListDetailsKendoGrid = $("#issuerRisk-list").data("kendoGrid");
        					activeListDetailsKendoGrid.saveAsExcel();
        					
        				}
        			});
        			
        			//Search button click
        			$("#searchBtn").kendoButton({
        				click: function(){
        					var input = $("input:text, select");
        					var valid=0;
        					for(var i=0;i<input.length;i++){
        						if($.trim($(input[i]).val()).length > 0){
        							valid = valid + 1;
        						}
        					}
        					if(valid >0){
        						dataGrids();
        						window.sessionStorage.setItem('entity',$('#entityList').val());
        						window.sessionStorage.setItem('issuerCode',$('#issuerCode').val());
        						window.sessionStorage.setItem('issuerName',$('#issuerName').val());
        						window.sessionStorage.setItem('bizUnit',$('#bizUnit').val());
        						window.sessionStorage.setItem('assetClass',$('#assetClass').val());
        						window.sessionStorage.setItem('assetCountryRisk',$('#collateralCountry').val());
        						
        					}
        					else{
        						alert("Atleast One Field is Required");
        					}				
        				}
        			});
        			
        			//Reset button click
        			$("#resetBtn").kendoButton({
        				click: function(){
        					$("#bizUnit").data("kendoDropDownList").value("ALL");
        					$("#entityList").data("kendoDropDownList").value("BOCIL");
        					$("#assetClass").data("kendoDropDownList").value("ALL");
        					$("#collateralCountry").data("kendoDropDownList").value("HK");
        					$("#issuerCode").val("");
        					$("#issuerName").val("");
        					window.sessionStorage.removeItem("entity");
        					window.sessionStorage.removeItem("bizUnit");
        					window.sessionStorage.removeItem("assetClass");
        					window.sessionStorage.removeItem("assetCountryRisk");
        					window.sessionStorage.removeItem("issuerCode");
        					window.sessionStorage.removeItem("issuerName");
        				}
        			});
        			
 		});
		
		//Displaying Data in the Grids
		function dataGrids(){		
			//$(".empty-height").hide();
			openModal();
			
			var searchCriteria = {
				userId : window.sessionStorage.getItem('username'),
				//assetClass : $('#assetClass').val(),
				//acctBizUnit : $("#bizUnit").val(),
				//acctEntity : $("#entityList").val(),
				//assetCountryRisk : $("#collateralCountry").val(),
				//issuerCode : $("#issuerCode").val(),
				//issuerName : $("#issuerName").val(),
				skip : 0,
				pageSize: 1000
			};		
			var getActiveListDetailsURL = window.sessionStorage.getItem('serverPath')+"otherRisk/getCountryRiskMonBreakdown";
			//var getActiveListDetailsURL = "/ermsweb/resources/js/getIssuerRiskBreakdown.json";
			var activeDataSource = new kendo.data.DataSource({
				transport: {
					read: {
						url: getActiveListDetailsURL,
						dataType: "json",
						data:searchCriteria,
						xhrFields : {
							withCredentials : true
						}
						
						 
					}
				},
				error:function(e){
									if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
								},						
				pageSize: 3
			});
			
			$("#issuerRisk-list").kendoGrid({
				dataSource: activeDataSource,
				sortable:false,
				scrollable:false,
				selectable: "row",
				pageable: true,				
				columns:[
						{ field: "assetCountryRisk", title: "Collateral Country" , autoWidth:true},
						{ field: "creditGroup", title: "Credit Group" , autoWidth:true},
						{ field: "clnName", title: "Client Name" , autoWidth:true},
						{ field: "acctId", title: "Account No." , autoWidth:true},
						{ field: "subAcctId", title: "Sub Acc" , autoWidth:true},
						{ field: "acctBizUnit", title: "Acc - Biz Unit" , autoWidth:true},
						{ field: "lmtTypeDesc", title: "Limit Type" , autoWidth:true},
						{ field: "facId", title: "Facility ID" , autoWidth:true},
						{ field: "assetClass", title: "Asset Class" , autoWidth:true},
						{ field: "assetType", title: "Asset Type" , autoWidth:true},
						{ field: "assetCode", title: "Asset Code" , autoWidth:true},
						{ field: "assetName", title: "Asset Name" , autoWidth:true},
						{ field: "t24CollCode", title: "T24 Collateral Code" , autoWidth:true},
						{ field: "assetStatus", title: "Asset - Status" , autoWidth:true},
						{ field: "sdAvailQty", title: "Asset - Available Qty (SD)" , autoWidth:true},
						{ field: "tdAvailQty", title: "Asset - Available Qty (TD)" , autoWidth:true},
						{ field: "sdQty", title: "Asset - Quantity (SD)" , autoWidth:true},
						{ field: "tdQty", title: "Asset - Quantity (TD)" , autoWidth:true},
						{ field: "sdMktValBaseCcy", title: "Asset - Market Value in Base Ccy (SD)" , autoWidth:true},
						{ field: "tdMktValBaseCcy", title: "Asset - Market Value in Base Ccy (TD)" , autoWidth:true},
						{ field: "sdMktValHke", title: "Asset - Market Value in HKD Equiv. (SD)" , autoWidth:true},
						{ field: "tdMktValHke", title: "Asset - Market Value in HKD Equiv. (TD)" , autoWidth:true},
						{ field: "marginRatio", title: "Asset - Margin Ratio" , autoWidth:true},
						{ field: "sdCollValBaseCcy", title: "Asset - Collateral Value in base Ccy (SD)" , autoWidth:true},
						{ field: "tdCollValBaseCcy", title: "Asset - Collateral Value in base Ccy (TD)" , autoWidth:true},
						{ field: "sdCollValHke", title: "Asset - Collateral Value in HKD eqv (SD)" , autoWidth:true},
						{ field: "tdCollValHke", title: "Asset - Collateral Value in HKD eqv (TD)" , autoWidth:true},
						{ field: "sdLoanAmtCollSupport", title: "Loan amount supported by this collateral (SD)" , autoWidth:true},
						{ field: "tdLoanAmtCollSupport", title: "Loan amount supported by this collateral (TD)" , autoWidth:true},
						{ field: "sdModiLoanAmtCollSupport", title: "Modified Loan amount supported by this collateral (SD)" , autoWidth:true},
						{ field: "tdModiLoanAmtCollSupport", title: "Modified Loan amount supported by this collateral (TD)" , autoWidth:true},
						{ field: "hhi", title: "HHI" , autoWidth:true}
				]
			});
			closeModal();
		}
		
		
		
		/* Handle underfined / null element */
		function checkUndefinedElement(element){			
			if(element === null || element === "undefined"){
				return "";
			}else{
				return element;
			}
		}
		function emptyHeight(checkId){
			
			var count = $("#"+checkId).data("kendoGrid").dataSource.total();
			console.log(count);
			if (count>0){
				//alert("secondTimecheck");
				$("#"+checkId).find(".empty-height").hide();
			}else{
				$("#"+checkId).find(".empty-height").show();
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
	<body>
	<div class="boci-wrapper">
		<div id="boci-content-wrapper">
			<div class="page-title">Issuer Risk Monitoring (Collateral) - Exposure Breakdown</div>
			<div class="filter-criteria">
				<div id="filter-table-heading" onclick="expandCriteria()">(-) Filter Criteria</div>
				<table class="list-table">					
					<tbody id="search-filter-body" style="display: block;">
						<tr>
							<td>Asset Class</td>
							<td><input id="assetClass" type="text" class="select-textbox one-required"/></td>
							<td>Business Unit</td>
							<td><input id="bizUnit" type="text" class="select-textbox one-required"/></td>
							<td>Entity</td>
							<td><input id="entityList" type="text" class="select-textbox one-required"/></td>
							<td>Collateral Country</td>
							<td><input id="collateralCountry" type="text" class="select-textbox one-required"/></td>
							
						</tr>
						<tr>
							<td colspan="3">&nbsp;</td>
						</tr>
						<tr>
							<td>Obligor/Issuer Code</td>
							<td><input type="text" id="issuerCode" class="k-textbox"/></td>
							<td>Obligor/Issuer Name</td>
							<td><input type="text" id="issuerName" class="k-textbox"/></td>
							<td colspan="3"align="right">
								<button id="searchBtn" class="k-button" type="button">Search</button>
								<button id="resetBtn" class="k-button" type="button">Reset</button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<div id="search_result_container">
				<div id="active-list-container">
					<table cellpadding="0" cellspacing="0" border="0" width="100%">
						<tr>
							<td colspan="8">
								<div class="list-header">Issuer Risk Exposure Breakdown Table</div>
							</td>
						</tr>
						<tr>
							<td>
								<div id="issuerRisk-list">
															
								</div>
								
								<div id="modal">
									<img id="loader" src="images/ajax-loader.gif" />
								</div>						
							</td>
						</tr>					
					</table>
				</div>
			</div>									
		</div>
	</div>	
</body>
</html>