<!DOCTYPE html>
<html lang="en">
	<meta http-equiv="Content-Style-Type" content="text/css">
    <meta http-equiv="Content-Script-Type" content="text/javascript">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 
    <script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>
    <script type="text/javascript" src="/ermsweb/resources/js/common_tools.js"></script>
   

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

  <!--   <script src="/ermsweb/resources/js/jszip.js"></script> -->
    <!-- Kendo UI combined JavaScript -->
    
    <!-- <script src="http://kendo.cdn.telerik.com/2014.3.1029/js/kendo.all.min.js"></script> -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
    
    <script>
    var fileArray = [];
    var hiddenFields = {};
    $(document).ready(function(){
    	
    	
		var xcollGroupId = getURLParameters('xcollGroupId');
		$(".empty-height").show();
		
		xcollGroupTypeDataSource = [
    	         	               {text:"G10_Chargor-Borrower Group",value:"G10_Chargor-Borrower Group"},
    	         	               {text:"G11_Group Sharing",value:"G11_Group Sharing"},
    	         				]
     			$('#xcollGroupType').kendoDropDownList({
     				dataTextField: "text",
     				dataValueField: "value",
     				dataSource: xcollGroupTypeDataSource,
     				index:0
     			}); 
		
		xcollCapAmtCcyDataSource=    
				[{
	    		"dataField": "hkd",
	    		"dataText": "HKD"
	    	}, {
	    		"dataField": "usd",
	    		"dataText": "USD"
	    	}]
		$("#xcollCapAmtCcy").kendoDropDownList({
			dataTextField: "dataText",
			dataValueField: "dataField",
			dataSource: xcollCapAmtCcyDataSource,
			index:0
	}); 
		
		membershipDataSource = [
			               {text:"Chargor",value:"Chargor"},
			               {text:"Borrower",value:"Borrower"},
			               {text:"Member",value:"Member"}
			               ]
			$('#xcollRole').kendoDropDownList({
				dataTextField: "text",
				dataValueField: "value",
				dataSource: membershipDataSource,
				index:0
			});
			$("#xcollCapAmt").kendoNumericTextBox({
	           min: 0,
	           spinners: false
	        });
			var newDate = new Date();
			$("#xcollExpiryDate").kendoDatePicker({
				value: new Date(newDate.getFullYear() + 1, newDate.getMonth(), newDate.getDate()),
				format: "yyyy/MM/dd"
			});
			$("#docMapList").kendoUpload({
		        async: {
		            saveUrl: window.sessionStorage.getItem('serverPath')+"xcollgroup/uploadDocument?userId="+window.sessionStorage.getItem("username"),
		            autoUpload: true,
		            xhrFields : {
						withCredentials : true
					}
		            
		        },
		        success: onSuccessfulUpload,
		        
		       
		    });
			$("#xcollRole").on("change",function(){
				var perValue = $(this).val();
				if(perValue == "Chargor"){
					$("#xcollCapAmtCcy").data("kendoDropDownList").enable(false);
					$("#xcollCapAmt").data("kendoNumericTextBox").enable(true);
				}else if(perValue=="Member"){
					$("#xcollCapAmtCcy").data("kendoDropDownList").enable(false);
					$("#xcollCapAmt").data("kendoNumericTextBox").enable(true);
				}else{
					$("#xcollCapAmtCcy").data("kendoDropDownList").enable(true);
					$("#xcollCapAmt").data("kendoNumericTextBox").enable(false);
				}
			});
		
    		var xcollGroupdataSource = new kendo.data.DataSource({
			transport: {
				read: {
					//url:"/ermsweb/resources/js/getxcollGroupRecord.json",
					url: window.sessionStorage.getItem('serverPath')+"xcollgroup/getRecord?xcollGroupId="+xcollGroupId+"&userId="+window.sessionStorage.getItem("username"),
					dataType: "json",
					

					xhrFields : {
						withCredentials : true
					},
					type:"GET"
					
				},
				update: {
		            url:window.sessionStorage.getItem('serverPath')+"xcollgroup/save",
		            type: "post",
		            dataType: "json",
		            contentType: "application/json; charset=utf-8", 
		            complete: function (jqXHR, textStatus){
						var response = JSON.parse(jqXHR.responseText);
						if(response.action=="success"){
							toBack();
						}else{
							$(".confirm-del").html(response.message);
						}
					},
					xhrFields: {
		                withCredentials: true
		               }
		        },
                 parameterMap: function(options, operation) {                                 
                     // note that you may need to merge that postData with the options send from the DataSource
                   return JSON.stringify(options);                                 
            	}
			},
			error:function(e){
							if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
						},
			schema: {                               // describe the result format
		        data: function(data) {              // the data which the data source will be bound to is in the values field
		            return [data];
		        },
		        model:{
		        	id:"xcollGroupId"
		        }
		    }		
			
		
		});
	 
    	var previousStatus = "";
    	xcollGroupdataSource.fetch(function(){
				var jsonObj = this.view();
				var groupDataArray = [];
				$.each(jsonObj, function(i){
						$("#xcollGroupId").html("<label>"+validateResponse(jsonObj[i].xcollGroupId)+"</label>");
						$("#xcollGroupType").data("kendoDropDownList").value(validateResponse(jsonObj[i].xcollGroupType));
						$("#xcollGroupName").val(validateResponse(jsonObj[i].xcollGroupName));
						
						$("#created_by").html(validateResponse(jsonObj[i].createBy));
						$("#created_at").html(validateResponse(validDate(jsonObj[i].createDt)));
						$("#updated_by").html(validateResponse(jsonObj[i].lastUpdateBy));
						$("#updated_at").html(validateResponse(validDate(jsonObj[i].lastUpdateDt)));
						$("#verified_by").html(validateResponse(jsonObj[i].verifyBy));
						$("#verified_at").html(validateResponse(validDate(jsonObj[i].verifyDt)));
						$("#crAction").html(validateResponse(jsonObj[i].crAction));
						$("#verifierRemarks").html(jsonObj[i].crRemark);
						var xcollGroupListData = jsonObj[i].xcollGroupMemList;
						
						groupDataArray = jsonObj[i].xcollGroupMemList;
						// Grid data Source and Grid Population code 
				});    	
				
				$.each(groupDataArray, function(i, obj){
					obj.xcollId = i+1;
					obj.changeStatus = "Added";
				});
				
				var xcollGroupData = new kendo.data.DataSource({
						data:groupDataArray,
							schema: {
		    					model:{
		    		            	id:"ccdId"
		    		            }
		    				},
						pageSize:2
					
					});
   	 
		    	   $("#group-list").kendoGrid({
						dataSource: xcollGroupData,
						scrollable:true,
						pageable: true,
						columns: [
									{ field: "xcollRole",  width: 120},
									{ field: "ccdId",  width: 120},
									{ field: "ccdName",  width: 120},
									{ field: "acctId",  width: 120},
									{ field: "subAcctId",  width: 120},
									{ field: "acctStatus",  width: 120},
									{ field: "acctName",  width: 120},
									{ field: "xcollCapAmtCcy",  width: 120},
									{ field: "xcollCapAmt",  width: 120},
									{ field: "xcollExpiryDate",template :"#= kendo.toString(new Date(xcollExpiryDate), 'yyyy/MM/dd')#",  width: 120},
									{ field: "changeStatus",  width: 120},
									{ field: "action", template:"#=ActionGraphics(changeStatus)#", width: 120}
			    				]
					});
					
					$("#xcollAddBtn").kendoButton({
						click: function(){
							var grid = $("#group-list").data("kendoGrid");
						     var count= grid.dataSource.total();
						     xcollGroupData.add({
						    	 	xcollRole:$("#xcollRole").data("kendoDropDownList").value(),
						    	 	ccdId:$("#clientccdId").text(),
						    	 	ccdName:$("#clientccdName").text(),
						    	 	acctId:$("#acctId").text(),
						    	 	subacctId:$("#subacctId").text(),
						    	 	acctStatus:$("#acctStatus").text(),
						    	 	acctName:$("#acctName").text(),
						    	 	xcollCapAmtCcy:$("#xcollCapAmtCcy").data("kendoDropDownList").value(),
						    	 	xcollCapAmt:$("#xcollCapAmt").data("kendoNumericTextBox").value(),
						    	 	xcollExpiryDate:converDateStrFormat($("#xcollExpiryDate").data("kendoDatePicker").value()),
						    	 	changeStatus:"Added",
						    	 	displaySubAcctNo:hiddenFields.displaySubAcctNo,
									bizUnit:hiddenFields.bizUnit,
									bookEntity:hiddenFields.bookEntity,
									dataSourceAppId:hiddenFields.dataSourceAppId,
						    	 	docMapList:fileArray,
		    						xcollId:count+1
							 });
							 toResetFields();
							 
						}
					});
	          		
					$("#xcollUpdateBtn").click(function(){
						
						 //var object = $(this).closest(".form");
						 var index = $("#clientAccountDetails").attr("rowid");
						 console.log($("#clientAccountDetails").attr("rowid"));
	  					var dataDatasource = xcollGroupData.at(index-1);
	  					console.log(dataDatasource);
								dataDatasource.set("xcollRole", $("#xcollRole").data("kendoDropDownList").value());
	  							dataDatasource.set("xcollCapAmtCcy", $("#xcollCapAmtCcy").data("kendoDropDownList").value());
	  							dataDatasource.set("xcollCapAmt", $("#xcollCapAmt").data("kendoNumericTextBox").value());
	  							dataDatasource.set("xcollExpiryDate", $("#xcollExpiryDate").data("kendoDatePicker").value());
	  							dataDatasource.set("changeStatus", "Updated");
	  							dataDatasource.set("docMapList",fileArray);
	  							toResetFields();
	   			
					 });
					$("#group-list").on("click", ".grid-row-delete", function (e) {
						var row = $(e.target).closest("tr");
					    var grid = $("#group-list").data("kendoGrid");
					    var dataItem = grid.dataItem(row);
					    previousStatus = dataItem.changeStatus;
					    var dataDatasource = xcollGroupData.at(dataItem.xcollId-1);
					    dataDatasource.set("changeStatus", "Deleted");
					    dataDatasource.set("action", ActionGraphics("Deleted"));
					});
					$("#group-list").on("click", ".grid-row-undo", function (e) {
						var row = $(e.target).closest("tr");
					    var grid = $("#group-list").data("kendoGrid");
					    var dataItem = grid.dataItem(row);
					    var dataDatasource = xcollGroupData.at(dataItem.xcollId-1);
					    dataDatasource.set("changeStatus",previousStatus);
					});
			});	
    	
	    	$("#group-list").on("click", ".grid-row-update", function (e) {
			    var row = $(e.target).closest("tr");
			    var grid = $("#group-list").data("kendoGrid");
			    var dataItem = grid.dataItem(row);
			    $("#clientAccountDetails").attr("rowid",dataItem.xcollId);
			    console.log($("#clientAccountDetails").attr("rowid"));
			    $("#clientccdId").html("<label>"+validateResponse(dataItem.ccdId)+"</label>");
				$("#clientccdName").html("<label>"+validateResponse(dataItem.ccdName)+"</label>");
				$("#acctName").html("<label>"+validateResponse(dataItem.acctName)+"</label>");
				$("#acctId").html("<label>"+validateResponse(dataItem.acctId)+"</label>");
				$("#subAcctId").html("<label>"+validateResponse(dataItem.subAcctId)+"</label>");
				$("#acctStatus").html("<label>"+validateResponse(dataItem.acctStatus)+"</label>");
				$("#xcollRole").data("kendoDropDownList").value(dataItem.xcollRole);
				$("#xcollCapAmtCcy").data("kendoDropDownList").value(dataItem.xcollCapAmtCcy);
				$("#xcollCapAmt").data("kendoNumericTextBox").value(dataItem.xcollCapAmt);
				$("#xcollExpiryDate").data("kendoDatePicker").value(dataItem.xcollExpiryDate);
				fileArray = [];
				$("#docMapListContainer").empty();
				$.each(dataItem.docMapList, function(i, objVal){
					generateDocs(objVal, true);		
				})
				
			});
	    	
	    	$("#docMapListContainer").on("click", ".file-delete", function (e) {
				
				var fileKeyVal = $(this).closest("div").attr("class");
				$.each(fileArray, function(i){
					console.log(fileArray[i].fileKey +" -- "+fileKeyVal);
					if(fileArray[i].fileKey == fileKeyVal) {
				    	fileArray.splice(i,1);
				        return false;
				    }
				});
				//console.log(fileArray);
				$("."+fileKeyVal).remove();
			});
	    	
			 $("#saveBtn").kendoButton({
					click: function(){
							var dataDatasource = xcollGroupdataSource.at(0);
							xcollGroupdataSource.transport.options.update.url= window.sessionStorage.getItem('serverPath')+"xcollgroup/save";
							dataDatasource.set("xcollGroupType",$("#xcollGroupType").data("kendoDropDownList").value());
							dataDatasource.set("xcollGroupName",$("#xcollGroupName").val());
							dataDatasource.set("crStatus","Saved");
							dataDatasource.set("crAction","UPDATE");
							dataDatasource.set("userId",window.sessionStorage.getItem("username"));
							dataDatasource.set("xcollGroupMemList",gridData());
							xcollGroupdataSource.sync();
						}
					
				});
				$("#submitBtn").kendoButton({
					click: function(){
								var dataDatasource = xcollGroupdataSource.at(0);
								xcollGroupdataSource.transport.options.update.url= window.sessionStorage.getItem('serverPath')+"xcollgroup/submit";
								dataDatasource.set("xcollGroupType",$("#xcollGroupType").data("kendoDropDownList").value());
								dataDatasource.set("xcollGroupName",$("#xcollGroupName").val());
								dataDatasource.set("crStatus","Submit");
								dataDatasource.set("crAction","UPDATE");
								dataDatasource.set("userId",window.sessionStorage.getItem("username"));
								dataDatasource.set("xcollGroupMemList",gridData());
								xcollGroupdataSource.sync();
					}
				});
				//Reset button click-Page-level
				$("#resetBtn").kendoButton({
					click: function(){
						$("#xcollGroupName").val("");
						$("#xcollGroupType").data("kendoDropDownList").value("G10_Chargor-Borrower Group");
						
					}
				});
					//Search button click
					$("#xcollsearchBtn").kendoButton({
						click: function(){
							var input = $(".validate");
							console.log(input);
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
					//Reset button account-search level
					$("#xcollresetBtn").kendoButton({
						click: function(){
							$(".validate").val("");
						}
					});
					
    	});
    
    /*Utility Functions and their definitions*/
    
    function gridData(){
		var result = [];
		result = $("#group-list").data("kendoGrid").dataSource.data();
		console.log(result);
		$.each(result, function(i, obj){
			delete obj.xcollId;
			delete obj.changeStatus;
		});
		return result;
	
	}
    
    function dataGrids(){		
		//$(".empty-height").hide();
		openModal();
		
		var searchCriteria = {
			ccdId:$('#ccdId').val(),
			ccdName:$('#ccdName').val(),
			accName:$('#accName').val(),
			accId:$('#accId').val(),
			userId:window.sessionStorage.getItem("username")
		};		
		
		//var getActiveListDetailsURL = window.sessionStorage.getItem('serverPath')+"xcollgroup/searchClnAcct";
		var getActiveListDetailsURL = "/ermsweb/resources/js/searchClnAccount.json";
		var activeDataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: getActiveListDetailsURL,
					dataType: "json",
					data:searchCriteria,
					xhrFields : {
						withCredentials : true
					},
					complete: function (){
						emptyHeight('active-list');
					} 
				}
			},
			pageSize: 3
		});
		$("#active-list").kendoGrid({
			dataSource: activeDataSource,
			pageSize: 1,
			sortable:false,
			scrollable:false,
			pageable: true,				
			columns:[
				{ field: "ccdId",  width: 120},
				{ field: "ccdName",  width: 120},
				{ field: "acctId",  width: 120},
				{ field: "subAcctId",  width: 120},
				{ field: "acctStatus",  width: 120},
				{ field: "acctName",  width: 120},
				{ field: "dataSourceAppId",  width: 120},
				{ field: "bookEntity",  width: 120},
				{ field: "bizUnit",  width: 120},
				{ field: "" ,title:"", command:{text:"Select",click: showDetails},width: 160},
			]
		});
	
		closeModal();
	}
	
    /* External function called from Grid custom command*/
	function showDetails(e){
		e.preventDefault();
		//var activeSearchBlock = $("input[name='radio_acg']:checked").attr("fieldBlock");
		var dataItem = this.dataItem($(e.currentTarget).closest("tr"));// Returned the selected object
		hiddenFields.displaySubAcctNo = dataItem.displaySubAcctNo;
		hiddenFields.bizUnit = dataItem.bizUnit;
		hiddenFields.bookEntity = dataItem.bookEntity;
		hiddenFields.dataSourceAppId = dataItem.dataSourceAppId;
		$("#clientccdId").html("<label>"+validateResponse(dataItem.ccdId)+"</label>");
		$("#clientccdName").html("<label>"+validateResponse(dataItem.ccdName)+"</label>");
		$("#acctName").html("<label>"+validateResponse(dataItem.acctName)+"</label>");
		$("#acctId").html("<label>"+validateResponse(dataItem.acctId)+"</label>");
		$("#subAcctId").html("<label>"+validateResponse(dataItem.subAcctId)+"</label>");
		$("#acctStatus").html("<label>"+validateResponse(dataItem.acctStatus)+"</label>");
	}
	function onSuccessfulUpload(e){
		//console.log(e.response);
		generateDocs(e.response);
	}
	
	function generateDocs(fileObj, isEdit){
		//console.log(fileObj);
		//console.log(fileArray);
		fileArray.push(fileObj);
		var fileName = "<div class='"+fileObj.fileKey+"'><a href='"+window.sessionStorage.getItem('serverPath')+"xcollgroup/getUploadFile?fileKey="+fileObj.fileKey+"&fileName="+fileObj.fileName+"&userId="+window.sessionStorage.getItem('username')+"&isNew="+fileObj.isNew+"' class='anchor'>"+fileObj.fileName+"</a><a href='javascript:void(0)' ><img  class='file-delete' src='/ermsweb/resources/images/bg_discard.png'/></a></div>";
		$("#docMapListContainer").append(fileName);
	}
	function emptyHeight(checkId){
		if(checkId == 'group-list'){
			if($("#"+checkId).data("kendoGrid").dataSource.total()>0){
				var count = $("#"+checkId).data("kendoGrid").dataSource.total();	
			}else{
				var count = 1;	
			}
		}else{
			var count = $("#"+checkId).data("kendoGrid").dataSource.total();
		}
		console.log(count);
		if (count>0){
			//alert("secondTimecheck");
			$("#"+checkId).find(".empty-height").hide();
		}else{
			$("#"+checkId).find(".empty-height").show();
		}
	}
    /* Open spinner while getting the data from back-end*/
	function openModal() {
		$("#modal, #modal1, #modal2, #modal3").show();
	}
	/* Close spinner after getting the data from back-end*/
	function closeModal() {
		$("#modal, #modal1, #modal2, #modal3").hide();	    
	}
	
	function validDate(obj){
    	return kendo.toString( new Date(parseInt(obj)), "MM/dd/yyyy HH:MM:tt" )
    }
	function validateResponse(data){
		return (data != null) ? data : "";
	}
	function toBack(){
		window.location = "/ermsweb/crossCollateralizationGroupMaintenance";
	}
	function converDateStrFormat(dateStr){
     	 var date = Date.parse(dateStr);
     	return parseInt(kendo.toString( new Date(parseInt(date)), "yyyyMMddHHMMs" ));       
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
	function ActionGraphics(action){
		var split_string = "";
		if(action == 'Added'){
			split_string = split_string+"<a href='javascript:void(0)' class='grid-row-update'><img src='/ermsweb/resources/images/bg_update.png'/></a>"+"<a href='javascript:void(0)' class='grid-row-delete'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
		}else if(action == 'Updated'){
			split_string = split_string+"<a href='javascript:void(0)' class='grid-row-update'><img src='/ermsweb/resources/images/bg_update.png'/></a>"+"<a href='javascript:void(0)' class='grid-row-delete'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";			
		}else if(action =='Deleted'){
			split_string = split_string+"<a href='javascript:void(0)' class='grid-row-undo'><img src='/ermsweb/resources/images/bg_view.png'/></a>";
		}else{
			split_string = split_string+"<a href='javascript:void(0)' class='grid-row-update'><img src='/ermsweb/resources/images/bg_update.png'/></a>"+"<a href='javascript:void(0)' class='grid-row-delete'><img src='/ermsweb/resources/images/bg_discard.png'/></a>";
		}
		return split_string;
	}
	
	function toResetFields(){
		var defaultDate = new Date();
		var resetdate = new Date(defaultDate.getFullYear() + 1, defaultDate.getMonth(), defaultDate.getDate());
		$("#xcollExpiryDate").data("kendoDatePicker").value(resetdate);
		$("#xcollRole").data("kendoDropDownList").value("Borrower");
		$("#xcollCapAmtCcy").data("kendoDropDownList").value("hkd");
		$("#xcollCapAmt").data("kendoNumericTextBox").value("");
		$("#docMapListContainer").empty();		
		$("#clientccdId").html("");
		$("#clientccdName").html("");
		$("#acctName").html("");
		$("#acctId").html("");
		$("#subAcctId").html("");
		$("#acctStatus").html("");
		
		fileArray = [];
		hiddenFields = {};
	}
	
    </script>
    <style>
    	.k-upload-pct{
    		display:none;
    	}
    </style>
    <body>
    	<div class="boci-limitType-wrapper">
    		<header>
    		
    		</header>
    		<div class="createLimit-content-wrapper form">
    			<form id="countryRating_form">
					<div class="page-title">Maintenance - Cross Collateralization Group Maintenance  -  Update Cross Collaterialization Group Change Request</div>	    		
	    			<div class="command-button-Section">
	    				<button id="saveBtn" class="k-button" type="button">Save</button>
	    				<button id="submitBtn" class="k-button" type="button">Submit</button>
	    				<button id="resetBtn" class="k-button toClear" type="button">Clear</button>
	    				<button id="backBtn" class="k-button" type="button" onclick="toBack()">Back</button>
	    			</div>
	    			<div class="confirm-del"></div>
	    			<div class="clear"></div>
	    			<div id="create_details_container" class="detail-section monitor-rule-details">
						<div class="monitor-rule-details-header">
							Cross Collateralization Group Details
						</div>
						<form id="create_newmonitorRule_form">
							<table class="create-details-table">					
								<tr>
									<td class="field-label">GroupId</td>
									<td>
										<div id="xcollGroupId"></div>
									</td>
								</tr>
								<tr>
									<td>GroupType</td>
									<td>
										<input id="xcollGroupType" value="G10_Chargor-Borrower Group"/>
									</td>
								</tr>
								<tr>
									<td>Group Name</td>
									<td><input id="xcollGroupName" type="text" max=100 class="k-textbox"/></td>
								</tr>
								
							</table>
						</form>
					</div>
				<div class="xcoll-search-account-section">
					<div class="filter-criteria form">
						<div id="filter-table-heading" style="margin:0;" onclick="expandCriteria()">(-) Filter Criteria</div>
							<table class="list-table">					
								<tbody id="search-filter-body" style="display: block;">
									<tr>
										<td>Client CCD ID</td>
										<td>&nbsp;</td>
										<td><input id="ccdId" type="text" class="k-textbox validate"/></td>
										<td>&nbsp;</td>
										<td>Client Name</td>
										<td>&nbsp;</td>
										<td><input id="ccdName" type="text" class="k-textbox validate"/></td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td align="right">
											<button id="xcollsearchBtn" class="k-button" type="button">Search</button>
											<button id="xcollresetBtn" class="k-button" type="button">Reset</button>
										</td>
									</tr>
									<tr>
										<td>Acount/Sub Acc No.</td>
										<td>&nbsp;</td>
										<td><input id="accId" type="text" class="k-textbox validate"/></td>
										<td>&nbsp;</td>
										<td>Account Name</td>
										<td>&nbsp;</td>
										<td><input id="accName" type="text" class="k-textbox validate"/></td>
										<td>&nbsp;</td>
									</tr>
								</tbody>
							</table>
					</div>
					<div class="results-section">
						<div class="expo-search-list-header">Result</div>
							<div id="active-list-container">
								<table cellpadding="0" cellspacing="0" border="0" width="100%">		
								<tr>
									<td>
										<div id="active-list">
											<table id="list-header" class="grid-container" width="100%">
												<tr>
													<th>Client  CCD ID</th>
													<th>Client Name</th>
													<th>Account No.</th>
													<th>Sub acc No.</th>
													<th>Account Status</th>
													<th>Account-Name</th>
													<th>Account-Name(chi)</th>
													<th>Acc - Entity</th>
													<th>Acc - Biz Unit</th>											
												</tr>								
											</table>	
																	
										</div>
										
										<div id="modal">
											<img id="loader" src="images/ajax-loader.gif" />
										</div>						
									</td>
								</tr>					
							</table>
						</div>
					</div>
	    		</div>
	    		
	    		<div id="create_details_container" class="detail-section monitor-rule-details">
						<div class="monitor-rule-details-header" id="clientAccountDetails">
							Client Account Details
						</div>
						<form id="create_newmonitorRule_form">
							<table class="create-details-table">					
								<tr>
									<td class="field-label">Client CCD ID</td>
									<td>
										<div id="clientccdId"></div>
									</td>
								</tr>
								<tr>
									<td>Client Name</td>
									<td>
										<div id="clientccdName"></div>
									</td>
								</tr>
								<tr>
									<td>Account Name</td>
									<td>
										<div id="acctName"></div>
									</td>
								</tr>
								<tr>
									<td>Account No.</td>
									<td>
										<div id="acctId"></div>
									</td>
								</tr>
								<tr>
									<td>Sub Acc No.</td>
									<td>
										<div id="subAcctId"></div>
									</td>
								</tr>
								<tr>
									<td>Account Status</td>
									<td>
										<div id="acctStatus"></div>
									</td>
								</tr>
								<tr>
									<td>Cross Collateralization Role</td>
									<td>
										<input id="xcollRole" value="Borrower"></input>
									</td>
								</tr>
								<tr>
									<td>Cross Collateralization Cap Amount Currency</td>
									<td>
										<input id="xcollCapAmtCcy" value="hkd"disabled></input>
									</td>
								</tr>
								<tr>
									<td>Cross Collateralization Cap Amount</td>
									<td>
										<input id="xcollCapAmt" disabled></input>
									</td>
								</tr>
								<tr>
									<td>Cross Collateralization Expiry date</td>
									<td>
										<input id="xcollExpiryDate"></input>
									</td>
								</tr>
								<tr>
									<td>Supporting Documents</td>
									<td>
										<input name="uploadFile" id="docMapList" type="file" />
										<div id="docMapListContainer" >
										</div>
									</td>
								</tr>
								
								<tr>
									<td>&nbsp;</td>
									<td align="right">
										<button id="xcollAddBtn" class="k-button" type="button">Add</button>
				    					<button id="xcollUpdateBtn" class="k-button" type="button">Update</button>
									</td>
								</tr>
								
								
							</table>
						</form>
					</div>
	    			<div id="active-list-container">
						<table cellpadding="0" cellspacing="0" border="0" width="100%">
							<tr>
								<td colspan="8">
									<div class="list-header">Cross Collateralization Group Members</div>
								</td>
							</tr>
							<tr>
								<td>
									<div id="group-list">
										<table id="list-header" class="grid-container" width="100%">
											<tr>
													<th>Role</th>
													<th>Client  CCD ID</th>
													<th>Client Name</th>
													<th>Account No.</th>
													<th>Sub acc No.</th>
													<th>Account Status</th>
													<th>Account-Name</th>
													<th>Cap Amount CCY</th>
													<th>Cap Amount</th>
													<th>Expiry Date</th>
													<th>Change Status</th>
													<th>Action</th>												
											</tr>								
										</table>	
									</div>
									
									<div id="modal">
										<img id="loader" src="images/ajax-loader.gif" />
									</div>						
								</td>
							</tr>					
						</table>
					</div>
					<div class="approval-section margin-top">
					<div id="approval-section-header">Approval</div>
						<table id="approval-section-table">
							<tr>
								<td class="bold">Action performed by Maker:</td>
								<td><label class="bold">Create/Update/Delete of Cross Collateralization Group</label></td>
							</tr>
							<tr>
								<td width="195.5" style="vertical-align:top" class="bold">Remarks</td>
								<td width="300">
									<div style="background-color:#FCD5B4;min-height:80px;"><label id="verifierRemarks">Verifer Reamrks will come here</label></div>
								</td>
							</tr>		
						</table>
					</div>	
					<div class="audit-details-section">
						<table>
						<tr>
							<td>Created By</td>
							<td><label id="created_by"></label></td>
							<td></td>
							<td></td>
							<td>Created At</td>
							<td><label id="created_at"></label></td>
						</tr>
						<tr>
							<td>Updated By</td>
							<td><label id="updated_by"></label></td>
							<td></td>
							<td></td>
							<td>Updated At</td>
							<td><label id="updated_at"></label></td>
						</tr>
						<tr>
							<td>Verified By</td>
							<td><label id="verified_by"></label></td>
							<td></td>
							<td></td>
							<td>Verified At</td>
							<td><label id="verified_at"></label></td>
						</tr>
						<tr>
							<td>Action</td>
							<td><label id="crAction"></label></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
					</table>
					</div>
    		</div>
    		
    	
    	</div>

    </body>
    </html>
    