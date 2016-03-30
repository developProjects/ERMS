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
			
			$("#searchBtn").kendoButton({
				click: function(){
					var input = $("input");
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
				}
			});
			
			

			
			$("#existingExpFrmDate").kendoDatePicker({
	  			format: "yyyy/MM/dd",
	  		});
	  		$("#existingExpToDate").kendoDatePicker({
	  			format: "yyyy/MM/dd",
	  		});
	  		$("#resetBtn").click(function(){
	  			var parent = $(this).closest(".form");
	  			parent.find('[data-role="datepicker"]').each(function(){
      				$(this).data("kendoDatePicker").value("");
      			}); 
	  			
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
		console.log(count);
		if (count>0){
			
			$("#"+checkId).find(".empty-height").hide();
		}else{
			$("#"+checkId).find(".empty-height").show();
		}
	}
	function dataGrids(){	
		var getActiveListDetailsURL = "/ermsweb/resources/js/alrbyBU.json";
		
		var activeDataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: getActiveListDetailsURL,
					dataType: "json"
					
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
			pageSize: 3
		});
		
		
		$("#active-list").kendoGrid({
			excel: {
				 allPages: true
			},
			dataSource: activeDataSource,
			pageable: true,
			columns:[
				{ field: "id.bizUnit",  template: '<span class="currency-span">#= bizDesc #</span> #=id.bizUnit # ', width: 200},    
				{ field: "id.isAutoInd", width: 120},
				{ field: "lastReviewCompeteDt", template: '#= kendo.toString( new Date(parseInt(lastReviewCompeteDt)), "yyyy/MM/dd HH:MM" )  #', width: 120},
				{ field: "id.scheduleEffDt", template: '#= kendo.toString( new Date(parseInt(id.scheduleEffDt)), "yyyy/MM/dd" )  #', width: 120},
				{ field: "existExpiryToDt", template: '<span class="currency-span">#= kendo.toString( new Date(parseInt(existExpiryFmDt)), "yyyy/MM/dd" ) #</span>- #=kendo.toString( new Date(parseInt(existExpiryToDt)), "yyyy/MM/dd" ) # ', width: 200},
				
			]
		});
		closeModal();
	}
    </script>
    <body>
    	<div class="boci-AnnualLimitTypeReviewSummary-wrapper">
    		<%-- <%@include file="header1.jsp"%> --%>
    		<div class="annualLimitReview-content-wrapper form">
					<div class="page-title">Annual Limit Review Summary (SCN-ALR-SUMMARY)</div>
					<div id="annual-filter-table-heading">Filter Criteria</div>	   
					<div class="annual-filter-criteria">
						<label class="">Existing Expiry Date (yyyy/mm/dd)</label> <input class="datemargin-left" id="existingExpFrmDate"/> to <input id="existingExpToDate"/>
						<div class="command-button-Section">
		    				<button id="searchBtn" class="k-button" type="button">Search</button>
		    				<button id="resetBtn" class="k-button" type="button">Reset</button>
	    				</div>
					</div>
					
					<div id="search_result_container">
						<div id="active-list-container">
							<table cellpadding="0" cellspacing="0" border="0" width="100%">
								<tr>
									<td>
										<div id="active-list">
											<table id="list-header" class="grid-container">
												<tr>
													<th>Business Unit</th>
													<th>Pending Limit Review by Front Office</th>
													<th>Pending Confirmation by RMD</th>
													<th>Completed Last Review</th>
													<th>Confirm to be Terminated</th>
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
