<!DOCTYPE html>
<html lang="en">

<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 
 <script src="/ermsweb/resources/js/ermsresources.js"></script>



<!-- Kendo UI API -->
<link rel="stylesheet"
	href="/ermsweb/resources/css/kendo.common.min.css">
<link rel="stylesheet" href="/ermsweb/resources/css/kendo.rtl.min.css">
<link rel="stylesheet"
	href="/ermsweb/resources/css/kendo.default.min.css">
<link rel="stylesheet"
	href="/ermsweb/resources/css/kendo.dataviz.min.css">
<link rel="stylesheet"
	href="/ermsweb/resources/css/kendo.dataviz.default.min.css">
<link rel="stylesheet"
	href="/ermsweb/resources/css/kendo.mobile.all.min.css">
<!-- General layout Style -->
<link href="/ermsweb/resources/css/layout.css" rel="stylesheet"
	type="text/css">
	
<!-- jQuery JavaScript -->
<script src="/ermsweb/resources/js/jquery.min.js"></script>
<!--  <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/2.5.0/jszip.min.js"></script> -->
<script src="/ermsweb/resources/js/jszip.min.js"></script>
<script src="/ermsweb/resources/js/kendo.all.min.js"></script>
<!-- 	<script src="http://kendo.cdn.telerik.com/2014.3.1029/js/kendo.all.min.js"></script>
	 -->
<style type="text/css">
.k-grid-header tr th.k-header, .grid-container tr th {
	background-color: #B54D4D;
	font-size: 13px;
	color: #fff;
	white-space: pre-line;
	width: 150px;
}

#audit_trail_grid .k-grid-header .k-link:link, #audit_trail_grid .k-grid-header .k-link:visited,
	#audit_trail_grid .k-grid-header .k-nav-current.k-state-hover .k-link {
	color: #fff;
}

.grid-container tr th {
	min-width: 150px;
	padding: 5px;
	white-space: nowrap;
	border-right: 1px solid #c5c5c5;
	background-image: none,
		linear-gradient(to bottom, rgba(255, 255, 255, 0.6) 0px,
		rgba(255, 255, 255, 0) 100%);
}

#filterBody tr td:nth-child(even) {
	padding-right: 10px;
}

.empty-height {
	padding: 10px;
	margin: 0;
}

#audit_wrapper {
	width: 90%;
	margin: 20px auto;
}

.search-section {
	padding-bottom: 20px;
	margin-bottom: 20px;
	height: auto;
	border: 1px solid #5a2727;
}

.search-section h3 {
	background-color: #5a2727;
	padding-left: 10px;
	padding-top: 0;
	margin-top: 0;
	color: #fff;
	font-size: 16px;
}

.search-section table {
	width: 100%;
}

.search-section tr td {
	padding: 5px 10px;
}


</style>

