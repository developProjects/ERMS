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
    	var lmtTypeCode = getURLParameters('lmtTypeCode');
    	//alert(lmtTypeCode);
//    	var lmtTypeCode=$('#lmtTypeCode').val();
		limitviewurl=window.sessionStorage.getItem('serverPath')+"limitTypeHier/getLmtTypeHier?lmtTypeCode="+lmtTypeCode;
    
		openModal();	
    	var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					//url: "/ermsweb/resources/js/viewLimitTypeDetails.json",
					url: limitviewurl,
					dataType: "json",			
					type:"GET",
					xhrFields: {
                        withCredentials: true
                       }
					
					
				},
				create: {
		            url:window.sessionStorage.getItem('serverPath')+"limitTypeHierCr/saveLmtTypeHierCr",
		            type: "post",
		            dataType: "json",
		            xhrFields: {
                        withCredentials: true
                       },
					
		            contentType: "application/json; charset=utf-8", 
		            complete: function (data, status){
						var response = JSON.parse(data.responseText);
						if(response.action=="success"){
							window.location = "/ermsweb/limitTypeMaintenance";
						}
										else{
							
							$(".confirm-del").html(response.message);
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
					id:"lmtTypeCode"
				} 
	        }
		});
    	
    	
    	

		/*Binding Data for LimitDetails to be updated*/
		
			dataSource.fetch(function(){
				var jsonObj = this.view();
				console.log(jsonObj);
				$.each(jsonObj, function(i){
					$("#limit_group_label").html("<input id='limit_group' default-attr='' name='limitGroup' value='"+validateResponse(jsonObj[i].lmtGroup)+"'/>");
					$("#client_counterparty_label").html("<span style='display:none;' class='hold_value'>"+validateResponse(checkClientCounterparty(jsonObj[i]))+"</span><input type='checkbox' name='ccp' id='client' value='Client' class='k-checkbox'></input><label class='k-checkbox-label padding_label' for='client' >Client</label> <input type='checkbox' name='ccp' id='counterparty' value='Counterparty' class='k-checkbox' ></input><label class='k-checkbox-label' for='counterparty'>Counterparty</label>");
					$("#limit_type_label").html("<input type='text' id='limit_type' class='k-textbox' maxlength='100'  name='limitType' value='"+jsonObj[i].lmtTypeDesc+"' required />");
					$("#base_nature_label").html("<input id='baseNature' default-attr='Notional' name='baseNature' value='"+validateResponse(jsonObj[i].baseNature)+"'/>");
					$("#limit_code_label").html("<input type='text' id='limit_code' name='limitcode' value='"+validateResponse(jsonObj[i].lmtTypeCode)+"' class='k-textbox' maxlength='100' readonly/>");						
					$("#category_label").html("<input id='create_category' default-attr='' name='category' value='"+validateResponse(jsonObj[i].category)+"'/>");
					$("#aggregate_level_label").html("<input id='aggregate_level' default-attr='Limit' name='aggregatelevel' value='"+validateResponse(jsonObj[i].aggLvl)+"'/>");
					$("#ccf_percentage_label").html("<input class='percentage_numeric_update' name='ccfpercentage' value='"+ccfConversion(jsonObj[i].ccfRatio,'',true)+"' id='ccf_percentage' type='number'/><span class='percentage-notation'>&#37</span>");
					$("#parent_limittype_label").html("<input id='parent_limit_type' default-attr='' name='parentLimitType' value='"+validateResponse(jsonObj[i].parentLmtTypeDesc)+"'/>");
					$("#hierarchy_level_label").html("<input id='hierarchy_level' default-attr='' name='hierarchyLevel' value='"+validateResponse(jsonObj[i].hierarchyLvl)+"'/>");						
					$("#approval_matrix_label").html("<input id='aproval_matrix_option' default-attr='' name='AprovalMatrix' required value='"+validateResponse(jsonObj[i].limitParameters)+"'/>");
					$(".command-button-Section").html("<button id=\"saveBtn\"  type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" >Save</button><label>    </label><button id=\"submitBtn\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Submit</button><label>    </label><button id=\"clearBtn\" type=\"button\" data-role=\"button\" class=\"k-button toClear\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Clear</button><label>    </label><button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Back</button>"); 
					$("#verifierRemarks").html(jsonObj[i].crRemarks);
					$("#created_by").html(validateResponse(jsonObj[i].createBy));
					$("#created_at").html(validateResponse(validDate(jsonObj[i].createDt)));
					$("#updated_by").html(validateResponse(jsonObj[i].lastUpdateBy));
					$("#updated_at").html(validateResponse(validDate(jsonObj[i].lastUpdateDt)));
					$("#verified_by").html(validateResponse(jsonObj[i].verifyBy));
					$("#verified_at").html(validateResponse(validDate(jsonObj[i].verifyDt)));
					$("#action").html(validateResponse(jsonObj[i].action));
						
					var lpdatabybusinessUnit = new kendo.data.DataSource({
						transport: {
							read: {
								//url: "/ermsweb/resources/js/lpbybu.json",
								//url: window.sessionStorage.getItem('serverPath')+"limitTypeHier/getLmtTypeHierBuMap?lmtTypeCode=LEE",
								url: window.sessionStorage.getItem('serverPath')+"limitTypeHier/getLmtTypeHierBuMap?lmtTypeCode="+lmtTypeCode,
								dataType: "json",
								xhrFields: {
	                                  withCredentials: true
	                                 },
	          					type:"GET"
								}
							},
							schema: {
		    					model:{
		    		            	id:"id"
		    		            }
		    				},
						pageSize:2
					
					});
					
					lpdatabybusinessUnit.fetch(function(){
						  var lpbyBudata = lpdatabybusinessUnit.data();
						  if (lpbyBudata.length!=0){
							  $.each(lpbyBudata, function(i, obj){
									obj.limitparamsbyBuId = i+1;
								});
						  }
						  $("#limitparams_by_businessUnit").kendoGrid({
								
								dataSource: lpbyBudata,
								
								scrollable:true,
								pageable: true,
								selectable: "row",
								change: function(e) {
									var selectedRows = this.select();
								    var selectedDataItems = [];
								    for (var i = 0; i < selectedRows.length; i++) {
								      var dataItem = this.dataItem(selectedRows[i]);
								      selectedDataItems.push(dataItem);
								     }
								    
								    $("#lpbybusinessUnit_form").attr("rowid",selectedDataItems[0].limitparamsbyBuId);
								    $("#business_unit_label").data("kendoDropDownList").value(selectedDataItems[0].id.bizUnit);
								    $("#limit_dbuffer_amountOne").data("kendoNumericTextBox").value(selectedDataItems[0].lmtDeficitBufAmt01Hkd);
								    $("#limit_dbuffer_amountTwo").data("kendoNumericTextBox").value(selectedDataItems[0].lmtDeficitBufAmt02Hkd);
								    $("#limit_uthreshold_percentageOne").data("kendoNumericTextBox").value(ccfConversion(selectedDataItems[0].lmtUtlzThresholdRatio01,'',true));
								    $("#limit_uthreshold_percentageTwo").data("kendoNumericTextBox").value(ccfConversion(selectedDataItems[0].lmtUtlzThresholdRatio02,'',true));
								    $("#margin_cbuffer_amountOne").data("kendoNumericTextBox").value(selectedDataItems[0].odMarginCallBufAmt01Hkd);
								    $("#margin_cbuffer_amountTwo").data("kendoNumericTextBox").value(selectedDataItems[0].odMarginCallBufAmt02Hkd);
								    $("#margin_cthreshold_percentageOne").data("kendoNumericTextBox").value(ccfConversion(selectedDataItems[0].marginCallThresholdRatio01,'',true));
								    $("#margin_cthreshold_percentageTwo").data("kendoNumericTextBox").value(ccfConversion(selectedDataItems[0].marginCallThresholdRatio02,'',true));
								    $("#collateral_mitigation_percentage").data("kendoNumericTextBox").value(ccfConversion(selectedDataItems[0].collMitigationRatio,'',true));
								    $("#economic_capital_percentage").data("kendoNumericTextBox").value(ccfConversion(selectedDataItems[0].econCapRatio,'',true));
								    $("#riskweight_greaterthanfive_percentage").data("kendoNumericTextBox").value(ccfConversion(selectedDataItems[0].rw4LoanExpoGte5PcRatio,'',true));
								    $("#riskweight_lessthanfive_percentage").data("kendoNumericTextBox").value(ccfConversion(selectedDataItems[0].rw4LoanExpoLt5PcRatio,'',true));
				 				    $("#board_approved_limit_currencybybu").data("kendoDropDownList").value(selectedDataItems[0].boardApproveLmtAmtCcy);
								    $("#board_approved_amountbybu").data("kendoNumericTextBox").value(selectedDataItems[0].boardApproveLmtAmtLmtCcy);
							
								},   
								columns: [
												{ field: "id.bizUnit", title: "Business Unit" , width: 150},
				    					{ field: "lmtDeficitBufAmt01Hkd", title: "Limit Deficit Buffer Amount 1 (HKD)", width: 150},
				    					{ field: "lmtDeficitBufAmt02Hkd", title: "Limit Deficit Buffer Amount 2 (HKD)", width: 150},
				    					{ field: "lmtUtlzThresholdRatio01", template: '#= ccfConversion(lmtUtlzThresholdRatio01,"%",true)#',title: "Limit Utilization Threshold Percent 1", width: 150},
				    					{ field: "lmtUtlzThresholdRatio02", template: '#= ccfConversion(lmtUtlzThresholdRatio02,"%",true)#',title: "Limit Utilization Threshold Percent 2", width: 150},
				    					{ field: "odMarginCallBufAmt01Hkd", title: "Overdue or Margin Call Buffer Amount 1 (HKD)", width: 150},
				    					{ field: "odMarginCallBufAmt02Hkd", title: "Overdue or Margin Call Buffer Amount 2 (HKD)", width: 150},
				    					{ field: "marginCallThresholdRatio01",template: '#= ccfConversion(marginCallThresholdRatio01,"%",true)#', title: "Margin Call Threshold Percent 1", width: 150},
				    					{ field: "marginCallThresholdRatio02", template: '#= ccfConversion(marginCallThresholdRatio02,"%",true)#',title: "Margin Call Threshold Percent 2", width: 150},
				    					{ field: "collMitigationRatio",template: '#= ccfConversion(collMitigationRatio,"%",true)#', title: "Collateral Mitigation Percent", width: 150},
				    					{ field: "econCapRatio",template: '#= ccfConversion(econCapRatio,"%",true)#', title: "Economic Capital Percent", width: 150},
				    					{ field: "rw4LoanExpoGte5PcRatio",template: '#= ccfConversion(rw4LoanExpoGte5PcRatio,"%",true)#', title: "Risk Weight Percent for Loan Exposure >= 5% of BOCI Capital", width: 150},
				    					{ field: "rw4LoanExpoLt5PcRatio", template: '#= ccfConversion(rw4LoanExpoLt5PcRatio,"%",true)#',title: "Risk Weight Percent for Loan Exposure < 5% of BOCI Capital", width: 150},
				    					{ field: "boardApproveLmtAmtLmtCcy", title: "Board Aproved Limit Amount",template: '#= boardApproveLmtAmtCcy # #=boardApproveLmtAmtLmtCcy # ', width: 150},
				    					{field:"status","title":"Status",width:150}
					    				]
								
							
							});
					 
					});
			    	 
			    	 var lpdatabybusinessEntity = new kendo.data.DataSource({
							transport: {
								read: {
									//url: "/ermsweb/resources/js/lpbyentity.json",
									//url: window.sessionStorage.getItem('serverPath')+"limitTypeHier/getLmtTypeHierEntityMap?lmtTypeCode=LEE",
									url: window.sessionStorage.getItem('serverPath')+"limitTypeHier/getLmtTypeHierEntityMap?lmtTypeCode="+lmtTypeCode,
									dataType: "json",
									xhrFields: {
		                                  withCredentials: true
		                                 },
		          					type:"GET"
									}
								},
								schema: {
			    					model:{
			    		            	id:"id"
			    		            }
			    				},
							pageSize:2
						
						});
			    	 lpdatabybusinessEntity.fetch(function(){
						  var lpbyEntitydata = lpdatabybusinessEntity.data();
						  if (lpbyEntitydata.length!=0){
							  $.each(lpbyEntitydata, function(i, obj){
									obj.limitparamsbyEntityId = i+1;
								});
						  }
			    	 		
			   				$("#limitparams_by_businessEntity").kendoGrid({
							
							dataSource: lpbyEntitydata,
							
							scrollable:true,
							pageable: true,
							selectable: "row",
							change: function(e) {
								var selectedRows = this.select();
							    var selectedDataItems = [];
							    for (var i = 0; i < selectedRows.length; i++) {
							      var dataItem = this.dataItem(selectedRows[i]);
							      selectedDataItems.push(dataItem);
							     
							    }
							   
							    $("#board_approved_amountbyentity").data("kendoNumericTextBox").value(selectedDataItems[0].boardApprLmtAmt);
							    $("#lpbyEntity_form").attr("rowid",selectedDataItems[0].limitparamsbyEntityId);
							    $("#entity_label").data("kendoDropDownList").value(selectedDataItems[0].id.bookEntity);
							  	$("#board_approved_limit_currencybyentity").data("kendoDropDownList").value(selectedDataItems[0].id.boardApprLmtCcy);
							},
							columns: [
				    					{ field: "id.bookEntity", title: "Entity" , width: 60},
				    					{ field: "boardApprLmtAmt", title: "Board Aproved Limit Amount", template: '<span class="currency-span">#= id.boardApprLmtCcy #</span> #=boardApprLmtAmt # ', width: 60},
				    					{field:"status","title":"Status",width:60}
				    				]
							
							
						});
			   			
			    	 });		
		   			$("#lpbyentitynewBtn").click(function(){
						 
						 if (validate_lpbyentity.validate()) {
						 var object = $(this).closest(".form");
						 var grid = $("#limitparams_by_businessEntity").data("kendoGrid");
					     var count= grid.dataSource.total(); 
						 var entity =  $("#entity_label").data("kendoDropDownList").value();
						 
	   					 var amount = $("#board_approved_amountbyentity").data("kendoNumericTextBox").value();
	   					 lpdatabybusinessEntity.add(
	   							 {
	   								"id": {
	   									"bookEntity": $("#entity_label").data("kendoDropDownList").value(),
	   									"boardApprLmtCcy":$("#board_approved_limit_currencybyentity").data("kendoDropDownList").value()
	   								},
	   								boardApprLmtAmt:amount,
	   							     status:"New",
	   							  	 crAction: "CREATE",
	   								 limitparamsbyEntityId:count+1
	   								 }
	   					  );
	   					 toReset(object);
	   					 
						 }
					 });
	    					 
					 $("#lpbyentityupdateBtn").click(function(){
		
						 var object = $(this).closest(".form");
						 var index = $("#lpbyEntity_form").attr("rowid");
						 var entity =  $("#entity_label").data("kendoDropDownList").value();
	   					 var amount = $("#board_approved_amountbyentity").data("kendoNumericTextBox").value();
	   					 var currency= $("#board_approved_limit_currencybyentity").data("kendoDropDownList").value();
	   					 
	   						var dataDatasource = lpdatabybusinessEntity.at(index-1);
		    				dataDatasource.set("id.bookEntity", entity);
		    				dataDatasource.set("boardApprLmtAmt", amount);
		    				dataDatasource.set("id.boardApprLmtCcy", currency);
		    				dataDatasource.set("status","Updated");
		    				dataDatasource.set("crAction","UPDATE");
		    				
	    				
	    				toReset(object);
	    			
					 });
					 
					 $("#lpbyentitydeleteBtn").click(function(){
						 var object = $(this).closest(".form");
						 var index = $("#lpbyEntity_form").attr("rowid");
						 
						 var dataDatasource = lpdatabybusinessEntity.at(index-1);
						
						 	if (dataDatasource.status == "New") 
						 	{
						 		
						 		lpdatabybusinessEntity.remove(dataDatasource);
						 		toReset(object);
						 	}
						 	else if (dataDatasource.status == "Updated"){
						 		dataDatasource.set("status","Deleted");
						 		dataDatasource.set("crAction","DELETE");
						 		toReset(object);
						 	}
						 	else{
						 		toReset(object);
						 	}
		    				
						 	
						 
					 });
					  
					 
					 
					 
					 $("#lpbybunewBtn").click(function(){
						 
						 if (validate_lpbybu.validate()) {
						 var object = $(this).closest(".form");
						 
						 var grid = $("#limitparams_by_businessUnit").data("kendoGrid");
					     var count= grid.dataSource.total();
					     
					     console.log($("#business_unit_label").data("kendoDropDownList").value());
					   
					     lpdatabybusinessUnit.add({
					    	    "id":{"bizUnit":$("#business_unit_label").data("kendoDropDownList").value()},
							 	lmtDeficitBufAmt01Hkd:$("#limit_dbuffer_amountOne").data("kendoNumericTextBox").value(),
							 	lmtDeficitBufAmt02Hkd:$("#limit_dbuffer_amountTwo").data("kendoNumericTextBox").value(),
							 	lmtUtlzThresholdRatio01:ccfConversion($("#limit_uthreshold_percentageOne").data("kendoNumericTextBox").value(),'',false),
							 	lmtUtlzThresholdRatio02:ccfConversion($("#limit_uthreshold_percentageTwo").data("kendoNumericTextBox").value(),'',false),
							 	odMarginCallBufAmt01Hkd:$("#margin_cbuffer_amountOne").data("kendoNumericTextBox").value(),
							 	odMarginCallBufAmt02Hkd:$("#margin_cbuffer_amountTwo").data("kendoNumericTextBox").value(),
							 	marginCallThresholdRatio01:ccfConversion($("#margin_cthreshold_percentageOne").data("kendoNumericTextBox").value(),'',false),
							 	marginCallThresholdRatio02:ccfConversion($("#margin_cthreshold_percentageTwo").data("kendoNumericTextBox").value(),'',false),
							 	collMitigationRatio:ccfConversion($("#collateral_mitigation_percentage").data("kendoNumericTextBox").value(),'',false),
							 	econCapRatio:ccfConversion($("#economic_capital_percentage").data("kendoNumericTextBox").value(),'',false),
							 	rw4LoanExpoGte5PcRatio:ccfConversion($("#riskweight_greaterthanfive_percentage").data("kendoNumericTextBox").value(),'',false),
							 	rw4LoanExpoLt5PcRatio:ccfConversion($("#riskweight_lessthanfive_percentage").data("kendoNumericTextBox").value(),'',false),
							 	boardApproveLmtAmtCcy:$("#board_approved_limit_currencybybu").data("kendoDropDownList").value(),
							 	boardApproveLmtAmtLmtCcy:$("#board_approved_amountbybu").data("kendoNumericTextBox").value(),
	    						status:"New",
	    						crAction:"CREATE",
	    						limitparamsbyBuId:count+1
	    						
						 });
						 console.log(lpdatabybusinessUnit);
						 toReset(object);
						}
						 
					 });
					 
					 
					 
					 
					 $("#lpbybuupdateBtn").click(function(){
							
						 var object = $(this).closest(".form");
						 var index = $("#lpbybusinessUnit_form").attr("rowid");
						 
	   					var dataDatasource = lpdatabybusinessUnit.at(index-1)
	   				
	   							dataDatasource.set("id.bizUnit", $("#business_unit_label").data("kendoDropDownList").value());
								dataDatasource.set("lmtDeficitAmt01Hkd", $("#limit_dbuffer_amountOne").data("kendoNumericTextBox").value());
								dataDatasource.set("lmtDeficitAmt02Hkd", $("#limit_dbuffer_amountTwo").data("kendoNumericTextBox").value());
								dataDatasource.set("lmtUtlzThresholdRatio01", ccfConversion($("#limit_uthreshold_percentageOne").data("kendoNumericTextBox").value()),'',false);
								dataDatasource.set("lmtUtlzThresholdRatio02", ccfConversion($("#limit_uthreshold_percentageTwo").data("kendoNumericTextBox").value()),'',false);
								dataDatasource.set("odMarginCallBufAmt01Hkd", $("#margin_cbuffer_amountOne").data("kendoNumericTextBox").value());
								dataDatasource.set("odMarginCallBufAmt02Hkd", $("#margin_cbuffer_amountTwo").data("kendoNumericTextBox").value());
								dataDatasource.set("marginCallThresholdRatio01", ccfConversion($("#margin_cthreshold_percentageOne").data("kendoNumericTextBox").value()),'',false);
								dataDatasource.set("marginCallThresholdRatio02", ccfConversion($("#margin_cthreshold_percentageTwo").data("kendoNumericTextBox").value()),'',false);
								dataDatasource.set("collMitigationRatio", ccfConversion($("#collateral_mitigation_percentage").data("kendoNumericTextBox").value()),'',false);
								dataDatasource.set("econCapRatio", ccfConversion($("#economic_capital_percentage").data("kendoNumericTextBox").value()),'',false);
								dataDatasource.set("rw4LoanExpoGte5PcRatio", ccfConversion($("#riskweight_greaterthanfive_percentage").data("kendoNumericTextBox").value()),'',false);
								dataDatasource.set("rw4LoanExpoLt5PcRatio", ccfConversion($("#riskweight_lessthanfive_percentage").data("kendoNumericTextBox").value()),'',false);
								dataDatasource.set("boardApproveLmtAmtCcy", $("#board_approved_limit_currencybybu").data("kendoDropDownList").value());
								dataDatasource.set("boardApproveLmtAmtLmtCcy", $("#board_approved_amountbybu").data("kendoNumericTextBox").value());
								dataDatasource.set("status", "Updated");
								dataDatasource.set("crAction", "UPDATE");
			    				//lpdatabybusinessUnit.sync();
	    						toReset(object);
					 });
					 
					 $("#lpbybudeleteBtn").click(function(){
						 
						 var object = $(this).closest(".form");
						 var index = $("#lpbybusinessUnit_form").attr("rowid");
						 
						 var dataDatasource = lpdatabybusinessUnit.at(index-1);
						
						 	if (dataDatasource.status == "New") 
						 	{
						 		lpdatabybusinessUnit.remove(dataDatasource);
						 		toReset(object);
						 	}
						 	else if (dataDatasource.status == "Updated"){
						 		dataDatasource.set("status","Deleted");
						 		dataDatasource.set("crAction","DELETE");
						 		toReset(object);
						 	}
						 	else{
						 		toReset(object);
						 	}
		    				
							//lpdatabybusinessUnit.sync();
						 	
						 
					 });	
					 
					 
				});
				
				$("input[type='checkbox']").each(function(){
					var hold_value = $(this).parent().find(".hold_value").text().split(",");
					for(var i=0;i<hold_value.length;i++){
						if(hold_value[i] == $(this).val()){
							$(this).prop("checked",true);
						}
					};	
				});
				var limitgroupData = [
							{ text: "ALL", value: "ALL" },
							{ text: "Pre-Settlement Risk Limit", value: "Pre-Settlement Risk Limit" },
							{ text: "Settlement Risk Limit", value: "Settlement Risk Limit" },
							{ text: "Loan Limit", value: "Loan Limit" },
							{ text: "Trading Risk Limit", value: "Trading Risk Limit" },
							{ text: "Other Limit", value: "Other Limit"}
					];
				$("#limit_group").kendoDropDownList({
					dataTextField: "text",
					dataValueField: "value",
					dataSource: limitgroupData,
					index: 0
				});
				var categoryData =[
							   {text:"" , value:""},  
    	          			{ text: "LEE-Omnibus Limit", value: "LEE-Omnibus Limit" },
    	          			{ text: "LEE- Independent Limit", value: "LEE- Independent Limit" },
    	          			{ text: "In-Direct Credit Limit", value: "In-Direct Credit Limit" },
    	          			{ text: "LEE-Non- Omnibus Limit", value: "LEE-Non- Omnibus Limit" }
    	          		];
				$("#create_category").kendoDropDownList({
					dataTextField: "text",
					dataValueField: "value",
					dataSource: categoryData,
					index: 0
				});
				var aggregatelevelData =[    
           	          			{ text: "Limit", value: "Limit" },
           	          			{ text: "Facilities", value: "Facilities" },
           	          ];
          		
          		$("#aggregate_level").kendoDropDownList({
          			dataTextField: "text",
          			dataValueField: "value",
          			dataSource: aggregatelevelData,
          			index: 0
          		});
				var baseNatureData =[
	           	          			{ text: "Potential Exposure", value: "Potential Exposure" },
	           	          			{ text: "Notional", value: "Notional" }
     	           	          ];
          		
          		$("#baseNature").kendoDropDownList({
          			dataTextField: "text",
          			dataValueField: "value",
          			dataSource: baseNatureData,
          			
          			index: 0
          		});
var parentLimitData =[];
          		
          		var parentlimittypeData =new kendo.data.DataSource({
           			transport: {
          				read: {
          					url: window.sessionStorage.getItem('serverPath')+"limitTypeHier/getLmtTypeCodeDescMap",
          					dataType: "json",
          					xhrFields: {
                                  withCredentials: true
                                 },
          					type:"GET"
          					
          				}
          			},
          			schema: {                               // describe the result format
        	            data: function(data) {              // the data which the data source will be bound to is in the values field
        	                //console.log(data);
        	                return [data];
        	            }
          			}
          		});
          		
          		
          		parentlimittypeData.fetch(function(){
          			var jsonObj = this.view()[0];
          			
          			console.log(parentlimittypeData.data()[0]);
          			for (var key in jsonObj) {
          				//console.log(key);
          				if (!jsonObj.hasOwnProperty(key)){
          					//console.log(key); 
          					continue;
          				}
          				if(key!="_events" && key!="uid" && key!="parent"){
          					parentLimitData.push({dataText:key,dataField:jsonObj[key]});	
          				}
          			}
          			$("#parent_limit_type").kendoDropDownList({
              			dataTextField: "dataText",
              			dataValueField: "dataField",
              			dataSource: parentLimitData,
              			index: 0
              		});
    			});
				var hierarchylevelData =[ 
          		        {text:"" , value:""},
						{ text: "Level 1", value: "1" },       
						{ text: "Level 2", value: "2" },
						{ text: "Level 3", value: "3" },
						{ text: "Level 4", value: "4" }
    	     	           	          ];
          	
          		$("#hierarchy_level").kendoDropDownList({
          			dataTextField: "text",
          			dataValueField: "value",
          			dataSource: hierarchylevelData,
          			index: 0
          		});
			var approvalMatrixData = new kendo.data.DataSource({
			transport: {
				read: {
					
					url: window.sessionStorage.getItem('serverPath')+"lmtApprMatrix/getOptionList",
					dataType: "json",
					xhrFields: {
                      withCredentials: true
                     },
					type:"GET"
					
				}
			}
/*       			schema: {                               // describe the result format
	            data: function(data) {              // the data which the data source will be bound to is in the values field
	                //console.log(data);
	                return data;
	            } 
	        }*/
		});
          		
			$("#aproval_matrix_option").kendoDropDownList({
      			dataTextField: "apprMatrixOption",
      			dataValueField: "value",
      			dataSource: approvalMatrixData,
      			index: 0
      		});
      		var businessUnitData = new kendo.data.DataSource({
					transport: {
						read: {
							url: "/ermsweb/resources/js/businessunit.json",
							dataType: "json"
						}
					}
		  		});
          		
          		$("#business_unit_label").kendoDropDownList({
          			dataTextField: "text",
          			dataValueField: "value",
          			dataSource: businessUnitData,
          			index: 0
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
                  		
          		
          		$(".board_approved_limit_currency").kendoDropDownList({
          			dataTextField: "dataText",
          			dataValueField: "dataField",
          			dataSource: currencyData,
          			index: 0
          		});
          		
          		var entityData = [
						{ text: "ALL", value: "ALL" },          
						{ text: "BOCI", value: "BOCI" },       
						{ text: "BOCIL", value: "BOCIL" },
						{ text: "BOCIS", value: "BOCIS" },
						{ text: "BOCIFP", value: "BOCIFP" },
						{ text: "BOCIGC", value: "BOCIGC" },
						{ text: "BOCI Finance", value: "BOCI Finance" },
					
          		      ];
          		
          		$("#entity_label").kendoDropDownList({
          			dataTextField: "text",
          			dataValueField: "value",
          			dataSource: entityData,
          			index: 0
          		});
          		
          		$(".percentage_numeric").kendoNumericTextBox({
                    min: 0,
                    max: 100, 
                    value:100,
                    spinners: false
                });
          		
          		$(".percentage_numeric_update").kendoNumericTextBox({
                    min: 0,
                    max: 100, 
                    spinners: false
                });
          		
          		$(".amount_numeric").kendoNumericTextBox({
                    min: 0,
                    value:0,
                    spinners: false
                });
          		
          		$(".boardamount_numeric").kendoNumericTextBox({
                    min: 0,
                    value:"",
                    spinners: false
                });
				
				$(".toClear").click(function(){
          			var parent = $(this).closest(".form");
          			parent.find("input[type='text']").val("");
          			parent.find('[data-role="dropdownlist"]').each(function(){
          				var default_attr = $(this).attr("default-attr");
          				$(this).data("kendoDropDownList").value((default_attr) ? default_attr : "");
          			})
          			parent.find('[data-role="numerictextbox"]').each(function(){
          				$(this).data("kendoNumericTextBox").value("");    
          			});
          			parent.find("input[name='ccp']").prop("checked",false);
          			
          		}); 
          		
               	 
				 
				 
				 
				$("#saveBtn").kendoButton({
    				click: function(){
    				
    					if (validate_create_newlimitform.validate()) {
                        	
    						var newlimit = {
                       			 lmtTpHierCr: {
                       				 
                       				 parentLmtTpHier: null,
        	                            crId: null,
                       			 lmtGroup:$("#limit_group").data("kendoDropDownList").value(),
                       			applyToClnInd:$("#client").is(":checked") ? "Y" : "N",
        	                            applyToCptyInd:$("#counterparty").is(":checked") ? "Y" : "N",
                       			 lmtTypeDesc:$("#limit_type").val(),
                       			 baseNature:$("#baseNature").data("kendoDropDownList").value(),
                       			 lmtTypeCode:$("#limit_code").val(),
                       			 category:$("#create_category").data("kendoDropDownList").value(),
                       			 aggLvl:$("#aggregate_level").data("kendoDropDownList").value(),
                       			 ccfRatio:ccfConversion($("#ccf_percentage").data("kendoNumericTextBox").value(),'',false),
                       			 parentLmtTypeCode:$("#parent_limit_type").data("kendoDropDownList").value(),
                       			 hierarchyLvl:$("#hierarchy_level").data("kendoDropDownList").value(),
                       			 approvalMatrixOption:$("#aproval_matrix_option").data("kendoDropDownList").value(),
                       			 crStatus: "Saved",
                       			 crAction: "UPDATE",
                       				 lastApproveStatusInd:"",
        	                       		lastApproveCrId:"",
        	                       		crRemark:"",
        	                       		crBy:window.sessionStorage.getItem('username'),
        	                       		crDt:"",
        	                       		verifyBy:"",
        	                       		verifyDt:"",
        	                       		approveBy:"",
        	                       		approveDt:"",
        	                       		createBy:window.sessionStorage.getItem('username'),
        	                       		createDt:"",
        	                       		lastUpdateBy:"",
        	                       		lastUpdateDt:"",                  	
                               			},
                  
                       			
                       			 listLmtTpHierBuMapCr:gridData(limitparams_by_businessUnit),
                       			 listLmtTpHierEntityMapCr:gridData(limitparams_by_businessEntity),
                       			 userId: window.sessionStorage.getItem('username'),
                       			 funcId:"",
                       			 action: "T"
                          			 
                       	 }
                       	 dataSource.add(newlimit);
                       	 dataSource.sync();
                        }
                       
                       
                     
    				}
				 });
				 
				 $("#submitBtn").kendoButton({
					 click: function(){
		    				
                         if (validate_create_newlimitform.validate()) {
                        	
                        	 var newlimit = {
                        			 lmtTpHierCr: {
                        				 
                        				 parentLmtTpHier: null,
         	                            crId: null,
                        			 lmtGroup:$("#limit_group").data("kendoDropDownList").value(),
                        			 applyToClnInd:$("#client").is(":checked") ? "Y" : "N",
         	                         applyToCptyInd:$("#counterparty").is(":checked") ? "Y" : "N",
                        			 lmtTypeDesc:$("#limit_type").val(),
                        			 baseNature:$("#baseNature").data("kendoDropDownList").value(),
                        			 lmtTypeCode:$("#limit_code").val(),
                        			 category:$("#create_category").data("kendoDropDownList").value(),
                        			 aggLvl:$("#aggregate_level").data("kendoDropDownList").value(),
                        			 ccfRatio:ccfConversion($("#ccf_percentage").data("kendoNumericTextBox").value(),'',false),
                        			 parentLmtTypeCode:$("#parent_limit_type").data("kendoDropDownList").value(),
                        			 hierarchyLvl:$("#hierarchy_level").data("kendoDropDownList").value(),
                        			 approvalMatrixOption:$("#aproval_matrix_option").data("kendoDropDownList").value(),
                        			 crStatus: "Submit",
                        			 crAction: "UPDATE",
                        				 lastApproveStatusInd:"",
         	                       		lastApproveCrId:"",
         	                       		crRemark:"",
         	                       		crBy:window.sessionStorage.getItem('username'),
         	                       		crDt:"",
         	                       		verifyBy:"",
         	                       		verifyDt:"",
         	                       		approveBy:"",
         	                       		approveDt:"",
         	                       		createBy:window.sessionStorage.getItem('username'),
         	                       		createDt:"",
         	                       		lastUpdateBy:"",
         	                       		lastUpdateDt:"",                  	
                                			},
                   
                        			
                        			 listLmtTpHierBuMapCr:gridData(limitparams_by_businessUnit),
                        			 listLmtTpHierEntityMapCr:gridData(limitparams_by_businessEntity),
                        			 userId: window.sessionStorage.getItem('username'),
                           			 funcId:"",
                           			 action: "S"
                           			 
                        	 }
                        	 dataSource.add(newlimit);
                        	 dataSource.sync();
                         }
                        
	    				
	    				}
					 });
    			
    					 
          			$("#create_category").on("change",function(){
          			var creditconversionfactor = $("#ccf_percentage").data("kendoNumericTextBox");
          			var hierarchylevel = $("#hierarchy_level").data("kendoDropDownList");
          			if($("#create_category").val() == "In-Direct Credit Limit"){
          				creditconversionfactor.enable(false);
          				hierarchylevel.enable(false);
          				$("#ccf_percentage").attr("required",false);
          				creditconversionfactor.value("100");
          			}
          			else if ($("#create_category").val() == "LEE- Independent Limit"){	
          				$("#ccf_percentage").attr("required",true);
          				hierarchylevel.enable(false);
          				creditconversionfactor.enable(true);
          			}
          			else{
          				creditconversionfactor.enable(true);
          				$("#ccf_percentage").attr("required",true);
          				hierarchylevel.enable(true);	
          				$("#hierarchy_level").attr("required",true);
          			}
          				
          		});
          		
				// Validators    		
          		var validate_lpbybu = $("#lpbybusinessUnit_form").kendoValidator().data("kendoValidator");
          		var validate_lpbyentity = $("#lpbyEntity_form").kendoValidator().data("kendoValidator");
          		var validate_create_newlimitform = $("#create_newlimit_form").kendoValidator().data("kendoValidator");
          		
          		
		});
		closeModal();	
		
          		
		
          		
    	 
		    	 
	   			
	    	 
    	          		
    });
    
	    
	    /* Open spinner while getting the data from back-end*/
		function openModal() {
			$("#modal, #modal1, #modal2, #modal3").show();
		}
		/* Close spinner after getting the data from back-end*/
		function closeModal() {
			$("#modal, #modal1, #modal2, #modal3").hide();
			$(".empty-height").hide();
		}
		
		/* function replaceActionGraphics(){
			var graphics = "" ;
			graphics = graphics+"<span><a href='#'><img src='/ermsweb/resources/images/bg_update.png'/></a></span><span><a href='#'><img src='/ermsweb/resources/images/bg_discard.png'/></a></span>";
			return graphics;
		} */
		
		function checkClientCounterparty(limitjson){
	    	if(validateResponse(limitjson.applyToClnInd)=='Y'){
	    		return "Client";
	    	}else if(validateResponse(limitjson.applyToCptyInd)=='Y'){
	    		return "Counterparty";
	    	}else{
	    		return "";
	    	}
	    		
	}
		
		
	function validDate(obj){
		return kendo.toString( new Date(parseInt(obj)), "MM/dd/yyyy HH:MM:tt" )
	}
		
		function toReset(object){
			
  			object.find('[data-role="dropdownlist"]').each(function(){
  				var default_attr = $(this).attr("default-attr");
  				$(this).data("kendoDropDownList").value((default_attr) ? default_attr : "");
  			})
  			object.find('[data-role="numerictextbox"]').each(function(){
  				var default_attr = $(this).attr("default-attr");
  				$(this).data("kendoNumericTextBox").value((default_attr) ? default_attr : "");
  			})
  			
			}
		
		function checkboxValues(chkId){          	
          	return ($("#"+chkId).is(":checked")) ? "Y" : "N"; 
		}
		
		function gridData(object){
			var result = [];
			result = $(object).data("kendoGrid").dataSource.data();
			$.each(result, function(i, obj){
				if(obj.limitparamsbyBuId){
					delete obj.limitparamsbyBuId;
				}
				if(obj.limitparamsbyEntityId){
					delete obj.limitparamsbyEntityId;
				}
				delete obj.status;
			});
			return result;
		
		}
		
		function toBack(){
			//window.history.back();
			window.location = "/ermsweb/limitTypeMaintenance";
		}
		
		function validateResponse(data){
			return (data != null) ? data : "";
		}
		function ccfConversion(ccf,delim,view){
    		if(view){
    			return ccf*100 + delim;	
    		}else{
    			return ccf/100;
    		}
    		
    	}
    	
    </script>
    <body>
    	<div class="boci-limitType-wrapper">
    		<%-- <%@include file="header1.jsp"%> --%>
    		<div class="updateLimit-content-wrapper form">
    			<form id="create_newlimit_form">
    				<!-- <input type="hidden" id="pagetitle" name="pagetitle" value="Limit Type Maintenance-Update Limit Type"> -->   
					 <div class="page-title">Maintenance - Limit Type Maintenance-Update Limit Type</div>
	    			<div class="command-button-Section">
	    				<button id="saveBtn" class="k-button" type="button">Save</button>
	    				<button id="submitBtn" class="k-button" type="button">Submit</button>
	    				<button id="clearBtn" class="k-button toClear" type="button">Clear</button>
	    				<button id="backBtn" class="k-button" type="button">Back</button>
	    			</div>
	    			<div class="confirm-del"></div>
	    			<div class="clear"></div>
	    			<div class="limitType-details">
	    			
	   					<div class="limitType-details-header">Limit Type Details </div>
	   					<table>
	   						<tr>
	   							<td>Limit Group</td>
	   							<td>
	   								<div id="limit_group_label"><label>Presettlment Limit</label></div>
	   							</td>
	   							<td>
	   								Cient/Counterparty
	   							</td>
	   							<td>
	   								<div id="client_counterparty_label"><label>Presettlment Limit</label></div>
								</td>
	   						</tr>
	   						<tr>
	   							<td>Limit Type</td>
	   							<td>
	   								<div id="limit_type_label"><label>Presettlment Limit</label></div>
	   							</td>
	   							<td>
	   								Base Nature
	   							</td>
	   							<td>
	   								<div id="base_nature_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Limit Code</td>
	   							<td>
	   								<div id="limit_code_label"><label>Presettlment Limit</label></div>
	   							</td>
	   							<td>
	   								Category
	   							</td>
	   							<td>
	   								<div id="category_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Aggregate Level</td>
	   							<td>
	   								<div id="aggregate_level_label"><label>Presettlment Limit</label></div>
	   							</td>
	   							<td>
	   								Credit Conversion Factors (CCF)
	   							</td>
	   							<td>
	   								<div id="ccf_percentage_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   					</table>
	    			</div>
	    			
	    			<div class="hierarchy-structure-details">
	   					<div class="hierarchy-details-header">Hierarchy Structure</div>
	   					<table>
	   						<tr>
	   							<td>Parent Limit Type</td>
	   							<td>
	   								<div id="parent_limittype_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Hierarchy Level</td>
	   							<td>
	   								<div id="hierarchy_level_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   						
	   					</table>
	    			</div>
	    			
	    			<div class="limit-parameter-details">
	   					<div class="limit-parameter-details-header">Limit Parameters</div>
	   					<table>
	   						<tr>
	   							<td>Aproval Matrix Option</td>
	   							<td>
	   								<div id="approval_matrix_label"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   					</table>
	    			</div>
    			</form>
    			<div class="limit-parameter-details form">
   					<div class="limit-parameter-details-header">Limit Parameters by Business Unit</div>
   					<form id="lpbybusinessUnit_form" rowid="">
	   					<table>
	   						<tr>
	   							<td colspan="4" align="right">
	   								<button id="lpbybunewBtn" class="k-button" type="button">New</button>
				    				<button id="lpbybuupdateBtn" class="k-button" type="button">Update</button>
				    				<button id="lpbybudeleteBtn" class="k-button" type="button">Delete</button>
				    				<button id="lpbybuclearBtn" class="k-button toClear" type="button">Clear</button>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Business Unit</td>
	   							<td colspan="3">
	   								<input id="business_unit_label" default-attr="" value="" name="businessUnit" required data-required-msg="Business Unit is required"></input>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Limit Deficit Buffer Amount 1 (HKD)</td>
	   							<td>
	   								<input class="amount_numeric" id="limit_dbuffer_amountOne" type="number" maxlength="23" name="LimitbufferAmountOne" required default-attr="0"/>
	   							</td>
	   							<td>Limit Deficit Buffer Amount 2 (HKD)</td>
	   							<td>
	   								<input class="amount_numeric" id="limit_dbuffer_amountTwo" type="number"  maxlength="23" name="LimitbufferAmountTwo" required default-attr="0"/>
	   							</td>
	   						</tr>
	   						
	   						<tr>
	   							<td>Limit Utilization Threshold Percent 1</td>
	   							<td>
	   								<input class="percentage_numeric" default-attr="100" id="limit_uthreshold_percentageOne" type="number" name="limitUthresholdPercentageOne" required/><span class="percentage-notation">&#37</span>
	   							</td>
	   							<td>Limit Utilization Threshold Percent 2</td>
	   							<td>
	   								<input class="percentage_numeric"  default-attr="100" id="limit_uthreshold_percentageTwo" type="number" name="limitUthresholdPercentageTwo" required /><span class="percentage-notation">&#37</span>
	   							</td>
	   						</tr>
	   						
	   						<tr>
	   							<td>Overdue or 
									Margin Call Buffer Amount 1 (HKD)
								</td>
	   							<td>
	   								<input class="amount_numeric"  default-attr="0" id="margin_cbuffer_amountOne" maxlength="23" type="number" name="margincbufferamountOne" required />
	   							</td>
	   							<td>Overdue or 
									Margin Call Buffer Amount 2 (HKD)
								</td>
	   							<td>
	   								<input class="amount_numeric"  default-attr="0" id="margin_cbuffer_amountTwo" maxlength="23" type="number" name="margincbufferamountTwo" required/>
	   							</td>
	   						</tr>
	   						
	   						<tr>
	   							<td>Margin Call Threshold Percent 1</td>
	   							<td>
	   								<input class="percentage_numeric" default-attr="100" id="margin_cthreshold_percentageOne" type="number" name="margincthresholdpercentageOne" required/><span class="percentage-notation" >&#37</span>
	   							</td>
	   							<td>Margin Call Threshold Percent 2</td>
	   							<td>
	   								<input class="percentage_numeric" default-attr="100" id="margin_cthreshold_percentageTwo" type="number" name="margincthresholdpercentageTwo" required/><span class="percentage-notation">&#37</span>
	   							</td>
	   						</tr>
	   						
	   						<tr>
	   							<td>Collateral Mitigation Percent</td>
	   							<td>
	   								<input class="percentage_numeric" default-attr="100" id="collateral_mitigation_percentage" type="number" name="collateralMitigationPercentage" required /><span class="percentage-notation">&#37</span>
	   							</td>
	   							<td>Economic Capital Percent</td>
	   							<td>
	   								<input class="percentage_numeric"  default-attr="100" id="economic_capital_percentage" type="number" name="economicCapitalPercentage" required /><span class="percentage-notation">&#37</span>
	   							</td>
	   						</tr>
	   						
	   						<tr>
	   							<td>Risk Weight Percent for Loan 
									Exposure >= 5&#37</span>of BOCI Capital
								</td>
	   							<td>
	   								<input class="percentage_numeric" default-attr="100"  id="riskweight_greaterthanfive_percentage" type="number" name="riskweightgreaterthanfivepercentage" required  /><span class="percentage-notation">&#37</span>
	   							</td>
	   							<td>Risk Weight Percent for Loan 
									Exposure < 5&#37</span>of BOCI Capital
								</td>
	   							<td>
	   								<input class="percentage_numeric" default-attr="100" id="riskweight_lessthanfive_percentage" type="number" name="riskweightlessthanfivepercentage" required  /><span class="percentage-notation">&#37</span>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Board Approved Limit Amount</td>
	   							<td colspan="3">
	   								<input id="board_approved_limit_currencybybu" class="board_approved_limit_currency marginright" default-attr="" value="" name="currency" required data-required-msg="Choose the Currency" ><input required class="boardamount_numeric" default-attr="" maxlength="23" id="board_approved_amountbybu" type="number" name="BoardApprovedAmount" required />
	   							</td>
	   						</tr>
	   						
	   					</table>
   					</form>
    			</div>
    			
    			<div class="display-limitparams-section">
    				
 					<table>
 						<tr>
 							<td><div class="list-header">Limit Parameters by Business Unit</div>
 						</tr>
	 					<tr>
							<td>
								<div id="limitparams_by_businessUnit">
									<!-- <table id="list-header1" class="grid-container" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<th></th>	
										</tr>								
									</table> -->							
								</div>
								
								<div id="modal1" class="model-loader" align="center" style="display:none;">
									<img id="loader" src="images/ajax-loader.gif" />
								</div>						
							</td>
						</tr>		
 						
 						
 					</table>
    			</div>
    			
    			<div class="limit-parameter-details form">
   					<div class="limit-parameter-details-header">Limit Parameters by Entity</div>
   					<form id="lpbyEntity_form" rowid="">
	   					<table>
	   						<tr>
	   							<td colspan="2" align="right">
	   								<button id="lpbyentitynewBtn" class="k-button" type="button">New</button>
				    				<button id="lpbyentityupdateBtn" class="k-button" type="button">Update</button>
				    				<button id="lpbyentitydeleteBtn" class="k-button" type="button">Delete</button>
				    				<button id="lpbyentityclearBtn" class="k-button toClear" type="button">Clear</button>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Entity</td>
	   							<td>
	   								<input id="entity_label" value="" default-attr=""  name="entity" required data-required-msg="Entity is required"></input>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Board Approved Limit Amount</td>
	   							<td>
	   								<input id="board_approved_limit_currencybyentity" class="board_approved_limit_currency marginright" default-attr="" value="" name="currency" required data-required-msg="Choose the Currency" ></input><input class="boardamount_numeric" id="board_approved_amountbyentity" default-attr="" maxlength="23" name="Board Approved Amount" type="number" required />
	   							</td>
	   						</tr>
	   					</table>
   					</form>
    			</div>
    			
    			<div class="display-limitparams-section">
    				
 					<table>
 						<tr>
 							<td><div class="list-header">Limit Parameters by Entity</div></td>
 						</tr>
 						<tr>
							<td>
								<div id="limitparams_by_businessEntity">
									<!-- <table id="list-header1" class="grid-container" cellpadding="0" cellspacing="0" border="0">
										<tr>
											<th></th>	
										</tr>								
									</table> -->							
								</div>
								
								<div id="modal1" class="model-loader" align="center" style="display:none;">
									<img id="loader" src="images/ajax-loader.gif" />
								</div>						
							</td>
						</tr>		
 						<!-- <th>
 							Entity
 						</th>
 						<th>
 							Board Approved Limit Amount
 						</th> -->
 					
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
