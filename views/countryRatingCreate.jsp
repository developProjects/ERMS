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
    	
    	$(".empty-height").hide();
    	
		//Dropdowns and Date realted code //
				var countryData = new kendo.data.DataSource({
	    			transport: {
	    				read: {
	    					url: window.sessionStorage.getItem('serverPath')+"common/getCountryList?userId="+window.sessionStorage.getItem("username"),
	    					dataType: "json",
	    					xhrFields: {
	                          withCredentials: true
	                         },
	    					type:"GET"
	    					
	    				}
	    			}
	    		});
				$("#countryList").kendoDropDownList({
					optionLabel: "Select",
					dataTextField: "dataField",
					dataValueField: "dataField",
					dataSource:countryData,
					 change: function(e) {
						//alert("change");
					    index = $('#countryList').data('kendoDropDownList').select();
						$("#countryName").html(countryData._data[index-1].dataText);
						//console.log(countryData._data[index-1].dataText);
					  //  var text = item.text();
					    // Use the selected item or its text
					  }, 
					index:0
				});
				
				$('#inrEffectiveDt').kendoDatePicker({
					
				});
			
        		$("#resetBtn").click(function(){
        			$("input[type='text']").val("");
        			$("#countryList").data("kendoDropDownList").value("");
        			$("#inrEffectiveDt").data("kendoDatePicker").value("");
        			
        		}); 
          		
				 var countrydataSource = new kendo.data.DataSource({
	    				transport: {
	    					create: {
	    			            url:window.sessionStorage.getItem('serverPath')+"countryRating/save",
	    			            type: "post",
	    			            dataType: "json",
	    			            contentType: "application/json; charset=utf-8", 
	    			            complete: function (jqXHR, textStatus){
	    							var response = JSON.parse(jqXHR.responseText);
	    							if(response.action=="success"){
	    								toBack();
	    							}else{
	    								$(".confirm-del").html(response.message);
	    							}
	    						},
	    						xhrFields: {
	    			                withCredentials: true
	    			               }
	    			        },
	    	                 parameterMap: function(options, operation) {                                 
	                             // note that you may need to merge that postData with the options send from the DataSource
	                           return JSON.stringify(options);                                 
	                    	}
	    				},
	    				error:function(e){
							if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
						},
	    				schema:{
	    					type: 'json',
	    				 	model:{
	    						id:"crId"
	    					} 
	    				}
	    				
	    			
	    			});
				 
					
					// Validators    		
	          		var validator = $("#countryRating_form").kendoValidator().data("kendoValidator");	
				 
				 $("#saveBtn").kendoButton({
						click: function(){
							if (validator.validate()) {
								var newCountryRating = {
										countryId:$("#countryList").data("kendoDropDownList").value(),
										countryName:$("#countryName").text(),
										bbgTicker:$("#bbgTicker").val(),
										creditRatingInr:$("#creditRatingInr").val(),
										creditRatingInrDesc:$("#creditRatingInrDesc").val(),
										inrEffectiveDt:converDateStrFormat($("#inrEffectiveDt").val()),
		                       			 crStatus: "Saved",
		                       			userId:window.sessionStorage.getItem("username"),
		                       			 crAction: "CREATE"	
								};
								countrydataSource.transport.options.create.url= window.sessionStorage.getItem('serverPath')+"countryRating/save";
								//console.log(newCountryRating);
								countrydataSource.add(newCountryRating);
								countrydataSource.sync();
							}
						}
					});
					
					$("#submitBtn").kendoButton({
						click: function(){
							if (validator.validate()) {
								var newCountryRating = {
										countryId:$("#countryList").data("kendoDropDownList").value(),
										bbgTicker:$("#bbgTicker").val(),
										countryName:$("#countryName").text(),
										creditRatingInr:$("#creditRatingInr").val(),
										creditRatingInrDesc:$("#creditRatingInrDesc").val(),
										inrEffectiveDt:converDateStrFormat($("#inrEffectiveDt").val()),
										userId:window.sessionStorage.getItem("username"),
		                       			 crStatus: "Submit",
		                       			 crAction: "CREATE"	
								};
								countrydataSource.transport.options.create.url= window.sessionStorage.getItem('serverPath')+"countryRating/submit";
								//console.log(newCountryRating);
								countrydataSource.add(newCountryRating);
								countrydataSource.sync();
							}
						}
					});
					
				
    					 
          		
          	
          		
    	          		
    	});
    
	    /* Open spinner while getting the data from back-end*/
		function openModal() {
			$("#modal, #modal1, #modal2, #modal3").show();
		}
		/* Close spinner after getting the data from back-end*/
		function closeModal() {
			$("#modal, #modal1, #modal2, #modal3").hide();	    
		}
	
		function validDate(obj){
	    	return kendo.toString( new Date(parseInt(obj)), "MM/dd/yyyy HH:MM:tt" )
	    }
		function validateResponse(data){
			return (data != null) ? data : "";
		}
		function toBack(){
			//window.history.back();
			window.location = "/ermsweb/countryRatingMaintenance";
		}
		
		function converDateStrFormat(dateStr){
		 	var date = Date.parse(dateStr);
		 	return kendo.toString( new Date(parseInt(date)), "ddMMyyyyHHmms" );	
		}
		
    </script>
    <body>
    	<div class="boci-limitType-wrapper">
    		<header>
    		
    		</header>
    		<div class="createLimit-content-wrapper form">
    			<form id="countryRating_form">
					<div class="page-title">Maintenance  - Country Rating Maintenance (Collateral) - Create New Country Rating (Collateral)</div>	    		
	    			<div class="command-button-Section">
	    				<button id="saveBtn" class="k-button" type="button">Save</button>
	    				<button id="submitBtn" class="k-button" type="button">Submit</button>
	    				<button id="resetBtn" class="k-button toClear" type="button">Reset</button>
	    				<button id="backBtn" class="k-button" type="button" onclick="toBack()">Back</button>
	    			</div>
	    			<div class="confirm-del"></div>
	    			<div class="clear"></div>
	    			<div class="limitType-details">
	   					<div class="limitType-details-header">Country Details </div>
	   					<table>
	   						<tr>
	   							<td>Country</td>
	   							<td>
	   								<input id="countryList" default-attr="" value="" name="countryList"></input>
	   							</td>
	   							
	   						</tr>
	   						<tr>
	   							<td>
	   								Country Name
	   							</td>
	   							<td>
	   								<div id="countryName"></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Country BBG Ticker</td>
	   							<td>
	   								<input type="text" id="bbgTicker" class="k-textbox"   name="bbgTicker" />
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Internal Rating</td>
	   							<td>
	   								<input type="text" id="creditRatingInr" class="k-textbox"   name="InternalRating" />
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Internal Rating Description</td>
	   							<td>
	   								<input type="text" id="creditRatingInrDesc" class="k-textbox"   name="InternalRatingDesc" />
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>
	   								S&P Rating
	   							</td>
	   							<td>
	   								<div id="creditRatingSnp"></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>
	   								Moody's Rating
	   							</td>
	   							<td>
	   								<div id="creditRatingMoodys"></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>
	   								Fitch Rating
	   							</td>
	   							<td>
	   								<div id="creditRatingFitch"></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>
	   								Effective Date (Internal Rating)
	   							</td>
	   							<td>
	   								<input id="inrEffectiveDt"/>
	   							</td>
	   						</tr>
	   						
	   					</table>
	    			</div>
	    			
	    			</form>
	    			
	    	
	    		<div class="audit-details-section">
					<table>
					<tr>
						<td>Created By</td>
						<td><label id="created_by"></label></td>
						<td></td>
						<td></td>
						<td>Created At</td>
						<td><label id="created_at"></label></td>
					</tr>
					<tr>
						<td>Updated By</td>
						<td><label id="updated_by"></label></td>
						<td></td>
						<td></td>
						<td>Updated At</td>
						<td><label id="updated_at"></label></td>
					</tr>
					<tr>
						<td>Verified By</td>
						<td><label id="verified_by"></label></td>
						<td></td>
						<td></td>
						<td>Verified At</td>
						<td><label id="verified_at"></label></td>
					</tr>
					<tr>
						<td>Action</td>
						<td><label id="action"></label></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</table>
				</div>
    			
    		</div>
    	
    	
    	</div>

    </body>
    </html>
    