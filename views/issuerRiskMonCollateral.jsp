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
		/* .k-pager-wrap,.k-grid-pager,.k-widget{
			width:100%;
		} */
	/* 	.k-animation-container{width:250px !important;} */
		
	</style>
    <!-- jQuery JavaScript -->
    <script src="/ermsweb/resources/js/jquery.min.js"></script>
	<script src="/ermsweb/resources/js/jszip.min.js"></script>
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
 	<script type="text/javascript">
 
 	 $(document).ready(function () {
 		 
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
                	
        			
        			//Fetching Search Criteria values from Session
        			
        			$("#bizUnit").val(checkUndefinedElement(window.sessionStorage.getItem("bizUnit")));
        			$("#entityList").val(checkUndefinedElement(window.sessionStorage.getItem("entity")));
        			
        			
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
        						window.sessionStorage.setItem('bizUnit',$('#bizUnit').val());
        						
        					}
        					else{
        						alert("Atleast One Field is Required");
        					}				
        				}
        			});
        			
        			//Reset button click
        			$("#resetBtn").kendoButton({
        				click: function(){
        					$("#bizUnit").data("kendoDropDownList").value("");
        					$("#entityList").data("kendoDropDownList").value("");
        					window.sessionStorage.removeItem("entity");
        					window.sessionStorage.removeItem("bizUnit");
        				}
        			});
        			
 		});
		
		//Displaying Data in the Grids
		function dataGrids(){		
			//$(".empty-height").hide();
			openModal();
			
			var searchCriteria = {
				//acctBizUnit:$('#bizUnit').val(),
				//acctEntity:$('#entityList').val(),
				userId:window.sessionStorage.getItem("username"),
				skip:0,
				pageSize:1000
			};		
			
			
			var totalLoanAmountURL = window.sessionStorage.getItem('serverPath')+"otherRisk/getIssuerTotalLoan";
			//var totalLoanAmountURL = "/ermsweb/resources/js/getIssuerTotalLoan.json";
			
			var dataSource = new kendo.data.DataSource({
				transport: {
					read: {
						url:totalLoanAmountURL,
						dataType: "json",
						data:searchCriteria,
						
						xhrFields : {
							withCredentials : true
						},
						type:"GET"
						
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
				$('#loanAmountContainer').css('display', 'block');
		    	$('.list-header').css('display', 'block');
		        $('#sdTotLoanAmt').html(jsonObj[0].sdTotLoanAmt);
		        $('#tdTotLoanAmt').html(jsonObj[0].tdTotLoanAmt);
	
			});
			
		
			    	
			
			var getActiveListDetailsURL = window.sessionStorage.getItem('serverPath')+"otherRisk/getIssuerRiskMon";
			//var getActiveListDetailsURL = "/ermsweb/resources/js/getIssuerRiskMon.json";
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
				excel: {
					 allPages: true,
					 fileName :"Issuer Risk Monitoring"
				},
				sortable:false,
				scrollable:false,
				selectable: "row",
				pageable: true,				
				columns:[
					{ field: "issuerCode", title: "Obligor/Issuer Code" , autoWidth: true},
					{ field: "issuerName", title: "Obligor/Issuer Name" , autoWidth: true},
					{ field: "countryId", title: "Obligor/Issuer Country Code" , autoWidth: true},
					{ field: "countryName", title: "Obligor/Issuer Country Name" , autoWidth: true},
					{ field: "lmtAmtHke", title: "Obligor/Issuer Limit (HKD)" , autoWidth: true},
					{ field: "sdExpo", title: "Total Exposure (TD)" , autoWidth: true},
					{ field: "tdExpo", title: "Total Exposure (SD)" , autoWidth: true},
					{ field: "tdAggreMktValCollSupport", title: "Aggregated Market Value for all Collateral (TD)" , autoWidth: true},
					{ field: "sdAggreMktValCollSupport", title: "Aggregated Market Value for all Collateral (SD)" , autoWidth: true},
					{ field: "tdAggreMgnValCollSupport", title: "Aggregated Marginable Value for all Collateral (TD)" , autoWidth: true},
					{ field: "sdAggreMgnValCollSupport", title: "Aggregated Marginable Value for all Collateral (SD)" , autoWidth: true},
					{ field: "tdLoanConcentrationRatio", title: "Obligor Loan Concentration % (TD)" , autoWidth: true},
					{ field: "sdLoanConcentrationRatio", title: "Obligor Loan Concentration % (SD)" , autoWidth: true},					
					{ field: "hhi", title: "HHI" , autoWidth: true},
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
			<div class="page-title">Issuer Risk Monitoring (Collateral)</div>
			<div class="filter-criteria">
				<div id="filter-table-heading" onclick="expandCriteria()">(-) Filter Criteria</div>
				<table class="list-table">					
					<tbody id="search-filter-body" style="display: block;">
						<tr>
							<td>Business Unit</td>
							<td colspan="4">&nbsp;</td>
							<td><input id="bizUnit" type="text" class="select-textbox one-required"/></td>
							<td colspan="4">&nbsp;</td>
							<td>Entity</td>
							<td colspan="4">&nbsp;</td>
							<td><input id="entityList" type="text" class="select-textbox one-required"/></td>
							<td colspan="4">&nbsp;</td>
							<td>&nbsp;</td>
							
							<td align="right">
								<button id="searchBtn" class="k-button" type="button">Search</button>
								<button id="resetBtn" class="k-button" type="button">Reset</button>
								<button id="exportBtn" class="k-button" type="button">Export</button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<div id="search_result_container">
				<div  class="info-container" id="loanAmountContainer" style="display:none;margin-bottom:20px;">
					<div id="limitHeader" class="list-header">Result</div>
					
					<table style="background-color:#DBE5F1;">
	                	<thead>
		                    <tr>
		                        <td colspan="9" style="background-color:#ccc;">
		                            
		                        </td>
		                    </tr>
	                    </thead>
	                    <tbody>
	                    <tr  style="background-color:#B54D4D;color:fff;">
							<td>Total Loan Amount (TD) &nbsp; &nbsp;&nbsp; : &nbsp; &nbsp;<span id="tdTotLoanAmt" style="float:right"></span></td>
							
						</tr>
						<tr style="background-color:#B54D4D;color:fff;">
							 <td>Total Loan Amount (SD)&nbsp; &nbsp;&nbsp; : &nbsp; &nbsp;<span id="sdTotLoanAmt" style="float:right"></span></td>
						</tr>
	                    </tbody>
                	</table>
				</div>
				
				<div id="active-list-container">
					<table cellpadding="0" cellspacing="0" border="0" width="100%">
						<tr>
							<td colspan="8">
								<div class="list-header" style="display:none;">Issuer Risk Table</div>
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