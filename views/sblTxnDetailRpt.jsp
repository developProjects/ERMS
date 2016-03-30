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
			
					});
					
		//Displaying Data in the Grids
		function dataGrids(){
			//alert(true);
			$('#dailyReport').css('display', 'block');
			$(".empty-height").hide();
			openModal();
			var getSblTxnDetailURL =window.sessionStorage.getItem('serverPath')+"sbl/getSblTxnDetailRpt?userId="+window.sessionStorage.getItem('username');
			//var getSaveSblTxnDetailURL = window.sessionStorage.getItem('serverPath')+"sbl/saveSblTxnDetailRpt?userId="+window.sessionStorage.getItem('username');
			//var getSblTxnDetailURL = "/ermsweb/resources/js/getSblTxnDetailRpt.json";
			//var getSaveSblTxnDetailURL = "/ermsweb/resources/js/sbl/saveSblTxnDetailRpt.json";
			var activeDataSource = new kendo.data.DataSource({
												transport: {
													read: {
														url: getSblTxnDetailURL,
														
														dataType: "json",
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
						 allPages: true,
						 fileName:"SBL Txn Detail Report"
					},
					dataSource: activeDataSource,
						pageSize: 1,
						excelExport: function(e) {
							e.preventDefault();
							promises[1].resolve(e.workbook);
						},
				    			scrollable:true,
				    			pageable: true,
				    			navigatable: true,
				    			columns: [
				    			        { field: "txnDate", title: "Transaction Date", width: 150},
				    					{ field: "txnId", title: "Transaction ID" , width: 150},
				    					{field:"stockCode", title: "Stock Code", width:120},
				    					{field:"stockName", title: "Stock Name", width:120},
				    					{ field: "aeCode", title: "Business Unit and AE /Sales Code" , width: 120},
				    					{field:"borrowerCustIdName", title: "Stock Borrower and Client ID", width:120},
				    					{ field: "lenderCustIdName", title: "Stock Lender and Client ID", width: 120},
				    					{ field: "activityType", title: "Activity Type" , width: 120},
				    					{ field: "stockValue", title: "Stock Price HK$" , width: 120},
				    					{ field: "stockQty", title: "Stock Quantity" , width: 120},
				    					{ field: "loanValue", title: "Loan Value  HK$" , width: 120},
				    					{ field: "marginReqRatio", title: "Margin Requirement %" , width: 120},
				    					{ field: "feeRatio", title: "Fee %" , width: 120}
				    			]
		    			});
			closeModal();
		}

		function replaceEditable(data){
			//return "<input type='text' value='"+data+"'>";
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
				<div id="limitHeader" style="background-color:#B54D4D; color:#fff;margin-bottom: 30px; padding:4px 0px 4px 0px;">SBL TRANSACTION DETAILS REPORT</div>
				
				
<!-- Large Exposure Conditinal search criteria starts-->
			<div id="limitData">
			
			<button id="exportBtn">Export</button>
			</div> 
				<!--  ends-->
				<br/><br/>
				<div id="list"></div>
</html>