<script type="text/javascript">
	//used to sync the exports
	var promises = [
		$.Deferred()
	];
	
	

	
	$(document).ready(function(){
		$("#functionScreen").kendoDropDownList();
		$("#searchField1").kendoDropDownList();
		$("#searchField2").kendoDropDownList();
		$("#searchField3").kendoDropDownList();
		$("#exportBtn").kendoButton();
		
		var newDate = new Date();
		
		$("#updatedFromDate").kendoDatePicker({
			min:new Date(newDate.getFullYear() - 1, newDate.getMonth('MM'), newDate.getDate()),
			max:new Date(newDate)
		});
		$("#updatedToDate").kendoDatePicker({
			min:new Date(newDate.getFullYear() - 1, newDate.getMonth(), newDate.getDate()),
			max:new Date(newDate)
		});
		$("#createdFromDate").kendoDatePicker({
			min:new Date(newDate.getFullYear() - 1, newDate.getMonth(), newDate.getDate()),
			max:new Date(newDate)
		});
		$("#createdToDate").kendoDatePicker({
			min:new Date(newDate.getFullYear() - 1, newDate.getMonth(), newDate.getDate()),
			max:new Date(newDate)
		});
		$("#verifiedFromDate").kendoDatePicker({
			min:new Date(newDate.getFullYear() - 1, newDate.getMonth(), newDate.getDate()),
			max:new Date(newDate)
		});
		$("#verifiedToDate").kendoDatePicker({
			min:new Date(newDate.getFullYear() - 1, newDate.getMonth(), newDate.getDate()),
			max:new Date(newDate)
		});
		
		var data_columns = [];
		
		var auditTrailAllDataSource = new kendo.data.DataSource({
			transport: {
				read: {
					//url: "/ermsweb/resources/js/getFunctionList.json",
					//url: window.sessionStorage.getItem('serverPath')+"auditTrail/getFunctionList?userId="+window.sessionStorage.getItem('username'),
					url: window.sessionStorage.getItem('serverPath')+"auditTrail/getFunctionList?userId="+window.sessionStorage.getItem('username'),							
						dataType: "json",
						
						xhrFields: {
                            withCredentials: true
                           }
				}
			},
			error:function(e){
				if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
			},
			schema:{
				data: function(data){
					return [data];
				}
			}				
		});
		
		auditTrailAllDataSource.fetch(function(){
			var dsData = this.view()[0];
			$("#functionScreen").kendoDropDownList({
				optionLabel: "Select",
				dataTextField: "funcName",
				dataValueField: "funcId",
				dataSource: dsData,
				change:function(e){
					//var selectedValue = this.value();					
					var selectedSearchFields = dsData[this.selectedIndex - 1]
					fecthPropValues(selectedSearchFields);					
				}
			});
		});
		
		function fecthPropValues(functionName){
		
			$("#searchField1, #searchField2, #searchField3").kendoDropDownList({
				optionLabel: "Select",
				dataTextField: "dataText",
				dataValueField: "dataField",
				dataSource:functionName.searchFields
			});
			data_columns = functionName.searchFields;
		}
		
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
					$("#audit_trail_grid").empty();
					dataGrid(data_columns);
				}
				else{
					alert("Atleast One Field is Required");
				}				
			}
		});
		
		$("#exportBtn").kendoButton({
			click: function(){
				ExportData(data_columns);
			}
		});
		
	});
	
	function ExportData(data_columns){
		var targetGrid = $("#audit_trail_grid").data("kendoGrid");
		var dataSource = targetGrid.dataSource;
		var dataView = dataSource.view();
		var rows=[];
		var cells=[];
		//console.log(dataSource.options.schema.model);
		/*------------Fetching Data headers for the excel----------*/
		$(data_columns).each(function(i){
			cells.push({value:data_columns[i].dataText});			
		});
		rows.push({cells:cells});
		cells = [];
		/*-------------Fetching Data for the excel---------------*/
		for(var i = 0; i < dataView.length; i++){
			$(data_columns).each(function(j){
				var dataString = " "+dataView[i][data_columns[j].dataField];
				cells.push({value:($.trim(dataString) == "undefined" || $.trim(dataString) ==  "null") ? "" : dataString});
				dataString = "";
			});
			rows.push({cells:cells});
			cells = [];
		}
		//console.log(rows);
		var workbook = new kendo.ooxml.Workbook({
          sheets: [
            {
              // Title of the sheet
              title: "Audit Trail Data",
              // Rows of the sheet
              rows: rows
            }
          ]
        });
        //save the file as Excel file with extension xlsx
        kendo.saveAs({dataURI: workbook.toDataURL(), fileName: "AuditTrail.xlsx"});
		
	}
	function dataGrid(columnData){
		
		//var getAuditDataUrl = "/ermsweb/searchData";
		//var getAuditDataUrl = "/ermsweb/resources/js/getAuditTrailDetails.json";
		

		openModal();
/* 		var updatefromdt=$('#updatedFromDate').val();
		if($('#updatedFromDate').val()!="" && $('#updatedFromDate').val()!='undefined'){
			//updatefromdt=new Date($('#updatedFromDate').val()); 
			updatefromdt=Date.parse($('#updatedFromDate').val());
		}else{
			updatefromdt=Date.parse('');
		}
		if($('#updatedToDate').val()!="" && $('#updatedToDate').val()!='undefined'){
			var updateTodt=Date.parse($('#updatedToDate').val()); 
		}else{
			var updateTodt=Date.parse('');
		} */
/* 		alert($('#updatedFromDate').val());
		String updateDt=$('#updatedFromDate').val()
		var arr = updateDt.split('/'); */
		// var updatefromdt=converDateStrFormat($('#updatedFromDate').val());
		
	
		//var updateTodt=converDateStrFormat($('#updatedToDate').val());
		var searchCriteria = {
			functionName:$('#functionScreen').val(),
			searchField1:$('#searchField1').val(),
			searchField2:$('#searchField2').val(),
			searchField3:$('#searchField3').val(),
			searchField1_key:$('#searchField1_key').val(),
			searchField2_key:$('#searchField2_key').val(),
			searchField3_key:$('#searchField3_key').val(),
			updatedFromDate:converDateStrFormat($('#updatedFromDate').val()),
			updatedToDate:converDateStrFormat($('#updatedToDate').val()),
			createdFromDate:converDateStrFormat($('#createdFromDate').val()),
			
			createdToDate:converDateStrFormat($('#createdToDate').val()),
			verifiedFromDate:converDateStrFormat($('#verifiedFromDate').val()),
			verifiedToDate:converDateStrFormat($('#verifiedToDate').val()),
			userId:window.sessionStorage.getItem('username')
		};
		
		var filterCriteria={
				funcId:searchCriteria.functionName,
				searchKey1:searchCriteria.searchField1,
				searchValue1:searchCriteria.searchField1_key,
				searchKey2:searchCriteria.searchField2,
				searchValue2:searchCriteria.searchField2_key,
				searchKey3:searchCriteria.searchField3,
				searchValue3:searchCriteria.searchField3_key,
				updatedFromDate:searchCriteria.updatedFromDate,
				updatedToDate:searchCriteria.updatedToDate,
				createdFromDate:searchCriteria.createdFromDate,
				createdToDate:searchCriteria.createdToDate,
				verifiedFromDate:searchCriteria.verifiedFromDate,
				verifiedToDate:searchCriteria.verifiedToDate,
				userId:window.sessionStorage.getItem('username')
		};
		
		
		// var getAuditDataUrl=window.sessionStorage.getItem('serverPath')+"auditTrail/getAuditTrailDetails?userId=RISKADMIN"+"&funcId="+searchCriteria.functionName+"&searchKey1="+searchCriteria.searchField1+"&searchValue1="+searchCriteria.searchField1_key;

		var columns=[];
		
		$(columnData).each(function(i){
			/* if(columnData[i].dateFlag){
				columns.push({
					field: columnData[i].dataField,
					title: columnData[i].dataText,
					template: '#= kendo.toString( new Date(parseInt('+columnData[i].dataField+')), "MM/dd/yyyy HH:MM" ) #',					
					filterable: false
				})
			}else{ */
				columns.push({
					field: columnData[i].dataField,
					title: columnData[i].dataText,				
					filterable: true
				})
			/* } */
		});
		 /*var getAuditDataUrl=window.sessionStorage.getItem('serverPath')+"auditTrail/getAuditTrailDetails?userId=RISKADMIN"+"&funcId="+searchCriteria.functionName+"&searchKey1="+searchCriteria.searchField1+"&searchValue1="+searchCriteria.searchField1_key+"&searchKey2="+searchCriteria.searchField2+"&searchValue2="+searchCriteria.searchField2_key;*/

		// var getAuditDataUrl=window.sessionStorage.getItem('serverPath')+"auditTrail/getAuditTrailDetails?userId=RISKADMIN"+"&funcId="+searchCriteria.functionName+"&searchKey1="+searchCriteria.searchField1+"&searchValue1="+searchCriteria.searchField1_key+"&searchKey2="+searchCriteria.searchField2+"&searchValue2="+searchCriteria.searchField2_key+"&updatedFromDate="+searchCriteria.updatedFromDate+"&updatedToDate="+searchCriteria.updatedToDate+"&createdFromDate="+searchCriteria.createdFromDate+"&createdToDate="+searchCriteria.createdToDate+"&verifiedFromDate="+searchCriteria.verifiedFromDate+"&verifiedToDate="+searchCriteria.verifiedToDate;
		var getAuditDataUrl=window.sessionStorage.getItem('serverPath')+"auditTrail/getAuditTrailDetails";

		var auditTrailDataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: getAuditDataUrl,
					dataType: "json",
					
					xhrFields: {
                        withCredentials: true
                       },
					data:filterCriteria
				}
			},
			error:function(e){
				if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
			},
			schema:{
				data: function(data){
					return data;
				}
			},
			pageSize: 10
		});
		
		$("#audit_trail_grid").kendoGrid({
			excel: {
				 allPages: true
			},
			dataSource: auditTrailDataSource,
			sortable:true,
			scrollable:true,
			pageable: true,
			columns:columns,
			filterable:{
				mode:"row"
			},
			excelExport: function(e) {
				e.preventDefault();
				promises[0].resolve(e.workbook);
			} 			
		});
		
		closeModal();
	}
	
	function openModal() {
	     $(".model-loader").show();
	}

	function closeModal() {
		 $(".model-loader").hide();	    
	}
	function converDateStrFormat(dateStr){
		  var date = Date.parse(dateStr);
          return kendo.toString( new Date(parseInt(date)), "ddMMyyyy" );       

	}

