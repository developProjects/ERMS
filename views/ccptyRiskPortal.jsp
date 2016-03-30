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
    	
    	var ccptyRisksList = [
			{text: "CPTY Potential Market Exposure (PME) Summary Report", value: "pme"},
		    {text: "CPTY Daily Settlement Exposure (DSE) Summary Report", value: "dse"},
		    {text: "CPTY Deliver vs Payment (DVP) Exposure  Summary Report", value: "dvp"},
		    {text: "CPTY Business Budget Limit Monitoring by Business Unit", value: "buBudgetLimit"},
		    {text: "CPTY Business Budget Limit Monitoring by Entity", value: "enBudgetLimit"},
		    {text: "CPTY General Exposure Monitoring Report", value: "expo"},
		    {text: "CPTY GC UK MARGIN CALL & UTLISATION SUMMARY REPORT", value: "marginUtlSum"},
		    {text: "CPTY Counterparty Exposure Summary and Margin Call", value: "ccptyExpo"},
		    {text: "CPTY Placed Margin Deposit Limit Summary Report", value: "placedMarginDeposit"}
		];

    	$("#riskType").kendoDropDownList({
    		dataTextField: "text",
    		dataValueField: "value",
    		dataSource: ccptyRisksList
    	});

    });

	function toNext(){
		
		console.log($("#riskType").val());

		if($("#riskType").val() == "pme"){
			window.location.href = "ccptyRiskDetail?type=pme";
		}
		else if($("#riskType").val() == "dse"){
			window.location.href = "ccptyRiskDetail?type=dse";
		}
		else if($("#riskType").val() == "dvp"){
			window.location.href = "ccptyRiskDetail?type=dvp";
		}
		else if($("#riskType").val() == "buBudgetLimit"){
			window.location.href = "ccptyRiskDetail?type=buBudgetLimit";
		}
		else if($("#riskType").val() == "enBudgetLimit"){
			window.location.href = "ccptyRiskDetail?type=enBudgetLimit";
		}
		else if($("#riskType").val() == "expo"){
			window.location.href = "ccptyRiskDetail?type=expo";
		}
		else if($("#riskType").val() == "marginUtlSum"){
			window.location.href = "ccptyRiskDetail?type=marginUtlSum";
		}
		else if($("#riskType").val() == "ccptyExpo"){
			window.location.href = "ccptyRiskDetail?type=ccptyExpo";
		}
		else if($("#riskType").val() == "placedMarginDeposit"){
			window.location.href = "ccptyRiskDetail?type=placedMarginDeposit";
		}
	}

    </script>

    <body>

    <br></br>
    <br></br>

    <input type="hidden" id="pagetitle" name="pagetitle" value="Counterparty Credit Risk Monitoring Report">

    <div align="center">
		Counterparty Credit Risk Monitoring Report:
		<input id="riskType" style="width: 600px"></input>
		<input type="button" id="nextBtn" value="Next" class="k-button" onclick=" toNext()"></input>
    </div>


    </body>
</html>