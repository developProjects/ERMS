<html lang="en">	
	<head>
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
	
	<style>
		.k-pager-wrap,.k-grid-pager,.k-widget{
			width:100%;
		}
		.k-animation-container{width:250px !important;}
		
	</style>
    <!-- jQuery JavaScript -->
    <script src="/ermsweb/resources/js/jquery.min.js"></script>
    <script src="/ermsweb/resources/js/jszip.min.js"></script>

    <!-- Kendo UI combined JavaScript -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>

 	<script type="text/javascript">
				
 	 $(document).ready(function () {
 		$('input[name="event"]').on('change', function(){
 			if($('#eventExp').is(':checked')){
 			$('#eExpId').attr('disabled', false);
 			$('#eOverId').attr('disabled', true);
 			$('#start').attr('disabled', true);
 			$('#end').attr('disabled', true);
 			}
 			if($('#eventOverDue').is(':checked')){
 			$('#eOverId').attr('disabled', false);
 			$('#eExpId').attr('disabled', true);
 			$('#start').attr('disabled', true);
 			$('#end').attr('disabled', true);
 			}
 			if($('#reportDate').is(':checked')){
 			$('#start').attr('disabled', false);
 			$('#end').attr('disabled', false);
 			$('#eOverId').attr('disabled', true);
 			$('#eExpId').attr('disabled', true);
 			}
 			});
					//alert(true);
					$('.inResetBtn').click(function(){
						$('#groupName1').val('');
						$('#groupType2').val('');
						$('#grid').html('');
					});
						
					$('.inResetBtn1').click(function(){
						$('#legalPartyCat').val('');
						$('#ccptyName').val('');
						$('#grid').html('');
					});
					$('.inResetBtn2').click(function(){
						$('#acctNo').val('');
						$('#acctName').val('');
						$("#grid3").html('');
					});
					
					
					
					 $("#searchWindow").kendoWindow({
                    width: "800px",
                    height: "650px",
                    modal: true,
                    title: "Search RMD Group",
                    visible: false
               		 });
					 $("#searchWindow2").kendoWindow({
		                    width: "800px",
		                    height: "650px",
		                    modal: true,
		                    title: "Search Client / Counter Party",
		                    visible: false
		             });
					 $("#searchWindow3").kendoWindow({
		                    width: "800px",
		                    height: "650px",
		                    modal: true,
		                    title: "Search Account",
		                    visible: false
		                });
					function startChange() {
                        var startDate = start.value(),
                        endDate = end.value();

                        if (startDate) {
                            startDate = new Date( startDate);
                            startDate.setDate(startDate.getDate());
                            end.min(startDate);
                        } else if (endDate) {
                            start.max(new Date(endDate));
                        } else {
                            endDate = new Date();
                            start.max(endDate);
                            end.min(endDate);
                        }
                    }

                    function endChange() {
                        var endDate = end.value(),
                        startDate = start.value();

                        if (endDate) {
                            endDate = new Date(endDate);
                            endDate.setDate(endDate.getDate());
                            start.max(endDate);
                        } else if (startDate) {
                            end.min(new Date(startDate));
                        } else {
                            endDate = new Date();
                            start.max(endDate);
                            end.min(endDate);
                        }
                    }

                    //var today = kendo.date.today();
                    //Default: Business date before today
                    Date.prototype.preDate = function(){
                    	var curDate = this.getDate();
                    	var beforeDate = new Date(this.setDate(curDate-1));
                    	return beforeDate;
                    }
                    var currentDate = new Date();
                    var today = currentDate.preDate();
					console.log(today);
					
                    var start = $("#start").kendoDateTimePicker({
                        value: today,
                        change: startChange,
                        format: "yyyy/MM/dd",
                        parseFormats: kendo.toString(new Date(), "yyyy/MM/dd")
                    }).data("kendoDateTimePicker");

                    var end = $("#end").kendoDateTimePicker({
                        value: today,
                        change: endChange,
                        format: "yyyy/MM/dd",
                        parseFormats: ["yyyy/MM/dd"]
                    }).data("kendoDateTimePicker");

                    start.max(end.value());
                    end.min(start.value());
                    
					$("#bizUnit").kendoDropDownList();
					
					
					var limitOperatorData = [
					                			{ text: "LFS", value: "LFS" },
					                			{ text: "PE", value: "PE" }
					                		];
					                  				
					                		$("#dropValue").kendoDropDownList({
					                			dataTextField: "text",
					                			dataValueField: "value",
					                			dataSource: limitOperatorData,
					                			index: 0
					                		});	
						//var getLargeExpoMonByGrpURL = "/ermsweb/resources/js/getErmsLargeExpoMonByGrp.json?userId="+window.sessionStorage.getItem('username');
					//grid layer for second call
						$(document).on('click', '#submitBtn', function(){
							dataGrids();
						});
						
			
						if($('#eventExp').is(":checked")){
							return "eventExpireIn="+$('#eExpId').val();
						}
						if($('#eventOverDue').is(":checked")){
							return "eventOverdue="+$('#eOverId').val();
							
						}
						if($('#reportDate').is(":checked")){
							return "dueDateFrom="+$('#start').val()+"&dueDateTo="+$('#end').val();
						}
						$("#resetBtn").kendoButton({
							click : function(){
								$('input[type=text]').val('');
							}
						});
						$("#exportBtn").kendoButton({
	          				click: function(){
	          					
	          					var Grid = $("#list").data("kendoGrid");
	          					
	          					if(Grid){
	          						Grid.saveAsExcel();
	          					}
	          				}
	          			}); 
					});
				
		//Displaying Data in the Grids
		function dataGrids(){
			$('#dailyReport').css('display', 'block');
			$(".empty-height").hide();
			openModal();
			function status(chk){
				if($('#'+chk).is(":checked")){
			    	return chk; 
				}else{
					return "";
				}
			}
			function radioChk(){
				if($('#eventExp').is(":checked")){
					return "eventExpireIn="+$('#eExpId').val();
				}
				if($('#eventOverDue').is(":checked")){
					return "eventOverdue="+$('#eOverId').val();
					
				}
				if($('#reportDate').is(":checked")){
					return "dueDateFrom="+$('#start').val()+"&dueDateTo="+$('#end').val();
				}
			}
			
			
			//var getPEreminderURL = window.sessionStorage.getItem('serverPath')+"expoLSFPE/getLsfPeReminder?userId="+window.sessionStorage.getItem('username')+"&bizUnit="+$("#dropValue").val()+"&rmdGroupId="+$('#grpDesc').val()+"&"+radioChk()+"&statusAll="+status($('#statusALL').val())+"&statusPMA="+status($('#statusPMA').val())+"&statusEOR="+status($('#statusEOR').val())+"&statusFN="+status($('#statusFN').val())+"&pageSize=5&skip=0";
			var getPEreminderURL = window.sessionStorage.getItem('serverPath')+"expoLSFPE/getLsfPeReminder?userId="+window.sessionStorage.getItem('username')+"&bizUnit="+$("#dropValue").val()+"&rmdGroupId="+$('#grpDesc').val()+"&"+radioChk()+"&statusAll="+status($('#statusALL').val())+"&statusPMA="+status($('#statusPMA').val())+"&statusEOR="+status($('#statusEOR').val())+"&statusFN="+status($('#statusFN').val())+"&pageSize=5&skip=0";
			//var getPEreminderURL = "/ermsweb/resources/js/getLsfPeDlyMonEnq.json";
			var activeDataSource = new kendo.data.DataSource({
												transport: {
													read: {
														url: getPEreminderURL,
														dataType: "json",
							                        	xhrFields: {
							                            	withCredentials: true
							                           	}
														
													}
												},
												error:function(e){
				if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}													
			},
												pageSize: 3
											});
			
