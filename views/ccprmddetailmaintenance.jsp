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
	
<!-- jQuery JavaScript -->
<script src="/ermsweb/resources/js/jquery.min.js"></script>

<!-- Kendo UI combined JavaScript -->
<script src="/ermsweb/resources/js/kendo.all.min.js"></script>

<!-- <head>Enquiry Loan Sub-Participation Ratio</head> -->
<script src="/ermsweb/resources/js/jszip.min.js"></script>
<script src="/ermsweb/resources/js/common_tools.js"></script>

<script type="text/javascript">
	// used to sync the exports
	  var promises = [
		$.Deferred(),
		$.Deferred()
	  ];

	/*var getCcpDetailsURL = window.sessionStorage.getItem('serverPath')+"acct/getDetailsChangeRequest?userId="+window.sessionStorage.getItem("username");

	var getCcpDetailsURL = window.sessionStorage.getItem('serverPath')+"acct/getDetails?userId="+window.sessionStorage.getItem("username");*/

	var getCcpDetailsURL = window.sessionStorage.getItem('serverPath')+"legalParty/getDetails?userId="+window.sessionStorage.getItem("username")

	var getCcpCrDetailsURL = window.sessionStorage.getItem('serverPath')+"legalParty/getDetailsChangeRequest?userId="+window.sessionStorage.getItem("username");;

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
		document.getElementById("clientCptyName").value = checkUndefinedElement(sessionStorage.getItem("clientCptyName"));
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

		if(getURLParameters("reset") == 'Y'){
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
				$("#clientCptyName").val("");
				$("#accountNo").val("");
				$("#subAcc").val("");
				$("#accName").val("");
				$("#accBizUnit").val("");
				$("#returnMessage").html("");
				window.sessionStorage.removeItem("groupName");
				window.sessionStorage.removeItem("groupType");
				window.sessionStorage.removeItem("ccdId");
				window.sessionStorage.removeItem("cmdClientId");
				window.sessionStorage.removeItem("clientCptyName");
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
	function getURLParameters(){
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
		$("#clientCptyName").val("");
		$("#accountNo").val("");
		$("#subAcc").val("");
		$("#accName").val("");
		$("#accBizUnit").val("");
		document.getElementById("returnMessage").innerHTML = "";
		window.sessionStorage.removeItem("groupName");
		window.sessionStorage.removeItem("groupType");
		window.sessionStorage.removeItem("ccdId");
		window.sessionStorage.removeItem("cmdClientId");
		window.sessionStorage.removeItem("clientCptyName");
		window.sessionStorage.removeItem("accountNo");
		window.sessionStorage.removeItem("subAcc");
		window.sessionStorage.removeItem("accName");
		window.sessionStorage.removeItem("accBizUnit");
		window.sessionStorage.removeItem("message");
	}
	//Displaying Data in the Grids
	function toExport(){
		var searchCriteria = {
			groupType:$('#groupType').val(),groupName:$('#groupName').val(),ccdId:$('#ccdId').val(),cmdClientId:$('#cmdClientId').val(),clientCptyName:$('#clientCptyName').val(),accountNo:$('#accountNo').val(),subAcc:$('#subAcc').val(),accName:$('#accName').val(),accBizUnit:$('#accBizUnit').val()
		};
	     var ds1 = new kendo.data.DataSource({
	        transport: {
	           	read: {
	               	url:getCcpDetailsURL, 
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
	               	ccdId: { type: "string"},
					legalPartyEngName: { type: "string"},
					legalPartyChiName: { type: "string"},
					legalPartyCat: { type: "string"},
					creditRatingInt: { type: "string"},					  
					externalKey1: { type: "string"},
					externalKey2: { type: "string"},
					externalKey3: { type: "string"},
					externalKey4: { type: "string"},
					externalKey5: { type: "string"},
					externalKey6: { type: "string"},
					externalKey7: { type: "string"},
					externalKey8: { type: "string"},
					externalKey9: { type: "string"},
					externalKey10: { type: "string"},
					lastUpdateBy: { type: "string"},
					lastUpdateDt: { type: "string"},
	             }
	           }
	         }
	     });

	     var ds2 = new kendo.data.DataSource({
	         transport: {
	            read: {
	               	url:getCcpDetailsURL,
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
	               	ccdId: { type: "string"},
	               	legalPartyEngName: { type: "string"},
	               	legalPartyChiName: { type: "string"},
	               	legalPartyCat: { type: "string"},
	               	creditRatingInt: { type: "string"},					  
	               	externalKey1: { type: "string"},
	               	externalKey2: { type: "string"},
	               	externalKey3: { type: "string"},
	               	externalKey4: { type: "string"},
	               	externalKey5: { type: "string"},
	               	externalKey6: { type: "string"},
	               	externalKey7: { type: "string"},
	               	externalKey8: { type: "string"},
	               	externalKey9: { type: "string"},
	               	externalKey10: { type: "string"},
	               	status: { type: "string"},
	               	lastUpdateBy: { type: "string"},
	             }
	           }
	         }
	    });

	    var rows1 = [{
	        cells: [
				{value: "CCD ID"},
				{value: "Client/Counterparty Name"},
				{value: "Client/Counterparty Chinese Name"},
				{value: "Client/Counterparty Category"},
				{value: "Internal Credit Rating (Basel)"},
				{value: "External_Key_ID_1"},
				{value: "External_Key_ID_2"},
				{value: "External_Key_ID_3"},
				{value: "External_Key_ID_4"},
				{value: "External_Key_ID_5"},
				{value: "External_Key_ID_6"},
				{value: "External_Key_ID_7"},
				{value: "External_Key_ID_8"},
				{value: "External_Key_ID_9"},
				{value: "External_Key_ID_10"},
				{value: "Updated by"},
				{value: "Last Updated"}
	        ]
	    }];

	    var rows2 = [{
	        cells: [
	          	{value:"CCD ID"},
	          	{value:"Client/Counterparty Name "},
	          	{value:"Client/Counterparty Chinese Name"},
	          	{value:"Client/Counterparty Category"},
	          	{value:"Internal Credit Rating (Basel)"},
	          	{value:"External_Key_ID_1"},
	          	{value:"External_Key_ID_2"},
	          	{value:"External_Key_ID_3"},
	          	{value:"External_Key_ID_4"},
	          	{value:"External_Key_ID_5"},
	          	{value:"External_Key_ID_6"},
	          	{value:"External_Key_ID_7"},
	          	{value:"External_Key_ID_8"},
	          	{value:"External_Key_ID_9"},
	          	{value:"External_Key_ID_10"},
	          	{value:"Status"},
	          	{value:"Updated by"}
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
	                    { autoWidth: true }
	                ],
                    title: "Client Counterparty RMD Detail List",
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
	                    { autoWidth: true }
	                ],
                    title: "Client Counterparty RMD Change Request List",
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
              		{ value: data[i].ccdId },
              		{ value: data[i].legalPartyEngName },
              		{ value: data[i].legalPartyChiName },
              		{ value: data[i].legalPartyCat },
              		{ value: data[i].creditRatingInt },
              		{ value: data[i].externalKey1 },
              		{ value: data[i].externalKey2 },
              		{ value: data[i].externalKey3 },
              		{ value: data[i].externalKey4 },
              		{ value: data[i].externalKey5 },
              		{ value: data[i].externalKey6 },
              		{ value: data[i].externalKey7 },
              		{ value: data[i].externalKey8 },
              		{ value: data[i].externalKey9 },
              		{ value: data[i].externalKey10 },
              		{ value: data[i].lastUpdateBy },
              		{ value: toDateFormat(data[i].lastUpdateDt) }
	            ]
	          });
	        }
	    });

		for (var i = 0; i < 10000000; i++) {
		};

	    ds2.fetch(function(){

	        var data2 = ds2.view();

	        for (var i = 0; i < data2.length; i++){
	          //push single row for every record
	          rows2.push({
	            cells: [
	             	{ value: data2[i].ccdId },
	             	{ value: data2[i].legalPartyEngName },
	             	{ value: data2[i].legalPartyChiName },
	             	{ value: data2[i].legalPartyCat },
	             	{ value: data2[i].creditRatingInt },
	             	{ value: data2[i].externalKey1 },
	             	{ value: data2[i].externalKey2 },
	             	{ value: data2[i].externalKey3 },
	             	{ value: data2[i].externalKey4 },
	             	{ value: data2[i].externalKey5 },
	             	{ value: data2[i].externalKey6 },
	             	{ value: data2[i].externalKey7 },
	             	{ value: data2[i].externalKey8 },
	             	{ value: data2[i].externalKey9 },
	             	{ value: data2[i].externalKey10 },
	             	{ value: data2[i].status },
	             	{ value: toDateFormat(data2[i].lastUpdateBy) }
	            ]
	          });
	        }
	        //save the file as Excel file with extension xlsx
	        kendo.saveAs({dataURI: workbook.toDataURL(), fileName: "CCP_Main_Lists.xlsx"}); 
	    });
			
	}

	function dataGrids(){
		
		$(".empty-height").hide();

		openModal();
		
		var searchCriteria = {
			groupType:$('#groupType').val(),groupName:$('#groupName').val(),ccdId:$('#ccdId').val(),cmdClientId:$('#cmdClientId').val(),clientCptyName:$('#clientCptyName').val(),accountNo:$('#accountNo').val(),subAcc:$('#subAcc').val(),accName:$('#accName').val(),accBizUnit:$('#accBizUnit').val()
		};
		
		var activeDataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: getCcpDetailsURL,
					dataType: "json",
					
					xhrFields: {
				    		withCredentials: true
				    	},
					data:searchCriteria,
					async: false,
					cache: false	
				}
			},
			error:function(e){
				if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
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
					url: getCcpCrDetailsURL,
					dataType: "json",
					
					xhrFields: {
				    	withCredentials: true
				    },
					data:searchCriteria,
					async: false,
					cache: false
				}
			},
			error:function(e){
				if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
			},
			pageSize: 5
		});
		
		
		$("#active-account-list").kendoGrid({
			excel: {
				 allPages: true
			},
			dataSource: activeDataSource,
				pageSize: 1,
			schema: {
			  model: {
				fields: {
				  ccdId: { type: "string"},
				  legalPartyEngName: { type: "string"},
				  legalPartyChiName: { type: "string"},
				  legalPartyCat: { type: "string"},
				  creditRatingInt: { type: "string"},					  
				  externalKey1: { type: "string"},
				  externalKey2: { type: "string"},
				  externalKey3: { type: "string"},
				  externalKey4: { type: "string"},
				  externalKey5: { type: "string"},
				  externalKey6: { type: "string"},
				  externalKey7: { type: "string"},
				  externalKey8: { type: "string"},
				  externalKey9: { type: "string"},
				  externalKey10: { type: "string"},
				  lastUpdateBy: { type: "date"},
				  lastUpdateDt: { type: "date"},
				  action: { type: "string"}	  
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
				promises[0].resolve(e.workbook);
			},
			columns: [
				{ field: "ccdId", autoWidth:true},
				{ field: "legalPartyEngName", autoWidth:true},
				{ field: "legalPartyChiName", autoWidth:true},
				{ field: "legalPartyCat", autoWidth:true},
				{ field: "creditRatingInt", autoWidth:true},
				{ field: "externalKey1", autoWidth:true},
				{ field: "externalKey2", autoWidth:true},
				{ field: "externalKey3", autoWidth:true},
				{ field: "externalKey4", autoWidth:true},
				{ field: "externalKey5", autoWidth:true},
				{ field: "externalKey6", autoWidth:true},
				{ field: "externalKey7", autoWidth:true},
				{ field: "externalKey8", autoWidth:true},
				{ field: "externalKey9", autoWidth:true},
				{ field: "externalKey10", autoWidth:true},
				{ field: "lastUpdateBy", autoWidth:true},
				{ field: "lastUpdateDt", autoWidth:true, template: "#=toDateFormat(lastUpdateDt)#"},
				{ field: "action", template:"#=replaceActionGraphics('|', false, action, ccdId, '')#", autoWidth:true}
				
			]	
		});
				
		$("#cr-account-list").kendoGrid({
				dataSource: changeRequestDataSource,
					pageSize: 1,
					schema: {
					  model: {
						fields: {
						  ccdId: { type: "string"},
						  legalPartyEngName: { type: "string"},
						  legalPartyChiName: { type: "string"},
						  legalPartyCat: { type: "string"},
						  creditRatingInt: { type: "string"},					  
						  externalKey1: { type: "string"},
						  externalKey2: { type: "string"},
						  externalKey3: { type: "string"},
						  externalKey4: { type: "string"},
						  externalKey5: { type: "string"},
						  externalKey6: { type: "string"},
						  externalKey7: { type: "string"},
						  externalKey8: { type: "string"},
						  externalKey9: { type: "string"},
						  externalKey10: { type: "string"},
						  lastUpdateBy: { type: "date"},
						  lastUpdateDt: { type: "date"},
						  action: { type: "string"}					  
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
					{ field: "ccdId", autoWidth:true},
					{ field: "legalPartyEngName", autoWidth:true},
					{ field: "legalPartyChiName", autoWidth:true},
					{ field: "legalPartyCat", autoWidth:true},
					{ field: "creditRatingInt", autoWidth:true},
					{ field: "externalKey1", autoWidth:true},
					{ field: "externalKey2", autoWidth:true},
					{ field: "externalKey3", autoWidth:true},
					{ field: "externalKey4", autoWidth:true},
					{ field: "externalKey5", autoWidth:true},
					{ field: "externalKey6", autoWidth:true},
					{ field: "externalKey7", autoWidth:true},
					{ field: "externalKey8", autoWidth:true},
					{ field: "externalKey9", autoWidth:true},
					{ field: "externalKey10", autoWidth:true},
					{ field: "status", autoWidth:true},
					{ field: "lastUpdateBy", autoWidth:true},
					/*{ field: "lastUpdateDt", autoWidth:true, template: "#=toDateFormat(lastUpdateDt)#"},*/
					{ field: "action", template:"#=replaceActionGraphics('|', true, action ,ccdId, crId)#", autoWidth:true}					
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
		window.sessionStorage.setItem('clientCptyName',document.getElementById("clientCptyName").value);
		window.sessionStorage.setItem('accountNo',document.getElementById("accountNo").value);
		window.sessionStorage.setItem('subAcc',document.getElementById("subAcc").value);
		window.sessionStorage.setItem('accName',document.getElementById("accName").value);
		window.sessionStorage.setItem('accBizUnit',document.getElementById("accBizUnit").value);		
	}

	function replaceActionGraphics(delim, crStatus, data, ccdId, crId){
		if(data!=null){
			var spltarr = data;
			var split_string = "";
			
			if(spltarr != "" && spltarr != undefined && spltarr != null){
				if (new RegExp("V").test(spltarr)){
						if(!crStatus){
							split_string = split_string+"<a href='/ermsweb/viewCounterParty?ccdId="+ccdId+"&userId="+window.sessionStorage.getItem("username")+"'><img style=\"border-style: none\" src='/ermsweb/resources/images/bg_view.png' width=\"20\" height=\"20\"/></a>";
						}else{
							split_string = split_string+"<a href='/ermsweb/viewCrCounterParty?ccdId="+ccdId+"&crId="+crId+"&userId="+window.sessionStorage.getItem("username")+"'><img style=\"border-style: none\" src='/ermsweb/resources/images/bg_view.png' width=\"20\" height=\"20\"/></a>";
						}
				}
				if (new RegExp("E").test(spltarr)){
					if(!crStatus){
						split_string = split_string+"<a href='/ermsweb/viewUpdate?ccdId="+ccdId+"&userId="+window.sessionStorage.getItem("username")+"&crId="+crId+"'><img style=\"border-style: none\" src='/ermsweb/resources/images/bg_update.png' width=\"20\" height=\"20\"/></a>";
					}else{
						split_string = split_string+"<a href='/ermsweb/viewCrUpdate?ccdId="+ccdId+"&crId="+crId+"&userId="+window.sessionStorage.getItem("username")+"'><img style=\"border-style: none\" src='/ermsweb/resources/images/bg_update.png' width=\"20\" height=\"20\"/></a>";
					}
				}
				if (new RegExp("D").test(spltarr)){
					split_string = split_string+"<a href='/ermsweb/viewDiscardCounterParty?crId="+crId+"&userId="+window.sessionStorage.getItem("username")+"&ccdId="+ccdId+"'><img style=\"border-style: none\" src='/ermsweb/resources/images/bg_discard2.png' width=\"20\" height=\"20\"/></a>";
				}
				if (new RegExp("A").test(spltarr)){
					split_string = split_string+"<a href='/ermsweb/viewVerifyCounterParty?crId="+crId+"&userId="+window.sessionStorage.getItem("username")+"&ccdId="+ccdId+"'><img style=\"border-style: none\" src='/ermsweb/resources/images/bg_update.png' width=\"20\" height=\"20\"/></a>";
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
		<%@include file="header1.jsp"%>
	<div class="page-title">Client Counterparty RMD Detail Maintenance </div>
	
		<div id="boci-content-wrapper">
			<!-- <input type="hidden" id="pagetitle" name="pagetitle"
				value="Client Counterparty RMD Detail Maintenance"> -->
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
							<td><input id="clientCptyName" class="k-textbox" type="text" /></td>

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
					<label>&nbsp;&nbsp;&nbsp;</label>Client Counterparty Table
				</div>
			
				<div id="active-account-list">
					
				</div>
				
				<div id="modal">
					<img id="loader" src="/ermsweb/resources/images/ajax-loader.gif" />
				</div>


	
				<div id="result2Title" style="background-color: #9C3E3E; color: white; display: none;">
					<label>&nbsp;&nbsp;&nbsp;</label>Client Counterparty RMD Detail
					change request
				</div>
			
		
				<div id="cr-account-list">
					
				</div>
				
				<div id="modal1">
					<img id="loader" src="/ermsweb/resources/images/ajax-loader.gif" />
				</div>

			
		</div>
	</div>
</body>
</html>
