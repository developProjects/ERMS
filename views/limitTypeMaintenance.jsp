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
	
	
	<script src="/ermsweb/resources/js/jszip.min.js"></script>
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
	
	<style>
	.num-text {
	width: 100px;
	border: none;
   }
	</style>
	<script type="text/javascript">
	// used to sync the exports
	var promises = [
		$.Deferred(),
		$.Deferred()
	];
		$(document).ready(function () {
			
			var limitGroupData = [
				{ text: "Pre-Settlement Risk Limit", value: "1" },
				{ text: "Settlement Risk Limit", value: "2" },
				{ text: "Loan Limit", value: "3" },
				{ text: "Other Limit", value: "4" },
				{ text: "Trading Risk Limit", value: "5" },
				{ text: "ALL", value: "" }
			];
					
			$('#lmtGroup').kendoDropDownList({
				dataSource: ["Pre-Settlement Risk Limit","Settlement Risk Limit","Loan Limit","Other Limit","ALL"],
				value: "ALL",
				index:0
			});
			
			var getLmtTypeCodeDescMap = [
				{ text: "MARGIN LOAN LIMIT", value: "MARLOAN" },
				{ text: "DVP LIMIT", value: "DVP" },
				{ text: "LOAN LIMIT", value: "LOAN" },
				{ text: "LEE LIMIT", value: "LEE" },
				{ text: "ALL", value: "ALL" }
			];
			
			var getccfOperatorMap = [
			             				{ text: "= ", value: "EQ" },
			             				{ text: ">", value: "GTR" },
			             				{ text: "<", value: "LSS" },
			             				{ text: ">=", value: "GEQ" },
			             				{ text: "<=", value: "LEQ" }
			             			];
			$('#lmtTypeCode').kendoDropDownList({
				dataTextField: "text",
       			dataValueField: "value",
				dataSource: getLmtTypeCodeDescMap,
				index:0
			});
			$('#aggLvl').kendoDropDownList({
				dataSource: ["Limit","Facilities","ALL"],
				value: "ALL",
				index:0
			}); 
			$('#baseNature').kendoDropDownList({
				dataSource: ["Potential Exposure","Notional","ALL"],
				value: "ALL",
				index:0
			}); 
			$('#leeLvl').kendoDropDownList({
				dataSource: ["Level 1","Level 2","Level 3","Level 4","N/A","ALL"],
				value: "ALL",
				index:0
			}); 
			$('#ccfOperator').kendoDropDownList({
				dataTextField: "text",
       			dataValueField: "value",
				dataSource: getccfOperatorMap,
				index:0
			}); 		
			
			$('#ccfPercentage').kendoNumericTextBox({
				decimals:2,
				spinners: false,
				max: 100
			});
			
			//Fetching Search Criteria values from Session
			$("#lmtGroup").data("kendoDropDownList").value(checkUndefinedElement(sessionStorage.getItem("lmtGroup")));
			$("#lmtTypeCode").data("kendoDropDownList").value(checkUndefinedElement(sessionStorage.getItem("lmtTypeCode")));
			$("#aggLvl").data("kendoDropDownList").value(checkUndefinedElement(sessionStorage.getItem("aggLvl")));
			$("#baseNature").data("kendoDropDownList").value(checkUndefinedElement(sessionStorage.getItem("baseNature")));
			$("#leeLvl").data("kendoDropDownList").value(checkUndefinedElement(sessionStorage.getItem("leeLvl")));
			$("#ccfOperator").data("kendoDropDownList").value(checkUndefinedElement(sessionStorage.getItem("ccfOperator")));
			$("#ccfPercentage").data("kendoNumericTextBox").value(checkUndefinedElement(sessionStorage.getItem("ccfPercentage")));
			
			//Export button click
			$("#exportBtn").kendoButton({
				click: function(){
					// trigger export of the AccDetails grid
					var activeListDetailsKendoGrid = $("#active-list").data("kendoGrid");
					var crListDetailsKendoGrid = $("#cr-list").data("kendoGrid");
					// trigger export of the products grid
					if(activeListDetailsKendoGrid){
						activeListDetailsKendoGrid.saveAsExcel();
					}
					if(crListDetailsKendoGrid){
						crListDetailsKendoGrid.saveAsExcel();
					}
					
					 // wait for both exports to finish
					$.when.apply(null, promises)
					.then(function(activeDetails, crDetails) {
	
						// create a new workbook using the sheets of the products and orders workbooks
						var sheets = [
							activeDetails.sheets[0],
							crDetails.sheets[0]
						];
	
						sheets[0].title = "LimitType Active List";
						sheets[1].title = "LimitType Change Request List";
	
						var workbook = new kendo.ooxml.Workbook({
							sheets: sheets
						});
						// save the new workbook,b
						kendo.saveAs({
							dataURI: workbook.toDataURL(),
							fileName: "Limit_Maintenance_List.xlsx"
						})
					});
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
					if(valid >0){
						dataGrids();
						window.sessionStorage.setItem('lmtGroup',$("#lmtGroup").val());
						window.sessionStorage.setItem('lmtTypeCode',$("#lmtTypeCode").val());
						window.sessionStorage.setItem('aggLvl',$("#aggLvl").val());
						window.sessionStorage.setItem('baseNature',$("#baseNature").val());
						window.sessionStorage.setItem('leeLvl',$("#leeLvl").val());
						window.sessionStorage.setItem('ccfOperator',$("#ccfOperator").val());
						window.sessionStorage.setItem('ccfPercentage',$("#ccfPercentage").val());
					}
					else{
						alert("Atleast One Field is Required");
					}				
				}
			});
			
			var limitTypesTreeview = new kendo.data.DataSource({
				transport: {
					read: {
						//url: "/ermsweb/resources/js/limitHier.json",
						url: window.sessionStorage.getItem('serverPath')+"limitTypeHier/getLimitHierTypeTree?userId="+window.sessionStorage.getItem('username'),
						dataType: "json",
						xhrFields: {
                            withCredentials: true
                           }
					}
				}
			});
			
			limitTypesTreeview.fetch(function(){
				var dsView = this.view();
				var dsLimitTypes = [];
				$.each(dsView, function(i){
					dsLimitTypes.push(dsView[i].root);
				});
				
				$("#tree_view").kendoTreeView({
					dataTextField: ["data.lmtTypeDesc", "data.lmtTypeDesc"],
					dataSource:dsLimitTypes,
					select: onSelect
				});			
				
				//$("#tree_view").data("kendoTreeView").expand(".k-item");
			});	
			
			//Reset button click
			$("#resetBtn").kendoButton({
				click: function(){
					$(".one-required").each(function(i){
						var attrId = $(this).attr("id");
						if(attrId){
							var ddlClass = $(this).hasClass("select-textbox");
							var numClass = $(this).hasClass("num-text");
							if(ddlClass){
								$("#"+attrId).data("kendoDropDownList").value("ALL");
							}if(numClass){
								$("#"+attrId).data("kendoNumericTextBox").value("");
							}else{
								$(this).val("");
							}
						}
					});
					window.sessionStorage.removeItem("lmtGroup");
					window.sessionStorage.removeItem("lmtTypeCode");
					window.sessionStorage.removeItem("aggLvl");
					window.sessionStorage.removeItem("baseNature");
					window.sessionStorage.removeItem("leeLvl");
					window.sessionStorage.removeItem("ccfOperator");
					window.sessionStorage.removeItem("ccfPercentage");
					
				}
			});
		});
		
		function onSelect(e) {
			var dataItem = this.dataItem(e.node);
			dataGrids(dataItem);
		}
		//Displaying Data in the Grids
		function dataGrids(limitType){		
			openModal();
			var paramLimitType = (limitType) ? limitType.data.lmtTypeCode : $('#lmtTypeCode').val();
			var subTreeFlag = (limitType) ? "1" : "0";
			var searchCriteria = {
				lmtGroup:$('#lmtGroup').val(), 
				lmtTypeCode:paramLimitType, 
				aggLvl:$('#aggLvl').val(), 
				baseNature:$('#baseNature').val(), 
				leeLvl:$('#leeLvl').val(), 
				ccfRatioOp:$('#ccfOperator').val(), 
				ccfRatio:$('#ccfPercentage').val(),
				subTree:subTreeFlag,
				userId:window.sessionStorage.getItem('username')
			};
					
			//var getActiveListDetailsURL = "/ermsweb/searchLimitTypeData";
			var getActiveListDetailsURL =window.sessionStorage.getItem('serverPath')+"limitTypeHier/getLmtTypeHier";
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
				error:function(e){
									if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
								},
				pageSize: 3
			});
			
			//var getCrListDetailsURL = "/ermsweb/searchLimitTypeCRData";
			var getCrListDetailsURL =window.sessionStorage.getItem('serverPath')+"limitTypeHierCr/getLmtTypeHierCr"
			var changeRequestDataSource = new kendo.data.DataSource({
				transport: {
					read: {
						url: getCrListDetailsURL,
						dataType: "json",
						xhrFields: {
	                        withCredentials: true
	                    },
						//data:searchCriteria
	                    data:{
	                    	userId:window.sessionStorage.getItem('username'),
	                    	funcId:""
	                    }
					}
					
				},
				error:function(e){
									if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
								},
				pageSize: 5
			});
	
			$("#active-list").kendoGrid({
				excel: {
					 allPages: true
				},
				dataSource: activeDataSource,
				pageSize: 1,
				sortable:false,
				scrollable:false,
				pageable: true,				
				excelExport: function(e) {
					e.preventDefault();
					promises[0].resolve(e.workbook);
				},
				columns:[
					{ field: "lmtGroup", title:"Limit Group", autoWidth:true},
					{ field: "parentLmtTypeDesc", title:"Parent Limit", autoWidth:true},
					{ field: "lmtTypeDesc", title:"Limit type",   autoWidth:true},
					{ field: "aggLvl", title:"Aggregate level", autoWidth:true},
					{ field: "baseNature", title:"Base Nature",  autoWidth:true},
					{ field: "ccfRatio",title:"CCF",  autoWidth:true},
					{ field: "leeLvl", title:"LEE Level",  autoWidth:true},					
					{ field: "action", title:"Action", template:"#=replaceActionGraphics('|',false,action,lmtTypeCode)#",  autoWidth:true}
				]
			});
			
			$("#cr-list").kendoGrid({
				excel: {
					 allPages: true
				},
				dataSource: changeRequestDataSource,
				pageSize: 1,
				sortable:false,
				scrollable:false,
				pageable: true,
				excelExport: function(e) {
					e.preventDefault();
					promises[1].resolve(e.workbook);
				},
				columns:[
					{ field: "lmtGroup", title:"Limit Group", autoWidth:true},
					{ field: "parentLmtTypeDesc", title:"Parent Limit", autoWidth:true},
					{ field: "lmtTypeDesc", title:"Limit type",   autoWidth:true},
					{ field: "aggLvl", title:"Aggregate level", autoWidth:true},
					{ field: "baseNature", title:"Base Nature",  autoWidth:true},
					{ field: "ccfRatio",title:"CCF",  autoWidth:true},
					{ field: "leeLvl", title:"LEE Level",  autoWidth:true},
					{ field: "status", title:"Status",  autoWidth:true},
					{ field: "lastUpdateBy", title:"Updated By",  autoWidth:true},
					{ field: "lastUpdateDt", template:"#= validDate(lastUpdateDt)#", title:"Update time",  autoWidth:true},
					{ field: "action", template:"#=replaceActionGraphics('|',true,action,lmtTypeCode,crId)#", title:"Action",  autoWidth:true}
				]			
			});
			closeModal()
		}
		
		/* Handle underfined / null element */
		function checkUndefinedElement(element){
			if(element === null || element === "undefined"){
				//return "";
			}else{
				return element;
			}
		}
	function emptyHeight(checkId){
			
			var count = $("#"+checkId).data("kendoGrid").dataSource.total();
			//console.log(count);
			if (count>0){
				//alert("secondTimecheck");
				$("#"+checkId).find(".empty-height").hide();
			}else{
				$("#"+checkId).find(".empty-height").show();
			}
		}
		
		function replaceActionGraphics(delim, crStatus, data, lmtTypeCode,crId){
			
			if(data!=null){
				var spltarr = data.split(delim);
				var split_string = "";
				$.each(spltarr, function(j){
					//console.log(spltarr[j]);
					if(spltarr[j] != ""){
						switch(spltarr[j]){
						case "V":
							if(!crStatus){
								
								split_string = split_string+"<a href='/ermsweb/viewLimitTypeDetails?lmtTypeCode="+lmtTypeCode+"'><img src='/ermsweb/resources/images/bg_view.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/makerLimitTypeChangeRequestView?lmtTypeCode="+lmtTypeCode+"&crId="+crId+"'><img src='/ermsweb/resources/images/bg_view.png'/></a>";
							}
							break;
						case "E":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/updateLimitTypeDetails?lmtTypeCode="+lmtTypeCode+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/makerLimitTypeChangeRequestUpdate?lmtTypeCode="+lmtTypeCode+"&crId="+crId+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							}
							break;
						case "A":
							split_string = split_string+"<a href='/ermsweb/checkerLimitTypeChangeRequestView?lmtTypeCode="+lmtTypeCode+"&crId="+crId+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							break;
						case "X":
							split_string = split_string+"<a href='/ermsweb/deleteLimitTypeConfirm?lmtTypeCode="+lmtTypeCode+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
							break;
							
						case "D":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/deleteLimitTypeConfirm?lmtTypeCode="+lmtTypeCode+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/makerLimitTypeChangeRequestDiscard?lmtTypeCode="+lmtTypeCode+"&crId="+crId+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
							}
							break;
						default:
							//split_string = "";
							break;
						}
					}
				});
				//console.log("split_string: "+split_string);
				
				return split_string;
			}
		}
		
		function validDate(obj){
	    	return kendo.toString( new Date(parseInt(obj)), "MM/dd/yyyy HH:MM:tt" )
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
		.select-textbox{
			width:150px;
		}
		.num-text{
			width:100px;
			border:none;
		}
		
	</style> 
</head>
<body>
	<div class="boci-wrapper">
		<%-- <%@include file="header1.jsp"%> --%>
		<div id="boci-content-wrapper">
		<!-- <input type="hidden" id="pagetitle" name="pagetitle" value="Limit Type Maintenance"> -->
	 	 <div class="page-title">Maintenance - Limit Type Maintenance</div>
			<div class="redirect-buttons">
				<a href="createnewLimitType" class="k-button">Create New Limit</a>
			</div>
			<div class="filter-criteria">
				<div id="filter-table-heading" onclick="expandCriteria()">(-) Filter Criteria</div>
				<table class="list-table">					
					<tbody id="search-filter-body" style="display: block;">
						<tr>
							<td>Limit Group</td>
							<td><input id="lmtGroup" type="text" value="ALL" class="select-textbox one-required"/></td>									
							
							<td>Limit Type</td>
							<td><input id="lmtTypeCode" type="text" value="ALL" class="select-textbox one-required"/></td>
							
							<td>Aggregate Level</td>
							<td colspan="2"><input id="aggLvl" type="text" value="ALL" class="select-textbox one-required"/></td>
						</tr>
						<tr>
							<td colspan="7">&nbsp;</td>
						</tr>
						<tr>
							<td>Base Nature.</td>
							<td><input id="baseNature" type="text" value="ALL" class="select-textbox one-required"/></td>					
						
							<td>Lee Level</td>
							<td><input id="leeLvl" type="text" value="ALL" class="select-textbox one-required"/></td>
						
							<td>CCF</td>
							<td>
								<input id="ccfOperator" type="text" value="GEQ" class="select-textbox one-required"/>
								<input id="ccfPercentage" type="text" class="k-textbox num-text one-required"/><span style="padding-right:30px;padding-left:10px;">&#37</span>
							</td>							
						</tr>
						<tr>
							<td colspan="7">&nbsp;</td>
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
				<div class="tree-view-container">
				<div class="list-header">Limit Types</div>
					<div id="tree_view"></div>	
				</div>
				<div class="list-container">
					<div id="active-list-container">
						<table cellpadding="0" cellspacing="0" border="0" class="full-width">
							<tr>
								<td colspan="8">
									<div class="list-header">Limit Type</div>
								</td>
							</tr>
							<tr>
								<td>
									<div id="active-list" class="full-width">
																	
									</div>									
									<div id="modal">
										<img id="loader" src="/ermsweb/resources/images/ajax-loader.gif" />
									</div>						
								</td>
							</tr>					
						</table>
					</div>
					<div id="cr-list-container">
						<table cellpadding="0" cellspacing="0" border="0" class="full-width">
							<tr>
								<td colspan="11">
									<div class="list-header">Pending Request</div>
								</td>
							</tr>
							<tr>
								<td>
									<div id="cr-list" class="full-width">
																	
									</div>									
									<div id="modal1">
										<img id="loader" src="/ermsweb/resources/images/ajax-loader.gif" />
									</div>						
								</td>
							</tr>					
						</table>
					</div>
				</div>
				<div class="clear"></div>
			</div>									
		</div>
	</div>	
</body>
</html>