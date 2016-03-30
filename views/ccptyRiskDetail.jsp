<!DOCTYPE html>
<html lang="en">
	<link rel="shortcut icon" href="/ermsweb/resources/images/boci.ico" />
	
	<meta http-equiv='cache-control' content='no-cache'>
	<meta http-equiv='expires' content='0'>
	<meta http-equiv='pragma' content='no-cache'>
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10">
	<meta http-equiv="Content-Style-Type" content="text/css">
    <meta http-equiv="Content-Script-Type" content="text/javascript">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 
    <script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>
	<script src="/ermsweb/resources/js/common_tools.js"></script>	    

   

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
	<script src="/ermsweb/resources/js/common_tools.js"></script>
	
    <!-- Kendo UI combined JavaScript -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
    <script src="/ermsweb/resources/js/jszip.min.js"></script>

    <script>	

	    $(document).ready(function(){

	    	/*pagetitle*/

	    	if(getURLParameters("type") == "pme"){

	    		$("#pagetitle").val("CPTY Potential Market Exposure (PME) Summary Report");

	    	}
	    	else if(getURLParameters("type") == "dse"){

	    		$("#pagetitle").val("CPTY Daily Settlement Exposure (DSE) Summary Report");

	    	}
	    	else if(getURLParameters("type") == "dvp"){

	    		$("#pagetitle").val("CPTY Deliver vs Payment (DVP) Exposure  Summary Report");

	    	}
	    	else if(getURLParameters("type") == "buBudgetLimit"){

	    		$("#pagetitle").val("CPTY Business Budget Limit Monitoring by Business Unit");

	    	}
	    	else if(getURLParameters("type") == "enBudgetLimit"){

	    		$("#pagetitle").val("CPTY Business Budget Limit Monitoring by Entity");

	    	}
	    	else if(getURLParameters("type") == "expo"){

	    		$("#pagetitle").val("CPTY General Exposure Monitoring Report");

	    	}
	    	else if(getURLParameters("type") == "marginUtlSum"){

	    		$("#pagetitle").val("CPTY GC UK MARGIN CALL & UTLISATION SUMMARY REPORT");

	    	}
	    	else if(getURLParameters("type") == "ccptyExpo"){

	    		$("#pagetitle").val("CPTY Counterparty Exposure Summary and Margin Call");

	    	}
	    	else if(getURLParameters("type") == "placedMarginDeposit"){

	    		$("#pagetitle").val("CPTY Placed Margin Deposit Limit Summary Report");

	    	}


	    	var bookEntityList = [
				{text: "", value: ""},
				{text: "ALL", value: "ALL"},
			    {text: "BOCIGC", value: "BOCIGC"},
			    {text: "BOCICnF", value: "BOCICnF"},
			    {text: "BOCIGCUK	", value: "BOCIGCUK"},
			    {text: "BOCICnFUS", value: "BOCICnFUS"},
			    {text: "BOCIGCSG", value: "BOCIGCSG"},
			    {text: "BOCIGCSH", value: "BOCIGCSH"},
			    {text: "BOCIFP", value: "BOCIFP"},
			    {text: "BOCIS", value: "BOCIS"},
			    {text: "BOCIL", value: "BOCIL"},
			    {text: "BOCIH", value: "BOCIH"},
			    {text: "BOCIAsia", value: "BOCIAsia"}
			];

			var bizUnitList = [
				{text: "", value: ""},
				{text: "ALL", value: "ALL"},
				{text: "Finance & Treasury (F&T) ", value: "F&T"},
				{text: "Product Marketing (PM)", value: "PM"},
				{text: "Global Commodities (GC)", value: "GC"},
				{text: "Equity Derivative (ESR-ED) ", value: "ESR-ED"},
				{text: "Financial Product Fixed Income(FP)", value: "FP"}
			]

	    	$("#bookEntity").kendoDropDownList({
	    		dataTextField: "text",
	    		dataValueField: "value",
	    		dataSource: bookEntityList,
	    		index: 0
	    	});

	    	$("#bizUnit").kendoDropDownList({
	    		dataTextField: "text",
	    		dataValueField: "value",
	    		dataSource: bizUnitList,
	    		index: 0
	    	});

	    	if(getURLParameters("type") == "buBudgetLimit" || getURLParameters("type") == "enBudgetLimit" || getURLParameters("type") == "marginUtlSum"){

	    		$("#ccdId").css({"display":"none"});
	    		$("#cptyName").css({"display":"none"});
	    		$("#labelCcdId").css({"display":"none"});
	    		$("#labelCcptyName").css({"display":"none"});
	    	}

	    });

		function postfixUrl(inputTexts){

			var query = "";


			$.each(inputTexts, function(key, value) {
				query += "&" + key + "=" + value;
			});

			return query;
		}

		/*
		function onExportBy(type){

			if(getURLParameters("type") == "pme"){
				url = window.sessionStorage.getItem('serverPath')+"cptyMonRpt/getErmsReport033?userId="+window.sessionStorage.getItem("username")+""+postfixUrl(getAllInputTextFields2("filterBody"));

				cols = [  
			       {field: "ccdId", width: 150},
			       {field: "cptyName", width: 150},
			       {field: "bizUnit", width: 150},
			       {field: "bookEntity", width: 150},
			       {field: "currentMtm", width: 150},
			       {field: "matlabMtm", width: 150},
			       {field: "nonMatlabMtm", width: 150},
			       {field: "grossPme", width: 150},
			       {field: "tdCollValue", width: 150},
			       {field: "netPme", width: 150},
			       {field: "lmtAmt", width: 150},
			       {field: "lmtXcessAmt", width: 150},
			       {field: "lmtUtlzPercent", width: 150},
			       {field: "remarks", width: 150},
			       {field: "matlabProdPme", width: 150},
			       {field: "nonMatlabProdPme", width: 150},
			       {field: "bondRepoPme", width: 150}
			    ];
			}
			var dataSource = new kendo.data.DataSource({
	    		transport: {
	    			read: {
	    	   		  	type: "GET",
	    			    url: url,
	    			    dataType: "json",
	    			    xhrFields: {
				    		withCredentials: true
				    	}
	    			}
	    		},
	    	    schema: {                               
	                total: function(argument) {                            
	                    try{
	                    	var totalRow = argument[0].total ;
	                    	return totalRow;
	                    }catch(err){
	                    	return 0;
	                    }
	                }
            	},
		        serverPaging: true,
	    		pageSize: 50
		    });			
		}

		*/
		
		function toExportBy(type){
			console.log(type);
			$(".k-grid-excel").click();
		}

		function onSearchBy(type){
			
			var url = "";
			var cols = [];
			var groupBy = [];

			if(getURLParameters("type") == "pme"){

				url = window.sessionStorage.getItem('serverPath')+"cptyMonRpt/getErmsReport033?userId="+window.sessionStorage.getItem("username")+""+postfixUrl(getAllInputTextFields2("filterBody"));

				cols = [  
			       {field: "ccdId", width: 150},
			       {field: "cptyName", width: 150},
			       {field: "bizUnit", width: 150},
			       {field: "bookEntity", width: 150},
			       {field: "currentMtm", width: 150},
			       {field: "matlabMtm", width: 150},
			       {field: "nonMatlabMtm", width: 150},
			       {field: "grossPme", width: 150},
			       {field: "tdCollValue", width: 150},
			       {field: "netPme", width: 150},
			       {field: "lmtAmt", width: 150},
			       {field: "lmtXcessAmt", width: 150},
			       {field: "lmtUtlzPercent", width: 150},
			       {field: "remarks", width: 150},
			       {field: "matlabProdPme", width: 150},
			       {field: "nonMatlabProdPme", width: 150},
			       {field: "bondRepoPme", width: 150}
			    ];

			}else if(getURLParameters("type") == "dse") {

				url = window.sessionStorage.getItem('serverPath')+"cptyMonRpt/getErmsReport034?userId="+window.sessionStorage.getItem("username")+""+postfixUrl(getAllInputTextFields2("filterBody"));

				cols = [
					{field: "ccdId", width: 150},
					{field: "cptyName", width: 150},
					{field: "bizUnit", width: 150},
					{field: "bookEntity", width: 150},
					{field: "t1Expo", width: 150},
					{field: "t2Expo", width: 150},
					{field: "t3Expo", width: 150},
					{field: "t4Expo", width: 150},
					{field: "t5ExpoOnwardPeak", width: 150},
					{field: "t5ExpoOnwardPeakDate", width: 150},
					{field: "maxDse", width: 150},
					{field: "lmtAmt", width: 150},
					{field: "lmtXcessAmt", width: 150},
					{field: "lmtUtlzPercent", width: 150},
					{field: "remarks", width: 150}
				]

			}else if(getURLParameters("type") == "dvp") {

				url = window.sessionStorage.getItem('serverPath')+"cptyMonRpt/getErmsReport035?userId="+window.sessionStorage.getItem("username")+""+postfixUrl(getAllInputTextFields2("filterBody"));

				cols = [
					{field: "ccdId", width: 150, title: "CCD ID"},
					{field: "cptyName", width: 150},
					{field: "bizUnit", width: 150},
					{field: "bookEntity", width: 150},
					{field: "t1Expo", width: 150},
					{field: "t2Expo", width: 150},
					{field: "t3Expo", width: 150},
					{field: "t4Expo", width: 150},
					{field: "t5Onward", width: 150},
					{field: "t5OnwardFinalDvpDate", width: 150},
					{field: "totDvpExpo", width: 150},
					{field: "lmtAmt", width: 150},
					{field: "lmtXcessAmt", width: 150},
					{field: "lmtUtlzPercent", width: 150},
					{field: "remarks", width: 150}
				]

			}else if(getURLParameters("type") == "buBudgetLimit"){
				
				url = window.sessionStorage.getItem('serverPath')+"cptyMonRpt/getErmsReport036?userId="+window.sessionStorage.getItem("username")+""+postfixUrl(getAllInputTextFields2("filterBody"));

				cols = [
					/*{field: "bizUnit", value: "bizUnit"},*/
					{field: "type", value: "type"},
					{field: "lmtTypeDesc", value: "lmtTypeDesc"},
					{field: "expo", value: "expo"},
					{field: "boardLmt", value: "boardLmt"},
					{field: "lmtUtlzPercent", value: "lmtUtlzPercent"},
					{field: "isLmtExcessInd", value: "isLmtExcessInd"}
				]

				groupBy = [{ field: "bizUnit", value: "bizUnit" }]  ;

			}else if(getURLParameters("type") == "enBudgetLimit"){

				url = window.sessionStorage.getItem('serverPath')+"cptyMonRpt/getErmsReport037?userId="+window.sessionStorage.getItem("username")+""+postfixUrl(getAllInputTextFields2("filterBody"));

				cols = [
					/*{field: "bookEntity", value: "bookEntity", groupable: true},*/
					{field: "type", value: "type"},
					{field: "pme", value: "pme"},
					{field: "dsl", value: "dsl"},
					{field: "dvp", value: "dvp"}
				]

				groupBy = [{ field: "bookEntity", value: "Book Entity" }]  ;


			}else if(getURLParameters("type") == "expo") {
				url = window.sessionStorage.getItem('serverPath')+"cptyMonRpt/getErmsReport038?userId="+window.sessionStorage.getItem("username")+""+postfixUrl(getAllInputTextFields2("filterBody"));

				cols = [
					{field: "ccdId", width: 150},
					{field: "ccdName", width: 150},
					{field: "bizUnit", width: 150},
					{field: "bookEntity", width: 150},
					{field: "latestDate", width: 150},
					{field: "notionalHkd", width: 150},
					{field: "tdExpoHkd", width: 150},
					{field: "lmtHkd", width: 150},
					{field: "lmtExcessHkd", width: 150},
					{field: "lmtUtlzPercent", width: 150},
					{field: "remarks", width: 150}
				]

			}else if(getURLParameters("type") == "marginUtlSum"){

				url = window.sessionStorage.getItem('serverPath')+"cptyMonRpt/getErmsReport039?userId="+window.sessionStorage.getItem("username")+""+postfixUrl(getAllInputTextFields2("filterBody"));

				cols = [
					{
					    title: "Client",
					    columns: [
							{field: "ccdId", width: 150},
							{field: "ccdName", width: 150}
						]
					},
					{
					    title: "Facilities (USD)",
						columns:[
							{field: "vmLineUsd", width: 150},
							{field: "vmExpoTd", width: 150},
							{field: "imLine", width: 150},
							{field: "imExpoTd", width: 150},
							{field: "fdlUsd", width: 150}
						]    
					},
					{
					    title: "Facility Utilization",
						columns:[
							{field: "vmUtlzPercent", width: 150},
							{field: "imUtlzPercent", width: 150},
							{field: "lfmUtlzPercent", width: 150},
							{field: "fdlUtlzPercent", width: 150}
						]
					}
				]

			}else if(getURLParameters("type") == "ccptyExpo") {

				url = window.sessionStorage.getItem('serverPath')+"cptyMonRpt/getErmsReport040?userId="+window.sessionStorage.getItem("username")+""+postfixUrl(getAllInputTextFields2("filterBody"));

				cols = [
					{field: "ccdId", width: 150},
					{field: "ccdName", width: 150},
					{field: "bizUnit", width: 150},
					{field: "bookEntity", width: 150},
					{field: "masAcctId", width: 150},
					{field: "mgfAcctId", width: 150},
					{field: "cashBalMioUsd", width: 150},
					{field: "floatPnlMioUsd", width: 150},
					{field: "totEquityMioUsd", width: 150},
					{field: "fdlImReqMioUsd", width: 150},
					{field: "fdlMioUsd", width: 150},
					{field: "fdlUtlzPercent", width: 150},
					{field: "lmdExpoMioUsd", width: 150},
					{field: "lmdUtlzPercent", width: 150},
					{field: "cashCallMioUsd", width: 150},
					{field: "mgnCallAmtMioUsd", width: 150},
					{field: "mgnCallCoverByGcPercent", width: 150},
					{field: "mgnCallToClnMioUsd", width: 150},
					{field: "tminus1CalCashBalMioUsd", width: 150},
					{field: "tminus1LfmdVerification", width: 150},
					{field: "mgnCallAccumDay", width: 150},
					{field: "remarks", width: 150}
				]

			}else if(getURLParameters("type") == "placedMarginDeposit") {

				url = window.sessionStorage.getItem('serverPath')+"cptyMonRpt/getErmsReport041?userId="+window.sessionStorage.getItem("username")+""+postfixUrl(getAllInputTextFields2("filterBody"));

				cols = [
					{field: "ccdId", width: 150},
					{field: "ccdName", width: 150},
					{field: "bizUnit", width: 150},
					{field: "bookEntity", width: 150},
					{field: "cashBalHkd", width: 150},
					{field: "floatPnlHkd", width: 150},
					{field: "totEquityHkd", width: 150},
					{field: "imReqHkd", width: 150},
					{field: "dfltFundOthContrHkd", width: 150},
					{field: "tdExpoHkd", width: 150},
					{field: "lmtAmtHkd", width: 150},
					{field: "lmtExcessHkd", width: 150},
					{field: "lmtUtlzPercent", width: 150},
					{field: "remarks", width: 150}
				]
			}

	    	var dataSource = new kendo.data.DataSource({

	    		transport: {
	    			read: {
	    	   		  	type: "GET",
	    			    url: url,
	    			    dataType: "json",
	    			    
	    			    xhrFields: {
				    		withCredentials: true
				    	}
	    			}
	    		},

			error:function(e){
				if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
			},
	    	    schema: {        
	    	    	model: {
	    	    		id : "ccdId",
	    	    		fields: {
    	    				ccdId: { type: "string" },
    	    				cptyName: { type: "string" },
    	    				bizUnit: { type: "string" },
    	    				bookEntity: { type: "string" }
	    	    		}
	    	    	},                       
	                total: function(argument) {                            
	                    try{
	                    	var totalRow = argument[0].total ;
	                    	return totalRow;
	                    }catch(err){
	                    	return 0;
	                    }
	                },
	                parse: function(data){
	                	$.each(data, function(idx, elem) {
	                		var allPropertyNames = Object.keys(elem);
	                		console.log(allPropertyNames);
	                		for (var i = 0; i < allPropertyNames.length; i++) {
	                			if(new RegExp("Date").test(allPropertyNames[i])){
	                				if(elem[allPropertyNames[i]] != null){
	                					elem[allPropertyNames[i]] = toDateFormat(elem[allPropertyNames[i]]);
	                				}
	                			}
	                		};
			            });
			            return data;
	                }
            	},
            	group: groupBy,
		        serverPaging: true,
	    		pageSize: 50
		    });			

    		$("#dataGrid").kendoGrid({
    			toolbar: ["excel"],
	            excel: {
	                fileName: "Export_Report.xlsx",
	                filterable: false
	            },
    			dataSource: dataSource,
    		    filterable: false,
    		    columnMenu: false,
    		    sortable: true,
    		    serverPaging: true,
    		    scrollable: true,
    		    pageable: {
                    refresh: true,
                    pageSize: 5
                },
    		    columns: cols
    		});	
		} 
    	
    </script>

    <body>

	    <input type="hidden" id="pagetitle" name="pagetitle" value="">
	    <br>

    	<table id="listTable" border="0" width="100%" style="background-color:#DBE5F1; overflow-x:scroll; border-bottom; width: 100% " cellpadding="0" cellspacing="0">
    		<tr>
    			<td colspan="6" style="background-color:#8DB4E3; width:100%">
    			<b><div id="filterTable" onclick="expandCriteria()">(+) Filter Criteria</div></b></td>
    		</tr>
    		<tr>
    			<td><br></td>
    		</tr>
    		<tbody id="filterBody" style="display: block">
    			<tr>
    				<td id="labelCcdId">Counterparty CCD ID</td>
    				<td><input class="k-textbox" id="ccdId" name="ccdId" type="text"/></td>
    				<td>Booking Entity :</td>
    				<td rowspan="1">
    						<input id="bookEntity" name="bookEntity"  type="text">   	
    						</input>
    				</td>
    				<td>Business Unit :</td>
    				<td rowspan="1">
    					<input id="bizUnit" name="bizUnit" style="width: 300px"  type="text"></input>
    				</td>
    				<td></td>
    			</tr>
    			<tr>
	    			<td><br></td>
	    			<td></td>
	    			<td></td>
	    			<td></td>
	    			<td></td>
	    			<td></td>
	    			<td></td>
    			</tr>
    			<tr>
    				<td id="labelCcptyName">Counterparty Name :</td>
    				<td><input class="k-textbox" id="cptyName" name="cptyName" type="text"/></td>
    				<td></td>
    				<td></td>
    				<td></td>
    				<td></td>
    				<td></td>
    			</tr>
    			<tr>
    				<td></td>
    				<td></td>
    				<td></td>
    				<td></td>
    				<td></td>
    				<td colspan="2" align="right">
    				<input class="k-button" type="button" id="search" value="Search" onclick="onSearchBy(getURLParameters('type'))"></input>
    				<input class="k-button" type="button" id="Export" value="Export" onclick="toExportBy(getURLParameters('type'))"></input>
    				<input class="k-button" type="button" id="Back" value="Back" onclick="window.location.href='/ermsweb/ccptyRiskPortal'"></input>
    				</td>
    			</tr>
    			<tr><td><br></td></tr>
    			<tr>
    				<td colspan="7">
    					
    				</td>
    			</tr>
    		</tbody>
    	</table>
    	<br>		
    	<div id="dataGrid"></div>

    </body>
</html>