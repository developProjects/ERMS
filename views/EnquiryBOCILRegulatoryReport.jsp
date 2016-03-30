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
		
			var reportListData = [
       			{ text: "", value: "" },
       			{ text: "Regulatory Report R47 ", value: "R47" },
       			{ text: "Regulatory Report R48 ", value: "R48" },
       			{ text: "Regulatory Report R54 ", value: "R54" },
       			{ text: "Regulatory Report R55 ", value: "R55" },
       			{ text: "Regulatory Report R56 ", value: "R56" },
       			{ text: "Regulatory Report R74 ", value: "R74" }
       		];
         				
       		$("#reportList").kendoDropDownList({
       			dataTextField: "text",
       			dataValueField: "value",
       			dataSource: reportListData,
       			index: 0
       		});	
			
			$("#reportDatePicker").kendoDatePicker({
				max:new Date(),
				format: "yyyy/MM/dd"
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
						reportDate= $("#reportDatePicker").val();
						report= $("#reportList").val();
						openExplorer(report,reportDate);
						
					}
					else{
						alert("Atleast One Field is Required");
					}				
				}
			});
			
			//Reset button click
			$("#resetBtn").kendoButton({
				click: function(){
					$("#reportList").data("kendoDropDownList").value("");
					$("#reportDatePicker").data("kendoDatePicker").value("");
				}
			});
			
			
		});
		var detailWindow;
		//Displaying Data in the Grids
		function openExplorer(rid,rdate){		
			if(detailWindow){
				detailWindow.close();
			}								
			detailWindow = window.open('file:///D:/ERMS_Backup/Frs/');
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
		
		
    </script>
   
</head>
<body>
	<div class="boci-wrapper">
		<div id="boci-content-wrapper">
			<div class="page-title">Enquiry BOCIL Regulatory Report </div>
			<div class="filter-criteria">
				<div id="filter-table-heading" onclick="expandCriteria()">(-) Filter Criteria</div>
				<table class="list-table">					
					<tbody id="search-filter-body" style="display: block;">
						<tr>
							<td>Regulatory Report Name</td>
							<td><input id="reportList" type="text" class="select-textbox one-required"/></td>
							
							<td>Report Date</td>
							<td><input id="reportDatePicker" type="text" class="select-textbox one-required"/></td>
							
						</tr>
						<tr>
							<td colspan="3">&nbsp;</td>
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
			
												
		</div>
	</div>	
</body>
</html>