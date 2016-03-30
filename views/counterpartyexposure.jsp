<html lang="en">

<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 
<script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>


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
	
<!--  <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/2.5.0/jszip.min.js"></script> -->
<script src="/ermsweb/resources/js/jszip.min.js"> </script>

<!-- jQuery JavaScript -->
<script src="/ermsweb/resources/js/jquery.min.js"></script>

<!-- Kendo UI combined JavaScript -->
<script src="/ermsweb/resources/js/kendo.all.min.js"></script>

<!-- <head>Enquiry Loan Sub-Participation Ratio</head> -->
<style type="text/css">
.k-grid-header tr th.k- {
	background-color: #B54D4D;
	font-size: 13px;
	color: #fff;
	white-space: pre-line;
}

#list .k-detail-row .k-detail-cell th.k-header {
	background: #777;
	color: white;
}

#list .k-hierarchy-cell a {
	background: #777 !important;
}

#grid tbody tr:hover {
	background: #ff0000;
}

#list .k-detail-row .k-widget {
	
}

#list .k-detail-row thead {
	color: red;
}

.k-pager-info, .k-label {
	float: left !important;
}

.k-pager-wrap, .k-grid-pager, .k-widget {
	width: 100% !important;
}
/* #list .k-hierarchy-cell{
		width:10% !important;		
	} */
/* #list .k-grid .k-hierarchy-col {
 		 width: 2px;
		} */
#list .k-detail-row .k-detail-cell table tr {
	background: #e0ebeb;
}

#list .k-detail-row .k-detail-cell .k-detail-row .k-detail-cell table tr
	{
	background: #ffddcc;
}

#list .k-detail-row .k-detail-cell .k-detail-row .k-detail-cell .k-detail-row table tr
	{
	background: #b3ffb3;
}

.k-detail-row>.k-hierarchy-cell {
	display: none;
}

tr.k-detail-row td.k-detail-cell {
	padding: 0px;
}

tr.k-detail-row tr.k-detail-row td.k-detail-cell {
	padding: 0px;
}

tr.k-detail-row tr.k-detail-row tr.k-detail-row td.k-detail-cell {
	padding-left: 25px;
}

.k-detail-row .k-header {
	display: none;
}

