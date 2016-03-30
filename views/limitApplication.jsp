<!DOCTYPE html>
<html lang="en">
	<link rel="shortcut icon" href="/ermsweb/resources/images/boci.ico" />
	<meta http-equiv="x-ua-compatible" content="IE=10">
	<meta http-equiv='cache-control' content='no-cache'>
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10">
	<meta http-equiv="Content-Style-Type" content="text/css">
    <meta http-equiv="Content-Script-Type" content="text/javascript">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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

    <body>
    	
    	<script type="text/javascript">

    	function postfixUrl(checkboxes, selectOpts, inputTexts, hiddens){

    		var query = "";

    		$.each(checkboxes, function(key, value) {
    			query += "&" + key + "=" + value;
    		});

    		$.each(selectOpts, function(key, value) {
    			query += "&" + key + "=" + value;
    		});

    		$.each(inputTexts, function(key, value) {
    			query += "&" + key + "=" + value;
    		});

    		$.each(hiddens, function(key, value) {
    			query += "&" + key + "=" + value;
    		});

    		console.log("Query ---> " + query);
    		return query;

    	}

    	function initializeLmtType(){

    		var dataSource = new kendo.data.DataSource({
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

    			    	        	fillInToDropDown("lmtTypeDesc", "", "-");

    			    	        	for (var i = 0; i < allPropertyNames.length; i++) {
    			    	        		
    			    	        		var name = allPropertyNames[i];
    			    	        		
    			    	        	 	fillInToDropDown("lmtTypeDesc", result[name], result[name]);
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

    	}

	    	$(document).ready(function () {


	    			$("#searchWindow").kendoWindow({
	    			    width: "800px",
	    			    height: "650px",
	    			    modal: true,
	    			    title: "Search RMD Group",
	    			    visible: false
	    			});
	    			
	    			$("#searchWindow2").kendoWindow({
	    			    width: "800px",
	    			    height: "650px",
	    			    modal: true,
	    			    title: "Search Client / Counter Party",
	    			    visible: false
	    			});
	    			
	    			$("#searchWindow3").kendoWindow({
	    			    width: "800px",
	    			    height: "650px",
	    			    modal: true,
	    			    title: "Search Account",
	    			    visible: false
	    			});

	    			$("#remarkWindow").kendoWindow({
	    			    width: "1200px",
	    			    height: "650px",
	    			    modal: true,
	    			    title: "Limit Application Remarks",
	    			    visible: false
	    			});

	    			$("#remarkWindow2").kendoWindow({
	    			    width: "99.8%",
	    			    height: "100%",
	    			    modal: true,
	    			    title: "Limit Application Remarks",
	    			    visible: false,
	    			    actions: [
	    			    	"Pin",
                            "Minimize",
                            "Maximize",
                            "Close"
                        ]
	    			});

	    			$("#remarkWindow3").kendoWindow({
	    			    width: "1200px",
	    			    height: "650px",
	    			    modal: true,
	    			    title: "Limit Application Remarks",
	    			    visible: false,
	    			    actions: [
	    			    	"Pin",
                            "Minimize",
                            "Maximize",
                            "Close"
                        ]
	    			});

					$("#historyWindow").kendoWindow({
	    			    width: "1200px",
	    			    height: "650px",
	    			    modal: true,
	    			    title: "History",
	    			    visible: false,
	    			    actions: [
	    			    	"Pin",
                            "Minimize",
                            "Maximize",
                            "Close"
                        ]
	    			});

		        	$("#submitBtn").kendoButton({
		        		click: function(e) {
		        			onClickSubmit();
						}
			       	});
	        	}
	        );

			function onClickSubmit(){
				$("#listTable2").css({"display":"block"});

		        			var dataSource = new kendo.data.DataSource({
		        			    transport: {
		        			        read: {
		        			            type: "GET",
		        			            async: false,
		        			            url: window.sessionStorage.getItem('serverPath')+"limitapplication/getEnquiryAndPendingDetails?enquiryView=Y&summaryView=Y&userId="+window.sessionStorage.getItem("username")+"&isBatchUpload=ALL"+postfixUrl(getCheckedCheckbox("searchContainer"), getSelectOptionFields("searchContainer"), getAllInputTextFields("searchContainer"), getAllHiddenFields("searchContainer")),   
		        			            cache: false,
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
			    	                },
			    	                model:{
			    	                	id: "crId",
			    	                	fields:{
			    	                		crId: {type: "string"}
			    	                	}
			    	                }
			                	},
			                	serverPaging: true,
		        			    pageSize: 10
		        			}); 

							var dataSource2 = new kendo.data.DataSource({
		        			    transport: {
		        			        read: {
		        			            type: "GET",
		        			            async: false,
		        			            url: window.sessionStorage.getItem('serverPath')+"limitapplication/getEnquiryAndPendingDetails?enquiryView=Y&summaryView=Y&userId="+window.sessionStorage.getItem("username")+"&isBatchUpload=ALL"+postfixUrl(getCheckedCheckbox("searchContainer"), getSelectOptionFields("searchContainer"), getAllInputTextFields("searchContainer"), getAllHiddenFields("searchContainer")), 
		        			            cache: false,
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
		        			    pageSize: 10
		        			}); 

		        			$("#enquiryResultsGrid").kendoGrid({

		        				dataSource: dataSource,
		        				filterable: false,
		        				columnMenu: false,
		        				sortable: true,
		        				scrollable: true,
					     	 	pageable: {
				                    refresh: true,
				                    pageSize: 10
				                },
		        				columns: [  
		        				    /* Group by */
		        				    {
		        				        title: "Business Unit",
		        				        width: 200,
		        				        columns: [
		        				            { 
		        				                field: "bizUnitDesc",
		        				                title: "Business Unit Desc" ,
		        				                width: 200
		        				            },
		        				            {  
		        				                field: "bizUnitCode",
		        				                title: "Business Unit Code" ,
		        				                width: 200
		        				            }
	        				            ]
		        				    },
		        				    /* Group by */
		        				    { 
		        				        field: "groupName",
		        				        title: "Group Name" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "ccdName",
		        				        title: "Client Counterparty Namer" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "accName",
		        				        title: "Account Name" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "acctId",
		        				        title: "Account No" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "subAcctId",
		        				        title: "Sub Account No" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "cmdAcctStatus",
		        				        title: "Account Status" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "acctOpenDate",
		        				        title: "Account Open Date (yyyy/mm/dd)" ,
		        				        width: 200,
		        				        template: "#=toDateFormatReverse(acctOpenDate)#"
		        				    },
		        				    { 
		        				        field: "salesmanCode",
		        				        title: "Sales Code" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "salesmanName",
		        				        title: "Sales Name" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "facId",
		        				        title: "Facility ID" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "lmtTypeDesc",
		        				        title: "Limit Type" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "ccfRatio",
		        				        title: "CCF (%)" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "existLmtExpiryDate",
		        				        title: "Existing Expiry Date (yyyy/mm/dd)" ,
		        				        width: 200,
		        				        template: "#=toDateFormatReverse(existLmtExpiryDate)#"
		        				    },
		        				    /* Group by */
		        				    {
		        				        title: "Existing Facility Limit",
		        				        width: 200,
		        				        columns: [
		        				            { 
		        				                field: "existLmtCcy",
		        				                title: "Currency" ,
		        				                width: 200
		        				            },
		        				            { 
		        				                field: "existLmtAmt",
		        				                title: "Amount" ,
		        				                width: 200
		        				            }
	        				            ]
		        				    },
		        				    /* Group by */
		        				    { 
		        				        field: "existCcfLmtAmtHkd",
		        				        title: "Existing Limit Amount x CCF (HKD)" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "newLmtExpiryDate",
		        				        title: "New Expiry Date (yyyy/mm/dd)" ,
		        				        width: 200,
		        				        template: "#=toDateFormatReverse(newLmtExpiryDate)#"
		        				    },
    	        				    {
    	        				        title: "New Facility Limit",
    	        				        width: 200,
    	        				        columns: [
    	        				            { 
    	        				                field: "newLmtCcy",
    	        				               	title: "Currency" ,
    	        				                width: 200
    	        				            },
    	        				            { 
    	        				                field: "newLmtAmt",
    	        				                title: "Amount" ,
    	        				                width: 200
    	        				            }
            				            ]
    	        				    },
		        				    { 
		        				        field: "newCcfLmtAmtHkd",
		        				        title: "New Limit Amount x CCF (HKD)" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "coLmtExpiryDate",
		        				        title: "Counter Offer New Expiry Date (yyyy/mm/dd)" ,
		        				        width: 200,
		        				        template: "#=toDateFormatReverse(coLmtExpiryDate)#"
		        				    },
		        				    {
    	        				        title: "Counter Offer : New Facility Limit",
    	        				        width: 200,
    	        				        columns: [
    	        				            { 
    	        				                field: "coLmtCcy",
    	        				                title: "Currency" ,
    	        				                width: 200
    	        				            },
    	        				            { 
    	        				                field: "coLmtAmt",
    	        				                title: "Amount" ,
    	        				                width: 200
    	        				            }
            				            ]
    	        				    },
		        				    { 
		        				        field: "coCcfLmtAmtHkd",
		        				        title: "Counter Offer : New Facility Amount x CCF (HKD)" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "",
		        				        title: "Requested By" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "",
		        				        title: "Request Date (yyyy/mm/dd)" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "lastUpdateBy",
		        				        title: "Updated By" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "lastUpdateDt",
		        				        title: "Updated Date (yyyy/mm/dd hh:mi)" ,
		        				        width: 200,
		        				        template: "#=toDateFormatReverse(lastUpdateDt)#"
		        				    },
		        				    { 
		        				        field: "status",
		        				        title: "Limit Status" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "processedBy",
		        				        title: "To be Processed By" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "isAnnualLmtReview",
		        				        title: "Annual Limit Review" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "isBatchUpload",
		        				        title: "Batch Upload" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "batchId",
		        				        title: "Batch ID" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "action",
		        				        title: "Action" ,
		        				        width: 200,
		        				        template: "#=replacedByIconOfDetails(isRoot, groupId, ccdId, acctId, subAcctId, approvalMatrixBu, approvalMatrixOption, crId, 'detail', action)#"
		        				    }
		        				]
		        			});

		        			$("#pendingRequestGrid").kendoGrid({

		        				dataSource: dataSource2,
		        				filterable: false,
		        				columnMenu: false,
		        				sortable: true,
		        				scrollable: true,
					     	 	pageable: {
				                    refresh: true,
				                    pageSize: 10
				                },
		        				columns: [  
		        					{ 
		        					    field: "", 
		        					    width: 200,
		        					    template: "#=createCheckBoxes(isRoot, batchId)#"
		        					},
		        				    { 
		        				        field: "", 
		        				        title: "View History" ,
		        				        width: 200,
		        				        template: "#=viewHistory(isRoot, groupId, ccdId, approvalMatrixBu, approvalMatrixOption)#"
		        				    },
		        				    /* Group by */
		        				    {
		        				        title: "Business Unit",
		        				        width: 200,
		        				        columns: [
		        				            { 
		        				                field: "bizUnitDesc",
		        				                title: "Business Unit Desc" ,
		        				                width: 200
		        				            },
		        				            { 
		        				                field: "bizUnitCode",
		        				                title: "Business Unit Code" ,
		        				                width: 200
		        				            }
	        				            ]
		        				    },
		        				    /* Group by */
		        				    { 
		        				        field: "groupName",
		        				        title: "Group Name" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "ccdName",
		        				        title: "Client Counterparty Namer" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "accName",
		        				        title: "Account Name" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "acctId",
		        				        title: "Account No" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "subAcctId",
		        				        title: "Sub Account No" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "cmdAcctStatus",
		        				        title: "Account Status" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "acctOpenDate",
		        				        title: "Account Open Date (yyyy/mm/dd)" ,
		        				        width: 200,
		        				        template: "#=toDateFormatReverse(acctOpenDate)#"
		        				    },
		        				    { 
		        				        field: "salesmanCode",
		        				        title: "Sales Code" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "salesmanName",
		        				        title: "Sales Name" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "facId",
		        				        title: "Facility ID" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "lmtTypeDesc",
		        				        title: "Limit Type" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "ccfRatio",
		        				        title: "CCF (%)" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "existLmtExpiryDate",
		        				        title: "Existing Expiry Date (yyyy/mm/dd)" ,
		        				        width: 200,
		        				        template: "#=toDateFormatReverse(existLmtExpiryDate)#"
		        				    },
		        				    /* Group by */
		        				    {
		        				        title: "Existing Facility Limit",
		        				        width: 200,
		        				        columns: [
		        				            { 
		        				                field: "existLmtCcy",
		        				                title: "Currency" ,
		        				                width: 200
		        				            },
		        				            { 
		        				                field: "existLmtAmt",
		        				                title: "Amount" ,
		        				                width: 200
		        				            }
	        				            ]
		        				    },
		        				    /* Group by */
		        				    { 
		        				        field: "existCcfLmtAmtHkd",
		        				        title: "Existing Limit Amount x CCF (HKD)" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "newLmtExpiryDate",
		        				        title: "New Expiry Date (yyyy/mm/dd)" ,
		        				        width: 200,
		        				        template: "#=toDateFormatReverse(newLmtExpiryDate)#"
		        				    },
    	        				    {
    	        				        title: "New Facility Limit",
    	        				        width: 200,
    	        				        columns: [
    	        				            { 
    	        				                field: "newLmtCcy",
    	        				                title: "Currency" ,
    	        				                width: 200
    	        				            },
    	        				            { 
    	        				                field: "newLmtAmt",
    	        				                title: "Amount" ,
    	        				                width: 200
    	        				            }
            				            ]
    	        				    },
		        				    { 
		        				        field: "newCcfLmtAmtHkd",
		        				        title: "New Limit Amount x CCF (HKD)" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "coLmtExpiryDate",
		        				        title: "Counter Offer New Expiry Date (yyyy/mm/dd)" ,
		        				        width: 200,
		        				        template: "#=toDateFormatReverse(coLmtExpiryDate)#"
		        				    },
		        				    {
    	        				        title: "Counter Offer : New Facility Limit",
    	        				        width: 200,
    	        				        columns: [
    	        				            { 
    	        				                field: "coLmtCcy",
    	        				                title: "Currency" ,
    	        				                width: 200
    	        				            },
    	        				            { 
    	        				                field: "coLmtAmt",
    	        				                title: "Amount" ,
    	        				                width: 200
    	        				            }
            				            ]
    	        				    },
		        				    { 
		        				        field: "coCcfLmtAmtHkd",
		        				        title: "Counter Offer : New Facility Amount x CCF (HKD)" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "lastUpdateBy",
		        				        title: "Updated By" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "lastUpdateDt",
		        				        title: "Updated Date (yyyy/mm/dd hh:mi)" ,
		        				        width: 200,
		        				        template: "#=toDateFormatReverse(lastUpdateDt)#"
		        				    },
		        				    { 
		        				        field: "status",
		        				        title: "Limit Status" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "processedBy",
		        				        title: "To be Processed By" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "isAnnualLmtReview",
		        				        title: "Annual Limit Review" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "isBatchUpload",
		        				        title: "Batch Upload" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "batchId",
		        				        title: "Batch ID" ,
		        				        width: 200
		        				    },
		        				    { 
		        				        field: "action",
		        				        title: "Action" ,
		        				        width: 200,
		        				        template: "#=replacedByIconOfDetails(isRoot, groupId, ccdId, acctId, subAcctId, approvalMatrixBu, approvalMatrixOption, crId, 'cr', action)#"
		        				    }		
		        				]
		        			});
							$('html,body').animate({scrollTop: $("#gridContent").offset().top}, 'slow'); 
			}

			function replacedByIconOfDetails(isRoot, groupId, ccdId, acctId, subAcctId, approvalMatrixBu, approvalMatrixOption, crId, type, action){
				if(isRoot == "Y"){
					if(type == "detail"){
						return "<a target=\"_self\" href=\"/ermsweb/limitApplicationDetail?userId="+window.sessionStorage.getItem("username")+"&rmdGroupId="+groupId+"&approvalMatrixBu="+approvalMatrixBu+"&approvalMatrixOption="+approvalMatrixOption+"&action=V&ccdId="+ccdId+"\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_view.png\" width=\"20\" height=\"20\"/></a>"
					}else if(type == "cr"){
						return "<a target=\"_self\" href=\"/ermsweb/limitApplicationDetail?userId="+window.sessionStorage.getItem("username")+"&rmdGroupId="+groupId+"&approvalMatrixBu="+approvalMatrixBu+"&approvalMatrixOption="+approvalMatrixOption+"&crId="+crId+"&action=V&ccdId="+ccdId+"\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_view.png\" width=\"20\" height=\"20\"/></a>"										
					}
				}else{
					return "";
				}
			}

			function nullAndEmptyToNA(value){
				if(value === "" || value === null || value === undefined || value === "null"){
					return "NA";		
				}else{
					return value;
				}
			}

			function openHistory(groupId, ccdId, approvalMatrixBu, approvalMatrixOption){
				
				$("#historyWindow").data("kendoWindow").open();
                $("#historyWindow").data("kendoWindow").center();

                $("#groupIdHistory").text(checkUndefinedElement(groupId));
                $("#ccdIdHistory").text(checkUndefinedElement(ccdId));
                $("#approvalMatrixBuHistory").text(checkUndefinedElement(approvalMatrixBu));
                $("#approvalMatrixOptionHistory").text(checkUndefinedElement(approvalMatrixOption));

                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: window.sessionStorage.getItem('serverPath')+"limitapplication/getHistory?rmdGroupId="+nullAndEmptyToNA(groupId)+"&ccdId="+nullAndEmptyToNA(ccdId)+"&approvalMatrixBu="+nullAndEmptyToNA(approvalMatrixBu)+"&approvalMatrixOption="+nullAndEmptyToNA(approvalMatrixOption), cache: false,
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            },
                            complete: function(response, status){
                                if(status == "success"){
                                	$.each(JSON.parse(response.responseText), function(key, value) {
                                		
                                	});
                                }   
                            }
                        }
                    },  
                    schema: { 
                        model:{
                            id: "guarId",
                            fields:{
                                guarId: {type: "string"},
                                guarName : {type: "string"},
                                guarDomicile : {type: "string"}
                            }
                        }
                    },
                    pageSize: 10
                }); 

				$('#historyGrid').kendoGrid({
				    dataSource: dataSource,
				    filterable: false,
				    columnMenu: false,
				    sortable: true,
				    pageable: {
				        refresh: true,
				        pageSize: 5
				    },
				    scrollable: true,
				    columns: [  
				        { field: "crStatus", title: "Status" ,width: 200},
				        { field: "lastUpdateBy", title: "Last Update By" ,width: 200},
				        { field: "lastUpdateDt", title: "Last Update Date" ,width: 200, template: "#=toDateFormatReverse(lastUpdateDt)#"},
				        { field: "", title: "File" ,width: 200, template:"#=getFile(filename)#"}

				    ]
				 });

                /*historyGrid*/

			}
			function getFile(fileName){
				return "<a target=\"_blank\" style=\"color: blue; cursor:pointer\" href=\""+window.sessionStorage.getItem('serverPath')+"limitapplication/getFile?filename="+fileName+"\">Get File</a>";
			}
			function viewHistory(isRoot, groupId, ccdId, approvalMatrixBu, approvalMatrixOption){

				if(isRoot != "Y"){
					return "<a style=\"color: blue;cursor:pointer \" onclick=\"openHistory('"+groupId+"','"+ccdId+"','"+approvalMatrixBu+"','"+approvalMatrixOption+"')\">View History</a>";
				}else{
					return "";
				}

				/*var link = window.sessionStorage.getItem('serverPath')+"limitapplication/getHistory?rmdGroupId="+groupId+"&ccdId="+ccdId+"&approvalMatrixBu="+approvalMatrixBu+"&approvalMatrixOption="+approvalMatrixOption;

				var dataSource = new kendo.data.DataSource({
    			    transport: {
    			        read: {
    			            type: "GET",
    			            async: false,
    			            url: link,  
    			            cache: false,
    			            dataType: "json",
    			            xhrFields: {
    			                withCredentials: true
    			            },
    			            complete: function(response, status){
    			            	if(status == "success"){

    			            		console.log(response.responseText);

    			            		$.each(JSON.parse(response.responseText), function(key, value) {
    			            			
    			            		});
    			            	} 
    			            }
    			        }
    			    },  
    	    	    schema: {                               
    	                model:{
    	                	id: "crId",
    	                	fields:{
    	                		crId: {type: "string"}
    	                	}
    	                }
                	}
    			}); 
				
				dataSource.read();*/

			}

	    	function disableGroupNameField(field){
	    		if(field.value == "groupName"){
	    			$("#groupNameField").prop('disabled', true);	
	    			$("#groupNameField").css({'background-color': 'white'});	
	    			$("#ccptyNameField").prop('disabled', false);	
	    			$("#ccptyNameField").css({'background-color': '#ccc'});	
	    			$("#accountNoField").prop('disabled', false);	
	    			$("#accountNoField").css({'background-color': '#ccc'});	
	    			$("#subAccountNoField").prop('disabled', false);	
	    			$("#subAccountNoField").css({'background-color': '#ccc'});	

	    		}else if(field.value == "ccptyName"){
	    			$("#groupNameField").prop('disabled', false);	
	    			$("#groupNameField").css({'background-color': '#ccc'});	
	    			$("#ccptyNameField").prop('disabled', true);	
	    			$("#ccptyNameField").css({'background-color': 'white'});	
	    			$("#accountNoField").prop('disabled', false);	
	    			$("#accountNoField").css({'background-color': '#ccc'});	
	    			$("#subAccountNoField").prop('disabled', false);	
	    			$("#subAccountNoField").css({'background-color': '#ccc'});	

	    		}else if(field.value == "accountNo"){
	    			$("#groupNameField").prop('disabled', false);
	    			$("#groupNameField").css({'background-color': '#ccc'});	
	    			$("#ccptyNameField").prop('disabled', false);
	    			$("#ccptyNameField").css({'background-color': '#ccc'});	
	    			$("#accountNoField").prop('disabled', true);
	    			$("#accountNoField").css({'background-color': 'white'});
	    			$("#subAccountNoField").prop('disabled', true);
	    			$("#subAccountNoField").css({'background-color': 'white'});
	    		}
	    	}
		    function toApplyLimitPage(){
		    	window.location.href = "/ermsweb/applyLimit";
		    }
		    function onClickSearchGroup(){
                
                $("#searchWindow").data("kendoWindow").open();
                $("#searchWindow").data("kendoWindow").center();
            }

            function onClickSearchCcpty(){
                
                $("#searchWindow2").data("kendoWindow").open();
                $("#searchWindow2").data("kendoWindow").center();
            }
            function onClickSearchAccount(){
                
                $("#searchWindow3").data("kendoWindow").open();
                $("#searchWindow3").data("kendoWindow").center();
            }
            function onClickOpenRemarkWindow(flag){
            	
            	clearDropDownWithoutBlank("remarkContent");
            	$("#remarkWindow").data("kendoWindow").open();
                $("#remarkWindow").data("kendoWindow").center();	
                $("#batchType").val(flag);

                /* http://lxdapp25:8080/ERMSCore/systemParam/getSysParams?userId=RISKADMIN&funcCat=&bizUnit=&multiValInd=Y */

    			var dataSource = new kendo.data.DataSource({
    			    transport: {
    			        read: {
    			            type: "GET",
    			            async: false,
    			            url: window.sessionStorage.getItem('serverPath')+"systemParam/getSysParams?funcCat=&bizUnit=&multiValInd=Y&userId="+window.sessionStorage.getItem("username"),   
    			            cache: false,
    			            dataType: "json",
    			            xhrFields: {
    			                withCredentials: true
    			            },
    			            complete: function(response, status){
    			            	if(status == "success"){
    			            		clearDropDownWithoutBlank("remarkCat");
    			            		$.each(JSON.parse(response.responseText), function(key, value) {
    			            			if(key == "Remarks Category"){
    			            				$.each(value, function(key, value) {
    			            					fillInToDropDown("remarkCat", value.paramValue, value.paramValue)
    			            				});
    			            			}
    			            		});
    			            	} 
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
    	                },
    	                model:{
    	                	id: "crId",
    	                	fields:{
    	                		crId: {type: "string"}
    	                	}
    	                }
                	},
                	serverPaging: true,
    			    pageSize: 10
    			}); 
				
				dataSource.read();
            }

            function closePopup(){
            	
            	$("#remarkWindow").data("kendoWindow").close();              
                $("#batchType").val("");

            }
            function onClickOpenRemarkWindow2(flag){
            	
            	$("#remarkWindow2").data("kendoWindow").open();
            	$("#remarkWindow2").data("kendoWindow").pin();
                $("#remarkWindow2").data("kendoWindow").center();
                $("#batchType2").val(flag);

                var getBatchIdUrl = window.sessionStorage.getItem('serverPath')+"limitapplication/getPendingRemarksDetails?userId="+window.sessionStorage.getItem("username")+""+scanGridCheckbox("getPendingRemarksDetailsGrid");

                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getBatchIdUrl,   
                            cache: false,                       
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
                	}
                }); 


                $("#getPendingRemarksDetailsGrid").kendoGrid({

                	dataSource: dataSource,
                	filterable: false,
                	columnMenu: false,
                	sortable: true,
                	serverPaging: true,
                	scrollable: true,
                	columns: [  
    				    /* Group by */
    				    {
    				        title: "Business Unit",
    				        width: 200,
    				        columns: [
    				            { 
    				                field: "bizUnitDesc",
    				                title: " " ,
    				                width: 200
    				            },
    				            { 
    				                field: "bizUnitCode",
    				                title: " " ,
    				                width: 200
    				            }
				            ]
    				    },
    				    /* Group by */
    				    { 
    				        field: "groupName",
    				        title: "Group Name" ,
    				        width: 200
    				    },
    				    { 
    				        field: "ccdName",
    				        title: "Client Counterparty Namer" ,
    				        width: 200
    				    },
    				    { 
    				        field: "accName",
    				        title: "Account Name" ,
    				        width: 200
    				    },
    				    { 
    				        field: "acctId",
    				        title: "Account No" ,
    				        width: 200
    				    },
    				    { 
    				        field: "subAcctId",
    				        title: "Sub Account No" ,
    				        width: 200
    				    },
    				    { 
    				        field: "cmdAcctStatus",
    				        title: "Account Status" ,
    				        width: 200
    				    },
    				    { 
    				        field: "acctOpenDate",
    				        title: "Account Open Date (yyyy/mm/dd)" ,
    				        width: 200,
    				        template: "#=toDateFormatReverse(acctOpenDate)#"
    				    },
    				    { 
    				        field: "salesmanCode",
    				        title: "Sales Code" ,
    				        width: 200
    				    },
    				    { 
    				        field: "salesmanName",
    				        title: "Sales Name" ,
    				        width: 200
    				    },
    				    { 
    				        field: "facId",
    				        title: "Facility ID" ,
    				        width: 200
    				    },
    				    { 
    				        field: "lmtTypeDesc",
    				        title: "Limit Type" ,
    				        width: 200
    				    },
    				    { 
    				        field: "ccfRatio",
    				        title: "CCF (%)" ,
    				        width: 200
    				    },
    				    
    				    /* Group by */
    				    {
    				        title: "Existing Facility Limit",
    				        width: 200,
    				        columns: [
    				            { 
    				                field: "existLmtCcy",
    				                title: "Facility Limit" ,
    				                width: 200
    				            },
    				            { 
    				                field: "existLmtAmt",
    				                title: "Amount" ,
    				                width: 200
    				            },
    				            { 
    				                field: "existLmtExpiryDate",
    				                title: "Existing Expiry Date (yyyy/mm/dd)" ,
    				                width: 200,
    				                template: "#=toDateFormatReverse(existLmtExpiryDate)#"
    				            },
    				            { 
    				                field: "existCcfLmtAmtHkd",
    				                title: "Existing Limit Amount x CCF (HKD)" ,
    				                width: 200
    				            },
				            ]
    				    },

    				    {
    				        title: "New Facility Limit",
    				        width: 200,
    				        columns: [
    				            { 
    				                field: "newLmtCcy",
    				                title: " " ,
    				                width: 200
    				            },
    				            { 
    				                field: "newLmtAmt",
    				                title: " " ,
    				                width: 200
    				            },
    				            { 
    				                field: "newLmtExpiryDate",
    				                title: "New Expiry Date (yyyy/mm/dd)" ,
    				                width: 200,
    				                template: "#=toDateFormatReverse(newLmtExpiryDate)#"
    				            },
    				            { 
    				                field: "newCcfLmtAmtHkd",
    				                title: "New Limit Amount x CCF (HKD)" ,
    				                width: 200
    				            }
				            ]
    				    },
    				    {
    				        title: "Counter Offer : New Facility Limit",
    				        width: 200,
    				        columns: [
    				            { 
    				                field: "coLmtCcy",
    				                title: " " ,
    				                width: 200
    				            },
    				            { 
    				                field: "coLmtAmt",
    				                title: " " ,
    				                width: 200
    				            },
    				            { 
    				                field: "coLmtExpiryDate",
    				                title: "Counter Offer New Expiry Date (yyyy/mm/dd)" ,
    				                width: 200,
    				                template: "#=toDateFormatReverse(coLmtExpiryDate)#"
    				            },
    				            { 
    				                field: "coCcfLmtAmtHkd",
    				                title: "Counter Offer : New Facility Amount x CCF (HKD)" ,
    				                width: 200
    				            }
				            ]
    				    },
    				    { 
    				        field: "",
    				        title: "Remarks Category" ,
    				        width: 300,
    				        template: "#=createRemarkCatDropDown(isRoot, batchId)#"
    				    },
    				    { 
    				        field: "",
    				        title: "Remarks",
    				        width: 300,
    				        template: "#=createRemarkTextbox(isRoot, batchId)#"
    				    },
    				    { 
    				        field: "",
    				        title: "Remarks Contents" ,
    				        width: 300,
    				        template: "#=createGetRemarkContent(isRoot, batchId)#"
    				    },
    				    { 
    				        field: "lastUpdateDt",
    				        title: "Updated Date (yyyy/mm/dd hh:mi)" ,
    				        width: 200,
    				        template: "#=toDateFormatReverse(lastUpdateDt)#"
    				    },
    				    { 
    				        field: "processedBy",
    				        title: "To be Processed By" ,
    				        width: 200
    				    },
    				    { 
    				        field: "isAnnualLmtReview",
    				        title: "Annual Limit Review" ,
    				        width: 200
    				    },
    				    { 
    				        field: "isBatchUpload",
    				        title: "Batch Upload" ,
    				        width: 200
    				    },
    				    { 
    				        field: "batchId",
    				        title: "Batch ID" ,
    				        width: 200
    				    }
    				]
                })
            }

            function createRemarkCatDropDown(isRoot, batchId){

            	if(isRoot){
            		var selectoptFormat = "";
            		var dataSource = new kendo.data.DataSource({
    			    transport: {
    			        read: {
    			            type: "GET",
    			            async: false,
    			            url: window.sessionStorage.getItem('serverPath')+"systemParam/getSysParams?funcCat=&bizUnit=&multiValInd=Y&userId="+window.sessionStorage.getItem("username"),   
    			            cache: false,
    			            dataType: "json",
    			            xhrFields: {
    			                withCredentials: true
    			            },
    			            complete: function(response, status){
    			            	if(status == "success"){
    			            		clearDropDownWithoutBlank("remarkCat");
    			            		$.each(JSON.parse(response.responseText), function(key, value) {
    			            			if(key == "Remarks Category"){
    			            				$.each(value, function(key, value) {

    			            					/*fillInToDropDown("remarkCat", value.paramValue, value.paramValue)*/

    			            					selectoptFormat += "<option value=\""+ value.paramValue +"\">"+value.paramValue+"</option>"

    			            				});
    			            			}
    			            		});
    			            	} 
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
    	                },
    	                model:{
    	                	id: "crId",
    	                	fields:{
    	                		crId: {type: "string"}
    	                	}
    	                }
                	},
                	serverPaging: true,
    			    pageSize: 10
    			}); 
				
				dataSource.read();

        		return "<select class=\"select_join\" style=\"width: 100%\" id=\"select_"+batchId+"\">"+selectoptFormat+"</select>"

            	}else{
            		return "";
            	}
            }

            function addToRemarkContentOfGrid(){

            	console.log($("#tmpBatchId").val());
		    	
		    	var remarkContent = document.getElementById("remarkContent2");

		    	var stringVal = "";
		    	clearDropDownWithoutBlank("content_"+$("#tmpBatchId").val());

		    	for (var i = 0; i < remarkContent.length; i++) {
					var tmparr = remarkContent[i].value.split("||");
					stringVal =  tmparr[0] + " : " + tmparr[1];
					console.log(stringVal);
					fillInToDropDown("content_"+$("#tmpBatchId").val(), stringVal, stringVal);
		    	};

		    	$("#remarkWindow3").data("kendoWindow").close();
		    	$("#remark2").val("");
		    	clearDropDownWithoutBlank("remarkContent2");
            }

            function createRemarkTextbox(isRoot, batchId){

            	if(isRoot){

            		return "<input type=\"text\" class=\"k-textbox\" style=\"width: 100%\" id=\"text_"+batchId+"\"></input>"

            	}else{

            		return "";
            	}
            }

            function createGetRemarkContent(isRoot, batchId){

            	if(isRoot){

            		return "<div align=\"right\"><select class=\"select_join\" style=\"width: 100%\" id=\"content_"+batchId+"\"></select><input type=\"button\" id=\"button_"+batchId+"\" class=\"k-button\" onclick=\"openRemarkWindow3('"+batchId+"')\" value=\"Add\"></input></div>";

            	}else{

            		return "";
            	}
            }

            function openRemarkWindow3(batchId){

        		$("#remarkWindow3").data("kendoWindow").open();
        	    $("#remarkWindow3").data("kendoWindow").center();

    			var dataSource = new kendo.data.DataSource({
    			    transport: {
    			        read: {
    			            type: "GET",
    			            async: false,
    			            url: window.sessionStorage.getItem('serverPath')+"systemParam/getSysParams?funcCat=&bizUnit=&multiValInd=Y&userId="+window.sessionStorage.getItem("username"),   
    			            cache: false,
    			            dataType: "json",
    			            xhrFields: {
    			                withCredentials: true
    			            },
    			            complete: function(response, status){
    			            	if(status == "success"){
    			            		clearDropDownWithoutBlank("remarkCat2");
    			            		$.each(JSON.parse(response.responseText), function(key, value) {
    			            			if(key == "Remarks Category"){
    			            				$.each(value, function(key, value) {
    			            					fillInToDropDown("remarkCat2", value.paramValue, value.paramValue)
    			            				});
    			            			}
    			            		});
    			            		$("#tmpBatchId").val(batchId);
    			            	} 
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
    	                },
    	                model:{
    	                	id: "crId",
    	                	fields:{
    	                		crId: {type: "string"}
    	                	}
    	                }
                	},
                	serverPaging: true,
    			    pageSize: 10
    			}); 
				
				dataSource.read();

            }

            function onlyUnique(value, index, self) { 
                return self.indexOf(value) === index;
            }

            function closePopup2(){
            	$("#remarkWindow3").data("kendoWindow").close();
            	$("#remark2").val("");
            	clearDropDownWithoutBlank("remarkContent2");
            }

            function onProceed(){

            	var displayedData = $("#getPendingRemarksDetailsGrid").data().kendoGrid.dataSource.view();
            	var displayedDataAsJSON = JSON.stringify(displayedData);
            	var arrayOfBatchId = [];

            	$.each(JSON.parse(displayedDataAsJSON), function(key, value) {
            		arrayOfBatchId.push(value.batchId);
            	});

            	var unique = arrayOfBatchId.filter( onlyUnique );

            	console.log(unique);

            	var jsonStringFormat = "[";

            	for (var i = 0; i < unique.length; i++) {

            		console.log(unique[i]);

            		jsonStringFormat += "{";
            		jsonStringFormat += "\"userId\" : \"" + window.sessionStorage.getItem("username")+"\",";
            		jsonStringFormat += "\"groupHier\" : null,";
            		jsonStringFormat += "\"batchId\" : \"" + unique[i] + "\",";
            		jsonStringFormat += "\"action\" : \"" + $("#batchType2").val() + "\",";

    		    	var remarkContent = document.getElementById("content_"+unique[i]);

    		    	jsonStringFormat += "\"batchRemarkResult\" : [";

    		    	if($("#text_"+unique[i]).val() != "" && $("#text_"+unique[i]).val() != undefined){

    		    		console.log("1");

    		    		jsonStringFormat += "{ \"remark\":\""+$("#text_"+unique[i]).val()+"\", \"remarkCat\":\""+document.getElementById("select_"+unique[i]).options[document.getElementById("select_"+unique[i]).selectedIndex].value +"\" }],";
    		    		jsonStringFormat = jsonStringFormat.substring(0, jsonStringFormat.length - 1);
    		    	}else{
    		    		console.log("2");
    		    		if(remarkContent.length > 0){
	    		    		for (var j = 0; j < remarkContent.length; j++) {
		    					var tmparr = remarkContent[j].value.split(":");
		    					jsonStringFormat += "{ \"remark\" : \"" + tmparr[1] + "\", \"remarkCat\" : \"" + tmparr[0]  + "\"},";
		    		    	};	
    		    		}else{
    		    			jsonStringFormat += "{},";
    		    		}
    		    		
	    		    	jsonStringFormat = jsonStringFormat.substring(0, jsonStringFormat.length - 1);
	    		    	jsonStringFormat += "]";
    		    	}

    		    	
            		jsonStringFormat += "},";

            	}

            	jsonStringFormat = jsonStringFormat.substring(0, jsonStringFormat.length - 1);
            	jsonStringFormat += "]";
            	console.log(jsonStringFormat);

    			$("#batchType2").val("");

    			    	var dataSource = new kendo.data.DataSource({
    			    	    transport: {
    			    	        read: function (options){
    				               $.ajax({
    				                   	type: "POST",
    				                   	url: window.sessionStorage.getItem('serverPath')+"limitapplication/batchAction",
    				                   	data: jsonStringFormat,
    				                   	contentType: "application/json; charset=utf-8",
    				                   	dataType: "json",
    				                  	success: function (result) {
    				                   	    options.success(result);
    				                   	},
    				                   	complete: function (jqXHR, textStatus){
    										if(textStatus == "success"){
    											$.each(JSON.parse(jqXHR.responseText), function(key, value) {
    												
    												if(value.status == "SUCCESS"){
    													document.getElementById("returnMessage2").style.color = "green";
    													document.getElementById("returnMessage2").innerHTML = value.Message;
    													 
    												}else if(value.status == "FAILED"){

    													document.getElementById("returnMessage2").style.color = "red";
    													document.getElementById("returnMessage2").innerHTML = value.Message;

    												}else{
    													document.getElementById("returnMessage2").style.color = "black";
    													document.getElementById("returnMessage2").innerHTML = value.Message;
    												}
    												

    											});
    											$("#remarkWindow2").data("kendoWindow").close();
    											onClickSubmit();
    										}
    									},
    									error: function(e){
    										document.getElementById("returnMessage2").style.color = "red";
    										document.getElementById("returnMessage2").innerHTML = "Update Failed : At least 1 row on assigned list.";
    										$("#remarkWindow2").data("kendoWindow").close();
    										onClickSubmit();
    									},
    				                	xhrFields: {
    							    		withCredentials: true
    							    	}
    				               	});
    			    	        }
    			    	    },
    			    	    schema: {
    			    	        model: {
    			    	            fields: {
    			    	               rmdGroupId: { type: "string" },
    			    	               groupTypeDesc: { type: "string" },
    			    	               rmdGroupDesc: { type: "string" }
    			    	            }
    			    	        }
    			    	    },
    			    	    pageSize: 11
    			    	});
    			    	dataSource.read();
    			    	
            }

    	</script>
    	
    	<div class="page-title">Limit Application</div>

    	<div align="right" style="padding-right: 50px">

    		<input type="button" class="k-button" value="Apply Limit" id="applyLimxit" onclick="toApplyLimitPage()"></input>
    		<!-- <input type="button" class="k-button" value="Batch Upload" id="batchUpload"></input> -->
    	</div>
    	<br>
    	<div id="searchContainer">
	    	<table id="listTable" width="100%" style="background-color:#DBE5F1; overflow-x:scroll; border-bottom; border-collapse: collapse; " cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="6" style="background-color:#8DB4E3; width:100%">
					<b><div id="filterTable" onclick="expandCriteria()">(+) Filter Criteria</div></b></td>
				</tr>
				<tr>
					<td><br></td>
				</tr>
				<tbody id="filterBody" style="display: block; padding-left: 7px">
					<tr>
						<td>Business Unit</td>
						<td>
						<select class="select_join" style="width: 300px" id="bizUnit" name="bizUnit">
						</select>
						</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr><td><br></td></tr>
					<tr>
						<td>Client / Counter Party Hierarchy</td>
						<td colspan="3">
							<table border="0" width="100%" style="100%">
								<tr>
									<td><label>Group Name</label> </td>
									<td align="right"><input disabled onkeyup="toReset('group')" class="k-textbox" style="width: 300px;" id="groupName" name="groupName" type="text"/>
									<button id="search" onclick="onClickSearchGroup()" class="k-button" value="Search">Search</button>
									</td>
								</tr>
								<tr>
									<td><label>Client / Counter Party Name</label> </td>
									<td align="right"><input disabled onkeyup="toReset('ccpty')" class="k-textbox" style="width: 300px;" id="CcptyName" name="CcptyName" type="text"/>
									<button id="search" onclick="onClickSearchCcpty()" class="k-button" value="Search">Search</button>
									</td>
								</tr>						
								<tr>
									<td><labelo>Account No.</label> </td>
									<td align="right"><input disabled onkeyup="toReset('acct')" class="k-textbox" style="width: 300px" id="accountNo" name="accountNo" type="text"/>
									<button id="search" onclick="onClickSearchAccount()" class="k-button" value="Search">Search</button>
									</td>
								</tr>						
								<tr>
									<td><label>Sub Account No.</label> </td>
									<td align="right"><input disabled onkeyup="toReset('acct')" class="k-textbox" style="width: 300px;" id="subAccountNo" name="subAccountNo" type="text"/>
									<button style="visibility: hidden" id="search" class="k-button" value="Search">Search</button>
									</td>
								</tr>						
							</table>

						</td>
						<td></td>
						<td></td>
					</tr>

					<tr><td><br></td></tr>
					<tr>
						<td>Limit Type</td>
						<td><select class="select_join" style="width: 300px" id="lmtTypeDesc" name="lmtTypeDesc"></select></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr><td><br></td></tr>
					<tr>
						<td>Status for Limit Application</td>
						<td>
						<select class="select_join" style="width: 300px" id="limitApplicationStatus" name="limitApplicationStatus">
							<option value="">-</option>
							<option value="Pending for Verification">Pending for Verification</option>
							<option value="Pending for Approval">Pending for Approval</option>
						</select>
						</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr><td><br></td></tr>
					<tr>
						<td>Annual Limit Review</td>
						<td>
						<select class="select_join" style="width: 300px" id="isAnnualLmtReview" name="isAnnualLmtReview">
							<option value="">-</option>
							<option value="Y">Y</option>
							<option value="N">N</option>
						</select>
						</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr><td><br></td></tr>
					<tr>
						<td>Batch Upload</td>
						<td>
						<select class="select_join" style="width: 300px" id="isBatchUpload" name="isBatchUpload">
							<option value="">-</option>
							<option value="Y">Yes</option>
							<option value="N">No</option>
						</select>
						</td>
						<td align="center">Batch ID.</td>
						<td><input class="k-textbox" style="width: 300px" id="batchId" name="batchId" type="text"/></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr><td><br></td></tr>
					<tr>
						<td>Existing Expiry Date</td>
						<td><input style="width: 300px" id="fromExistLmtExpiryDate" type="text"/></td>
						<td align="center">To</td>
						<td><input style="width: 300px" id="toExistLmtExpiryDate" type="text"/></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr><td><br></td></tr>
					<tr>
						<td>New Expiry Date</td>
						<td><input style="width: 300px" id="fromNewLmtExpiryDate" type="text"/></td>
						<td align="center">To</td>
						<td><input style="width: 300px" id="toNewLmtExpiryDate" type="text"/></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr><td><br></td></tr>
					<tr>
						<td>Request Date</td>
						<td><input style="width: 300px" id="fromRequestDate" type="text"/></td>
						<td align="center">To</td>
						<td><input style="width: 300px" id="toRequestDate" type="text"/></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr><td><br></td></tr>
					<tr>
						<td>Sales Code</td>
						<td>
						<select class="select_join" style="width: 300px" id="salesCode" name="salesCode"></select>
						</td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr><td><br></td></tr>
					<tr><td><br></td></tr>

					<tr>
						<td>Account Status</td>
						<td colspan="5">
							<div style="padding-left: 70px; padding-right: 70px; display: inline-block"><input type="checkbox" class="k-checkbox" name="acctStatus" id="cmdAcctStatusActive" value="Y"> <label class="k-checkbox-label" for="cmdAcctStatusActive">Active</label></div>
							<div style="padding-left: 70px; padding-right: 70px; display: inline-block"><input type="checkbox" class="k-checkbox" name="acctStatus" id="cmdAcctStatusClosed" value="Y"> <label class="k-checkbox-label" for="cmdAcctStatusClosed">Closed</label></div>&nbsp;&nbsp;
							<div style="padding-left: 70px; padding-right: 70px; display: inline-block"><input type="checkbox" class="k-checkbox" name="acctStatus" id="cmdAcctStatusDormant" value="Y"> <label class="k-checkbox-label" for="cmdAcctStatusDormant">Dormant</label></div><br><br>
							<div style="padding-left: 70px; padding-right: 70px; display: inline-block"><input type="checkbox" class="k-checkbox" name="acctStatus" id="cmdAcctStatusFreeze" value="Y"> <label class="k-checkbox-label" for="cmdAcctStatusFreeze">Freeze</label></div>
							<div style="padding-left: 70px; padding-right: 70px; display: inline-block"><input type="checkbox" class="k-checkbox" name="acctStatus" id="cmdAcctStatusInactive" value="Y"> <label class="k-checkbox-label" for="cmdAcctStatusInactive">Inactive</label></div>
							<div style="padding-left: 70px; padding-right: 70px; display: inline-block"><input type="checkbox" class="k-checkbox" name="acctStatus" id="cmdAcctStatusProcess" value="Y"> <label class="k-checkbox-label" for="cmdAcctStatusProcess">Processing</label></div><br><br>
							<div style="padding-left: 70px; padding-right: 70px; display: inline-block"><input type="checkbox" class="k-checkbox" name="acctStatus" id="cmdAcctStatusSuspend" value="Y"> <label class="k-checkbox-label" for="cmdAcctStatusSuspend">Suspended</label></div>

						</td>
						<td></td>
					</tr>
					<tr><td><br></td></tr>
					<tr>
						<td><input type="checkbox" class="k-checkbox" name="filterPending" id="filterPending" value="Y"> <label class="k-checkbox-label" for="filterPending">Filter on Pending Request</label></td>
						<td></td>
						<td></td>
						<td>
							<input type="hidden" id="rmdGroupId" name="groupId" value=""></input>
							<input type="hidden" id="ccdId" name="ccdId" value=""></input>
						</td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr><td><br></td></tr>
					<tr><td><br></td></tr>
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td colspan="2"><b>Result :</b> <br><b><div id="returnMessage"></div></b><b><div id="noRecord"/></div></b></td>
						<td>
							<button class="k-button" id="submitBtn" type="button">Search</button>
							<button class="k-button" id="resetBtn" 	type="button">Reset</button>
							<button class="k-button" id="exportBtn" type="button" onclick="toExport()">Export</button>
						</td>
					</tr>
					<tr><td><br>		<div id="gridContent"></div></td></tr>
					<tr><td><br></td></tr>
				</tbody>
			</table>
		</div>
		<br>

		<script>

			function toExport(){

     			var ds1 = new kendo.data.DataSource({
     			    transport: {
     			        read: {
     			            type: "GET",
     			            async: false,
     			            url: window.sessionStorage.getItem('serverPath')+"limitapplication/getEnquiryAndPendingDetails?enquiryView=Y&summaryView=Y&userId="+window.sessionStorage.getItem("username")+"&isBatchUpload=ALL"+postfixUrl(getCheckedCheckbox("searchContainer"), getSelectOptionFields("searchContainer"), getAllInputTextFields("searchContainer"), getAllHiddenFields("searchContainer")),   
     			            cache: false,
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
	    	                },
	    	                model:{
	    	                	id: "crId",
	    	                	fields:{
	    	                		crId: {type: "string"}
	    	                	}
	    	                }
	                	},
	                	serverPaging: true,
     			    pageSize: 10
     			}); 

					var ds2 = new kendo.data.DataSource({
     			    transport: {
     			        read: {
     			            type: "GET",
     			            async: false,
     			            url: window.sessionStorage.getItem('serverPath')+"limitapplication/getEnquiryAndPendingDetails?enquiryView=Y&summaryView=Y&userId="+window.sessionStorage.getItem("username")+"&isBatchUpload=ALL"+postfixUrl(getCheckedCheckbox("searchContainer"), getSelectOptionFields("searchContainer"), getAllInputTextFields("searchContainer"), getAllHiddenFields("searchContainer")), 
     			            cache: false,
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
     			    pageSize: 10
     			}); 

	            var rows1 = [{
	                cells: [
	                  {value : "action"},
	                  {value : "status"},
	                  {value : "total"},
	                  {value : "crBy"},
	                  {value : "crId"},
	                  {value : "groupId"},
	                  {value : "ccdId"},
	                  {value : "isRoot"},
	                  {value : "lmtTypeCode"},
	                  {value : "bizUnitDesc"},
	                  {value : "bizUnitCode"},
	                  {value : "groupName"},
	                  {value : "ccdName"},
	                  {value : "acctId"},
	                  {value : "accName"},
	                  {value : "subAcctId"},
	                  {value : "cmdAcctStatus"},
	                  {value : "acctOpenDate"},
	                  {value : "salesmanCode"},
	                  {value : "salesmanName"},
	                  {value : "facId"},
	                  {value : "lmtTypeDesc"},
	                  {value : "ccfRatio"},
	                  {value : "existLmtExpiryDate"},
	                  {value : "existLmtCcy"},
	                  {value : "existLmtAmt"},
	                  {value : "existCcfLmtAmtHkd"},
	                  {value : "newLmtExpiryDate"},
	                  {value : "newLmtCcy"},
	                  {value : "newLmtAmt"},
	                  {value : "newCcfLmtAmtHkd"},
	                  {value : "coLmtExpiryDate"},
	                  {value : "coLmtCcy"},
	                  {value : "coLmtAmt"},
	                  {value : "coCcfLmtAmtHkd"},
	                  {value : "crDt"},
	                  {value : "lastUpdateBy"},
	                  {value : "lastUpdateDt"},
	                  {value : "processedBy"},
	                  {value : "isBatchUpload"},
	                  {value : "batchId"},
	                  {value : "isAnnualLmtReview"},
	                  {value : "approvalMatrixBu"},
	                  {value : "approvalMatrixOption"},
	                ]
	            }];

	            var rows2 = [{
	                cells: [
	                  {value : "action"},
	                  {value : "status"},
	                  {value : "total"},
	                  {value : "crBy"},
	                  {value : "crId"},
	                  {value : "groupId"},
	                  {value : "ccdId"},
	                  {value : "isRoot"},
	                  {value : "lmtTypeCode"},
	                  {value : "bizUnitDesc"},
	                  {value : "bizUnitCode"},
	                  {value : "groupName"},
	                  {value : "ccdName"},
	                  {value : "acctId"},
	                  {value : "accName"},
	                  {value : "subAcctId"},
	                  {value : "cmdAcctStatus"},
	                  {value : "acctOpenDate"},
	                  {value : "salesmanCode"},
	                  {value : "salesmanName"},
	                  {value : "facId"},
	                  {value : "lmtTypeDesc"},
	                  {value : "ccfRatio"},
	                  {value : "existLmtExpiryDate"},
	                  {value : "existLmtCcy"},
	                  {value : "existLmtAmt"},
	                  {value : "existCcfLmtAmtHkd"},
	                  {value : "newLmtExpiryDate"},
	                  {value : "newLmtCcy"},
	                  {value : "newLmtAmt"},
	                  {value : "newCcfLmtAmtHkd"},
	                  {value : "coLmtExpiryDate"},
	                  {value : "coLmtCcy"},
	                  {value : "coLmtAmt"},
	                  {value : "coCcfLmtAmtHkd"},
	                  {value : "crDt"},
	                  {value : "lastUpdateBy"},
	                  {value : "lastUpdateDt"},
	                  {value : "processedBy"},
	                  {value : "isBatchUpload"},
	                  {value : "batchId"},
	                  {value : "isAnnualLmtReview"},
	                  {value : "approvalMatrixBu"},
	                  {value : "approvalMatrixOption"},
	                ]
	            }];

	            var workbook = new kendo.ooxml.Workbook({
	                sheets: [
	                	{
	                        columns: [
	                            // Column settings (width)
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true }
	                            
	                        ],
	                            title: "Limit Application List",
	                            rows: rows1
	                    },
	                	{
	                        columns: [
	                            // Column settings (width)
	                           { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true },
	                            { autoWidth: true }
	                        ],
	                            title: "Pending Change Request",
	                            rows: rows2
	                    }
	                ]
	            });

	            //using fetch, so we can process the data when the request is successfully completed
	            ds1.fetch(function(){

	                var data = ds1.view();
	                
	                for (var i = 0; i < data.length; i++){
	                  //push single row for every record
	                  rows1.push({
	                    cells: [
	                      {value: data[i].action},
	                      {value: data[i].status},
	                      {value: data[i].total},
	                      {value: data[i].crBy},
	                      {value: data[i].crId},
	                      {value: data[i].groupId},
	                      {value: data[i].ccdId},
	                      {value: data[i].isRoot},
	                      {value: data[i].lmtTypeCode},
	                      {value: data[i].bizUnitDesc},
	                      {value: data[i].bizUnitCode},
	                      {value: data[i].groupName},
	                      {value: data[i].ccdName},
	                      {value: data[i].acctId},
	                      {value: data[i].accName},
	                      {value: data[i].subAcctId},
	                      {value: data[i].cmdAcctStatus},
	                      {value: toDateFormat(data[i].acctOpenDate)},
	                      {value: data[i].salesmanCode},
	                      {value: data[i].salesmanName},
	                      {value: data[i].facId},
	                      {value: data[i].lmtTypeDesc},
	                      {value: data[i].ccfRatio},
	                      {value: toDateFormat(data[i].existLmtExpiryDate)},
	                      {value: data[i].existLmtCcy},
	                      {value: data[i].existLmtAmt},
	                      {value: data[i].existCcfLmtAmtHkd},
	                      {value: toDateFormat(data[i].newLmtExpiryDate)},
	                      {value: data[i].newLmtCcy},
	                      {value: data[i].newLmtAmt},
	                      {value: data[i].newCcfLmtAmtHkd},
	                      {value: toDateFormat(data[i].coLmtExpiryDate)},
	                      {value: data[i].coLmtCcy},
	                      {value: data[i].coLmtAmt},
	                      {value: data[i].coCcfLmtAmtHkd},
	                      {value: toDateFormat(data[i].crDt)},
	                      {value: data[i].lastUpdateBy},
	                      {value: toDateFormat(data[i].lastUpdateDt)},
	                      {value: data[i].processedBy},
	                      {value: data[i].isBatchUpload},
	                      {value: data[i].batchId},
	                      {value: data[i].isAnnualLmtReview},
	                      {value: data[i].approvalMatrixBu},
	                      {value: data[i].approvalMatrixOption},
	                      
	                    ]
	                  });
	                }
	                 /*kendo.saveAs({dataURI: workbook.toDataURL(), fileName: "RMD_GROUP_LISTS.xlsx"}); */
	            });

				for (var i = 0; i < 10000000; i++) {
				};

	            ds2.fetch(function(){

	                var data2 = ds2.view();

	                for (var i = 0; i < data2.length; i++){
	                  //push single row for every record
	                  rows2.push({
	                    cells: [

	                      {value: data2[i].action},
                          {value: data2[i].status},
                          {value: data2[i].total},
                          {value: data2[i].crBy},
                          {value: data2[i].crId},
                          {value: data2[i].groupId},
                          {value: data2[i].ccdId},
                          {value: data2[i].isRoot},
                          {value: data2[i].lmtTypeCode},
                          {value: data2[i].bizUnitDesc},
                          {value: data2[i].bizUnitCode},
                          {value: data2[i].groupName},
                          {value: data2[i].ccdName},
                          {value: data2[i].acctId},
                          {value: data2[i].accName},
                          {value: data2[i].subAcctId},
                          {value: data2[i].cmdAcctStatus},
                          {value: toDateFormat(data2[i].acctOpenDate)},
                          {value: data2[i].salesmanCode},
                          {value: data2[i].salesmanName},
                          {value: data2[i].facId},
                          {value: data2[i].lmtTypeDesc},
                          {value: data2[i].ccfRatio},
                          {value: toDateFormat(data2[i].existLmtExpiryDate)},
                          {value: data2[i].existLmtCcy},
                          {value: data2[i].existLmtAmt},
                          {value: data2[i].existCcfLmtAmtHkd},
                          {value: toDateFormat(data2[i].newLmtExpiryDate)},
                          {value: data2[i].newLmtCcy},
                          {value: data2[i].newLmtAmt},
                          {value: data2[i].newCcfLmtAmtHkd},
                          {value: toDateFormat(data2[i].coLmtExpiryDate)},
                          {value: data2[i].coLmtCcy},
                          {value: data2[i].coLmtAmt},
                          {value: data2[i].coCcfLmtAmtHkd},
                          {value: toDateFormat(data2[i].crDt)},
                          {value: data2[i].lastUpdateBy},
                          {value: toDateFormat(data2[i].lastUpdateDt)},
                          {value: data2[i].processedBy},
                          {value: data2[i].isBatchUpload},
                          {value: data2[i].batchId},
                          {value: data2[i].isAnnualLmtReview},
                          {value: data2[i].approvalMatrixBu},
                          {value: data2[i].approvalMatrixOption},
	                    ]
	                  });
	                }
	                //save the file as Excel file with extension xlsx
	               kendo.saveAs({dataURI: workbook.toDataURL(), fileName: "RMD_GROUP_LISTS.xlsx"}); 
	            });
						
	            /* 	Close the onload	*/
	   		}

			

			function onLoadGetBatchIdList(isBatchUpload){

				var getBatchIdUrl = window.sessionStorage.getItem('serverPath')+"limitapplication/getPendingBatchIdList?isBatchUpload="+isBatchUpload+"&userId="+window.sessionStorage.getItem("username");

				var dataSource = new kendo.data.DataSource({
				    transport: {
				        read: {
				            type: "GET",
				            async: false,
				            url: getBatchIdUrl,   
				            cache: false,                       
				            dataType: "json",
				            xhrFields: {
				                withCredentials: true
				            },
				            complete: function(response, status){
				                if(status == "success"){

				                	$.each(JSON.parse(response.responseText), function(key, value) {
				                		fillInToDropDown("batchIdList", value.batchId ,value.batchId);
				                	});
				                }   
				            }
				        }
				    },  
				    schema: { 
				        model:{
				            id: "guarId",
				            fields:{
				                guarId: {type: "string"},
				                guarName : {type: "string"},
				                guarDomicile : {type: "string"}
				            }
				        }
				    },
				    pageSize: 10
				}); 

				dataSource.read();
			}

		</script>

		<!-- Enquiry Result Grid -->
		<div id="enquiryResultsGrid"></div>

		<table width="100%" style="background-color:#DBE5F1; overflow-x:scroll; display: none; padding-left: 7px" cellpadding="0" id="listTable2" cellspacing="0">
			<tr>
				<td colspan="6" style="background-color:#8DB4E3; width:100%">
				<b><div id="filterTable">Action By Batch For Batch Upload</div></b></td>
			</tr>
			<tr>
				<td><br></td>
			</tr>
			<tbody>
				<tr>
					<td>Batch ID</td>
					<td>
						<select class="select_join" id="batchIdList" onChange="selectedValue(this)" name="batchIdList" type="text" style="width: 500px">
						</select>
					</td>
					<td></td>
				</tr>
				<tr><td><br></td></tr>
				<!-- http://lxdapp25:8080/ERMSCore/limitapplication/getPendingRemarksDetails?userId=RISKADMIN&batchId=BAT01&batchId=BAT02 -->
				<tr>
					<td></td>
					<td></td>
					<td>
						<input type="button" class="k-button" id="batchDiscard" onclick="onClickOpenRemarkWindow('D')"  value="Batch Discard"></input>
						<input type="button" class="k-button" id="batchSubmit" onclick="onClickOpenRemarkWindow('S')" value="Batch Submit"></input>
						<input type="button" class="k-button" id="batchReturn" onclick="onClickOpenRemarkWindow('R')"  value="Batch Return"></input>
						<input type="button" class="k-button" id="batchApprove" onclick="onClickOpenRemarkWindow('A')"  value="Batch Approve"></input>
						<input type="button" class="k-button" id="batchReject" onclick="onClickOpenRemarkWindow('J')"  value="Batch Reject"></input>
					</td>
				</tr>
				<tr>
					<td><br></td>
				</tr>
				<tr>
					<td></td>
					<td><b>Message</b> : <div id="returnMessage2"></div></td>
					<td >
						<div>
							<input type="button" class="k-button" id="discard" 	onclick="onClickOpenRemarkWindow2('D')"  value="Discard"></input>
							<input type="button" class="k-button" id="submit" 	onclick="onClickOpenRemarkWindow2('S')" 	value="Submit"></input>
							<input type="button" class="k-button" id="return" 	onclick="onClickOpenRemarkWindow2('R')"  value="Return"></input>
							<input type="button" class="k-button" id="approve" 	onclick="onClickOpenRemarkWindow2('A')"  value="Approve"></input>
							<input type="button" class="k-button" id="reject" 	onclick="onClickOpenRemarkWindow2('J')"  value="Reject"></input>
							<input type="button" class="k-button" id="export" 	onclick=""  value="Export"></input>
						</div>
					</td>
				</tr>
				<tr>
					<td><br></td>
				</tr>
			</tbody>
		</table>
		<script>

		function closeRemarkWindow2(){
			$("#remarkWindow2").data("kendoWindow").close();
		}

		</script>
		<div id="remarkWindow2" align="right">
			<input type="hidden" id="batchType2"></input>
			<input type="hidden" id="batchIdTemp2"></input>

			<input type="button" class="k-button" value="Back" onclick="closeRemarkWindow2()"></input>
			<input type="button" class="k-button" value="Proceed" onclick="onProceed()"></input>

			<br><br>
			<div id="getPendingRemarksDetailsGrid"></div>
			<br>
			<br>
		</div>

		<script>
			function selectedValue(selectopt){
				console.log(selectopt.options[selectopt.selectedIndex].value);
				$("#batchIdTemp").val(selectopt.options[selectopt.selectedIndex].value);
			}
		</script>

		<!-- Pending Request Grid -->
		<div id="pendingRequestGrid"></div>

		<!-- Popup Boxes -->
		<div id="searchWindow">

		    <table id="listTable" width="95%" style="background-color:#DBE5F1; overflow-x:scroll; border-bottom; position: absolute; border-collapse: collapse; " cellpadding="0" cellspacing="0">
		        <tr>
		            <td colspan="3" style="background-color:#8DB4E3; width:100%">
		                <b><div id="filterTable" onclick="">(+) Filter Criteria</div></b>
		            </td>
		        </tr>
		        <tbody style="display: block">
		            <tr>
		                <td>Group Name.</td>
		                <td><input class="k-textbox" id="groupName2" name="groupName2" type="text"/></td>
		                <td>Group Type.</td>
		                <td><input class="k-textbox" id="groupType2" name="groupType2" type="text"/></td>
		            </tr>
		            <tr><td><br></td></tr>
		            <tr><td><br></td></tr>
		            <tr>
		                <td></td>
		                <td></td>
		                <td colspan="2"><b></b></td>
		                <td>
		                    <button class="k-button" type="button" onclick="clickSearchGroup()">Search</button>
		                    <button class="k-button" id="resetBtn" type="button" onclick="toReset('group')">Reset</button>
		                </td>
		            </tr>
		        </tbody>
		        <tr>
		            <td colspan="4">
		                 <div id="grid"></div>
		            </td>
		        </tr>
		    </table>
		</div>

		<div id="searchWindow2">

		    <table id="listTable" width="95%" style="background-color:#DBE5F1; overflow-x:scroll; border-bottom; position: absolute; border-collapse: collapse; " cellpadding="0" cellspacing="0">
		        <tr>
		            <td colspan="3" style="background-color:#8DB4E3; width:100%">
		                <b><div id="filterTable" onclick="">(+) Filter Criteria</div></b>
		            </td>
		        </tr>
		        <tbody style="display: block">
		            <tr>
		                <td>Client / Counter Party</td>
		                <td><input class="k-textbox" id="legalPartyCat" name="legalPartyCat" type="text"/></td>
		                <td>Name</td>
		                <td><input class="k-textbox" id="ccptyName" name="ccptyName" type="text"/></td>
		            </tr>
		            <tr><td><br></td></tr>
		            <tr><td><br></td></tr>
		            <tr>
		                <td></td>
		                <td></td>
		                <td colspan="2"><b></b></td>
		                <td>
		                    <button class="k-button" type="button" onclick="clickSearchCcpty()">Search</button>
		                    <button class="k-button" id="resetBtn" type="button" onclick="toReset('ccpty')">Reset</button>
		                </td>
		            </tr>
		        </tbody>
		        <tr>
		            <td colspan="4">
		                 <div id="grid2"></div>
		            </td>
		        </tr>
		    </table>
		</div>
		<div id="searchWindow3">

		    <table id="listTable" width="95%" style="background-color:#DBE5F1; overflow-x:scroll; border-bottom; position: absolute; border-collapse: collapse; " cellpadding="0" cellspacing="0">
		        <tr>
		            <td colspan="3" style="background-color:#8DB4E3; width:100%">
		                <b><div id="filterTable" onclick="">(+) Filter Criteria</div></b>
		            </td>
		        </tr>
		        <tbody style="display: block">
		            <tr>
		                <td>Account No.</td>
		                <td><input class="k-textbox" id="acctNo" name="acctNo" type="text"/></td>
		                <td>Name</td>
		                <td><input class="k-textbox" id="acctName" name="acctName" type="text"/></td>
		            </tr>
		            <tr>
		                <td>Sub-Account No.</td>
		                <td><input class="k-textbox" id="subAcctNo" name="subAcctNo" type="text"/></td>
		                <td></td>
		                <td></td>
		            </tr>
		            <tr><td><br></td></tr>
		            <tr><td><br></td></tr>
		            <tr>
		                <td></td>
		                <td></td>
		                <td colspan="2"><b></b></td>
		                <td>
		                    <button class="k-button"  type="button" onclick="clickSearchAccount()">Search</button>
		                    <button class="k-button" id="resetBtn" type="button" onclick="toReset('acct')">Reset</button>
		                </td>
		            </tr>
		        </tbody>
		        <tr>
		            <td colspan="4">
		                 <div id="grid3"></div>
		            </td>
		        </tr>
		    </table>
		</div>

		<div id="remarkWindow">
			
			<input type="hidden" id="batchType"></input>
			<input type="hidden" id="batchIdTemp"></input>

		    <table id="listTable" border="0" width="100%" style="background-color:#DBE5F1; overflow-x:scroll; border-bottom; position: absolute; border-collapse: collapse; " cellpadding="0" cellspacing="0">
		        <tr>
		            <td colspan="3" style="background-color:#8DB4E3; width:100%">
		                <b><div id="filterTable" onclick="">(+) Filter Criteria</div></b>
		            </td>
		        </tr>
		        <tbody style="display: block"  height="500px">
		        	<tr><td><br></td></tr>
		        	<tr>
		        	    <td></td>
		        	    <td></td>
		        	    <td colspan="4"><b></b></td>
		        	    <td>
		        	        <button class="k-button" type="button" onclick="confirmSave()">Confirm</button>
		        	        <button class="k-button" id="resetBtn" type="button" onclick="closePopup()" >Cancel</button>
		        	    </td>
		        	</tr>
		        	<tr><td><br></td></tr>
		        	<tr><td><br></td></tr>
		            <tr>
		                <td>Remarks Category.</td>
		                <td colspan="2">
			                <select class="select_join" id="remarkCat" name="remarkCat" style="width: 500px">
			                </select>
		                </td>
		                <td>Remarks</td>
		                <td colspan="2">
		                	<input class="k-textbox" id="remark" name="remark" type="text"/><input type="button" id="add" value="Add" class="k-button" onclick="addToContent()"></input>
		                </td>
		            </tr>
		            <tr><td><br></td></tr>
		            <tr><td><br></td></tr>
		            <tr>
		                <td>Remarks Content</td>
		                <td colspan="5">
			                <select id="remarkContent" class="select_join" multiple style="width: 100%; height: 300px"></select>
		                </td>
		            </tr>
		        </tbody>
		    </table>
		</div>

		<div id="remarkWindow3">
			
			<input type="hidden" id="tmpBatchId"></input>

		    <table id="listTable" border="0" width="100%" style="background-color:#DBE5F1; overflow-x:scroll; border-bottom; position: absolute; border-collapse: collapse; " cellpadding="0" cellspacing="0">
		        <tr>
		            <td colspan="3" style="background-color:#8DB4E3; width:100%">
		                <b><div id="filterTable" onclick="">(+) Filter Criteria</div></b>
		            </td>
		        </tr>
		        <tbody style="display: block"  height="500px">
		        	<tr><td><br></td></tr>
		        	<tr>
		        	    <td></td>
		        	    <td></td>
		        	    <td colspan="4"><b></b></td>
		        	    <td>
		        	        <button class="k-button" type="button" onclick="addToRemarkContentOfGrid()">Confirm</button>
		        	        <button class="k-button" id="resetBtn" type="button" onclick="closePopup2()" >Cancel</button>
		        	    </td>
		        	</tr>
		        	<tr><td><br></td></tr>
		        	<tr><td><br></td></tr>
		            <tr>
		                <td>Remarks Category.</td>
		                <td colspan="2">
			                <select class="select_join" id="remarkCat2" name="remarkCat2" style="width: 500px">
			                </select>
		                </td>
		                <td>Remarks</td>
		                <td colspan="2">
		                	<input class="k-textbox" id="remark2" name="remark2" type="text"/><input type="button" id="add" value="Add" class="k-button" onclick="addToContent2()"></input>
		                </td>
		            </tr>
		            <tr><td><br></td></tr>
		            <tr><td><br></td></tr>
		            <tr>
		                <td>Remarks Content</td>
		                <td colspan="5">
			                <select id="remarkContent2" class="select_join" multiple style="width: 100%; height: 300px"></select>
		                </td>
		            </tr>
		        </tbody>
		    </table>
		</div>
		<div id="historyWindow">
			
		    <table id="listTable" border="0" width="100%" style="background-color:#DBE5F1; overflow-x:scroll; border-bottom; position: absolute; border-collapse: collapse; " cellpadding="0" cellspacing="0">
		        <tr>
		            <td colspan="4" style="background-color:#8DB4E3; width:100%">
		                <b><div id="filterTable" onclick="">CR Detail</div></b>
		            </td>
		        </tr>
		        <tbody style="display: block" >
		        	<tr><td colspan="4"><br></td></tr>
		        	<tr>
		        	    <td width="33.3%">Group Id</td>
		        	    <td width="10.3%">:</td>
		        	    <td width="33.3%"><div id="groupIdHistory"></div></td>
		        	    <td width="33.3%"></td>
		        	</tr>
		        	<tr>
		        	    <td width="33.3%">Client / Counterparty ID</td>
		        	    <td width="10.3%">:</td>
		        	    <td width="33.3%"><div id="ccdIdHistory"></div></td>
		        	    <td width="33.3%"></td>
		        	</tr>
		        	<tr>
		        	    <td width="33.3%">Approval Matric Option </td>
		        	    <td width="10.3%">:</td>
		        	    <td width="33.3%"><div id="approvalMatrixOptionHistory"></div></td>
		        	    <td width="33.3%"></td>
		        	</tr>
		        	<tr>
		        	    <td width="33.3%">Approval Matric BU</td>
		        	    <td width="10.3%">:</td>
		        	    <td width="33.3%"><div id="approvalMatrixBuHistory"></div></td>
		        	    <td width="33.3%"></td>
		        	</tr>
		        	<tr><td colspan="4"><br></td></tr>
		        	<tr><td colspan="4"><br></td></tr>
		        	<tr>
		        		<td colspan="4">
		        			<div id="historyGrid"></div>
		        		</td>
		        	</tr>
		        </tbody>
		        
		    </table>
		</div>

    </body>

    <script>

    $(document).ready(function () {

    	initializeLmtType();
    	initialLoadBusinessUnit();
    	clearDropDownWithoutBlank("batchIdList");
    	onLoadGetBatchIdList("Y");
		
		$("#fromExistLmtExpiryDate").kendoDatePicker({
			value: "",
			format: "yyyy/MM/dd"
		});
		$("#fromExistLmtExpiryDate").attr("readonly", "readonly");

		$("#fromNewLmtExpiryDate").kendoDatePicker({
			value: "",
			format: "yyyy/MM/dd"
		});
		$("#fromNewLmtExpiryDate").attr("readonly", "readonly");

		$("#fromRequestDate").kendoDatePicker({
			value: "",
			format: "yyyy/MM/dd"
		});
		$("#fromRequestDate").attr("readonly", "readonly");

		$("#toExistLmtExpiryDate").kendoDatePicker({
			value: "",
			format: "yyyy/MM/dd"
		})
		$("#toExistLmtExpiryDate").attr("readonly", "readonly");

		$("#toNewLmtExpiryDate").kendoDatePicker({
			value: "",
			format: "yyyy/MM/dd"
		})
		$("#toNewLmtExpiryDate").attr("readonly", "readonly");

		$("#toRequestDate").kendoDatePicker({
			value: "",
			format: "yyyy/MM/dd"
		})
		$("#toRequestDate").attr("readonly", "readonly");

    });

    function initialLoadBusinessUnit(){

    	var getBusinessUnit = "/ermsweb/resources/js/businessunit.json";

    	var dataSource = new kendo.data.DataSource({
    	    transport: {
    	        read: {
    	            type: "GET",
    	            async: false,
    	            url: getBusinessUnit,   
    	            cache: false,                       
    	            dataType: "json",
    	            xhrFields: {
    	                withCredentials: true
    	            },
    	            complete: function(response, status){
    	                if(status == "success"){
    	                	$.each(JSON.parse(response.responseText), function(key, value) {
    	                		fillInToDropDown("bizUnit", value.text, value.value);
    	                	});
    	                }   
    	            }
    	        }
    	    },  
    	    schema: { 
    	        model:{
    	            id: "guarId",
    	            fields:{
    	                guarId: {type: "string"},
    	                guarName : {type: "string"},
    	                guarDomicile : {type: "string"}
    	            }
    	        }
    	    },
    	    pageSize: 10
    	}); 

    	dataSource.read();
    }

    function createCheckBoxes(isRoot, batchId){
    	if(isRoot == "Y"){
    		return "<div align=\"center\"><input type=\"checkbox\" id=\"\" name=\"groupCheck\" value=\"" + batchId + "\"></input></div>";
    	}else{
    		return "";
    	}
    }

    function scanGridCheckbox(gridId){
    	console.log("Scan Checkbox2"); 
    	var getFormat = "";
    	for (var i = 0; i < document.getElementsByName("groupCheck").length; i++) {
    		if(document.getElementsByName("groupCheck")[i].checked == true){
    			getFormat += "&batchId=" + document.getElementsByName("groupCheck")[i].value;
    			$("#batchIdTemp2").val(document.getElementsByName("groupCheck")[i].value);
    		}
    	};
    	console.log(getFormat);
    	return getFormat;
    }

    function initialLoadLimitType(){

    	var getLimitType = "";

    	var dataSource = new kendo.data.DataSource({
    	    transport: {
    	        read: {
    	            type: "GET",
    	            async: false,
    	            url: getLimitType,   
    	            cache: false,                       
    	            dataType: "json",
    	            xhrFields: {
    	                withCredentials: true
    	            },
    	            complete: function(response, status){
    	                if(status == "success"){
    	                	fillInToDropDown("lmtTypeDesc", "-", "");
    	                	$.each(JSON.parse(response.responseText), function(key, value) {
    	                		fillInToDropDown("lmtTypeDesc", value.text, value.value);
    	                	});
    	                }   
    	            }
    	        }
    	    },  
    	    schema: { 
    	        model:{
    	            id: "guarId",
    	            fields:{
    	                guarId: {type: "string"},
    	                guarName : {type: "string"},
    	                guarDomicile : {type: "string"}
    	            }
    	        }
    	    },
    	    pageSize: 10
    	}); 

    	dataSource.read();
    }

    function initialLoadAnnualLimitReview(){

    	var limitApplicationStatus = "";

    	var dataSource = new kendo.data.DataSource({
    	    transport: {
    	        read: {
    	            type: "GET",
    	            async: false,
    	            url: limitApplicationStatus,   
    	            cache: false,                       
    	            dataType: "json",
    	            xhrFields: {
    	                withCredentials: true
    	            },
    	            complete: function(response, status){
    	                if(status == "success"){
    	                	$.each(JSON.parse(response.responseText), function(key, value) {
    	                		fillInToDropDown("lmtTypeDesc", value.text, value.value);
    	                	});
    	                }   
    	            }
    	        }
    	    },  
    	    schema: { 
    	        model:{
    	            id: "guarId",
    	            fields:{
    	                guarId: {type: "string"},
    	                guarName : {type: "string"},
    	                guarDomicile : {type: "string"}
    	            }
    	        }
    	    },
    	    pageSize: 10
    	}); 

    	dataSource.read();
    }

    function initialLoadBatchUpload(){

    	var batchUpload = "";

    	var dataSource = new kendo.data.DataSource({
    	    transport: {
    	        read: {
    	            type: "GET",
    	            async: false,
    	            url: batchUpload,   
    	            cache: false,                       
    	            dataType: "json",
    	            xhrFields: {
    	                withCredentials: true
    	            },
    	            complete: function(response, status){
    	                if(status == "success"){
    	                	$.each(JSON.parse(response.responseText), function(key, value) {
    	                		fillInToDropDown("lmtTypeDesc", value.text, value.value);
    	                	});
    	                }   
    	            }
    	        }
    	    },  
    	    schema: { 
    	        model:{
    	            id: "guarId",
    	            fields:{
    	                guarId: {type: "string"},
    	                guarName : {type: "string"},
    	                guarDomicile : {type: "string"}
    	            }
    	        }
    	    },
    	    pageSize: 10
    	}); 

    	dataSource.read();
    }

    function initialLoadsalesCode(){

    	var salesCode = "";

    	var dataSource = new kendo.data.DataSource({
    	    transport: {
    	        read: {
    	            type: "GET",
    	            async: false,
    	            url: salesCode,   
    	            cache: false,                       
    	            dataType: "json",
    	            xhrFields: {
    	                withCredentials: true
    	            },
    	            complete: function(response, status){
    	                if(status == "success"){
    	                	$.each(JSON.parse(response.responseText), function(key, value) {
    	                		fillInToDropDown("lmtTypeDesc", value.text, value.value);
    	                	});
    	                }   
    	            }
    	        }
    	    },  
    	    schema: { 
    	        model:{
    	            id: "guarId",
    	            fields:{
    	                guarId: {type: "string"},
    	                guarName : {type: "string"},
    	                guarDomicile : {type: "string"}
    	            }
    	        }
    	    },
    	    pageSize: 10
    	}); 

    	dataSource.read();
    }

    function clickSearchGroup(){

        var dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url:window.sessionStorage.getItem('serverPath')+"groupDetail/searchGroups?userId="+window.sessionStorage.getItem("username")+"&rmdGroupDesc="+document.getElementById('groupName2').value+"&groupTypeDesc="+document.getElementById('groupType2').value,
                    type: "GET",
                    dataType: "json",
                    xhrFields: {
                        withCredentials: true
                    }
                }
            },
            schema: {
                model: {
                    fields: {
                       rmdGroupId: { type: "string" },
                       groupTypeDesc: { type: "string" },
                       rmdGroupDesc: { type: "string" }
                    }
                }
            },
            pageSize: 11
        });
        $('#grid').kendoGrid({
            dataSource: dataSource,
            filterable: false,
            columnMenu: false,
            sortable: true,
            pageable: {
                refresh: true,
                pageSize: 5
            },
            scrollable: true,
            columns: [  
                { field: "", title: "" ,width: 80, template: "#=selectGroupAction(rmdGroupId, groupTypeDesc, rmdGroupDesc)#"},
                { field: "rmdGroupId", title: "Group ID" ,width: 200},
                { field: "groupTypeDesc", title: "Group Type" ,width: 200},
                { field: "rmdGroupDesc", title: "Group Name" ,width: 200}
            ]
         });
    }
    function clickSearchCcpty(){

        var dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url:window.sessionStorage.getItem('serverPath')+"legalParty/searchLegalPartiesGroup?userId="+window.sessionStorage.getItem("username")+"&ccdName="+$("#ccptyName").val()+"&legalPartyCat="+$("#legalPartyCat").val(),
                    type: "GET",
                    dataType: "json",
                    xhrFields: {
                        withCredentials: true
                    }
                }
            },
            schema: {
                model: {
                    fields: {
                       rmdGroupId: { type: "string" },
                       groupTypeDesc: { type: "string" },
                       rmdGroupDesc: { type: "string" }
                    }
                }
            },
            pageSize: 11
        });
        $('#grid2').kendoGrid({
            dataSource: dataSource,
            filterable: false,
            columnMenu: false,
            sortable: true,
            pageable: {
                refresh: true,
                pageSize: 5
            },
            scrollable: true,
            columns: [  
                { field: "", title: "" ,width: 80, template: "#=selectCcptyAction(ccdId, ccdNameEng, rmdGroupId)#"},
                { field: "rmdGroupDesc", title: "Group Name" ,width: 200},
                { field: "ccdNameEng", title: "Client/Counter Party Name" ,width: 200},
                { field: "ccdId", title: "CCD ID" ,width: 200},
                { field: "legalPartyCat", title: "legal Party Cat" ,width: 200},
                { field: "cmdClientId", title: "CMD Client ID", width: 200},
                { field: "externalKey1", title: "externalKey1", width: 200},
                { field: "externalKey2", title: "externalKey2", width: 200},
                { field: "externalKey3", title: "externalKey3", width: 200},
                { field: "externalKey4", title: "externalKey4", width: 200},
                { field: "externalKey5", title: "externalKey5", width: 200},
                { field: "externalKey6", title: "externalKey6", width: 200},
                { field: "externalKey7", title: "externalKey7", width: 200},
                { field: "externalKey8", title: "externalKey8", width: 200},
                { field: "externalKey9", title: "externalKey9", width: 200},
                { field: "externalKey10", title: "externalKey10", width: 200}
            ]
         });
    }

    function clickSearchAccount(){

        var dataSource = new kendo.data.DataSource({
            transport: {
                read: {
                    url:window.sessionStorage.getItem('serverPath')+"acct/searchAccountsGroup?userId="+window.sessionStorage.getItem("username")+"&accountNo="+$("#acctNo").val()+"&accName="+$("#acctName").val()+"&subAcc="+$("#subAcctNo").val(),
                    type: "GET",
                    dataType: "json",
                    xhrFields: {
                        withCredentials: true
                    }
                }
            },
            schema: {
                model: {
                    fields: {
                       rmdGroupId: { type: "string" },
                       groupTypeDesc: { type: "string" },
                       rmdGroupDesc: { type: "string" }
                    }
                }
            },
            pageSize: 11
        });
        $('#grid3').kendoGrid({
            dataSource: dataSource,
            filterable: false,
            columnMenu: false,
            sortable: true,
            pageable: {
                refresh: true,
                pageSize: 5
            },
            scrollable: true,
            columns: [  
                { field: "", title: "" ,width: 80, template: "#=selectAccountAction(ccdId, acctId, rmdGroupId, subAcc)#"},
                { field: "rmdGroupDesc", title: "Group Name" ,width: 200},
                { field: "ccdId", title: "CCD ID" ,width: 200},
                { field: "acctId", title: "Account No", width: 200},
                { field: "subAcc", title: "subAccountNo", width: 200},
                { field: "accNameEng", title: "accNameEng", width: 200}
            ]
         });
    }

    function selectGroupAction(rmdGroupId, groupTypeDesc, rmdGroupDesc){
        return "<input class='k-button' type='button' onclick='changeGroupFieldsValue(\""+rmdGroupId+"\", \""+rmdGroupDesc+"\")' value='Select'/>";
    }

    function selectCcptyAction(ccdId, ccdNameEng, rmdGroupId){
        return "<input class='k-button' type='button' onclick='changeCcptyFieldsValue(\""+ccdId+"\",\""+ccdNameEng+"\", \""+rmdGroupId+"\")' value='Select'/>";
    }

    function selectAccountAction(ccdId, accountNo, rmdGroupId, subAccountNo){
        return "<input class='k-button' type='button' onclick='changeAccountFieldsValue(\""+ccdId+"\",\""+accountNo+"\", \""+rmdGroupId+"\",\""+subAccountNo+"\")' value='Select'/>";
    }

    function changeGroupFieldsValue(rmdGroupId, rmdGroupDesc){
        $("#rmdGroupId").val(checkUndefinedElement(rmdGroupId));
        $("#ccdId").val("");
        $("#groupName").val(checkUndefinedElement(rmdGroupDesc));
        $("#searchWindow").data("kendoWindow").close();
    }

    function changeCcptyFieldsValue(ccdId, ccdNameEng, rmdGroupId){
        $("#CcptyName").val(checkUndefinedElement(ccdNameEng));
        $("#rmdGroupId").val(checkUndefinedElement(rmdGroupId));
        $("#ccdId").val(checkUndefinedElement(ccdId));
        $("#searchWindow2").data("kendoWindow").close();
    }

    function changeAccountFieldsValue(ccdId, accountNo, rmdGroupId, subAccountNo){
        $("#accountNo").val(checkUndefinedElement(accountNo));  
        $("#subAccountNo").val(checkUndefinedElement(subAccountNo));
        $("#rmdGroupId").val(checkUndefinedElement(rmdGroupId));
        $("#ccdId").val(checkUndefinedElement(ccdId));
        $("#searchWindow3").data("kendoWindow").close();
    }

    function toNext(){
        alert("\nAccount No. :" + $("#accountNo").val() + "\nSub-Account No. :" + $("#subAccountNo").val() + "\ngroupId : " + $("#groupId").val() + "\nccdId :" + $("#ccdId").val() + "\nbizUnit :" + $("#bizUnit").val() + "\napprMatrixOpt : " + $("#apprMatrixOpt").val());
    }

    function toReset(scope){
        if(scope == "group"){
            $("#groupName").val("");
            $("#groupType2").val("");
            clickSearchGroup();
        }else if(scope == "ccpty"){
            $("#ccpty").val("");
            $("#ccptyName").val("");
            clickSearchCcpty();
        }else if(scope == "acct"){
            $("#acctNo").val("");
            $("#subAcctNo").val("");
            $("#acctName").val("");     
            clickSearchAccount();
        }
        $("#rmdGroupId").val("");
        $("#ccdId").val("");
    }

    function containsOnSelectOpts(selectOpt, tmpValue, tmpValue2){

    	var selectBox = document.getElementById(selectOpt);

    	for (var i = 0; i < selectBox.options.length; i++) { 

    		var tmpArr = selectBox.options[i].value.split("||");
    		console.log(tmpArr);
    	 	if(tmpArr[0] == tmpValue){
    	 		if(tmpArr[1] == tmpValue2){
    	 			return true;
    	 		}
    	 	}
    	} 

    	return false;
    }


    function addToContent(){

    	if(!containsOnSelectOpts("remarkContent", $("#remarkCat").val(),$("#remark").val())){
    		fillInToDropDown("remarkContent", $("#remarkCat").val() + "||" + $("#remark").val(), "Remarks Category : "+document.getElementById("remarkCat").options[document.getElementById("remarkCat").selectedIndex].innerHTML + " , Remarks : " + $("#remark").val());
    	}else{
    		console.log("Duplicated ! ");
    	}
    }

    function addToContent2(){

    	if(!containsOnSelectOpts("remarkContent2", $("#remarkCat2").val(),$("#remark2").val())){
    		fillInToDropDown("remarkContent2", $("#remarkCat2").val() + "||" + $("#remark2").val(), "Remarks Category : "+document.getElementById("remarkCat2").options[document.getElementById("remarkCat2").selectedIndex].innerHTML + " , Remarks : " + $("#remark2").val());
    	}else{
    		console.log("Duplicated ! ");
    	}
    }

    function confirmSave(){

    	var jsonStringFormat = "[{";

    	jsonStringFormat += "\"userId\" : \"" + window.sessionStorage.getItem("username")+"\",";
    	jsonStringFormat += "\"groupHier\" : null,";
    	jsonStringFormat += "\"batchId\" : \"" + $("#batchIdTemp").val() + "\",";
    	
		jsonStringFormat += "\"batchRemarkResult\" : [";

    	var remarkContent = document.getElementById("remarkContent");


    	for (var i = 0; i < remarkContent.length; i++) {
			var tmparr = remarkContent[i].value.split("||");
			jsonStringFormat += "{ \"remark\" : \"" + tmparr[1] + "\", \"remarkCat\" : \"" + tmparr[0]  + "\"},";
    	};
    	jsonStringFormat = jsonStringFormat.substring(0, jsonStringFormat.length - 1);
    	jsonStringFormat += "], ";
		jsonStringFormat += "\"action\" : \"" + $("#batchType").val() + "\"}]";
    	
    	console.log(jsonStringFormat);

    	var dataSource = new kendo.data.DataSource({
    	    transport: {
    	        read: function (options){
	               $.ajax({
	                   	type: "POST",
	                   	url: window.sessionStorage.getItem('serverPath')+"limitapplication/batchAction",
	                   	data: jsonStringFormat,
	                   	contentType: "application/json; charset=utf-8",
	                   	dataType: "json",
	                  	success: function (result) {
	                   	    options.success(result);
	                   	},
	                   	complete: function (jqXHR, textStatus){
							if(textStatus == "success"){
								$.each(JSON.parse(jqXHR.responseText), function(key, value) {
									
									if(value.status == "SUCCESS"){
										document.getElementById("returnMessage2").style.color = "green";
										document.getElementById("returnMessage2").innerHTML = value.Message;
										 
									}else if(value.status == "FAILED"){

										document.getElementById("returnMessage2").style.color = "red";
										document.getElementById("returnMessage2").innerHTML = value.Message;

									}else{
										document.getElementById("returnMessage2").style.color = "black";
										document.getElementById("returnMessage2").innerHTML = value.Message;
									}
									

								});
								$("#remarkWindow").data("kendoWindow").close();	
								onClickSubmit();
							}
						},
						error: function(e){
							document.getElementById("returnMessage2").style.color = "red";
							document.getElementById("returnMessage2").innerHTML = "Update Failed : At least 1 row on assigned list.";

							onClickSubmit();
						},
	                	xhrFields: {
				    		withCredentials: true
				    	}
	               	});
    	        }
    	    },
    	    schema: {
    	        model: {
    	            fields: {
    	               rmdGroupId: { type: "string" },
    	               groupTypeDesc: { type: "string" },
    	               rmdGroupDesc: { type: "string" }
    	            }
    	        }
    	    },
    	    pageSize: 11
    	});
    	dataSource.read();
    }

    </script>

</html>