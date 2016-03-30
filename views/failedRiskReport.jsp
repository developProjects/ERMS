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
    
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.mobile.all.min.css">
     <!-- General layout Style -->
    <link href="/ermsweb/resources/css/layout.css" rel="stylesheet" type="text/css">
    
	<style>
		.k-pager-wrap,.k-grid-pager,.k-widget{
			width:100%;
		}
		.k-animation-container{width:250px !important;}
		.k-toolbar,.k-grid-toolbar{float:right;}
	</style>
    <!-- jQuery JavaScript -->
    <script src="/ermsweb/resources/js/jquery.min.js"></script>
 <script src="/ermsweb/resources/js/jszip.min.js"></script>
    <!-- Kendo UI combined JavaScript -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>

 	<script type="text/javascript">
				
 	 $(document).ready(function () {
					//alert(true);
					$("#bizUnit").kendoDropDownList();
						//var getLargeExpoMonByGrpURL = "/ermsweb/resources/js/getErmsLargeExpoMonByGrp.json?userId="+window.sessionStorage.getItem('username');
					//grid layer for second call
							dataGrids();
						$("#resetBtn").kendoButton({
							click : function(){
								$('input[type=text]').val('');
							}
						});
						$("#exportBtn").kendoButton({
							click: function(){
								
								var Grid = $("#list").data("kendoGrid");
								
								if(Grid){
									Grid.saveAsExcel();
								}
							}
						}); 		
						//Export button click
					});
					
		//Displaying Data in the Grids
		function dataGrids(){
			//alert(true);
			$('#dailyReport').css('display', 'block');
			$(".empty-height").hide();
			openModal();
			//var getLargeExpoMonURL = "/ermsweb/resources/js/getErmsLargeExpoMon.json?userId="+window.sessionStorage.getItem('username')+"&ccdId="+$('#ccdId').val();
			var getLsfPeDlyMonEnqURL = window.sessionStorage.getItem('serverPath')+"sbl/getSblFailSettlementRpt?userId="+window.sessionStorage.getItem('username');
			//var getLsfPeDlyMonEnqURL = "/ermsweb/resources/js/getSblFailSettlementRpt.json";
			//var getsaveSblDlyMonEnqURL = "/ermsweb/resources/js/getSblDealerOverrideRpt.json";
			var getsaveSblDlyMonEnqURL = window.sessionStorage.getItem('serverPath')+"sbl/saveSblFailSettlementRpt";
			var activeDataSource = new kendo.data.DataSource({
												transport: {
													read: {
														url: getLsfPeDlyMonEnqURL,
														dataType: "json",
														xhrFields: {
									                    	withCredentials: true
									                    }
													},
													update: {
														dataType: "json",
						                                url:getsaveSblDlyMonEnqURL,
						                                type:"POST",
						                                xhrFields: {
									                    	withCredentials: true
									                    }
													},
													parameterMap: function(options, operation) {
														console.log(options);
														console.log(operation);
														if (operation == "update"){
															return {tradeRef: JSON.stringify(options.tradeRef),
																	userId : JSON.stringify(window.sessionStorage.getItem('username')),
																	reportDate : JSON.stringify(options.reportDate),
																	lenderCustId : JSON.stringify(options.lenderCustId),
																	riskMgtRemarks :JSON.stringify(options.riskMgtRemarks)
															};
															
														}
										            }
												},
					                            schema: {
					                            	  model: {
					                            		  id: "tradeRef",
					        							fields: {
					        										tradeRef: { type: "string", editable: false  },
					        										lenderCustId: { type: "string", editable: false },
					        										borrowerCustId: { type: "string", editable: false },
					        										lenderCustName: { type: "string", editable: false },
					        										borrowerCustName: { type: "string", editable: false },
					        										aeCode: { type: "string", editable: false },
					        										cashStockType: { type: "string", editable: false },
					        										tranType: { type: "string", editable: false },
					        										tranType: { type: "string", editable: false },
					        										failCode: { type: "string", editable: false },
					        										stockValue: { type: "string", editable: false },
					        										stockCode: { type: "string", editable: false },
					        										stockQty: { type: "string", editable: false },
					        										noOfDaysDailSettle: { type: "string", editable: false },
					        										riskMgtRemarks: { type: "string", editable: true },
					        										expSettleDate: { type: "string", editable: false }
					        				   	    			}
					        				   	    		}
					                            },
												pageSize: 3
											});
			
				$("#list").kendoGrid({
				    			
					dataSource: activeDataSource,
						pageSize: 1,
						
								excel: {
									 allPages: true,
									 fileName: "Failed Risk Report"
								},
				    			scrollable:true,
				    			pageable: true,
				    			navigatable: true,
				    			change : function(e){
				    				console.log(e);
				    			},
				    			selectableCell : function(e){
				    				console.log(e);
				    			},
				    			columns: [
				    			        { field: "tradeRef", title: "Trade Reference", width: 150},
				    					{ field: "lenderCustId", title: "Lender Customer ID" , width: 150},
				    					{ field: "borrowerCustId", title: "Borrower Customer ID", width: 120},
				    					{ field: "lenderCustName", title: "Lender Customer Name", width: 120},
				    					{ field: "borrowerCustName", title: "Borrower Customer Name" , width: 120},
				    					{ field: "aeCode", title: "Business Unit and AE /Sales Code" , width: 120},
				    					{ field: "cashStockType", title: "Cach / Stock Settlement" , width: 120},
				    					{ field: "tranType", title: "Transaction Type" , width: 120},
				    					{ field: "failCode", title: "Fail Code" , width: 120},
				    					{ field: "stockValue", title: "Stock Value" , width: 120},
				    					{ field: "stockCode", title: "Stock Code (if any)" , width: 120},
				    					{ field: "stockQty", title: "Stock Quantity" , width: 120},
				    					{ field: "noOfDaysDailSettle", title: "# of Days of failed Settlement" , width: 120},
				    					{ field: "riskMgtRemarks", title: "Risk Mgt Remarks" , width: 120},
				    					{ field: "expSettleDate", title: "Expected Settlement Date" , width: 120, template:"#=validDate(expSettleDate)#",},
				    					{ command: ["edit", "destroy"], title: "&nbsp;", width: "250px"}
				    			],
				    			editable: "inline"
		    			});
			closeModal();
		}

		function showDetails(data){
			var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
			alert(true);
			console.log(dataItem.tradeRef);
		}
		function validDate(obj){
			if(obj != null && obj != ""  ){
				return kendo.toString( new Date(parseInt(obj)), "MM/dd/yyyy" );
			}else{
				return "";
			}
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
				<div id="limitHeader" style="background-color:#B54D4D; color:#fff;margin-bottom: 30px; padding:4px 0px 4px 0px;">FAIL SETTLEMENT REPORT</div>
				
				
<!-- Large Exposure Conditinal search criteria starts-->
			<div id="limitData">
			<button id="exportBtn">Export</button>
			</div> 
				<!--  ends-->
				<br/><br/>
				<div id="list"></div>
</html>
