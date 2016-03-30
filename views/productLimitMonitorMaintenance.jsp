<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
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
	<!-- jQuery JavaScript -->
	<script src="/ermsweb/resources/js/jquery.min.js"></script>
	<script src="/ermsweb/resources/js/jszip.js"></script>
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
	<!-- <script src="http://kendo.cdn.telerik.com/2014.3.1029/js/kendo.all.min.js"></script>
	 -->
	<script type="text/javascript">
		// used to sync the exports
		var promises = [
			$.Deferred(),
			$.Deferred()
		];
		$(document).ready(function () {
			/* Control and initialize the menu bar of header
			 (8 options of menu)
			*/
			$("#menu1").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			$("#menu2").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			$("#menu3").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			$("#menu4").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			$("#menu5").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			$("#menu6").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			$("#menu7").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});	
			
			/* $("#prodType").kendoDropDownList({
				optionLabel: "Select"
			}); */
			var getLmtDroplist=window.sessionStorage.getItem('serverPath')+"lmtMonitorRule/getLmtProdTypeList?userId="+window.sessionStorage.getItem('username');
			var ddlLimitProductDataSource = new kendo.data.DataSource({
				transport: {
					read: {
						url: getLmtDroplist,
						dataType: "json",
						xhrFields: {
                            withCredentials: true
                           }
					}
				},
				schema:{
					data: function(data){
						return [data];
					}
				}				
			});
			
			$("#limitType").val(checkUndefinedElement(sessionStorage.getItem("limitType")));
			
			ddlLimitProductDataSource.fetch(function(){
				var dsData = this.view()[0];
				$('#limitType').kendoDropDownList({
					optionLabel: "Select",
					dataTextField: "lmtDesc",
					dataValueField: "lmtType",
					dataSource: dsData,
					change:function(e){
						var dsProductTypes = dsData[this.selectedIndex - 1];
						fecthProducts(dsProductTypes)
						
					}
				});
				/*by default validating the Session values and populating the values*/
				//console.log($("#limitType").data("kendoDropDownList").select());// gets the Selected Index of the Kendo Dropdown
				if($("#limitType").val()){
					$("#limitType").data("kendoDropDownList").trigger("change");
					
					var objProdTypeList = checkUndefinedElement(sessionStorage.getItem("prodType")).match(/(?=\S)[^,]+?(?=\s*(,|$))/g);
					$('#prodType').val((objProdTypeList) ? objProdTypeList : "");
				}
			});
			
			function fecthProducts(dsProductTypes){
				var optionHtml = "";
				var disableFlag = ((dsProductTypes.lmtType).toLowerCase() == "all") ? true : false;
				$.each(dsProductTypes.product, function(index, element){
					if((dsProductTypes.lmtType).toLowerCase() == "all"){
						optionHtml = optionHtml+"<option value='"+element.prodType+"' selected>"+element.prodType+"</option>";	
					}else{
						optionHtml = optionHtml+"<option value='"+element.prodType+"'>"+element.prodType+"</option>";
					}
					
				});
				$('#prodType').html(optionHtml);
				$('#prodType').prop("disabled", disableFlag);
			}
			
			$('#entity').kendoDropDownList({
				dataSource: ["BOCIL","BOCIS","BOCIFP","BOCIGC","BOCI Finance","ALL"],
				value: "ALL",
				index:0
			});
			
			$('#groupType').kendoDropDownList({
				optionLabel: "Select",
				dataTextField: "dataText",
				dataValueField: "dataField",
				dataSource: {
					transport: {
						read: {
							url: window.sessionStorage.getItem('serverPath')+"common/getGroupTypeList",
							dataType: "json",
							xhrFields: {
                            withCredentials: true
                           }
						}
					}
				},
				index:0
			}); 
			
			$('#limitCcy').kendoDropDownList({
				optionLabel: "Select",
				dataTextField: "dataText",
				dataValueField: "dataField",
				dataSource: {
					transport: {
						read: {
							url: window.sessionStorage.getItem('serverPath')+"common/getCcyList",
							dataType: "json",
							xhrFields: {
                            withCredentials: true
                           }
						}
					}
				},
				index:0
			}); 
			
			var limitOperatorData = [
       			{ text: "=", value: "EQ" },
       			{ text: ">=", value: "GEQ" },
       			{ text: "<=", value: "LEQ" },
       			{ text: ">", value: "GTR" },
       			{ text: "<", value: "LSS" },
       		];
         				
       		$("#limitOperator").kendoDropDownList({
       			optionLabel: "Select",
       			dataTextField: "text",
       			dataValueField: "value",
       			dataSource: limitOperatorData,
       			index: 0
       		});	
			
			$('#limitAmt').kendoNumericTextBox({
				decimals:2,			
				spinners: false
			});
			
			var queryFieldsObj = [];
			
			$("input[name='queryOn']").each(function(){
				$(this).click(function(){
					var enab_class = ".on-"+$(this).attr("link-input");
					var queryFields;
					queryFieldsObj = [];
					$(".disabled-off").prop("disabled", true).removeClass("enabled-border").val("");
					
					$(".disabled-off:hidden").each(function(){
						if($(this).hasClass("select-textbox")){
							$("#"+$(this).attr("id")).data("kendoDropDownList").value("ALL");
							$("#"+$(this).attr("id")).data("kendoDropDownList").enable(false);					
						}
					});
					
					$(enab_class).each(function(){
						queryFields = ($(this).attr("id")) ? $(this).attr("id") : "";
						var inputId = "#"+queryFields;
						($(inputId).data("kendoDropDownList")) ? $(inputId).data("kendoDropDownList").enable(true) : ($(inputId).data("kendoNumericTextBox")) ? $(inputId).data("kendoNumericTextBox").enable(true) : $(inputId).prop("disabled", false).addClass("enabled-border");
						
						if(queryFields){
							queryFieldsObj.push(queryFields);
						}
					});			
				});
			});	
			
			
			//Fetching Search Criteria values from Session
			$("#entity").val(checkUndefinedElement(sessionStorage.getItem("entity")));
			$("#Acct").val(checkUndefinedElement(sessionStorage.getItem("Acct")));
			$("#subAcct").val(checkUndefinedElement(sessionStorage.getItem("subAcct")));
			if(checkUndefinedElement(sessionStorage.getItem("Acct"))){
				$("#radio_account").prop("checked",true);
			}
			
			$("#client").val(checkUndefinedElement(sessionStorage.getItem("client")));
			if(checkUndefinedElement(sessionStorage.getItem("client"))){
				$("#radio_client").prop("checked",true);
			}
			
			$("#groupType").val(checkUndefinedElement(sessionStorage.getItem("groupType")));
			$("#group").val(checkUndefinedElement(sessionStorage.getItem("group")));
			if(checkUndefinedElement(sessionStorage.getItem("groupType"))){
				$("#radio_group").prop("checked",true);
			}
			
			$("#limitCcy").val(checkUndefinedElement(sessionStorage.getItem("limitCcy")));
			$("#limitOperator").val(checkUndefinedElement(sessionStorage.getItem("limitOperator")));
			$("#limitAmt").html(checkUndefinedElement(window.sessionStorage.getItem("limitAmt")));
			
			
			enable_radio_inputs();
			
			function enable_radio_inputs(){		
				var radio_checked = $("input[name='queryOn']:checked").attr("link-input");
				if(radio_checked){
					var enab_class = ".on-"+radio_checked;
					var queryFields;
					queryFieldsObj = [];
					$(".disabled-off").prop("disabled", true).removeClass("enabled-border");
					
					$(enab_class).each(function(){
						queryFields = ($(this).attr("id")) ? $(this).attr("id") : "";
						var inputId = "#"+queryFields;
						($(inputId).data("kendoDropDownList")) ? $(inputId).data("kendoDropDownList").enable(true) : ($(inputId).data("kendoNumericTextBox")) ? $(inputId).data("kendoNumericTextBox").enable(true) : $(inputId).prop("disabled", false).addClass("enabled-border");
						
						if(queryFields){
							queryFieldsObj.push(queryFields);
						}
					});				
				}
			}
			
			
			//Export button click
			$("#exportBtn").kendoButton({
				click: function(){
					var gridListArray = ["active-list","cr-list"];// Id's of the kendo Grids, pass coma seperated if you have more than 1 grid in this page
					ExportData(gridListArray);//Passing Grid names in an Array Object
				}
			});
			
			//Search button click
			$("#submitBtn").kendoButton({
				click: function(){
					var input = $("input:text, select");
					var valid=0;
					for(var i=0;i<input.length;i++){
						if($.trim($(input[i]).val()).length > 0){
							valid = valid + 1;
						}
					}
					
					if($("#limitType").val()){
						valid = (!$("#prodType").val()) ? -1 : 1;
					}
					
					if($("#groupType").val()){
						valid = (!$("#group").val()) ? -2 : 1;
					}
					
					if(valid > 0){
						var paramproductType = $("#prodType").val();
						
						dataGrids(queryFieldsObj);						
						window.sessionStorage.setItem('limitType',$("#limitType").val());						
						window.sessionStorage.setItem('prodType',(paramproductType) ? paramproductType.toString() : "");
						window.sessionStorage.setItem('entity',$("#entity").val());
						window.sessionStorage.setItem('Acct',$("#Acct").val());
						window.sessionStorage.setItem('subAcct',$("#subAcct").val());						
						window.sessionStorage.setItem('client',$("#client").val());
						window.sessionStorage.setItem('groupType',$("#groupType").val());
						window.sessionStorage.setItem('group',$("#group").val());
						window.sessionStorage.setItem('limitCcy',$("#limitCcy").val());
						window.sessionStorage.setItem('limitOperator',$("#limitOperator").val());
						window.sessionStorage.setItem('limitAmt',$("#limitAmt").val());
					}else if(valid == -1){
						alert("Please select Product Type.");
					}else if(valid == -2){
						alert("Please enter Group desc.");
					}
					else{
						alert("Atleast One Field is Required");
					}				
				}
			});
			
			//Reset button click
			$("#resetBtn").kendoButton({
				click: function(){
					$(".one-required").each(function(i){
						var attrId = $(this).attr("id");
						if(attrId){
							var ddlClass = $(this).hasClass("select-textbox");
							var ddlMultiClass = $(this).hasClass("multi-select");
							var numClass = $(this).hasClass("num-text");
							if(ddlClass){
								$("#"+attrId).data("kendoDropDownList").value("ALL");
							}else if(numClass){
								$("#"+attrId).data("kendoNumericTextBox").value("");
							}else if(ddlMultiClass){
								$("#"+attrId).html("");
							}else{
								$(this).val("");
							}
						}
					});
					window.sessionStorage.removeItem("limitType");
					window.sessionStorage.removeItem("prodType");
					window.sessionStorage.removeItem("entity");
					window.sessionStorage.removeItem("Acct");
					window.sessionStorage.removeItem("subAcct");
					window.sessionStorage.removeItem("client");
					window.sessionStorage.removeItem("groupType");
					window.sessionStorage.removeItem("group");
					window.sessionStorage.removeItem("limitCcy");
					window.sessionStorage.removeItem("limitOperator");
					window.sessionStorage.removeItem("limitAmt");
					
				}
			});
		});
		
		//Displaying Data in the Grids
		function dataGrids(queryFieldsObj){		
			//$(".empty-height").hide();
			openModal();
			var paramLimitType = $('#limitType').val();
			var paramproductType = $('#prodType').val(); 
			var searchCriteria = {
				limitType:paramLimitType, 
				userId:window.sessionStorage.getItem('username'),
				productType:(paramproductType) ? paramproductType.toString() : "", 
				entity:$('#entity').val(),
				limitCcy:$('#limitCcy').val(), 
				limitOperator:$('#limitOperator').val(), 
				limitAmount:$('#limitAmt').val()
			};		
			
			$.each(queryFieldsObj, function(index, fieldName){
				searchCriteria[fieldName] = $("#"+fieldName).val();			
			});
			
			
			var getActiveListDetailsURL = window.sessionStorage.getItem('serverPath')+"lmtMonitorRule/getDetails";
			var activeDataSource = new kendo.data.DataSource({
				transport: {
					read: {
						url: getActiveListDetailsURL,
						dataType: "json",
						xhrFields: {
                            withCredentials: true
                           },
						data:searchCriteria
					}
				},
				schema:{
					data: function(data){
						return [data];
					}
				},	
				pageSize: 3
			});
			
			var getCrListDetailsURL = window.sessionStorage.getItem('serverPath')+"lmtMonitorRule/getDetailsChangeRequest";//"/ermsweb/resources/js/getProductLimitMonitorDetails.json";//window.sessionStorage.getItem('serverPath')+"lmtMonitorRule/getDetailsChangeRequest";//getProductLimitMonitorChangeRequest.json";
			
			var changeRequestDataSource = new kendo.data.DataSource({
				transport: {
					read: {
						url: getCrListDetailsURL,
						dataType: "json",
						xhrFields: {
                            withCredentials: true
                           },
						data:searchCriteria
						
						
						
					}
				},
				schema:{
					data: function(data){
						return [data];
					}
				},	
				pageSize: 3
			});
	
			$("#active-list").kendoGrid({
				excel: {
					 allPages: true
				},
				dataSource: activeDataSource,
				sortable:false,
				scrollable:false,
				pageable: true,
				columns:[
					{ field: "ruleName", title:"Monitor Rule Name", autoWidth:true},
					{ field: "lmtTypeDesc",title:"Limit Type", autoWidth:true},
					{ field: "prodTypeList", title:"Product Type", autoWidth:true},
					{ field: "ruleBookEntity",title:"Entity", autoWidth:true},
					{ field: "Acct",title:"Account", template:"#=displayByParty(partyType,'account',partyName)#", autoWidth:true},
					{ field: "client", title:"Client/Counterparty",template:"#=displayByParty(partyType,'client',partyName)#", autoWidth:true},
					{ field: "groupTypeDesc", title:"Group Type",autoWidth:true},
					{ field: "group", title:"Group",template:"#=displayByParty(partyType,'group',partyName)#", autoWidth:true},
					{ field: "ruleLmtCcy", title:"Limit CCY",autoWidth:true},
					{ field: "ruleLmtAmt", title:"Limit Amount",autoWidth:true},
					{ field: "firstWarnRatio", title:"1st Warning Ration",autoWidth:true},
					{ field: "secondWarnRatio",title:"2nd Warning Ration", autoWidth:true},
					{ field: "action",title:"Action", template:"#=replaceActionGraphics('|',false,action,ruleName)#", autoWidth:true}
				]
			});
			
			$("#cr-list").kendoGrid({
				excel: {
					 allPages: true
				},
				dataSource: changeRequestDataSource,
				sortable:false,
				scrollable:false,
				pageable: true,
				columns:[
					{ field: "ruleName", title:"Monitor Rule Name", autoWidth:true},
					{ field: "lmtTypeDesc", title:"Limit Type", autoWidth:true},
					{ field: "prodTypeList", title:"Product Type", autoWidth:true},
					{ field: "ruleBookEntity", title:"Entity",autoWidth:true},
					{ field: "Acct",title:"Account", template:"#=displayByParty(partyType,'account',partyName)#", autoWidth:true},
					{ field: "client", title:"Client/Counterparty",template:"#=displayByParty(partyType,'client',partyName)#", autoWidth:true},
					{ field: "groupTypeDesc", title:"Group Type",autoWidth:true},
					{ field: "group", title:"Group",template:"#=displayByParty(partyType,'group',partyName)#", autoWidth:true},
					{ field: "ruleLmtCcy", title:"Limit CCY",autoWidth:true},
					{ field: "ruleLmtAmt", title:"Limit Amount",autoWidth:true},
					{ field: "firstWarnRatio", title:"1st Warning Ration",autoWidth:true},
					{ field: "secondWarnRatio",title:"2nd Warning Ration", autoWidth:true},
					{ field: "lastUpdateBy", title:"Updated By", autoWidth:true},
					{ field: "lastUpdateDt", title:"Update time", template: '#= kendo.toString( new Date(parseInt(lastUpdateDt)), "MM/dd/yyyy HH:MM:tt" ) #', autoWidth:true},
					{ field: "crStatus", title:"Status",autoWidth:true},
					{ field: "action", title:"Action", template:"#=replaceActionGraphics('|',true,action,crId)#", autoWidth:true}
				]			
			});
			
			closeModal();
		}
		
		function ExportData(gridRef){
			var dataView = [];
			var cells = [];
			var excellSheets = [];
			
			//console.log(gridRef.length);
			$.each(gridRef, function(i){
				var gridobject = $("#"+gridRef[i]).data("kendoGrid");
				if(gridobject){
					dataView[i] = gridobject.dataSource.view();
					excellSheets.push({
						rows:[],
						title:gridRef[i],
						columns:[]
					});
					
					$("#"+gridRef[i]).find("th").each(function(){
						var headerColumn = $(this).text();
						cells.push({value:headerColumn});
						excellSheets[i].columns.push({autoWidth: true });
					});
					excellSheets[i].rows.push({cells:cells});
					cells = [];
					
					$.each(dataView[i], function(j){ // Iterating the Data Rows
						$.each(gridobject.columns, function(index, element){
							var dataString = " "+dataView[i][j][element.field];
							cells.push({value:($.trim(dataString) == "undefined" || $.trim(dataString) ==  "null") ? "" : dataString});
						});
						excellSheets[i].rows.push({cells:cells});// Inserting the Row Data
						cells = [];
					});					
				}
			});
			//console.log(excellSheets);
			if(excellSheets.length > 0){
				var workbook = new kendo.ooxml.Workbook({
				  sheets: excellSheets
				});
				//save the file as Excel file with extension xlsx
				kendo.saveAs({dataURI: workbook.toDataURL(), fileName: "ProductMonitorRulesList.xlsx"});
			}
			
		}
		
		/* Handle underfined / null element */
		function checkUndefinedElement(element){			
			if(element === null || element === "undefined"){
				return "";
			}else{
				return element;
			}
		}
		
		function displayByParty(partyType, fieldColumn, partyName){
			//alert("partyType"+partyType);
			if($.trim(partyType).toLowerCase() != fieldColumn){
				return "";
			}else{
				return partyName;
			}
		}
		
		function replaceActionGraphics(delim, crStatus, data, ruleId){
			if(data!=null){
				var spltarr = data.split(delim);
				var split_string = "";
				$.each(spltarr, function(j){
					//console.log(spltarr[j]);
					if(spltarr[j] != ""){
						switch(spltarr[j]){
						case "V":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/productLimitMonitorRuleDetailsView?ruleId="+ruleId+"'><img src='/ermsweb/resources/images/bg_view.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/productMonitorRuleChangeRequestView?ruleId="+ruleId+"'><img src='/ermsweb/resources/images/bg_view.png'/></a>";
							}
							break;
						case "E":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/productLimitMonitorRuleUpdate?ruleId="+ruleId+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/productMonitorRuleChangeRequestUpdate?ruleId="+ruleId+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							}
							break;
						case "A":
							split_string = split_string+"<a href='/ermsweb/productMonitorRuleVerify?ruleId="+ruleId+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							break;
						case "D":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/productLimitMonitorRuleDelete?ruleId="+ruleId+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/productMonitorRuleDiscardChangeRequest?ruleId="+ruleId+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
							}
							break;
						case "X":
								split_string = split_string+"<a href='/ermsweb/productLimitMonitorRuleDelete?ruleId="+ruleId+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
							break;
						default:
							split_string = "";
							break;
						}
					}
				});
				//console.log("split_string: "+split_string);
				return split_string;
			}
		}
		
		function expandCriteria(){
			var filterBody = document.getElementById("search-filter-body").style.display;
			if(filterBody == "block"){
				document.getElementById("search-filter-body").style.display = "none";
				document.getElementById("filter-table-heading").innerHTML = "(+) Filter Criteria";
			}else{
				document.getElementById("search-filter-body").style.display = "block";
				document.getElementById("filter-table-heading").innerHTML= "(-) Filter Criteria";
			}
		}
		
		function openModal() {
		     $("#modal, #modal1").show();
		}

		function closeModal() {
		    $("#modal, #modal1").hide();	    
		}
    </script>
    <style>
		.select-textbox, .k-textbox{
			width:150px;
		}
		.num-text{
			width:390px;
			border:none;
		}
		.multi-select{
			width:150px;
			height:60px;
		}
		
	</style>
