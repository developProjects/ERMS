<!DOCTYPE html>
<html lang="en">
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
    <!-- jQuery JavaScript -->
    <script src="/ermsweb/resources/js/jquery.min.js"></script>

  <!--   <script src="/ermsweb/resources/js/jszip.js"></script> -->
    <!-- Kendo UI combined JavaScript -->
    
    <!-- <script src="http://kendo.cdn.telerik.com/2014.3.1029/js/kendo.all.min.js"></script> -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
    
    <script>
    $(document).ready(function(){
			$(".empty-height").show();
			
			
			var getActiveListDetailsURL = window.sessionStorage.getItem('serverPath')+"annualLimitReview/getAlrSchedule?userId="+window.sessionStorage.getItem('username');
			
			
			var activeDataSource = new kendo.data.DataSource({
				transport: {
					read: {
						url: getActiveListDetailsURL,
						//"+window.sessionStorage.getItem('serverPath')+"annualLimitReview/getAlrSchedule?userId=ABC
						dataType: "json",
						xhrFields: {
	                        withCredentials: true
	                       }
					}
				},
				error:function(e){
					if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
				},
				schema: {                               // describe the result format
		            data: function(data) {              // the data which the data source will be bound to is in the values field
		                //console.log(data);
		                return data;
		            },
		            model:{
						id:"id"
					} 
		        },
				pageSize: 2
			});
			
			/* $.each(activeDataSource, function( key, value ) {
				window.sessionStorage.prototype.setObj = function(key, value) {
				    return this.setItem(key, JSON.stringify(value))
				}
			}); */
			
			
			
			
			var getcRListDetailsURL = window.sessionStorage.getItem('serverPath')+"annualLimitReview/getAlrScheduleCr?userId="+window.sessionStorage.getItem('username');
			
			var crDataSource = new kendo.data.DataSource({
				transport: {
					read: {
						url: getcRListDetailsURL,
						xhrFields: {
	                        withCredentials: true
	                       },
						
						//"+window.sessionStorage.getItem('serverPath')+"annualLimitReview/getAlrScheduleCr?userId=ABC
						dataType: "json"
					}, 
					update:{
						type:"GET",
						//url: "/ERMSCore/annualLimitReview/doActionAlrScheduleCr",
						url:window.sessionStorage.getItem('serverPath')+"annualLimitReview/doActionAlrScheduleCr",
						dataType: "json",
						xhrFields: {
	                        withCredentials: true
	                       },
						contentType:"application/json",
						complete: function (jqXHR, textStatus){
							var response = JSON.parse(jqXHR.responseText);
							if(response.action){
								if(response.action == "success"){
									$(".confirm-del").html(response.message);
								window.location = "/ermsweb/annualLimitReviewProcess";
								}
							}
							
						}
						
					},
					destroy:{
						type:"GET",
						//url: "/ERMSCore/annualLimitReview/doActionAlrScheduleCr",
						url:window.sessionStorage.getItem('serverPath')+"annualLimitReview/doActionAlrScheduleCr",
						dataType: "json",
						xhrFields: {
	                        withCredentials: true
	                       },
						contentType:"application/json",
						complete: function (jqXHR, textStatus){
							var response = JSON.parse(jqXHR.responseText);
							if(response.action){
								if(response.action == "success"){
									$(".confirm-del").html(response.message);
								window.location = "/ermsweb/annualLimitReviewProcess";
								}
							}
							
						}
					},
					parameterMap: function(options, operation) {
					      if (operation != "read") {
					     	return kendo.stringify(options);//JSON.stringify(options);
							}
						}
					
				},
				error:function(e){
					if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
				},
				schema: {                               // describe the result format
		            data: function(data) {              // the data which the data source will be bound to is in the values field
		                //console.log(data);
		                return data;
		            },
		            model:{
						id:"crId"
					} 
		        },
				pageSize: 3
			});
			
			
			
			
			
			var getGroupListDetailsURL = window.sessionStorage.getItem('serverPath')+"annualLimitReview/getAlrScheduleByGrp?userId="+window.sessionStorage.getItem('username');
			
			var groupDataSource = new kendo.data.DataSource({
				transport: {
					read: {
						url: getGroupListDetailsURL,
						//"+window.sessionStorage.getItem('serverPath')+"annualLimitReview/getAlrScheduleByGrp?userId=abc
						dataType: "json",
						xhrFields: {
	                        withCredentials: true
	                       }
						}
					
				},
				error:function(e){
					if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
				},
				schema: {                               // describe the result format
		            data: function(data) {              // the data which the data source will be bound to is in the values field
		                //console.log(data);
		                return data;
		            },
		            model:{
						id:"batchId"
					} 
		        },
				pageSize: 3
			});
			
		
			
			
			
			
			$("#active-list").kendoGrid({
				excel: {
					 allPages: true
				},
				dataSource: activeDataSource,
				pageable: true,
				columns:[
					{ field: "" ,title:"", command:{text:"Start Annual Review",click: showDetails},width: 160},
					{ field: "id.bizUnit",  template: '<span class="currency-span">#= bizDesc #</span> #=id.bizUnit # ', width: 200},    
					{ field: "id.isAutoInd", width: 120},
					{ field: "lastReviewCompeteDt", template: '#= kendo.toString( new Date(parseInt(lastReviewCompeteDt)), "yyyy/MM/dd HH:MM" )  #', width: 120},
					{ field: "id.scheduleEffDt", template: '#= kendo.toString( new Date(parseInt(id.scheduleEffDt)), "yyyy/MM/dd" )  #', width: 120},
					{ field: "existExpiryToDt", template: '<span class="currency-span">#= kendo.toString( new Date(parseInt(existExpiryFmDt)), "yyyy/MM/dd" ) #</span>- #=kendo.toString( new Date(parseInt(existExpiryToDt)), "yyyy/MM/dd" ) # ', width: 200},
					{ field: "newExpiryDt", template: '#= kendo.toString( new Date(parseInt(newExpiryDt)), "yyyy/MM/dd" )  #', width: 120},
					{ field: "Acct", width: 120},
					{ field: "exclAcctStatusList",  width: 120},
					{ field: "isNormalApprFlowInd", width: 120},
					{ field: "alrStatus", width: 120},
					{ field: "lastUpdateDt",template: '#= kendo.toString( new Date(parseInt(lastUpdateDt)), "yyyy/MM/dd HH:MM" )  #', width: 120}
				],
				dataBound: function (e) {
					var grid = $("#active-list").data("kendoGrid");
		            var gridData = grid.dataSource.view();
		            for (var i = 0; i < gridData.length; i++) {
		                var currentUid = gridData[i].uid;
		                //alert(gridData[i].id.isAutoInd);
		                if (gridData[i].id.isAutoInd != 'N') {
		                	
		                    var currenRow = grid.table.find("tr[data-uid='" + currentUid + "']");
		                    var reviewButton = $(currenRow).find(".k-button");
		              		reviewButton.hide();
		                }
		            }
				}
			});
			
			/* activeDataSource.fetch(function(){
				var jsonObj = this.view();
				$.each(jsonObj, function(i){
					if(jsonObj[i].id.isAutoInd == "Y"){
						$(".k-grid-StartAnnualReview").hide();
					}	
				});
				
			}); */
			
			
			$("#cr-list").kendoGrid({
				excel: {
					 allPages: true
				},
				dataSource: crDataSource,
				pageable: true,
				columns:[
					{ field: "crId",template: '<input type="checkbox" value="#=crId#" class="" name=""/>', width: 120},    
					{ field: "bizUnit",  template: '<span class="currency-span">#= bizDesc #</span> #=bizUnit # ', width: 200},    
					{ field: "isAutoInd", width: 120},
					{ field: "scheduleEffDt", template: '#= kendo.toString( new Date(parseInt(scheduleEffDt)), "yyyy/MM/dd" )  #', width: 120},
					{ field: "existExpiryToDt", template: '<span class="currency-span">#= kendo.toString( new Date(parseInt(existExpiryFmDt)), "yyyy/MM/dd" ) #</span>- #=kendo.toString( new Date(parseInt(existExpiryToDt)), "yyyy/MM/dd" ) # ', width: 200},
					{ field: "newExpiryDt", template: '#= kendo.toString( new Date(parseInt(newExpiryDt)), "yyyy/MM/dd" )  #', width: 120},
					{ field: "Acct", width: 120},
					{ field: "exclAcctStatusList",  width: 120},
					{ field: "isNormalApprFlowInd", width: 120},
					{ field: "crBy", width: 120},
					{ field: "crDt",template: '#= kendo.toString( new Date(parseInt(crDt)), "yyyy/MM/dd HH:MM" )  #', width: 120},
					
					
				]
			});
			
			$("#group-list").kendoGrid({
				excel: {
					 allPages: true
				},
				dataSource: groupDataSource,
				pageable: true,
				columns:[
				         
					{ field: "rmdGroupDesc", width: 120},
					{ field: "nextReviewDate", template: '#= kendo.toString( new Date(parseInt(nextReviewDate)), "yyyy/MM/dd" )  #', width: 120},
					{ field: "isAutoInd", width: 120},
					{ field: "lastReviewCompeteDt", template: '#= kendo.toString( new Date(parseInt(lastReviewCompeteDt)), "yyyy/MM/dd HH:MM" )  #', width: 120},
					{ field: "scheduleEffDt", template: '#= kendo.toString( new Date(parseInt(scheduleEffDt)), "yyyy/MM/dd" )  #', width: 120},
					{ field: "existExpiryToDt", template: '<span class="currency-span">#= kendo.toString( new Date(parseInt(existExpiryFmDt)), "yyyy/MM/dd" ) #</span>- #=kendo.toString( new Date(parseInt(existExpiryToDt)), "yyyy/MM/dd" ) # ', width: 200},
					{ field: "newLmtExpiryDate", template: '#= kendo.toString( new Date(parseInt(newLmtExpiryDate)), "yyyy/MM/dd" )  #', width: 120},
					{ field: "newLmtAmt", width: 120},
					{ field: "exclAcctStatusList",  width: 120},
					{ field: "isNormalApprFlowInd", width: 120},
					{ field: "alrStatus", width: 120},
					{ field: "lastUpdateDt",template: '#= kendo.toString( new Date(parseInt(lastUpdateDt)), "yyyy/MM/dd HH:MM" )  #', width: 120},
								
				]
			});
			
			$("#approveBtn").kendoButton({
				click: function(){
					
					var grid = $('#cr-list').data("kendoGrid");
					var gridDs = grid.dataSource;
					var rows = $('#cr-list :checkbox:checked');
					var rowId = $('#cr-list :checkbox:checked').closest("tr").attr("data-uid");
				    var items = [];
				    
				    
				   if(rows.length == 1){
				    	$.each(rows, function (idx, element) {
					        var item = grid.dataItem($(this).closest("tr"));
					        items.push(item);					        					        
					    });
					
				    	$.each(items, function(idx, elem) {
					        elem.set("crAction", "A");
					        elem.set("funcId","");
					        elem.set("userId",window.sessionStorage.getItem("username"));
					        crDataSource.remove(elem);
					    });			
				    						    					    
				    }else if (rows.length == 0){
				    	alert("Select a Row to Approve");
				    }else{
				    	alert("Select One Row At a Time to Approve");
				    }
				   crDataSource.sync();
				}
  		 
			 });
			
			$("#rejectBtn").kendoButton({
				click: function(){
					var grid = $('#cr-list').data("kendoGrid");
					var gridDs = grid.dataSource;
					var rows = $('#cr-list :checkbox:checked');
					var rowId = $('#cr-list :checkbox:checked').closest("tr").attr("data-uid");
				    var items = [];
				       
				    
				   if(rows.length == 1){
				    	$.each(rows, function (idx, element) {
					        var item = grid.dataItem($(this).closest("tr"));
					        items.push(item);					        					        
					    });
					
				    	$.each(items, function(idx, elem) {
					        elem.set("crAction", "J");
					        elem.set("funcId","");
					        elem.set("userId",window.sessionStorage.getItem("username"));
					        crDataSource.remove(elem);
					    });			
				    						    					    
				    }else if (rows.length == 0){
				    	alert("Select a Row to Reject");
				    }else{
				    	alert("Select One Row At a Time to Reject");
				    }
				   crDataSource.sync();
				}
  		 
  		 
			 });
			
			
		
    });
    function openModal() {
	     $("#modal, #modal1").show();
	}

	function closeModal() {
	    $("#modal, #modal1").hide();	    
	}
	function emptyHeight(checkId){
		
		var count = $("#"+checkId).data("kendoGrid").dataSource.total();
		if (count>0){
			
			$("#"+checkId).find(".empty-height").hide();
		}else{
			$("#"+checkId).find(".empty-height").show();
		}
	}
	function showDetails(e){
		var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
	
		window.sessionStorage.setItem("activeData",JSON.stringify(dataItem));
		
		e.preventDefault();
		window.location = "/ermsweb/annualLimitReviewDetails?inline=true";
		
	}
    </script>
    <body>
    	<div class="boci-AnnualLimitTypeReview-wrapper">
    		<%-- <%@include file="header1.jsp"%> --%>
    		<div class="annualLimitReview-content-wrapper">
					<div class="page-title">Annual Limit Review Process (SCN-ALR-PROCESS)</div>
	    			<div class="command-button-Section">
	    				<a href="annualLimitReviewDetails?" id="adhocALRBtn" class="k-button">Ad hoc Annual Limit Review</a>
	    			</div>
	    			<div class="clear"></div>
	    			
	    			<div id="search_result_container">
						<div id="active-list-container">
							<table cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td colspan="8">
										<div class="list-header">Annual Limit Review By Business Unit Section</div>
									</td>
								</tr>
								<tr>
									<td>
										<div id="active-list">
											<table id="list-header" class="grid-container">
												<tr>
													<th></th>
													<th>Business Unit</th>
													<th>Automated</th>
													<th>Last Review Completion Time (yyyy/mm/dd hi:mm)</th>
													<th>Schedule Date (yyyy/mm/dd)</th>
													<th>Existing Expiry Date(yyyy/mm/dd - yyyy/mm/dd)</th>
													<th>New Expiry Date(yyyy/mm/dd)</th>
													<th>New Limit Amount</th>
													<th>Exclude Account Status</th>
													<th>Go through the Normal Limit Review Flow ?</th>
													<th>Status</th>	
													<th>Update Time(yyyy/mm/dd hi:mm)</th>
																							
												</tr>								
											</table>		
																
										</div>
										
										<div id="modal">
											<img id="loader" src="images/ajax-loader.gif" />
										</div>						
									</td>
								</tr>					
							</table>
						</div>
    	
    			</div>
    			
    			<div class="command-button-Section">
	    				<button id="approveBtn" class="k-button" type="button">Approve</button>
	    				<button id="rejectBtn" class="k-button" type="button">Reject</button>
	    		</div>
	    		<div class="confirm-del"></div>
	    		<div class="clear"></div>
	    		<div id="search_result_container">
						<div id="cr-list-container">
							<table cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td colspan="8">
										<div class="list-header">Pending Request</div>
									</td>
								</tr>
								<tr>
									<td>
										<div id="cr-list">
											<table id="list-header" class="grid-container">
												<tr>
												<th></th>
													<th>Business Unit</th>
													<th>Automated</th>
													<th>Schedule Date (yyyy/mm/dd)</th>
													<th>Existing Expiry Date(yyyy/mm/dd - yyyy/mm/dd)</th>
													<th>New Expiry Date(yyyy/mm/dd)</th>
													<th>New Limit Amount</th>
													<th>Exclude Account Status</th>
													<th>Go through the Normal Limit Review Flow ?</th>
													<th>Updated by</th>	
													<th>Update At(yyyy/mm/dd hi:mm)</th>
																							
												</tr>								
											</table>
																		
										</div>
										
										<div id="modal">
											<img id="loader" src="images/ajax-loader.gif" />
										</div>						
									</td>
								</tr>					
							</table>
						</div>
    				</div>
    				
	    			<div id="search_result_container">
						<div id="active-list-container">
							<table cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td colspan="8">
										<div class="list-header">Annual Limit Review by Group</div>
									</td>
								</tr>
								<tr>
									<td>
										<div id="group-list">
											<table id="list-header" class="grid-container">
												<tr>
													<th>Group Name</th>
													<th>Next Review Date</th>
													<th>Automated</th>
													<th>Last Review Completion Time (yyyy/mm/dd hi:mm)</th>
													<th>Schedule Date (yyyy/mm/dd)</th>
													<th>Existing Expiry Date(yyyy/mm/dd - yyyy/mm/dd)</th>
													<th>New Expiry Date(yyyy/mm/dd)</th>
													<th>New Limit Amount</th>
													<th>Exclude Account Status</th>
													<th>Go through the Normal Limit Review Flow ?</th>
													<th>Status</th>	
													<th>Update Time(yyyy/mm/dd hi:mm)</th>
																							
												</tr>								
											</table>		
																
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
    