.disableCursor {
	cursor: none;
}
</style>
<script>
	        $(document).ready(function () {
	        	
				//Search button click
				$("#submitBtn").kendoButton({
					click: function(){
						 $('#list').empty();

                         dataGrids();
					}
				});
				$("#resetBtn").kendoButton({
					click: function(){
						$("#groupType").val("");
						$("#groupName").val("");
						$("#accNo").val("");
					
						//$("#returnMessage").html("");
						//$(".grid-container").find("tbody").html("<tr><td>&nbsp;</td></tr>");
					}
				});
				$("#exportBtn").click(function(e){
    				
				/* 	 window.open('data:application/vnd.ms-excel,' + $('.k-grid-header-wrap').html());
					    e.preventDefault(); */

    				/* var dataKendoGrid = $("#list").data("kendoGrid");
					alert(dataKendoGrid);
    				if(dataKendoGrid){
    					
    					dataKendoGrid.saveAsExcel();
    				} */
					var rows = [];
					var cells = [];
					var columnWidth = [];
					
					$(".k-grid-header").find("table").find("th").each(function(){
						var headerColumn = $(this).text();
						cells.push({value:headerColumn});
						columnWidth.push({autoWidth: true });
					});
					
					rows.push({cells:cells});
					cells = [];
					
					$(".k-grid-content").children("table").children("tbody").children("tr.k-master-row").each(function(index, element){
						getCellvalues($(this).children("td"));
						$(this).next(".k-detail-row").children(".k-detail-cell").children(".k-grid").children("table").children("tbody").children("tr.k-master-row").each(function(){
							getCellvalues($(this).children("td"));
							$(this).next(".k-detail-row").children(".k-detail-cell").children(".k-grid").children("table").children("tbody").children("tr.k-master-row").each(function(){
								getCellvalues($(this).children("td"));
								$(this).next(".k-detail-row").children(".k-detail-cell").children(".k-grid").children("table").children("tbody").children("tr").each(function(){
									getCellvalues($(this).children("td"), true);// by specifying true it will add one td manually
								});
							});
						});
					});	
					
					function getCellvalues(trObj, noTd){
						if(noTd){
							cells.push({value:""});
						}
						trObj.each(function(){
							var dataColumnsCG = " "+$(this).text();
							cells.push({value:dataColumnsCG});
						});
						rows.push({cells:cells});
						cells = [];
					}  
					
					var workbook = new kendo.ooxml.Workbook({
				          sheets: [
				            { 
				            	columns: columnWidth,
								title: "Counter Party Exposure",        
								rows: rows
				            }
				          ]
			        });
			        
			        kendo.saveAs({dataURI: workbook.toDataURL(), fileName: "CounterPartyExposure.xlsx"});
					
    			});
        	});
	
	//Displaying Data in the Grids
	function dataGrids(e){
		console.log(e);
		$(".empty-height").hide();
		openModal();
		var searchCriteria = {
			userId : window.sessionStorage.getItem('username'),
			groupType:$('#groupType').val(),
			groupName:$('#groupName').val(),
			ccdId:$('#accNo').val()
		};
		
		if(searchCriteria.groupType != "" || searchCriteria.groupName != "" || searchCriteria.ccdId != ""){

			var getCCPDetailsURL = window.sessionStorage.getItem('serverPath')+"limitexposure/getGrpExpTree?userId="+searchCriteria.userId+"&acctNo="+searchCriteria.ccdId+"&clnName="+searchCriteria.groupName+"&creditGrp="+searchCriteria.groupType;
			//var getCCPDetailsURL = "http://localhost:8080/ERMSCore/limitexposure/getGrpExpTree?userId="+searchCriteria.userId+"&acctNo="+searchCriteria.ccdId+"&clnName="+searchCriteria.groupName+"&creditGrp="+searchCriteria.groupType;
			//var getCCPDetailsURL = "/ermsweb/getGrpExpTree?userId="+searchCriteria.userId+"&accNo="+searchCriteria.ccdId+"&clnName="+searchCriteria.groupName+"&creditGrp="+searchCriteria.groupType;
		}else{
			exp = false;
	
			var getCCPDetailsURL = window.sessionStorage.getItem('serverPath')+"limitexposure/getExposureSummary?userId="+searchCriteria.userId;
			
			//var getCCPDetailsURL = "/ermsweb/getExposureSummary?userDetail="+searchCriteria.userId;
			//var getCCPDetailsURL = "/ermsweb/getGrpExpTree?userDetail="+searchCriteria.userId;
		}
			
		var activeDataSource = new kendo.data.DataSource({
										transport: {
											read: {
												url: getCCPDetailsURL,
												dataType: "json",
												
												xhrFields: {
						                            withCredentials: true
						                           }
												//data:searchCriteria
											}
										},
										error:function(e){
											if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
										},
										pageSize: 3
									});
		
		
		
		$("#list").kendoGrid({
			dataSource: activeDataSource,
				pageSize: 1,
				excel: {
					 allPages: true
				},
				emptyMsg: 'This grid is empty',
				schema: {
					model: {
						  id: "creditGroup",
					fields: {
						creditGroup:{ type: "string" },
						counterpartyName: { type: "string" },
						accEntity: { type: "string" },
						accountNo: { type: "string" },
						subAcc: { type: "string" },
						accStatus: { type: "string" },
						accAccType: { type: "string" },
						businessUnit: { type: "string" },
						limitType: { type: "string"  },
						limitHierarchyLevel: { type: "string" },
						parentLimitType: { type: "string" },
						facilityID: { type: "string" },
						limitExpiryDate: { type: "string" },
						limitCcy: { type: "string" },
						limitAmount: { type: "string" },
						limitAmountLEEBased: { type: "string" }
					}
				  }
			},
			
			scrollable:true,
			pageable: true,
			detailInit: function(e){
					return detailInit(e);
			},
			dataBound: function (e) {
				 var dataObj = e.sender._data;
					$.each(dataObj, function(i){
						
							if( dataObj[i].enableExpandButton == false){
								
								console.log(i);
								console.log(e);
								e.sender.table[0].rows[i].firstChild.className = "";
								e.sender.table[0].rows[i].firstElementChild.childNodes[0].className = "";
								e.sender.table[0].rows[i].firstElementChild.className = "disableCursor";
							}
						
					});
			}, 
/* 			excelExport: function(e) {
				//e.preventDefault();
				//promises[0].resolve(e.workbook);
				var dataKendoGrid = $("#list").data("kendoGrid");
				if(dataKendoGrid){
					dataKendoGrid.saveAsExcel();
				}
			}, */
			columns: [
					/* { field: "rmdGroupId", title: "Group Id" , width: 150}, */
					{ field: "rmdGroupDesc", title: "Credit Group" , width: 120},
					{ field: "ccdEngName", title: "Counterparty Name" , width: 150},
					{ field: "acctBookEntity", title: "Acc - Entity", width: 120},
					{ field: "acctId", title: "Account No", width: 120},
					{ field: "acctSubAcc", title: "Sub Acc", width: 120},
					{ field: "acctStatus", title: "Acc - Status", width: 120},
					{ field: "acctType", title: "Acc - Type", width: 120},
					{ field: "acctBizUnit", title: "Business Unit", width: 120},
					{ field: "limitType", title: "Limit Type", width: 120},
					{ field: "limitHierachyLevel", title: "Limit Hierarchy Level", width: 120},
					{ field: "parentLimitType", title: "Parent Limit Type", width: 120},
					{ field: "facilityId", title: "Facility ID", width: 120},
					{ field: "limitExpiryDate", title: "Limit Expiry Date", width: 120},
					{ field: "limitCcy", title: "Limit Ccy", width: 120},
					{ field: "limitAmount", title: "Limit Amount", width: 120},
					{ field: "limitAmountLee", title: "Limit Amount - LEE Based", width: 120},
					{ field: "limitUsageSd", title: "Limit Usage (SD)", width: 120},
					{ field: "limitUsageTd", title: "Limit Usage (TD)", width: 120},
					{ field: "limitUsageSdLee", title: "Limit Usage (SD) – LEE Based", width: 120},
					{ field: "limitUsageTdLee", title: "Limit Usage (TD) – LEE Based", width: 120},
					{ field: "collMktValueSd", title: "Collateral Market Value (SD)", width: 120},
					{ field: "collMktValueTd", title: "Collateral Market Value (TD)", width: 120},
					{ field: "collMargValueSd", title: "Collateral Marginable Value (SD)", width: 120},
					{ field: "collMargValueTd", title: "Collateral Marginable Value (SD)", width: 120},
					{ field: "collUsageSd", title: "Collateral Usage (SD)", width: 120},
					{ field: "collUsageTd", title: "Collateral Usage (TD)", width: 120},
					{ field: "econCap", title: "CEconomic Capital", width: 120}
					
			]
		});
		
			
		
		closeModal();
	}
	
	function detailInit(e, exp) {

		console.log(e)
		console.log($(this).html());
		if(e.data.rmdGroupId==null){
			var countVal =e.data.ccdId;
			var isEmpty=true;
		}else{
			var countVal = e.data.rmdGroupId;
			var isEmpty=false;
		}
	
		//alert(countVal);
//		var kdata = e.detailCell.context.attributes[0].value
//		console.log(kdata);
		var getCCPDetailsURL = window.sessionStorage.getItem('serverPath')+"limitexposure/getGrp2ndLvlExpTree?keyId="+countVal+"&isEmptyGrp="+isEmpty+"&userId="+window.sessionStorage.getItem('username');
		//var getCCPDetailsURL = "http://localhost:8080/ERMSCore/limitexposure/getGrp2ndLvlExpTree?keyId="+countVal+"&isEmtpyGrp=false"+"&userId="+window.sessionStorage.getItem('username');
		//var getCCPDetailsURL = "/ermsweb/getGrp2ndLvlExpTree?keyId="+countVal+"&isEmtpyGrp=false"+"&userId="+window.sessionStorage.getItem('username');
		
		  $("<div/>").appendTo(e.detailCell).kendoGrid({
		    dataSource: {
		        type: "json",
		        transport: {
		        	read: {
						url: getCCPDetailsURL,
						
						dataType: "json",
						xhrFields: {
                            withCredentials: true
                           }
						//data:searchCriteria
					}
		        },
		        error:function(e){
											if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
										},
/*				schema: {
					model: {
						  id: "creditGroup",
					}
				}*/

		    },
		    change: function(e){
		    	
		    },
		    scrollable: false,
		    detailInit: function(e){
					return detailInit1(e);
			},
			
			dataBound: function (e) {
                 	var dataObj = e.sender._data;
					$.each(dataObj, function(i){
							if( dataObj[i].enableExpandButton == false){
								console.log(i);
								console.log(e);
								e.sender.table[0].rows[i+1].firstChild.className = "";
								e.sender.table[0].rows[i+1].firstElementChild.childNodes[0].className  = "";
								e.sender.table[0].rows[i+1].firstElementChild.className = "disableCursor";
							}
						
					});
				 this.expandRow(this.tbody.find("tr.k-detail-row").css("background-color", "#ccc"));
			},
		    columns:
		           [
				
					{ field: "rmdGroupDesc", title: "Credit Group" , width: 120},
					{ field: "ccdEngName", title: "Counterparty Name" , width: 150},
					{ field: "acctBookEntity", title: "Acc - Entity", width: 120},
					{ field: "acctId", title: "Account No", width: 120},
					{ field: "acctSubAcc", title: "Sub Acc", width: 120},
					{ field: "acctStatus", title: "Acc - Status", width: 120},
					{ field: "acctType", title: "Acc - Type", width: 120},
					{ field: "acctBizUnit", title: "Business Unit", width: 120},
					{ field: "limitType", title: "Limit Type", width: 120},
					{ field: "limitHierachyLevel", title: "Limit Hierarchy Level", width: 120},
					{ field: "parentLimitType", title: "Parent Limit Type", width: 120},
					{ field: "facilityId", title: "Facility ID", width: 120},
					{ field: "limitExpiryDate", title: "Limit Expiry Date", width: 120},
					{ field: "limitCcy", title: "Limit Ccy", width: 120},
					{ field: "limitAmount", title: "Limit Amount", width: 120},
					{ field: "limitAmountLee", title: "Limit Amount - LEE Based", width: 120},
					{ field: "limitUsageSd", title: "Limit Usage (SD)", width: 120},
					{ field: "limitUsageTd", title: "Limit Usage (TD)", width: 120},
					{ field: "limitUsageSdLee", title: "Limit Usage (SD)- LEE Based", width: 120},
					{ field: "limitUsageTdLee", title: "Limit Usage (TD)- LEE Based", width: 120},
					{ field: "collMktValueSd", title: "Collateral Market Value (SD)", width: 120},
					{ field: "collMktValueTd", title: "Collateral Market Value (TD)", width: 120},
					{ field: "collMargValueSd", title: "Collateral Marginable Value (SD)", width: 120},
					{ field: "collMargValueTd", title: "Collateral Marginable Value (SD)", width: 120},
					{ field: "collUsageSd", title: "Collateral Usage (SD)", width: 120},
					{ field: "collUsageTd", title: "Collateral Usage (TD)", width: 120},
					{ field: "econCap", title: "CEconomic Capital", width: 120}
		          ]
		  }).data("kendoGrid");
		 }
	
	function detailInit1(e) {

		console.log(e)
		console.log($(this).html());
		alert(e.detailCell);
		var countVal = e.data.ccdId;
		var isEmpty=false;
		if(e.data.rmdGroupId==null){
			var isEmpty=true;
		}

		//alert(countVal);
//		var kdata = e.detailCell.context.attributes[0].value
//		console.log(kdata);
		var getCCPDetailsURL = window.sessionStorage.getItem('serverPath')+"limitexposure/getCln2ndLvlExpTree?ccdId="+countVal+"&userId="+window.sessionStorage.getItem('username');
		//var getCCPDetailsURL = "http://localhost:8080/ERMSCore/limitexposure/getGrp2ndLvlExpTree?keyId="+countVal+"&isEmtpyGrp=false"+"&userId="+window.sessionStorage.getItem('username');
		//var getCCPDetailsURL = "/ermsweb/getCln2ndLvlExpTree?ccdId="+countVal+"&userId="+window.sessionStorage.getItem('username');
		//var getCCPDetailsURL = "/ermsweb/getGrp2ndLvlExpTree?keyId="+countVal+"&isEmtpyGrp=false"+"&userId="+window.sessionStorage.getItem('username');
		  $("<div/>").appendTo(e.detailCell).kendoGrid({
		    dataSource: {
		        type: "json",
		        transport: {
		        	read: {
						url: getCCPDetailsURL,
						
						dataType: "json",
						xhrFields: {
                            withCredentials: true
                           }
						//data:searchCriteria
					}
		        },
		        error:function(e){
											if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
										},
/*				schema: {
					model: {
						  id: "creditGroup",
					}
				}*/

		    },
		    change: function(e){
		    	
		    },
		    scrollable: false,
		    detailInit: function(e){
					return detailInit2(e);
			},
			
			dataBound: function (e) {
                 	var dataObj = e.sender._data;
					$.each(dataObj, function(i){
							if( dataObj[i].enableExpandButton == false){
								console.log(i);
								console.log(e);
								e.sender.table[0].rows[i+1].firstChild.className = "";
								e.sender.table[0].rows[i+1].firstElementChild.childNodes[0].className  = "";
								e.sender.table[0].rows[i+1].firstElementChild.className = "disableCursor";
							}
						
					});
				 this.expandRow(this.tbody.find("tr.k-detail-row").css("background-color", "#f7f7f7"));
			},
		    columns:
		           [
				
					{ field: "rmdGroupDesc", title: "Credit Group" , width: 120},
					{ field: "ccdEngName", title: "Counterparty Name" , width: 150},
					{ field: "acctBookEntity", title: "Acc - Entity", width: 120},
					{ field: "acctId", title: "Account No", width: 120},
					{ field: "acctSubAcc", title: "Sub Acc", width: 120},
					{ field: "acctStatus", title: "Acc - Status", width: 120},
					{ field: "acctType", title: "Acc - Type", width: 120},
					{ field: "acctBizUnit", title: "Business Unit", width: 120},
					{ field: "limitType", title: "Limit Type", width: 120},
					{ field: "limitHierachyLevel", title: "Limit Hierarchy Level", width: 120},
					{ field: "parentLimitType", title: "Parent Limit Type", width: 120},
					{ field: "facilityId", title: "Facility ID", width: 120},
					{ field: "limitExpiryDate", title: "Limit Expiry Date", width: 120},
					{ field: "limitCcy", title: "Limit Ccy", width: 120},
					{ field: "limitAmount", title: "Limit Amount", width: 120},
					{ field: "limitAmountLee", title: "Limit Amount - LEE Based", width: 120},
					{ field: "limitUsageSd", title: "Limit Usage (SD)", width: 120},
					{ field: "limitUsageTd", title: "Limit Usage (TD)", width: 120},
					{ field: "limitUsageSdLee", title: "Limit Usage (SD) – LEE Based", width: 120},
					{ field: "limitUsageTdLee", title: "Limit Usage (TD) – LEE Based", width: 120},
					{ field: "collMktValueSd", title: "Collateral Market Value (SD)", width: 120},
					{ field: "collMktValueTd", title: "Collateral Market Value (TD)", width: 120},
					{ field: "collMargValueSd", title: "Collateral Marginable Value (SD)", width: 120},
					{ field: "collMargValueTd", title: "Collateral Marginable Value (SD)", width: 120},
					{ field: "collUsageSd", title: "Collateral Usage (SD)", width: 120},
					{ field: "collUsageTd", title: "Collateral Usage (TD)", width: 120},
					{ field: "econCap", title: "CEconomic Capital", width: 120}
		          ]
		  }).data("kendoGrid");
		 }

	function detailInit2(e) {
		var accountId= e.data.acctId;
		var bussinessUnit = e.data.acctBizUnit;
		var bookEntity = e.data.acctBookEntity;
		var dataSourceAppId=e.data.acctDataSourceAppId;
		var getCCPDetailsURL = window.sessionStorage.getItem('serverPath')+"limitexposure/getAcct2ndLvlExpTree?acctId="+accountId+"&bizUnit="+bussinessUnit+"&bookEntity="+bookEntity+"&dataSourceAppId="+dataSourceAppId+"&userId="+window.sessionStorage.getItem('username');
		//var getCCPDetailsURL = "/ermsweb/getAcct2ndLvlExpTree?accId="+accountId+"&bizUnit="+bussinessUnit+"&bookEntity="+bookEntity+"&dataSourceAppId="+dataSourceAppId+"&userId="+window.sessionStorage.getItem('username');
	  
			  $("<div/>").appendTo(e.detailCell).kendoGrid({
			    dataSource: {
			        type: "json",
			        transport: {
			        	read: {
							url: getCCPDetailsURL,
							
							dataType: "json",
							xhrFields: {
	                            withCredentials: true
	                           }
							//data:searchCriteria
						}
			           
			        },
			        error:function(e){
											if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
										},
			        pageable: {
			            refresh: true
			        },
			        detailInit: function(e){
						return detailInit3(e);
					},
			        //serverPaging: true,
			        //serverSorting: true,
			        //serverFiltering: true,
			        //pageSize: 5,
			    },
			    scrollable: false,
			    sortable: false,
			    selectable: false,
			    columns:
			            [
							{ field: "rmdGroupDesc", title: "Credit Group" , width: 120},
							{ field: "ccdEngName", title: "Counterparty Name" , width: 150},
							{ field: "acctBookEntity", title: "Acc - Entity", width: 120},
							{ field: "acctId", title: "Account No", width: 120},
							{ field: "acctSubAcc", title: "Sub Acc", width: 120},
							{ field: "acctStatus", title: "Acc - Status", width: 120},
							{ field: "acctType", title: "Acc - Type", width: 120},
							{ field: "acctBizUnit", title: "Business Unit", width: 120},
							{ field: "limitType", title: "Limit Type", width: 120},
							{ field: "limitHierachyLevel", title: "Limit Hierarchy Level", width: 120},
							{ field: "parentLimitType", title: "Parent Limit Type", width: 120},
							{ field: "facilityId", title: "Facility ID", width: 120},
							{ field: "limitExpiryDate", title: "Limit Expiry Date", width: 120},
							{ field: "limitCcy", title: "Limit Ccy", width: 120},
							{ field: "limitAmount", title: "Limit Amount", width: 120},
							{ field: "limitAmountLee", title: "Limit Amount - LEE Based", width: 120},
							{ field: "limitUsageSd", title: "Limit Usage (SD)", width: 120},
							{ field: "limitUsageTd", title: "Limit Usage (TD)", width: 120},
							{ field: "limitUsageSdLee", title: "Limit Usage (SD) – LEE Based", width: 120},
							{ field: "limitUsageTdLee", title: "Limit Usage (TD) – LEE Based", width: 120},
							{ field: "collMktValueSd", title: "Collateral Market Value (SD)", width: 120},
							{ field: "collMktValueTd", title: "Collateral Market Value (TD)", width: 120},
							{ field: "collMargValueSd", title: "Collateral Marginable Value (SD)", width: 120},
							{ field: "collMargValueTd", title: "Collateral Marginable Value (SD)", width: 120},
							{ field: "collUsageSd", title: "Collateral Usage (SD)", width: 120},
							{ field: "collUsageTd", title: "Collateral Usage (TD)", width: 120},
							{ field: "econCap", title: "CEconomic Capital", width: 120}
									
			            ]
			  }).data("kendoGrid");
			 }
	
	
	
	function expandCriteria(){
		var filterBody = document.getElementById("search-filter-body").style.display;
		if(filterBody != "block"){
			document.getElementById("search-filter-body").style.display = "block";
			document.getElementById("filter-table-heading").innerHTML= "<b>(-) Filter Criteria</b>";
		}else{
			document.getElementById("search-filter-body").style.display = "none";
			document.getElementById("filter-table-heading").innerHTML = "<b>(+) Filter Criteria</b>";
		}
	}
	
	function openModal() {
	    $("#modal, #modal1").show();
	}

	function closeModal() {
	    $("#modal, #modal1").hide();	    
	}
	
    </script>

