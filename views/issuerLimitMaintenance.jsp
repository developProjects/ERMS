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
			
		
						
			//Fetching Search Criteria values from Session
			
			$("#issuerName").val(checkUndefinedElement(window.sessionStorage.getItem("issuerName")));
			$("#issuerCode").val(checkUndefinedElement(window.sessionStorage.getItem("issuerCode")));
			
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
	
						sheets[0].title = "Issuer Limit Active List";
						sheets[1].title = "Issuer Limit Change Request List";
	
						var workbook = new kendo.ooxml.Workbook({
							sheets: sheets
						});
						// save the new workbook,b
						kendo.saveAs({
							dataURI: workbook.toDataURL(),
							fileName: "IssuerLimit_Maintenance_List.xlsx"
						})
					});
				}
			});
			
			
			//Search button click
			$("#searchBtn").kendoButton({
				click: function(){
					/* var input = $("input:text, select");
					var valid=0;
					for(var i=0;i<input.length;i++){
						if($.trim($(input[i]).val()).length > 0){
							valid = valid + 1;
						}
					}
					if(valid >0){ */
						dataGrids();
						window.sessionStorage.setItem('issuerCode',$('#issuerCode').val());
						window.sessionStorage.setItem('issuerName',$('#issuerName').val());
						
					/* }
					else{
						alert("Atleast One Field is Required");
					} */				
				}
			});
			
			//Reset button click
			$("#resetBtn").kendoButton({
				click: function(){
					$("input[type='text']").val("");
					window.sessionStorage.removeItem("issuerCode");
					window.sessionStorage.removeItem("issuerName");
				}
			});
		});
		
		//Displaying Data in the Grids
		function dataGrids(){		
			//$(".empty-height").hide();
			openModal();
			
			var searchCriteria = {
				issuerCode:$('#issuerCode').val(),
				issuerName:$('#issuerName').val(),
				userId:window.sessionStorage.getItem("username")
			};		
			
			var getActiveListDetailsURL = window.sessionStorage.getItem('serverPath')+"issuerlmt/getDetails";
			//var getActiveListDetailsURL = "/ermsweb/resources/js/getissuerLimitActiveList.json";
			var activeDataSource = new kendo.data.DataSource({
				transport: {
					read: {
						url: getActiveListDetailsURL,
						dataType: "json",
						data:searchCriteria,
						xhrFields : {
							withCredentials : true
						},
						
					}
					
				},
				error:function(e){
									if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
								},
				schema:{
					data:function(data){
						return data;
					}
				},
				pageSize: 3
			});
			
			var getCrListDetailsURL = window.sessionStorage.getItem('serverPath')+"issuerlmt/getDetailsChangeRequest";
			//var getCrListDetailsURL = "/ermsweb/resources/js/getissuerLimitCRlist.json";
			
			var changeRequestDataSource = new kendo.data.DataSource({
				transport: {
					read: {
						url: getCrListDetailsURL,
						dataType: "json",
						xhrFields : {
							withCredentials : true
						},
						
					}
				},
				schema:{
					data:function(data){
						return data;
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
				excelExport: function(e) {
					e.preventDefault();
					promises[0].resolve(e.workbook);
				},
				pageSize: 1,
				sortable:false,
				scrollable:false,
				pageable: true,				
				columns:[
					{ field: "issuerCode", title:"Issuer", autoWidth:true},
					{ field: "issuerName", title:"Issuer Name", autoWidth:true},
					{ field: "countryId", title:"Country", autoWidth:true},
					{ field: "countryName", title:"Country Name", autoWidth:true},
					{ field: "lmtCcy", title:"Limit CCY", autoWidth:true},
					{ field: "lmtAmt", title:"Limit Amount", autoWidth:true},
					{ field: "lmtInLoan",  title:"Limit in % Loan",autoWidth:true},
					{ field: "lastUpdateBy", title:"Updated by", autoWidth:true},
					{ field: "lastUpdateDt", title:"Last Updated", template: '#= kendo.toString( new Date(parseInt(lastUpdateDt)), "MM/dd/yyyy HH:MM:tt" ) #', autoWidth:true},
					{ field: "action", title:"Action",template:"#=replaceActionGraphics('|',false,action,issuerCode)#", autoWidth:true}
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
					{ field: "issuerCode", title:"Issuer", autoWidth:true},
					{ field: "issuerName", title:"Issuer Name", autoWidth:true},
					{ field: "countryId", title:"Country", autoWidth:true},
					{ field: "countryName", title:"Country Name", autoWidth:true},
					{ field: "lmtCcy", title:"Limit CCY", autoWidth:true},
					{ field: "lmtAmt", title:"Limit Amount", autoWidth:true},
					{ field: "lmtInLoan",  title:"Limit in % Loan",autoWidth:true},
					{ field: "status",  title:"Status",autoWidth:true},
					{ field: "lastUpdateBy",  title:"Updated by", width: 200},
					{ field: "verifyBy",  title:"Pending Verify by", width: 200},
					{ field: "action",  title:"Action", template:"#=replaceActionGraphics('|',true,action,issuerCode,crId)#", autoWidth:true}
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
		
		function replaceActionGraphics(delim, crStatus, data,issuerCode,crId){
			if(data!=null){
				var spltarr = data.split(delim);
				var split_string = "";
				$.each(spltarr, function(j){
					//console.log(spltarr[j]);
					if(spltarr[j] != ""){
						switch(spltarr[j]){
						case "V":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/issuerLimitDetailView?issuerCode="+issuerCode+"'><img src='/ermsweb/resources/images/bg_view.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/issuerLimitChangeRequestView?issuerCode="+issuerCode+"&crId="+crId+"'><img src='/ermsweb/resources/images/bg_view.png'/></a>";
							}
							break;
						case "E":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/issuerLimitUpdate?issuerCode="+issuerCode+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/issuerLimitChangeRequestUpdate?issuerCode="+issuerCode+"&crId="+crId+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							}
							break;
						case "A":
							split_string = split_string+"<a href='/ermsweb/issuerLimitVerify?issuerCode="+issuerCode+"&crId="+crId+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							break;
						case "D":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/issuerLimitDelete?issuerCode="+issuerCode+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/issuerLimitChangeRequestDiscard?issuerCode="+issuerCode+"&crId="+crId+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
							}
							break;
						case "X":
								split_string = split_string+"<a href='/ermsweb/issuerLimitDelete?issuerCode="+issuerCode+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
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
			<div class="page-title">Issuer Limit Maintenance (Collateral)</div>
			<div class="filter-criteria">
				<div id="filter-table-heading" onclick="expandCriteria()">(-) Filter Criteria</div>
				<table class="list-table">					
					<tbody id="search-filter-body" style="display: block;">
						<tr>
							<td>Issuer Code</td>
							<td><input id="issuerCode" type="text" class="k-textbox"/></td>
							<td>Issuer Name</td>
							<td><input id="issuerName" type="text" class="k-textbox"/></td>
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
								<div class="list-header">Issuer Limit Table</div>
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