$("#list").kendoGrid({
    			
	excel: {
		 allPages: true,
		 fileName : "PE Reminder"
	},
	dataSource: activeDataSource,
		pageSize: 1,
		schema: {
		  model: {
			fields: {
   	    				projectName:{ type: "string" },
   	    				clientName: { type: "string" },
   	    				acctId: { type: "string" },
   	    				dailyMonitorRptDate: { type: "string" },
   	    				ltvMonitorRptDate: { type: "string" },
   	    			}
   	    			}
   	    			},
    			
    			//toolbar: ["excel"],
    			scrollable:true,
    			pageable: true,
    			columns: [
    					{ field: "projectName", title: "Project Name" , width: 120, template: '#=hrefLink(projectName)#'},
    					{ field: "clientName", title: "Client Name" , width: 150},
    					{ field: "dueDate", title: "Due Date", width: 120, template: "#=hrefLink1()#"},
    					{ field: "type", title: "Type", width: 120},
    					{ field: "status", title: "Status", width: 120},
    					{ field: "event", title: "Event", width: 120}
    			]
    			});
			closeModal();
		}

		function hrefLink(link){
			var chk = $('#dropValue').val();
			if(chk == "PE"){
				return  "<a href='/ermsweb/T24InvestmentDetails'>"+link+"</a>";
			}else{
				return  "<a href='/ermsweb/loanLSFDetails'>"+link+"</a>";
			}
		} 
		function hrefLink1(obj){
			
				if(obj != null && obj != ''){
					return  kendo.toString( new Date(parseInt(obj)), "MM/dd/yyyy" );
				}else{
					return "";						
				}
		}
		function openModal() {
		     $("#modal, #modal1").show();
		}

		function closeModal() {
		    $("#modal, #modal1").hide();	    
		}
					
					
		
		function expandCriteria(){
			var filterBody = document.getElementById("filterBody").style.display;
			if(filterBody == "block"){
				document.getElementById("filterBody").style.display = "none";
				document.getElementById("filterTable").innerHTML = "(+) Filter Criteria";
			}else{
				document.getElementById("filterBody").style.display = "block";
				document.getElementById("filterTable").innerHTML= "(-) Filter Criteria";
			}
		} 
		
		
		
		//popUp Window Start
		 function onClickSearchProjectName(){
              $("#searchWindow").data("kendoWindow").open();
              $("#searchWindow").data("kendoWindow").center();
          }
		  
		  function clickProjectGroup(){

              var dataSource = new kendo.data.DataSource({
                  transport: {
                      read: {
                          url:window.sessionStorage.getItem('serverPath')+"groupDetail/searchGroups?userId="+window.sessionStorage.getItem("username")+"&rmdGroupDesc="+$('#groupName1').val(),
                          //url:"/ermsweb/resources/js/searchGroups.json?userId="+window.sessionStorage.getItem("username")+"&rmdGroupDesc="+$('#groupName1').val(),
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
                             rmdGroupId: { type: "string" },
                             groupTypeDesc: { type: "string" },
                             rmdGroupDesc: { type: "string" }
                          }
                      }
                  },
                  pageSize: 11
              });
              
              $('#grid').kendoGrid({
                  dataSource: dataSource,
                  filterable: false,
                  columnMenu: false,
                  sortable: true,
                  pageable: {
                      refresh: true,
                      pageSize: 5
                  },
                  scrollable: true,
                  columns: [  
                      { field: "", title: "" ,width: 80, template: "#=selectGroupAction(rmdGroupId, groupTypeDesc, rmdGroupDesc)#"},
                      { field: "rmdGroupId", title: "Group ID" ,width: 200},
                      { field: "groupTypeDesc", title: "Group Type" ,width: 200},
                      { field: "rmdGroupDesc", title: "Group Name" ,width: 200}
                  ]
               });
          }
		  
		  function selectGroupAction(rmdGroupId, groupTypeDesc, rmdGroupDesc){
              return "<input class='k-button' type='button' onclick='changeGroupFieldsValue(\""+rmdGroupId+"\", \""+rmdGroupDesc+"\")' value='Select'/>";
          } 
		  
		  
		  function onClickSearchCcpty(){
              $("#searchWindow2").data("kendoWindow").open();
              $("#searchWindow2").data("kendoWindow").center();
          }
		  
		   function clickSearchCcpty(){

               var dataSource2 = new kendo.data.DataSource({
                   transport: {
                       read: {
						//url:"/ermsweb/resources/js/searchLegalPartiesGroup.json?userId="+window.sessionStorage.getItem("username")+"&ccdName="+$('#ccptyName').val(),
                    	   url:window.sessionStorage.getItem('serverPath')+"legalParty/searchLegalPartiesGroup?userId="+window.sessionStorage.getItem("username")+"&ccdName="+$('#ccptyName').val(),
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
                              rmdGroupId: { type: "string" },
                              rmdGroupDesc: { type: "string" }
                           }
                       }
                   },
                   pageSize: 5
               });

               $('#grid2').kendoGrid({
            	   dataSource: dataSource2,
                   sortable: true,
                   pageable: {
                       pageSize: 5
                   },
                   scrollable: true,
                   columns: [  
                       { field: "", title: "" ,width: 80, template: "#=selectCcptyAction(ccdId, ccdNameEng, rmdGroupId)#"},
                       { field: "rmdGroupDesc", title: "Group Name" ,width: 200},
                       { field: "ccdNameEng", title: "Client/Counter Party Name" ,width: 200},
                       { field: "ccdId", title: "CCD ID" ,width: 200},
                       { field: "legalPartyCat", title: "legal Party Cat" ,width: 200},
                       { field: "cmdClientId", title: "CMD Client ID", width: 200},
                       { field: "externalKey1", title: "externalKey1", width: 200},
                       { field: "externalKey2", title: "externalKey2", width: 200},
                       { field: "externalKey3", title: "externalKey3", width: 200},
                       { field: "externalKey4", title: "externalKey4", width: 200},
                       { field: "externalKey5", title: "externalKey5", width: 200},
                       { field: "externalKey6", title: "externalKey6", width: 200},
                       { field: "externalKey7", title: "externalKey7", width: 200},
                       { field: "externalKey8", title: "externalKey8", width: 200},
                       { field: "externalKey9", title: "externalKey9", width: 200},
                       { field: "externalKey10", title: "externalKey10", width: 200}
                   ]
                });
           }
		   
		   function selectCcptyAction(ccdId, ccdNameEng, rmdGroupId){
               return "<input class='k-button' type='button' onclick='changeCcptyFieldsValue(\""+ccdId+"\",\""+ccdNameEng+"\", \""+rmdGroupId+"\")' value='Select'/>";
           }
		   
		   function onClickSearchAccount(){
               $("#searchWindow3").data("kendoWindow").open();
               $("#searchWindow3").data("kendoWindow").center();
           }
		   
		   function clickSearchAccount(){

               var dataSource = new kendo.data.DataSource({
                   transport: {
                       read: {
                           url:window.sessionStorage.getItem('serverPath')+"acct/searchAccountsGroup?userId="+window.sessionStorage.getItem("username")+"&accountNo="+$("#acctNo").val()+"&accName="+$("#acctName").val()+"&subAcc="+$("#subAcctNo").val(),
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
                              rmdGroupId: { type: "string" },
                              groupTypeDesc: { type: "string" },
                              rmdGroupDesc: { type: "string" }
                           }
                       }
                   },
                   pageSize: 11
               });
               $('#grid3').kendoGrid({
                   dataSource: dataSource,
                   filterable: false,
                   columnMenu: false,
                   sortable: true,
                   pageable: {
                       refresh: true,
                       pageSize: 5
                   },
                   scrollable: true,
                   columns: [  
                       { field: "", title: "" ,width: 80, template: "#=selectAccountAction(ccdId, acctId, rmdGroupId, subAcc)#"},
                       { field: "rmdGroupDesc", title: "Group Name" ,width: 200},
                       { field: "ccdId", title: "CCD ID" ,width: 200},
                       { field: "acctId", title: "Account No", width: 200},
                       { field: "subAcc", title: "subAccountNo", width: 200},
                       { field: "accNameEng", title: "accNameEng", width: 200}
                   ]
                });
           }
		   function selectAccountAction(ccdId, accountNo, rmdGroupId, subAccountNo){
               return "<input class='k-button' type='button' onclick='changeAccountFieldsValue(\""+ccdId+"\",\""+accountNo+"\", \""+rmdGroupId+"\",\""+subAccountNo+"\")' value='Select'/>";
           }

		   function changeGroupFieldsValue(rmdGroupId, rmdGroupDesc){
               $("#projectName").val(rmdGroupDesc);
               $("#grpDesc").val(rmdGroupId);
               //$("#groupName").val(checkUndefinedElement(rmdGroupDesc));
               $("#searchWindow").data("kendoWindow").close();
           }
		   
           function changeCcptyFieldsValue(ccdId, ccdNameEng, rmdGroupId){
               $("#ClientName").val(ccdNameEng);
               //$("#groupId").val(checkUndefinedElement(rmdGroupId));
               //$("#ccdId").val(checkUndefinedElement(ccdId));
               $("#searchWindow2").data("kendoWindow").close();
           }
           function changeAccountFieldsValue(ccdId, accountNo, rmdGroupId, subAccountNo){
               $("#accNum").val(accountNo);  
               //$("#subAccountNo").val(checkUndefinedElement(subAccountNo));
               //$("#groupId").val(checkUndefinedElement(rmdGroupId));
               //$("#ccdId").val(checkUndefinedElement(ccdId));
               $("#searchWindow3").data("kendoWindow").close();
           }
		
	
	</script>
	</head>
	
			<!-- <div width="1000"> -->
				<!-- <script type="text/javascript" src="/ermsweb/resources/js/header.js"></script> -->
				<%-- <%@include file="header.jsp"%> --%> 
				<br>
				<div id="limitHeader" style="background-color:#B54D4D; color:#fff;margin-bottom: 30px; padding:4px 0px 4px 0px; display:none;">Limit/Exposure Monitoring Alert - Large Exposure Violation</div>
				