</script>
</head>
<body>

	<div id="boci-wrapper">
	<%@include file="header1.jsp"%>
	<div class="page-title">Audit Trail</div>
	
		<!-- <input type="hidden" id="pagetitle" name="pagetitle"
			value="Audit Trail">
		<div style="background-color:pink;" class="pageTitle"></div> -->
		<div class="search-section">
			<h3>Search Section</h3>
			<table cellpadding="0" cellspacing="0">
				<tr>
					<td>Function</td>
					<td colspan="3"><input id="functionScreen" value="" /></td>
					<td>
						<button type="button" id="exportBtn">Export</button>
					</td>
				</tr>
				<tr>
					<td>Search Field 1</td>
					<td><input id="searchField1" value="" /></td>
					<td>Value</td>
					<td><input id="searchField1_key" value="" class="k-textbox" />
					</td>
					<td>
						<button type="button" id="searchBtn">Search</button>
					</td>
				</tr>
				<tr>
					<td>Search Field 2</td>
					<td><input id="searchField2" value="" /></td>
					<td>Value</td>
					<td colspan="2"><input id="searchField2_key" value=""
						class="k-textbox" /></td>
				</tr>
				<tr>
					<td>Search Field 3</td>
					<td><input id="searchField3" value="" /></td>
					<td>Value</td>
					<td colspan="2"><input id="searchField3_key" value=""
						class="k-textbox" /></td>
				</tr>

				<tr>
					<td>Updated from-date</td>
					<td><input id="updatedFromDate" value="" class="k-textbox" />
					</td>
					<td>Updated to-date</td>
					<td colspan="2"><input id="updatedToDate" value=""
						class="k-textbox" /></td>
				</tr>
				<tr>
					<td>Created from-date</td>
					<td><input id="createdFromDate" value="" class="k-textbox" />
					</td>
					<td>Created to-date</td>
					<td colspan="2"><input id="createdToDate" value=""
						class="k-textbox" /></td>
				</tr>
				<tr>
					<td>Verified from-date</td>
					<td><input id="verifiedFromDate" value="" class="k-textbox" />
					</td>
					<td>Verified to-date</td>
					<td colspan="2"><input id="verifiedToDate" value=""
						class="k-textbox" /></td>
				</tr>
			</table>
		</div>
		<div style="overflow-x: scroll; width: 100%;">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr style="background-color: #5A2727; color: white">
					<td colspan="17">Audit Search Result Table</td>
				</tr>
				<tr>
					<td>
						<div id="audit_trail_grid">
							
						</div>
						
						<div id="modal1" class="model-loader" align="center"
							style="display: none;">
							<img id="loader" src="/ermsweb/resources/images/ajax-loader.gif" />
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
</body>
</html>
