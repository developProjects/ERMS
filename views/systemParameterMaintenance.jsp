	<!DOCTYPE html>
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
		<script>
	        
		 	$("#options").kendoDropDownList();

	        $(document).ready(function () {
	        		
	        		getFunctionList();
	        		getBizUnit();
	        		onChangeParameters();
	        		getApprMemberList();
	        		initializeBuCode();

        	        $("#effFmDt").kendoDatePicker({
         				format: "dd/MM/yyyy"
         			});
         			$("#effFmDt").attr("readonly", "readonly");
         			
         			$("#effToDt").kendoDatePicker({
         				format: "dd/MM/yyyy"
         			});
         			$("#effToDt").attr("readonly", "readonly");

         			var dataSource = new kendo.data.DataSource({
	                    transport: {
	                        read: {
	                            type: "GET",
	                            async: false,
	                            url: window.sessionStorage.getItem('serverPath')+"systemParam/getApprMemeberList?userId="+window.sessionStorage.getItem("username"), cache: false,
	                            dataType: "json",
	                            xhrFields: {
	                                withCredentials: true
	                            },
	                            
	                            complete: function(response, status){
	                                if(status == "success"){
	                                	
	                                	var option = document.createElement("option");
	                                	option.text = checkUndefinedElement("-");
	                                	option.value = checkUndefinedElement("");
	                                	document.getElementById("memberList").appendChild(option);
	                                	option = null;

	                                	$.each(JSON.parse(response.responseText), function(key, value) {

	                                		option = document.createElement("option");
	                                		option.text = checkUndefinedElement(value.pararmName);
	                                		option.value = checkUndefinedElement(value.paramOrderId);
	                                		document.getElementById("memberList").appendChild(option);
	                                		document.getElementById("memberList").selectedIndex = 0;
	                                		option = null;

	                                	});
	                                }   
	                            }
	                        }
	                    }, 
	                    error:function(e){
									if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
								},	 
	                    schema: { 
	                        model:{
	                            id: "guarId",
	                            fields:{
	                                guarId: {type: "string"},
	                                guarName : {type: "string"},
	                                guarDomicile : {type: "string"}
	                            }
	                        }
	                    },
	                    pageSize: 10
	                }); 
					dataSource.read();

	        	}
	        );

			function initializeBuCode(){

				var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: window.sessionStorage.getItem('serverPath')+"systemParam/getBizUnitList?userId="+window.sessionStorage.getItem("username"), cache: false,
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            },
                            complete: function(response, status){

                                if(status == "success"){
                                	clearDropDownWithoutBlank("memBizUnit");
                                	$.each(JSON.parse(response.responseText), function(key, value) {
                                		if(value.bizUnit != null){
                                			var option = document.createElement("option");
                                			option.text = checkUndefinedElement(value.bizUnit);
                                			option.value = checkUndefinedElement(value.bizUnit);
                                			document.getElementById("memBizUnit").appendChild(option);
                                			document.getElementById("memBizUnit").selectedIndex = 0;
                                			option = null;
                                		}else{
                                			var option = document.createElement("option");
                                			option.text = checkUndefinedElement("-");
                                			option.value = checkUndefinedElement("-");
                                			document.getElementById("memBizUnit").appendChild(option);
                                			document.getElementById("memBizUnit").selectedIndex = 0;
                                			option = null;
                                		}

                                	});

                                }   
                            }
                        }
                    }
                }); 

				dataSource.read();

			}

			function onChangeMemberDropDown(){
				var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: window.sessionStorage.getItem('serverPath')+"systemParam/getApprMemeberList?userId="+window.sessionStorage.getItem("username"), cache: false,
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            },
                            complete: function(response, status){

                                if(status == "success"){
                                	clearDropDownWithoutBlank("memBizUnit");
                                	initializeBuCode();
                                	autoSelectedByValue("memBizUnit", "-");
                                	console.log($("#memberList").val());
                                	console.log($("#memberList option:selected").html());

                                	$.each(JSON.parse(response.responseText), function(key, value) {

                                		if($("#memberList").val() == value.paramOrderId && $("#memberList option:selected").html() == value.pararmName){

                                			$("#effFmDt").val(toDateFormat(value.effFmDt));
                                			$("#effToDt").val(toDateFormat(value.effToDt));
                                			$("#paramDesc").val(value.paramDesc);
                                			$("#memName").val(value.memName);

                                			var option = document.createElement("option");
                                			option.text = checkUndefinedElement(value.memBizUnit);
                                			option.value = checkUndefinedElement(value.memBizUnit);
                                			document.getElementById("memBizUnit").appendChild(option);
                                			option = null;

                                			autoSelectedByValue("memBizUnit", value.memBizUnit);

                                			$("#emailAddr").val(value.emailAddr);
                                			$("#messageApprMember").css({"display":"none"});
                                			$("#otherBu").val("");
                                		}
                                	});
                                }   
                            }
                        }
                    },  
                    schema: { 
                        model:{
                            id: "guarId",
                            fields:{
                                guarId: {type: "string"},
                                guarName : {type: "string"},
                                guarDomicile : {type: "string"}
                            }
                        }
                    },
                    pageSize: 10
                }); 

				dataSource.read();
			}

	        function toSubmitApprMember(){

	        	var updateApprMember = window.sessionStorage.getItem('serverPath')+"systemParam/updateApprMember?userId="+window.sessionStorage.getItem("username");

	        	/*if($("#memberList").val() == value.paramOrderId && $("#memberList option:selected").html() == value.pararmName){

	        		$("#effFmDt").val(toDateFormat(value.effFmDt));
	        		$("#effToDt").val(toDateFormat(value.effToDt));
	        		$("#paramDesc").val(value.paramDesc);
	        		$("#memName").val(value.memName);
	        		$("#memBizUnit").val(value.memBizUnit);
	        		$("#emailAddr").val(value.emailAddr);

	        	}*/

	        	var buType = "";

	        	if($("#otherBu").val() != "" && $("#otherBu").val() != undefined){
	        		buType = $("#otherBu").val();
	        	}else{
	        		buType = $("#memBizUnit :selected").val();
	        	}

	        	var jsonArr = {

	        		userId: window.sessionStorage.getItem("username"),
	        		pararmName: $("#memberList option:selected").html(),
	        		paramOrderId: $("#memberList").val(),
	        		paramDesc: $("#paramDesc").val(),
	        		memName: $("#memName").val(),
	        		memBizUnit: buType,
	        		emailAddr: $("#emailAddr").val(),
	        		lastUpdateBy: window.sessionStorage.getItem("username"),
	        		lastUpdateDt: new Date(),
	        		effFmDt: strToDate($("#effFmDt").val()),
	        		effToDt: strToDate($("#effToDt").val())
	        	};

	        	var dataSource = new kendo.data.DataSource({
	        	    transport: {
	        	        read: function(options) {
		                    $.ajax({
		                        type: "POST",
		                        url: updateApprMember,
		                        data: JSON.stringify(jsonArr),
		                        contentType: "application/json; charset=utf-8",
		                        dataType: "json",
		                        xhrFields: {
						    		withCredentials: true
						    	},
						    	complete: function(jqXHR, status){
						    		if(status == "success"){
						    			var obj = JSON.parse(jqXHR.responseText);
						    			console.log(obj.message.toUpperCase());
						    			if(obj.message == "success"){
						    				$("#messageApprMember").css({"display":"block"});
						    				document.getElementById("messageApprMember").style.color = "green"
						    				document.getElementById("messageApprMember").innerHTML = "Update" + " successfully."	
						    			}
						    		}
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

	        function getApprMemberList(){

	        	var getCurrencyJson = window.sessionStorage.getItem('serverPath')+"systemParam/getApprMemeberList?userId="+window.sessionStorage.getItem("username");

	        	var dataSource = new kendo.data.DataSource({
	        	    transport: {
	        	        read: {
	        	            type: "GET",
	        	            async: false,
	        	            url: getCurrencyJson,   
	        	            cache: false,                       
	        	            dataType: "json",
	        	            xhrFields: {
	        	                withCredentials: true
	        	            },
	        	            complete: function(response, status){
	        	                if(status == "success"){

	        	                }
	        	            }
	        	        }
	        	    },  
	        	    schema: { 
	        	        model:{
	        	            id: "crId",
	        	            fields:{
	        	                ccdId: {type: "string"},
	        	                groupId : {type: "string"},
	        	                bizUnit : {type: "string"}
	        	            }
	        	        }
	        	    },
	        	    pageSize: 10
	        	});    
	        	dataSource.read();
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
		

			function teamOnChangeEvent(){
				/* Change Team Number */
			}

	    </script>
	
		<body onload="checkSessionAlive()" class="bodyContainer">
		<script type="text/javascript">
		/* Get Function Drop Down List*/
		function groupByKeyValue(list){

			Array.prototype.getUnique = function () {
	            var unique = this.filter(function (elem, pos) {
	                return this.indexOf(elem) == pos;
	            }.bind(this));
	            this.length = 0;
	            this.splice(0, 0, unique);
	        }

	        var duplicates = [];

	        $("#"+list+" option").each(function(){
			    duplicates.push($(this).html());
			});

	        duplicates.getUnique();
	        var afterEffect = duplicates.toString().split(",");

	        clearDropDown(list);

	        for (var i = 0; i < afterEffect.length; i++) {
	        	if(afterEffect[i] != " - "){
		        	var option = document.createElement("option");
		     		option.text = checkUndefinedElement(afterEffect[i]);
		     		option.value = checkUndefinedElement(afterEffect[i]);
		     		document.getElementById(list).appendChild(option);
		     		option = null;
	        	}
	        };

	        document.getElementById(list).selectedIndex = 1;

			/*var mySet = new Set();

			$("#"+list+" option").each(function(){
			    mySet.add($(this).html());
			});

			clearDropDown(list);	
			mySet.forEach(function(item, sameItem, s) {
				if(item != " - "){
					var option = document.createElement("option");
		     		option.text = checkUndefinedElement(item);
		     		option.value = checkUndefinedElement(item);
		     		document.getElementById(list).appendChild(option);
		     		document.getElementById(list).selectedIndex = 1;
		     		option = null;
		     	}
			});*/
		}

		function getFunctionList(){
			var dataSource = new kendo.data.DataSource({
	    		transport: {
	    			read: {
	    	   		  	type: "GET",
	    			    url: window.sessionStorage.getItem('serverPath')+"systemParam/getFunctionList?userId="+window.sessionStorage.getItem("username"),
	    			    dataType: "json",
	    			    xhrFields: {
				    		withCredentials: true
				    	},
				    	complete: function (response, status){
				    		if(status == "success"){
				    			
					     		$.each(JSON.parse(response.responseText), function(key, value) {
					     		  	var option = document.createElement("option");
						     		option.text = checkUndefinedElement(value.functCat);
						     		option.value = checkUndefinedElement(value.functCat);
						     		document.getElementById("functionDropDown").appendChild(option);
						     		document.getElementById("functionDropDown").selectedIndex = document.getElementById("functionDropDown").options.length - document.getElementById("functionDropDown").options.length ;
						     		option = null;
					     		});
				    		}
				    	}
	    			}
	    		},
	    		schema: { 
		            model:{
		            	id: "rmdGroupId",
		            	fields:{
		            		functCat: {type: "string"}    
		            	}
		            }
		        }
	    	});   
			
		    dataSource.read(); 
		}
		function getBizUnit(){
			var dataSource = new kendo.data.DataSource({
	    		transport: {
	    			read: {
	    	   		  	type: "GET",
	    			    url: window.sessionStorage.getItem('serverPath')+"systemParam/getBizUnitList?userId="+window.sessionStorage.getItem("username"),
	    			    dataType: "json",
	    			    xhrFields: {
				    		withCredentials: true
				    	},
				    	complete: function (response, status){
				    		if(status == "success"){
				    			
					     		$.each(JSON.parse(response.responseText), function(key, value) {
					     		  	var option = document.createElement("option");
						     		option.text = checkUndefinedElement(value.bizUnit);
						     		option.value = checkUndefinedElement(value.bizUnit);
						     		document.getElementById("bizUnitDropDown").appendChild(option);
						     		document.getElementById("bizUnitDropDown").selectedIndex = document.getElementById("bizUnitDropDown").options.length - document.getElementById("bizUnitDropDown").options.length;
						     		option = null;
					     		});
				    		}
				    	}
	    			}
	    		},
	    		schema: { 
		            model:{
		            	id: "bizUnit",
		            	fields:{
		            		bizUnit: {type: "string"}    
		            	}
		            }
		        }
	    	});   
			
		    dataSource.read(); 
		}

		function clearDropDown(params){

			try{
				var item = document.getElementById(params);
				for(var i = item.options.length - 1; i >= 0; i--){
			      	item.remove(i);
			   	}
     			var option = document.createElement("option");
	     		option.text = checkUndefinedElement(" - ");
	     		option.value = checkUndefinedElement(null);

	     		document.getElementById(params).appendChild(option);
	     		document.getElementById(params).selectedIndex = 0;

	     		option = null;

			}catch(err){
				console.log(err);
			}
		}
		function changeParamValue(myRadio){
			/* Onchange event of changing between the radio buttons : multi_value_screen and or param_value_screen */
			document.getElementById("returnMessage").innerHTML = "";
			document.getElementById("returnMessage").style.color = "green";
			if(myRadio.value == "N"){
				
				document.getElementById("param_value_screen").style.display = "block";
				document.getElementById("multi_value_screen").style.display = "none";
				onChangeParameters();
			}else{

				document.getElementById("param_value_screen").style.display = "none";
				document.getElementById("multi_value_screen").style.display = "block";
				onChangeParameters();
			}
		}
		function onChangeParameters(){
			
			var url = "";
	   		var isMultiValInd = true;
	   		var params = "";
	   		var radionOption = $('input[name="para_values"]:checked').val();

	   		if(radionOption == 'N'){
	   			params = "genericParam";
	   		}else{
	   			params = "dropBoxParam";
	   		}

			url = window.sessionStorage.getItem('serverPath')+"systemParam/getSysParams?userId="+window.sessionStorage.getItem("username")+"&funcCat="+document.getElementById('functionDropDown').value+"&bizUnit="+document.getElementById('bizUnitDropDown').value+"&multiValInd="+radionOption;
			

			var dataSource = new kendo.data.DataSource({
	    		transport: {
	    			read: {
	    	   		  	type: "GET",
	    			    url: url,
	    			    dataType: "json",
	    			    xhrFields: {
				    		withCredentials: true
				    	},
				    	complete: function (response, status){
				    		if(status == "success"){

				    			clearDropDown(params);
				    			clearDropDown("valueList");

					     		$.each(JSON.parse(response.responseText), function(key, value) {
					     			var option = document.createElement("option");
						     		option.text = checkUndefinedElement(value[0].paramName);
						     		option.value = checkUndefinedElement(value[0].paramId);
						     		document.getElementById(params).appendChild(option);
						     		document.getElementById(params).selectedIndex = 0;
						     		option = null;
					     		});
					     		/*groupByKeyValue("dropBoxParam");*/
				    		}
				    	}
	    			}
	    		},
	    		schema: { 
		            model:{
		            	id: "paramName",
		            	fields:{
		            		paramName: {type: "string"}    
		            	}
		            }
		        }
	    	});   
			
		    dataSource.read(); 
		}
		
		function onChangeDropboxList(valueOfList){

	   		var params = "dropBoxParam";

			var url = window.sessionStorage.getItem('serverPath')+"systemParam/getSysParams?userId="+window.sessionStorage.getItem("username")+"&funcCat="+document.getElementById('functionDropDown').value+"&bizUnit="+document.getElementById('bizUnitDropDown').value+"&multiValInd=Y";
			

			var dataSource = new kendo.data.DataSource({
	    		transport: {
	    			read: {
	    	   		  	type: "GET",
	    			    url: url,
	    			    dataType: "json",
	    			    xhrFields: {
				    		withCredentials: true
				    	},	
				    	complete: function (response, status){
				    		if(status == "success"){

				    			clearDropDown("valueList");
				    			var i = 0

					     		$.each(JSON.parse(response.responseText), function(key, value) {
					     			if(key == valueOfList.options[valueOfList.selectedIndex].text){
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
					     		});
				    		}
				    	}
	    			}
	    		},
	    		schema: { 
		            model:{
		            	id: "paramName",
		            	fields:{
		            		paramName: {type: "string"}    
		            	}
		            }
		        }
	    	});   
			
		    dataSource.read(); 
		}
		
		function toClear(action){
			if(action == "Y"){
				document.getElementById("dropBoxParam").selectedIndex = 0;
				document.getElementById("")
				document.getElementById("descriptionArea").value = "";
				document.getElementById("valueField").value = "";
				onChangeParameters();
			}else{
				document.getElementById("genericParam").selectedIndex = 0;
				document.getElementById("value").value = "";
				document.getElementById('description').value = "";
				document.getElementById('severity').selectedIndex = 0;
				onChangeParameters();	
			}
			document.getElementById("returnMessage").innerHTML = "";
		}

		function refreshTheSeverity(severity){

 			for (var i = 3 ; i >= 0 ; i--) {
 				var option = document.createElement("option");
 				option.text = i;
     			option.value = i;	
     			document.getElementById("severity").appendChild(option);
     			option = null;
 			};
 			
 			for (var i = 0 ; i < document.getElementById("severity").options.length ; i++) {
 				if(document.getElementById('severity').options[i].value == severity){
 					document.getElementById("severity").selectedIndex = i ;
 				} 	
 			};
		}

		function onChangeGenericParameter(genParam){

			var url = "";
	   		var isMultiValInd = true;
	   		var params = "";
	   		var radionOption = $('input[name="para_values"]:checked').val();

	   		if(radionOption == 'N'){
	   			params = "genericParam";
	   		}else{
	   			params = "dropBoxParam";
	   		}

			url = window.sessionStorage.getItem('serverPath')+"systemParam/getSysParams?userId="+window.sessionStorage.getItem("username")+"&funcCat="+document.getElementById('functionDropDown').value+"&bizUnit="+document.getElementById('bizUnitDropDown').value+"&multiValInd="+radionOption;
			

			var dataSource = new kendo.data.DataSource({
	    		transport: {
	    			read: {
	    	   		  	type: "GET",
	    			    url: url,
	    			    dataType: "json",
	    			    xhrFields: {
				    		withCredentials: true
				    	},
				    	complete: function (response, status){
				    		if(status == "success"){
				    			if(genParam.value == null || genParam.value == ""){
				    				document.getElementById('value').value = ""; 
				    				document.getElementById('description').value = ""; 
				    				/*document.getElementById('severity').value = "1"; */

				    				clearDropDown("severity");

				    			}else{
				    				$.each(JSON.parse(response.responseText), function(key, value) {
						     			/*
							     			alert("key : " + key);
							     			alert("value : " + value[0].paramId);
							     			alert("genParam : " + key);
						     			*/
						     			if(value[0].paramId == genParam.options[genParam.selectedIndex].value){

						     				clearDropDown("severity");

						     				document.getElementById('value').value = value[0].paramValue;
						     				document.getElementById('description').value = value[0].paramDesc;
		     				     			
		     					     		refreshTheSeverity(value[0].severity);
						     			}
						     		});
				    			}
				    		}
				    	}
	    			}
	    		},
	    		schema: { 
		            model:{
		            	id: "paramName",
		            	fields:{
		            		paramName: {type: "string"}    
		            	}
		            }
		        }
	    	});   
			
		    dataSource.read(); 
		}

		function toSubmit(parmsType, action){
			var url = "";
			var jsonArr = "";
			var msgFlag = "";
			if(parmsType == "N"){
				if(document.getElementById("genericParam").value == "" || document.getElementById("genericParam").value == null || document.getElementById("genericParam").value.length <= 0 ){
					document.getElementById('returnMessage').style.color = "red";
					document.getElementById('returnMessage').innerHTML = "Generic Parameter can not be null";
				}else{
					if(document.getElementById("value").value == "" || document.getElementById("value").value == null || document.getElementById("value").value.length <= 0 ){
						document.getElementById('returnMessage').style.color = "red";
						document.getElementById('returnMessage').innerHTML = "Value can not be null";
					}else{
						url = window.sessionStorage.getItem('serverPath')+"systemParam/update";
						jsonArr = { 
							newParamValue: document.getElementById('value').value,
							paramType: "STRING",
							paramId: document.getElementById("genericParam").value,
							paramDesc: document.getElementById('description').value,
							multiValInd: $('input[name="para_values"]:checked').val(),
							severity: document.getElementById('severity').value, 
							userId: window.sessionStorage.getItem("username")
						};
						msgFlag = "Update";	
					}
					toClear("N");
				}				
			}else{
				if(action == "add"){
					if(document.getElementById('valueField').value == "" || document.getElementById('valueField').value == null || document.getElementById('valueField').value.length <= 0){
						document.getElementById('returnMessage').style.color = "red";
						document.getElementById('returnMessage').innerHTML = "Value Field Can not be null";
					}else{
						url = window.sessionStorage.getItem('serverPath')+"systemParam/add";
						var tmpParamId = $("#dropBoxParam option:selected").val();
						var newId = tmpParamId.substring(0, tmpParamId.length - 1);

						jsonArr = { 
							newParamValue: document.getElementById('valueField').value,
							paramDesc: document.getElementById('descriptionArea').value,
							multiValInd: $('input[name="para_values"]:checked').val(),
							userId: window.sessionStorage.getItem("username"),
							paramId: newId+"0"					
						};
						msgFlag = "add";
						toClear("Y");
					}
				}else{
					if(action == "update"){
						if(document.getElementById('valueField').value == "" || document.getElementById('valueField').value == null || document.getElementById('valueField').value.length == 0){
							document.getElementById('returnMessage').style.color = "red";
							document.getElementById('returnMessage').innerHTML = "Value Field Can not be null";
						}else{
							url = window.sessionStorage.getItem('serverPath')+"systemParam/update",
							jsonArr = { 
								paramId : document.getElementById('valueList').value,
								newParamValue: document.getElementById('valueField').value,
								paramDesc: document.getElementById('descriptionArea').value,
								multiValInd: $('input[name="para_values"]:checked').val(),
								userId: window.sessionStorage.getItem("username"),
							};
							msgFlag = "update";
							toClear("Y");
						}						
						
					}else{
						if(document.getElementById('valueList').value == "" || document.getElementById('valueList').value == null || document.getElementById('valueList').value.length == 0){
							document.getElementById('returnMessage').style.color = "red";
							document.getElementById('returnMessage').innerHTML = "Please select the value your want to delete";
						}else{
							url = window.sessionStorage.getItem('serverPath')+"systemParam/delete",
							jsonArr = { 
								paramId : document.getElementById('valueList').value,
								paramDesc: document.getElementById('descriptionArea').value,
								multiValInd: $('input[name="para_values"]:checked').val(),
								userId: window.sessionStorage.getItem("username"),
							};
							msgFlag = "delete";
							toClear("Y");
						}
					}
				}
			}

			var dataSource = new kendo.data.DataSource({
				transport: {
				    read: function(options) {
	                    $.ajax({
	                        type: "POST",
	                        url: url,
	                        data: JSON.stringify(jsonArr),
	                        contentType: "application/json; charset=utf-8",
	                        dataType: "json",
	                        success: function (result) {
	                            options.success(result);
	                        },
	                        complete: function (jqXHR, textStatus){
								if(textStatus == "success"){
									var obj = JSON.parse(jqXHR.responseText);
									console.log(obj.message.toUpperCase());
									if(obj.message == "success"){
										document.getElementById("returnMessage").style.color = "green"
										document.getElementById("returnMessage").innerHTML = msgFlag + " successfully."	
									}
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
			onChangeParameters();
		}

		</script>

		<div class="page-title">System Parameter Maintenance</div>

			<table width="100%" border="1" cellspacing="0" cellspacing="6" height="auto" style="border-color: black; border-style: solid;">
				<tr>
					<td align="center">
						<div class="result1Title"  align="center" width="100%" style="background-color:#9C3E3E;">
							<table border="0" width="80%" style="color: white">
								<tr>
									<td width="33.3%">
										Function : 
										<select onchange="onChangeParameters()" id="functionDropDown" style="width:50%" class="select_join">
											<option value=""> - </option>
										</select>
									</td>
									<td width="33.3%">
										Business Unit.
										<select onchange="onChangeParameters()" id="bizUnitDropDown"  style="width:50%" class="select_join">
											<option value=""> - </option>
										</select>
									</td>
									<td width="33.3%">
										<input type="radio" onchange="changeParamValue(this)" name="para_values" id="param_value_pair" class="k-radio" checked="checked" value="N">
										</input>
										<label class="k-radio-label" for="param_value_pair">Param-Value Pair</label>
										<input type="radio" onchange="changeParamValue(this)" name="para_values" id="multi_value_param" class="k-radio" value="Y">
										</input>
										<label class="k-radio-label" for="multi_value_param">Multi-Value Param</label>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="3"> <div id="returnMessage" style="display: inline; color: green;">
					</td>
				</tr>
				<tr>
					<td colspan="3" style="height: auto; width:75%; vertical-align:top" align="center">
						<div id="param_value_screen">
							<table width="100%" border="0" cellspacing="10" cellspacing="6">
								<tr>
									<td><br></td>
								</tr>
								<tr>
									<td align="left" width="10%">
									Generic Parameter:
									</td>
									<td width="15%">
										<select id="genericParam" style="width:100%" class="select_join" onchange="onChangeGenericParameter(this)">
											<option> - </option>
										</select>
									</td>
									<td>
										&nbsp;&nbsp;&nbsp;&nbsp;
										Value:
										<input type="text" id="value" class="k-textbox" style="width:90%; border: groove"></input>
									</td>
									<td align="left">
										Severity Level:
										<select id="severity"  style="width:40%" class="select_join">
											<option>1</option>
											<option>2</option>
											<option>3</option>
										</select>
									</td>
								</tr>
								<tr>
									<td align="left">
										Description:
									</td>
									<td colspan="2">
										<input id="description" type="text" class="k-textbox" style="width:100%; border: groove"></input>
									</td>
									<td align="right" style="padding-right: 50px">
									</td>
									</td>
								</tr>
								<tr>
								<td colspan="3"><br></td>
									<td align="right" style="padding-right: 50px">
										<input type="button" class="k-button" onclick="toSubmit('N', '')" value="Update"></input>
										<input type="button" class="k-button" value="Reset" onclick="toClear('N')"></input>
									</td>
								</tr>
							</table>
						</div>
						<div id="multi_value_screen" style="display: none" align="center">
							<table width="100%" border="0">
								<tr>
									<td colspan="3"></div></td>
								</tr>
								<tr>
									<td width="10%">
										Dropbox Parameter:
									</td>
									<td width="15%">
										<select id="dropBoxParam" name="dropBoxParam" onchange="onChangeDropboxList(this)" style="width:100%" class="select_join">
										</select>
									</td>
									<td >
										<!-- block col -->
										<br>
									</td>
									<td width="1px">
										<!-- block col -->
										value:
									</td>
									<td rowspan="2" style="vertical-align: top" align="left">
										<select id="valueList" style="height: 200px; vertical-align: top; width: 50% " multiple>
											<option> - </option>
										</select>
										<br>
										<input value="" id="valueField" type="text" class="k-textbox" style="width:50%"></input>
									</td>
								</tr>
								<tr>
									<td width="10%">
										Description:
									</td>
									<td width="15%">
										<textarea id="descriptionArea" rows="10" cols="40"></textarea>
									</td>
									<td>
										<!-- block col -->
									</td>
								</tr>
								<tr>
									<td><br></td>
									<td><br></td>
									<td><br></td>
									<td><br></td>
									<td align="right" style="padding-right: 50px">
										<input type="button" class="k-button" onclick="toSubmit('Y', 'add')" value="Add"></input>
										<input type="button" class="k-button" onclick="toSubmit('Y', 'update')" value="Update"></input>
										<input type="button" class="k-button" onclick="toSubmit('Y', 'delete')" value="Delete"></input>
										<input type="button" class="k-button" value="Clear" onclick="toClear('Y')"></input>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
				<tr>
					<td style="color: white; background-color:#9C3E3E;">Appr Member</td>
				</tr>
				<tr>
					<td colspan="3">
					<div id="messageApprMember" style="display: inline; color: green;"></div>
					</td>
				</tr>
				<tr>
					<td style="width: 99.5%" align="center">
						<br></br>
						<div id="apprMemberParams">
							<table width="99.5%" border="0">
								<tbody style="padding-left: 2em">
									<tr>
										<td>
											Member :
										</td>
										<td>
											<select id="memberList" onChange="onChangeMemberDropDown()" class="select_join" style="width:100%; border: groove;"></select>
										</td>
										<td>
											Effective From :
										</td>
										<td>
											<input type="text" style="border: groove" id="effFmDt"></input>
										</td>
										<td>
											Effective to :
										</td>
										<td>
											<input type="text" style="border: groove" id="effToDt"></input>
										</td>
									</tr>
									<tr>
										<td>Description :</td>
										<td colspan="3">
											<input type="text" class="k-textbox" id="paramDesc" style="width: 100%; border: groove"></input>
										</td>
									</tr>
									<tr>
										<td>
											Member Name :
										</td>
										<td>
											<input type="text" style="border: groove" class="k-textbox" id="memName"></input>
										</td>
										<td>
											BU Code of Member :
										</td>
										<td>
											<select style="border: groove" class="select_join" id="memBizUnit"></select>
										</td>
										<td>
											
										</td>
										<td></td>
									</tr>
									<tr>
										<td>
											Email :
										</td>
										<td>
											<input type="text" style="border: groove" class="k-textbox" id="emailAddr"></input>
										</td>
										<td>
											Please specify it other :
										</td>
										<td>
											<input type="text" id="otherBu" style="border: groove" class="k-textbox"></input>
										</td>
										<td>
											
										</td>
										<td>
											
										</td>
									</tr>
									<tr>
										<td><br></td>
										<td><br></td>
										<td><br></td>
										<td><br></td>
										<td><br></td>
										<td align="right" style="padding-right: 50px">
											<input type="button" class="k-button" onclick="toSubmitApprMember()" value="Update"></input>
											<input type="button" class="k-button" value="Clear" onclick="toClear('Y')"></input>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</body>
	</html>	