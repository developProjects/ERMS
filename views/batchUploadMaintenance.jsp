<html lang="en">

	<meta http-equiv="Content-Style-Type" content="text/css">
    <meta http-equiv="Content-Script-Type" content="text/javascript">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 
    <script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>
  
    <!-- Kendo UI API -->
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.common.min.css">
    
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.rtl.min.css"><link rel="stylesheet" href="/ermsweb/resources/css/kendo.default.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.dataviz.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.dataviz.default.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.mobile.all.min.css">
    
      <!-- General layout Style -->
    <link href="/ermsweb/resources/css/layout.css" rel="stylesheet" type="text/css">
    
    <!--  <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/2.5.0/jszip.min.js"></script> -->
    <!-- jQuery JavaScript -->
    <script src="/ermsweb/resources/js/jquery.min.js"></script>
    <script src="/ermsweb/resources/js/jszip.js"></script>
    <!-- <script src="/ermsweb/resources/js/jquery.fileupload.js"></script> -->
	<script src="http://kendo.cdn.telerik.com/2014.3.1029/js/kendo.all.min.js"></script>
	<script type="text/javascript">
	 $(document).ready(function () {
	      /* $('input[type=file]').change(function () {
	          var filePath= $('#files').val(); 
	         	$('#filePath').val(filePath);
		         	$('.file').on('file', function (event, files, label) {
		         		 $('.path').html($(this).val().replace(/\\/g, '/').replace(/.*\//, ''));
		         		 alert($(this).val());
		         	});
	     }); 
	     
	     $('#submit').on('click', uploadFiles); */

	    
	     function onSelect(e) {
             console.log("Select :: " + getFileInfo(e));
         }

         function onUpload(e) {
             console.log("Upload :: " + getFileInfo(e));
         }

         function onSuccess(e) {
         	$(".list-header").show();
         	e.preventDefault();
         	console.log(e);
         	fileData = e;
         	
         	 //var getBatchUploadDetailsURL = "/ermsweb/BatchUploadMaintenance/excelUpload";
    	     
			/*   var activeDataSource = new kendo.data.DataSource({
					transport: {
						read: {
							url: getBatchUploadDetailsURL,
							dataType: "json",
						
							//data:searchCriteria
						}
					},
					pageSize: 3
				}); */
        	$("#list").kendoGrid({
    			
    			dataSource: {
    				data : e.response,
    				schema: {
    	    			model: {
    	    			id: "creditGroup",
    	    			fields: {
    	    				creditGroup:{ type: "string" },
    	    				counterpartyName: { type: "string" },
    	    				accEntity: { type: "string" },
    	    				accountNo: { type: "string" },
    	    				subAcc: { type: "string" },
    	    				accStatus: { type: "string" },
    	    				accAccType: { type: "string" },
    	    				businessUnit: { type: "string" },
    	    				limitType: { type: "string"  },
    	    				limitHierarchyLevel: { type: "string" },
    	    				parentLimitType: { type: "string" },
    	    				facilityID: { type: "string" },
    	    				limitExpiryDate: { type: "string" },
    	    				limitCcy: { type: "string" },
    	    				limitAmount: { type: "string" },
    	    				limitAmountLEEBased: { type: "string" }
    	    			}
    	    			}
    	    			},
    	    			pageSize: 5
    			},
    			
    			//toolbar: ["excel"],
    		
    			
    			scrollable:true,
    			pageable: true,
    			columns: [
    					 { field: "rmdGroupId", title: "Action" , width: 150},
    					 { field: "bizUnitCd", title: "Business Unit Code", width: 120},
    					{ field: "cmdId", title: "Client / Counterparty Hierarchy" , width: 120},
    					{field:"groupId", title:"Group ID", width: 120},
    					{ field: "cptyId", title: "Client / Counterparty ID" , width: 150},
    					{ field: "cptyId", title: "CCD ID" , width: 150},
    					{ field: "cptyId", title: "CMD Client ID" , width: 150},
    					{ field: "cptyId", title: "CCD ID" , width: 150},
    					{ field: "cptyId", title: "CCD ID" , width: 150},
    					{ field: "acctBookEntity", title: "Account ID", width: 120},
    					{ field: "accId", title: "Account No", width: 120},
    					{ field: "subAcct", title: "Sub-Account No", width: 120},
    					{ field: "facilityId", title: "Facility ID", width: 120},
    					{ field: "facilityId", title: "Limit Type ID", width: 120},
    					{ field: "bizUnitCd", title: "Facility Purpose", width: 120},
    					{ field: "lmtTypeId", title: "Limit Type", width: 120},
    					{ field: "facilityPurpose", title: "Facility Purpose", width: 120},
    					{ field: "lendingUnit", title: "Lending Unit", width: 120},
    					{ field: "newExpiryDt", title: "New Expiry Date", width: 120},
    					{ field: "newFacLmtCcy", title: "New Facility Limit CCY", width: 120},
    					{ field: "newFacLmtAmt", title: "New Facility Limit Amount", width: 120},
    					{ field: "cntNewExpDt", title: "Counter Offer: New Expiry Date", width: 120},
    					{ field: "cntNewFacLmtCcy", title: "Counter Offer: New Facility Limit CCY", width: 120},
    					{ field: "cntNewFacLmtAmt", title: "Counter Offer: New Facility Limit Amount", width: 120},
    					{ field: "lmtRiskRating", title: "Limit Risk Rating", width: 120},
    					{ field: "colType", title: "Collateral Type", width: 120},
    					{ field: "lmtTenor", title: "Limit Tenor", width: 120},
    					{ field: "lmtTenorLmt", title: "Limit Tenor Unit", width: 120},
    					{ field: "proposedPrice", title: "Proposed Pricing ", width: 120},
    					{ field: "percentPropsedPrice", title: "Operator for Percentage of Proposed Pricing", width: 120},
    					{ field: "", title: "Percentage of Proposed Pricing", width: 120},
    					{ field: "feeCommission", title: "Fees & Commission", width: 120},
    					{ field: "arrangeHandleFee", title: "Arrangement / Handling Fee", width: 120},
    					{ field: "proposedPriceOthers", title: "others", width: 120},
    					{ field: "remarksCate", title: "Remarks - Remarks Category", width: 120},
    					{ field: "remarks", title: "Remarks - Remarks content", width: 120},
    					{ field: "reviewRoleDescBr", title: "Review info - Role Description", width: 120},
    					{ field: "reviewRoleNamecBr", title: "Review info - Name", width: 120},
    					{ field: "reviewRoleEmailBr", title: "Review Info - email Address", width: 120},
    					{ field: "reviewRoleDtBr", title: "Review info - Date(yyyymmdd)", width: 120},
    			]
    			});
             console.log("Success (" + e.operation + ") :: " + getFileInfo(e));
         }

         function onError(e) {
             console.log("Error (" + e.operation + ") :: " + getFileInfo(e));
         }

         function onComplete(e) {
             console.log("Complete");
         }

         function onCancel(e) {
             console.log("Cancel :: " + getFileInfo(e));
         }

         function onRemove(e) {
             console.log("Remove :: " + getFileInfo(e));
         }

         function onProgress(e) {
             console.log("Upload progress :: " + e.percentComplete + "% :: " + getFileInfo(e));
         }

         function getFileInfo(e) {
             return $.map(e.files, function(file) {
                 var info = file.name;

                 // File size is not available in all browsers
                 if (file.size > 0) {
                     info  += " (" + Math.ceil(file.size / 1024) + " KB)";
                 }
                 return info;
             }).join(", ");
         }
         $('#uplaod').on('click', function(){
         $("#files").kendoUpload({
             async: {
                 saveUrl: window.sessionStorage.getItem('serverPath')+"limitapplication/batchUpload?username=RISKADMIN",
                 xhrFields: {
                     withCredentials: true
                    },
                 autoUpload: true
             }, 
             
             cancel: onCancel,
             complete: onComplete,
             error: onError,
             progress: onProgress,
             remove: onRemove,
             select: onSelect,
             success: onSuccess,
             upload: onUpload
         });
         });
	     
	  // Catch the form submit and upload the files
	
	 
			
			
			
		
			
			
	});
</script>
</head>
<body>
<%@include file="header1.jsp"%>
  <div class="page-title">Limit Application BatchUpload</div>
  <div id="example" style="border: 1px solid #ccc;width: 500px;">
        
                <div class="demo-section k-content">
                    <input name="file" id="files" type="file" />
                    <p style="padding-top: 1em; text-align: right">
                        <input id="uplaod" value="Submit" class="k-button k-primary" style="margin:5px;"/>
                    </p>
                </div>
            
        </div>
        
         <!-- <div class="demo-section k-content">                    
                    <input name="files" id="files" type="file" />
                </div>     --> 
<div class="list-header" style="display:none;">Rejected Records</div>           
<div id="list"></div>        
    
</body>
</html>
