<html lang="en">

	<meta http-equiv="Content-Style-Type" content="text/css">
    <meta http-equiv="Content-Script-Type" content="text/javascript">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>
    
    <!-- General layout Style -->
    <link href="/ermsweb/resources/css/layout.css" rel="stylesheet" type="text/css">

    <!-- Kendo UI API -->
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.common.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.rtl.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.default.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.dataviz.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.dataviz.default.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.mobile.all.min.css">

    <!-- jQuery JavaScript -->
    <script src="/ermsweb/resources/js/jquery.min.js"></script>

    <!-- Kendo UI combined JavaScript -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>

    <!-- <head>Enquiry Loan Sub-Participation Ratio</head> -->
<style type="text/css">
	.k-grid-header tr th.k-


{
		background-color:#B54D4D; font-size:13px; color:#fff;
		white-space:pre-line;
	}
</style>
 	<script>
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
				
				var testdataSource = new kendo.data.DataSource({
										transport: {
											read: {
												url: "/ermsweb/resources/js/getClientCounterList.json",
												dataType: "json",
											}
										},
										pageSize: 3,
										change:function(){
											var objgd = this.view();
											$.each(objgd, function(i){
												var spltarr = objgd[i].action.split(",");
												var split_string = (spltarr[0] == "A") ? "<a target=\"main_frame\" href='ccpDetailMaintenanceView?ccdid="+objgd[i].ccdId+"'><img src='/ermsweb/resources/images/bg_view.png' width='' height=''/></a>&nbsp;<a target=\"main_frame\" href='ccpDetailMaintenanceView?ccdid="+objgd[i].ccdId+"'><img src='/ermsweb/resources/images/bg_update.png' width='' height=''/></a>" : "<a target=\"main_frame\" href='ccp_detail_maintenance_update.html?ccdid="+objgd[i].ccdId+"'><img src='/ermsweb/resources/images/bg_update.png' width='' height=''/></a>&nbsp;<a target=\"main_frame\" href='ccp_detail_maintenance_view.html?ccdid="+objgd[i].ccdId+"'><img src='/ermsweb/resources/images/bg_view.png' width='' height=''/></a>";												
												objgd[i].action =  split_string;
											});
										}
									});
				
				$("#list").kendoGrid({
                        dataSource: testdataSource, 
						scrollable:true,
						pageable: true,
						columns: [
								{ field: "ccdId", title: "CCD ID" , width: 120},
								{ field: "clnCptyName", title: "Client/Counterparty Name", width: 120},
								{ field: "clnCptyCat", title: "Client/Counterparty Category", width: 120},
								{ field: "creditRatingInteral", title: "Credit Rating - Internal (Private)", width: 120},
								{ field: "externalKey1", title: "External Key ID #1", width: 120},
								{ field: "externalKey2", title: "External Key ID #2", width: 120},
								{ field: "externalKey3", title: "External Key ID #3", width: 120},
								{ field: "externalKey4", title: "External Key ID #4", width: 120},
								{ field: "externalKey5", title: "External Key ID #5", width: 120},
								{ field: "externalKey6", title: "External Key ID #6", width: 120},
								{ field: "externalKey7", title: "External Key ID #7", width: 120},
								{ field: "externalKey8", title: "External Key ID #8", width: 120},
								{ field: "externalKey9", title: "External Key ID #9", width: 120},
								{ field: "externalKey10", title: "External Key ID #10", width: 120},
								{ field: "updateBy", title: "Updated by", width: 120},
								{ field: "lastUpdated", title: "Last Updated", width: 120},
								{ field: "action", title: "Action", template:"<span class='iconOpr'>#=action#</span>", width: 120}
                        ]
				});
				
				/*Client Counterparty RMD Detail change request Table */
				$("#list1").kendoGrid({
                        dataSource: testdataSource,
						scrollable:true,
						pageable: true,
						columns: [
								{ field: "ccdId", title: "CCD ID" , width: 120},
								{ field: "clnCptyName", title: "Client/Counterparty Name", width: 120},
								{ field: "clnCptyCat", title: "Client/Counterparty Category", width: 120},
								{ field: "creditRatingInteral", title: "Credit Rating - Internal (Private)", width: 120},
								{ field: "externalKey1", title: "External Key ID #1", width: 120},
								{ field: "externalKey2", title: "External Key ID #2", width: 120},
								{ field: "externalKey3", title: "External Key ID #3", width: 120},
								{ field: "externalKey4", title: "External Key ID #4", width: 120},
								{ field: "externalKey5", title: "External Key ID #5", width: 120},
								{ field: "externalKey6", title: "External Key ID #6", width: 120},
								{ field: "externalKey7", title: "External Key ID #7", width: 120},
								{ field: "externalKey8", title: "External Key ID #8", width: 120},
								{ field: "externalKey9", title: "External Key ID #9", width: 120},
								{ field: "externalKey10", title: "External Key ID #10", width: 120},
								{ field: "status", title: "Status", width: 120},
								{ field: "updateBy", title: "Updated by", width: 120},
								{ field: "lastUpdated", title: "Last Updated", width: 120},
								{ field: "action", title: "Action", template:"<span class='iconOpr'>#=action#</span>", width: 120}
                        ]
				});
				
				$("#resetBtn").kendoButton();
				$("#exportBtn").kendoButton();				
        	});
		
	function icons_operations(operands){
		console.log("Welcome: "+operands);
	}
	
	function displayFilterResults() {
	  // Gets the data source from the grid.
	  	var dataSource = $("#MyGrid").data("kendoGrid").dataSource;
	  
	  	 	// Gets the filter from the dataSource
	     	var filters = dataSource.filter();
	     	
	     	// Gets the full set of data from the data source
	     	var allData = dataSource.data();
	     	
	     	// Applies the filter to the data
	     	var query = new kendo.data.Query(allData);
	     	var filteredData = query.filter(filters).data;
	     	
	     	// Output the results
	     	$('#FilterCount').html(filteredData.length);
	     	$('#TotalCount').html(allData.length);
	     	$('#FilterResults').html('');
	    	
	    	$.each(filteredData, function(index, item){
	    	  $('#FilterResults').append('<li>'+item.Site+' : '+item.Visitors+'</li>')
	    	});	
	}
	/* Open spinner while getting the data from back-end*/
	function openModal() {
	     document.getElementById('modal').style.display = 'block';
		 document.getElementById('modal1').style.display = 'block';
	     document.getElementById('modal2').style.display = 'block';
	}

	/* Close spinner when all the data have been received*/
	function closeModal() {
	    document.getElementById('modal').style.display = 'none';
		document.getElementById('modal1').style.display = 'none';
	    document.getElementById('modal2').style.display = 'none';
	}
    </script>

	<body>
