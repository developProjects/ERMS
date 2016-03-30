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
					
                    var start = $("#start").kendoDatePicker({
                        value: today,
                        change: startChange,
                        format: "dd/MM/yyyy",
                        parseFormats: kendo.toString(new Date(), "dd/MM/yyyy")
                    }).data("kendoDatePicker");

                    var end = $("#end").kendoDatePicker({
                        value: today,
                        change: endChange,
                        format: "dd/MM/yyyy",
                        parseFormats: ["dd/MMyyyy"]
                    }).data("kendoDatePicker");

                    start.max(end.value());
                    end.min(start.value());
                    
					$("#bizUnit").kendoDropDownList();
						//var getLargeExpoMonByGrpURL = "/ermsweb/resources/js/getErmsLargeExpoMonByGrp.json?userId="+window.sessionStorage.getItem('username');
					//grid layer for second call
						$(document).on('click', '#submitBtn', function(){
							dataGrids();
						});
						$("#resetBtn").kendoButton({
							click : function(){
								$('input[type=text]').val('');
							}
						});
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
			var getLsfPeDlyMonEnqURL = window.sessionStorage.getItem('serverPath')+"expoLSFPE/getLsfPeDlyMonEnq?userId="+window.sessionStorage.getItem('username')+"&bizUnit="+$("#dropValue").val()+"&rmdGroupId="+$('#grpDesc').val()+"&loanInvRefId="+$('#LoanId').val()+"&rptFromDate="+$('#start').val()+"&rptToDate="+$('#end').val()+"&pageSize=5&skip=0";
			//var getLsfPeDlyMonEnqURL = "http://localhost:8080/ermsweb/getLsfPeDlyMonEnq1?userId="+window.sessionStorage.getItem('username')+"&bizUnit="+$("#dropValue").val()+"&rmdGroupId="+$('#grpDesc').val()+"&loanInvRefId="+$('#LoanId').val()+"&rptFromDate="+$('#start').val()+"&rptToDate="+$('#end').val()+"&pageSize=5&skip=0";
			//var getLsfPeDlyMonEnqURL = "/ermsweb/resources/js/getLsfPeDlyMonEnq.json";
			var activeDataSource = new kendo.data.DataSource({
												transport: {
													read: {
														url: getLsfPeDlyMonEnqURL,
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
				
				dataSource: activeDataSource,
				excel: {
					 allPages: true,
					 fileName :"PE Daily Monitoring Report"
				},
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
			    					{ field: "clientName", title: "Client Name" , width: 150, template: '#=hrefLink1(projectName, clientName)#'},
			    					{ field: "acctId", title: "Account No", width: 120, template: '#=hrefLink2(projectName, clientName, acctId)#'},
			    					{ field: "dailyMonitorRptDate", title: "Daily Monitoring Report Date (yyyy/mm/dd)", width: 120, template: '#=hrefLink3(dailyMonitorRptDate, clientName, acctId)#'},
			    					{ field: "ltvMonitorRptDate", title: "LTV Monitoring Report Date (yyyy/mm/dd)", width: 120, template: '#=hrefLink4(ltvMonitorRptDate)#'},
			    					{ field: "", title: "Loan/Investment Details" , width: 120, template: '#=hrefLink5(loanTxNo)#'},
			    					
			    			]
			    			});
						closeModal();
					}
		
		function hrefLink(projectLink){
				return "<a href='/ermsweb/counterpartyexposure?ProjectName="+projectLink+"'>"+projectLink+"</a>";
		}
		function hrefLink1(projectLink, clientLink){
				return "<a href='/ermsweb/counterpartyexposure?ProjectName="+projectLink+"/&ClientName="+clientLink+"'>"+clientLink+"</a>";
		}
		function hrefLink2(projectLink, clientLink, accLink){
			return "<a href='/ermsweb/counterpartyexposure?ProjectName="+projectLink+"&ClientName="+clientLink+"&accLink="+accLink+"'>"+accLink+"</a>";
		}
		
		function hrefLink3(obj){
			if(obj != null && obj != ''){
				var chk = $('#dropValue').val();
				if(chk == "PE"){
					return  "<a href='/ermsweb/T24InvestmentDetails'>"+kendo.toString( new Date(parseInt(obj)), "dd/MM/yyyy" )+"</a>";
				}else{
					return  "<a href='/ermsweb/ltvMonitoringReport'>"+kendo.toString( new Date(parseInt(obj)), "dd/MM/yyyy" )+"</a>";
				}
			}
			if(obj == null || ''){
				return "";
			}
		} 
		
		function hrefLink4(obj){
			if(obj != null && obj != ''){
				var chk = $('#dropValue').val();
				if(chk == "PE"){
					return  kendo.toString( new Date(parseInt(obj)), "dd/MM/yyyy" );
				}else{
					return  "<a href='/ermsweb/ltvMonitoringReport'>"+kendo.toString( new Date(parseInt(obj)), "dd/MM/yyyy" )+"</a>";
				}
			}
			if(obj == null || ''){
				return "";
			}
		} 
		function hrefLink5(loanTxNo){
			var chk = $('#dropValue').val();
			if(chk == "PE"){
				return  "<a href='/ermsweb/T24InvestmentDetails?loanTxNo="+loanTxNo+"'>View Details</a>";
			}else{
				return  "<a href='/ermsweb/loanLSFDetails?loanTxNo="+loanTxNo+"''>View Details</a>";
			}
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
		
		  function onClickSearchProjectName(){
              $("#searchWindow").data("kendoWindow").open();
              $("#searchWindow").data("kendoWindow").center();
          }
		  
		  function clickProjectGroup(){

              var dataSource = new kendo.data.DataSource({
                  transport: {
                      read: {
                          url:window.sessionStorage.getItem('serverPath')+"groupDetail/searchGroups?userId="+window.sessionStorage.getItem("username")+"&rmdGroupDesc="+$('#groupName2').val(),
                          //url:"/ermsweb/resources/js/searchGroups.json",
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
							//url:"/ermsweb/resources/js/searchLegalPartiesGroup.json",
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
		
		function openModal() {
		   $("#modal, #modal1").show();
		}
		
		function closeModal() {
		   $("#modal, #modal1").hide();	    
		}
	
	</script>
	</head>
	
			<!-- <div width="1000"> -->
				<!-- <script type="text/javascript" src="/ermsweb/resources/js/header.js"></script> -->
				<%-- <%@include file="header.jsp"%> --%> 
				<br>
				<div id="limitHeader" style="background-color:#B54D4D; color:#fff;margin-bottom: 30px; padding:4px 0px 4px 0px; display:none;">Limit/Exposure Monitoring Alert - Large Exposure Violation</div>
				
				
<!-- Large Exposure Conditinal search criteria starts-->
			<div id="limitData">
			<div style="background-color:pink; width:1000" class="pageTitle">PE Daily Monitoring Report Enquiry</div>
			<!-- Start -->
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
						<td>&nbsp; : &nbsp; </td>
						 <td style="width: 300px;"><select  id="dropValue"></select></span></td>
					</tr>
					 <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td>Project Name</td>
                        <td>&nbsp; : &nbsp; </td>
                        <td><input id="projectName" class="k-textbox" style="width: 300px;" type="text"/><input type="button" id="searchGroup" class="k-button" value="Search" onClick="onClickSearchProjectName()"></input></td>                                  
                    </tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td>Client Name</td>
                        <td>&nbsp; : &nbsp; </td>
                        <td><input id="ClientName" class="k-textbox" style="width: 300px;" type="text"/><input type="button" id="searchCcpty" class="k-button" value="Search" onclick="onClickSearchCcpty()"></input></td>                                  
                    </tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td>Loan / Investment Reference ID</td>
                        <td>&nbsp; : &nbsp; </td>
                        <td><input id="LoanId" class="k-textbox" style="width: 300px;" type="text"/></td>
                    </tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td>Report Date - To Date</td>
                        <td>&nbsp; : &nbsp; </td>
                        <td style="width: 300px;"><input id="start" style="width: 200px;" />&nbsp;&nbsp;&nbsp;&nbsp;To&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td><input id="end" style="width: 200px;" /></td>
                    </tr>
                    <tr>   
                        <td colspan="3">&nbsp;</td>
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
			
			<!-- end -->
			
		</div> 
				<!--  ends-->
				<br/><br/>
				<div id="list"></div>
				
				
				<!-- popUp window -->
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
                            <td><input class="k-textbox" id="groupName2" name="groupName2" type="text"/></td>
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
                                <button class="k-button"   type="button" onclick="clickProjectGroup()">Search</button>
                                <button class="k-button inResetBtn" type="button" onclick="toReset('group')">Reset</button>
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
                                <button class="k-button inResetBtn1" type="button" onclick="toReset('ccpty')">Reset</button>
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
				
		
</html>
