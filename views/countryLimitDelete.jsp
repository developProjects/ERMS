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
		var entity = getURLParameters('entity');
		
    	var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					//url:"/ermsweb/resources/js/getcountryLimitRecord.json",
					url: window.sessionStorage.getItem('serverPath')+"countrylmt/getRecord?countryId="+countryId+"&userId="+window.sessionStorage.getItem("username")+"&entity="+entity,
					dataType: "json",
					
					xhrFields : {
						withCredentials : true
					},
					type:"GET"
					
				},
				update:{
					type:"POST",
					url: window.sessionStorage.getItem('serverPath')+"countrylmt/submit",//"/ermsweb/updateDataByccdId",
					dataType: "json",
					contentType:"application/json",
					xhrFields : {
						withCredentials : true
					},
					complete: function (jqXHR, textStatus){
						var response = JSON.parse(jqXHR.responseText);
						if(response.action=="success"){
							toBack();
						}else{
							$(".confirm-del").html(response.message);
						}
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
			schema: {                               // describe the result format
		        data: function(data) {              // the data which the data source will be bound to is in the values field
		            //console.log(data);
		            return [data];
		        },
		        model:{
		        	id:"countryId"
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
						$(".command-button-Section").html("<button id=\"yesBtn\"  type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Yes</button><label>    </label><button id=\"noBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">No</button>");
						$(".confirm-del").html("<div>"+ "Confirm to Delete "+validateResponse(jsonObj[i].countryId)+" " + "</div>");
						$("#created_by").html(validateResponse(jsonObj[i].createBy));
						$("#created_at").html(validateResponse(validDate(jsonObj[i].createDt)));
						$("#updated_by").html(validateResponse(jsonObj[i].lastUpdateBy));
						$("#updated_at").html(validateResponse(validDate(jsonObj[i].lastUpdateDt)));
						$("#verified_by").html(validateResponse(jsonObj[i].verifyBy));
						$("#verified_at").html(validateResponse(validDate(jsonObj[i].verifyDt)));
						$("#crAction").html(validateResponse(jsonObj[i].action));
				});
				$("#yesBtn").kendoButton({
        			click: function(){
        				var dataDatasource = dataSource.at(0);
        				dataDatasource.set("crAction","DELETE");
        				dataDatasource.set("entity","BOCIS");
        				dataDatasource.set("userId",window.sessionStorage.getItem("username"));
        				//dataSource.remove(dataSource.at(0));
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
		window.location = "/ermsweb/countryLimitMaintenance";
	}
	
    </script>
    <body>
    	<div class="boci-wrapper">
    		
    		<div class="content-wrapper">
					<div class="page-title">Maintenance  - Country Limit Maintenance (Collateral) - Delete Country Limit (Collateral)</div>	    		
	    			<div class="command-button-Section">
	    				
	    			</div>
	    			<div class="confirm-del"></div>
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
    