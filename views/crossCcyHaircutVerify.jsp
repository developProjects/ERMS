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
    	
    	var ccyCode = getURLParameters('ccyCode');
		var bizUnit = getURLParameters('bizUnit');
		var crId = getURLParameters('crId');
		
    	var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: window.sessionStorage.getItem('serverPath')+"crossCcyHaircut/getRecord?ccyCode="+ccyCode+"&crId="+crId+"&bizUnit="+bizUnit+"&userId="+window.sessionStorage.getItem("username"),
					dataType: "json",
					

					xhrFields : {
						withCredentials : true
					},
					type:"GET"
					
				},
				update:{
					type:"POST",
					url: window.sessionStorage.getItem('serverPath')+"crossCcyHaircut/verify",
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
				$.each(jsonObj, function(i){
						$("#bizUnit").html("<label>"+validateResponse(jsonObj[i].bizUnit)+"</label>");
						$("#currency").html("<label>"+validateResponse(jsonObj[i].ccyCode)+"</label>");
						$("#haircutPercent").html("<label>"+validateResponse(jsonObj[i].haircutRatio)+"</label>");
						$("#verifierRemarks").html(jsonObj[i].action);
						$(".command-button-Section").html("<button id=\"verifyBtn\"  type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" >Verify</button><label>    </label><button id=\"returnBtn\"  type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Return</button><label>    </label><button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Back</button>");
						
						$("#created_by").html(validateResponse(jsonObj[i].createBy));
						$("#created_at").html(validateResponse(validDate(jsonObj[i].createDt)));
						$("#updated_by").html(validateResponse(jsonObj[i].lastUpdateBy));
						$("#updated_at").html(validateResponse(validDate(jsonObj[i].lastUpdateDt)));
						$("#verified_by").html(validateResponse(jsonObj[i].verifyBy));
						$("#verified_at").html(validateResponse(validDate(jsonObj[i].verifyDt)));
						$("#crAction").html(validateResponse(jsonObj[i].crAction));
				});
				
				/*Service Calls*/
				$("#verifyBtn").kendoButton({
	    			click: function(){
	    				var dataDatasource = dataSource.at(0);
	    				dataSource.transport.options.update.url= window.sessionStorage.getItem('serverPath')+"crossCcyHaircut/verify";
	    				dataDatasource.set("crStatus","verified");
	    				dataDatasource.set("crRemarks",$("#verifierRemarks").val());
	    				dataSource.sync();
	    			}
	    		});
	      		
	      		$("#returnBtn").kendoButton({
	    			click: function(){    				
	    				var dataDatasource = dataSource.at(0);
	    				dataSource.transport.options.update.url= window.sessionStorage.getItem('serverPath')+"crossCcyHaircut/return";
	    				dataDatasource.set("crStatus","return");
	    				dataDatasource.set("crRemarks",$("#verifierRemarks").val());
	    				dataSource.sync();
	    			}
	    		});
	      		
			});			
	
	});	 
    /* Action - Save button */
	
	function validateResponse(data){
		return (data != null) ? data : "";
	}
	function validDate(obj){
		return kendo.toString( new Date(parseInt(obj)), "MM/dd/yyyy HH:MM:tt" )
	}
    
	function toBack(){
		//window.history.back();
		window.location = "/ermsweb/crossCcyHaircutMaintenance";
	}
	
    </script>
    <body>
    	<div class="boci-limitType-wrapper">
    		<%@include file="header1.jsp"%>
    		<div class="viewLimitTypeDetails-content-wrapper form">
					<div class="page-title">Maintenance  -  Cross Currency Haircut Maintenance - Cross Currency Haircut Change Request View (Verfiy)</div>	    		
	    			<div class="command-button-Section">
	    				
	    			</div>
	    			<div class="confirm-del"></div>
	    			<div class="clear"></div>
	    			<div class="monitor-rule-details">
	   					<div class="monitor-rule-details-header">Cross Currency Haircut </div>
	   					<table>
	   						<tr>
	   							<td class="field-label">Business Unit</td>
	   							<td>
	   								<div id="bizUnit"><label>pb</label></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Currency</td>
	   							<td>
	   								<div id="currency"><label>Monitor Rule Name</label></div>
	   							</td>
	   						</tr>
	   						<tr>	
	   							<td>
	   								Haircut %
	   							</td>
	   							<td>
	   								<div id="haircutPercent"><label>Presettlment Limit</label></div>
	   							</td>
	   						</tr>
	   					</table>
	    			</div>
	    			<div class="approval-section margin-top">
					<div id="approval-section-header">Approval</div>
						<table id="approval-section-table">
							<tr>
								<td width="195.5" class="bold">Action performed by Maker:</td>
								<td><label class="bold">Create/Update/Delelte of Limit</label></td>
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
    