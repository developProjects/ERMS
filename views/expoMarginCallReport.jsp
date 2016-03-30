
<html lang="en">
	<meta http-equiv="x-ua-compatible" content="IE=10">
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
    <script src="/ermsweb/resources/js/common_tools.js"></script>

    <!-- Kendo UI combined JavaScript -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
<script type="text/javascript">
	// used to sync the exports
	  var promises = [
		$.Deferred(),
		$.Deferred()
	  ];

	function onChangeBizDate(){

		
		var dataSource = new kendo.data.DataSource({
		  	transport: {

				read: function(options){
					$.ajax({
					    url: window.sessionStorage.getItem('serverPath')+"expoMarginCall/getReportDates?userId="+window.sessionStorage.getItem("username"),
					    type: 'GET',
					    dataType: 'json',
					    contentType: 'application/json; charset=utf-8',
					    success: function (result) {
					        if(result != null){
					        	
					        	$.each(result, function(key, value){
					        		if(value.bizDateId == $("#bizDateId").val()){
					        			console.log(value.isHist);
					        			$("#isHistHidden").val(value.isHist);
					        		}
					        	})
							}
					    },
					    error: function (objAjaxRequest, strError) {
					        var respText = objAjaxRequest.responseText;
					        console.log(respText);
					    },
					    xhrFields: {
					        withCredentials: true
					    }
					});
				}
			}
		});

		dataSource.read();
		
	}
	function postfixUrl(inputTexts){

		var query = "";


		$.each(inputTexts, function(key, value) {
			query += "&" + key + "=" + value;
		});

		/*console.log("Query ---> " + query);*/
		return query;
	}

	 function onChangeExpiryDateType(e){

	 	var dataItem = this.dataItem(e.item);

	 	if(dataItem.value == "R"){

	 		$("#labelExpiryDate").css({"display":"none"});
	 		$("#labelRectifyDate").css({"display":"block"});
	 		$("#dateTypeChange").html("<input id=\"rectifyExpiryDate\" type=\"text\" class=\"k-textbox one-required\"/>");
	 		$("#rectifyExpiryDate").kendoDatePicker({
			format: "ddMMyyyy"
		});

	 	}else{

	 		$("#labelExpiryDate").css({"display":"block"});
	 		$("#labelRectifyDate").css({"display":"none"});
	 		$("#dateTypeChange").html("<input id=\"approveExpiryDate\" type=\"text\" class=\"k-textbox one-required\"/>");
 		 	$("#approveExpiryDate").kendoDatePicker({
 				format: "ddMMyyyy"
 			});
	 	}	
	 }

	$(document).ready(function () {

		

		var data = [
		   {"text": "-", "value": ""},
		   {"text": "PB", "value": "PB"},
		   {"text": "ISD", "value": "ISD"}
		];


		$("#bizUnit").kendoDropDownList({
			dataTextField: "text",
		    dataValueField: "value",
		    dataSource: data,
		    index: 0
		});


		$("#bizDateId").kendoDropDownList({
			dataSource: new kendo.data.DataSource(),
		 	dataTextField: "text",
		  	dataValueField: "value"
		});


		var dataSource = new kendo.data.DataSource({
		  	transport: {

				read: function(options){
					$.ajax({
					    url: window.sessionStorage.getItem('serverPath')+"expoMarginCall/getReportDates?userId="+window.sessionStorage.getItem("username"),
					    type: 'GET',
					    dataType: 'json',
					    contentType: 'application/json; charset=utf-8',
					    success: function (result) {
					        if(result != null){

					        	var ddl = $("#bizDateId").data("kendoDropDownList");
					        	
					        	$.each(result, function(key, value){
					        		var tmpDataSource = ddl.dataSource.add({
					        		    "text": value.bizDateId, 
					        		    "value": value.bizDateId
					        		});
					        	})
							}
							onChangeBizDate();
					    },
					    error: function (objAjaxRequest, strError) {
					        var respText = objAjaxRequest.responseText;
					        console.log(respText);
					    },
					    xhrFields: {
					        withCredentials: true
					    }
					});
				}
			}
		});

		dataSource.read();


		$("#creditGroup").kendoDropDownList({
			dataSource: new kendo.data.DataSource(),
	 		dataTextField: "text",
	 	 	dataValueField: "value"
		});

		dataSource = new kendo.data.DataSource({
		  	transport: {
			    
				read: function(options){
					$.ajax({
					    url: window.sessionStorage.getItem('serverPath')+"expoMarginCall/getCreditGroups?userId="+window.sessionStorage.getItem("username"),
					    type: 'GET',
					    dataType: 'json',
					    contentType: 'application/json; charset=utf-8',
					    success: function (result) {

					        if(result != null){

					        	var ddl = $("#creditGroup").data("kendoDropDownList");
					        	var tmpDataSource = ddl.dataSource.add({
					        		    "text": "-", 
					        		    "value": ""
					        		}
					        	);
					        	
					        	$.each(result, function(key, value){
					        		$.each(value, function(key, value){
						        		tmpDataSource = ddl.dataSource.add({
						        		    "text": value, 
						        		    "value": value}
						        		);
					        		});
					        	})

					        	var dropdownlist = $("#creditGroup").data("kendoDropDownList");
					        	dropdownlist.search(getURLParameters("creditGroup"));
							}
					    },
					    error: function (objAjaxRequest, strError) {
					        var respText = objAjaxRequest.responseText;
					        console.log(respText);
					    },
					    xhrFields: {
					        withCredentials: true
					    }
					});
				}
			}
		});

		dataSource.read();
		

		data = [
			{"text":"-", "value":""},
			{"text":"ALL", "value":"ALL"},
			{"text":"Main", "value":"Main"},
			{"text":"Cash", "value":"Cash"},
			{"text":"Margin", "value":"Margin"},
			{"text":"DVP", "value":"DVP"}
		];

		$("#acctType").kendoDropDownList({
			dataTextField: "text",
		    dataValueField: "value",
		    dataSource: data,
		    index: 0
		});

		$("#lmtTypeDesc").kendoDropDownList({
			dataTextField: "text",
		    dataValueField: "value",
		    dataSource: new kendo.data.DataSource(),
		    index: 0
		});

		dataSource = new kendo.data.DataSource({
		  	transport: {
			    read: function(options){
			    	$.ajax({
			    	    url: window.sessionStorage.getItem('serverPath')+"limitTypeHier/getLmtTypeCodeDescMap?userId="+window.sessionStorage.getItem("username"),
			    	    type: 'GET',
			    	    dataType: 'json',
			    	    contentType: 'application/json; charset=utf-8',
			    	    success: function (result) {
			    	        /*console.log(result);*/
			    	        if(result != null){
			    	        	var paramString = "";
			    	        	var allPropertyNames = Object.keys(result);
			    	        	var ddl = $("#lmtTypeDesc").data("kendoDropDownList");
			    	        	var tmpDataSource = ddl.dataSource.add({
			    	        		    "text": "-", 
			    	        		    "value": ""
			    	        		}
			    	        	);
			    	        	for (var i = 0; i < allPropertyNames.length; i++) {
			    	        		var name = allPropertyNames[i];
			    	        		
			    	        		 tmpDataSource = ddl.dataSource.add({
			    	        		    "text": result[name], 
			    	        		    "value": result[name]}
			    	        		);
			    	        	};
			    	        }
			    	    },
			    	    error: function (objAjaxRequest, strError) {
			    	        var respText = objAjaxRequest.responseText;
			    	        console.log(respText);
			    	    },
			    	    xhrFields: {
			    	        withCredentials: true
			    	    }
			    	});
			    }
			}
		});
		
		dataSource.read();


		data = [
			{"text": "-", "value": ""},
			{"text": "Triggered", "value": "Triggered"},
			{"text": "Rectified", "value": "Rectified"},
			{"text": "Approved", "value": "Approved"},
			{"text": "Rejected", "value": "Rejected"},
			{"text": "Pending for Approval", "value": "Pending for Approval"},
			{"text": "Pending for Liquidation", "value": "Pending for Liquidation"}
		]

		$("#status").kendoDropDownList({
			dataTextField: "text",
		    dataValueField: "value",
		    dataSource: data,
		    index: 0
		});

		data = [
			{"text": "-", "value": ""},
			{"text": ">", "value": ">"},
			{"text": ">=", "value": ">="},
			{"text": "=", "value": "="},
			{"text": "<=", "value": "<="},
			{"text": "<", "value": "<"},
		];

		/*$("#daysCashOverdueFilter").kendoDropDownList();*/
		$("#daysInOdMarginCallOpr").kendoDropDownList({
			dataTextField: "text",
		    dataValueField: "value",
		    dataSource: data,
		    index: 0
		});

		$("#daysInLmtDeficitOpr").kendoDropDownList({
			dataTextField: "text",
		    dataValueField: "value",
		    dataSource: data,
		    index: 0
		});


		data = [
		   {"text": "RECTIFY", "value": "R"},
		   {"text": "SEEK_APPROVAL", "value": "S"}
		];

		$("#expiryDateType").kendoDropDownList({
			dataTextField: "text",
		    dataValueField: "value",
		    dataSource: data,
		    index: 0,
		    change: onChangeExpiryDateType
		});

		$("#dateTypeChange").html("<input id=\"rectifyExpiryDate\" type=\"text\" class=\"k-textbox one-required\"/>");

		$("#approveExpiryDate").kendoDatePicker({
			format: "ddMMyyyy"
		});
		$("#approveExpiryDate").attr("readonly", "readonly");

		$("#rectifyExpiryDate").kendoDatePicker({
			format: "ddMMyyyy"
		});
		$("#rectifyExpiryDate").attr("readonly", "readonly");
	
		$("#dispOpt").kendoDropDownList();
		$("#clinetGroup").kendoDropDownList();
		$("#accType").kendoDropDownList({
			dataSource: ["Main", "Cash", "Margin", "DVP", "ALL"],
			value: "ALL",
			index:0
		});
		$("#lmtType").kendoDropDownList();
		$("#status").kendoDropDownList({
			dataSource: ["Triggered", "Rectified", "Approved", "Rejected", "Pending for Approval", "Pending for Liquidation"],
			index:0
		});
		
		var daysCOoperators = [
			{ text: "=", value: "EQ" },
			{ text: ">=", value: "GEQ" },
			{ text: "<=", value: "LEQ" },
			{ text: ">", value: "GTR" },
			{ text: "<", value: "LSS" },
		];
		$("#daysCashOverdueFilter").kendoDropDownList({
			dataTextField: "text",
			dataValueField: "value",
			dataSource: daysCOoperators,
			index: 0
		});
		
		var daysMCoperators = [
			{ text: "=", value: "EQ" },
			{ text: ">=", value: "GEQ" },
			{ text: "<=", value: "LEQ" },
			{ text: ">", value: "GTR" },
			{ text: "<", value: "LSS" },
		];
		$("#daysMarginCallFilter").kendoDropDownList({
			dataTextField: "text",
			dataValueField: "value",
			dataSource: daysMCoperators,
			index: 0
		});
		
		var daysLDoperators = [
			{ text: "=", value: "EQ" },
			{ text: ">=", value: "GEQ" },
			{ text: "<=", value: "LEQ" },
			{ text: ">", value: "GTR" },
			{ text: "<", value: "LSS" },
		];
		$("#daysLimitDeficitFilter").kendoDropDownList({
			dataTextField: "text",
			dataValueField: "value",
			dataSource: daysLDoperators,
			index: 0
		});
		$("#expDateType").kendoDropDownList();


		

		//Search button click
		$("#submitBtn").kendoButton({
			click: function(){			
				var input = $("input:text, select");
				var valid=0;
				
				for(var i=0;i<input.length;i++){
					if($.trim($(input[i]).val()).length > 0){
						//console.log("Input Value: "+$(input[i]).val());
						valid = valid + 1;
					}
				}

				
				if(valid > 0){
					dataGrids();					
				}else{
					alert("Please select atleast one field");
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
							if(attrId == "prodType"){
								var productDDL = $("#prodType").data("kendoDropDownList");								
								productDDL.dataSource.data([{}]); // clears dataSource
								productDDL.text(""); // clears visible text
								productDDL.value("");
								productDDL.enable(false);								
							}else{
								$("#</div>"+attrId).data("kendoDropDownList").value("ALL");
							}
						}if(numClass){
							$("#</div>"+attrId).data("kendoNumericTextBox").value("");
						}else{
							$(this).val("");
						}
					}
				});					
			}
		});
		
		$(".exp-col-bar").click(function(){
			var barId = $(this).attr("id")+"-body";
			var exp_col = $(this).find("span").html();
			(exp_col != "-") ? $(this).find("span").html("-") : $(this).find("span").html("+") 
			$("#"+barId).toggle();
		});

		/* subAcctId=2000&acctId=1234&creditGroup=GRP01&ccdId=CC1234 */


		$("#acctName").val(getURLParameters("ccdId"));
		$("#acctId").val(getURLParameters("acctId"));
		$("#subAcctId").val(getURLParameters("subAcctId"));

		dataGrids();
	});
	
	/* Handle underfined / null element */
	function checkUndefinedElement(element){			
		if(element === null || element === "undefined"){
			return "";
		}else{
			return element;
		}
	}

	//Displaying Data in the Grids

	function dataGrids(){				

		var searchCriteria = {};		
		console.log(postfixUrl(getAllInputTextFields2("filter-criteria")));
		var getActiveListDetailsURL = window.sessionStorage.getItem('serverPath')+"expoMarginCall/getReportList?userId="+window.sessionStorage.getItem("username")+""+postfixUrl(getAllInputTextFields2("filter-criteria"));
			
		var activeDataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: getActiveListDetailsURL,
					dataType: "json",
					complete: function (){
						/*emptyHeight('active-list');					*/
					},
    			    xhrFields: {
			    		withCredentials: true
			    	},
					data:searchCriteria

				}
			},
			schema: {
				model: {
					fields: {
						negativeBalHkd: { type: "number" },						
						im: { type: "number" },
						mm: { type: "number" },
						mtmLoss: { type: "number" },
						mtmGain: { type: "number" },						
						approvedLmtAmt: { type: "number" },
						sdConsLmtUtlz: { type: "number" },
						lmtSurplusDeficit: { type: "number" },
						tdConsLmtUtlz: { type: "number" },						
						tdLmtSurplusDeficit: { type: "number" },
						availCollValue: { type: "number" },
						cuConsExposure: { type: "number" },
						cuMarginSurplusOrCallAmt: { type: "number" },
						tdAvailCollValue: { type: "number" },
						tdConsExposure: { type: "number" },						
						tdMarginSurplusOrCallAmt: { type: "number" },
						cashOverdueAmt: { type: "number" },
						hhi: { type: "number" },
						tdMrktValueUnderFac: { type: "number" }
					}
				}                
			},
			serverPaging: true ,
			pageSize: 5,
			group: {
				field: "creditGroup", aggregates: [
					{ field: "negativeBalHkd", aggregate: "sum"},						
					{ field: "im", aggregate: "sum"},
					{ field: "mm", aggregate: "sum"},
					{ field: "mtmLoss", aggregate: "sum"},
					{ field: "mtmGain", aggregate: "sum"},					
					{ field: "approvedLmtAmt", aggregate: "sum"},
					{ field: "sdConsLmtUtlz", aggregate: "sum"},
					{ field: "lmtSurplusDeficit", aggregate: "sum"},
					{ field: "tdConsLmtUtlz", aggregate: "sum"},						
					{ field: "tdLmtSurplusDeficit", aggregate: "sum"},
					{ field: "availCollValue", aggregate: "sum"},
					{ field: "cuConsExposure", aggregate: "sum"},
					{ field: "cuMarginSurplusOrCallAmt", aggregate: "sum"},
					{ field: "tdAvailCollValue", aggregate: "sum"},
					{ field: "tdConsExposure", aggregate: "sum"},						
					{ field: "tdMarginSurplusOrCallAmt", aggregate: "sum"},
					{ field: "cashOverdueAmt", aggregate: "sum"},
					{ field: "hhi", aggregate: "sum"},
					{ field: "tdMrktValueUnderFac", aggregate: "sum"}
				]
			},
			aggregate: [ 
				{ field: "negativeBalHkd", aggregate: "sum"},						
				{ field: "im", aggregate: "sum"},
				{ field: "mm", aggregate: "sum"},
				{ field: "mtmLoss", aggregate: "sum"},
				{ field: "mtmGain", aggregate: "sum"},						
				{ field: "approvedLmtAmt", aggregate: "sum"},
				{ field: "sdConsLmtUtlz", aggregate: "sum"},
				{ field: "lmtSurplusDeficit", aggregate: "sum"},
				{ field: "tdConsLmtUtlz", aggregate: "sum"},						
				{ field: "tdLmtSurplusDeficit", aggregate: "sum"},
				{ field: "availCollValue", aggregate: "sum"},
				{ field: "cuConsExposure", aggregate: "sum"},
				{ field: "cuMarginSurplusOrCallAmt", aggregate: "sum"},
				{ field: "tdAvailCollValue", aggregate: "sum"},
				{ field: "tdConsExposure", aggregate: "sum"},						
				{ field: "tdMarginSurplusOrCallAmt", aggregate: "sum"},
				{ field: "cashOverdueAmt", aggregate: "sum"},
				{ field: "hhi", aggregate: "sum"},
				{ field: "tdMrktValueUnderFac", aggregate: "sum"}
			]


		});


		var oldAcctId, detailWindow;

		$("#active-list").kendoGrid({

			excel: {
				 allPages: true
			},
			dataSource: activeDataSource,
			sortable:false,
			scrollable:false,
			pageable: true,	
			selectable: "multiple",
			excelExport: function(e) {
				e.preventDefault();
				promises[0].resolve(e.workbook);
			},
			change:function(e){

				onChangeBizDate();
				var grid = $("#active-list").data("kendoGrid");
				var selectedRow = grid.select();
				
				var selectedRowObject = grid.dataItem(selectedRow[0]);
				if(selectedRowObject != null){

					var sessionUserId = window.sessionStorage.getItem("username");
					var width = 800;
					var height = 900;

					console.log(selectedRowObject.acctId);

					detailWindow = window.open("/ermsweb/expoMarginCallEORectification?creditGroup="+selectedRowObject.creditGroup+"&ccdId="+selectedRowObject.ccdId+"&acctId="+selectedRowObject.acctId+"&subAcctId="+selectedRowObject.subAcctId+"&isHist="+$("#isHistHidden").val()+"&userId="+sessionUserId+"&bizDateId="+$("#bizDateId").val(),"_blank","width="+width+", height="+height+",scrollbars=yes",false); 	

				}
			},
			columns:[
				{					
					columns: [
						{ field: "creditGroup",  width: 120},
						{ field: "cpGroupId",  width: 120}						
					]
				},
				{				
					columns: [
						{ field: "acctId", width: 120},
						{ field: "subAcctId", width: 120},
						{ field: "acctName", width: 120},
						{ field: "acctSalesmanCode", width: 120},
						{ field: "acctSalesmanName", width: 120},
						{ field: "relatedAcctId", width: 120, groupFooterTemplate: "<div class='rightAlign'>Total: </div>", footerTemplate: "<div class='rightAlign'>Grand Total : </div>"},
						{ field: "negativeBalHkd", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=kendo.toString(sum, 'c2')#</div>", footerTemplate: "<div class='rightAlign'>$#=sum.toFixed(2)#</div>", width: 120, attributes: {"class": "rightAlign"}
						}
					]
				},
				{ field: "lmtTypeDesc",  width: 120},					
				{ field: "facId",  width: 120},
				{ field: "im", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
				{ field: "mm", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
				{ field: "mtmLoss", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
				{ field: "mtmGain", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
				{ field: "eqtyImPercent",  width: 120},
				{ field: "approvedLmtAmt", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},								
				{
					columns: [
						{ field: "sdConsLmtUtlz", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},					
						{ field: "lmtSurplusDeficit", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
						{ field: "lmtUtlzPercent",  width: 120},
						{ field: "tdConsLmtUtlz", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
						{ field: "tdLmtSurplusDeficit", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
						{ field: "tdLmtUtlzPercent",  width: 120},
						{ field: "daysInLmtDeficit",  width: 120}
					]
				},				
				{ field: "availCollValue", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},				
				{ field: "cuConsExposure", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},					
				{ field: "cuMarginSurplusOrCallAmt", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
				{ field: "cuMarginPercent",  width: 120},
				{ field: "tdAvailCollValue", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
				{ field: "tdConsExposure", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
				{ field: "tdMarginSurplusOrCallAmt", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
				{ field: "tdMarginPercent",  width: 120},
				{ field: "tdDaysInOdMarginCall",  width: 120},				
				{ field: "cashOverdueAmt", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},					
				{ field: "hhi", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
				{ field: "tdMrktValueUnderFac", aggregates: ["sum"], groupFooterTemplate: "<div class='rightAlign'>#=sum#</div>", footerTemplate: "<div class='rightAlign'>#=sum#</div>", width: 120, attributes: {"class": "rightAlign"}},
				{ field: "mrktValueCoveragePercent",  width: 120},
				{ field: "lmtExpiryDt", width: 120, template: '#= validDate(lmtExpiryDt) #'}
			]
		});
	}
	
	function validDate(obj){
    	return (!obj) ? "" : kendo.toString( new Date(parseInt(obj)), "dd-MM-yyyy HH:MM:tt" );
    }
	
	function openModal() {
	     $("#modal, #modal1").show();
	}

	function closeModal() {
	    $("#modal, #modal1").hide();	    
	}
	
    </script>
	<style>
		.k-grid-header .k-header.alignCenter{text-align:center;}
		.k-textbox{width:150px;}
		.filter-operators .k-textbox{width:100px;}
		.select-textbox{width:150px;}
		.filter-operators .select-textbox{width:70px;}
		
		.rightAlign{text-align:right;}		
		.k-grouping-row, .k-group-cell{display:none;}
		.k-group-footer td{background-color:#84e5de;}
		.k-footer-template td{background-color:#cbf0b7;}
	</style>
	<body>
	<div class="page-title">PB ISD Margin Call report</div>
	<input type="hidden" id="isHistHidden"></input>
	<div class="boci-wrapper">
		<div id="boci-content-wrapper">	
			<div class="filter-criteria" id="filter-criteria">
				<div class="exp-col-bar expo-search-list-header" id="displayBar" style="background-color:#B5A2C6">(<span>-</span>) <b>Display Option</b></div>

				<table class="list-table" id="displayBar-body" style="background-color:#E7E3EF; width: 100%">					
					<tbody style="display: block; width: 100%" >
						<tr>
							<td>Business Unit</td><!--  -->
							<td><input id="bizUnit" type="text" class="select-textbox one-required"/></td>
						</tr>						
						<tr>
							<td>Display Option - Report Position Date</td> <!--  -->
							<td><input id="bizDateId" onChange="onChangeBizDate()" type="text" class="select-textbox one-required"/></td>
						</tr>						
					</tbody>
				</table>
				
				<div class="exp-col-bar expo-search-list-header" id="searchBar">(<span>-</span>) <b>Search Criteria</b></div>
				<table class="list-table" id="searchBar-body" style="width: 100%">					
					<tbody style="display: block; background-color:#DBE5F1; ">
						<tr>
							<td>Client Group</td> <!--  -->
							<td><input id="creditGroup" type="text" class="select-textbox one-required"/></td>						
							<td>Client</td> <!--  -->
							<td colspan="3"><input id="acctName" type="text" class="k-textbox one-required"/></td>						
						</tr>
						<tr>
							<td>Account Type</td>
							<td><input id="acctType" type="text" class="select-textbox one-required"/></td>						
							<td>Account</td>
							<td><input id="acctId" type="text" class="k-textbox one-required"/></td>						
							<td>Sub Account</td>
							<td><input id="subAcctId" type="text" class="k-textbox one-required"/></td>
						</tr>
						<tr>
							<td>Limit Type</td>
							<td><input id="lmtTypeDesc" type="text" class="select-textbox one-required"/></td>						
							<td>Status</td>
							<td colspan="3"><input id="status" type="text" style="width: 170px" class="select-textbox one-required"/></td>						
						</tr>
						<tr class="filter-operators"> <!--  -->
							<td></td>
							<td>
							</td>						
							<td>Days in Cash Overdue / Margin Call</td>
							<td>
								<input id="daysInOdMarginCallOpr" type="text" class="select-textbox one-required"/>
								<input id="daysInOdMarginCall" type="text" class="k-textbox one-required"/>
							</td>
							<td>Days in Limit Deficit Filter operator</td>
							<td>
								<input id="daysInLmtDeficitOpr" type="text" class="select-textbox one-required"/>
								<input id="daysInLmtDeficit" type="text" class="k-textbox one-required"/>
							</td>							
						</tr>
						<tr>
							<td>Expiry Date type</td>
							<td><input id="expiryDateType" type="text" class="select-textbox one-required"/></td>

							<!--  -->						

							<td>
								<label id="labelExpiryDate">Expiry Date</label>
								<label id="labelRectifyDate">Rectify Date</label>
							</td>
							<td colspan="3">

							<!-- <input id="approveExpiryDate" type="text" class="k-textbox one-required"/>
							<input id="rectifyExpiryDate" type="text" class="k-textbox one-required"/> -->
							
							<div id="dateTypeChange">
								
							</div>
							</td>						
						</tr>
						<tr>
							<td colspan="6" align="right">
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
								
							</td>
						</tr>
						<tr>
							<td>
								<div id="active-list">
											
								</div>
								
								<div id="modal">
									<!-- <img id="loader" src="images/ajax-loader.gif" /> -->
								</div>						
							</td>
						</tr>					
					</table>
				</div>				
				<div class="clear"></div>
			</div>									
		</div>
	</div>
	<div id="window"></div>
</body>
</html>	