<!-- Start -->
		<div id="limitData">
			<div style="background-color:pink; width:1000" class="pageTitle">LSF / PE Reminder</div>
			 <table style="background-color:#DBE5F1;" cellpadding="0" cellspacing="0"  border="0" width="100%">
                <tr>
                    <td colspan="3" style="background-color:#393052; color:white;">
                        Search Criteria
                    </td>
                </tr>
                <tbody id="filterBody" style="display : block; padding-left: 7px;">
                    <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
						<td>Business Unit</td>
						 <td style="width: 300px;"><select  id="dropValue"></select></span></td>
					</tr>
					 <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td>Project Name</td>
                        <td><input id="projectName" class="k-textbox" style="width: 300px;" type="text"/></td>
                        <td><input type="button" id="projectGroup" class="k-button" value="Search" onClick="onClickSearchProjectName()"></input></td>                                  
                    </tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td>Client Name</td>
                        <td><input id="ClientName" class="k-textbox" style="width: 300px;" type="text"/></td>
                        <td><input type="button" id="searchCcpty" class="k-button" value="Search" onclick="onClickSearchCcpty()"></input></td>                                  
                    </tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td>Account Number</td>
                        <td><input id="accNum" class="k-textbox" style="width: 300px;" type="text"/></td>
                        <td><input type="button" class="k-button" value="Search" onclick="onClickSearchAccount()"></input></td>
                    </tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                    	<td><input type="radio" name="event" id="eventExp">Event Expiring in</td>
                    	<td><input id="eExpId" type="text" class="k-textbox"/><span>&nbsp;&nbsp;days</span></td>
                    </tr>
                     <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                    	<td><input type="radio" name="event" id="eventOverDue">Event Overdue for more than</td>
                    	<td><input id="eOverId" type="text" class="k-textbox"/> <span>&nbsp;&nbsp;days</span></td>
                    </tr>
                     <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td><input type="radio" name="event" id="reportDate">Report Date - To Date</td>
                        <td style="width: 300px;"><input id="start" style="width: 200px;" />&nbsp;&nbsp;&nbsp;&nbsp;To&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td><input id="end" style="width: 200px;" /></td>
                    </tr>
                    <tr>   
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
						<td><span>status</span></td>
					</tr>
					<tr>
						<td><span style="display: inline-block;width: 230px;"><input type="checkbox" id="statusALL" value="statusALL"/> &nbsp;&nbsp;&nbsp;All</span></td>
						 <td><span><input type="checkbox" id="statusPMA" value="statusPMA"/></span>Pending / Maturing / Analysis Update Required</td>
					</tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                    	<td><span style="display: inline-block;width: 230px;"><input type="checkbox" id="statusEOR" value="statusEOR"/> &nbsp;&nbsp;&nbsp;Overdue / Expired / Reapproval Required</span></td>
                    	<td> <span><input type="checkbox" id="statusFN" value="statusFN"/></span>Failed / Not Complied (pending approval)</td>
                    </tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
						<td colspan="6" align="right">
							<button id="submitBtn" class="k-button" type="button">Search</button>
							<button id="resetBtn" class="k-button" type="button">Reset</button>
							<button id="exportBtn" class="k-button" type="button">Export</button>
						</td>
					</tr>
                </tbody>
            </table>
		</div> 

