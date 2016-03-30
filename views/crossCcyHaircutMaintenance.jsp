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
			
			
			$('#bizUnit').kendoDropDownList({
				optionLabel: "Select",
				dataTextField: "text",
				dataValueField: "value",
				dataSource: {
					transport: {
						read: {
							url: "/ermsweb/resources/js/businessunit.json",
							dataType: "json"
						}
					}
				},
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
			
			$('#currencyList').kendoDropDownList({
				optionLabel: "Select",
				dataTextField: "dataText",
				dataValueField: "dataField",
				dataSource: currencyData,
				index:0
			}); 
			
			var haircutOperatorData = [
       			{ text: "=", value: "EQ" },
       			{ text: ">=", value: "GEQ" },
       			{ text: "<=", value: "LEQ" },
       			{ text: ">", value: "GTR" },
       			{ text: "<", value: "LSS" },
       		];
         				
       		$("#haircutOperator").kendoDropDownList({
       			dataTextField: "text",
       			dataValueField: "value",
       			dataSource: haircutOperatorData,
       			index: 0
       		});	
			
			
			$("#haircutPercent").kendoNumericTextBox({
                min: 0,
                max: 100,
                spinners: false
            });
			
						
			//Fetching Search Criteria values from Session
			
			$("#bizUnit").val(checkUndefinedElement(sessionStorage.getItem("bizUnit")));
			$("#currency").val(checkUndefinedElement(sessionStorage.getItem("currency")));
			$("#haircutOperator").val(checkUndefinedElement(sessionStorage.getItem("haircutOperator")));
			$("#haircutPercent").html(checkUndefinedElement(window.sessionStorage.getItem("haircutPercent")));
			
			
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
						window.sessionStorage.setItem('bizUnit',$('#bizUnit').val());
						window.sessionStorage.setItem('currency',$('#currencyList').val());
						window.sessionStorage.setItem('haircutOperator',$('#haircutOperator').val());
						window.sessionStorage.setItem('haircutPercent',$('#haircutPercent').val());
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
							var numClass = $(this).hasClass("num-text");
							if(ddlClass){
									$("#"+attrId).data("kendoDropDownList").value("");
							}
							if(numClass){
								$("#"+attrId).data("kendoNumericTextBox").value("");
							}else{
								$("#"+attrId).data("kendoDropDownList").value("GEQ");
							}
						}
					});
					window.sessionStorage.removeItem("bizUnit");
					window.sessionStorage.removeItem("currency");
					window.sessionStorage.removeItem("haircutOperator");
					window.sessionStorage.removeItem("haircutPercent");
					
					
				}
			});
		});
		
		//Displaying Data in the Grids
		function dataGrids(){		
			//$(".empty-height").hide();
			openModal();
			
			var searchCriteria = {
				bizUnit:$('#bizUnit').val(), 
				userId:window.sessionStorage.getItem("username"),
				ccy:$('#currencyList').val(),  
				haircutOperator:$('#haircutOperator').val(), 
				haircutPercent:$('#haircutPercent').val()
			};		
			
			var getActiveListDetailsURL = window.sessionStorage.getItem('serverPath')+"crossCcyHaircut/getDetails";
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
			
			var getCrListDetailsURL = window.sessionStorage.getItem('serverPath')+"crossCcyHaircut/getDetailsChangeRequest";
			
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
					{ field: "bizUnit", title:"Business Unit", autoWidth:true},
					{ field: "ccyCode", title:"Currency",autoWidth:true},
					{ field: "haircutRatio", title:"Haircut %", autoWidth:true},
					{ field: "action",title:"Action", template:"#=replaceActionGraphics('|',false,action,crId,ccyCode,bizUnit)#", autoWidth:true}
				]
			});
			
			$("#cr-list").kendoGrid({
				
				dataSource: changeRequestDataSource,
				pageSize: 1,
				sortable:false,
				scrollable:false,
				pageable: true,
				columns:[
					{ field: "bizUnit",title:"Business Unit",  autoWidth:true},
					{ field: "ccyCode", title:"Currency",autoWidth:true},
					{ field: "haircutRatio", title:"Haircut %", autoWidth:true},
					{ field: "status", title:"Status",autoWidth:true},
					{ field: "createBy",title:"Updated By", autoWidth:true},
					{ field: "createDt",title:"Last Updated time", template: '#= kendo.toString( new Date(parseInt(createDt)), "MM/dd/yyyy HH:MM:tt" ) #', autoWidth:true},
					{ field: "action", title:"Action",template:"#=replaceActionGraphics('|',true,action,crId,ccyCode,bizUnit)#", autoWidth:true}
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
		
		function replaceActionGraphics(delim, crStatus, data,crId,ccyCode,bizUnit){
			if(data!=null){
				var spltarr = data.split(delim);
				var split_string = "";
				$.each(spltarr, function(j){
					//console.log(spltarr[j]);
					if(spltarr[j] != ""){
						switch(spltarr[j]){
						case "V":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/crossCcyHaircutDetailsView?crId="+crId+"&ccyCode="+ccyCode+"&bizUnit="+bizUnit+"'><img src='/ermsweb/resources/images/bg_view.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/crossCcyHaircutChangeRequestView?crId="+crId+"&ccyCode="+ccyCode+"&bizUnit="+bizUnit+"'><img src='/ermsweb/resources/images/bg_view.png'/></a>";
							}
							break;
						case "E":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/crossCcyHaircutUpdate?crId="+crId+"&ccyCode="+ccyCode+"&bizUnit="+bizUnit+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/crossCcyHaircutChangeRequestUpdate?crId="+crId+"&ccyCode="+ccyCode+"&bizUnit="+bizUnit+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							}
							break;
						case "A":
							split_string = split_string+"<a href='/ermsweb/crossCcyHaircutVerify?crId="+crId+"&ccyCode="+ccyCode+"&bizUnit="+bizUnit+"'><img src='/ermsweb/resources/images/bg_update.png'/></a>";
							break;
						case "D":
							if(!crStatus){
								split_string = split_string+"<a href='/ermsweb/crossCcyHaircutDelete?crId="+crId+"&ccyCode="+ccyCode+"&bizUnit="+bizUnit+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
							}else{
								split_string = split_string+"<a href='/ermsweb/crossCcyHaircutDiscardChangeRequest?crId="+crId+"&ccyCode="+ccyCode+"&bizUnit="+bizUnit+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
							}
							break;
						case "X":
								split_string = split_string+"<a href='/ermsweb/crossCcyHaircutDelete?crId="+crId+"&ccyCode="+ccyCode+"&bizUnit="+bizUnit+"'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
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
		<%@include file="header1.jsp"%>
		<div id="boci-content-wrapper">
			<div class="page-title">Maintenance  -  Cross Currency Haircut Maintenance </div>
			<div class="filter-criteria">
				<div id="filter-table-heading" onclick="expandCriteria()">(-) Filter Criteria</div>
				<table class="list-table">					
					<tbody id="search-filter-body" style="display: block;">
						<tr>
							<td>Business Unit</td>
							<td><input id="bizUnit" type="text" class="select-textbox one-required"/></td>
							
							<td>Currency</td>
							<td><input id="currencyList" type="text" class="select-textbox one-required"/></td>
							
							<td>Haircut %</td>
							<td>
								<input id="haircutOperator" style="width:150px;" type="text" value="GEQ" class="one-required"/>
								<input id="haircutPercent"  type="text" class="k-textbox num-text one-required"/>
							</td>
						</tr>
						<tr>
							<td colspan="7">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="7" align="right">
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
								<div class="list-header">Cross Currency Haircut</div>
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