
<html lang="en">

<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 

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
<link href="/ermsweb/resources/css/layout.css" rel="stylesheet"
	type="text/css">
<script src="/ermsweb/resources/js/jquery.min.js"></script>
<script src="/ermsweb/resources/js/kendo.all.min.js"></script>
<script src="/ermsweb/resources/js/common_tools.js"></script>

<script>
        
	 	$("#options").kendoDropDownList();

        $(document).ready(function () {

        		var dataSource = new kendo.data.DataSource({
		    		transport: {
		    			read: {
		    	   		  	type: "GET",
		    			    url: window.sessionStorage.getItem('serverPath')+"team/getTeamMap?userId="+window.sessionStorage.getItem("username"),
		    			    mimeType: "application/json",
		    			    xhrFields: {
					    		withCredentials: true
					    	},
		    			    dataType: "json",
		    			    complete: function(response, status){
		    			    	if(status == "success"){

						     		$.each(JSON.parse(response.responseText), function(key, value) {
						     		  	var option = document.createElement("option");
							     		option.text = checkUndefinedElement(key);
							     		option.value = checkUndefinedElement(key);
							     		document.getElementById("functionDropDown").appendChild(option);
							     		document.getElementById("functionDropDown").selectedIndex = 0 ;
							     		
							     		option = null;
						     		});

						     		var i = 0

						     		/*$.each(JSON.parse(response.responseText), function(key, value) {
						     			if(key == document.getElementById('functionDropDown').options[document.getElementById('functionDropDown').selectedIndex].text){
						     				for (var i = 0; i < value.length; i++) {
						     					option = document.createElement("option");
									     		option.text = checkUndefinedElement(value[i].paramValue);
									     		option.value = checkUndefinedElement(value[i].paramId);
									     		document.getElementById("valueList").appendChild(option);
									     		document.getElementById("valueList").selectedIndex = 1;
									     		option = null;
						     				};
						     				i++;
						     			}
						     			i++;
						     		});*/
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

        		$("#options").kendoDropDownList();
        		/*saveButtonEvent();*/
	        	
	        	$("#saveBtn").kendoButton({
	        		click: function(e) {
						/*saveButtonEvent();*/
		            }
		       	});
	
		       	$("#resetBtn").kendoButton({
		       		click: function(e) {
		       			/* Reset Button Event */
		       		}
		       	});
		 
		       	$("#exportBtn").kendoButton();
		       	
		       	getAvailableList();
        	}
        );

		function displayFilterResults() {
		  // Gets the data source from the grid.
		  	var dataSource = $("#MyGrid").data("kendoGrid").dataSource;
		  
		  	 	// Gets the filter from the dataSource
		     	var filters = dataSource.filter();
		     	
		     	// Gets the full set of data from the data source
		     	var allData = dataSource.data();
		     	
		     	// Applies the filter to the data
		     	var query = new kendo.data.Query(allData);
		     	var filteredData = query.filter(filters).data;
		     	
		     	// Output the results
		     	$('#FilterCount').html(filteredData.length);
		     	$('#TotalCount').html(allData.length);
		     	$('#FilterResults').html('');
		    	
		    	$.each(filteredData, function(index, item){
		    	  $('#FilterResults').append('<li>'+item.Site+' : '+item.Visitors+'</li>')
		    	});		
		}

		// View - V, Update - E, Discard - D, Verify - A, Returned - R //
		/* Get action type from database and to be replaced image icon */
		function replacedByIconOfDetails(groupId, action_types, userId){
			
			var returnImgHTML = "";
							
			if(new RegExp("V").test(action_types)){ 
				if(new RegExp("E").test(action_types) ){
					returnImgHTML += " <a target=\"main_frame\" href=\"groupMaintenanceDetail?action=view|update&rmdGroupId="+groupId+"&userId="+userId+"\"><img src=\"images/bg_view.png\" width=\"20\" height=\"20\"/></a> ";
					returnImgHTML += " <a target=\"main_frame\" href=\"groupMaintenanceDetail?action=update&rmdGroupId="+groupId+"&userId="+userId+"\"><img src=\"images/bg_update.png\" width=\"20\" height=\"20\"/></a> ";
				}else{
					returnImgHTML += " <a target=\"main_frame\" href=\"groupMaintenanceDetail?action=view&rmdGroupId="+groupId+"&userId="+userId+"\"><img src=\"images/bg_view.png\" width=\"20\" height=\"20\"/></a> ";
				}
			}
			return returnImgHTML;
		}
		function replacedByIconOfCR(crId, action_types, userId){
			
			var returnImgHTML = "";
			
			if(new RegExp("V").test(action_types)){ 
				if(new RegExp("E").test(action_types)){
					returnImgHTML += " <a target=\"main_frame\" href=\"groupMaintenanceChangeRequest?action=view|update&crId="+crId+"&userId="+userId+"\"><img src=\"images/bg_view.png\" width=\"20\" height=\"20\"/></a> ";
					returnImgHTML += " <a target=\"main_frame\" href=\"groupMaintenanceChangeRequest?action=update&crId="+crId+"&userId="+userId+"\"><img src=\"images/bg_update.png\" width=\"20\" height=\"20\"/></a> ";
				}else{
					returnImgHTML += " <a target=\"main_frame\" href=\"groupMaintenanceChangeRequest?action=view&crId="+crId+"&userId="+userId+"\"><img src=\"images/bg_view.png\" width=\"20\" height=\"20\"/></a> ";			
				}
			}
			
			if(new RegExp("A").test(action_types)){ 
				returnImgHTML += " <a target=\"main_frame\" href=\"groupMaintenanceChangeRequest?action=verify&crId="+crId+"&userId="+userId+"\"><img src=\"images/bg_update.png\" width=\"20\" height=\"20\"/></a> ";
			}	
			return returnImgHTML;
		}
		
		/* Handle underfined / null element */
		function checkUndefinedElement(element){
			if(element === null || element === "undefined"){
				return "";
			}else{
				return element;
			}
		}
		
		function getCookie(key) {  
		   var keyValue = document.cookie.match('(^|;) ?' + key + '=([^;]*)(;|$)');  
		   return keyValue ? keyValue[2] : null;  
		} 

		function getUserId(){
			return window.sessionStorage.getItem("username");
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
		function toDateFormat(dateObj){
			var jsonDate = "/Date("+dateObj+")/";
		    var date = new Date(parseInt(jsonDate.substr(6)));

	        return date.toString() != "Invalid Date" ? date.getDate().toString()+"/"+(date.getMonth()+1).toString()+"/"+date.getFullYear().toString() : "" ;
		}
		
		function saveButtonEvent(){   
			/* Save button Event */
		}
	
		function AllLeftToRight(){
			/* Click Event of All Data of left to right */
			var leftList = document.getElementById('selectList1');
			var rightList = document.getElementById('selectList2');

			for (var i = 0; i < leftList.length; i++) {
				rightList.options.add(new Option(leftList.options[i].innerHTML,leftList.options[i].value));
			};
			while(leftList.length > 0){
				leftList.remove(0);
			}
		}

		function AllRightToLeft(){
			/* Click Event of All Data of right to left */
			var leftList = document.getElementById('selectList1');
			var rightList = document.getElementById('selectList2');

			for (var i = 0; i < rightList.length; i++) {
				leftList.options.add(new Option(rightList.options[i].innerHTML,rightList.options[i].value));
			};
			while(rightList.length > 0){
				rightList.remove(0);
			}
		}

		function toRight(){
			/* Click Event of left to right */
			var leftList = document.getElementById('selectList1');
			var rightList = document.getElementById('selectList2');

			console.log("To right list " + leftList.options[leftList.selectedIndex].value);

			for (var i = 0; i < leftList.length; i++) {
				if(leftList[i].selected == true){
					console.log(leftList[i].innerHTML + " : " + i);
					rightList.options.add(new Option(leftList[i].innerHTML, leftList[i].value));
					leftList.remove(i);
					i--;

				}
			};
		}

		function toLeft(){
			/* Click Event of right to left */	

			var leftList = document.getElementById('selectList1');
			var rightList = document.getElementById('selectList2');

			console.log("To Left list " + rightList.options[rightList.selectedIndex].value);

			for (var i = 0; i < rightList.length; i++) {
				if(rightList[i].selected == true){
					console.log(rightList[i].innerHTML + " : " + i);
					leftList.options.add(new Option(rightList[i].innerHTML, rightList[i].value));
					rightList.remove(i);
					i--;

				}
			};
		}

		function selectedElements(){

			var leftList = document.getElementById('selectList1');

			for (var i = 0; i < leftList.length; i++) {
				if(leftList[i].selected == true){
					console.log(leftList[i].value + " : " + i);
				}
			};
		}

		function teamOnChangeEvent(){
			/* Change Team Number */
		}

		function functionOnChangeList(teamCode){

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

	    			    		clearDropDown("buzUnitDropDown");

					     		$.each(JSON.parse(response.responseText), function(key, value) {

					     			if(key == teamCode.options[teamCode.selectedIndex].text){

					     				var arrayFromValue = value;

					     				for (var i = 0; i < arrayFromValue.length; i++) {
	     					     		  	var option = document.createElement("option");
	     						     		option.text = arrayFromValue[i];
	     						     		option.value = arrayFromValue[i];
	     						     		document.getElementById("buzUnitDropDown").appendChild(option);
	     						     		document.getElementById("buzUnitDropDown").selectedIndex = 0 ;
	     						     		option = null;	
					     				};	

					     			}			

					     		});
					     		getAssignedList(teamCode.value, document.getElementById('buzUnitDropDown').options[document.getElementById('buzUnitDropDown').selectedIndex].value);		
					     		clearDropDownWithoutBlank("selectList1");
					     		getAvailableList();
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

		function buzUnitOnchangeList(buzUnit){
			clearDropDownWithoutBlank("selectList1");
			getAssignedList(document.getElementById('functionDropDown').options[document.getElementById('functionDropDown').selectedIndex].value, buzUnit.value);
			getAvailableList();
		}

		function getAvailableList(){

			var dataSource = new kendo.data.DataSource({
			
				transport: {
					read: {
						
						url: window.sessionStorage.getItem('serverPath')+"team/getTeamFuncAvList",
						dataType: "json",
						xhrFields: {
				    		withCredentials: true
				    	},
				    	type: "GET",
				    	complete: function (response, status){
				    		
	    			    	if(status == "success"){
	    			    		clearDropDownWithoutBlank("selectList1");
	    			    		var tmpArray = displayResult("selectList2").split(",");
	    			    		
					     		$.each(JSON.parse(response.responseText), function(key, value) {		

						     		if(tmpArray.includes(value.id.funcId)){
						     			console.log(value.id.funcId + " Contained on a array");
						     		}else{
		     			     		  	var option = document.createElement("option");

		     				     		option.text = value.funcDesc;
		     				     		option.value = value.id.funcId;

		     				     		document.getElementById("selectList1").appendChild(option);
		     				     		document.getElementById("selectList1").selectedIndex = 0 ;
		     				     		option = null;						
						     		}
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

		function getAssignedList(teamCode, BizCode){
		
			var dataSource = new kendo.data.DataSource({
			
				transport: {
					read: {
						url: window.sessionStorage.getItem('serverPath')+"team/getTeamFunc?userId="+window.sessionStorage.getItem("username")+"&teamCode="+teamCode+"&bizUnit="+BizCode,
						dataType: "json",
						xhrFields: {
				    		withCredentials: true
				    	},
				    	type: "GET",
				    	complete: function (response, status){

	    			    	if(status == "success"){

	    			    		clearDropDownWithoutBlank("selectList2");
								$.each(JSON.parse(response.responseText), function(key, value) {
					     		  	var option = document.createElement("option");
						     		option.text = value.funcDesc;
						     		option.value = value.funcId;

						     		document.getElementById("selectList2").appendChild(option);
						     		document.getElementById("selectList2").selectedIndex = 0 ;
						     		option = null;
					     		});	    		
					     		clearDropDownWithoutBlank("selectList1");
					     		getAvailableList();
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

		function toSave(){

			var url = window.sessionStorage.getItem('serverPath')+"team/saveTeamFunc";

			var item = document.getElementById("selectList2");

			var jsonArr = new Array(item.options.length);

			var jsonStringFormat = "[";

			/*alert(document.getElementById('functionDropDown').options[document.getElementById('functionDropDown').selectedIndex].value);*/

			$('#selectList2 option').each(function() {

			    var tmp = "{\"funcDesc\" : \"" 
			    + $(this).html() + "\",\"funcId\" : \""
			    + $(this).val() + "\",\"teamCode\" : \""
			    + document.getElementById("functionDropDown").options[document.getElementById("functionDropDown").selectedIndex].value + "\",\"bizUnit\" : \""
			    + document.getElementById("buzUnitDropDown").options[document.getElementById("buzUnitDropDown").selectedIndex].value + "\",\"userId\" : \""
			    + window.sessionStorage.getItem("username") 
			    + "\"}";

				jsonStringFormat += tmp + ",";
			});

			if(jsonStringFormat.length -1 == 0){
				var tmp = "{\"funcDesc\" : \"" 
			    + "" + "\",\"funcId\" : \""
			    + "" + "\",\"teamCode\" : \""
			    + document.getElementById("functionDropDown").options[document.getElementById("functionDropDown").selectedIndex].value + "\",\"bizUnit\" : \""
			    + document.getElementById("buzUnitDropDown").options[document.getElementById("buzUnitDropDown").selectedIndex].value + "\",\"userId\" : \""
			    + window.sessionStorage.getItem("username") 
			    + "\"}";
			    jsonStringFormat += tmp + ",";
			}

			jsonStringFormat = jsonStringFormat.substring(0, jsonStringFormat.length -1);
			jsonStringFormat += "]";
			

			var dataSource = new kendo.data.DataSource({
				transport: {
				    read: function(options) {
	                    $.ajax({
	                        type: "POST",
	                        url: url,
	                        data: jsonStringFormat,
	                        contentType: "application/json; charset=utf-8",
	                        dataType: "json",
	                        success: function (result) {
	                            options.success(result);
	                        },
	                        complete: function (jqXHR, textStatus){
								if(textStatus == "success"){
									document.getElementById("returnMessage").style.color = "green";
									document.getElementById("returnMessage").innerHTML = "Update successfully"
								}
							},
							error: function(e){
								document.getElementById("returnMessage").style.color = "red";
								document.getElementById("returnMessage").innerHTML = "Update Failed : At least 1 row on assigned list.";
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
		}

	    </script>

<body class="bodyContainer">
	<%@include file="header1.jsp"%>
	<div class="page-title">Function Entitlement</div>
	<!-- <input type="hidden" id="pagetitle" name="pagetitle"
		value="Function Entitlement"> -->
	<table width="100%" height="auto" border="0" cellpadding="4"
		cellspacing="1" style="border-color: black; border-style: solid;">
		<tr>
			<td colspan="3" align="center"
				style="background-color: #9C3E3E; color: white">Team : <select
				id="functionDropDown" onchange="functionOnChangeList(this)"
				style="width: 20%" class="select_join">
					<option>-</option>
			</select> <select id="buzUnitDropDown" onchange="buzUnitOnchangeList(this)"
				style="width: 20%" class="select_join">
					<option>-</option>
			</select>
			</td>
		</tr>
		<tr>
			<td colspan="3">
				<div id="returnMessage"></div>
			</td>
		</tr>
		<tr>
			<td style="height: 700px; width: 40%; vertical-align: top;">
				<div style="background-color: #9C3E3E; color: white">
					<b>Available Functions</b>
				</div> <select id="selectList1" onchange="selectedElements()"
				style="height: 700px; width: 100%; vertical-align: top" multiple>
			</select>
			</td>
			<td style="height: 700px; width: 20%;" align="center"><input
				type="button" class="k-button" style="width: 60%" value=">>"
				onclick="AllLeftToRight()"></input><br>
			<br> <input type="button" class="k-button" style="width: 60%"
				value=">" onclick="toRight()"></input><br>
			<br> <input type="button" class="k-button" style="width: 60%"
				value="<" onclick="toLeft()"></input><br>
			<br> <input type="button" class="k-button" style="width: 60%"
				value="<<" onclick="AllRightToLeft()"></input><br>
			<br>
			<br>
			<br>
			<br>
			<br>
			<br>
			<br>
			<br>
			<br> <input type="button" onclick="toSave()" class="k-button"
				style="width: 30%" value="Save"></input> <input type="button"
				class="k-button" style="width: 30%" value="Clear"></input><br>
			</td>
			<td style="height: 700px; width: 40%;">
				<div style="background-color: #9C3E3E; color: white">
					<b>Assigned Functions</b>
				</div> <select id="selectList2"
				style="height: 700px; width: 100%; vertical-align: top" multiple>
			</select>
			</td>
		</tr>
	</table>
</body>
</html>
