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
			
		
			$('#countryList').kendoDropDownList({
				optionLabel: "Select",
				dataTextField: "dataText",
				dataValueField: "dataField",
				dataSource:countryData,
				index:0
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
			
			$('#entityList').kendoDropDownList({
				optionLabel: "Select",
				dataTextField: "text",
				dataValueField: "value",
				dataSource:entityData,
				index:0
			}); 
			
			
						
			//Fetching Search Criteria values from Session
			
			$("#countryList").val(checkUndefinedElement(window.sessionStorage.getItem("country")));
			$("#entityList").val(checkUndefinedElement(window.sessionStorage.getItem("entity")));
			
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
	
						sheets[0].title = "Country Limit Active List";
						sheets[1].title = "Country Limit Change Request List";
	
						var workbook = new kendo.ooxml.Workbook({
							sheets: sheets
						});
						// save the new workbook,b
						kendo.saveAs({
							dataURI: workbook.toDataURL(),
							fileName: "CountryLimit_Maintenance_List.xlsx"
						})
					});
				}
			});
			
			
			//Search button click
			$("#searchBtn").kendoButton({
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
						window.sessionStorage.setItem('country',$('#countryList').val());
						window.sessionStorage.setItem('entity',$('#entityList').val());
						
					}
					else{
						alert("Atleast One Field is Required");
					}				
				}
			});
			
			//Reset button click
			$("#resetBtn").kendoButton({
				click: function(){
					$("#countryList").data("kendoDropDownList").value("");
					$("#entityList").data("kendoDropDownList").value("");
					window.sessionStorage.removeItem("country");
				}
			});
		});
		
		//Displaying Data in the Grids
		function dataGrids(){		
			//$(".empty-height").hide();
			openModal();
			
			var searchCriteria = {
				countryId:$('#countryList').val(),
				entity:$('#entityList').val(),
				userId:window.sessionStorage.getItem("username")
			};		
			
			var getActiveListDetailsURL = window.sessionStorage.getItem('serverPath')+"countrylmt/getDetails";
			//var getActiveListDetailsURL = "/ermsweb/resources/js/getcountryLimitActiveList.json";
			var activeDataSource = new kendo.data.DataSource({
				transport: {
					read: {
						url: getActiveListDetailsURL,
						dataType: "json",
						data:searchCriteria,
						
						xhrFields : {
							withCredentials : true
						}
						
					}
				},
				error:function(e){
							if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
						},
				pageSize: 3
			});
			
			var getCrListDetailsURL = window.sessionStorage.getItem('serverPath')+"countrylmt/getDetailsChangeRequest";
			//var getCrListDetailsURL = "/ermsweb/resources/js/getcountryLimitCRlist.json";
			
			var changeRequestDataSource = new kendo.data.DataSource({
				transport: {
					read: {
						url: getCrListDetailsURL,
						dataType: "json",
						xhrFields : {
							withCredentials : true
						}
						
					}
				},
				error:function(e){
							if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
						},
				pageSize: 3
			});
	
			$("#active-list").kendoGrid({
				dataSource: activeDataSource,
				excel: {
					 allPages: true
				},
				pageSize: 1,
				sortable:false,
				scrollable:false,
				excelExport: function(e) {
					e.preventDefault();
					promises[0].resolve(e.workbook);
				},
				pageable: true,				
				columns:[
					{ field: "countryId", title:"Country",  autoWidth:true},
					{ field: "countryName", title:"Country Name", autoWidth:true},
					{ field: "entity", title:"Entity", autoWidth:true},
					{ field: "lmtCcy", title:"Limit CCY", autoWidth:true},
					{ field: "lmtAmt", title:"Limit Amount", autoWidth:true},
					{ field: "lmtInCapital",title:"Limit % of Capital",  autoWidth:true},
					{ field: "lastUpdateBy", title:"Updated by", autoWidth:true},
					{ field: "lastUpdateDt", title:"Last Updated",template: '#= kendo.toString( new Date(parseInt(lastUpdateDt)), "MM/dd/yyyy HH:MM:tt" ) #', autoWidth:true},
					{ field: "action",title:"Action", template:"#=replaceActionGraphics('|',false,action,countryId,entity)#", autoWidth:true}
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
				excelExport: function(e) {
					e.preventDefault();
					promises[1].resolve(e.workbook);
				},
				pageable: true,
				columns:[
					{ field: "countryId", title:"Country",  autoWidth:true},
					{ field: "countryName", title:"Country Name", autoWidth:true},
					{ field: "entity", title:"Entity", autoWidth:true},
					{ field: "lmtCcy", title:"Limit CCY", autoWidth:true},
					{ field: "lmtAmt", title:"Limit Amount", autoWidth:true},
					{ field: "lmtInCapital",title:"Limit % of Capital",  autoWidth:true},
					{ field: "status", title:"Status", autoWidth:true},
					{ field: "lastUpdateBy", title:"Updated by", autoWidth:true},
					{ field: "verifyBy", title:"Pending Verify By", autoWidth:true},
					{ field: "action", title:"Action",template:"#=replaceActionGraphics('|',true,action,countryId,crId)#", autoWidth:true}
				]			
			});
			
			closeModal();
		}
		
		
		
		/* Handle underfined / null element */
		function checkUndefinedElement(element){			
			if(element === null || element === "undefined"){
				return "";
			}else{
				return element;
			}
		}
		
		function replaceActionGraphics(delim, crStatus, data,countryId,param){
			if(data!=null){
				var spltarr = data.split(delim);
				var split_string = "";
				$.each(spltarr, function(j){
					//console.log(spltarr[j]);
					if(spltarr[j] != ""){
						switch(spltarr[j]){
						case "V":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/countryLimitDetailView?countryId="+countryId+"&entity="+param+"'><img src='/ermsweb/resources/images/bg_view.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/countryLimitChangeRequestView?countryId="+countryId+"&crId="+param+"'><img src='/ermsweb/resources/images/bg_view.png'/></a>";
							}
							break;
						case "E":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/countryLimitUpdate?countryId="+countryId+"&entity="+param+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/countryLimitChangeRequestUpdate?countryId="+countryId+"&crId="+param+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							}
							break;
						case "A":
							split_string = split_string+"<a href='/ermsweb/countryLimitVerify?countryId="+countryId+"&crId="+param+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							break;
						case "D":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/countryLimitDelete?countryId="+countryId+"&entity="+param+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/countryLimitChangeRequestDiscard?countryId="+countryId+"&crId="+param+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
							}
							break;
						case "X":
								split_string = split_string+"<a href='/ermsweb/countryLimitDelete?countryId="+countryId+"&entity="+param+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
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
		function emptyHeight(checkId){
			
			var count = $("#"+checkId).data("kendoGrid").dataSource.total();
			console.log(count);
			if (count>0){
				//alert("secondTimecheck");
				$("#"+checkId).find(".empty-height").hide();
			}else{
				$("#"+checkId).find(".empty-height").show();
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
			width:150px;
			border:none;
		}
		
	</style>
</head>
<body>
	<div class="boci-wrapper">
		
		<div id="boci-content-wrapper">
			<div class="page-title">Country Limit Maintenance (Collateral)</div>
			<div class="redirect-buttons">
				<a href="countryLimitCreate" class="k-button">Create</a>
				<a href="countryLimitImport" class="k-button">Import</a>
			</div>
			<div class="filter-criteria">
				<div id="filter-table-heading" onclick="expandCriteria()">(-) Filter Criteria</div>
				<table class="list-table">					
					<tbody id="search-filter-body" style="display: block;">
						<tr>
							<td>Country</td>
							<td><input id="countryList" type="text" class="select-textbox one-required"/></td>
							<td>Entity</td>
							<td><input id="entityList" type="text" class="select-textbox one-required"/></td>
						</tr>
						<tr>
							<td colspan="5">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="5" align="right">
								<button id="searchBtn" class="k-button" type="button">Search</button>
								<button id="resetBtn" class="k-button" type="button">Reset</button>
								<button id="exportBtn" class="k-button" type="button">Export</button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<div id="search_result_container">
				<div id="active-list-container">
					<table cellpadding="0" cellspacing="0" border="0" width="100%">
						<tr>
							<td colspan="8">
								<div class="list-header">Country Limit Table</div>
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
					<table cellpadding="0" cellspacing="0" border="0" width="100%">
						<tr>
							<td colspan="11">
								<div class="list-header">Pending Request Section</div>
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