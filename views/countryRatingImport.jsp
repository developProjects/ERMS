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
    	

    	//"+window.sessionStorage.getItem('serverPath')+"countryRating/upload
    	
    	$('#importBtn').on('click', function(){
	         $("#files").kendoUpload({
	        	 localization: {
	                 select: "Browse"
	             },
	             async: {
	                 saveUrl: window.sessionStorage.getItem('serverPath')+"countryRating/upload?userId="+window.sessionStorage.getItem("username"),
	                 xhrFields: {
	                     withCredentials: true
	                    },
	                 autoUpload: true
	             }, 
	             success: onSuccess
	            });
         });
    		
    	
	});	 
   
    function onSuccess(e){
    	console.log(e.response);
    }

	function toBack(){
		//window.history.back();
		window.location = "/ermsweb/countryRatingMaintenance";
	}
	
    </script>
    <body>
    	<div class="boci-wrapper">
    		
    		<div class="content-wrapper">
					<div class="page-title">Maintenance  - Country Rating Maintenance (Collateral) - Import </div>	    		
	    			<div class="command-button-Section">
	    				<button id="importBtn" class="k-button toClear" type="button">Import</button>
	    				<button id="backBtn" class="k-button" type="button" onclick="toBack()">Back</button>
	    			</div>
	    			<div class="clear"></div>
	    			<div class="limitType-details">
	   					<div class="limitType-details-header">Country Details </div>
	   					<table>
	   						<tr>
	   							<td>File</td>
	   							<td>
	   								<input name="file" id="files" type="file" />
	   							</td>
	   							
	   						</tr>
	   						
	   						
	   					</table>
	    			</div>
	    			
    	
    	
    	</div>
    	</div>

    </body>
    </html>
    