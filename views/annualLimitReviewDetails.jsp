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

    <script src="/ermsweb/resources/js/jszip.min.js"></script>
    <!-- Kendo UI combined JavaScript -->
    
    <!-- <script src="http://kendo.cdn.telerik.com/2014.3.1029/js/kendo.all.min.js"></script> -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
    
    <script>
    $(document).ready(function(){
		
    	var businessUnitData = new kendo.data.DataSource({
			transport: {
				read: {
					url: "/ermsweb/resources/js/businessunit.json",
					dataType: "json"
				}
			}
  		});
    	
    	
  		
  		$("#bizDesc").kendoDropDownList({
  			dataTextField: "text",
  			dataValueField: "value",
  			dataSource: businessUnitData,
  			index: 0
  		});
  		
  		
  		
  		var numberData = [{text:"1",value:"1"},{text:"2",value:"2"}];
  		
  		$("#number_Selector").kendoDropDownList({
  			dataTextField: "text",
  			dataValueField: "value",
  			dataSource: numberData,
  			index: 0
  		});
  		
		var monthYearData = [{text:"Month",value:null},{text:"Year",value:"year"}];
  		
  		$("#mon_Year_Selector").kendoDropDownList({
  			dataTextField: "text",
  			dataValueField: "value",
  			dataSource: monthYearData,
  			index: 0
  		});
  		
  		var flowData = [{text:"Yes",value:"Y"},{text:"No",value:"N"}]; 
  		
  		$("#isNormalApprFlowInd").kendoDropDownList({
  			dataTextField: "text",
  			dataValueField: "value",
  			dataSource: flowData,
  			index: 0
  		});
  		
  		$("#scheduleDate").kendoDatePicker({
  			format: "yyyy/MM/dd",
  		});
  		$("#existingExpFrmDate").kendoDatePicker({
  			format: "yyyy/MM/dd",
  		});
  		$("#existingExpToDate").kendoDatePicker({
  			format: "yyyy/MM/dd",
  		});
  		
  		$("#newExpiryDate").kendoDatePicker({
  			format: "yyyy/MM/dd",
  		});
  		
  		var inlineFlag = getURLParameters('inline');
    	if(inlineFlag){
	    	var jsonObj = JSON.parse(window.sessionStorage.getItem("activeData"));
			if(jsonObj.id.bizUnit){
				$("#bizDesc").data("kendoDropDownList").value(jsonObj.id.bizUnit);
				$("#scheduleDate").val(validDate(jsonObj.id.scheduleEffDt));
				$("#existingExpFrmDate").val(validDate(jsonObj.existExpiryFmDt));
				$("#existingExpToDate").val(validDate(jsonObj.existExpiryToDt));
				$("#newExpiry_radio").prop("checked", true);
				$("#newExpiryDate").data("kendoDatePicker").enable(true);
				$("#newExpiryDate").data("kendoDatePicker").value(validDate(jsonObj.newExpiryDt));
				$("#newLmtAmt").html(jsonObj.newLmtAmt);
				$("input[type='radio']").each(function(){
					if($(this).val() == jsonObj.isExcludeGroupInd){
						$(this).prop("checked",true);	
					}else{
						$(this).prop("checked",false);
					}
						
				});
				/* $("input[type='checkbox']").each(function(){
					var hold_value = jsonObj.exclAcctStatusList.split(",");
					for(var i=0;i<hold_value.length;i++){
						if(hold_value[i] == $(this).val()){
							$(this).prop("checked",true);
						}
					};	
				}); */
				$("#isNormalApprFlowInd").data("kendoDropDownList").value(jsonObj.isNormalApprFlowInd);
					
			}
    	}
    	
  		var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: "/ermsweb/resources/js/viewLimitTypeDetails.json",
					//url: window.sessionStorage.getItem('serverPath')+"annualLimitReview/getAlrSchedule?userId="+window.sessionStorage.getItem('username');
					dataType: "json",
					
					xhrFields: {
                        withCredentials: true
                       },
					
					type:"GET"
					
				}, 
				create:{
					type:"POST",
					url: window.sessionStorage.getItem('serverPath')+"annualLimitReview/addAlrScheduleCr",
					//"+window.sessionStorage.getItem('serverPath')+"annualLimitReview/addAlrScheduleCr
					dataType: "json",
					xhrFields: {
                        withCredentials: true
                       },
					
					contentType:"application/json",
					complete: function (jqXHR, textStatus){
						var response = JSON.parse(jqXHR.responseText);
						if(response.action){
							if(response.action == "success"){
								//$(".confirm-del").html(response.message);
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
			schema:{
				/* data: function(data) {              // the data which the data source will be bound to is in the values field
	                //console.log(data);
	                return data;
	            }, */
			 	model:{
					id:"id"
				} 
			}
		});
  		
  		
  		 $("#scheduleBtn").kendoButton({
				click: function(){
					var scheduleObj = {
							
							"userId": window.sessionStorage.getItem('username'),
							"funcId": "",
							"action": "A",
							"bizUnit": "PB",
							"scheduleEffDt": converDateStrFormat($("#scheduleDate").data("kendoDatePicker").value()),
							"bizDesc": "Public bank",
							"existExpiryFmDt": converDateStrFormat($("#existingExpFrmDate").data("kendoDatePicker").value()),
							"existExpiryToDt": converDateStrFormat($("#existingExpToDate").data("kendoDatePicker").value()),
							"newExpiryDt": converDateStrFormat($("#newExpiryDate").data("kendoDatePicker").value()),
							"exclAcctStatusList": checkboxValues(),
							"isNormalApprFlowInd": $("#isNormalApprFlowInd").data("kendoDropDownList").value(),
							"newExpiryDtIncrement": $("#number_Selector").data("kendoDropDownList").value(),
							"newExpiryDtIncrementUnit": null
							
							//"isExcludeGroup": $("input[name='excludeGroup']:checked").val(),
							//"newExpiryDtIncrementUnit": $("#mon_Year_Selector").data("kendoDropDownList").value()	
							
					};
					console.log(scheduleObj);
					dataSource.add(scheduleObj);
					dataSource.sync();
					
				}
  		 
			 });
  		 
  		$("#exportBtn").kendoButton({
			click: function(){
				var exportCriteria = {
						userId:"RISKADMIN",
						bizUnit:"PB",
						enquiryView:"Y",
						excludeCmdAcctStatusActive:"Y",
						filterPending:"Y",
						summaryView:"N",
						
				};
				
				var alrenquiryPendingDetailsURL= window.sessionStorage.getItem('serverPath')+"limitapplication/getEnquiryAndPendingDetails";
				var dataSource = new kendo.data.DataSource({
					transport: {
						read: {
							url: alrenquiryPendingDetailsURL,
							//url: window.sessionStorage.getItem('serverPath')+"annualLimitReview/getAlrSchedule?userId="+window.sessionStorage.getItem('username');
							dataType: "json",
							data:exportCriteria,
							xhrFields: {
		                        withCredentials: true
		                       },
							
							type:"GET"
							
						}
						
					}

				});
				
				dataSource.fetch(function(){
					var exportData= this.view();
					var rows=[];
					var cells=[];
					/*------------Fetching Data headers for the excel----------*/
					cells = [  
		     				    {value:"Business Unit Desc"},	
								{value:"Business Unit Code"},
		        				    { 
		        				        value: "Group Name"
		        				        
		        				    },
		        				    { 
		        				      
		        				        value: "Client Counterparty Namer" 
		        				        
		        				    },
		        				    { 

		        				        value: "Account Name"

		        				    },
		        				    { 
		        				        
		        				        value: "Account No" 
		        				        
		        				    },
		        				    { 
		        				      
		        				        value: "Sub Account No"
		        				      
		        				    },


		        				    { 
		        				        
		        				        value: "Account Status"
		        				        
		        				    },
		        				    { 
		        				        
		        				        value: "Account Open Date (yyyy/mm/dd)" 
		        				        
		        				       
		        				    },
		        				    { 
		        				        
		        				        value: "Sales Code" 
		        				        
		        				    },
		        				    { 
		        				        
		        				        value: "Sales Name"
		        				        
		        				    },
		        				    { 
		        				        
		        				        value: "Facility ID"
		        				        
		        				    },
		        				    { 
		        				        
		        				        value: "Limit Type"
		        				        
		        				    },
		        				    { 
		        				        
		        				        value: "CCF (%)" 
		        				        
		        				    },
		        				    { 
		        				        
		        				        value: "Existing Expiry Date (yyyy/mm/dd)"
		        				        
		        				        
		        				    },
		        				            { 

		        				                value: "Existing Facility LimitCurrency" 

		        				            },
		        				            { 
		        				                value: "Existing Facility LimitAmount" 
		        				              
		        				            },
		        				    
		        				   
		        				    { 
		        				   
		        				        value: "Existing Limit Amount x CCF (HKD)"

		        				    },
		        				    { 
		        				        
		        				        value: "New Expiry Date (yyyy/mm/dd)"
		        				    },
										{ 

    	        				                value: "New Facility LimitCurrency"

    	        				            },
    	        				            { 

    	        				                value: "New Facility LimitAmount" 
    	        				                
    	        				            },


    	        				   
		        				    { 
		        				       
		        				        value: "New Limit Amount x CCF (HKD)"

		        				    },
		        				    { 
		        				        
		        				        value: "Counter Offer New Expiry Date (yyyy/mm/dd)" 

		        				        
		        				    },
{ 

    	        				                value: "Counter Offer : New Facility LimitCurrency"

    	        				            },
    	        				            { 

    	        				                 value: "Counter Offer : New Facility LimitAmount"

    	        				            },


		        				  
		        				    { 
		        				        
		        				        value: "Counter Offer : New Facility Amount x CCF (HKD)" ,
		        				        
		        				    },
		        				    { 
		        				        
		        				        value: "Updated By" 
		        				        
		        				    },
		        				    { 
		        				       
		        				        value: "Updated Date (yyyy/mm/dd hh:mi)"

		        				    },

		        				    { 

		        				        value: "Limit Status"

		        				    },

		        				    { 
		        				        
		        				        value: "To be Processed By"

		        				    },
		        				    { 

		        				        value: "Annual Limit Review"

		        				    },
		        				    { 

		        				        value: "Batch Upload"

		        				    },
		        				    { 

		        				        value: "Batch ID"

		        				    },
		        				    { 

		        				        value: "Action"

		        				    }
		        				]

					
					
					/* $.each(exportData[0], function(key, value ) {
						cells.push({value:key});	
					});
					
					console.log(cells); */
					rows.push({cells:cells});
					console.log(cells);
					cells = [];
					/*-------------Fetching Data for the excel---------------*/
					for(var i = 0; i < exportData.length; i++){
							cells.push(
									{value:exportData[i].bizUnitDesc},{value:exportData[i].bizUnitCode},{value:exportData[i].groupName},{value:exportData[i].ccdName},{value:exportData[i].accName},{value:exportData[i].acctId},{value:exportData[i].subAcctId},{value:exportData[i].cmdAcctStatus},{value:exportData[i].acctOpenDate},
									{value:exportData[i].salesmanCode},{value:exportData[i].salesmanName},{value:exportData[i].facId},{value:exportData[i].lmtTypeDesc},{value:exportData[i].ccfRatio},{value:exportData[i].existLmtExpiryDate},{value:exportData[i].existLmtCcy},{value:exportData[i].existLmtAmt},{value:exportData[i].existCcfLmtAmtHkd},
									{value:exportData[i].newLmtExpiryDate},{value:exportData[i].newLmtCcy},{value:exportData[i].newLmtAmt},{value:exportData[i].newCcfLmtAmtHkd},{value:exportData[i].coLmtExpiryDate},{value:exportData[i].coLmtCcy},{value:exportData[i].coLmtAmt},{value:exportData[i].coCcfLmtAmtHkd},{value:exportData[i].lastUpdateBy},
									{value:exportData[i].lastUpdateDt},{value:exportData[i].status},{value:exportData[i].processedBy},{value:exportData[i].isAnnualLmtReview},{value:exportData[i].isBatchUpload},{value:exportData[i].batchId},{value:exportData[i].action}
									);
							rows.push({cells:cells});
							cells = [];				
					}
						
	
					/*-------------Workbook Sheet Creation---------------*/
					var workbook = new kendo.ooxml.Workbook({
			          sheets: [
			            {
			              // Title of the sheet
			              title: "Annual Limit Review Data",
			              // Rows of the sheet
			              rows: rows
			            }
			          ]
			        });
			        //save the file as Excel file with extension xlsx
			        kendo.saveAs({dataURI: workbook.toDataURL(), fileName: "Alrdetails.xlsx"});
				
				});	
				
			}
		 
  			
		 });
  		 
	  		$("input[name='queryOn']").each(function(){
				$(this).click(function(){
					var radio_checked = $("input[name='queryOn']:checked").attr("link-input");
					if(radio_checked){
						$(".disabled-off").each(function(){
							var queryFields = ($(this).attr("id")) ? $(this).attr("id") : "";
							if(queryFields){
								var inputId = "#"+queryFields;
								
								if($(inputId).hasClass("on-"+radio_checked)){
									($(inputId).data("kendoDropDownList")) ? $(inputId).data("kendoDropDownList").enable(true) : ($(inputId).data("kendoDatePicker")) ? $(inputId).data("kendoDatePicker").enable(true) : $(inputId).prop("disabled", false);
								}else{
									($(inputId).data("kendoDropDownList")) ? ($(inputId).data("kendoDropDownList").enable(false), $(inputId).data("kendoDropDownList").value('')) : ($(inputId).data("kendoDatePicker")) ? ($(inputId).data("kendoDatePicker").enable(false), $(inputId).data("kendoDatePicker").value('')) : $(inputId).prop("disabled", true);
								}
							}
						});
					}
				});
			});	

	  		
	  		
	  		
  		
  		
    });
    function checkboxValues(){
		
		var checkedval = "";
		$(':checkbox:checked').each(function(i){
			
			if(checkedval == ""){
 			 checkedval = $(this).val();
 			 }
			else{
				checkedval = checkedval + "," + $(this).val();
			}
      	});
		return checkedval;
	}
    function converDateStrFormat(dateStr){
        var date = Date.parse(dateStr);
        return kendo.toString( new Date(parseInt(date)), "ddMMyyyy" );       
    } 
	
    function validateResponse(data){
		return (data != null) ? data : "";
	}
    
    function validDate(obj){
		return kendo.toString( new Date(parseInt(obj)), "yyyy/MM/dd" )
	}
    
    function openModal() {
	     $("#modal, #modal1").show();
	}
    
    function toBack() {
    	
    	window.location = "/ermsweb/annualLimitReviewProcess";
	}

	function closeModal() {
	    $("#modal, #modal1").hide();	    
	}
	
    </script>
    <body>
    	<div class="boci-AnnualLimitTypeReview-wrapper">
    		<%-- <%@include file="header1.jsp"%> --%>
    		<div class="annualLimitReview-content-wrapper">
					<div class="page-title">Annual Limit Review Process (SCN-ALR-PROCESS-DTL)</div>
	    			<div class="command-button-Section">
	    				<button id="exportBtn" class="k-button" type="button">Export</button>
	    				<button id="scheduleBtn" class="k-button" type="button" >Schedule</button>
	    				<button id="backBtn" class="k-button" type="button" onclick="toBack()">Back</button>
	    			</div>
	    			<div class="confirm-del"></div>
	    			<div class="clear"></div>
	    			<div class="annual-Limit-Review-details">
	   					<div class="annual-Limit-Review-details-header">Annual Limit Review Details </div>
	   					<table>
	   						<tr>
	   							<td class="field-label">Business Unit</td>
	   							<td colspan="2">
									<div id="bizDesc_label"><input id="bizDesc" class="select-textbox" /></div>
									<!-- <input id="bizUnit" class="select-textbox"/> -->
								</td>
	   						</tr>
	   						<tr>
	   							<td>Schedule Date (yyyy/mm/dd)</td>
	   							<td>
	   								<div id="scheduleDate_label"><input id="scheduleDate"/> after SOD </div>
	   							</td>
	   						</tr>
	   						<tr>	
	   							<td>
	   								Existing Expiry Date (yyyy/mm/dd)
	   							</td>
	   							<td>
	   								<input id="existingExpFrmDate"/> to <input id="existingExpToDate"/> 
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>New Expiry Date (yyyy/mm/dd)</td>
	   							<td>
	   								<div><input type="radio" name="queryOn" link-input="expirydate" id="newExpiry_radio" /><input id="newExpiryDate" class="on-expirydate disabled-off date-pick" disabled="disabled"/></div>
	   								<div><input type="radio" name="queryOn" link-input="approvaldate" />New Approval Date +<input id="number_Selector" class="on-approvaldate disabled-off select-textbox" disabled="disabled"/> <input  class="on-approvaldate disabled-off select-textbox" id="mon_Year_Selector" disabled="disabled"/> Extension</div>
	   							</td>
	   							
	   						</tr>	
	   						<tr>
	   							<td>
	   								New Limit Amount
	   							</td>
	   							<td>
	   								<div id="newLmtAmt"></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Exclude Group with Next Review Date</td>
	   							<td>
	   								<div><input type="radio" name="excludeGroup"  id="yes_radio" value="Y" /><label for="yes_radio">Yes</label><input class="checkmarign-left" type="radio" name="excludeGroup" value="N"  id="no_radio" /><label for="no_radio">No</label></div>
	   							</td>
	   							
	   						</tr>
	   						
	   						<tr>
	   							<td>Exclude Account Status</td>
	   							<td>
	   								<div>
		   								<input type="checkbox" id="active" value="Active"/><label class="checkbox-padding"for="active">Active</label>
		   								<input type="checkbox" id="closed" value="Closed"checked class="checkmarign-left" style="margin-left:214px;"/><label class="checkbox-padding"for="closed">Closed</label>
		   							</div>
		   							<div>
		   								<input type="checkbox" id="dormant" value="Dormant"/><label class="checkbox-padding"for="dormant">Dormant</label>
		   								<input type="checkbox" id="freeze" value="Freeze" class="checkmarign-left" /><label class="checkbox-padding"for="freeze">Freeze</label>
		   							</div>
		   							<div>
		   								<input type="checkbox" id="inActive" value="Inactive"/><label class="checkbox-padding"for="inActive">InActive</label>
		   								<input type="checkbox" id="process"  value="Processing" class="checkmarign-left"/><label class="checkbox-padding"for="process">Processing</label>
		   							</div>
		   							<div>
		   								<input type="checkbox" id="suspend" value="Suspended" /><label class="checkbox-padding"for="suspend">Suspended</label>
	   							</td>
	   						</tr>
	   			
	   						<tr>
	   							<td>Go through the Normal Limit Review Flow?</td>
	   							<td>
	   								<input id="isNormalApprFlowInd"/>
	   							</td>
	   						</tr>
	   						
	   					</table>
	    			</div>
	    			    		
			</div>
		</div>
    </body>
    </html>
    