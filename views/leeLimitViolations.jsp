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
   <script src="/ermsweb/resources/js/jszip.min.js"></script>
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
    
    <script>
    $(document).ready(function () {
    	
		$("#leeLimitViolations-list").kendoGrid({
			dataSource:{
				transport:{
					read: {
						//url: "/ermsweb/resources/js/getleeLimitViolations.json",
						url: window.sessionStorage.getItem('serverPath')+"leeLmtExpo/getErmsLeeLmtExpoMon?userId="+window.sessionStorage.getItem("username")+"&funcId=",
						
						dataType: "json",
						xhrFields : {
							withCredentials : true
						},
						type:"GET"
						
					}
				}
				
			},
			error:function(e){
									if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
								},
			scrollable:false,
			pageable: {
		        pageSize: 3
		      },
			pageSize: 2,
			columns:[
				{ field: "rmdGroupDesc" ,title:"Credit Group",template:"#=callExpoDetailsGroup(rmdGroupDesc)#"},
				{ field: "clnName" ,title:"Client/Counterparty", template:"#=callExpoDetailsClient(clnName)#"},
				{ field: "leeLmtAmt" ,title:"LEE Limit Amount"},
				{ field: "leeExpo" ,title:"LEE Exposure"},
				{ field: "severity" ,title:"Severity"}
			]
		});
			
	});		
    function callExpoDetailsGroup(rmdGroupDesc){
    	var split_string = "";
    	split_string = split_string+"<a href='/ermsweb/counterpartyexposure?rmdGroupDesc="+rmdGroupDesc+"'>"+rmdGroupDesc+"</a>";
    	return split_string;
    }
    function callExpoDetailsClient(clnName){
    	var split_string = "";
    	split_string = split_string+"<a href='/ermsweb/counterpartyexposure?clnName="+clnName+"'>"+clnName+"</a>";
    	return split_string;
    }
    </script>
	<body>
	<div class="boci-wrapper">
		<div id="boci-content-wrapper">
			<div class="page-title">Limit/Exposure Monitoring alert-LEE Limit Violations</div>
			<div id="leeLimitViolations-list" style="margin-top:20px;"></div>						
		</div>
	</div>	
</body>
</html>	