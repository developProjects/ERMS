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
				dataSource: countryData,
				index:0
			}); 
			
			
						
			//Fetching Search Criteria values from Session
			
			$("#countryList").val(checkUndefinedElement(window.sessionStorage.getItem("country")));
			
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
	
						sheets[0].title = "Country Rating Active List";
						sheets[1].title = "Country Rating Change Request List";
	
						var workbook = new kendo.ooxml.Workbook({
							sheets: sheets
						});
						// save the new workbook,b
						kendo.saveAs({
							dataURI: workbook.toDataURL(),
							fileName: "CountryRating_Maintenance_List.xlsx"
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
				userId:window.sessionStorage.getItem("username")
			};		
			
			var getActiveListDetailsURL = window.sessionStorage.getItem('serverPath')+"countryRating/getDetails";
			//var getActiveListDetailsURL = "/ermsweb/resources/js/getcountryActiveList.json";
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
			
			var getCrListDetailsURL = window.sessionStorage.getItem('serverPath')+"countryRating/getDetailsChangeRequest";
			//var getCrListDetailsURL = "/ermsweb/resources/js/getcountryCRlist.json";
			
			var changeRequestDataSource = new kendo.data.DataSource({
				transport: {
					read: {
						url: getCrListDetailsURL,
						dataType: "json",
						data:searchCriteria,
						xhrFields : {
							withCredentials : true
						}
					}
				},
				error:function(e){
							alert(e.errorThrown);
							(e.xhr.status == "401") ? window.parent.location = "/ermsweb/home" :"";
						},
				pageSize: 3
			});
	
			$("#active-list").kendoGrid({
				dataSource: activeDataSource,
				excel: {
					 allPages: true
				},
				excelExport: function(e) {
					e.preventDefault();
					promises[0].resolve(e.workbook);
				},
				pageSize: 1,
				sortable:false,
				scrollable:false,
				pageable: true,				
				columns:[
					{ field: "countryId", title:"Country", autoWidth:true},
					{ field: "countryName", title:"Country Name", autoWidth:true},
					{ field: "bbgTicker",  title:"BBG Ticker", autoWidth:true},
					{ field: "creditRatingInr", title:"Internal Rating",  autoWidth:true},
					{ field: "creditRatingInrDesc", title:"Internal Rating Description",  autoWidth:true},
					{ field: "creditRatingSnp", title:"S&P Rating", autoWidth:true},
					{ field: "creditRatingMoodys", title:"Moody's Rating", autoWidth:true},
					{ field: "creditRatingFitch", title:"Fitch Rating", autoWidth:true},
					{ field: "inrEffectiveDt", title:"Effective Date (Internal Rating)", template: '#= kendo.toString( new Date(parseInt(inrEffectiveDt)), "MM/dd/yyyy HH:MM:tt" ) #', autoWidth:true},
					{ field: "lastUpdateBy", title:"Updated by", autoWidth:true},
					{ field: "lastUpdateDt", title:"Last Updated", template: '#= kendo.toString( new Date(parseInt(lastUpdateDt)), "MM/dd/yyyy HH:MM:tt" ) #', autoWidth:true},
					{ field: "action", title:"Action", template:"#=replaceActionGraphics('|',false,action,countryId)#", autoWidth:true}
				]
			});
			
			$("#cr-list").kendoGrid({
				excel: {
					 allPages: true
				},
				excelExport: function(e) {
					e.preventDefault();
					promises[1].resolve(e.workbook);
				},
				dataSource: changeRequestDataSource,
				pageSize: 1,
				sortable:false,
				scrollable:false,
				pageable: true,
				columns:[
					{ field: "countryId", title:"Country", autoWidth:true},
					{ field: "countryName", title:"Country Name", autoWidth:true},
					{ field: "bbgTicker",  title:"BBG Ticker", autoWidth:true},
					{ field: "creditRatingInr", title:"Internal Rating",  autoWidth:true},
					{ field: "creditRatingInrDesc", title:"Internal Rating Description",  autoWidth:true},
					{ field: "creditRatingSnp", title:"S&P Rating", autoWidth:true},
					{ field: "creditRatingMoodys", title:"Moody's Rating", autoWidth:true},
					{ field: "creditRatingFitch", title:"Fitch Rating", autoWidth:true},
					{ field: "inrEffectiveDt", title:"Effective Date (Internal Rating)", template: '#= kendo.toString( new Date(parseInt(inrEffectiveDt)), "MM/dd/yyyy HH:MM:tt" ) #', autoWidth:true},
					{ field: "status", title:"Status", autoWidth:true},
					{ field: "lastUpdateBy", title:"Updated By", autoWidth:true},
					{ field: "verifyBy", title:"Pending Verify by", autoWidth:true},
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
		
		function replaceActionGraphics(delim, crStatus, data,countryId,crId){
			if(data!=null){
				var spltarr = data.split(delim);
				var split_string = "";
				$.each(spltarr, function(j){
					//console.log(spltarr[j]);
					if(spltarr[j] != ""){
						switch(spltarr[j]){
						case "V":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/countryRatingDetailView?countryId="+countryId+"'><img src='/ermsweb/resources/images/bg_view.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/countryRatingChangeRequestView?countryId="+countryId+"&crId="+crId+"'><img src='/ermsweb/resources/images/bg_view.png'/></a>";
							}
							break;
						case "E":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/countryRatingUpdate?countryId="+countryId+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/countryRatingChangeRequestUpdate?countryId="+countryId+"&crId="+crId+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							}
							break;
						case "A":
							split_string = split_string+"<a href='/ermsweb/countryRatingVerify?countryId="+countryId+"&crId="+crId+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							break;
						case "D":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/countryRatingDelete?countryId="+countryId+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/countryRatingChangeRequestDiscard?countryId="+countryId+"&crId="+crId+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
							}
							break;
						case "X":
								split_string = split_string+"<a href='/ermsweb/countryRatingDelete?countryId="+countryId+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
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
			<div class="page-title">Country Rating Maintenance (Collateral)</div>
			<div class="redirect-buttons">
				<a href="countryRatingCreate" class="k-button">Create</a>
				<a href="countryRatingImport" class="k-button">Import</a>
			</div>
			<div class="filter-criteria">
				<div id="filter-table-heading" onclick="expandCriteria()">(-) Filter Criteria</div>
				<table class="list-table">					
					<tbody id="search-filter-body" style="display: block;">
						<tr>
							<td>Country</td>
							<td>&nbsp;</td>
							<td><input id="countryList" type="text" class="select-textbox one-required"/></td>
						</tr>
						<tr>
							<td colspan="3">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="3" align="right">
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
								<div class="list-header">Country Rating Table</div>
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