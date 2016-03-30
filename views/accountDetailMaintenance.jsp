<!DOCTYPE html>

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
	
<script src="/ermsweb/resources/js/common_tools.js"></script>
<!-- jQuery JavaScript -->
<script src="/ermsweb/resources/js/jquery.min.js"></script>

<!-- Kendo UI combined JavaScript -->
<script src="/ermsweb/resources/js/kendo.all.min.js"></script>
<script src="/ermsweb/resources/js/common_tools.js"></script>

<!-- <head>Enquiry Loan Sub-Participation Ratio</head> -->
<script src="/ermsweb/resources/js/jszip.min.js"></script>

<script type="text/javascript">
	// used to sync the exports
	  var promises = [
		$.Deferred(),
		$.Deferred()
	  ];

	  var getAccountsCrDetailsURL = window.sessionStorage.getItem('serverPath')+"acct/getDetailsChangeRequest?userId="+window.sessionStorage.getItem("username");

	  var getAccountDetailsURL = window.sessionStorage.getItem('serverPath')+"acct/getDetails?userId="+window.sessionStorage.getItem("username");

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
		document.getElementById("groupName").value = checkUndefinedElement(sessionStorage.getItem("groupName"));
		document.getElementById("groupType").value = checkUndefinedElement(sessionStorage.getItem("groupType"));
		document.getElementById("ccdId").value = checkUndefinedElement(sessionStorage.getItem("ccdId"));
		document.getElementById("cmdClientId").value = checkUndefinedElement(sessionStorage.getItem("cmdClientId"));
		document.getElementById("ccdName").value = checkUndefinedElement(sessionStorage.getItem("ccdName"));
		document.getElementById("accountNo").value = checkUndefinedElement(sessionStorage.getItem("accountNo"));
		document.getElementById("subAcc").value = checkUndefinedElement(sessionStorage.getItem("subAcc"));
		document.getElementById("accName").value = checkUndefinedElement(sessionStorage.getItem("accName"));
		document.getElementById("accBizUnit").value = checkUndefinedElement(sessionStorage.getItem("accBizUnit"));
		document.getElementById("returnMessage").innerHTML = checkUndefinedElement(window.sessionStorage.getItem("message"));

		if(document.getElementById("returnMessage").innerHTML === "success"){
			document.getElementById("returnMessage").style.color = "green";
		}else{
			document.getElementById("returnMessage").style.color = "red";
		}

		if(getURLParameters() == 'Y'){
			toReset();
		}else{
			toSubmit();	
		}

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
        						window.sessionStorage.setItem("message", "");
								toSubmit();
								document.getElementById('result1Title').style.display = "block";
								document.getElementById('result2Title').style.display = "block";
        					}
        					else{
        						alert("Atleast One Field is Required");
        					}
				
			}
		});
		
		//Reset button click
		$("#resetBtn").kendoButton({
			click: function(){
				$("#groupName").val("");
				$("#groupType").val("");
				$("#ccdId").val("");
				$("#cmdClientId").val("");
				$("#ccdName").val("");
				$("#accountNo").val("");
				$("#subAcc").val("");
				$("#accName").val("");
				$("#accBizUnit").val("");
				$("#returnMessage").html("");
				window.sessionStorage.removeItem("groupName");
				window.sessionStorage.removeItem("groupType");
				window.sessionStorage.removeItem("ccdId");
				window.sessionStorage.removeItem("cmdClientId");
				window.sessionStorage.removeItem("ccdName");
				window.sessionStorage.removeItem("accountNo");
				window.sessionStorage.removeItem("subAcc");
				window.sessionStorage.removeItem("accName");
				window.sessionStorage.removeItem("accBizUnit");
				window.sessionStorage.removeItem("message");
				//$("#returnMessage").html("");
				//$(".grid-container").find("tbody").html("<tr><td>&nbsp;</td></tr>");
			}
		});
		
		
		//Export button click
		$("#exportBtn").kendoButton({
			click: function(){
				toExport();
			}
		});
	});
	function getURLParameters(paramName){
		var objPastToPager = null;
		var params = window.location.search.substr(location.search.indexOf("?")+1);
		return params.split("=")[1];
	}
	/* Handle underfined / null element */
	function checkUndefinedElement(element){
		if(element === null || element === "undefined"){
			return "";
		}else{
			return element;
		}
	}
	
	function toReset(){
		$("#groupName").val("");
		$("#groupType").val("");
		$("#ccdId").val("");
		$("#cmdClientId").val("");
		$("#ccdName").val("");
		$("#accountNo").val("");
		$("#subAcc").val("");
		$("#accName").val("");
		$("#accBizUnit").val("");
		document.getElementById("returnMessage").innerHTML = "";
		window.sessionStorage.removeItem("groupName");
		window.sessionStorage.removeItem("groupType");
		window.sessionStorage.removeItem("ccdId");
		window.sessionStorage.removeItem("cmdClientId");
		window.sessionStorage.removeItem("ccdName");
		window.sessionStorage.removeItem("accountNo");
		window.sessionStorage.removeItem("subAcc");
		window.sessionStorage.removeItem("accName");
		window.sessionStorage.removeItem("accBizUnit");
		window.sessionStorage.removeItem("message");
	}
	//Displaying Data in the Grids
	function toExport(){
		var searchCriteria = {
			groupType:$('#groupType').val(),groupName:$('#groupName').val(),ccdId:$('#ccdId').val(),cmdClientId:$('#cmdClientId').val(),ccdName:$('#ccdName').val(),accountNo:$('#accountNo').val(),subAcc:$('#subAcc').val(),accName:$('#accName').val(),accBizUnit:$('#accBizUnit').val()
		};
	     var ds1 = new kendo.data.DataSource({
	        transport: {
	           	read: {
	               	url:getAccountDetailsURL, 
	             	type: "GET",
	             	dataType: "json",
	             	
    			    xhrFields: {
			    		withCredentials: true
			    	},
			    	data: searchCriteria
	           	}
	         },
			error:function(e){
				if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
			},
	         schema: {
	           model: {
	             fields: {
	               ccdId: { type: "string" },
	               cmdCustId: { type: "string" },
	               legalPartyName: { type: "string" },
	               acctId: { type: "string" },
	               acctName: { type: "string" },
	               acctClientType: { type: "string" },
	               guaranteeEntity: { type: "string" },
	               externalKey1: { type: "string" },
	               externalKey2: { type: "string" },
	               externalKey3: { type: "string" },
	               externalKey4: { type: "string" },
	               externalKey5: { type: "string" },
	               externalKey6: { type: "string" },
	               externalKey7: { type: "string" },
	               externalKey8: { type: "string" },
	               externalKey9: { type: "string" },
	               externalKey10: { type: "string" },
	               lastUpdateBy: { type: "string" },
	               lastUpdateDt: { type: "string" }
	             }
	           }
	         }
	     });

	     var ds2 = new kendo.data.DataSource({
	         transport: {
	            read: {
	               	url:getAccountsCrDetailsURL,
	               	type: "GET",
	               	dataType: "json",
	               	
	               	xhrFields: {
			    		withCredentials: true
			    	},
			    	data: searchCriteria
	            }
	         },
	         error:function(e){
					if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
				},
	         schema: {
	           model: {
	             fields: {
	               ccdId: { type: "string" },
	               cmdCustId: { type: "string" },
	               legalPartyName: { type: "string" },
	               acctId: { type: "string" },
	               acctName: { type: "string" },
	               acctClientType: { type: "string" },
	               guaranteeEntity: { type: "string" },
	               externalKey1: { type: "string" },
	               externalKey2: { type: "string" },
	               externalKey3: { type: "string" },
	               externalKey4: { type: "string" },
	               externalKey5: { type: "string" },
	               externalKey6: { type: "string" },
	               externalKey7: { type: "string" },
	               externalKey8: { type: "string" },
	               externalKey9: { type: "string" },
	               externalKey10: { type: "string" },
	               status: { type: "string" },
	               crBy: { type: "string" }
	             }
	           }
	         }
	    });

	    var rows1 = [{
	        cells: [
				{ value: "CCDID" },
				{ value: "CMD Client ID" },
				{ value: "Client/Counterparty Name" },
				{ value: "Account ID" },
				{ value: "Account Name" },
				{ value: "Account Client Type" },
				{ value: "Entity of Guarantee In Favor" },
				{ value: "External Key 1" },
				{ value: "External Key 2" },
				{ value: "External Key 3" },
				{ value: "External Key 4" },
				{ value: "External Key 5" },
				{ value: "External Key 6" },
				{ value: "External Key 7" },
				{ value: "External Key 8" },
				{ value: "External Key 9" },
				{ value: "External Key 10" },
				{ value: "Updated By" },
				{ value: "Last Updated" }
	        ]
	    }];

	    var rows2 = [{
	        cells: [
	          	{ value: "CCDID" },
				{ value: "CMD Client ID" },
				{ value: "Client/Counterparty Name" },
				{ value: "Account ID" },
				{ value: "Account Name" },
				{ value: "Account Client Type" },
				{ value: "Entity of Guarantee In Favor" },
				{ value: "External Key 1" },
				{ value: "External Key 2" },
				{ value: "External Key 3" },
				{ value: "External Key 4" },
				{ value: "External Key 5" },
				{ value: "External Key 6" },
				{ value: "External Key 7" },
				{ value: "External Key 8" },
				{ value: "External Key 9" },
				{ value: "External Key 10" },
				{ value: "Status" },
				{ value: "Updated By" }
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
	                    { autoWidth: true }
	                ],
                    title: "Account RMD Detail List",
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
	                    { autoWidth: true }
	                ],
                    title: "Account RMD Change Request List",
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
              		 { value: data[i].ccdId},
					{ value: data[i].cmdCustId},
					{ value: data[i].legalPartyName},
					{ value: data[i].acctId},
					{ value: data[i].acctName},
					{ value: data[i].acctClientType},
					{ value: data[i].guaranteeEntity},
					{ value: data[i].externalKey1},
					{ value: data[i].externalKey2},
					{ value: data[i].externalKey3},
					{ value: data[i].externalKey4},
					{ value: data[i].externalKey5},
					{ value: data[i].externalKey6},
					{ value: data[i].externalKey7},
					{ value: data[i].externalKey8},
					{ value: data[i].externalKey9},
					{ value: data[i].externalKey10},
					{ value: data[i].lastUpdateBy},
					{ value: toDateFormat(data[i].lastUpdateDt)}
	            ]
	          });
	        }
	        kendo.saveAs({dataURI: workbook.toDataURL(), fileName: "Acct_Main_Lists.xlsx"}); 
	    });

		for (var i = 0; i < 10000000; i++) {
		};

	    ds2.fetch(function(){

	        var data2 = ds2.view();

	        for (var i = 0; i < data2.length; i++){
	          //push single row for every record
	          rows2.push({
	            cells: [
	             { value: data2[i].ccdId},
					{ value: data2[i].cmdCustId},
					{ value: data2[i].legalPartyName},
					{ value: data2[i].acctId},
					{ value: data2[i].acctName},
					{ value: data2[i].acctClientType},
					{ value: data2[i].guaranteeEntity},
					{ value: data2[i].externalKey1},
					{ value: data2[i].externalKey2},
					{ value: data2[i].externalKey3},
					{ value: data2[i].externalKey4},
					{ value: data2[i].externalKey5},
					{ value: data2[i].externalKey6},
					{ value: data2[i].externalKey7},
					{ value: data2[i].externalKey8},
					{ value: data2[i].externalKey9},
					{ value: data2[i].externalKey10},
					{ value: data2[i].status},
					{ value: data2[i].crBy},
	            ]
	          });
	        }
	        //save the file as Excel file with extension xlsx
	        
	    });
			
	}

	function dataGrids(){
		
		$(".empty-height").hide();

		openModal();
		
		var searchCriteria = {
			groupType:$('#groupType').val(),groupName:$('#groupName').val(),ccdId:$('#ccdId').val(),cmdClientId:$('#cmdClientId').val(),ccdName:$('#ccdName').val(),accountNo:$('#accountNo').val(),subAcc:$('#subAcc').val(),accName:$('#accName').val(),accBizUnit:$('#accBizUnit').val()
		};
		
		var activeDataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: getAccountDetailsURL,
					dataType: "json",
					xhrFields: {
			    		withCredentials: true
			    	},
					data:searchCriteria,
					async: false,
					cache: false	
				}
			},
			schema: {                               
                total: function(argument) { 
                	try{
                    	var totalRow = argument[0].total ;
                    	document.getElementById("returnMessage").innerHTML = window.sessionStorage.getItem("message");
                    	return totalRow;
                    }catch(err){
                    	window.sessionStorage.setItem("message", "No Records");
                    	document.getElementById("returnMessage").innerHTML = window.sessionStorage.getItem("message");
                    	window.sessionStorage.setItem("message", "")
                    	return 0;
                    }
                }
        	},
			pageSize: 5
		});
		
		
		
		var changeRequestDataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: getAccountsCrDetailsURL,
					dataType: "json",
					xhrFields: {
				    	withCredentials: true
				    },
					data:searchCriteria,
					async: false,
					cache: false
				}
			},
			pageSize: 5
		});
		
		
		$("#active-account-list").kendoGrid({
			excel: {
				 allPages: true
			},
			dataSource: activeDataSource,
				pageSize: 1,
			/* schema: {
			  model: {
				fields: {
				  ccdId: { type: "string" },
				  cmdCustId: { type: "string" },
				  legalPartyName: { type: "string" },
				  acctId: { type: "number" },
				  acctName: { type: "string" },
				  acctClientType: { type: "string" },
				  guaranteeEntity: { type: "string" },
				  externalKey1: { type: "string" },
				  externalKey2: { type: "string" },
				  externalKey3: { type: "string" },
				  externalKey4: { type: "string" },
				  externalKey5: { type: "string" },
				  externalKey6: { type: "string" },
				  externalKey7: { type: "string" },
				  externalKey8: { type: "string" },
				  externalKey9: { type: "string" },
				  externalKey10: { type: "string" },
				  crBy: { type: "string" },
				  lastUpdateDt: { type: "string" },
				  action: { type: "string" }			  
				}
			  }
			} */
			scrollable:true,
			pageable: {
                refresh: true,
                pageSize: 5
            },
			excelExport: function(e) {
				e.preventDefault();
				promises[0].resolve(e.workbook);
			},
			columns: [
				{ field: "ccdId", title: "CCD ID", autoWidth:true},
				{ field: "cmdCustId",title: "CMD Client ID",autoWidth:true},
				{ field: "legalPartyName",  title: "Client/Counterparty Name",autoWidth:true},
				{ field: "acctId",title: "Account No.",autoWidth:true},
				{ field: "acctName", title: "Account - Name",autoWidth:true},
				{ field: "acctClientType",title: "Account-Client Type",  autoWidth:true},
				{ field: "guaranteeEntity",title: "Entity of Guarantee In Favor", autoWidth:true},
				{ field: "externalKey1",title: "External_Key_ID_1",autoWidth:true},
				{ field: "externalKey2",title: "External_Key_ID_2",autoWidth:true},
				{ field: "externalKey3",title: "External_Key_ID_3",autoWidth:true},
				{ field: "externalKey4",title: "External_Key_ID_4",autoWidth:true},
				{ field: "externalKey5",title: "External_Key_ID_5", autoWidth:true},
				{ field: "externalKey6", title: "External_Key_ID_6",autoWidth:true},
				{ field: "externalKey7", title: "External_Key_ID_7",autoWidth:true},
				{ field: "externalKey8", title: "External_Key_ID_8", autoWidth:true},
				{ field: "externalKey9",  title: "External_Key_ID_9",autoWidth:true},
				{ field: "externalKey10", title: "External_Key_ID_10",autoWidth:true},
				{ field: "crBy", title: "Updated_by", autoWidth:true},
				{ field: "lastUpdateDt", title: "Last Updated",autoWidth:true, template: "#=toDateFormat(lastUpdateDt)#"},
				{ field: "action", title: "Action",template:"#=replaceActionGraphics('|',false, action, acctId, bizUnit, bookEntity, dataSourceAppId)#", autoWidth:true}					
			]	
		});
				
		$("#cr-account-list").kendoGrid({
				dataSource: changeRequestDataSource,
					pageSize: 1,
					schema: {
					  model: {
						fields: {
						  ccdId: { type: "string" },
						  cmdCustId: { type: "string" },
						  legalPartyName: { type: "string" },
						  acctId: { type: "number" },
						  acctName: { type: "string" },
						  acctClientType: { type: "string" },
						  guaranteeEntity: { type: "string" },
						  externalKey1: { type: "string" },
						  externalKey2: { type: "string" },
						  externalKey3: { type: "string" },
						  externalKey4: { type: "string" },
						  externalKey5: { type: "string" },
						  externalKey6: { type: "string" },
						  externalKey7: { type: "string" },
						  externalKey8: { type: "string" },
						  externalKey9: { type: "string" },
						  externalKey10: { type: "string" },
						  status: { type: "string" },
						  crBy: { type: "string" },
						  action: { type: "string" }					  
						}
					  }
					},
				scrollable:true,
				pageable: {
                    refresh: true,
                    pageSize: 5
                },
				excelExport: function(e) {
					e.preventDefault();
					promises[1].resolve(e.workbook);
				},
				columns: [
					{ field: "ccdId", title: "CCD ID", autoWidth:true},
					{ field: "cmdCustId",title: "CMD Client ID",autoWidth:true},
					{ field: "legalPartyName",  title: "Client/Counterparty Name",autoWidth:true},
					{ field: "acctId",title: "Account No.",autoWidth:true},
					{ field: "acctName", title: "Account - Name",autoWidth:true},
					{ field: "acctClientType",title: "Account-Client Type",  autoWidth:true},
					{ field: "guaranteeEntity",title: "Entity of Guarantee In Favor", autoWidth:true},
					{ field: "externalKey1",title: "External_Key_ID_1",autoWidth:true},
					{ field: "externalKey2",title: "External_Key_ID_2",autoWidth:true},
					{ field: "externalKey3",title: "External_Key_ID_3",autoWidth:true},
					{ field: "externalKey4",title: "External_Key_ID_4",autoWidth:true},
					{ field: "externalKey5",title: "External_Key_ID_5", autoWidth:true},
					{ field: "externalKey6", title: "External_Key_ID_6",autoWidth:true},
					{ field: "externalKey7", title: "External_Key_ID_7",autoWidth:true},
					{ field: "externalKey8", title: "External_Key_ID_8", autoWidth:true},
					{ field: "externalKey9",  title: "External_Key_ID_9",autoWidth:true},
					{ field: "externalKey10", title: "External_Key_ID_10",autoWidth:true},
					{ field: "status",title: "Status", autoWidth:true},
					{ field: "crBy", title: "Updated_by",autoWidth:true},
					{ field: "action",title: "Action", template:"#=replaceActionGraphics('|',true , action, acctId, bizUnit, bookEntity, dataSourceAppId, crId)#", autoWidth:true}					
				]
		});
		closeModal();
	}
	
	function toSubmit(){
		var input = $("input:text, select");
		var valid=0;
		for(var i=0;i<input.length;i++){
			if($.trim($(input[i]).val()).length > 0){
				valid = valid + 1;
			}
		}
		if(valid >0){
			dataGrids();
			document.getElementById("returnMessage").innerHTML = window.sessionStorage.getItem("message");
		}
		else{
			dataGrids();
			document.getElementById("returnMessage").innerHTML = "No Records";
		}		
		
		window.sessionStorage.setItem('groupName',document.getElementById("groupName").value);
		window.sessionStorage.setItem('groupType',document.getElementById("groupType").value);
		window.sessionStorage.setItem('ccdId',document.getElementById("ccdId").value);
		window.sessionStorage.setItem('cmdClientId',document.getElementById("cmdClientId").value);
		window.sessionStorage.setItem('ccdName',document.getElementById("ccdName").value);
		window.sessionStorage.setItem('accountNo',document.getElementById("accountNo").value);
		window.sessionStorage.setItem('subAcc',document.getElementById("subAcc").value);
		window.sessionStorage.setItem('accName',document.getElementById("accName").value);
		window.sessionStorage.setItem('accBizUnit',document.getElementById("accBizUnit").value);		
	}

	function replaceActionGraphics(delim, crStatus, data, acctId, bizUnit, bookEntity, dataSourceAppId, crId){
		if(data!=null){
			var spltarr = data;
			var split_string = "";
			
			if(spltarr != "" && spltarr != undefined && spltarr != null){
				if (new RegExp("V").test(spltarr)){
						if(!crStatus){
							split_string = split_string+"<a href='/ermsweb/viewAccountDetails?acctId="+acctId+"&userId="+window.sessionStorage.getItem("username")+"&bizUnit="+bizUnit+"&bookEntity="+bookEntity+"&dataSourceAppId="+dataSourceAppId+"'><img style=\"border-style: none\" src='/ermsweb/resources/images/bg_view.png' width=\"20\" height=\"20\"/></a>";
						}else{
							split_string = split_string+"<a href='/ermsweb/viewCrAccounts?crId="+crId+"&userId="+window.sessionStorage.getItem("username")+"'><img style=\"border-style: none\" src='/ermsweb/resources/images/bg_view.png' width=\"20\" height=\"20\"/></a>";
						}
				}
				if (new RegExp("E").test(spltarr)){
					if(!crStatus){
						split_string = split_string+"<a href='/ermsweb/viewAccountsUpdate?acctId="+acctId+"&userId="+window.sessionStorage.getItem("username")+"&bizUnit="+bizUnit+"&bookEntity="+bookEntity+"&dataSourceAppId="+dataSourceAppId+"'><img style=\"border-style: none\" src='/ermsweb/resources/images/bg_update.png' width=\"20\" height=\"20\"/></a>";
					}else{
						split_string = split_string+"<a href='/ermsweb/viewCrAccountsUpdate?crId="+crId+"&userId="+window.sessionStorage.getItem("username")+"&bizUnit="+bizUnit+"&bookEntity="+bookEntity+"&dataSourceAppId="+dataSourceAppId+"'><img style=\"border-style: none\" src='/ermsweb/resources/images/bg_update.png' width=\"20\" height=\"20\"/></a>";
					}
				}
				if (new RegExp("D").test(spltarr)){
					split_string = split_string+"<a href='/ermsweb/discardAccounts?crId="+crId+"&userId="+window.sessionStorage.getItem("username")+"&bizUnit="+bizUnit+"&bookEntity="+bookEntity+"&dataSourceAppId="+dataSourceAppId+"'><img style=\"border-style: none\" src='/ermsweb/resources/images/bg_discard2.png' width=\"20\" height=\"20\"/></a>";
				}
				if (new RegExp("A").test(spltarr)){
					split_string = split_string+"<a href='/ermsweb/verifyAccounts?crId="+crId+"&userId="+window.sessionStorage.getItem("username")+"&bizUnit="+bizUnit+"&bookEntity="+bookEntity+"&dataSourceAppId="+dataSourceAppId+"'><img style=\"border-style: none\" src='/ermsweb/resources/images/bg_update.png' width=\"20\" height=\"20\"/></a>";
				}
			
				//console.log("split_string: "+split_string);
				return split_string;
			}
		}
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
<body onload="checkSessionAlive()">
	<div class="boci-wrapper">

		<div class="page-title">Account RMD  Maintenance </div>
		<div id="boci-content-wrapper">
			<input type="hidden" id="pagetitle" name="pagetitle"
				value="Account RMD Detail Maintenance">
			<div class="filter-criteria">
				<div id="filter-table-heading" onclick="expandCriteria()">
					<b>(-) Filter Criteria</b>
				</div>
				<table cellpadding="0" cellspacing="0" id="list-table">
					<tbody id="search-filter-body" style="display: block">
						<tr>
							<td>Group Type.</td>
							<td><input id="groupType" class="k-textbox" type="text" /></td>

							<td>Group Name.</td>
							<td><input id="groupName" class="k-textbox" type="text" /></td>

							<td>CCD ID.</td>
							<td><input id="ccdId" class="k-textbox" type="text" /></td>
						</tr>
						<tr>
							<td colspan="6">&nbsp;</td>
						</tr>
						<tr>
							<td>CMD Client ID.</td>
							<td><input id="cmdClientId" class="k-textbox" type="text" /></td>

							<td>Client/Counterparty Name.</td>
							<td><input id="ccdName" class="k-textbox" type="text" /></td>

							<td>Account No.</td>
							<td><input id="accountNo" class="k-textbox" type="text" /></td>
						</tr>
						<tr>
							<td colspan="6">&nbsp;</td>
						</tr>
						<tr>
							<td>Sub-acc.</td>
							<td><input id="subAcc" class="k-textbox" type="text" /></td>

							<td>Account - Name.</td>
							<td><input id="accName" class="k-textbox" type="text" /></td>

							<td>Acc - Biz Unit.</td>
							<td><input id="accBizUnit" class="k-textbox" type="text" /></td>
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
								<button id="resetBtn" class="k-button" type="button">Reset</button>
								<button id="exportBtn" class="k-button" type="button">Export</button>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
							<div id="result1Title" style="background-color: #9C3E3E; color: white; display: none;">
								<label>&nbsp;&nbsp;&nbsp;</label>Account Table
							</div>
						
							<div id="active-account-list"></div>
							<div id="modal">
								<img id="loader" src="/ermsweb/resources/images/ajax-loader.gif" />
							</div>
						


							<div id="result2Title" style="background-color: #9C3E3E; color: white; display: none;">
								<label>&nbsp;&nbsp;&nbsp;</label>Account RMD Change Request
								Table
							</div>
						
							<div id="cr-account-list">
							
							</div>
							<div id="modal1">
								<img id="loader" src="/ermsweb/resources/images/ajax-loader.gif" />
							</div>
						
			</div>
		</div>
	</div>
</body>
</html>