<!-- 		<script type="text/javascript" src="js/header.js"></script> -->
		<div style="background-color:pink; width:1000" class="pageTitle">Client Counterparty RMD Detail Maintenance</div>
		<br>

		<table id="listTable" width="1000" style="background-color:#DBE5F1; overflow-x:scroll" cellpadding="0" cellspacing="0">
			<tr>
				<td colspan="4" style="background-color:#8DB4E3; width:1000">(+) Filter Criteria</td>
			</tr>
			<tr>
				<td><br></td>
			</tr>
			<tr>
				<td>Group Name.</td>
				<td><input id="group_name" type="text"/></td>
				<td colspan="2"></td>
			</tr>
			<tr>
				<td>Group Type.</td>
				<td><input id="group_type" type="text"/></td>
				<td colspan="2"></td>
			</tr>
			<tr>
				<td>CCD ID.</td>
				<td><input id="ccd_id" type="text"/></td>
				<td colspan="2"></td>
			</tr>
			<tr>
				<td>CMD Client ID.</td>
				<td><input id="cmd_client_id" type="text"/></td>
				<td colspan="2"></td>
			</tr>
			<tr>
				<td>Client/Counterparty Name.</td>
				<td><input id="ccp_name" type="text"/></td>
				<td colspan="2"></td>
			</tr>
			<tr>
				<td>Account No.</td>
				<td><input id="acc_no" type="text"/></td>
				<td colspan="2"></td>
			</tr>
			<tr>
				<td>Sub-acc.</td>
				<td><input id="sub_acc" type="text"/></td>
				<td colspan="2"></td>
			</tr>
			<tr>
				<td>Account - Name.</td>
				<td><input id="acc_name" type="text"/></td>
				<td colspan="2"></td>
			</tr>
			<tr>
				<td>Acc - Biz Unit.</td>
				<td><input id="acc_biz_unit" type="text"/></td>
				<td colspan="2"></td>
			</tr>
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td>
					<button id="submitBtn" class="k-button" type="button">Search</button>
					<button id="resetBtn" type="button">Reset</button>
					<button id="exportBtn" type="button">Export</button>
				</td>
			</tr>
			<tr></tr>
			<tr></tr>
		</table>
		<br/>		
		<div style="overflow-x: scroll; width:1000px;">
			<table width="1000" cellpadding="0" cellspacing="0">
				<tr style="background-color:#5A2727; color:white">
					<td>
						Client Counterparty Table
					</td>
				</tr>
				<tr>
					<td>
						<div id="modal" align="center" style="display:none;">
							<img id="loader" src="/ermsweb/resources/images/ajax-loader.gif" />
						</div>
						<div id="list">
							
						</div>
					</td>
				</tr>				
			</table>
		</div>
		<!-- <div style="font-size: 13px" id="countRow"></div>
		<div id="pager1"></div> -->
		<br/>
		<div style="overflow-x: scroll; width:1000px;">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr style="background-color:#5A2727; color:white">
					<td colspan="17">
						Client Counterparty RMD Detail change request Table
					</td>
				</tr>
				<tr>
					<td>
						<div id="modal" align="center" style="display:none;">
							<img id="loader" src="/ermsweb/resources/images/ajax-loader.gif" />
						</div>
						<div id="list1">
						</div>
					</td>
				</tr>				
			</table>
		</div>
		<!-- <div style="width:1000" id='MyGrid'>
		<div style="background-color:grey; color:white">Result</div>
			<div id="modal2" align="center" style="display:none;">
	            <img id="loader2" src="images/ajax-loader.gif" />
	        </div>
		</div> -->
	</body>
</html>	