<body>
	
		<%@include file="header1.jsp"%>
		<div class="page-title">Exposure Tree Maintenance</div>
	<!-- <input type="hidden" id="pagetitle" name="pagetitle"
		value="Exposure Tree Maintenance">
	<div style="background-color:pink; width:1000" class="pageTitle">Client Counterparty RMD Detail Maintenance</div>
	<br>
 -->
	 <div class="filter-criteria">
	 			<div id="filter-table-heading" class="bold" onclick="expandCriteria()" style="cursor:pointer;">
					(-) Filter Criteria
				</div>
				<table cellpadding="0" cellspacing="0" id="list-table">
					<tbody id="search-filter-body" style="display: block">
						<tr>
							<td>Credit Group</td>
							<td><input id="groupType" class="k-textbox" type="text" /></td>

						</tr>
						<tr>
							<td colspan="6">&nbsp;</td>
						</tr>
						<tr>
							<td>Client/Counterparty Name &nbsp; </td>
							<td><input id="groupName" class="k-textbox" type="text" /></td>

						</tr>
						
						<tr>
							<td colspan="6">&nbsp;</td>
						</tr>
						
						
						<tr>
							<td>Account No </td>
							<td><input id="accNo" class="k-textbox" type="text" /></td>

						</tr>
						
						<tr>
							<td colspan="6">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="3" align="right"></td>
							<td colspan="2"><b>Result :</b> <br> <b><div
										id="returnMessage"></div></b></td>
							<td>
								<button id="submitBtn" class="k-button" type="button">Search</button>
								<button id="resetBtn" type="button">Reset</button>
								<button class="k-button k-button-icontext k-grid-excel" id="exportBtn" type="button">Export</button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
	<div style="overflow-x: scroll; width: 100%;">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr style="background-color: #5A2727; color: white;">
				<td>Client Counterparty Table</td>
			</tr>
			<tr>
				<td>
					<div id="list"></div>
					
					<div id="modal" align="center" style="display: none;">
						<img id="loader" src="/ermsweb/resources/images/ajax-loader.gif" />
					</div>
				</td>
			</tr>
		</table>
	</div>
	<!-- <div style="font-size: 13px" id="countRow"></div>
		<div id="pager1"></div> -->
	<br />

</body>
</html>
