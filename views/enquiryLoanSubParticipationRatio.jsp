<!DOCTYPE html>
<html lang="en">
<head>
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
<!-- jQuery JavaScript -->

<script src="/ermsweb/resources/js/jquery.min.js"></script>
<script src="/ermsweb/resources/js/jszip.min.js"></script>

<!-- Kendo UI combined JavaScript -->
<script src="/ermsweb/resources/js/kendo.all.min.js"></script>

<script type="text/javascript">
		
		$(document).ready(function () {
			
			//Export button click
			$("#exportBtn").kendoButton({
				click: function(){
					// trigger export of the AccDetails grid
					var activeListDetailsKendoGrid = $("#active-list").data("kendoGrid");
					if(activeListDetailsKendoGrid){
						activeListDetailsKendoGrid.saveAsExcel();
					}
				}	
			});
			$("#resetBtn").kendoButton({
	       		click: function(e) {
	       			toReset();
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
					}
					else{
						alert("Atleast One Field is Required");
					}				
				}
			});
			
		});
		
		//Displaying Data in the Grids
		function dataGrids(){		
			$(".empty-height").hide();
			openModal();
			
			var searchCriteria = {
				accountId:$('#accountNo').val(), 
				creditGrp:$('#creditGroup').val(),
				clientName:$('#clientName').val(), 
				facId:$('#facilityId').val(), 
				loanTxNo:$('#loanId').val()
			};
					
			
			//var getActiveListDetailsURL = "/ermsweb/searchEnquiryLoanSubPartData";
			var getActiveListDetailsURL = window.sessionStorage.getItem('serverPath')+"acctLoan/getSubPartRatio";
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
			
			
			$("#active-list").kendoGrid({
				excel: {
					 allPages: true,
					 fileName: "Enquiry_Loan_Sub_Participation_Ratio.xlsx"
				},
				dataSource: activeDataSource,
				pageable: true,
				columns: [
				
					{ field: "creditGroup", title:"Credit Group", autoWidth:true},
					{ field: "clientName", title:"Client Name", autoWidth:true},
					{ field: "sourceSystem", title:"Source System", autoWidth:true},
					{ field: "acctId",title:"Account No.",autoWidth:true},
					
					{ field: "subAccount", title:"Sub-acc", autoWidth:true},
					{ field: "accountName", title:"Account Name", autoWidth:true},
					{ field: "accountEntity", title:"Acc - Entity", autoWidth:true},	
					{ field: "limitTypeCode", title:"Limit Type", autoWidth:true},
					{ field: "facId", title:"Facility ID",autoWidth:true},
					{ field: "refFacId",title:"Facility Ccy<", autoWidth:true},
					{ field: "subPartRatio",title:"Limit Sub-Part Ratio",  autoWidth:true},
					{ field: "loanTxNo",title:"Loan ID", autoWidth:true},
					{ field: "loanType",title:"Loan Ccy",autoWidth:true},
					{ field: "tdLoanAmt",title:"Loan Amount",autoWidth:true},
					
					{ field: "loanSubPartRatio", title:"Loan Sub-Part Ratio", autoWidth:true},
					
					{ field: "maturityDate",title:"Loan Maturity Date",autoWidth:true},
					{ field: "intMature",title:"Loan Interest upon Maturity",autoWidth:true},
					{ field: "categoryCode", title:"Sub Part Category",autoWidth:true},
					{ field: "subPartEntity",title:"Sub Part Entity<", autoWidth:true},
					{ field: "weightedSubpartRatio", title:"Weighted Average Sub-Part Ratio",autoWidth:true}				
				]			
			});
			
			closeModal();
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
		
		function toReset(){
			document.getElementById("accountNo").value = "";
   			document.getElementById("creditGroup").value = "";
   			document.getElementById("clientName").value = "";
   			document.getElementById("facilityId").value = "";
   			document.getElementById("loanId").value = "";
   			
		}
		
    </script>
<style>
#search_result_container {
	margin-top: 20px;
}

.list-container {
	float: left;
	width: 75%;
}

table.grid-container {
	border-spacing: 0;
	overflow-x: scroll;
}

#search-filter-body tr td {
	padding: 0px 10px;
}

#active-list-container {
	margin-bottom: 20px;
	overflow-x: scroll;
}

#search-filter-body tr td:nth-child(even) {
	padding-right: 15px;
}
</style>
</head>
<body>
	<div class="boci-wrapper">

			<%@include file="header1.jsp"%>
			<div class="page-title">Enquiry Loan Sub Participation</div>
		<div id="boci-content-wrapper">
			<!-- <input type="hidden" id="pagetitle" name="pagetitle"
				value="Enquiry Loan Sub Participation"> -->
			<div class="filter-criteria">
				<div id="filter-table-heading" onclick="expandCriteria()">(-)
					Filter Criteria</div>
				<table class="list-table">
					<tbody id="search-filter-body" style="display: block;">
						<tr>
							<td>Account No</td>
							<td colspan="5"><input id="accountNo" type="text"
								class="select-textbox k-textbox k-textbox" /></td>
						</tr>
						<tr>
							<td colspan="6">&nbsp;</td>
						</tr>
						<tr>
							<td>Credit Group</td>
							<td><input id="creditGroup" type="text"
								class="select-textbox k-textbox" /></td>

							<td>Client Name</td>
							<td colspan="3"><input id="clientName" type="text"
								class="select-textbox k-textbox" /></td>
						</tr>
						<tr>
							<td colspan="6">&nbsp;</td>
						</tr>
						<tr>
							<td>Facility ID</td>
							<td><input id="facilityId" type="text"
								class="select-textbox k-textbox" /></td>

							<td>Loan ID</td>
							<td colspan="3"><input id="loanId" type="text"
								class="select-textbox k-textbox" /></td>
						</tr>
						<tr>
							<td colspan="6">&nbsp;</td>
							<td align="right">
								<button id="submitBtn" class="k-button" type="button">Search</button>
								<button id="resetBtn" class="k-button" type="button">Reset</button>
								<button id="exportBtn" class="k-button" type="button">Export</button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>

			<div id="search_result_container">
				<div id="active-list-container">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td colspan="8">
								<div class="list-header">Loan Sub-participation Table</div>
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
				<div class="clear"></div>
			</div>
		</div>
	</div>
</body>
</html>