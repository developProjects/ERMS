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
	
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
	
	
	<script type="text/javascript">
		
		$(document).ready(function () {
			
		
			
			membershipDataSource = [
			               {text:"Chargor",value:"Chargor"},
			               {text:"Borrower",value:"Borrower"},
			               {text:"Member",value:"Member"}
			               ]
			$('#membership').kendoDropDownList({
				dataTextField: "text",
				dataValueField: "value",
				dataSource: membershipDataSource,
				index:0
			}); 
			
			
			xcollGroupTypeDataSource = [
	               {text:"G10_Chargor-Borrower Group",value:"G10_Chargor-Borrower Group"},
	               {text:"G11_Group Sharing",value:"G11_Group Sharing"},
				]
			$('#xcollGroupType').kendoDropDownList({
				dataTextField: "text",
				dataValueField: "value",
				dataSource: xcollGroupTypeDataSource,
				index:0
			}); 
			
			
			
			
						
			//Fetching Search Criteria values from Session
			
			$("#xcollGroupType").data("kendoDropDownList").value(checkUndefinedElement(window.sessionStorage.getItem("xcollGroupType")));
			$("#membership").data("kendoDropDownList").value(checkUndefinedElement(window.sessionStorage.getItem("membership")));
			$("#xcollGroupId").val(checkUndefinedElement(window.sessionStorage.getItem("xcollGroupId")));
			$("#xcollGroupName").val(checkUndefinedElement(window.sessionStorage.getItem("xcollGroupName")));
			$("#ccdId").val(checkUndefinedElement(window.sessionStorage.getItem("ccdId")));
			$("#ccdName").val(checkUndefinedElement(window.sessionStorage.getItem("ccdName")));
			$("#accountNo").val(checkUndefinedElement(window.sessionStorage.getItem("accountNo")));
			$("#accountName").val(checkUndefinedElement(window.sessionStorage.getItem("accountName")));
			
			
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
						window.sessionStorage.setItem('xcollGroupType',$('#xcollGroupType').val());
						window.sessionStorage.setItem('xcollGroupId',$('#xcollGroupId').val());
						window.sessionStorage.setItem('xcollGroupName',$('#xcollGroupName').val());
						window.sessionStorage.setItem('membership',$('#membership').val());
						window.sessionStorage.setItem('ccdId',$('#ccdId').val());
						window.sessionStorage.setItem('ccdName',$('#ccdName').val());
						window.sessionStorage.setItem('accountName',$('#accountName').val());
						window.sessionStorage.setItem('accountNo',$('#accountNo').val());
						
					}
					else{
						alert("Atleast One Field is Required");
					}				
				}
			});
			
			//Reset button click
			$("#resetBtn").kendoButton({
				click: function(){
					$("#xcollGroupType").data("kendoDropDownList").value("");
					$("input[type='text']").val("");
					$("#membership").data("kendoDropDownList").value("");
					window.sessionStorage.removeItem("xcollGroupType");
					window.sessionStorage.removeItem("membership");
					window.sessionStorage.removeItem("xcollGroupId");
					window.sessionStorage.removeItem("xcollGroupName");
					window.sessionStorage.removeItem("ccdId");
					window.sessionStorage.removeItem("ccdName");
					window.sessionStorage.removeItem("accountNo");
					window.sessionStorage.removeItem("accountName");
				}
			});
		});
		
		//Displaying Data in the Grids
		function dataGrids(){		
			//$(".empty-height").hide();
			openModal();
			
			var searchCriteria = {
				xcollGroupType:$('#xcollGroupType').val(),
				membership:$('#membership').val(),
				xcollGroupId:$('#xcollGroupId').val(),
				xcollGroupName:$('#xcollGroupName').val(),
				ccdId:$('#ccdId').val(),
				ccdName:$('#ccdName').val(),
				accountName:$('#accountName').val(),
				accountNo:$('#accountNo').val(),
				userId:window.sessionStorage.getItem("username")
			};		
			
			var getActiveListDetailsURL = window.sessionStorage.getItem('serverPath')+"xcollgroup/getDetails";
			//var getActiveListDetailsURL = "/ermsweb/resources/js/getxcollgroupActiveList.json";
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
				schema:{
					data: function(data){
						return data;
					}
				},	
				error:function(e){
							if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
						},
				pageSize: 3
			});
			
			var getCrListDetailsURL = window.sessionStorage.getItem('serverPath')+"xcollgroup/getDetailsChangeRequest";
			//var getCrListDetailsURL = "/ermsweb/resources/js/getxcollgroupCRlist.json";
			
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
				schema:{
					data: function(data){
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
				pageSize: 1,
				sortable:false,
				scrollable:false,
				pageable: true,				
				columns:[
					{ field: "xcollGroupId", title:"Group ID", autoWidth:true},
					{ field: "xcollGroupType", title:"Group Type", autoWidth:true},
					{ field: "xcollGroupName", title:"Group Name", autoWidth:true},
					{ field: "action",title:"Action", template:"#=replaceActionGraphics('|',false,action,xcollGroupId)#", autoWidth:true}
				]
			});
			
			$("#cr-list").kendoGrid({
				
				dataSource: changeRequestDataSource,
				pageSize: 1,
				sortable:false,
				scrollable:false,
				pageable: true,
				columns:[
					{ field: "xcollGroupId", title:"Group ID", autoWidth:true},
					{ field: "xcollGroupType", title:"Group Type", autoWidth:true},
					{ field: "xcollGroupName", title:"Group Name", autoWidth:true},
					{ field: "status",  title:"Status", autoWidth:true},
					{ field: "lastUpdateBy",  title:"Updated By", width: 200},
					{ field: "lastUpdateDt", title:"Update time", template: '#= kendo.toString( new Date(parseInt(lastUpdateDt)), "MM/dd/yyyy HH:MM:tt" ) #', autoWidth:true},
					{ field: "action",  title:"Action", template:"#=replaceActionGraphics('|',true,action,xcollGroupId,crId)#", autoWidth:true}
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
		
		function replaceActionGraphics(delim, crStatus, data,xcollGroupId,crId){
			if(data!=null){
				var spltarr = data.split(delim);
				var split_string = "";
				$.each(spltarr, function(j){
					//console.log(spltarr[j]);
					if(spltarr[j] != ""){
						switch(spltarr[j]){
						case "V":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/crossCollateralizationGroupDetailsView?xcollGroupId="+xcollGroupId+"'><img src='/ermsweb/resources/images/bg_view.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/crossCollateralizationGroupChangeRequestView?xcollGroupId="+xcollGroupId+"&crId="+crId+"'><img src='/ermsweb/resources/images/bg_view.png'/></a>";
							}
							break;
						case "E":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/crossCollateralizationGroupUpdate?xcollGroupId="+xcollGroupId+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/crossCollateralizationGroupChangeRequestUpdate?xcollGroupId="+xcollGroupId+"&crId="+crId+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							}
							break;
						case "A":
							split_string = split_string+"<a href='/ermsweb/crossCollateralizationGroupVerify?xcollGroupId="+xcollGroupId+"&crId="+crId+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							break;
						case "D":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/crossCollateralizationGroupDelete?xcollGroupId="+xcollGroupId+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/crossCollateralizationGroupChangeRequestDiscard?xcollGroupId="+xcollGroupId+"&crId="+crId+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
							}
							break;
						case "X":
								split_string = split_string+"<a href='/ermsweb/crossCollateralizationGroupDelete?xcollGroupId="+xcollGroupId+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
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
			<div class="page-title">Maintenance - Cross Collateralization Group Maintenance</div>
			<div class="redirect-buttons">
				<a href="crossCollateralizationGroupCreate" class="k-button">Create Cross Collateralization Group</a>
			</div>
			<div class="filter-criteria">
				<div id="filter-table-heading" onclick="expandCriteria()">(-) Filter Criteria</div>
				<table class="list-table">					
					<tbody id="search-filter-body" style="display: block;">
						<tr>
							<td>Cross Collateralization Group ID</td>
							<td><input id="xcollGroupId" type="text" class="k-textbox"/></td>
						</tr>
						<tr>
							<td>Cross Collateralization Group Type</td>
							<td><input id="xcollGroupType"/></td>
						</tr>
						<tr>
							<td>Cross Collateralization Group Name</td>
							<td><input id="xcollGroupName" type="text" class="k-textbox"/></td>
						</tr>
						<tr>
							<td>Client CCD ID</td>
							<td><input id="ccdId" type="text" class="k-textbox"/></td>
						</tr>
						<tr>
							<td>Client Name</td>
							<td><input id="ccdName" type="text" class="k-textbox"/></td>
						</tr>
						<tr>
							<td>Acount/Sub Acc No.</td>
							<td><input id="accountNo" type="text" class="k-textbox"/></td>
						</tr>
						<tr>
							<td>Account Name</td>
							<td><input id="accName" type="text" class="k-textbox"/></td>
						</tr>
						<tr>
							<td>Cross Collateralization Role</td>
							<td><input id="membership"/></td>
						</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
						
						<tr>
							<td colspan="5" align="right">
								<button id="searchBtn" class="k-button" type="button">Search</button>
								<button id="resetBtn" class="k-button" type="button">Reset</button>
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
								<div class="list-header">Cross Collateralization Group Table</div>
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
								<div class="list-header">Cross Collateralization Group change request Table</div>
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