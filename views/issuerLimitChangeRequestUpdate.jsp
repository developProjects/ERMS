<!DOCTYPE html>
<html lang="en">
	<meta http-equiv="Content-Style-Type" content="text/css">
    <meta http-equiv="Content-Script-Type" content="text/javascript">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 
    <script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>
    <script type="text/javascript" src="/ermsweb/resources/js/common_tools.js"></script>
   

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
    	
    	
		var crId = getURLParameters('crId');
		
				
				//Dropdowns and Date realted code //
				
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
		
				$('#lmtCcy').kendoDropDownList({
					optionLabel: "Select",
					dataTextField: "dataText",
					dataValueField: "dataField",
					dataSource: currencyData,
					index:0
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
						//alert("change");
					    index = $('#countryId').data('kendoDropDownList').select();
						$("#countryName").html(countryData._data[index-1].dataText);
						//console.log(countryData._data[index-1].dataText);
					  //  var text = item.text();
					    // Use the selected item or its text
					  }, 
					index:0
				});
				$('#lmtInLoan').kendoNumericTextBox({
					min: 0,
                    max: 100, 
                    spinners: false
				});
				
				$('#lmtAmt').kendoNumericTextBox({
					min: 0,
                    spinners: false
				});
				
        		
        		$('#lmtInLoan').on("blur", function() {
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
	    					read: {
	    						//url:"/ermsweb/resources/js/getissuerLimitRecord.json",
	    						url: window.sessionStorage.getItem('serverPath')+"issuerlmt/getRecord?crId="+crId+"&userId="+window.sessionStorage.getItem("username"),
	    						dataType: "json",
	    						xhrFields : {
	    							withCredentials : true
	    						},
	    						
	    						type:"GET"
	    						
	    					},
	    					update: {
	    			            url:window.sessionStorage.getItem('serverPath')+"issuerlmt/save",
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
	    				schema: {                               // describe the result format
	    			        data: function(data) {              // the data which the data source will be bound to is in the values field
	    			            return [data];
	    			        },
	    			        model:{
	    			        	id:"crId"
	    			        }
	    			    }		
	    				
	    			
	    			});
				 
				 countrydataSource.fetch(function(){
						var jsonObj = this.view();
						$.each(jsonObj, function(i){
								
								$("#issuerCode").html("<label>"+validateResponse(jsonObj[i].issuerCode)+"</label>");
								$("#issuerName").html("<label>"+validateResponse(jsonObj[i].issuerName)+"</label>");
								$("#countryId").data("kendoDropDownList").value(validateResponse(jsonObj[i].countryId));
								$("#countryName").html("<label>"+validateResponse(jsonObj[i].countryName)+"</label>");
								$("#lmtCcy").data("kendoDropDownList").value(validateResponse(jsonObj[i].lmtCcy));
								$('#lmtAmt').data("kendoNumericTextBox").value(validateResponse(jsonObj[i].lmtAmt)),
								$('#lmtInLoan').data("kendoNumericTextBox").value(validateResponse(jsonObj[i].lmtInCapital)),
								$(".command-button-Section").html("<button id=\"saveBtn\"  type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" >Save</button></label> <label><button id=\"submitBtn\"  type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" >Submit</button></label> <label><button id=\"resetBtn\"  type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" >Reset</button></label> <label><button id=\"discardBtn\"  type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" onclick=\"toDiscard('"+jsonObj[i].countryId+"')\">Discard</button></label> <label><button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Back</button>");
								$("#verifierRemarks").html(jsonObj[i].crRemark);
								$("#created_by").html(validateResponse(jsonObj[i].createBy));
								$("#created_at").html(validateResponse(validDate(jsonObj[i].createDt)));
								$("#updated_by").html(validateResponse(jsonObj[i].lastUpdateBy));
								$("#updated_at").html(validateResponse(validDate(jsonObj[i].lastUpdateDt)));
								$("#verified_by").html(validateResponse(jsonObj[i].verifyBy));
								$("#verified_at").html(validateResponse(validDate(jsonObj[i].verifyDt)));
								$("#crAction").html(validateResponse(jsonObj[i].action));
						});
						
						$("#resetBtn").click(function(){
		        			$("input[type='text']").val("");
		        			$("#lmtCcy").data("kendoDropDownList").value("");
		        			$("#countryId").data("kendoDropDownList").value("");
		        			$("#lmtAmt").data("kendoNumericTextBox").value("");
		        			$("#lmtAmt").data("kendoNumericTextBox").enable(true);
		        			$("#mtInLoan").data("kendoNumericTextBox").value("");
		        			
		        		}); 

						// Validators    		
		          		var validator = $("#countryRating_form").kendoValidator().data("kendoValidator");	
					 
		          		 $("#saveBtn").kendoButton({
								click: function(){
										if (validator.validate()) {
										
										var dataDatasource = countrydataSource.at(0);
										countrydataSource.transport.options.update.url= window.sessionStorage.getItem('serverPath')+"issuerlmt/save";
										dataDatasource.set("lmtCcy",$("#lmtCcy").data("kendoDropDownList").value());
										dataDatasource.set("countryId",$("#countryId").data("kendoDropDownList").value());
										dataDatasource.set("lmtAmt",$("#lmtAmt").data("kendoNumericTextBox").value());
										dataDatasource.set("lmtInLoan",$("#lmtInLoan").data("kendoNumericTextBox").value());
										dataDatasource.set("crStatus","Saved");
										dataDatasource.set("crAction","UPDATE");
										dataDatasource.set("countryName",$("#countryName").text());
										dataDatasource.set("userId",window.sessionStorage.getItem("username"));
										countrydataSource.sync();
									}
								}
							});
							
							$("#submitBtn").kendoButton({
								click: function(){
									if (validator.validate()) {
										
										var dataDatasource = countrydataSource.at(0);
										countrydataSource.transport.options.update.url= window.sessionStorage.getItem('serverPath')+"issuerlmt/submit";
										dataDatasource.set("lmtCcy",$("#lmtCcy").data("kendoDropDownList").value());
										dataDatasource.set("countryId",$("#countryId").data("kendoDropDownList").value());
										dataDatasource.set("lmtAmt",$("#lmtAmt").data("kendoNumericTextBox").value());
										dataDatasource.set("lmtInLoan",$("#lmtInLoan").data("kendoNumericTextBox").value());
										dataDatasource.set("crStatus","Submit");
										dataDatasource.set("crAction","UPDATE");
										dataDatasource.set("countryName",$("#countryName").text());
										dataDatasource.set("userId",window.sessionStorage.getItem("username"));
										countrydataSource.sync();
									}
								}
							});
						
						
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
		window.location = "/ermsweb/issuerLimitMaintenance";
	}
	
	function toDiscard(issuerCode){
		window.location = "/ermsweb/issuerLimitChangeRequestDiscard?issuerCode="+issuerCode;
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
					<div class="page-title">Maintenance  - Issuer Limit Maintenance (Collateral) - Update Issuer Limit Change Request (Collateral)</div>	    		
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
	   							<td>
	   								Issuer	
	   							</td>
	   							<td>
	   								<div id="issuerCode"></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>
	   								Issuer Name
	   							</td>
	   							<td>
	   								<div id="issuerName"></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Country</td>
	   							<td>
	   								<input id="countryId" name="countryId" />
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
	   							<td>Limit in % of Loan</td>
	   							<td>
	   								<input id="lmtInLoan"    name="lmtInCapital" /> %
	   							</td>
	   						</tr>
	   						
	   					</table>
	    			</div>
	    			</form>
	    			<div class="approval-section margin-top">
					<div id="approval-section-header">Approval</div>
						<table id="approval-section-table">
							<tr>
								<td class="bold">Action performed by Maker:</td>
								<td><label class="bold">Update </label></td>
							</tr>
							<tr>
								<td width="195.5" style="vertical-align:top" class="bold">Remarks</td>
								<td width="300">
									<div style="background-color:#FCD5B4;min-height:80px;"><label id="verifierRemarks">Verifer Reamrks will come here</label></div>
								</td>
							</tr>		
						</table>
					</div>	
	    	
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
    