<html lang="en">	
	<meta http-equiv="Content-Style-Type" content="text/css">
    <meta http-equiv="Content-Script-Type" content="text/javascript">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 
    <script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>
    
    <!-- General layout Style -->

    <!-- Kendo UI lib -->
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.common.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.rtl.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.default.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.dataviz.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.dataviz.default.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.mobile.all.min.css">
    
    <link href="/ermsweb/resources/css/layout.css" rel="stylesheet" type="text/css">

    <!-- jQuery JavaScript -->
    <script src="/ermsweb/resources/js/jquery.min.js"></script>
    <script src="/ermsweb/resources/js/common_tools.js"></script>

    <!-- Kendo UI combined JavaScript -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
    <body onload="checkSessionAlive()">

    <script>

    	var screenDataSource = new kendo.data.DataSource();

    	$(document).ready(function () {
			initialMatchLinkByTarget();

			getUpstreamData();
        	getAlerts();
        	getRequest("myRequest");
        	getRequest("allPendingRequest");

        });

        function getUpstreamData(){
        	var url = window.sessionStorage.getItem('serverPath')+"dashboard/getSourceAppLoadJobList?userId="+window.sessionStorage.getItem("username");

            var dataSource = new kendo.data.DataSource({
                transport: {
                  read: {
                      	url:url,
                    	type: "GET",
                    	dataType: "json",
	    			    xhrFields: {
				    		withCredentials: true
				    	},
				    	complete: function (response, status){
				    	    if(status == "success"){

				    	    	$.each(JSON.parse(response.responseText), function(key, value){
				    	    		
				    	    		/*
					    	    		<td width="129" align="center" max-width="70">XXXX </td>
					    	    		<td width="123" align="center" max-width="70">XXXX </td>
					    	    		<td width="125" align="center" max-width="70">XXXX </td>
					    	    		<td width="113" align="center" max-width="70">XXXX </td>
				    	    		*/

				    	    		$("#upsteamDataList").append("<tr><td width=\"129\" align=\"center\" max-width=\"70\"> "+value.sourceApp+" </td> <td width=\"123\" align=\"center\" max-width=\"70\"> "+value.status+" </td> <td width=\"125\" align=\"center\" max-width=\"70\"> "+value.lastBusinessDate+" </td> <td width=\"113\" align=\"center\" max-width=\"70\"> "+toDateTimeFormat(value.jobEndDateTime)+" </td></tr>");
				    	    	});
				    	    }
				    	}
                  	}
                },
                schema: {
                  model: {
                    fields: {
                      target: { type: "string" },
                      desc: { type: "string" },
                      auth: { type: "string" },
                      param: { type: "date" }
                    }
                  }
                }
            });
            dataSource.read();
        }

        function getAlerts(){

        	var url = window.sessionStorage.getItem('serverPath')+"dashboard/getAlerts?userId="+window.sessionStorage.getItem("username");

            var dataSource = new kendo.data.DataSource({
                transport: {
                  read: {
                      	url:url,
                    	type: "GET",
                    	dataType: "json",
	    			    xhrFields: {
				    		withCredentials: true
				    	},
				    	complete: function (response, status){
				    	    if(status == "success"){

				    	    	$.each(JSON.parse(response.responseText), function(key, value){
				    	    		
				    	    		var link = "";
				    	    		link = "<a href=\""+matchLinkByTarget(value.target)+"&crId="+value.param+"\">"+value.desc+"</a>";
				    	    		$("#ContentTable").append("<tr><td>"+link+"</td></tr>");	
				    	    		
				    	    	});
				    	    }
				    	}
                  	}
                },
                schema: {
                  model: {
                    fields: {
                      target: { type: "string" },
                      desc: { type: "string" },
                      auth: { type: "string" },
                      param: { type: "date" }
                    }
                  }
                }
            });
            dataSource.read();
        }

        function getRequest(type){

        	var url = "";

        	if(type == "myRequest"){

        		url = window.sessionStorage.getItem('serverPath')+"dashboard/getPendingRequest?userId="+window.sessionStorage.getItem("username")+"&userOnly=Y";

        	}else if(type == "allPendingRequest"){

        		url = window.sessionStorage.getItem('serverPath')+"dashboard/getPendingRequest?userId="+window.sessionStorage.getItem("username")+"&userOnly=N";
        	}

            var dataSource = new kendo.data.DataSource({
                transport: {
                  read: {
                      	url:url,
                    	type: "GET",
                    	dataType: "json",
	    			    xhrFields: {
				    		withCredentials: true
				    	},
				    	complete: function (response, status){

				    	    if(status == "success"){

				    	    	$.each(JSON.parse(response.responseText), function(key, value){
				    	    		
				    	    		var link = "";

				    	    		link = "<a href=\""+matchLinkByTarget(value.target)+"&"+setParams(value.param)+"\">"+value.desc+"</a>";
				    	    		

				    	    		if(type == "myRequest"){

				    	    			$("#myRequestTable").append("<tr><td>"+link+"</td></tr>");		
				    	    		}

				    	    		if(type == "allPendingRequest"){
				    	    			
				    	    			$("#allPendingActionTable").append("<tr><td>"+link+"</td></tr>");	
				    	    		}

				    	    	});
				    	    }
				    	}
                  	}
                },
                schema: {
                  model: {
                    fields: {
                      target: { type: "string" },
                      desc: { type: "string" },
                      auth: { type: "string" },
                      param: { type: "string" }
                    }
                  }
                }
            });
            dataSource.read();
        }

        function initialMatchLinkByTarget(){

        	 var dataSource = new kendo.data.DataSource({
                transport: {
                  read: {
                      	url:"/ermsweb/resources/js/screenCodeMapping.json",
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
                      target: { type: "string" },
                      desc: { type: "string" },
                      auth: { type: "string" },
                      param: { type: "string" }
                    }
                  }
                }
            });

            dataSource.read();
            screenDataSource = dataSource;

        }

        function matchLinkByTarget(target){

        	var postFixLink = "";

        	$.each(screenDataSource.data()[0], function(key, value){
        		if(key == target && value != "" ){
        			postFixLink =  value;
        		}
        	});
        	return postFixLink;
        }

        function setParams(jsonObj){

        	if(jsonObj != null){
        		var paramString = "";
        		var allPropertyNames = Object.keys(jsonObj);
        		
        		for (var i = 0; i < allPropertyNames.length; i++) {
        			var name = allPropertyNames[i];
        			paramString += name + "=" + checkUndefinedElement(jsonObj[name]) +"&";
        		};

        		paramString += "userId="+window.sessionStorage.getItem("username");
        	}
        	
        	return paramString;
        }

    </script>
    <input type="hidden" id="pagetitle" name="pagetitle" value="Dashboard">
		<div style="color: red; display: inline-block">System Message: </div>
		<br>
		<br>
		<table border="0" height="300" cellpadding="0" cellspacing="0">
			<tr>
				<td width="50%" rowspan="3" valign="top">
					<table border="0" cellpadding="0" cellspacing="0" style="border: solid 1px; border-collapse: collapse;" width="100%">
						<tr>
							<td valign="top" height="30">
								<table border="0" cellpadding="0" cellspacing="0" style="height:10px; border: solid 1px; border-collapse: collapse; table-layout:fixed;" width="100%">
									<tr height="30">
										<td colspan="4" align="center" style="background-color:pink">
										<b>Limit/Exposure Monitoring Alert</b>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td valign="top">
								<div id="Contain" style="height:845; overflow-y:scroll; overflow-x:scroll; word-wrap: break-word; margin-top:-1px;">
									<table id="ContentTable" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse; table-layout:fixed;  text-overflow: clip; " width="100%">
									
											
									</table>
								</div>
							</td>
						</tr>
					</table>
				</td>
				</td>
				<td width="4%" rowspan="3">
					<p style="word-spacing: 10px">&nbsp;</p>
				</td>
				<td width="50%" valign="top">
					<!-- ++++++++++++++++++++++++ -->
					<table border="0" cellpadding="0" cellspacing="0" style="border: solid 1px; border-collapse: collapse;" width="100%">
						<tr>
							<td valign="top" height="30">
								<table border="0" cellpadding="0" cellspacing="0" style="height:10px; border: solid 1px; border-collapse: collapse; table-layout:fixed;" width="100%">
									<tr height="30">
										<td colspan="4" align="center" style="background-color:pink">
										<b>Upstream System Data</b>
										</td>
									</tr>
									<tr class="Header">
										<td nowrap="nowrap" align="center" width="80">Upstream System</td>
										<td nowrap="nowrap" align="center" width="80">Status</td>
										<td nowrap="nowrap" align="center" width="80">Latest Day End Date</td>
										<td nowrap="nowrap" align="center" width="80">last Loading Time</td> 
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td valign="top">
								<div id="Contain" style="height:240px; overflow-y:scroll; overflow-x:scroll; word-wrap: break-word; margin-top:-1px;">
									<table id="upsteamDataList" border="0" cellpadding="0" cellspacing="0" style="table-layout:fixed;  text-overflow: clip; " width="100%" >
									
									</table>
								</div>
							</td>
						</tr>
					</table>
					<!-- ++++++++++++++++++++++++ -->

				</td>
			</tr>
			<tr>
				<td valign="top" height="30">
					<table border="0" cellpadding="0" cellspacing="0" style="border: solid 1px; border-collapse: collapse;" width="100%">
						<tr>
							<td valign="top" height="30">
								<table border="0" cellpadding="0" cellspacing="0" style="height:10px; border: solid 1px; border-collapse: collapse; table-layout:fixed;" width="100%">
									<tr height="30">
										<td colspan="4" align="center" style="background-color:pink">
										<b>Pending Action</b>
										</td>
									</tr>
									
								</table>
							</td>
						</tr>
						<tr>
							<td valign="top">
								<div id="Contain" style="height:240px; overflow-y:scroll; overflow-x:scroll; word-wrap: break-word; margin-top:-1px;">
									<table id="allPendingActionTable" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse; table-layout:fixed;  text-overflow: clip; " width="100%">
									

									</table>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td valign="top" height="30">
					<table border="0" cellpadding="0" cellspacing="0" style="border: solid 1px; border-collapse: collapse;" width="100%">
						<tr>
							<td valign="top" height="30">
								<table border="0" cellpadding="0" cellspacing="0" style="height:10px; border-collapse: collapse; table-layout:fixed;" width="100%">
									<tr height="30">
										<td colspan="4" align="center" style="background-color:pink">
										<b>Your Request in Progress</b>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td valign="top">
								<div id="Contain" style="height:240px; overflow-y:scroll; overflow-x:scroll; word-wrap: break-word; margin-top:-1px;">
									<table id="myRequestTable" border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse; table-layout:fixed;  text-overflow: clip; " width="100%">
									

									</table>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
<!-- 			</div>
-->		</body>
</html>
