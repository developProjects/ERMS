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
			//var getLargeExpoMonURL = "/ermsweb/resources/js/getErmsLargeExpoMon.json?userId="+window.sessionStorage.getItem('username')+"&ccdId="+$('#ccdId').val();
			//var getLsfPeDlyMonEnqURL = "+window.sessionStorage.getItem('serverPath')+"sbl/getSblFailSettlementRpt?userId="+window.sessionStorage.getItem('username');
			//var getOverrideURL = "/ermsweb/resources/js/getSblDealerOverrideRpt.json";
			var getOverrideURL = window.sessionStorage.getItem('serverPath')+"sbl/getSblDealerOverrideRpt?userId=RISKADMIN";
			//hvar getsaveOverrideURL = "/ermsweb/resources/js/getSblDealerOverrideRpt.json";
			var getsaveOverrideURL =window.sessionStorage.getItem('serverPath')+"sbl/saveSblDealerOverrideRpt";
			var activeDataSource = new kendo.data.DataSource({
												transport: {
													read: {
														url: getOverrideURL,
														dataType: "json",
														
														xhrFields: {
									                    	withCredentials: true
									                    }
													},
													update: {
														dataType: "json",
						                                url:getsaveOverrideURL,
						                                complete: function (jqXHR, textStatus){
									var response = JSON.parse(jqXHR.responseText);
									if(response.action){
										if(response.action == "success"){
											window.sessionStorage.setItem('message', JSON.parse(jqXHR.responseText).message);
											window.location.href = "/ermsweb/accountDetailMaintenance";
										}
									}
									
								},
						                                xhrFields: {
						                                	withCredentials: true
						                                }
														//url:getsaveSblDlyMonEnqURL
						                            }, 
													parameterMap: function(options, operation) {
										                if (operation == "update") {
										                	return {
										                		tradeRef: options.tradeRef,
																userId : window.sessionStorage.getItem('username'),
																custId : options.custId,
																reportDate :converDateStrFormat(options.reportDate),
																riskMgtRemarks :options.riskMgtRemarks
															};
										                }
										            }
												},
					                            schema: {
					                            	  model: {
					                            		  id: "tradeRef",
					        							fields: {
					        										tradeRef: { type: "string", editable: false  },
					        										custId: { type: "string", editable: false },
					        										custName: { type: "string", editable: false },
					        										dealerCode: { type: "string", editable: false },
					        										overriddenField: { type: "string", editable: false },
					        										orgMarginRatio: { type: "string", editable: false },
					        										ovrMarginRatio: { type: "string", editable: false },
					        										orgHaircutRatio: { type: "string", editable: false },
					        										ovrHaircutRatio: { type: "string", editable: false },
					        										dealerComment: { type: "string", editable: false },
					        										riskMgtRemarks: { type: "string", editable: false },
					        										stockQty: { type: "string", editable: false },
					        										noOfDaysDailSettle: { type: "string", editable: false },
					        										riskMgtRemarks: { type: "string", editable: true },
					        										reportDate: { type: "string", editable: false }
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
						 fileName : "Dealer Override"
					},
					dataSource: activeDataSource,
						pageSize: 5,
						
				    			
				    			//toolbar: ["excel"],
				    			scrollable:true,
				    			pageable: true,
				    			columns: [
				    			        { field: "tradeRef", title: "Trade Reference", width: 150},
				    					{ field: "custId", title: "Customer ID" , width: 150},
				    					{ field: "custName", title: "Customer Name", width: 120},
				    					{ field: "dealerCode", title: "Dealer Code", width: 120},
				    					{ field: "overriddenField", title: "Overridden Field" , width: 120},
				    					{ field: "orgMarginRatio", title: "Original Value (Margin)" , width: 120},
				    					{ field: "ovrMarginRatio", title: "Overridden Value (Margin)" , width: 120},
				    					{ field: "orgHaircutRatio", title: "Original Value (Haircut)" , width: 120},
				    					{ field: "ovrHaircutRatio", title: "Overridden Value (Haircut)" , width: 120},
				    					{ field: "dealerComment", title: "Dealer Comment" , width: 120},
				    					{ field: "riskMgtRemarks", title: "Risk Mgt Remarks" , width: 120},
				    					{ field: "reportDate", title: "Report Date" , width: 120, template:"#=validDate(reportDate)#"},
				    					{ command: ["edit", "destroy"], title: "&nbsp;", width: 200 }
				    			],
				    			editable: "inline",
		    			});
			closeModal();
		}
		
		
		function validDate(obj){
			return kendo.toString( new Date(parseInt(obj)), "MM/dd/yyyy" )
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
					
		function converDateStrFormat(dateStr){
			console.log(dateStr);
			var date =  new Date(parseInt(dateStr));
		    return kendo.toString(date, "ddMMyyyy" );       
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
			<button id="exportBtn">Export</button>
			</div> 
				<!--  ends-->
				<br/><br/>
				<div id="list"></div>
</html>
