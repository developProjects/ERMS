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
		
	</style>
    <!-- jQuery JavaScript -->
    <script src="/ermsweb/resources/js/jquery.min.js"></script>

    <!-- Kendo UI combined JavaScript -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>

 	<script type="text/javascript">
				
 	 $(document).ready(function () {
					//alert(true);
						$("#limitThershold").css("display", "block");
						var getLargeExpoMonByGrpURL = window.sessionStorage.getItem('serverPath')+"largeExpo/getErmsLargeExpoMonByGrp?userId="+window.sessionStorage.getItem('username');
						//var getLargeExpoMonByGrpURL = "/ermsweb/resources/js/getErmsLargeExpoMonByGrp.json";
						var activeDataSource = new kendo.data.DataSource({
														transport: {
															read: {
																cache:false,
																method : "GET",
																url: getLargeExpoMonByGrpURL,
																dataType: "json",
																
																xhrFields: {
										                            withCredentials: true
										                           }
																//data:searchCriteria
															}
														},
														error:function(e){
															if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
														},	
														pageSize: 3
													});
						
							//alert("product1");
							
							$("#limit").kendoGrid({
								dataSource: activeDataSource,
								pageSize: 1,
								excel: {
									 allPages: true
								},
							scrollable:true,
							pageable: true,
							dataBound: function (e) {
								//console.log(e.sender._data);
								var rec = e.sender._data;
								$('.limitHeading').html('');
								$('.limitHeading').html('Limit/Exposure Monitoring Alert - Large Exposure Violation');
								$('.capBase').html(rec[0].rmdGroupDesc);
								$('.threshold1').html(rec[0].rmdGroupDesc);
								$('.threshold2').html(rec[0].rmdGroupDesc);
								$('.threshold3').html(rec[0].rmdGroupDesc);
								$(document).find('.noOfRec').remove();
								$('#limit').append('<p style="border: 3px solid red;width:30%;" class="noOfRec">#of record '+rec[0].rmdGroupDesc+'</p>');
							},
							excelExport: function(e) {
								e.preventDefault();
								promises[0].resolve(e.workbook);
							},
							columns: [
										{ field: "ccdId", title: "Client/Counterparty" , width: 80},
										{ field: "rmdGroupDesc", title: "S81 Group" , width: 60},
										{ field: "priLegalName", title: "Agrregated Exposure Under S81 Group", width: 60},
										{ field: "total", title: "% to Capital Base", width: 60},
										{ field: "severity", title: "Severity", width: 60}
							]
							});
 	 
 	 
 	 
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
						
						$(document).on('click', '#CLsubmitBtn', function(){
							alert("Cluster data");
							clusterGrid();
						});
						$(document).on('click', '.clusterGrp', function(){
							$('#limit').html('');
							$("#clusterlimitData").show();
						});
						$("#resetBtn").kendoButton();
						$("#exportBtn").kendoButton();				
			
					});
					
		//Displaying Cluster Grid
		function clusterGrid(){
			alert('trueVal');
			//var getLargeExpoMonURL = "/ermsweb/resources/js/getErmsLargeExpoMon.json?userId="+window.sessionStorage.getItem('username')+"&ccdId="+$('#CLccdId').val();
			var getClusterExpoMonURL = "/ermsweb/resources/js/getErmsClusterExpoMon.json";
			var activeDataSource = new kendo.data.DataSource({
											transport: {
												read: {
													url: getClusterExpoMonURL,
													dataType: "json"
												}
											},
											pageSize: 3
										});
			
			
			$("#CLlrglist1").kendoGrid({
				excel: {
					 allPages: true
				},
				dataSource: activeDataSource,
					pageSize: 1,
					schema: {
					  model: {
						fields: {
							rmdGroupId: { type: "string"},
							rmdGroupDesc: { type: "string"},
							portfolioCode: { type: "string"},
							portfolioName: { type: "string"},
							cmdClnId: { type: "string"},
							acctNumber: { type: "string"},
							acctName: { type: "string"},
							feFromFiniq: { type: "string"},
							tdFeFromT24: { type: "string"},
							sdFeFromT24: { type: "string"},
							tdSumOfFe: { type: "string"},
							sdSumOfFe: { type: "string"},
							tdCapBasePercent: { type: "string"},
							sdCapBasePercent: { type: "string"},
							matLmtForLargeExpo: { type: "string"},
							matLmtForClusterExpo: { type: "string"},
							hkmaLmtForLargeExpo: { type: "string"},
						  	hkmaLmtForClusterExpo: { type: "string"}
						}
					  }
				},
				sortable:true,
				scrollable:true,
				pageable: true, 
				excelExport: function(e) {
					e.preventDefault();
					promises[0].resolve(e.workbook);
				},
				columns: [
						{ field: "rmdGroupId", title: "Group ID", width: 120},
						{ field:"rmdGroupDesc", title: "Group Name", width: 120},
						{ field: "protfolioCode", title: "Protfolio Code", width: 120},
						{ field: "protfolioName", title: "Protfolio Name", width: 120},
						{ field: "cmdClnId", title: "CMD Client Id", width: 120},
						{ field: "acctNumber", title: "Account No", width: 120},
						{ field: "acctName", title: "Account Name", width: 120},
						{ field: "feFromFiniq", title: "FE from FINIQ", width: 120},
						{ field: "tdFeFromT24", title: "FE from T24 (TD)", width: 120},
						{ field: "sdFeFromT24", title: "FE from T24 (SD)", width: 120},
						{ field: "tdSumOfFe", title: "sum of FE(TD)", width: 120},
						{ field: "sdSumOfFe", title: "Sum of FE(SD)", width: 120},
						{ field: "tdCapBasePercent", title: "% of Capital Base(TD)", width: 120},
						{ field: "sdCapBasePercent", title: "% of Capital Base(SD)", width: 120},
						{ field: "matLmtForLargeExpo", title: "Exceeding MAT Limit(TD)", width: 120},
						{ field: "matLmtForClusterExpo", title: "Exceeding MAT Limit(SD)", width: 120},
						{ field: "hkmaLmtForLargeExpo", title: "Exceeding HKMA Limit(TD)", width: 120},
						{ field: "hkmaLmtForClusterExpo", title: "Exceeding HKMA Limit(SD)", width: 120}
				]
			});
					
			$("#CLlrglist2").kendoGrid({
					dataSource: activeDataSource,
						pageSize: 1,
						schema: {
						  model: {
							fields: {
								rmdGroupId: { type: "string"},
								rmdGroupDesc: { type: "string"},
								portfolioCode: { type: "string"},
								portfolioName: { type: "string"},
								cmdClnId: { type: "string"},
								acctNumber: { type: "string"},
								acctName: { type: "string"},
								feFromFiniq: { type: "string"},
								tdFeFromT24: { type: "string"},
								sdFeFromT24: { type: "string"},
								tdSumOfFe: { type: "string"},
								sdSumOfFe: { type: "string"},
								tdCapBasePercent: { type: "string"},
								sdCapBasePercent: { type: "string"},
								matLmtForLargeExpo: { type: "string"},
								matLmtForClusterExpo: { type: "string"},
								hkmaLmtForLargeExpo: { type: "date"},
							  	hkmaLmtForClusterExpo: { type: "date"}				  
							}
						  }
					},
					scrollable:true,
					pageable: true,
					excelExport: function(e) {
						e.preventDefault();
						promises[1].resolve(e.workbook);
					},
					columns: [
							{ field: "rmdGroupId", title: "Group ID", width: 120},
						{ field:"rmdGroupDesc", title: "Group Name", width: 120},
						{ field: "protfolioCode", title: "Protfolio Code", width: 120},
						{ field: "protfolioName", title: "Protfolio Name", width: 120},
						{ field: "cmdClnId", title: "CMD Client Id", width: 120},
						{ field: "acctNumber", title: "Account No", width: 120},
						{ field: "acctName", title: "Account Name", width: 120},
						{ field: "feFromFiniq", title: "FE from FINIQ", width: 120},
						{ field: "tdFeFromT24", title: "FE from T24 (TD)", width: 120},
						{ field: "sdFeFromT24", title: "FE from T24 (SD)", width: 120},
						{ field: "tdSumOfFe", title: "sum of FE(TD)", width: 120},
						{ field: "sdSumOfFe", title: "Sum of FE(SD)", width: 120},
						{ field: "tdCapBasePercent", title: "% of Capital Base(TD)", width: 120},
						{ field: "sdCapBasePercent", title: "% of Capital Base(SD)", width: 120},
						{ field: "matLmtForLargeExpo", title: "Exceeding MAT Limit(TD)", width: 120},
						{ field: "matLmtForClusterExpo", title: "Exceeding MAT Limit(SD)", width: 120},
						{ field: "hkmaLmtForLargeExpo", title: "Exceeding HKMA Limit(TD)", width: 120},
						{ field: "hkmaLmtForClusterExpo", title: "Exceeding HKMA Limit(SD)", width: 120}
					]
			});
			
			$("#CLlrglist3").kendoGrid({
				dataSource: activeDataSource,
					pageSize: 1,
					schema: {
					  model: {
						fields: {
							rmdGroupId: { type: "string"},
							rmdGroupDesc: { type: "string"},
							portfolioCode: { type: "string"},
							portfolioName: { type: "string"},
							cmdClnId: { type: "string"},
							acctNumber: { type: "string"},
							acctName: { type: "string"},
							feFromFiniq: { type: "string"},
							tdFeFromT24: { type: "string"},
							sdFeFromT24: { type: "string"},
							tdSumOfFe: { type: "string"},
							sdSumOfFe: { type: "string"},
							tdCapBasePercent: { type: "string"},
							sdCapBasePercent: { type: "string"},
							matLmtForLargeExpo: { type: "string"},
							matLmtForClusterExpo: { type: "string"},
							hkmaLmtForLargeExpo: { type: "date"},
						  	hkmaLmtForClusterExpo: { type: "date"}				  
						}
					  }
				},
				scrollable:true,
				pageable: true,
				excelExport: function(e) {
					e.preventDefault();
					promises[1].resolve(e.workbook);
				},
				columns: [
						{ field: "rmdGroupId", title: "Group ID", width: 120},
						{ field:"rmdGroupDesc", title: "Group Name", width: 120},
						{ field: "protfolioCode", title: "Protfolio Code", width: 120},
						{ field: "protfolioName", title: "Protfolio Name", width: 120},
						{ field: "cmdClnId", title: "CMD Client Id", width: 120},
						{ field: "acctNumber", title: "Account No", width: 120},
						{ field: "acctName", title: "Account Name", width: 120},
						{ field: "feFromFiniq", title: "FE from FINIQ", width: 120},
						{ field: "tdFeFromT24", title: "FE from T24 (TD)", width: 120},
						{ field: "sdFeFromT24", title: "FE from T24 (SD)", width: 120},
						{ field: "tdSumOfFe", title: "sum of FE(TD)", width: 120},
						{ field: "sdSumOfFe", title: "Sum of FE(SD)", width: 120},
						{ field: "tdCapBasePercent", title: "% of Capital Base(TD)", width: 120},
						{ field: "sdCapBasePercent", title: "% of Capital Base(SD)", width: 120},
						{ field: "matLmtForLargeExpo", title: "Exceeding MAT Limit(TD)", width: 120},
						{ field: "matLmtForClusterExpo", title: "Exceeding MAT Limit(SD)", width: 120},
						{ field: "hkmaLmtForLargeExpo", title: "Exceeding HKMA Limit(TD)", width: 120},
						{ field: "hkmaLmtForClusterExpo", title: "Exceeding HKMA Limit(SD)", width: 120}
				]
			});
			
			$("#CLlrglist4").kendoGrid({
				dataSource: activeDataSource,
					pageSize: 1,
					schema: {
					  model: {
						fields: {
							rmdGroupId: { type: "string"},
							rmdGroupDesc: { type: "string"},
							portfolioCode: { type: "string"},
							portfolioName: { type: "string"},
							cmdClnId: { type: "string"},
							acctNumber: { type: "string"},
							acctName: { type: "string"},
							feFromFiniq: { type: "string"},
							tdFeFromT24: { type: "string"},
							sdFeFromT24: { type: "string"},
							tdSumOfFe: { type: "string"},
							sdSumOfFe: { type: "string"},
							tdCapBasePercent: { type: "string"},
							sdCapBasePercent: { type: "string"},
							matLmtForLargeExpo: { type: "string"},
							matLmtForClusterExpo: { type: "string"},
							hkmaLmtForLargeExpo: { type: "date"},
						  	hkmaLmtForClusterExpo: { type: "date"}				  
						}
					  }
				},
				scrollable:true,
				pageable: true,
				excelExport: function(e) {
					e.preventDefault();
					promises[1].resolve(e.workbook);
				},
				columns: [
						{ field: "rmdGroupId", title: "Group ID", width: 120},
						{ field:"rmdGroupDesc", title: "Group Name", width: 120},
						{ field: "protfolioCode", title: "Protfolio Code", width: 120},
						{ field: "protfolioName", title: "Protfolio Name", width: 120},
						{ field: "cmdClnId", title: "CMD Client Id", width: 120},
						{ field: "acctNumber", title: "Account No", width: 120},
						{ field: "acctName", title: "Account Name", width: 120},
						{ field: "feFromFiniq", title: "FE from FINIQ", width: 120},
						{ field: "tdFeFromT24", title: "FE from T24 (TD)", width: 120},
						{ field: "sdFeFromT24", title: "FE from T24 (SD)", width: 120},
						{ field: "tdSumOfFe", title: "sum of FE(TD)", width: 120},
						{ field: "sdSumOfFe", title: "Sum of FE(SD)", width: 120},
						{ field: "tdCapBasePercent", title: "% of Capital Base(TD)", width: 120},
						{ field: "sdCapBasePercent", title: "% of Capital Base(SD)", width: 120},
						{ field: "matLmtForLargeExpo", title: "Exceeding MAT Limit(TD)", width: 120},
						{ field: "matLmtForClusterExpo", title: "Exceeding MAT Limit(SD)", width: 120},
						{ field: "hkmaLmtForLargeExpo", title: "Exceeding HKMA Limit(TD)", width: 120},
						{ field: "hkmaLmtForClusterExpo", title: "Exceeding HKMA Limit(SD)", width: 120}
				]
			});
		}
					
					
		//Displaying Data in the Grids
		function dataGrids(){
			$('#dailyReport').css('display', 'block');
			$(".empty-height").hide();
			openModal();
			//var getLargeExpoMonURL = "/ermsweb/resources/js/getErmsLargeExpoMon.json?userId="+window.sessionStorage.getItem('username')+"&ccdId="+$('#ccdId').val();
			var getLargeExpoMonURL = "/ermsweb/resources/js/getErmsLargeExpoMon.json";
			var activeDataSource = new kendo.data.DataSource({
											transport: {
												read: {
													url: getLargeExpoMonURL,
													dataType: "json"
												}
											},
											pageSize: 3
										});
			
			
			$("#lrglist1").kendoGrid({
				excel: {
					 allPages: true
				},
				dataSource: activeDataSource,
					pageSize: 1,
					schema: {
					  model: {
						fields: {
							rmdGroupId: { type: "string"},
							rmdGroupDesc: { type: "string"},
							portfolioCode: { type: "string"},
							portfolioName: { type: "string"},
							cmdClnId: { type: "string"},
							acctNumber: { type: "string"},
							acctName: { type: "string"},
							feFromFiniq: { type: "string"},
							tdFeFromT24: { type: "string"},
							sdFeFromT24: { type: "string"},
							tdSumOfFe: { type: "string"},
							sdSumOfFe: { type: "string"},
							tdCapBasePercent: { type: "string"},
							sdCapBasePercent: { type: "string"},
							matLmtForLargeExpo: { type: "string"},
							matLmtForClusterExpo: { type: "string"},
							hkmaLmtForLargeExpo: { type: "string"},
						  	hkmaLmtForClusterExpo: { type: "string"}
						}
					  }
				},
				sortable:true,
				scrollable:true,
				pageable: true, 
				excelExport: function(e) {
					e.preventDefault();
					promises[0].resolve(e.workbook);
				},
				columns: [
						{ field: "rmdGroupId", title: "Group ID", width: 120},
						{ field:"rmdGroupDesc", title: "Group Name", width: 120},
						{ field: "protfolioCode", title: "Protfolio Code", width: 120},
						{ field: "protfolioName", title: "Protfolio Name", width: 120},
						{ field: "cmdClnId", title: "CMD Client Id", width: 120},
						{ field: "acctNumber", title: "Account No", width: 120},
						{ field: "acctName", title: "Account Name", width: 120},
						{ field: "feFromFiniq", title: "FE from FINIQ", width: 120},
						{ field: "tdFeFromT24", title: "FE from T24 (TD)", width: 120},
						{ field: "sdFeFromT24", title: "FE from T24 (SD)", width: 120},
						{ field: "tdSumOfFe", title: "sum of FE(TD)", width: 120},
						{ field: "sdSumOfFe", title: "Sum of FE(SD)", width: 120},
						{ field: "tdCapBasePercent", title: "% of Capital Base(TD)", width: 120},
						{ field: "sdCapBasePercent", title: "% of Capital Base(SD)", width: 120},
						{ field: "matLmtForLargeExpo", title: "Exceeding MAT Limit(TD)", width: 120},
						{ field: "matLmtForClusterExpo", title: "Exceeding MAT Limit(SD)", width: 120},
						{ field: "hkmaLmtForLargeExpo", title: "Exceeding HKMA Limit(TD)", width: 120},
						{ field: "hkmaLmtForClusterExpo", title: "Exceeding HKMA Limit(SD)", width: 120}
				]
			});
					
			$("#lrglist2").kendoGrid({
					dataSource: activeDataSource,
						pageSize: 1,
						schema: {
						  model: {
							fields: {
								rmdGroupId: { type: "string"},
								rmdGroupDesc: { type: "string"},
								portfolioCode: { type: "string"},
								portfolioName: { type: "string"},
								cmdClnId: { type: "string"},
								acctNumber: { type: "string"},
								acctName: { type: "string"},
								feFromFiniq: { type: "string"},
								tdFeFromT24: { type: "string"},
								sdFeFromT24: { type: "string"},
								tdSumOfFe: { type: "string"},
								sdSumOfFe: { type: "string"},
								tdCapBasePercent: { type: "string"},
								sdCapBasePercent: { type: "string"},
								matLmtForLargeExpo: { type: "string"},
								matLmtForClusterExpo: { type: "string"},
								hkmaLmtForLargeExpo: { type: "date"},
							  	hkmaLmtForClusterExpo: { type: "date"}				  
							}
						  }
					},
					scrollable:true,
					pageable: true,
					excelExport: function(e) {
						e.preventDefault();
						promises[1].resolve(e.workbook);
					},
					columns: [
							{ field: "rmdGroupId", title: "Group ID", width: 120},
						{ field:"rmdGroupDesc", title: "Group Name", width: 120},
						{ field: "protfolioCode", title: "Protfolio Code", width: 120},
						{ field: "protfolioName", title: "Protfolio Name", width: 120},
						{ field: "cmdClnId", title: "CMD Client Id", width: 120},
						{ field: "acctNumber", title: "Account No", width: 120},
						{ field: "acctName", title: "Account Name", width: 120},
						{ field: "feFromFiniq", title: "FE from FINIQ", width: 120},
						{ field: "tdFeFromT24", title: "FE from T24 (TD)", width: 120},
						{ field: "sdFeFromT24", title: "FE from T24 (SD)", width: 120},
						{ field: "tdSumOfFe", title: "sum of FE(TD)", width: 120},
						{ field: "sdSumOfFe", title: "Sum of FE(SD)", width: 120},
						{ field: "tdCapBasePercent", title: "% of Capital Base(TD)", width: 120},
						{ field: "sdCapBasePercent", title: "% of Capital Base(SD)", width: 120},
						{ field: "matLmtForLargeExpo", title: "Exceeding MAT Limit(TD)", width: 120},
						{ field: "matLmtForClusterExpo", title: "Exceeding MAT Limit(SD)", width: 120},
						{ field: "hkmaLmtForLargeExpo", title: "Exceeding HKMA Limit(TD)", width: 120},
						{ field: "hkmaLmtForClusterExpo", title: "Exceeding HKMA Limit(SD)", width: 120}
					]
			});
			
			$("#lrglist3").kendoGrid({
				dataSource: activeDataSource,
					pageSize: 1,
					schema: {
					  model: {
						fields: {
							rmdGroupId: { type: "string"},
							rmdGroupDesc: { type: "string"},
							portfolioCode: { type: "string"},
							portfolioName: { type: "string"},
							cmdClnId: { type: "string"},
							acctNumber: { type: "string"},
							acctName: { type: "string"},
							feFromFiniq: { type: "string"},
							tdFeFromT24: { type: "string"},
							sdFeFromT24: { type: "string"},
							tdSumOfFe: { type: "string"},
							sdSumOfFe: { type: "string"},
							tdCapBasePercent: { type: "string"},
							sdCapBasePercent: { type: "string"},
							matLmtForLargeExpo: { type: "string"},
							matLmtForClusterExpo: { type: "string"},
							hkmaLmtForLargeExpo: { type: "date"},
						  	hkmaLmtForClusterExpo: { type: "date"}				  
						}
					  }
				},
				scrollable:true,
				pageable: true,
				excelExport: function(e) {
					e.preventDefault();
					promises[1].resolve(e.workbook);
				},
				columns: [
						{ field: "rmdGroupId", title: "Group ID", width: 120},
						{ field:"rmdGroupDesc", title: "Group Name", width: 120},
						{ field: "protfolioCode", title: "Protfolio Code", width: 120},
						{ field: "protfolioName", title: "Protfolio Name", width: 120},
						{ field: "cmdClnId", title: "CMD Client Id", width: 120},
						{ field: "acctNumber", title: "Account No", width: 120},
						{ field: "acctName", title: "Account Name", width: 120},
						{ field: "feFromFiniq", title: "FE from FINIQ", width: 120},
						{ field: "tdFeFromT24", title: "FE from T24 (TD)", width: 120},
						{ field: "sdFeFromT24", title: "FE from T24 (SD)", width: 120},
						{ field: "tdSumOfFe", title: "sum of FE(TD)", width: 120},
						{ field: "sdSumOfFe", title: "Sum of FE(SD)", width: 120},
						{ field: "tdCapBasePercent", title: "% of Capital Base(TD)", width: 120},
						{ field: "sdCapBasePercent", title: "% of Capital Base(SD)", width: 120},
						{ field: "matLmtForLargeExpo", title: "Exceeding MAT Limit(TD)", width: 120},
						{ field: "matLmtForClusterExpo", title: "Exceeding MAT Limit(SD)", width: 120},
						{ field: "hkmaLmtForLargeExpo", title: "Exceeding HKMA Limit(TD)", width: 120},
						{ field: "hkmaLmtForClusterExpo", title: "Exceeding HKMA Limit(SD)", width: 120}
				]
			});
			
			$("#lrglist4").kendoGrid({
				dataSource: activeDataSource,
					pageSize: 1,
					schema: {
					  model: {
						fields: {
							rmdGroupId: { type: "string"},
							rmdGroupDesc: { type: "string"},
							portfolioCode: { type: "string"},
							portfolioName: { type: "string"},
							cmdClnId: { type: "string"},
							acctNumber: { type: "string"},
							acctName: { type: "string"},
							feFromFiniq: { type: "string"},
							tdFeFromT24: { type: "string"},
							sdFeFromT24: { type: "string"},
							tdSumOfFe: { type: "string"},
							sdSumOfFe: { type: "string"},
							tdCapBasePercent: { type: "string"},
							sdCapBasePercent: { type: "string"},
							matLmtForLargeExpo: { type: "string"},
							matLmtForClusterExpo: { type: "string"},
							hkmaLmtForLargeExpo: { type: "date"},
						  	hkmaLmtForClusterExpo: { type: "date"}				  
						}
					  }
				},
				scrollable:true,
				pageable: true,
				excelExport: function(e) {
					e.preventDefault();
					promises[1].resolve(e.workbook);
				},
				columns: [
						{ field: "rmdGroupId", title: "Group ID", width: 120},
						{ field:"rmdGroupDesc", title: "Group Name", width: 120},
						{ field: "protfolioCode", title: "Protfolio Code", width: 120},
						{ field: "protfolioName", title: "Protfolio Name", width: 120},
						{ field: "cmdClnId", title: "CMD Client Id", width: 120},
						{ field: "acctNumber", title: "Account No", width: 120},
						{ field: "acctName", title: "Account Name", width: 120},
						{ field: "feFromFiniq", title: "FE from FINIQ", width: 120},
						{ field: "tdFeFromT24", title: "FE from T24 (TD)", width: 120},
						{ field: "sdFeFromT24", title: "FE from T24 (SD)", width: 120},
						{ field: "tdSumOfFe", title: "sum of FE(TD)", width: 120},
						{ field: "sdSumOfFe", title: "Sum of FE(SD)", width: 120},
						{ field: "tdCapBasePercent", title: "% of Capital Base(TD)", width: 120},
						{ field: "sdCapBasePercent", title: "% of Capital Base(SD)", width: 120},
						{ field: "matLmtForLargeExpo", title: "Exceeding MAT Limit(TD)", width: 120},
						{ field: "matLmtForClusterExpo", title: "Exceeding MAT Limit(SD)", width: 120},
						{ field: "hkmaLmtForLargeExpo", title: "Exceeding HKMA Limit(TD)", width: 120},
						{ field: "hkmaLmtForClusterExpo", title: "Exceeding HKMA Limit(SD)", width: 120}
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
				
				<div style="background-color:pink; width:1060" class="limitHeading">Home (HOME-SCN-001)</div>
				<br>
				<div id="limitHeader" style="background-color:#B54D4D; color:#fff;margin-bottom: 30px; padding:4px 0px 4px 0px; display:none;">Limit/Exposure Monitoring Alert - Large Exposure Violation</div>
				
				
<!-- Large Exposure Conditinal search criteria starts-->
			<div id="limitData" style="display:none">
			<div style="background-color:pink; width:1000" class="pageTitle">Limit/Exposure Monitoring Alert - Large Exposure </div>
			<table id="listTable" width="1000" style="background-color:#DBE5F1;" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="6" style="background-color:#8DB4E3; width:100%;">
					<b><div id="filterTable" onclick="expandCriteria()">(-) Filter Criteria</div></b></td>
				</tr>
				<tr>
					<td><br/></td>
				</tr>
				<tbody id="filterBody" style="display: block">
					<tr width="100%">
						<td>Group Name : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="groupName" type="text"/></td>									
						
						<td>CMD Client ID : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="cmdId" type="text"/> &nbsp;&nbsp;&nbsp;</td>
						
						<td>CCD Client ID : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="ccdId" type="text"/></td>
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td>Account No : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="accountNo" type="text"/></td>
						<td>Account Name : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="accontName" type="text"/></td>					
					
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td>FE Form T24(TD) : &nbsp;&nbsp;&nbsp;</td>
						<td>
						<select>
							<option> &#62;= </option>
							<option> &#60;= </option>
							<option> = </option>
						</select>
						<input id="FEform" type="text"/></td>
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td>Sum of FE(TD) : &nbsp;&nbsp;&nbsp;</td>
						<td>
						<select>
							<option> &#62;= </option>
							<option> &#60;= </option>
							<option> = </option>
						</select>
						<input id="SumFE" type="text"/></td>
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td>% Capital Base(TD) : &nbsp;&nbsp;&nbsp;</td>
						<td>
						<select>
							<option> &#62;= </option>
							<option> &#60;= </option>
							<option> = </option>
						</select>
						<input id="capBase" type="text"/></td>
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="6" align="right">
							<button id="submitBtn" class="k-button" type="button">Search</button>
							<button id="resetBtn" type="button">Reset</button>
							<button id="exportBtn" type="button">Export</button>
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
				
	
	<!-- Clustering Group Exposure violation Conditinal search criteria starts-->
			<div id="clusterlimitData" style="display:none">
			<!-- <div style="background-color:pink; width:1000" class="pageTitle">Limit/Exposure Monitoring Alert - Large Exposure</div> -->
			<table id="listTable" width="1000" style="background-color:#DBE5F1;" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="6" style="background-color:#8DB4E3; width:100%;">
					<b><div id="filterTable" onclick="expandCriteria()">(-) Filter Criteria</div></b></td>
				</tr>
				<tr>
					<td><br/></td>
				</tr>
				<tbody id="filterBody" style="display: block">
					<tr width="100%">
						<td>Group Name : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="CLgroupName" type="text"/></td>									
						
						<td>CMD Client ID : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="CLcmdId" type="text"/> &nbsp;&nbsp;&nbsp;</td>
						
						<td>CCD Client ID : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="CLccdId" type="text"/></td>
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td>Account No : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="CLaccountNo" type="text"/></td>
						<td>Account Name : &nbsp;&nbsp;&nbsp;</td>
						<td><input id="CLaccontName" type="text"/></td>					
					
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td>FE Form T24(TD) : &nbsp;&nbsp;&nbsp;</td>
						<td>
						<select>
							<option> &#62;= </option>
							<option> &#60;= </option>
							<option> = </option>
						</select>
						<input id="CLFEform" type="text"/></td>
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td>Sum of FE(TD) : &nbsp;&nbsp;&nbsp;</td>
						<td>
						<select>
							<option> &#62;= </option>
							<option> &#60;= </option>
							<option> = </option>
						</select>
						<input id="CLSumFE" type="text"/></td>
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td>% Capital Base(TD) : &nbsp;&nbsp;&nbsp;</td>
						<td>
						<select>
							<option> &#62;= </option>
							<option> &#60;= </option>
							<option> = </option>
						</select>
						<input id="CLcapBase" type="text"/></td>
					</tr>
					<tr>
						<td colspan="6">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="6" align="right">
							<button id="CLsubmitBtn" class="k-button" type="button">Search</button>
							<button id="CLresetBtn" type="button">Reset</button>
							<button id="CLexportBtn" type="button">Export</button>
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
			<div id="CLlrglist3"></div>
			<div id="CLlrglist4"></div>
			<div id="CLlrglist1"></div>
			<div id="CLlrglist2"></div>
		</div>
				<!--  ends-->
				
				<div id="limitThershold" style="display:none">
					<table style="width:50%;border: 3px solid #953735;">
						<tbody>
							<tr>
								<td style="width:30%; background-color:#DC8A98;">Capital Base</td>
								<td style="width: 30%;background-color: pink; text-align: end;" class="capBase"></td>
							</tr>
								<tr>
								<td style="width:30%; background-color:#DC8A98;">large Exposure 1st threshold %</td>
								<td style="width: 30%;background-color: pink; text-align: end;" class="threshold1"></td>
							</tr>
							<tr>
								<td style="width:30%; background-color:#DC8A98;">large Exposure 2nd threshold %</td>
								<td style="width: 30%;background-color: pink; text-align: end;" class="threshold2"></td>
							</tr>
							<tr>
								<td style="width:30%; background-color:#DC8A98;">large Exposure 3rd threshold</td>
								<td style="width: 30%;background-color: pink; text-align: end;" class="threshold3"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<br/><br/>
				<div id="limit"></div>
		
</html>
