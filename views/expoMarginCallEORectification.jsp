<html lang="en">
	<meta http-equiv="x-ua-compatible" content="IE=10">
	<meta http-equiv="Content-Style-Type" content="text/css">
    <meta http-equiv="Content-Script-Type" content="text/javascript">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 
    <script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>
  

	
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
    <script src="/ermsweb/resources/js/common_tools.js"></script>

    <!-- Kendo UI combined JavaScript -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
    
	<style type="text/css">
	.margin-call-wrapper .details-wrapper table, th, td {
		border: 1px solid brown;
	}
	</style>
<script>

	function deleteFile(fileKey, monitorType){

		var url = window.sessionStorage.getItem('serverPath')+"expoMarginCall/deleteDocument?creditGroup="+getURLParameters("creditGroup")+"&ccdId="+getURLParameters("ccdId")+"&acctId="+getURLParameters("acctId")+"&subAcctId="+getURLParameters("subAcctId")+"&monitorType="+monitorType+"&userId="+window.sessionStorage.getItem("username").replace("//","//")+"&fileKey"+fileKey;


		var jsonArr = {
		  creditGroup: getURLParameters("creditGroup"),
		  ccdId: getURLParameters("ccdId"),
		  acctId: getURLParameters("acctId"),
		  subAcctId: getURLParameters("subAcctId"),
		  monitorType: monitorType,
		  fileKey: fileKey,
		  userId: window.sessionStorage.getItem("username").replace("//","//")
		} ;

		var dataSource = new kendo.data.DataSource({
		    transport: {
		        read: {
		            url: url,
		            type: "POST",
		            data: JSON.stringify(jsonArr),
		            dataType: "json",
		            xhrFields: {
		                withCredentials: true
		            }
		        }
		    }
		});
		dataSource.read();
		window.location.reload();
	}

	function addCurrentFileToList(type, fileList, status){

		if(type == "od"){
			var listStr = "";

			$.each(fileList, function(key, value){
				console.log(value.id.fileKey + ":" + value.fileName);

				if(status == "Rectified" || status == "Pending for Liquidation" || status == "Approved" || status == "Pending for Approval"){
					listStr += "<div class=\"img1\"><a href=\"#\" class=\"anchor\">"+value.fileName+"</a></div>";
				}else{
					listStr += "<div class=\"img1\"><a href=\"#\" onclick=\"deleteFile('"+value.id.fileKey+"','MCOD')\"><img class=\"icon_delete_1\" width=\"20\" height=\"20\" src=\"/ermsweb/resources/images/bg_discard2.png\"></img></a><a href=\"#\" class=\"anchor\">"+value.fileName+"</a></div>";	
				}
				

				$("#odMcExpoMarginCallDoc").html(listStr);
				
			});
		}else if(type == "le"){
			var listStr = "";

			$.each(fileList, function(key, value){
				console.log(value.id.fileKey + ":" + value.fileName);
				if(status == "Rectified" || status == "Pending for Liquidation" || status == "Approved" || status == "Pending for Approval"){
					listStr += "<div class=\"img2\"><a href=\"#\" class=\"anchor\">"+value.fileName+"</a></div>";
				}else{
					listStr += "<div class=\"img2\"><a  href=\"#\" onclick=\"deleteFile('"+value.id.fileKey+"', 'LE')\"><img width=\"20\" height=\"20\" src=\"/ermsweb/resources/images/bg_discard2.png\"></img></a><a href=\"#\" class=\"anchor\" >"+value.fileName+"</a></div>";
				}
				
				$("#leExpoMarginCallDoc").html(listStr);
			});
		}
	}


	function submitForm(type) {
        
        var data, xhr, uploadType, monitorType;

        if(type == "od"){
        	uploadType = "uploadFile";
        	monitorType = "MCOD";

        }
        if(type == "le"){
        	uploadType = "uploadFile2";
        	monitorType = "LE";
        }

        data = new FormData();
        data.append( "uploadFile", $( "#"+uploadType)[0].files[0] );

        xhr = new XMLHttpRequest();
        xhr.withCredentials = true;
        xhr.open( 'POST', window.sessionStorage.getItem('serverPath')+"expoMarginCall/uploadDocument?creditGroup="+getURLParameters("creditGroup")+"&ccdId="+getURLParameters("ccdId")+"&acctId="+getURLParameters("acctId")+"&subAcctId="+getURLParameters("subAcctId")+"&monitorType="+monitorType+"&userId="+window.sessionStorage.getItem("username").replace("//","//"), true );
        xhr.onreadystatechange = function ( response ) {
        	window.location.reload();
        };
        xhr.send( data );
    }

	function dimFieldsByStatus(type, status){

		if(type == "od"){

			if(status == "Triggered"){

				$("#odMcIsBizApproval").prop("disabled","disabled");

			}else if(status == "Pending for Approval"){

				$("#odMcIsBizApproval").prop("disabled",false);		
				$("#rectArea1").css({"display":"none"});		
				$("#sendFile1").css({"display":"none"});		
				$("#uploadFile").prop("disabled",true);			
				$(".img1").css({"display":"none"});			
				$("#odMcRectificationReason").data("kendoDropDownList").enable(false);
				$("#rectif_approv_expiry_date").data('kendoDatePicker').enable(false);	
				$("#openUser1").css({"pointer-events":"none"});
				$("#notifyBtn").prop("disabled","disabled");


			}else if(status == "Rectified" || status == "Pending for Liquidation" || status == "Approved"){

				$("#odMcIsBizApproval").prop("disabled","disabled");				
				$("#odMcRemarks").prop("disabled","disabled");				
				$("#odMcRectificationReason").data("kendoDropDownList").enable(false);
				$("#rectif_approv_expiry_date").data('kendoDatePicker').enable(false);			
				$("#openUser1").css({"pointer-events":"none"});
				$("#uploadBtn").prop("disabled","disabled");
				$("#notifyBtn").prop("disabled","disabled");
				$("#odMcIsGracePeriod").prop("disabled","disabled");
				$("#sendFile1").css({"display":"none"});	
				$("#uploadFile").prop("disabled",true);			
				$(".img1").css({"display":"none"});
				$("#notifyBtn").prop("disabled","disabled");
				$("#odMcBizApprovalNamesField").prop("disabled","disabled");
			}

		}else if(type == "le"){

			if(status == "Triggered"){

				$("#leIsBizApproval").prop("disabled","disabled");

			}else if(status == "Pending for Approval"){

				$("#leIsBizApproval").prop("disabled",false);				
				$("#rectArea2").css({"display":"none"});				
				$("#sendFile2").css({"display":"none"});		
				$("#uploadFile2").prop("disabled",true);					
				$(".img2").css({"display":"none"});				
				$("#leRectificationReason").data("kendoDropDownList").enable(false)	;
				$("#leRectifyExpiryDt").data('kendoDatePicker').enable(false);
				$("#openUser2").css({"pointer-events":"none"});		
				$("#notifyBtn2").prop("disabled","disabled");

			}else if(status == "Rectified" || status == "Pending for Liquidation" || status == "Approved"){

				$("#leIsBizApproval").prop("disabled","disabled");				
				$("#leRemarks").prop("disabled","disabled");	
				$("#leRectificationReason").data("kendoDropDownList").enable(false)	;
				$("#leRectifyExpiryDt").data('kendoDatePicker').enable(false);
				$("#openUser2").css({"pointer-events":"none"});
				$("#uploadBtn2").prop("disabled","disabled");
				$("#notifyBtn2").prop("disabled","disabled");
				$("#leIsGracePeriod").prop("disabled","disabled");
				$("#sendFile2").css({"display":"none"});				
				$("#uploadFile2").prop("disabled",true);					
				$(".img2").css({"display":"none"});						
				$("#notifyBtn2").prop("disabled","disabled");
				$("#leBizApprovalNamesField").prop("disabled","disabled");
			}
		}
	}

	function emptyReturnN(option){
		if(option == ""){
			return "N";
		}else{
			return option;
		}
	}

	function statusAndActionButtonMapping(type, action){

		/*public static final String EXPO_ACTION_VIEW = "V";
		public static final String EXPO_ACTION_RECTIFY = "R";
		public static final String EXPO_ACTION_SEEK_APPROVAL = "S";
		public static final String EXPO_ACTION_APPROVE = "A";
		public static final String EXPO_ACTION_REJECT = "J";
		public static final String EXPO_ACTION_FORCE_LIQUID = "F";*/

		/*public static final String STATUS_TRIGGERED = "Triggered";
		public static final String STATUS_RECTIFIED = "Rectified"; X
		public static final String STATUS_SUBMIT_LIQ = "Pending for Liquidation"; X
		public static final String STATUS_SUBMIT_APPR = "Pending for Approval";
		public static final String STATUS_REJECT = "Rejected";
		public static final String STATUS_APPROVED = "Approved";*/

		if(type == "od"){

			if(new RegExp("V").test(action)){

				console.log("V");
			}

			var counter1 = 0;

			if(new RegExp("R").test(action)){

				$("#rectifyBtn").css({"display":"inline"});
				counter1++;

			}
			if(new RegExp("S").test(action)){

				$("#seekApprovalBtn").css({"display":"inline"});

				counter1++;

			}
			if(new RegExp("A").test(action)){

				$("#approveBtn").css({"display":"inline"});
				$("label, td").removeClass("dimmed");
				counter1++;

			}
			if(new RegExp("J").test(action)){

				$("#rejectBtn").css({"display":"inline"});
				counter1++;

			}
			if(new RegExp("F").test(action)){

				$("#forcedLiqudationBtn").css({"display":"inline"});
				counter1++;

			}
			if(counter1 == 0){

				$("#odMcIsBizApproval").prop("disabled","disabled");				
				$("#odMcRemarks").prop("disabled","disabled");				
				$("#odMcRectificationReason").data("kendoDropDownList").enable(false);
				$("#rectif_approv_expiry_date").data('kendoDatePicker').enable(false);			
				$("#openUser1").css({"pointer-events":"none"});
				$("#openUser1").css({"pointer-events":"none"});
				$("#uploadBtn").prop("disabled","disabled");
				$("#notifyBtn").prop("disabled","disabled");
				$("#sendFile1").css({"display":"none"});	
				$("#uploadFile").prop("disabled",true);			
				$(".img1").css({"display":"none"});
				$("#odMcIsGracePeriod").prop("disabled","disabled");

			}
		}else{
			console.log("le Buttons");
			if(type == "le"){
				if(new RegExp("V").test(action)){

				}

				var counter2 = 0;

				if(new RegExp("R").test(action)){

					$("#rectifyBtn2").css({"display":"inline"});
					counter2++;

				}
				if(new RegExp("S").test(action)){

					$("#seekApprovalBtn2").css({"display":"inline"});
					counter2++;

				}
				if(new RegExp("A").test(action)){

					$("#approveBtn2").css({"display":"inline"});
					$("label, td").removeClass("dimmed");
					counter2++;

				}
				if(new RegExp("J").test(action)){

					$("#rejectBtn2").css({"display":"inline"});
					counter2++;

				}
				if(new RegExp("F").test(action)){

					$("#forcedLiqudationBtn2").css({"display":"inline"});
					counter2++;

				}
				if(counter2 == 0){
					$("#leIsBizApproval").prop("disabled","disabled");				
					$("#leRemarks").prop("disabled","disabled");	
					$("#leRectificationReason").data("kendoDropDownList").enable(false)	;
					$("#leRectifyExpiryDt").data('kendoDatePicker').enable(false);
					$("#openUser2").css({"pointer-events":"none"});
					$("#uploadBtn2").prop("disabled","disabled");
					$("#notifyBtn2").prop("disabled","disabled");
					$("#sendFile2").css({"display":"none"});				
					$("#uploadFile2").prop("disabled",true);					
					$(".img2").css({"display":"none"});	
					$("#leIsGracePeriod").prop("disabled","disabled");
				}
			}
		}
	}


	function openUserPopup(type){

		$("#searchUserWindow").data("kendoWindow").open();
		$("#searchUserWindow").data("kendoWindow").center();
		loadUserGrid(type);
	}
	function loadUserGrid(type){
		console.log("Load Grid" + window.sessionStorage.getItem("username").replace("//","//"));
		var dataSource = new kendo.data.DataSource({
		    transport: {
		        read: {
		            url:window.sessionStorage.getItem('serverPath')+"user/getAllUsers?userId="+window.sessionStorage.getItem("username").replace("//","//"),
		            type: "GET",
		            dataType: "json",
		            xhrFields: {
		                withCredentials: true
		            }
		        }
		    }
		});

		$("#userGrid").kendoGrid({
		    dataSource: dataSource,
		    filterable: false,
     	 	columnMenu: false,
     	 	sortable: true,
		    scrollable: true,
		    columns: [  
		       { field: "", title: "" ,width: 80, template: "#=selectUser('"+type+"', userId)#"},
		       { field: "userId", title: "USER ID" ,width: 150}
		    ]
		});	
	}
	function selectUser(type, user){
		console.log("type : " + type);
		console.log("user : " + user);
		if(type == "od"){
			return "<input class='k-button' type='button' onclick='selectOutUserOd(\""+user.replace("\\", "\\\\")+"\")' value='Select'/>";
		}else{
			if(type == "le"){
				return "<input class='k-button' type='button' onclick='selectOutUserLe(\""+user.replace("\\", "\\\\")+"\")' value='Select'/>";
			}else{
				return "";
			}
		}		
	}

	function selectOutUserOd(user){
		$("#userIdOd").html(user);
		$("#searchUserWindow").data("kendoWindow").close();
	}

	function selectOutUserLe(user){
		$("#userIdLe").html(user);
		$("#searchUserWindow").data("kendoWindow").close();
	}


	function sendRequestsOd(){

		console.log("Clicked : " + $(".actionMessage").html());

		var actionType = "";

		if($(".actionMessage").html() == "Rectify"){
			
			actionType = "R";
	
		}
		if($(".actionMessage").html() == "Seek Approval"){
			
			actionType = "S";
	
		}
		if($(".actionMessage").html() == "Approve"){
			
			actionType = "A";
	
		}
		if($(".actionMessage").html() == "Reject"){
			
			actionType = "J";
	
		}
		if($(".actionMessage").html() == "Forced Liqudiation"){
			
			actionType = "F";
	
		}


		var tmpRectDate = "";
		var tmpApprDate = "";

		if(actionType == "R"){

			tmpRectDate = $("#rectif_approv_expiry_date").val();

		}else if(actionType == "S"){

			tmpApprDate = $("#rectif_approv_expiry_date").val();

		}

		var jsonArr = {
		  creditGroup: getURLParameters("creditGroup"),
		  ccdId: getURLParameters("ccdId"),
		  acctId: getURLParameters("acctId"),
		  subAcctId: getURLParameters("subAcctId"),
		  monitorType: "MCOD",
		  action: actionType,
		  isBizApproval: emptyReturnN(checkUndefinedElement($('input[name="approval"]:checked').val())),
		  bizApprovalNames: $("#odMcBizApprovalNamesField").val(),
		  isGracePeriod: emptyReturnN(checkUndefinedElement($('input[name="graceperiod"]:checked').val())),
		  rectifyExpiryDt: strToDate(tmpRectDate),
		  approveExpiryDt: strToDate(tmpApprDate),
		  rectificationReason: $("#odMcRectificationReason").val(),
		  remarks: $("#odMcRemarks").val(),
		  assignApprover: $("#userIdOd").html(),
		  userId: window.sessionStorage.getItem("username").replace("//","//")
		} ;


		var dataSource = new kendo.data.DataSource({
			transport: {
			    read: function(options) {
                    $.ajax({
                        type: "POST",
                        url: window.sessionStorage.getItem('serverPath')+"expoMarginCall/processAction",
                        data: JSON.stringify(jsonArr),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (result) {
                            options.success(result);
                        },
                        complete: function (jqXHR, textStatus){
							if(textStatus == "success"){
								/*window.opener.location.reload();
								             window.close();*/
								window.location.reload();
							}
						},
                        xhrFields: {
				    		withCredentials: true
				    	}
                    });
                }
			},
			schema: { 
	            model:{
	            	id: "message",
	            	fields:{
	            		message: {type: "string"},     
	            		status: {type: "string"}     
	            	}
	            }
	        }
		});
		dataSource.read();
		console.log(jsonArr);
	}
	/*
	Possible action types:
	public static final String EXPO_ACTION_VIEW = "V";
	public static final String EXPO_ACTION_RECTIFY = "R";
	public static final String EXPO_ACTION_SEEK_APPROVAL = "S";
	public static final String EXPO_ACTION_APPROVE = "A";
	public static final String EXPO_ACTION_REJECT = "J";
	public static final String EXPO_ACTION_FORCE_LIQUID = "F";
	*/
	function sendRequestsLe(){

		console.log("Clicked : " + $(".actionMessage2").html());

		var actionType = "";

		if($(".actionMessage2").html() == "Rectify"){
	
			actionType = "R";
	
		}
		if($(".actionMessage2").html() == "Seek Approval"){
	
			actionType = "S";
	
		}
		if($(".actionMessage2").html() == "Approve"){
	
			actionType = "A";
	
		}
		if($(".actionMessage2").html() == "Reject"){
	
			actionType = "J";
	
		}
		if($(".actionMessage2").html() == "Forced Liqudiation"){
	
			actionType = "F";
	
		}

		var tmpRectDate = "";
		var tmpApprDate = "";

		if(actionType == "R"){

			tmpRectDate = $("#leRectifyExpiryDt").val();

		}else if(actionType == "S"){

			tmpApprDate = $("#leRectifyExpiryDt").val();

		}

		var jsonArr = {
		  creditGroup: getURLParameters("creditGroup"),
		  ccdId: getURLParameters("ccdId"),
		  acctId: getURLParameters("acctId"),
		  subAcctId: getURLParameters("subAcctId"),
		  monitorType: "LE",
		  action: actionType,
		  isBizApproval: emptyReturnN(checkUndefinedElement($('input[name="approval2"]:checked').val())),
		  bizApprovalNames: $("#leBizApprovalNamesField").val(),
		  isGracePeriod: emptyReturnN(checkUndefinedElement($('input[name="graceperiod2"]:checked').val())),
		  rectifyExpiryDt: strToDate(tmpRectDate),
		  approveExpiryDt: strToDate(tmpApprDate),
		  rectificationReason: $("#leRectificationReason").val(),
		  remarks: $("#leRemarks").val(),
		  assignApprover: $("#userIdLe").html(),
		  userId: window.sessionStorage.getItem("username").replace("//","//")
		} ;

		var dataSource = new kendo.data.DataSource({
			transport: {
			    read: function(options) {
                    $.ajax({
                        type: "POST",
                        url: window.sessionStorage.getItem('serverPath')+"expoMarginCall/processAction",
                        data: JSON.stringify(jsonArr),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (result) {
                            options.success(result);
                        },
                        complete: function (jqXHR, textStatus){
							if(textStatus == "success"){
								/*window.opener.location.reload();
								window.close();*/
								window.location.reload();
							}
						},
                        xhrFields: {
				    		withCredentials: true
				    	}
                    });
                }
			},
			schema: { 
	            model:{
	            	id: "message",
	            	fields:{
	            		message: {type: "string"},     
	            		status: {type: "string"}     
	            	}
	            }
	        }
		});
		dataSource.read();
		console.log(jsonArr);
	}

	$(document).ready(function(){
		

		$(".rectif_approv_expiry_date").kendoDatePicker();
		
		
		$(".rectif_approv_expiry_date").attr("readonly", "readonly");

		var rectificationReasonData = [
					{ text: "Can settle same day", value: "Can settle same day" },
					{ text: "Margin call is covered on group level", value: "Margin call is covered on group level" },
					{ text: "Out of scope of the system process flow", value: "Out of scope of the system process flow" },
					{ text: "N/A", value: "" },
				];

		$("#odMcRectificationReason").kendoDropDownList({
			dataTextField: "text",
			dataValueField: "value",
			dataSource: rectificationReasonData,
			index: 0
		});
		$("#leRectificationReason").kendoDropDownList({
			dataTextField: "text",
			dataValueField: "value",
			dataSource: rectificationReasonData,
			index: 0
		});

		$("#rectif_approv_expiry_date").kendoDatePicker({
			format: "dd/MM/yyyy"
		});		
		$("#rectif_approv_expiry_date").attr("readonly", "readonly");

		$("#leRectifyExpiryDt").kendoDatePicker({
			format: "dd/MM/yyyy"
		});		
		$("#leRectifyExpiryDt").attr("readonly", "readonly");

		$("#searchUserWindow").kendoWindow({
		    width: "300px",
		    height: "500px",
		    modal: true,
		    title: "Search ISDA",
		    visible: false
		}); 
		
		var dataSource = new kendo.data.DataSource({
			transport: {
				read: {
					
					url: window.sessionStorage.getItem('serverPath')+"expoMarginCall/getRecord?creditGroup="+getURLParameters("creditGroup")+"&ccdId="+getURLParameters("ccdId")+"&acctId="+getURLParameters("acctId")+"&subAcctId="+getURLParameters("subAcctId")+"&isHist="+getURLParameters("isHist")+"&userId="+getURLParameters("userId")+"&bizDateId="+getURLParameters("bizDateId"),
					dataType: "json",
					type:"GET",
	    			xhrFields: {
			    		withCredentials: true
			    	}
					
				}
			},
			schema: {                              
	            data: function(data) {              
	                return [data];
	            },
	            model:{
					id:""
				} 
	        }
		});
		
		dataSource.fetch(function(){
			var jsonObj = this.view();
			$.each(jsonObj, function(i){
					
					statusAndActionButtonMapping("od",validateResponse(jsonObj[i].odMcAction));
					statusAndActionButtonMapping("le",validateResponse(jsonObj[i].leAction));
					dimFieldsByStatus("od", jsonObj[i].odMcStatus);
					dimFieldsByStatus("le", jsonObj[i].leStatus);

				    $("#creditGroup").html(validateResponse(jsonObj[i].creditGroup));
				    $("#ccdId").html(validateResponse(jsonObj[i].ccdId));
				    $("#acctId").html(validateResponse(jsonObj[i].acctId));
				    $("#subAcctId").html(validateResponse(jsonObj[i].subAcctId));
				    $("#acctName").html(validateResponse(jsonObj[i].acctName));
				    $("#acctSalesmanCode").html(validateResponse(jsonObj[i].acctSalesmanCode));
				    $("#acctSalesmanName").html(validateResponse(jsonObj[i].acctSalesmanName));
				    $("#lmtTypeDesc").html(validateResponse(jsonObj[i].lmtTypeDesc));
				    $("#totalClientLeeDeficit").html(validateResponse(jsonObj[i].totalClientLeeDeficit));
				    $("#totalClientOverdueOrCallAmt").html(validateResponse(jsonObj[i].totalClientOverdueOrCallAmt));
				    $("#odMcStatus").html(validateResponse(jsonObj[i].odMcStatus));  



				    if(jsonObj[i].acctBizUnit == "PB"){
				    	if(jsonObj[i].odMcIsGracePeriod == "Y"){
				    		$("#odMcIsGracePeriod").prop("checked",true);
				    	}else{
				    		$("#odMcIsGracePeriod").prop("checked",false);
				    	}	
				    }else{
				    	if(jsonObj[i].acctBizUnit == "ISD"){
				    		$("#odMcIsGracePeriod").prop("disabled", "disabled");
				    	}	
				    }
				    


				    addCurrentFileToList("od", jsonObj[i].odMcExpoMarginCallDoc, jsonObj[i].odMcStatus);
					addCurrentFileToList("le", jsonObj[i].leExpoMarginCallDoc,  jsonObj[i].leStatus);




				    $("#userIdOd").html(validateResponse(jsonObj[i].odMcAssignApprover));
				    $("#odMcDaysInOdMarginCall").html(validateResponse(jsonObj[i].odMcDaysInOdMarginCall));
				    $("#odMcConsExposure").html(validateResponse(jsonObj[i].odMcConsExposure));
				    $("#odMcAvailCollValue").html(validateResponse(jsonObj[i].odMcAvailCollValue));
				    $("#odMcTdConsExposure").html(validateResponse(jsonObj[i].odMcTdConsExposure));
				    $("#odMcTdAvailCollValue").html(validateResponse(jsonObj[i].odMcTdAvailCollValue));
				    $("#odMcRelatedAcctId").html(validateResponse(jsonObj[i].odMcRelatedAcctId));
				    $("#odMcTdMrktValueUnderFac").html(validateResponse(jsonObj[i].odMcTdMrktValueUnderFac));
				    $("#odMcHhi").html(validateResponse(jsonObj[i].odMcHhi));
				    $("#odMcIm").html(validateResponse(jsonObj[i].odMcIm));
				    $("#odMcBizApprovalGrp").html(validateResponse(jsonObj[i].odMcBizApprovalGrp));





				    $("#odMcBizApprovalNames").html(validateResponse(jsonObj[i].odMcBizApprovalNames));
				    if(jsonObj[i].odMcStatus == "Pending for Approval"){
				    	$("#odMcBizApprovalNames").html("<input type=\"text\" class=\"k-textbox\" id=\"odMcBizApprovalNamesField\" value=\""+validateResponse(jsonObj[i].odMcBizApprovalNames)+"\"></input>");
				    }else{
				    	$("#odMcBizApprovalNames").html("<input type=\"text\" class=\"k-textbox\" id=\"odMcBizApprovalNamesField\" disabled value=\""+validateResponse(jsonObj[i].odMcBizApprovalNames)+"\"></input>");
				    }




				    if(jsonObj[i].odMcIsBizApproval == "Y"){
				    	$("#odMcIsBizApproval").prop("checked",true);
				    }else{
				    	$("#odMcIsBizApproval").prop("checked",false);
				    }
				    $("#odMcRectificationReason").data("kendoDropDownList").value(validateResponse(jsonObj[i].odMcRectificationReason));
				    $("#odMcMarginSurplusOrCallAmt").html(validateResponse(jsonObj[i].odMcMarginSurplusOrCallAmt));
				    $("#odMcMarginPercent").html(validateResponse(jsonObj[i].odMcMarginPercent));
				    $("#odMcTdMarginSurplusOrCallAmt").html(validateResponse(jsonObj[i].odMcTdMarginSurplusOrCallAmt));
				    $("#odMcTdMarginPercent").html(validateResponse(jsonObj[i].odMcTdMarginPercent));
				    $("#odMcNegativeBalHkd").html(validateResponse(jsonObj[i].odMcNegativeBalHkd));
				    $("#odMcMrktValueCoveragePercent").html(validateResponse(jsonObj[i].odMcMrktValueCoveragePercent));
				    $("#odMcNavOrOverloss").html(validateResponse(jsonObj[i].odMcNavOrOverloss));
				    $("#odMcEqtyImPercent").html(validateResponse(jsonObj[i].odMcEqtyImPercent));
				    $("#odMcRemarks").val(validateResponse(jsonObj[i].odMcRemarks));
				    /*$("#odMcExpoMarginCallDoc").html(validateResponse(jsonObj[i].odMcExpoMarginCallDoc));*/
				    $("#leStatus").html(validateResponse(jsonObj[i].leStatus));




				    if(jsonObj[i].acctBizUnit == "PB"){
					    if(jsonObj[i].leIsGracePeriod == "Y"){
					    	$("#leIsGracePeriod").prop("checked",true);
					    }else{
					    	$("#leIsGracePeriod").prop("checked",false);
					    }
					}else{
				    	if(jsonObj[i].acctBizUnit == "ISD"){
				    		$("#leIsGracePeriod").prop("disabled", "disabled");
				    	}	
				    }




				    $("#userIdLe").html(validateResponse(jsonObj[i].leAssignApprover));
				    $("#leDaysInLmtDeficit").html(validateResponse(jsonObj[i].leDaysInLmtDeficit));
				    
				    $("#leSdConsLmtUtlz").html(validateResponse(jsonObj[i].leSdConsLmtUtlz));
				    $("#leTdConsLmtUtlz").html(validateResponse(jsonObj[i].leTdConsLmtUtlz));
				    $("#leApprovedLmtAmt").html(validateResponse(jsonObj[i].leApprovedLmtAmt));
				    $("#leLmtExpiryDt").html(validateResponse(jsonObj[i].leLmtExpiryDt));
				    $("#leBizApprovalGrp").html(validateResponse(jsonObj[i].leBizApprovalGrp));





				    $("#leBizApprovalNames").html(validateResponse(jsonObj[i].leBizApprovalNames));
				    if(jsonObj[i].leStatus == "Pending for Approval"){
				    	 $("#leBizApprovalNames").html("<input type=\"text\" class=\"k-textbox\" id=\"leBizApprovalNamesField\" value=\""+validateResponse(jsonObj[i].leBizApprovalNames)+"\"></input>");
				    }else{
				    	 $("#leBizApprovalNames").html("<input type=\"text\" class=\"k-textbox\" id=\"leBizApprovalNamesField\" disabled value=\""+validateResponse(jsonObj[i].leBizApprovalNames)+"\"></input>");
				    }





				    if(jsonObj[i].leIsBizApproval == "Y"){
				    	$("#leIsBizApproval").prop("checked",true);
				    }else{
				    	$("#leIsBizApproval").prop("checked",false);
				    }
				    $("#leRectificationReason").data("kendoDropDownList").value(validateResponse(jsonObj[i].leRectificationReason));
				    $("#leLmtSurplusDeficit").html(validateResponse(jsonObj[i].leLmtSurplusDeficit));
				    $("#leTdLmtSurplusDeficit").html(validateResponse(jsonObj[i].leTdLmtSurplusDeficit));
				    $("#leLmtUtlzPercent").html(validateResponse(jsonObj[i].leLmtUtlzPercent));
				    $("#leTdLmtUtlzPercent").html(validateResponse(jsonObj[i].leTdLmtUtlzPercent));
				    $("#leRemarks").val(validateResponse(jsonObj[i].leRemarks));
				    

				    /*if(value.pmeMaxTenorAllowUnit == "year"){
				        $("#pmeMaxTenorAllowUnitYear").prop("checked", true);
				        $("#pmeMaxTenorAllowUnitMonth").prop("checked", false);
				    }else{
				        $("#pmeMaxTenorAllowUnitYear").prop("checked", false);
				        $("#pmeMaxTenorAllowUnitMonth").prop("checked", true);
				    }*/




				    if(jsonObj[i].odMcStatus == "Pending for Approval" || jsonObj[i].odMcStatus == "Rejected" || jsonObj[i].odMcStatus == "Approved" || jsonObj[i].odMcStatus == "Rectified" || jsonObj[i].odMcStatus == "Pending for Liquidation"){

				    	$("#gracePeriodOnly1").css({"display":"none"});
				    	$("#graceOptions1").css({"display":"block"});

				    	if(jsonObj[i].odMcGraceType == "table3"){

					        $("#table3").prop("checked", true);

					    }else if(jsonObj[i].odMcGraceType == "table4"){

					        $("#table4").prop("checked", true);
					        
					    }else if(jsonObj[i].odMcGraceType == "gracePeriod"){

					        $("#grace").prop("checked", true);
					        
					    }else{

					    	$("#NA").prop("checked", true);
					    }

				    }else{

				    	$("#gracePeriodOnly1").css({"display":"block"});
				    	$("#graceOptions1").css({"display":"none"});

			    	 	if(jsonObj[i].odMcIsGracePeriod == "Y"){
				    		$("#odMcIsGracePeriod").prop("checked",true);
				    	}

				    }

				    if(jsonObj[i].leStatus == "Pending for Approval" || jsonObj[i].leStatus == "Rejected" || jsonObj[i].leStatus == "Approved" || jsonObj[i].leStatus == "Rectified" || jsonObj[i].leStatus == "Pending for Liquidation"){

				    	$("#gracePeriodOnly2").css({"display":"none"});
				    	$("#graceOptions2").css({"display":"block"});

				    	if(jsonObj[i].odMcGraceType == "table3"){

					        $("#table32").prop("checked", true);

					    }else if(jsonObj[i].odMcGraceType == "table4"){

					        $("#table42").prop("checked", true);
					        
					    }else if(jsonObj[i].odMcGraceType == "gracePeriod"){

					        $("#grace2").prop("checked", true);
					        
					    }else{

					    	$("#NA2").prop("checked", true);
					    }

				    }else{

				    	$("#gracePeriodOnly2").css({"display":"block"});
				    	$("#graceOptions2").css({"display":"none"});

			    	 	if(jsonObj[i].leIsGracePeriod == "Y"){
				    		$("#leIsGracePeriod").prop("checked",true);
				    	}
				    }



				    
					if(validateResponse(jsonObj[i].odMcRectifyExpiryDt) != ""){
						$("#rectif_approv_expiry_date").val(toDateFormat(validateResponse(jsonObj[i].odMcRectifyExpiryDt)));
						$("#dateTypeFlag").val("rectDate");
					}else{
						if(validateResponse(jsonObj[i].odMcApproveExpiryDt) != ""){
							$("#rectif_approv_expiry_date").val(toDateFormat(validateResponse(jsonObj[i].odMcApproveExpiryDt)));
							$("#dateTypeFlag").val("approvalDate");
						}else{

						}
					}
					if(validateResponse(jsonObj[i].leRectifyExpiryDt) != ""){
						$("#leRectifyExpiryDt").val(toDateFormat(validateResponse(jsonObj[i].leRectifyExpiryDt)));
						$("#dateTypeFlag").val("rectDate");
					}else{
						if(validateResponse(jsonObj[i].leApproveExpiryDt) != ""){
							$("#leRectifyExpiryDt").val(toDateFormat(validateResponse(jsonObj[i].leApproveExpiryDt)));
							$("#dateTypeFlag").val("approvalDate");
						}else{

						}
					}

					
				
			});
			
			
		});
		
		
		
		$(".actionBtn").click(function(){
			var msg = $(this).text();
			$(this).closest("tr").prevAll("tr.msgRow").show().find(".actionMessage").html(msg);
			console.log($(this).parents("table").find("tr.msgRow").length);
		});

		$(".actionBtn2").click(function(){
			var msg = $(this).text();
			$(this).closest("tr").prevAll("tr.msgRow2").show().find(".actionMessage2").html(msg);
			console.log($(this).parents("table").find("tr.msgRow2").length);
		});
		
		$(".noaction").click(function(){
			$(this).closest(".msgRow").hide();
			$(this).closest(".msgRow2").hide();
		});

		/* -- OD -- */

		/*$("#rectifyBtn").click(function(){
				
		});
		
		$("#seekApprovalBtn").click(function(){
			
		});

		$("#approveBtn").click(function(){
			
		});

		$("#rejectBtn").click(function(){
			
		});

		$("#forcedLiqudationBtn").click(function(){
			
		});*/

		/* -- LE -- */

		/*$("#rectifyBtn2").click(function(){
			
		});
		
		$("#seekApprovalBtn2").click(function(){
			
		});

		$("#approveBtn2").click(function(){
			
		});

		$("#rejectBtn2").click(function(){
			
		});

		$("#forcedLiqudationBtn2").click(function(){
			
		});
		*/
	});
	
	function validateResponse(data){
		return (data != null) ? data : "";
	}
	
	
	</script>
	<body>
	<input type="hidden" id="dateTypeFlag"></input>
	<div class="margin-call-wrapper">
		<div class="details-wrapper">
			<div class="list-header">Rectification or Exceptional Approval</div>
			<table>
				<tr class="table-list-header">
					<td colspan="4" >
						<div>Account Details</div>
					</td>
				</tr>
				<tr>
					<td class="odd-td-format">Credit Group</td>
					<td ><div id="creditGroup"></div></td>
					<td class="odd-td-format">Sales Name</td>
					<td><div id="acctSalesmanName"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">Account No.</td>
					<td><div id="acctId"></div></td>
					<td class="odd-td-format">Sales Code</td>
					<td><div id="acctSalesmanCode"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">Sub Acc</td>
					<td><div id="subAcctId"></div></td>
					<td class="odd-td-format">Limit Type</td>
					<td><div id="lmtTypeDesc"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">Account Name</td>
					<td><div id="acctName"></div></td>
					<td class="odd-td-format">Facility ID</td>
					<td><div id="facId"></div></td>
				</tr>
				<tr class="table-list-header">
					<td colspan="4" >
						<div>Client Level Total</div>
					</td>
				</tr>
				<tr>
					<td class="odd-td-format">Total LEE deficit of Client</td>
					<td><div id="totalClientLeeDeficit"></div></td>
					<td class="odd-td-format">Total Overdue or Call Amount</td>
					<td><div id="totalClientOverdueOrCallAmt"></div></td>
				</tr>
				<tr class="table-list-header">
					<td colspan="4" >
						<div class="form">Cash Overdue or Margin Call Section</div>
					</td>
				</tr>
				
				<tr class="msgRow">
					<td colspan="4">
						Are you Confirm <span class="actionMessage bold" ></span> Margin Call Section <a id="confirm1" onclick="sendRequestsOd()" href="#" class="anchor">[Yes]</a>|<a class="anchor noaction" href="#">[No]</a> 
					</td>
				</tr>
				
				<tr>
					<td class="odd-td-format background-color">Overdue or Margin Call workflow Status</td>
					<td><div id="odMcStatus" class="background-color"></div></td>
					<td rowspan="2" colspan="2">
						<div>
							<div id="gracePeriodOnly1" style="display: none" class="selection-panel">
								<input type="checkbox" name="graceperiod" id="odMcIsGracePeriod" value="Y"/><label for="graceperiod" class="bold">Grace Period</label>
							</div>
							<br>
							<div id="graceOptions1" style="display: none">
								<br>
								<input type="radio" disabled name="optionsGrace1" id="grace" />Grace<br>
								<input type="radio" disabled name="optionsGrace1" id="table3" />Table 3<br>
								<input type="radio" disabled name="optionsGrace1" id="table4" />Table 4<br>
								<input type="radio" disabled name="optionsGrace1" id="NA" /> N/A<br>
							</div>
							<div id="marigncall-button-panel" class="marigncall-button-panel">
								<!-- Trigger and Rejected Button Set -->
								
									<button style="display: none;" id="rectifyBtn" class="k-button actionBtn" type="button">Rectify</button>
									<button style="display: none;" id="seekApprovalBtn" class="k-button actionBtn" type="button">Seek Approval</button>
								
								<!-- Pending for Approval Button Set -->
								
									<button style="display: none;" id="approveBtn" class="k-button actionBtn" type="button">Approve</button>
									<button style="display: none;" id="rejectBtn" class="k-button actionBtn" type="button">Reject</button>
									<button style="display: none;" id="forcedLiqudationBtn" class="k-button actionBtn" type="button">Forced Liqudiation</button>
								
							</div>
							<div class="clear"></div>
						</div>
					</td>					
				</tr>
				
				<tr>
					<td class="dimmed" id="odMcAssignApprover">Assign another Approver</td>
					<td>
						<div class="selection-panel">
							<button id="notifyBtn" class="k-button" type="button">Notify</button>
						</div>
						<div class="marigncall-button-panel">
							<a href="#" id="openUser1" onclick="openUserPopup('od')"><img src="/ermsweb/resources/images/person-icon.png" width="30" height="30"></img></a>
						</div>
						<div style="width: 200px" id="userIdOd"></div>
						<div class="clear"></div>
					</td>					
				</tr>
				<tr>
					<td class="odd-td-format">Days in Margin Call or Overdue</td>
					<td><div id="odMcDaysInOdMarginCall"></div></td>
					<td class="odd-td-format">Rectification/ApprovalExpiry Date</td>
					<td><input class="rectif_approv_expiry_date" id="rectif_approv_expiry_date"></input></td>
				</tr>
				<tr>
					<td class="odd-td-format">Consolidated Exposure</td>
					<td ><div id="odMcConsExposure"></div></td>
					<td class="odd-td-format">Overdue or Margin Call Amount</td>
					<td><div id="odMcMarginSurplusOrCallAmt"></div></td>
				</tr>
				
				<tr>
					<td class="odd-td-format">Available Collateral Value</td>
					<td ><div id="odMcAvailCollValue"></div></td>
					<td class="odd-td-format">Margin %</td>
					<td><div id="odMcMarginPercent"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">TD Consolidated Exposure</td>
					<td ><div id="odMcTdConsExposure"></div></td>
					<td class="odd-td-format">TD Margin Call Amount</td>
					<td><div id="odMcTdMarginSurplusOrCallAmt"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">TD Available Collateral Value</td>
					<td ><div id="odMcTdAvailCollValue"></div></td>
					<td class="odd-td-format">TD Margin %</td>
					<td><div id="odMcTdMarginPercent"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">Related PB Account</td>
					<td ><div id="odMcRelatedAcctId"></div></td>
					<td class="odd-td-format">Negative Balance (PB)</td>
					<td><div id="odMcNegativeBalHkd"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">TD Market Value under the Facility</td>
					<td ><div id="odMcTdMrktValueUnderFac"></div></td>
					<td class="odd-td-format">Market Value Coverage %</td>
					<td><div id="odMcMrktValueCoveragePercent"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">HHI</td>
					<td ><div id="odMcHhi"></div></td>
					<td class="odd-td-format">NAV or Overloss</td>
					<td><div id="odMcNavOrOverloss"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">Initial Margin </td>
					<td ><div id="odMcIm"></div></td>
					<td class="odd-td-format">Equity / IM %</td>
					<td><div id="odMcEqtyImPercent"></div></td>
				</tr>
				<tr>
					<td class="dimmed">Business Approval Authority </td>
					<td ><div id="odMcBizApprovalGrp"></div></td>
					<td class="dimmed">Business Approvers</td>
					<td><div id="odMcBizApprovalNames"></div></td>
				</tr>
				<tr>
					<td class="dimmed">Business Approval</td>
					<td colspan="3">
						<input type="checkbox" name="approval" class="dimmed" id="odMcIsBizApproval" value="Y"/><label for="approval_check" class="dimmed">Approved</label>
						<span class="odd-td-format margin-rectification" id="rectArea1" > Rectification Reason </span> <input id="odMcRectificationReason"/>
					</td>
				</tr>
				
				<tr>
					<td class="odd-td-format" style="display: inline">Attachments 
						<!-- <button id="uploadBtn" class="k-button" type="button">Upload</button> -->
						<!-- <form method="POST" action=window.sessionStorage.getItem('serverPath')+"expoMarginCall/uploadDocument?creditGroup=GRP01&ccdId=CC1234&acctId=1234&subAcctId=2000&monitorType=MCOD&userId=RISKADMIN" enctype="multipart/form-data" style="display: inline"> -->
							<input type="file" id="uploadFile" style="width: 100%" class=" k-primary"></input>
							<br>
							<input type="submit" class="k-button" onclick="submitForm('od')" id="sendFile1" value="Save" style="float: right" ></input>
						<!-- </form> -->
						<div class="clear"></div>
					</td>
					
					<td rowspan="2" colspan="3">
						<span class="odd-td-format margin-remarks">Remarks</span>
						<textarea class="text-area-style" id="odMcRemarks"></textarea>
					</td>					
				</tr>
				
				<tr>
					<td>
						<div id="odMcExpoMarginCallDoc">
						</div>
					</td>
								
				</tr>
				<tr><td colspan="4">&nbsp;</td></tr>
				
				<tr class="table-list-header">
					<td colspan="4" >
						<div class="form">Limit Deficit Section</div>
					</td>
				</tr>
				<tr class="msgRow2">
					<td colspan="4">
						Are you Confirm <span class="actionMessage2 bold" ></span> Margin Call Section <a id="confirm2" href="#" class="anchor" onclick="sendRequestsLe()">[Yes]</a>|<a class="anchor noaction" href="#">[No]</a> 
					</td>
				</tr>
				
				<tr>
					<td class="odd-td-format background-color">Limit Deficit workflow status</td>
					<td><div id="leStatus" class="background-color" ></div></td>
					<td rowspan="2" colspan="2">
						<div>
							<div id="gracePeriodOnly2" style="display: none" class="selection-panel">
								<input type="checkbox" name="graceperiod2" id="leIsGracePeriod" value="Y"/><label for="graceperiod2" class="bold">Grace Period</label>
							</div>
							<br>
							<div id="graceOptions2" style="display: none">
								<br>
								<input type="radio" disabled name="optionsGrace2" id="grace2" />Grace<br>
								<input type="radio" disabled name="optionsGrace2" id="table32" />Table 3<br>
								<input type="radio" disabled name="optionsGrace2" id="table42" />Table 4<br>
								<input type="radio" disabled name="optionsGrace2" id="NA2" /> N/A<br>
							</div>
							<div class="marigncall-button-panel">
								
									<button style="display: none;" id="rectifyBtn2" class="k-button actionBtn2" type="button">Rectify</button>
									<button style="display: none;" id="seekApprovalBtn2" class="k-button actionBtn2" type="button">Seek Approval</button>
								
								<!-- Pending for Approval Button Set -->
								
									<button style="display: none;" id="approveBtn2" class="k-button actionBtn2" type="button">Approve</button>
									<button style="display: none;" id="rejectBtn2" class="k-button actionBtn2" type="button">Reject</button>
									<button style="display: none;" id="forcedLiqudationBtn2" class="k-button actionBtn2" type="button">Forced Liqudiation</button>
								
							</div>
							<div class="clear"></div>
						</div>
					</td>					
				</tr>
				
				<tr>
					<td class="dimmed" id="leAssignApprover">Assign another Approver</td>
					<td>
						<div class="selection-panel">
							<button id="notifyBtn2" class="k-button" type="button">Notify</button>
						</div>
						<div class="marigncall-button-panel" id="leAssignApprover">
							<a href="#" id="openUser2" onclick="openUserPopup('le')"><img src="/ermsweb/resources/images/person-icon.png" width="30" height="30"></img></a>
						</div>
						<div id="userIdLe"></div>
						<div class="clear"></div>
					</td>					
				</tr>
				<tr>
					<td class="odd-td-format">Days in Limit Deficit</td>
					<td><div id="leDaysInLmtDeficit"></div></td>
					<td class="odd-td-format">Rectification/ApprovalExpiry Date</td>
					<td><input class="rectif_approv_expiry_date" id="leRectifyExpiryDt"></input></td>
				</tr>
				<tr>
					<td class="odd-td-format">Cons. Limit Utilization</td>
					<td ><div id="leSdConsLmtUtlz"></div></td>
					<td class="odd-td-format">SD Limit Deficit</td>
					<td><div id="leLmtSurplusDeficit"></div></td>
				</tr>
				
				<tr>
					<td class="odd-td-format">TD Cons. Limit Utilization</td>
					<td ><div id="leTdConsLmtUtlz"></div></td>
					<td class="odd-td-format">TD Limit Deficit</td>
					<td><div id="leTdLmtSurplusDeficit"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">Approved Limit Amount</td>
					<td ><div id="leApprovedLmtAmt"></div></td>
					<td class="odd-td-format">SD Limit Utilization %</td>
					<td><div id="leLmtUtlzPercent"></div></td>
				</tr>
				<tr>
					<td class="odd-td-format">Limit Expiry Date</td>
					<td ><div id="leLmtExpiryDt"></div></td>
					<td class="odd-td-format">TD Limit Utilization %</td>
					<td><div id="leTdLmtUtlzPercent"></div></td>
				</tr>
				
				<tr>
					<td class="dimmed">Business Approval Authority </td>
					<td ><div id="leBizApprovalGrp"></div></td>
					<td class="dimmed">Business Approvers</td>
					<td><div id="leBizApprovalNames"></div></td>
				</tr>
				<tr>
					<td class="dimmed">Business Approval</td>
					<td colspan="3">
						<input type="checkbox" name="approval2" class="dimmed" id="leIsBizApproval" value="Y"/><label for="approval_check" class="dimmed">Approved</label>
						<span class="odd-td-format margin-rectification" id="rectArea2"> Rectification Reason </span> <input id="leRectificationReason"/>
					</td>
				</tr>
				
				<tr>
					<td class="odd-td-format" style="display: inline">Attachments 
					<input class="k-primary" style="width: 100%"  type="file" id="uploadFile2"></input>
					<br>
					<input type="submit" class="k-button" style="float: right" onclick="submitForm('le')" id="sendFile2" value="Save"></input>
					<div class="clear"></div>
					</td>
					
					<td rowspan="3" colspan="3">
						<span class="odd-td-format margin-remarks" >Remarks</span>
						<textarea class="text-area-style" id="leRemarks"></textarea>
					</td>					
				</tr>
				
				<tr>
					<td>
						<div id="leExpoMarginCallDoc">
						</div>
					</td>
					
								
				</tr>
				<tr><td><br></br></td></tr>
				<tr><td><br></br></td></tr>

			</table>
		</div>
	</div>	

	<div id="searchUserWindow">
		<div id="userGrid"></div>
	</div>
	</body>
</html>	