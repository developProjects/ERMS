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
    	

		var countryId = getURLParameters('countryId');
		var crId = getURLParameters('crId');
		
    	var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					//url:"/ermsweb/resources/js/getcountryLimitRecord.json",
					url: window.sessionStorage.getItem('serverPath')+"countrylmt/getRecord?crId="+crId+"&userId="+window.sessionStorage.getItem("username"),
					

					dataType: "json",
					xhrFields : {
						withCredentials : true
					},
					type:"GET"
					
				}
			},
			error:function(e){
							if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
						},
			schema: {                               // describe the result format
	            data: function(data) {              // the data which the data source will be bound to is in the values field
	                //console.log(data);
	                return [data];
	            }
	        }
		});
    	
		
			dataSource.fetch(function(){
				var jsonObj = this.view();
				$.each(jsonObj, function(i){
						$("#countryId").html("<label>"+validateResponse(jsonObj[i].countryId)+"</label>");
						$("#countryName").html("<label>"+validateResponse(jsonObj[i].countryName)+"</label>");
						$("#entity").html("<label>"+validateResponse(jsonObj[i].entity)+"</label>");
						$("#lmtCcy").html("<label>"+validateResponse(jsonObj[i].lmtCcy)+"</label>");
						$("#lmtAmt").html("<label>"+validateResponse(jsonObj[i].lmtAmt)+"</label>");
						$("#lmtInCapital").html("<label>"+validateResponse(jsonObj[i].lmtInCapital)+"</label>");
						$("#verifierRemarks").html(jsonObj[i].crRemark);
						$(".command-button-Section").html("<button id=\"updateBtn\"  type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\"onclick=\"toEdit('"+jsonObj[i].crId+"')\" >Update</button></label> <label><button id=\"discardBtn\"  type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" onclick=\"toDiscard('"+jsonObj[i].crId+"')\">Discard</button></label> <label><button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Back</button>");
						$("#created_by").html(validateResponse(jsonObj[i].createBy));
						$("#created_at").html(validateResponse(validDate(jsonObj[i].createDt)));
						$("#updated_by").html(validateResponse(jsonObj[i].lastUpdateBy));
						$("#updated_at").html(validateResponse(validDate(jsonObj[i].lastUpdateDt)));
						$("#verified_by").html(validateResponse(jsonObj[i].verifyBy));
						$("#verified_at").html(validateResponse(validDate(jsonObj[i].verifyDt)));
						$("#crAction").html(validateResponse(jsonObj[i].action));
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
    
	function toEdit(crId){
		window.location = "/ermsweb/countryLimitChangeRequestUpdate?crId="+crId;
	}
	function toDiscard(crId){
		window.location = "/ermsweb/countryLimitChangeRequestDiscard?crId="+crId;
	}
	function toBack(){
		//window.history.back();
		window.location = "/ermsweb/countryLimitMaintenance";
	}
	
    </script>
    <body>
    	<div class="boci-wrapper">
    		
    		<div class="content-wrapper">
					<div class="page-title">Maintenance  - Country Limit Maintenance (Collateral) - View Country Limit Change Request (Collateral)</div>	    		
	    			<div class="command-button-Section">
	    				
	    			</div>
	    			<div class="clear"></div>
	    			<div class="limitType-details">
	   					<div class="limitType-details-header">Country Details </div>
	   					<table>
	   						<tr>
	   							<td>Country</td>
	   							<td>
	   								<div id="countryId"></div>
	   							</td>
	   							
	   						</tr>
	   						<tr>
	   							<td>
	   								Country Name
	   							</td>
	   							<td>
	   								<div id="countryName"></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Entity</td>
	   							<td>
	   								<div id="entity"></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Limit CCY</td>
	   							<td>
	   								<div  id="lmtCcy" ></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>Limit Amount</td>
	   							<td>
	   								<div  id="lmtAmt" ></div>
	   							</td>
	   						</tr>
	   						<tr>
	   							<td>
	   								Limit in % of Capital
	   							</td>
	   							<td>
	   								<div id="lmtInCapital"></div>
	   							</td>
	   						</tr>
	   						
	   						
	   					</table>
	    			</div>
	    			<div class="approval-section margin-top">
					<div id="approval-section-header">Approval</div>
						<table id="approval-section-table">
							<tr>
								<td class="bold">Action performed by Maker:</td>
								<td><label class="bold">Update </label></td>
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
    