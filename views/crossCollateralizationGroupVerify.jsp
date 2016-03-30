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
    $(document).ready(function(){
    	

		var xcollGroupId = getURLParameters('xcollGroupId');
		var crId = getURLParameters('crId');
		
    	var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					//url:"/ermsweb/resources/js/getxcollGroupRecord.json",
					url: window.sessionStorage.getItem('serverPath')+"xcollgroup/getRecord?userId="+window.sessionStorage.getItem("username")+"&crId="+crId,
					dataType: "json",
					
					xhrFields : {
						withCredentials : true
					},
					type:"GET"
					
				},
				update:{
					type:"POST",
					url: window.sessionStorage.getItem('serverPath')+"xcollgroup/verify",
					dataType: "json",
					contentType:"application/json",
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
				    if (operation != "read") {
				     	return kendo.stringify(options);//JSON.stringify(options);
					}
				}
			},

								error:function(e){
							if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
						},
			schema:{
				 data: function(data) {              // the data which the data source will be bound to is in the values field
		            //console.log(data);
		            return [data];
		        },
			 	model:{
					id:"crId"
				} 
			}
		});
    	
		
			dataSource.fetch(function(){
				var jsonObj = this.view();
				var xcollGroupListData = [];
				$.each(jsonObj, function(i){
					
						$("#xcollGroupId").html("<label>"+validateResponse(jsonObj[i].xcollGroupId)+"</label>");
						$("#xcollGroupType").html("<label>"+validateResponse(jsonObj[i].xcollGroupType)+"</label>");
						$("#xcollGroupName").html("<label>"+validateResponse(jsonObj[i].xcollGroupName)+"</label>");
						$("#verifierRemarks").html(jsonObj[i].crRemark);
						$(".command-button-Section").html("<button id=\"verifyBtn\"  type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" >Verify</button><label>    </label><button id=\"returnBtn\"  type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Return</button><label>    </label><button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Back</button>");

						$("#created_by").html(validateResponse(jsonObj[i].createBy));
						$("#created_at").html(validateResponse(validDate(jsonObj[i].createDt)));
						$("#updated_by").html(validateResponse(jsonObj[i].lastUpdateBy));
						$("#updated_at").html(validateResponse(validDate(jsonObj[i].lastUpdateDt)));
						$("#verified_by").html(validateResponse(jsonObj[i].verifyBy));
						$("#verified_at").html(validateResponse(validDate(jsonObj[i].verifyDt)));
						$("#crAction").html(validateResponse(jsonObj[i].action));
						
						xcollGroupListData = jsonObj[i].xcollGroupMemList;
						
				});
				
						$("#group-list").kendoGrid({
							dataSource: xcollGroupListData,
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
										{ field: "action", template:"#=ActionGraphics()#", width: 120}
				    				]
							
						
						});
						
						
						
						$("#group-list").on("click", ".grid-row-view", function (e) {
						    var row = $(e.target).closest("tr");
						    var grid = $("#group-list").data("kendoGrid");
						    var dataItem = grid.dataItem(row);
						    $("#docMapList").empty();
						    $("#ccdId").html("<label>"+validateResponse(dataItem.ccdId)+"</label>");
							$("#ccdName").html("<label>"+validateResponse(dataItem.ccdName)+"</label>");
							$("#acctName").html("<label>"+validateResponse(dataItem.acctName)+"</label>");
							$("#acctId").html("<label>"+validateResponse(dataItem.acctId)+"</label>");
							$("#subAcctId").html("<label>"+validateResponse(dataItem.subAcctId)+"</label>");
							$("#acctStatus").html("<label>"+validateResponse(dataItem.acctStatus)+"</label>");
							$("#xcollRole").html("<label>"+validateResponse(dataItem.xcollRole)+"</label>");
							$("#xcollCapAmtCcy").html("<label>"+validateResponse(dataItem.xcollCapAmtCcy)+"</label>");
							$("#xcollCapAmt").html("<label>"+validateResponse(dataItem.xcollCapAmt)+"</label>");
							$("#xcollExpiryDate").html("<label>"+validateResponse(validDate(dataItem.xcollExpiryDate))+"</label>");
							$.each(dataItem.docMapList, function(i){
								$("#docMapList").append("<div><a href='"+window.sessionStorage.getItem('serverPath')+"xcollgroup/getUploadFile?fileKey="+dataItem.docMapList[i].fileKey+"&fileName="+dataItem.docMapList[i].fileName+"&userId="+window.sessionStorage.getItem('username')+"&isNew="+dataItem.docMapList[i].isNew+"' >"+validateResponse(dataItem.docMapList[i].fileName)+"</a></div>");	
							});
							
						});
						
						$(".empty-height").hide();
				
				/*Service Calls*/
				$("#verifyBtn").kendoButton({
	    			click: function(){
	    				var dataDatasource = dataSource.at(0);
	    				dataSource.transport.options.update.url= window.sessionStorage.getItem('serverPath')+"xcollgroup/verify";
	    				dataDatasource.set("crStatus","verify");
	    				dataDatasource.set("userId",window.sessionStorage.getItem("username"));
	    				dataDatasource.set("crRemark",$("#verifierRemarks").val()); 
	    				dataSource.sync();
	    			}
	    		});
	      		
	      		$("#returnBtn").kendoButton({
	    			click: function(){    				
	    				var dataDatasource = dataSource.at(0);
	    				dataSource.transport.options.update.url= window.sessionStorage.getItem('serverPath')+"xcollgroup/return";
	    				dataDatasource.set("crStatus","return");
	    				dataDatasource.set("userId",window.sessionStorage.getItem("username"));
	    				dataDatasource.set("crRemark",$("#verifierRemarks").val());
	    				dataSource.sync();
	    			}
	    		});
				
				
				
			});			
	
	});	 
    /* Action - Save button */
	function ActionGraphics(){
		return "<a href='javascript:void(0)' class='grid-row-view'><img src='/ermsweb/resources/images/bg_view.png'/></a>";
    }
	function validateResponse(data){
		return (data != null) ? data : "";
	}
	function validDate(obj){
		return kendo.toString( new Date(parseInt(obj)), "MM/dd/yyyy" )
	}
	function toEdit(xcollGroupId){
		window.location = "/ermsweb/crossCollateralizationGroupChangeRequestUpdate?xcollGroupId="+xcollGroupId;
	}
	function toDiscard(xcollGroupId){
		window.location = "/ermsweb/crossCollateralizationGroupChangeRequestDiscard?xcollGroupId="+xcollGroupId;
	}
	function toBack(){
		//window.history.back();
		window.location = "/ermsweb/crossCollateralizationGroupMaintenance";
	}
	
    </script>
    <body>
    	<div class="boci-wrapper">
    		
    		<div class="content-wrapper">
					<div class="page-title">Maintenance - Cross Collateralization Group Maintenance  -  Cross Collaterialization Group Change Request View</div>	    		
	    			<div class="command-button-Section">
	    				
	    			</div>
	    			<div class="confirm-del"></div>
	    			<div class="clear"></div>
	    			<div id="create_details_container" class="detail-section monitor-rule-details">
						<div class="monitor-rule-details-header">Cross Collateralization Group Details</div>
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
										<div id="xcollGroupId"></div>
									</td>
								</tr>
								<tr>
									<td>Group Name</td>
									<td><div id="xcollGroupName"></div></td>
								</tr>
							</table>
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
										<div id="ccdId"></div>
									</td>
								</tr>
								<tr>
									<td>Client Name</td>
									<td>
										<div id="ccdName"></div>
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
										<div id="xcollRole"></div>
									</td>
								</tr>
								<tr>
									<td>Cross Collateralization Cap Amount Currency</td>
									<td>
										<div id="xcollCapAmtCcy"></div>
									</td>
								</tr>
								<tr>
									<td>Cross Collateralization Cap Amount</td>
									<td>
										<div id="xcollCapAmt"></div>
									</td>
								</tr>
								<tr>
									<td>Cross Collateralization Expiry date</td>
									<td>
										<div id="xcollExpiryDate"></div>
									</td>
								</tr>
								<tr>
									<td>Supporting Documents</td>
									<td>
										<div id="docMapList" >
											
										</div>
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
								<td width="195.5" class="bold">Action performed by Maker:</td>
								<td><label class="bold">Create/Update/Delete of Cross Collateralization Group</label></td>
							</tr>
							<tr>
								<td width="195.5" style="vertical-align:top" class="bold">Remarks</td>
								
								<td style="background-color:#FCD5B4;">
									<textarea id="verifierRemarks" class="remarks-textarea"></textarea>
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
    