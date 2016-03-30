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
		var entityData = [
        						{ text: "ALL", value: "ALL" },          
        						{ text: "BOCI", value: "BOCI" },       
        						{ text: "BOCIL", value: "BOCIL" },
        						{ text: "BOCIS", value: "BOCIS" },
        						{ text: "BOCIFP", value: "BOCIFP" },
        						{ text: "BOCIGC", value: "BOCIGC" },
        						{ text: "BOCI Finance", value: "BOCI Finance" },
        					
                  		      ];
		
				$('#entityList').kendoDropDownList({
					optionLabel: "Select",
					dataTextField: "text",
					dataValueField: "value",
					dataSource: entityData,
					index:0
				}); 
				
				var currencyData = new kendo.data.DataSource({
        			transport: {
        				read: {
        					url: window.sessionStorage.getItem('serverPath')+"common/getCcyList",
        					dataType: "json",
        					xhrFields: {
                              withCredentials: true
                             },
        					type:"GET"
        					
        				}
        			}
        		});
				
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
				
				
				$("#countryId").kendoDropDownList({
					optionLabel: "Select",
					dataTextField: "dataField",
					dataValueField: "dataField",
					dataSource:countryData,
					 change: function(e) {
					    index = $('#countryId').data('kendoDropDownList').select();
						$("#countryName").html(countryData._data[index-1].dataText);
						console.log(countryData._data[index-1].dataText);
					  //  var text = item.text();
					    // Use the selected item or its text
					  }, 
					index:0
				}); 
				
				$('#lmtCcy').kendoDropDownList({
					optionLabel: "Select",
					dataTextField: "dataText",
					dataValueField: "dataField",
					dataSource:currencyData,
					index:0
				}); 
				
				$('#lmtInCapital').kendoNumericTextBox({
					min: 0,
                    max: 100, 
                    spinners: false
				});
				
				$('#lmtAmt').kendoNumericTextBox({
					min: 0,
                    spinners: false
				});
				
        		$("#resetBtn").click(function(){
        			$("input[type='text']").val("");
        			$("#entityList").data("kendoDropDownList").value("");
        			$("#lmtCcy").data("kendoDropDownList").value("");
        			$("#lmtAmt").data("kendoNumericTextBox").value("");
        			$("#lmtAmt").data("kendoNumericTextBox").enable(true);
        			$("#mtInCapital").data("kendoNumericTextBox").value("");
        			
        		}); 
          		
        		$('#lmtInCapital').on("blur", function() {
                    var perValue = $(this).val();
                    if(perValue != ""){
                    	$("#lmtAmt").data("kendoNumericTextBox").value("");
                    	$("#lmtAmt").data("kendoNumericTextBox").enable(false);                        	
                    }else{
                    	$("#lmtAmt").data("kendoNumericTextBox").enable(true);
                    }
                });
        		
				 var countrydataSource = new kendo.data.DataSource({
	    				transport: {
	    					create: {
	    			            url:window.sessionStorage.getItem('serverPath')+"countrylmt/save",
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
	    				 	model:{
	    						id:"crId"
	    					} 
	    				}
	    				
	    			
	    			});
				 
					
				// Validators    		
          		var validator = $("#countryRating_form").kendoValidator().data("kendoValidator");	
				 
				 $("#saveBtn").kendoButton({
						click: function(){
								var newCountryLimit = {
										
										countryId:$("#countryId").data("kendoDropDownList").value(),
										countryName:$("#countryName").text(),
										entity:$("#entityList").data("kendoDropDownList").value(),
										lmtCcy:$("#lmtCcy").data("kendoDropDownList").value(),
										lmtAmt:$("#lmtAmt").data("kendoNumericTextBox").value(),
										lmtInCapital:$("#lmtInCapital").data("kendoNumericTextBox").value(),
		                       			 crStatus: "Saved",
		                       			 userId:window.sessionStorage.getItem("username"),
		                       			 crAction: "CREATE"	
								};
								countrydataSource.transport.options.create.url= window.sessionStorage.getItem('serverPath')+"countrylmt/save";
								countrydataSource.add(newCountryLimit);
								countrydataSource.sync();
							
						}
					});
					
					$("#submitBtn").kendoButton({
						click: function(){
								var newCountryLimit = {
										countryId:$("#countryId").data("kendoDropDownList").value(),
										countryName:$("#countryName").text(),
										entity:$("#entityList").data("kendoDropDownList").value(),
										lmtCcy:$("#lmtCcy").data("kendoDropDownList").value(),
										lmtAmt:$("#lmtAmt").data("kendoNumericTextBox").value(),
										lmtInCapital:$("#lmtInCapital").data("kendoNumericTextBox").value(),
										userId:window.sessionStorage.getItem("username"),
		                       			 crStatus: "Submit",
		                       			 crAction: "CREATE"	
								};
								countrydataSource.transport.options.create.url= window.sessionStorage.getItem('serverPath')+"countrylmt/submit";
								countrydataSource.add(newCountryLimit);
								countrydataSource.sync();
							
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
			window.location = "/ermsweb/countryLimitMaintenance";
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
					<div class="page-title">Maintenance  - Country Limit Maintenance (Collateral) - Create Country Limit (Collateral)</div>	    		
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
	   								<input id="countryId" type="text" class="k-textbox" value="" name="countryId"></input>
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
	   							<td>Entity</td>
	   							<td>
	   								<input id="entityList" name="entity" />
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Limit CCY</td>
	   							<td>
	   								<input id="lmtCcy" name="limitccy" />
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Limit Amount</td>
	   							<td>
	   								<input type="text" id="lmtAmt"  name="lmtAmt" />
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Limit in % of Capital</td>
	   							<td>
	   								<input id="lmtInCapital"    name="lmtInCapital" /> %
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
    