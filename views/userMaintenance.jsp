	<html lang="en">
	
		<meta http-equiv="Content-Style-Type" content="text/css">
	    <meta http-equiv="Content-Script-Type" content="text/javascript">
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 
	    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.common.min.css">	
	    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.rtl.min.css">
	    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.default.min.css">
	    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.dataviz.min.css">
	    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.dataviz.default.min.css">
	    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.mobile.all.min.css">
	    <link href="/ermsweb/resources/css/layout.css" rel="stylesheet" type="text/css">
	    <script src="/ermsweb/resources/js/jquery.min.js"></script>
	    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
	    <script src="/ermsweb/resources/js/common_tools.js"></script>
	    <script src="/ermsweb/resources/js/jquery.min.js"></script>
	    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
	    <script src="/ermsweb/resources/js/jszip.min.js"></script>
	 	<script src="/ermsweb/resources/js/common_tools.js"></script>
	 	<script>
        
	        var wnd, detailsTemplate;

		 	$("#authority").kendoDropDownList();

        	$(document).ready(function () {
        		submitButtonEvent();
	        	$("#submitBtn").kendoButton({
	        		click: function(e) {
						submitButtonEvent();
		            }
		       	});
		       	$("#resetBtn").kendoButton({
		       		click: function(e) {
		       			
		       		}
		       	});
		       	$("#exportBtn").kendoButton();
		       	
		       	$("#popup_editor").kendoWindow({
		       		actions: ["Minimize", "Maximize", "Close"],
		       		width: "500px",
		       		height: "350px",
		       		modal: true,
		       		title: "Edit and Update",
		       		visible: false,
		       		resizable: false	,
		       		animation: true
		       	});
		       	$("#popup_creator").kendoWindow({
		       		actions: ["Minimize", "Maximize", "Close"],
		       		width: "500px",
		       		height: "350px",
		       		modal: true,
		       		title: "Add new user",
		       		visible: false,
		       		resizable: false	,
		       		animation: true
		       	});

        	});

			/* Handle underfined / null element */
			
			function fillDataToFrame(userId, username, teamCode, bizUnit, roleId, authority, status){

				return "<input type='button' class='k-button' onclick=\"editBtnOnClick('"+userId.replace( "\\", "\\\\")+"','"+username+"','"+teamCode+"','"+bizUnit+"','"+roleId+"','"+authority+"','"+status+"')\" value='Edit'/>";
			}

			function toDeleteRole(){

				var	jsonArr = 	{ 
									userId: document.getElementById("userId").value,
									userName: document.getElementById("username").value,
									action: "DELETE",
									teamCode: document.getElementById("teamCode").options[document.getElementById("teamCode").selectedIndex].value,
									bizUnit: document.getElementById("bizUnit").options[document.getElementById("bizUnit").selectedIndex].value,
									roleId: document.getElementById("roleId").options[document.getElementById("roleId").selectedIndex].value,
									lastUpdateBy: window.sessionStorage.getItem("username")
								};

				var dataSource = new kendo.data.DataSource({
					transport: {
					    read: function(options) {	
		                    $.ajax({
		                        type: "POST",
		                        url: window.sessionStorage.getItem('serverPath')+"user/saveUserTeamRole",
		                        data: JSON.stringify(jsonArr),
                        		xhrFields: {
                            		withCredentials: true
                            	},
		                        contentType: "application/json; charset=utf-8",
		                        dataType: "json",
		                        success: function (result) {
		                            options.success(result);
		                        },
		                        complete: function (jqXHR, textStatus){
									if(status == "success"){
			    			    		submitButtonEvent();
						    		}
						    	}
							})
						}
		            },
			    		schema: { 
				            model:{
				            	id: "data",
				            	fields:{
				            		data: {type: "string"}    
				            	}
				            }
				        }				
					});

					dataSource.read();
					submitButtonEvent();

			}

			function functionOnChangeList(teamCode, bizUnit){

				var dataSource = new kendo.data.DataSource({
				
					transport: {
						read: {
							url: window.sessionStorage.getItem('serverPath')+"team/getTeamMap?userId="+window.sessionStorage.getItem("username"),
							dataType: "json",
							
							xhrFields: {
					    		withCredentials: true
					    	},
					    	type: "GET",
					    	complete: function (response, status){	

		    			    	if(status == "success"){
		    			    		var i = 0;
		    			    		/*if(teamCode != "" && teamCode != null){*/
		    			    			$.each(JSON.parse(response.responseText), function(key, value) {

							     				var arrayFromValue = key;
		     					     		  	var option = document.createElement("option");
		     						     		option.text = arrayFromValue;
		     						     		option.value = arrayFromValue;
		     						     		document.getElementById("teamCode").appendChild(option);

		     						     		if(teamCode == arrayFromValue){
		     						     			document.getElementById("teamCode").selectedIndex = i;	
		     						     		}
		     						     		i++;
								     	});
							    		
		    			    		/*}*/
		    			    	}
		    			    }
						}
					},
					error:function(e){
									if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
								},						
		    		schema: { 
			            model:{
			            	id: "data",
			            	fields:{
			            		data: {type: "string"}    
			            	}
			            }
			        }				
				});

				dataSource.read();

			}
			function bizUnitOnChangeList(teamCode, bizUnit){

				var dataSource = new kendo.data.DataSource({
				
						transport: {
							read: {
								url: window.sessionStorage.getItem('serverPath')+"team/getTeamMap?userId="+window.sessionStorage.getItem("username"),
								dataType: "json",
								xhrFields: {
						    		withCredentials: true
						    	},
						    	type: "GET",
						    	complete: function (response, status){	

						    		clearDropDownWithoutBlank("bizUnit");

			    			    	if(status == "success"){

			    			    		if(teamCode != "" && teamCode != null){
								     		$.each(JSON.parse(response.responseText), function(key, value) {

							     				if(key == teamCode){	

								     				var arrayFromValue = value;

								     				for (var i = 0; i < arrayFromValue.length; i++) {

				     					     		  	var option = document.createElement("option");
				     						     		option.text = arrayFromValue[i];
				     						     		option.value = arrayFromValue[i];
				     						     		document.getElementById("bizUnit").appendChild(option);

				     						     		if(bizUnit == arrayFromValue[i]){
				     						     			document.getElementById("bizUnit").selectedIndex = i ;	
				     						     		}
								     				}
								     			}
								     			option = null;
							    			});
										}
							    	}
								}
							}
						},
			    		schema: { 
				            model:{
				            	id: "data",
				            	fields:{
				            		data: {type: "string"}    
				            	}
				            }
				        }				
					});

					dataSource.read();

			}
			function editBtnOnClick(userId, username, teamCode, bizUnit, roleId, authority, status){

				document.getElementById('editCorner').style.display = "block";
				document.getElementById("userId").value =  userId;
				document.getElementById("username").value = username; 

				clearDropDownWithoutBlank("bizUnit");
				clearDropDown("authority");
				clearDropDownWithoutBlank("roleId");
				clearDropDownWithoutBlank("teamCode");


				/* ############### teamCode Handle ############### */
				functionOnChangeList(teamCode, bizUnit);
				if(teamCode == "" || teamCode == null){
					teamCode = 	"CA";
				}
				bizUnitOnChangeList(teamCode, bizUnit);
				/* bizUnit List Handle */
				/*option = document.createElement("option");
				option.text = checkUndefinedElement(bizUnit);
				option.value = checkUndefinedElement(bizUnit);
				document.getElementById("bizUnit").appendChild(option);
				document.getElementById("bizUnit").selectedIndex = 1;
				option = null;*/

				/* ############### Role List Handle ############### */
				var roleIdList = ["RMD_VIEWER",
				                  "RMD_MAKER",
				                  "RMD_CHECKER",
				                  "RMD_APPROVER",
				                  "RMD_APPROVER_REPRESENTATIVE",
				                  "CA_CHECKER",
				                  "RMD_ENDORSER",
				                  "EXCEPT_OPERATOR"];

				for(var i = 0 ; i < roleIdList.length  ; i++){
					var option = document.createElement("option");
					option.text = checkUndefinedElement(roleIdList[i]);
					option.value = checkUndefinedElement(roleIdList[i]);
					document.getElementById("roleId").appendChild(option);
				}
				option = null;	
				$("#roleId option").filter(function() {
				    return $(this).text() == roleId; 
				}).prop('selected', true);

				/* ############### Authority List Handle ############### */
				var authorityList = ["SO", "SBO", "SRO"];
				
				for (var i = 0; i < authorityList.length; i++) {
					var option = document.createElement("option");
				
					option.text = checkUndefinedElement(authorityList[i]);
		     		option.value = checkUndefinedElement(authorityList[i]);
		     		document.getElementById("authority").appendChild(option);
				};
				option = null;	
				$("#authority option").filter(function() {
				    return $(this).text() == authority; 
				}).prop('selected', true);
				

				/* Status Radio Handle */
				/*if(status == "Active"){
					document.getElementById("statusY").checked = true;
				}else {
					document.getElementById("statusN").checked = true;
				}*/

				/*onChangeBizUnit(document.getElementById("teamCode"));*/
			}

			function getCookie(key) {  
			   var keyValue = document.cookie.match('(^|;) ?' + key + '=([^;]*)(;|$)');  
			   return keyValue ? keyValue[2] : null;  
			} 

			function getUserId(){
				return window.sessionStorage.getItem("username");
			}
			function openCreator(){
				$("#popup_creator").data("kendoWindow").center().open();
			}
			function showDetails(e) {
	            e.preventDefault();

	            var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
	            wnd.content(detailsTemplate(dataItem));
	            wnd.center().open();
	        }
	        function toBack(){
	        	document.getElementById('editCorner').style.display = "none";
	        	wnd.center().close();
	        }
			function submitButtonEvent(){   

				/* --------------- Get User List ---------------- */

		     	var getUserURL = window.sessionStorage.getItem('serverPath')+"user/getUserTeamRole?userId="+window.sessionStorage.getItem("username"); 
		     	
		    	var dataSource = new kendo.data.DataSource({
		    		transport: {
		    			read: {
		    	   		  	type: "GET",
		    			    url: getUserURL,
		    			    
		    			    dataType: "json",
		    			    contentType: "application/json; charset=utf-8",
		    			    xhrFields: {
					    		withCredentials: true
					    	}
		    			}
		    		},
		    		error:function(e){
									if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
								}
		    	});   

		     	$('#MyGrid1').kendoGrid({
		     	 	dataSource: dataSource,
		     	 	filterable: false,
		     	 	columnMenu: false,
		     	 	sortable: true,
		     	 	pageable: false,
		     	 	height: 400,

		     	 	/*locked: true */// Frozen Column //
		     	 	columns: [ 	
		         	 	{ 			         	
		         	 		width: 80, 
		         	 		attributes: {
		         	 			style: "font-size: 11px"
		         	 		},
		         	 		template: "#=fillDataToFrame(checkUndefinedElement(userId), checkUndefinedElement(userName), checkUndefinedElement(teamCode), checkUndefinedElement(bizUnit), checkUndefinedElement(roleId), checkUndefinedElement(authority), status)#"
		         	 	},
		         	 	{ 	
		         	 		field: "userId" ,
		         	 		width: 200, 
		         	 		attributes: {
		         	 			style: "font-size: 11px"
		         	 		},
		         	 		template: "#=checkUndefinedElement(checkUndefinedElement(userId))#"
		         	 	},
		         	 	{ 
		         	 		field: "userName" ,
		         	 		width: 200,
		         	 		attributes: {
		         	 			style: "font-size: 11px"
		         	 		},
		         	 		template: "#=checkUndefinedElement(userName)#"
		         	 	},
		         	 	{ 
		         	 		field: "teamCode" ,
		         	 		width: 200,
		         	 		attributes: {
		         	 			style: "font-size: 11px"
		         	 		},
		         	 		template: "#=checkUndefinedElement(teamCode)#"
		         	 	},
		         	 	{ 
		         	 		field: "bizUnit" ,
		         	 		width: 200,
		         	 		attributes: {
		         	 			style: "font-size: 11px"
		         	 		},
		         	 		template: "#=checkUndefinedElement(bizUnit)#"
	         	 		},
	         	 		{ 
		         	 		field: "status" ,
		         	 		width: 200,
		         	 		attributes: {
		         	 			style: "font-size: 11px"
		         	 		},
		         	 		template: "#=checkUndefinedElement(status)#"
	         	 		},
		         	 	{ 
		         	 		field: "roleId" ,
		         	 		width: 200,
		         	 		attributes: {
		         	 			style: "font-size: 11px"
		         	 		},
		         	 		template: "#=checkUndefinedElement(roleId)#"
		         	 	},
		         	 	{ 
		         	 		field: "lastUpdateDt" ,
		         	 		width: 200,
		         	 		attributes: {
		         	 			style: "font-size: 11px"
		         	 		},
		         	 		template: "#=toDateFormat(lastUpdateDt)#"
		         	 	},
		         	 	{ 
		         	 		field: "lastUpdateBy" ,
			         	 	width: 200,
			         	 	attributes: {
		         	 			style: "font-size: 11px"
		         	 		}
			         	},
		         	 	{ 
		         	 		field: "authority" ,
			         	 	width: 200,
			         	 	attributes: {
		         	 			style: "font-size: 11px"
		         	 		}
			         	}
		         	]
		     	});   	           

		     	dataSource.read();      	
			}

			function toSaveUserAuthority(){
				 
				if(checkUndefinedElement(document.getElementById("userId").value) == "" || 

					checkUndefinedElement(document.getElementById("username").value) == ""){
					alert("User ID or User Name can not be NULL or EMPTY");

				}else{
					var	jsonArr = 	{ 
										userId: document.getElementById("userId").value,
										userName: document.getElementById("username").value,
										action: "CREATE",
										lastUpdateBy: window.sessionStorage.getItem("username"),
										authority: document.getElementById("authority").options[document.getElementById("authority").selectedIndex].value
									};

					var dataSource = new kendo.data.DataSource({
						transport: {
						    read: function(options) {
			                    $.ajax({
			                        type: "POST",
			                        url: window.sessionStorage.getItem('serverPath')+"user/saveUserAuthority",
			                        data: JSON.stringify(jsonArr),
	                        		xhrFields: {
	                            		withCredentials: true
	                            	},
			                        contentType: "application/json; charset=utf-8",
			                        dataType: "json",
			                        success: function (result) {
			                            options.success(result);
			                        },
			                        complete: function (jqXHR, textStatus){
										if(status == "success"){
				    			    		clearDropDown("bizUnit");
								     		$.each(JSON.parse(response.responseText), function(key, value) {

								     			if(key == teamCode){	

								     				var arrayFromValue = value;

								     				for (var i = 0; i < arrayFromValue.length; i++) {

				     					     		  	var option = document.createElement("option");
				     						     		option.text = arrayFromValue[i];
				     						     		option.value = arrayFromValue[i];
				     						     		document.getElementById("bizUnit").appendChild(option);

				     						     		if(bizUnit == arrayFromValue[i]){
				     						     			document.getElementById("bizUnit").selectedIndex = (i+1) ;	
				     						     		}
								     				}		
								     			}
								     		});			     		
							    		}
							    		displayReturnMessage(jqXHR);
							    	}
								})
							}
			            },
				    		schema: { 
					            model:{
					            	id: "data",
					            	fields:{
					            		data: {type: "string"}    
					            	}
					            }
					        }				
						});

						dataSource.read();
						submitButtonEvent();
				}
			}
			function toSubmit(){

				var	jsonArr = 	{ 
									userId: document.getElementById("userId").value,
									userName: document.getElementById("username").value,
									action: "CREATE",
									teamCode: document.getElementById("teamCode").options[document.getElementById("teamCode").selectedIndex].value,
									bizUnit: document.getElementById("bizUnit").options[document.getElementById("bizUnit").selectedIndex].value,
									roleId: document.getElementById("roleId").options[document.getElementById("roleId").selectedIndex].value,
									lastUpdateBy: window.sessionStorage.getItem("username")
								};

				var dataSource = new kendo.data.DataSource({
					transport: {
					    read: function(options) {	
		                    $.ajax({
		                        type: "POST",
		                        url: window.sessionStorage.getItem('serverPath')+"user/saveUserTeamRole",
		                        data: JSON.stringify(jsonArr),
                        		xhrFields: {
                            		withCredentials: true
                            	},
		                        contentType: "application/json; charset=utf-8",
		                        dataType: "json",
		                        success: function (result) {
		                            options.success(result);
		                        },
		                        complete: function (jqXHR, textStatus){
									if(status == "success"){
			    			    		submitButtonEvent();
						    		}
						    	}
							})
						}
		            },
			    		schema: { 
				            model:{
				            	id: "data",
				            	fields:{
				            		data: {type: "string"}    
				            	}
				            }
				        }				
					});

					dataSource.read();
					submitButtonEvent();
			}
			function onChangeBizUnit(teamCode){
				var dataSource = new kendo.data.DataSource({
					transport: {
						read: {
							url: window.sessionStorage.getItem('serverPath')+"team/getTeamMap?userId="+window.sessionStorage.getItem("username"),
							dataType: "json",
							xhrFields: {
					    		withCredentials: true
					    	},
					    	type: "GET",
					    	complete: function (response, status){	

					    		clearDropDownWithoutBlank("bizUnit");

		    			    	if(status == "success"){

						     		$.each(JSON.parse(response.responseText), function(key, value) {

					     				if(key == teamCode.value){	

						     				var arrayFromValue = value;

						     				for (var i = 0; i < arrayFromValue.length; i++) {

		     					     		  	var option = document.createElement("option");
		     						     		option.text = arrayFromValue[i];
		     						     		option.value = arrayFromValue[i];
		     						     		document.getElementById("bizUnit").appendChild(option);
						     				}
						     			}
						     			option = null;
					    			});
						    	}
							}
						}
					},
		    		schema: { 
			            model:{
			            	id: "data",
			            	fields:{
			            		data: {type: "string"}    
			            	}
			            }
			        }				
				});

				dataSource.read();
			}
			function toDelete(){
				var	jsonArr = 	{ 
									userId: document.getElementById("userId").value,
									userName: document.getElementById("username").value,
									action: "DELETE",
									teamCode: document.getElementById("teamCode").options[document.getElementById("teamCode").selectedIndex].value,
									bizUnit: document.getElementById("bizUnit").options[document.getElementById("bizUnit").selectedIndex].value,
									roleId: document.getElementById("roleId").options[document.getElementById("roleId").selectedIndex].value,
									lastUpdateBy: window.sessionStorage.getItem("username")
								};

				var dataSource = new kendo.data.DataSource({
					transport: {
					    read: function(options) {	
		                    $.ajax({
		                        type: "POST",
		                        url: window.sessionStorage.getItem('serverPath')+"user/saveUserAuthority",
		                        data: JSON.stringify(jsonArr),
                        		xhrFields: {
                            		withCredentials: true
                            	},
		                        contentType: "application/json; charset=utf-8",
		                        dataType: "json",
		                        success: function (result) {
		                            options.success(result);
		                        },
		                        complete: function (jqXHR, textStatus){
									if(status == "success"){
			    			    		submitButtonEvent();
						    		}
						    	}
							})
						}
		            },
			    		schema: { 
				            model:{
				            	id: "data",
				            	fields:{
				            		data: {type: "string"}    
				            	}
				            }
				        }				
					});

					dataSource.read();
					submitButtonEvent();
					
			}
			function toExport(){

	            var getUserURL = window.sessionStorage.getItem('serverPath')+"user/getUserTeamRole?userId="+window.sessionStorage.getItem("username"); 
		     	
		    	var dataSource = new kendo.data.DataSource({
		    		transport: {
		    			read: {
		    	   		  	type: "GET",
		    			    url: getUserURL,
		    			    dataType: "json",
		    			    contentType: "application/json; charset=utf-8",
		    			    xhrFields: {
					    		withCredentials: true
					    	}
		    			}
		    		}
		    	});   

				var rows1 = [{
				    cells: [
				      { value : "userId" },
				      { value : "userName" },
				      { value : "teamCode" },
				      { value : "bizUnit" },
				      { value : "status" },
				      { value : "roleId" },
				      { value : "lastUpdateDt" },
				      { value : "lastUpdateBy" },
				      { value : "authority" }
				    ]
				}];
				var workbook = new kendo.ooxml.Workbook({
                    sheets: [
                    	{
                            columns: [
                                // Column settings (width)
                                { autoWidth: true },
                                { autoWidth: true },
                                { autoWidth: true },
                                { autoWidth: true },
                                { autoWidth: true },
                                { autoWidth: true },
                                { autoWidth: true },
                                { autoWidth: true },
                                { autoWidth: true }
                            ],
                                title: "User Account List",
                                rows: rows1
                        }
                    ]
                });
				dataSource.fetch(function(){

                    var data = dataSource.view();
                    
                    for (var i = 0; i < data.length; i++){
                      //push single row for every record
                      rows1.push({
                        cells: [
                          { value: data[i].userId },
                          /*{ value: data[i].rmdGroupId },*/
                          { value: data[i].userName },
                          { value: data[i].teamCode },
                          { value: data[i].bizUnit },
                          { value: data[i].status },
                          { value: data[i].roleId },
                          { value: toDateFormat(data[i].lastUpdateDt) },
                          { value: data[i].lastUpdateBy },
                          { value: data[i].authority }
                          /*{ value: data[i].total }*/
                        ]
                      });
                    }
                     kendo.saveAs({dataURI: workbook.toDataURL(), fileName: "User_List.xlsx"}); 
                });

			}
		    </script>
		
		<body onload="checkSessionAlive()">
			<input type="hidden" id="pagetitle" name="pagetitle" value="User Maintenace">
			
			<input class="k-button" type="button" value="Add User" id="createUser" style="width: 100px" onclick="editBtnOnClick('','','','','','','')" />
			<input class="k-button" type="button" value="Export" id="export" style="width: 100px" onclick="toExport()" />	
			<div style="display:inline" id="returnMessage"></div>

			<div style="width:100%;" id='MyGrid1'>
			</div>
			<br>
			<div id="editCorner" style="display: none">
	        	<table cellspacing="1" cellpadding="6" width="40%">
	        			<tr>
	        				<td colspan="4" style="background-color:#393052;color:white; width:500; font-size:13px">
	        					User Maintenance
	        				</td>
	        			</tr>
	                   	<tr>
	                   		<td style="font-size:13px; background-color:#E7E3EF">User ID</td>
	                   		<td style="font-size:13px; background-color:#E7E3EF; width:30% ">: <input class="k-textbox" type="text" id="userId"></input></td>
	                   		<td style="font-size:13px; background-color:#E7E3EF">User Name</td>
	                   		<td style="font-size:13px; background-color:#E7E3EF; width:30% ">: <input class="k-textbox" type="text" id="username"></input></td>
	                   	</tr>
	                   	<tr>
	                   		<td style="font-size:13px; background-color:#E7E3EF">Authority</td>
	                   		<td colspan="3" style="font-size:13px; background-color:#E7E3EF; width:30% ">: 
	                   			<select id="authority" class="select_join" style="width: 40%">
	                   			</select>
	                   			<div align="right">
	                   				<input type="button" onclick="toSaveUserAuthority()" id="saveUserAuthority" class="k-button" value="Add/Update User Authority"></input>
	                   				<input type="button" class="k-button" onclick="toDelete()" id="delete" value="Delete"/>
	                   			</div>
	                   		</td>
	                   	</tr>
	                   	<!-- <tr>
	                   		<td style="font-size:13px; background-color:#E7E3EF">Status</td>
	                   		<td style="font-size:13px; background-color:#E7E3EF; width:30% ">: 
	                   			<input type='radio' name="status" id="statusY" value='Y'/><label for="statusY">Active</label> <input type='radio' name='status' id="statusN" value='N'/><label for="statusN">Inactive</label>
	                   		<td style="font-size:13px; background-color:#E7E3EF"></td>
	                   		<td style="font-size:13px; background-color:#E7E3EF"></td>
	                   	</tr> -->
	                   	<tr>
	                   		<td colspan="4" style="background-color:#393052;color:white; width:500; font-size:13px">
	                   			Update User Role
	                   		</td>
	                   	</tr>
	                   	<tr>
	                   		<td style="font-size:13px; background-color:#E7E3EF">Role</td>
	                   		<td colspan="3" style="font-size:13px; background-color:#E7E3EF; width:30% ">:
	                   		 	<select class="select_join" style="width: 150px" id="roleId">
	                   		 	</select>
	                   		</td>
	                   	</tr>
	                   	<tr>
	                   		<td style="font-size:13px; background-color:#E7E3EF">Team</td>
	                   		<td style="font-size:13px; background-color:#E7E3EF; width:30% ">: 
	                   			<select class="select_join" onchange="onChangeBizUnit(this)" style="width: 150px" id="teamCode"></select>
	                   		</td>
	                   		<td style="font-size:13px; background-color:#E7E3EF">Biz Unit</td>
	                   		<td style="font-size:13px; background-color:#E7E3EF; width:30% ">: 
	                   			<select class="select_join" style="width: 150px" id="bizUnit"></select>
	                   		</td>
	                   	</tr>
	                   	<tr>
		                   	<td style="font-size:13px; background-color:#E7E3EF" colspan="4" align="right">
			                   	<input type="button" class="k-button" onclick="toSubmit()" id="submitUpdate" value="Add/Update User Role"/>
			                   	<input type="button" class="k-button" onclick="toDeleteRole()" id="deleteRole" value="Delete User Role"/>
		                   	</td>
	                   	</tr>
	            </table>
	        </div>
		</body>
	</html>	