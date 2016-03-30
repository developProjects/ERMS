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
<script src="/ermsweb/resources/js/common_tools.js"></script>

<!-- Kendo UI combined JavaScript -->
<script src="/ermsweb/resources/js/kendo.all.min.js"></script>
<script src="/ermsweb/resources/js/jszip.min.js"></script>

<!-- <head>Enquiry Loan Sub-Participation Ratio</head> -->

<script>
	 			/* alert("Current Role : " + window.parent.getRole()); */
		$(document).ready(function () {
	
		        	var objPastToPager = null;
		        	var initialLoad = true;
		        	
		        	document.getElementById("groupName").value = checkUndefinedElement(sessionStorage.getItem("groupName"));
		        	document.getElementById("groupType").value = checkUndefinedElement(sessionStorage.getItem("groupType"));
		        	document.getElementById("ccdId").value = checkUndefinedElement(sessionStorage.getItem("ccdId"));
		        	document.getElementById("cmdClientId").value = checkUndefinedElement(sessionStorage.getItem("cmdClientId"));
		        	document.getElementById("ccdName").value = checkUndefinedElement(sessionStorage.getItem("ccdName"));
		        	document.getElementById("accountNo").value = checkUndefinedElement(sessionStorage.getItem("accountNo"));
		        	document.getElementById("subAcc").value = checkUndefinedElement(sessionStorage.getItem("subAcc"));
		        	document.getElementById("accName").value = checkUndefinedElement(sessionStorage.getItem("accName"));
		        	document.getElementById("accBizUnit").value = checkUndefinedElement(sessionStorage.getItem("accBizUnit"));
		        	document.getElementById("returnMessage").innerHTML = checkUndefinedElement(sessionStorage.getItem("message"));

        			if(document.getElementById("returnMessage").innerHTML == "success"){
        				document.getElementById("returnMessage").style.color = "green";
        			}else{
        				document.getElementById("returnMessage").style.color = "red";
        			}

        			if(getURLParameters("reset") == 'Y'){
        				toReset();
  	      			}else{
  	      				submitButtonEvent();	
  	      			}
        		

			        

		        	$("#submitBtn").kendoButton({
		        		click: function(e) {
		        			var input = $("input:text, select");
        					var valid=0;
        					for(var i=0;i<input.length;i++){
        						if($.trim($(input[i]).val()).length > 0){
        							valid = valid + 1;
        						}
        					}
        					if(valid >0){
        						submitButtonEvent();
    		        			document.getElementById("returnMessage").innerHTML = "";
        					}
        					else{
        						alert("Atleast One Field is Required");
        					}
		        			
			            }
			       	});

			       	$("#resetBtn").kendoButton({
			       		click: function(e) {
			       			toReset();
			       		}
			       	});

		       		$("#exportBtn").kendoButton({
                        click:function(){
                        	 /* Initialize the onload */
                             openModal();

	                             var ds1 = new kendo.data.DataSource({
	                                 transport: {
	                                   read: {
	                                       url:window.sessionStorage.getItem('serverPath')+"groupDetail/getDetails?groupType="+document.getElementById('groupType').value+"&groupName="+document.getElementById('groupName').value+"&ccdId="+document.getElementById('ccdId').value+"&cmdClientId="+document.getElementById('cmdClientId').value+"&ccdName="+document.getElementById('ccdName').value+"&accountNo="+document.getElementById('accountNo').value+"&subAcc="+document.getElementById('subAcc').value+"&accName="+document.getElementById('accName').value+"&accBizUnit="+document.getElementById('accBizUnit').value+"&userId="+window.sessionStorage.getItem("username"),

	                                     	type: "GET",
	                                     	dataType: "json",
	                 	    			    xhrFields: {
	                 				    		withCredentials: true
	                 				    	},
	                                   	}
	                                 },
	                                 schema: {
	                                   model: {
	                                     fields: {
	                                       groupTypeDesc: { type: "string" },
	                                       rmdGroupId: { type: "string" },
	                                       rmdGroupDesc: { type: "string" },
	                                       rmdGroupDescChi: { type: "date" },
	                                       lastUpdateDt: { type: "string" },
	                                       lastUpdateBy: { type: "string" },
	                                       total: { type: "string" }
	                                     }
	                                   }
	                                 }
	                             });

	                             var ds2 = new kendo.data.DataSource({
	                                 transport: {
	                                       read: 
	                                       {
	                                       url:window.sessionStorage.getItem('serverPath')+"groupDetail/getDetailsChangeRequest?groupType="+document.getElementById('groupType').value+"&groupName="+document.getElementById('groupName').value+"&ccdId="+document.getElementById('ccdId').value+"&cmdClientId="+document.getElementById('cmdClientId').value+"&ccdName="+document.getElementById('ccdName').value+"&accountNo="+document.getElementById('accountNo').value+"&subAcc="+document.getElementById('subAcc').value+"&accName="+document.getElementById('accName').value+"&accBizUnit="+document.getElementById('accBizUnit').value+"&userId="+window.sessionStorage.getItem("username"),

	                                       	type: "GET",
	                                       	dataType: "json",
	                                       	xhrFields: {
	                 				    		withCredentials: true
	                 				    	},
	                                      }
	                                 },
	                                 schema: {
	                                   model: {
	                                     fields: {
	                                       groupTypeDesc: { type: "string" },
	                                       rmdGroupDesc: { type: "string" },
	                                       rmdGroupDescChi: { type: "string" },
	                                       lastUpdateDt: { type: "string" },
	                                       lastUpdateBy: { type: "string" },
	                                       status: { type: "string" },
	                                       crDt: { type: "string" },
	                                       crId: { type: "string" }
	                                     }
	                                   }
	                                 }
	                            });

	                            var rows1 = [{
	                                cells: [
	                                  { value: "Group Type" },
	                                  { value: "Group Name" },
	                                  { value: "Group Name (CHI)" },
	                                  { value: "Last Update Date" },
	                                  { value: "Last Update By" },
	                                ]
	                            }];

	                            var rows2 = [{
	                                cells: [
	                                  { value: "Group Type" },
	                                  { value: "Group Name" },
	                                  { value: "Group Name (CHI)" },
	                                  { value: "CR Date" },
	                                  { value: "CR By" },
	                                  { value: "Status" },
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
		                                        { autoWidth: true }
		                                    ],
		                                        title: "RMD Group Detail List",
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
		                                        { autoWidth: true }
		                                    ],
		                                        title: "Change Request List",
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
	                                      { value: data[i].groupTypeDesc },
	                                      /*{ value: data[i].rmdGroupId },*/
	                                      { value: data[i].rmdGroupDesc },
	                                      { value: data[i].rmdGroupDescChi },
	                                      { value: toDateFormat(data[i].lastUpdateDt) },
	                                      { value: data[i].lastUpdateBy },
	                                      /*{ value: data[i].total }*/
	                                    ]
	                                  });
	                                }
			                         kendo.saveAs({dataURI: workbook.toDataURL(), fileName: "RMD_GROUP_LISTS.xlsx"}); 
	                            });

								for (var i = 0; i < 10000000; i++) {
								};

	                            ds2.fetch(function(){

	                                var data2 = ds2.view();

	                                for (var i = 0; i < data2.length; i++){
	                                  //push single row for every record
	                                  rows2.push({
	                                    cells: [
	                                      { value: data2[i].groupTypeDesc },
	                                      /*{ value: data2[i].rmdGroupId },*/
	                                      { value: data2[i].rmdGroupDesc },
	                                      { value: data2[i].rmdGroupDescChi },
	                                     /* { value: data2[i].lastUpdateDt },*/
	                                      { value: toDateFormat(data2[i].crDt) },
	                                      { value: data2[i].crBy },
	                                      { value: data2[i].status },
	                                    ]
	                                  });
	                                }
	                                //save the file as Excel file with extension xlsx
	                               
		                        });
										
		                        /* 	Close the onload	*/
		               	       	CloseModal();		
		               		}
						});
				    });
			   
	
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

		// View - V, Update - E, Discard - D, Verify - A, Returned - R //
		/* Get action type from database and to be replaced image icon */
		function replacedByIconOfDetails(groupId, action_types, userId){
			
			var returnImgHTML = "";
							
			if(new RegExp("V").test(action_types)){ 
				if(new RegExp("E").test(action_types) ){
					returnImgHTML += " <a target=\"main_frame\" href=\"groupMaintenanceDetail?action=view|update&rmdGroupId="+groupId+"&userId="+window.sessionStorage.getItem("username")+"\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_view.png\" width=\"20\" height=\"20\"/></a> ";
					returnImgHTML += " <a target=\"main_frame\" href=\"groupMaintenanceDetail?action=update&rmdGroupId="+groupId+"&userId="+window.sessionStorage.getItem("username")+"\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_update.png\" width=\"20\" height=\"20\"/></a> ";
				}else{
					returnImgHTML += " <a target=\"main_frame\" href=\"groupMaintenanceDetail?action=view&rmdGroupId="+groupId+"&userId="+window.sessionStorage.getItem("username")+"\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_view.png\" width=\"20\" height=\"20\"/></a> ";
				}
			}
			return returnImgHTML;
		}
		function getURLParameters(){
		  	var params = window.location.search.substr(location.search.indexOf("?")+1);
		  	return params.split("=")[1];
		}
		function replacedByIconOfCR(crId, action_types, userId){
			
			var returnImgHTML = "";
			
			if(new RegExp("V").test(action_types)){ 
				if(new RegExp("E").test(action_types)){
					returnImgHTML += " <a target=\"main_frame\" href=\"groupMaintenanceChangeRequest?action=view|update&crId="+crId+"&userId="+window.sessionStorage.getItem("username")+"\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_view.png\" width=\"20\" height=\"20\"/></a> ";
					returnImgHTML += " <a target=\"main_frame\" href=\"groupMaintenanceChangeRequest?action=update&crId="+crId+"&userId="+window.sessionStorage.getItem("username")+"\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_update.png\" width=\"20\" height=\"20\"/></a> ";
				}else{
					returnImgHTML += " <a target=\"main_frame\" href=\"groupMaintenanceChangeRequest?action=view&crId="+crId+"&userId="+window.sessionStorage.getItem("username")+"\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_view.png\" width=\"20\" height=\"20\"/></a> ";			
				}
			}
			
			if(new RegExp("A").test(action_types)){ 
				returnImgHTML += " <a style=\"border-style: none\" target=\"main_frame\" href=\"groupMaintenanceChangeRequest?action=verify&crId="+crId+"&userId="+window.sessionStorage.getItem("username")+"\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_update.png\" width=\"20\" height=\"20\"/></a> ";
			}
			if(new RegExp("D").test(action_types)){ 
				returnImgHTML += " <a style=\"border-style: none\" target=\"main_frame\" href=\"groupMaintenanceChangeRequest?action=discard&crId="+crId+"&userId="+window.sessionStorage.getItem("username")+"\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_discard2.png\" width=\"20\" height=\"20\"/></a> ";
			}	
			return returnImgHTML;
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
			document.getElementById("groupName").value = "";
   			document.getElementById("groupType").value = "";
   			document.getElementById("ccdId").value = "";
   			document.getElementById("cmdClientId").value = "";
   			document.getElementById("ccdName").value = "";
   			document.getElementById("accountNo").value = "";
   			document.getElementById("subAcc").value = "";
   			document.getElementById("accName").value = "";
   			document.getElementById("accBizUnit").value = "";
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
   			window.sessionStorage.setItem("message", "");
		}
		
		function openModal() {
		     $("#modal, #modal1").show();
		}

		function closeModal() {
		    $("#modal, #modal1").hide();	    
		}
		function getCookie(key) {  
		   var keyValue = document.cookie.match('(^|;) ?' + key + '=([^;]*)(;|$)');  
		   return keyValue ? keyValue[2] : null;  
		} 

		function getUserId(){
			return ""
		}
		function callback(e) {
		  alert("callback");
		}
		function expandCriteria(){
			var filterBody = document.getElementById("filterBody").style.display;
			if(filterBody == "block"){
				document.getElementById("filterBody").style.display = "none";
				document.getElementById("filterTable").innerHTML = "(+) Filter Criteria";
			}else{
				document.getElementById("filterBody").style.display = "block";
				document.getElementById("filterTable").innerHTML= "(-) Filter Criteria";
			}
		}
		function submitButtonEvent(){

			document.getElementById('result1Title').style.display = "block";
			document.getElementById('result2Title').style.display = "block";

			/*document.getElementById("tableScope1").style.display = "block";
			document.getElementById("tableScope2").style.display = "block";*/
			
	     	/* Delete / Clean rows for refresh the table by delete all of rows */
	     	var oRows = document.getElementById('listTable').getElementsByTagName('tr');
	     	var iRowCount = oRows.length;
	     	
			/* -------------------------------------- Get Details ----------------------------------------- */

	     	var getDetailURL = window.sessionStorage.getItem('serverPath')+"groupDetail/getDetails?groupType="+document.getElementById('groupType').value+"&groupName="+document.getElementById('groupName').value+"&ccdId="+document.getElementById('ccdId').value+"&cmdClientId="+document.getElementById('cmdClientId').value+"&ccdName="+document.getElementById('ccdName').value+"&accountNo="+document.getElementById('accountNo').value+"&subAcc="+document.getElementById('subAcc').value+"&accName="+document.getElementById('accName').value+"&accBizUnit="+document.getElementById('accBizUnit').value+"&userId="+window.sessionStorage.getItem("username"); 
			
	     	
	     	var totalPages = 0, totalPages2 = 0;
	     	var tmpDataSource;
	    	var dataSource = new kendo.data.DataSource({
	    		transport: {
	    			read: {
	    	   		  	type: "GET",
	    	   		  	async: false,
	    			    url: getDetailURL,
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
	                    	document.getElementById("returnMessage").innerHTML = window.sessionStorage.getItem("message");
	                    	document.getElementById("noRecord").innerHTML = "";
	                    	return totalRow;
	                    }catch(err){
	                    	window.sessionStorage.setItem("message", "No Records");
	                    	document.getElementById("noRecord").innerHTML = window.sessionStorage.getItem("message");
	                    	document.getElementById("noRecord").style.color = "red";
	                    	window.sessionStorage.setItem("message", "")
	                    	return 0;
	                    }
	                }
            	},
	    		pageSize: 5,
	    		serverPaging: true,
	    		batch: true
	    	});   

	     	$('#MyGrid1').kendoGrid({
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
	         	 	{ field: "groupTypeDesc", title: "Group Type" ,width: 200},
	         	 	/*{ field: "rmdGroupId" ,width: 200},*/
	         	 	{ field: "rmdGroupDesc", title: "Group Name" ,width: 200},
	         	 	{ field: "rmdGroupDescChi", title: "Group Name (CHI)" ,width: 200},
	         	 	{ field: "lastUpdateDt" ,width: 200, title: "Last Update Date" ,template: "#=toDateFormat(lastUpdateDt)#"},
	         	 	{ field: "lastUpdateBy", title: "Last Update By" ,width: 200},
	         	 	{ field: "action" , title: "Action", width: 200, template: "#=replacedByIconOfDetails(rmdGroupId, action, getUserId())#"}
	     	 	]
	     	 });
	    	//*  -------------------------------------- Get Change Request ----------------------------------------- */
	    	var getCR = window.sessionStorage.getItem('serverPath')+"groupDetail/getDetailsChangeRequest?groupType="+document.getElementById('groupType').value+"&groupName="+document.getElementById('groupName').value+"&ccdId="+document.getElementById('ccdId').value+"&cmdClientId="+document.getElementById('cmdClientId').value+"&ccdName="+document.getElementById('ccdName').value+"&accountNo="+document.getElementById('accountNo').value+"&subAcc="+document.getElementById('subAcc').value+"&accName="+document.getElementById('accName').value+"&accBizUnit="+document.getElementById('accBizUnit').value+"&userId="+window.sessionStorage.getItem("username"); 
	    	
	    	/*var getCR = "http://lxdapp25:8080/ERMSMock/groupDetail/getDetailsChangeRequest";*/

	    	var dataSource2 = new kendo.data.DataSource({
	    		transport: {
	    			read: {
	    	   		  	type: "GET",
	    	   		  	async: false,
	    			    url: getCR,	  
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
	    		pageSize: 5
	    	});   
	    	$('#MyGrid2').kendoGrid({
	     	 	dataSource: dataSource2,
	     	 	filterable: false,
	     	 	columnMenu: false,
	     	 	sortable: true,
	     	 	pageable: {
                    refresh: true,
                    pageSize: 5
                },
	     	 	scrollable: true,
	     	 	columns: [ 	
	         	 	{ field: "groupTypeDesc", title: "Group Type" ,width: 200},
/*	         	 	{ field: "rmdGroupId" ,width: 200},*/
	         	 	{ field: "rmdGroupDesc", title: "Group Name" ,width: 200},
	         	 	{ field: "rmdGroupDescChi", title: "Group Name (CHI)" ,width: 200},
	         	 	{ field: "crDt", title: "Last Update Date" ,width: 200, template: "#=toDateFormat(crDt)#"},
	         	 	{ field: "crBy" ,title: "Last Update By",width: 200},
	         	 	{ field: "status" ,title: "Status", width: 200},
	         	 	{ field: "action" ,title: "Action", width: 200, template: "#=replacedByIconOfCR(crId, action, getUserId())#"}
	     	 	]
	     	 });

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
	
	    </script>

<body onload="checkSessionAlive()">
<%@include file="header1.jsp"%>
<div class="page-title">RMD Group Maintenace List</div>
	<!-- <input type="hidden" id="pagetitle" name="pagetitle"
		value="RMD Group Group Maintenace List">

	<br> -->
	<table id="listTable" width="100%"
		style="background-color: #DBE5F1; overflow-x: scroll;" cellpadding="0"
		cellspacing="0">
		<tr>
			<td colspan="6" style="background-color: #8DB4E3; width: 100%">
				<b><div id="filterTable" onclick="expandCriteria()">(-)
						Filter Criteria</div></b>
			</td>
		</tr>
		<tr>
			<td><br></td>
		</tr>
		<tbody id="filterBody" style="display: block">
			<tr>
				<td>Group Name.</td>
				<td><input class="k-textbox" id="groupName" name="groupName"
					type="text" /></td>
				<td>Group Type.</td>
				<td><input class="k-textbox" id="groupType" name="groupType"
					type="text" /></td>
				<td>CCD ID.</td>
				<td><input class="k-textbox" id="ccdId" name="ccdId"
					type="text" /></td>
				<td></td>
			</tr>
			<tr>
				<td><br></td>
			</tr>
			<tr>
				<td>CMD Client ID.</td>
				<td><input class="k-textbox" id="cmdClientId"
					name="cmdClientId" type="text" /></td>
				<td>Client/Counterparty Name.</td>
				<td><input class="k-textbox" id="ccdName"
					name="ccdName" type="text" /></td>
				<td>Account No.</td>
				<td><input class="k-textbox" id="accountNo" name="accountNo"
					type="text" /></td>
				<td></td>
			</tr>
			<tr>
				<td><br></td>
			</tr>
			<tr>
				<td>Sub - Acc.</td>
				<td><input class="k-textbox" id="subAcc" name="subAcc"
					type="text" /></td>
				<td>Account Name.</td>
				<td><input class="k-textbox" id="accName" name="accName"
					type="text" /></td>
				<td>Acc - Biz Unit.</td>
				<td><input class="k-textbox" id="accBizUnit" name="accBizUnit"
					type="text" /></td>
				<td></td>
			</tr>
			<tr>
				<td><br></td>
			</tr>
			<tr>
				<td><br></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td colspan="2"><b>Result :</b> <br>
				<b><div id="returnMessage"></div></b><b><div id="noRecord" /></div></b></td>
				<td>
					<button class="k-button" id="submitBtn" type="button">Search</button>
					<button class="k-button" id="resetBtn" type="button">Reset</button>
					<button class="k-button" id="exportBtn" type="button">Export</button>
				</td>
			</tr>
		</tbody>
	</table>
	<br>
	<div align="left">
		<!-- Revamped Grid of getDetails  -->
		<div style="width: 99%" id='MyGrid1'>
			<div id="result1Title"
				style="background-color: #9C3E3E; color: white; display: none;">
				<label>&nbsp;&nbsp;&nbsp;</label>Result of Get RMD Group
			</div>
		</div>
		<!-- END -->
		<!-- Revamped Grid of getDetails  -->
		<div style="width: 99%" id='MyGrid2'>
			<div id="result2Title"
				style="background-color: #9C3E3E; color: white; display: none;">
				<label>&nbsp;&nbsp;&nbsp;</label>Result of Get RMD Group Change
				Request
			</div>
		</div>
		<!-- END -->
	</div>
</body>
</html>