</head>
<body>
	<div class="boci-wrapper">
	<%@include file="header1.jsp"%>
		<div id="boci-content-wrapper">
			<div class="page-title">Maintenance - Product Limit Monitor</div>
			<div class="redirect-buttons">
				<a href="/ermsweb/productLimitMonitorRuleCreate" class="k-button">Create New Monitor Limit</a>
			</div>
			<div class="filter-criteria">
				<div id="filter-table-heading" onclick="expandCriteria()">(-) Filter Criteria</div>
				<table class="list-table">					
					<tbody id="search-filter-body" style="display: block;">
						<tr>
							<td>Limit Type</td>
							<td><input id="limitType" type="text" class="select-textbox one-required"/></td>
							<td>Product Type</td>
							<td><select multiple class="multi-select one-required" name="prodType" id="prodType"></select></td>
							
							<td>Entity</td>
							<td colspan="2"><input id="entity" type="text" class="select-textbox one-required"/></td>
						</tr>
						<tr>
							<td colspan="7">&nbsp;</td>
						</tr>
						
						<tr>
							<td><input type="radio" name="queryOn" link-input="account" id="radio_account"/><label for="radio_account" class="radio-label">Account</label></td>
							<td>
								<input id="Acct" type="text" class="k-textbox on-account disabled-off one-required" disabled="disabled"/>
								<span class="spanlabel">Sub Account</span><input id="subAcct" type="text" class="k-textbox on-account disabled-off one-required" disabled="disabled"/>
							</td>
							
							<td><input type="radio" name="queryOn" link-input="client" id="radio_client"/><label for="radio_client" class="radio-label">Client</label></td>
							<td><input id="client" type="text" class="k-textbox on-client disabled-off one-required" disabled="disabled"/></td>
							
							<td><input type="radio" name="queryOn"  link-input="group" id="radio_group"/><label for="radio_group" class="radio-label">Group</label></td>
							<td colspan="2">
								<input id="groupType" type="text" class="select-textbox on-group disabled-off one-required" disabled="disabled"/>
								<input id="group" type="text" class="k-textbox on-group disabled-off one-required" disabled="disabled"/>
							</td>
						</tr>
						<tr>
							<td colspan="7">&nbsp;</td>
						</tr>
						
						<tr>
							<td>Limit CCY</td>
							<td><input id="limitCcy" type="text" class="select-textbox one-required"/></td>					
						
							<td>Limit Amount</td>
							<td colspan="4">
								<input id="limitOperator" type="text" value="GEQ" class="select-textbox one-required"/>
								<input id="limitAmt" type="text" maxlength="41" class="k-textbox num-text one-required"/>
							</td>							
						</tr>
						<tr>
							<td colspan="7" align="right">
								<button id="submitBtn" class="k-button" type="button">Search</button>
								<button id="resetBtn" class="k-button" type="button">Reset</button>
								<button id="exportBtn" class="k-button" type="button">Export</button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<div id="search_result_container">
				<div id="active-list-container">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td colspan="8">
								<div class="list-header">Product Limit Monitor Rule</div>
							</td>
						</tr>
						<tr>
							<td>
								<div id="active-list">
														
								</div>
								<div id="modal">
									<img id="loader" src="images/ajax-loader.gif" />
								</div>						
							</td>
						</tr>					
					</table>
				</div>
				<div id="cr-list-container">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td colspan="11">
								<div class="list-header">Monitor Rule change request Table</div>
							</td>
						</tr>
						<tr>
							<td>
								<div id="cr-list">
															
								</div>
								<div id="modal1">
									<img id="loader" src="images/ajax-loader.gif" />
								</div>						
							</td>
						</tr>					
					</table>
				</div>
				<div class="clear"></div>
			</div>									
		</div>
	</div>	
</body>
</html>