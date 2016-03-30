<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>
<html>

<meta http-equiv="x-ua-compatible" content="IE=10">
<link rel="shortcut icon" href="/ermsweb/resources/images/boci.ico" />
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>
<script type="text/javascript" src="/ermsweb/resources/js/common_tools.js"></script>


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


<script>
	
$(document).ready(
	function(){
		/* Control and initialize the menu bar of header  
		 (8 options of menu)
		*/
		$("#menu1").kendoMenu({
    		width: "100%",
    		animation: {open: {effects: "slideIn:down"}}
    	});
		$("#menu2").kendoMenu({
    		width: "100%",
    		animation: {open: {effects: "slideIn:down"}}
    	});
		$("#menu3").kendoMenu({
    		width: "100%",
    		animation: {open: {effects: "slideIn:down"}}
    	});
		$("#menu4").kendoMenu({
    		width: "100%",
    		animation: {open: {effects: "slideIn:down"}}
    	});
		$("#menu5").kendoMenu({
    		width: "100%",
    		animation: {open: {effects: "slideIn:down"}}
    	});
		$("#menu6").kendoMenu({
    		width: "100%",
    		animation: {open: {effects: "slideIn:down"}}
    	});
		$("#menu7").kendoMenu({
    		width: "100%",
    		animation: {open: {effects: "slideIn:down"}}
    	});
	}
);
function getRole() { // Simulating to be different roles 
	return "checker";
}

</script>
<head></head>
<body id="index" onload="checkSessionAlive()">

	<%@include file="header.jsp"%>
	
	<iframe cellpadding="0" cellspacing="0"
		style="overflow: auto; display: block;" frameborder="0" border="0"
		frameborder="0" scrolling="yes" width="100%" max-height="100%" height="800px" 
		src="/ermsweb/dashboard" name="main_frame" id="main_frame" onload="onLoadTitle();"></iframe>

</body>
</html>