<!-- End -->
				<br/><br/>
				<div id="list"></div>
		
		
		<div id="searchWindow">
                <table id="listTable" width="95%" style="background-color:#DBE5F1; overflow-x:scroll; border-bottom; position: absolute; border-collapse: collapse; " cellpadding="0" cellspacing="0">
                    <tr>
                        <td colspan="3" style="background-color:#8DB4E3; width:100%">
                            <b><div id="filterTable" onclick="">(+) Filter Criteria</div></b>
                        </td>
                    </tr>
                    <tbody style="display: block">
                        <tr>
                            <td>Group Name.</td>
                            <td><input class="k-textbox" id="groupName1" name="groupName2" type="text"/></td>
                            <td>Group Type.</td>
                            <td><input class="k-textbox" id="groupType2" name="groupType2" type="text"/></td>
                        </tr>
                        <tr><td><br></td></tr>
                        <tr><td><br></td></tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td colspan="2"><b></b></td>
                            <td>
                                <button class="k-button" type="button" onclick="clickProjectGroup()">Search</button>
                                <button class="k-button inResetBtn"  type="button">Reset</button>
                            </td>
                        </tr>
                    </tbody>
                    <tr>
                        <td colspan="4">
                             <div id="grid"></div>
                              <input type="hidden" id="grpDesc" value=""/>
                             <input type="hidden" id="" value=""/>
                        </td>
                    </tr>
                </table>
            	</div>
            	
            	<div id="searchWindow2">

                <table id="listTable" width="95%" style="background-color:#DBE5F1; overflow-x:scroll; border-bottom; position: absolute; border-collapse: collapse; " cellpadding="0" cellspacing="0">
                    <tr>
                        <td colspan="3" style="background-color:#8DB4E3; width:100%">
                            <b><div id="filterTable" onclick="">(+) Filter Criteria</div></b>
                        </td>
                    </tr>
                    <tbody style="display: block">
                        <tr>
                            <td>Client / Counter Party</td>
                            <td><input class="k-textbox" id="legalPartyCat" name="legalPartyCat" type="text"/></td>
                            <td>Name</td>
                            <td><input class="k-textbox" id="ccptyName" name="ccptyName" type="text"/></td>
                        </tr>
                        <tr><td><br></td></tr>
                        <tr><td><br></td></tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td colspan="2"><b></b></td>
                            <td>
                                <button class="k-button" type="button" onclick="clickSearchCcpty()">Search</button>
                                <button class="k-button inResetBtn1" type="button" >Reset</button>
                            </td>
                        </tr>
                    </tbody>
                    <tr>
                        <td colspan="4">
                             <div id="grid2"></div>
                             <input type="hidden" id="" value=""/>
                              <input type="hidden" id="" value=""/>
                        </td>
                    </tr>
                </table>
            </div>
            
             <div id="searchWindow3">

                <table id="listTable" width="95%" style="background-color:#DBE5F1; overflow-x:scroll; border-bottom; position: absolute; border-collapse: collapse; " cellpadding="0" cellspacing="0">
                    <tr>
                        <td colspan="3" style="background-color:#8DB4E3; width:100%">
                            <b><div id="filterTable" onclick="">(+) Filter Criteria</div></b>
                        </td>
                    </tr>
                    <tbody style="display: block">
                        <tr>
                            <td>Account No.</td>
                            <td><input class="k-textbox" id="acctNo" name="acctNo" type="text"/></td>
                            <td>Name</td>
                            <td><input class="k-textbox" id="acctName" name="acctName" type="text"/></td>
                        </tr>
                        <tr>
                            <td>Sub-Account No.</td>
                            <td><input class="k-textbox" id="subAcctNo" name="subAcctNo" type="text"/></td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr><td><br></td></tr>
                        <tr><td><br></td></tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td colspan="2"><b></b></td>
                            <td>
                                <button class="k-button" type="button" onclick="clickSearchAccount()">Search</button>
                                <button class="k-button inResetBtn2" type="button">Reset</button>
                            </td>
                        </tr>
                    </tbody>
                    <tr>
                        <td colspan="4">
                             <div id="grid3"></div>
                        </td>
                    </tr>
                </table>
            </div>
		
		
		
</html>
