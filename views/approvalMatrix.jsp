<!DOCTYPE html>
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

<head>
<input type="hidden" id="pagetitle" name="pagetitle"
	value="Approval Matrix">
</head>
<script>
	    
		 	$("#dropDownApprList").kendoDropDownList();

		 	var wnd, detailsTemplate;

		        $(document).ready(function () {

		        		loadDropDownList();

			        	$("#submitBtn").kendoButton({
			        		click: function(e) {
								submitButtonEvent(document.getElementById("dropDownApprList").value);
				            }
				       	});
				       	$("#resetBtn").kendoButton({
				       		click: function(e) {
				       			
				       		}
				       	});
				       	$("#exportBtn").kendoButton();
		        	}
		        );

				/* Handle underfined / null element */
				function checkUndefinedElement(element){
					if(element === null || element === "undefined"){
						return "";
					}else{
						return element;
					}
				}

				function handleOperator(operator){
					/*= : EQ
					> : GTR
					< : LSS
					>= : GEQ
					<= : LEQ*/
					if(operator == "EQ"){
						return "=";
					}
					else if( operator == "GTR"){
						return ">";
					}
					else if( operator == "LSS"){
						return "<";
					}
					else if( operator == "GEQ"){
						return ">=";
					}
					else if( operator == "LEQ"){
						return "<=";
					}else{
						return "";
					}
				}

				function loadDropDownList(){

					var url = window.sessionStorage.getItem('serverPath')+"lmtApprMatrix/getOptionList?userId="+window.sessionStorage.getItem("username");

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
						    			var i = 0
							     		$.each(JSON.parse(response.responseText), function(key, value) {
					     					option = document.createElement("option");
								     		option.text = checkUndefinedElement(value.apprMatrixOption);
								     		option.value = checkUndefinedElement(value.apprMatrixOption);
								     		document.getElementById("dropDownApprList").appendChild(option);
								     		document.getElementById("dropDownApprList").selectedIndex = 0;
								     		option = null;
							     		});
							     		submitButtonEvent(document.getElementById("dropDownApprList").value);
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
				
				function getCookie(key) {  
				   var keyValue = document.cookie.match('(^|;) ?' + key + '=([^;]*)(;|$)');  
				   return keyValue ? keyValue[2] : null;  
				} 

				function getUserId(){
					return window.sessionStorage.getItem("username");
				}
				function showDetails(e) {

                    e.preventDefault();
                    var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
                    wnd.content(detailsTemplate(dataItem));
                    wnd.center().open();
                }
				function toSubmit(){
					document.getElementById("returnMessage").innerHTML = "";
					if(checkUndefinedElement($("#captialBase").val()) > 100 || checkUndefinedElement($("#captialBase").val()) < 0){

						alert("The Captial Base should not be more than 9.99 or less than 0 ");

					}else{
						
						var url = window.sessionStorage.getItem('serverPath')+"lmtApprMatrix/updateRuleDetail?userId="+window.sessionStorage.getItem("username")+"&matrixOpt="+document.getElementById("apprMatrixOption").textContent+"&bizUnit="+document.getElementById('bizUnit').textContent+"&leeChangeDesc="+document.getElementById('leeChangeDesc').textContent+"&apprLevel="+document.getElementById('apprLevel').textContent+"&ccfLmtAmtCcy="+$("#currencey").val()+"&ccfLmtAmt="+$("#amount").val()+"&bociCapBaseRatio="+checkUndefinedElement($("#captialBase").val())+"&creditGroupLeeOperator="+document.getElementById('creditGroupLeeOperator').textContent;	

						var dataSource = new kendo.data.DataSource({
							transport: {
							    read: function(options) {
				                    $.ajax({
				                        type: "GET",
				                        url: url,
				                        contentType: "application/json; charset=utf-8",
				                        dataType: "json",
				                        success: function (result) {
				                            options.success(result);
				                        },
				                        complete: function (jqXHR, textStatus){
											if(textStatus == "success"){
												var obj = JSON.parse(jqXHR.responseText);
												console.log(obj.message.toUpperCase());
												document.getElementById("returnMessage").style.color = "green"
												document.getElementById("returnMessage").innerHTML = obj.message;
											}else{
												document.getElementById("returnMessage").style.color = "green"
												document.getElementById("returnMessage").innerHTML = obj.message;
											}
											submitButtonEvent(document.getElementById('dropDownApprList').value);

											document.getElementById('editCorner').style.display = "none";

											wnd.center().close();
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
						submitButtonEvent(document.getElementById('dropDownApprList').value);
					}
				}
				function toBack(){
					document.getElementById('editCorner').style.display = "none";
					wnd.center().close();
				}
				function fillDataToFrame(bizUnit, apprMatrixOption, leeChangeDesc, apprLevel, creditGroupLeeOperator, ccfLmtAmt, bociCapBaseRatio, ccfLmtAmtCcy, captialBase){
					return "<input type='button' class='k-button' onclick=\"editBtnOnClick('"+bizUnit+"','"+apprMatrixOption+"','"+leeChangeDesc+"','"+apprLevel+"','"+creditGroupLeeOperator+"','"+ccfLmtAmt+"','"+bociCapBaseRatio+"','"+ccfLmtAmtCcy+"', '"+captialBase+"')\" value='Edit'/>";
				}
				function editBtnOnClick(bizUnit, apprMatrixOption, leeChangeDesc, apprLevel, creditGroupLeeOperator, ccfLmtAmt, bociCapBaseRatio, ccfLmtAmtCcy, captialBase){

					document.getElementById('editCorner').style.display = "block";
					document.getElementById("bizUnit").innerHTML =  bizUnit;
					document.getElementById("apprMatrixOption").innerHTML = apprMatrixOption; 
					document.getElementById("leeChangeDesc").innerHTML = leeChangeDesc;
					document.getElementById("apprLevel").innerHTML =  apprLevel;
					document.getElementById("creditGroupLeeOperator").innerHTML = handleOperator(creditGroupLeeOperator);
					document.getElementById("currencey").value = ccfLmtAmtCcy;
					document.getElementById("amount").value = ccfLmtAmt;
					document.getElementById("captialBase").value = captialBase;
				}
				function submitButtonEvent(matrixOpt){   

					/* --------------- Get User List ---------------- */

			     	var getApprMatrix = window.sessionStorage.getItem('serverPath')+"lmtApprMatrix/getOptionDetailList?userId=riskadmin&matrixOpt="+matrixOpt; 

			     	/*var getApprMatrix = "/ermsweb/resources/js/testApprMatrix.json";*/
			     	
			    	var dataSource = new kendo.data.DataSource({
			    		transport: {
			    			read: {
			    	   		  	type: "GET",
			    			    url: getApprMatrix,
			    			    dataType: "json",
			    			    xhrFields: {
						    		withCredentials: true
						    	},
						    	complete: function(jqXHR, textStatus){
						    		wnd = $("#details") .kendoWindow({title: "", modal: true, visible: false, resizable: false, width: 800 }).data("kendoWindow"); detailsTemplate = kendo.template($("#template").html()); 
						    	}
			    			}
			    		},
			    		schema:{
			    			model:{
			    				id: "id"
			    			}
			    		}
			    	});   
			
			     	 $('#MyGrid1').kendoGrid({
			     	 	dataSource: dataSource,
			     	 	filterable: false,
			     	 	columnMenu: false,
			     	 	sortable: true,
			     	 	pageable: false,			   
			     	 	height: "400",			   	   
			     	 	
			     	 	/*locked: true */// Frozen Column //
			     	 	columns: [ 	
			     	 		{ 
			     	 			field: "",
			     	 			width: "100px",
			     	 			template: "#=fillDataToFrame(bizUnit, apprMatrixOption, leeChangeDesc, apprLevel, creditGroupLeeOperator, ccfLmtAmt, bociCapBaseRatio, ccfLmtAmtCcy, bociCapBaseRatio)#"
			     	 		},
			         	 	{ 	
			         	 		field: "bizUnit" ,
			         	 		title: "Business Unit" ,
			         	 		width: 200, 
			         	 		attributes: {
			         	 			style: "font-size: 11px"
			         	 		}
			         	 	},
			         	 	{ 
			         	 		field: "apprMatrixOption" ,
			         	 		title: "Approval Matrix Options" ,
			         	 		width: 200,
			         	 		attributes: {
			         	 			style: "font-size: 11px"
			         	 		}
			         	 	},
			         	 	{ 
			         	 		field: "leeChangeDesc" ,
			         	 		title: "Change on Credit Group" ,
			         	 		width: 200,
			         	 		attributes: {
			         	 			style: "font-size: 11px"
			         	 		}
			         	 	},
			         	 	{ 
			         	 		field: "apprLevel" ,
			         	 		title: "Approval Level" ,
			         	 		width: 200,
			         	 		attributes: {
			         	 			style: "font-size: 11px"
			         	 		}
		         	 		},
		         	 		{ 
			         	 		field: "creditGroupLeeOperator" ,
			         	 		title: "Credit Group Operator" ,
			         	 		width: 200,
			         	 		attributes: {
			         	 			style: "font-size: 11px"
			         	 		},
			         	 		template: "#=handleOperator(creditGroupLeeOperator)#"
		         	 		},
		         	 		{ 
			         	 		field: "ccfLmtAmtCcy" ,
			         	 		title: "Credit Group Operator" ,
			         	 		width: 200,
			         	 		attributes: {
			         	 			style: "font-size: 11px"
			         	 		},
			         	 		template: "#=ccfLmtAmtCcy#"
		         	 		},
			         	 	{ 
			         	 		field: "ccfLmtAmt" ,
			         	 		title: "Limit Amount of X CCF" ,
			         	 		width: 200,
			         	 		attributes: {
			         	 			style: "font-size: 11px"
			         	 		}
		         	 		},
			         	 	{ 
			         	 		field: "bociCapBaseRatio" ,
			         	 		title: "BOCI Captial Base (%)" ,
			         	 		width: 200,
			         	 		attributes: {
			         	 			style: "font-size: 11px"
			         	 		}
			         	 	}
			         	]
			     	});   
			     	dataSource.read();      	
				}
		    </script>
<body onload="checkSessionAlive()">
		<%@include file="header1.jsp"%>
	<div class="page-title">Approval Matrix</div>
	<div style="display: inline">
		<label>&nbsp;&nbsp;</label>
		</labe>
		Approval Matrix Option : <select class="select_join"
			id="dropDownApprList">
		</select> <input type="button" value="Search" id="submitBtn" class="k-button"></input>
		<div id="returnMessage"></div>
	</div>


	<div style="width: 100%;" id='MyGrid1'></div>
	<div id="details"></div>
	<script type="text/x-kendo-template" id="template">
	        	</script>
	<div id="editCorner" style="display: none">
		<table cellspacing="1" cellpadding="6" width="40%">
			<tr>
				<td colspan="2"
					style="background-color: #393052; color: white; width: 500; font-size: 13px">
					User Maintenance</td>
			</tr>
			<tr>
				<td style="font-size: 13px; background-color: #B5A2C6">Business
					Unit</td>
				<td style="font-size: 13px; background-color: #E7E3EF">: <label
					id="bizUnit"></label></td>
			</tr>
			<tr>
				<td style="font-size: 13px; background-color: #B5A2C6">Approval
					Matrix Options</td>
				<td style="font-size: 13px; background-color: #E7E3EF">: <label
					id="apprMatrixOption"></label></td>
			</tr>
			<tr>
				<td style="font-size: 13px; background-color: #B5A2C6">Change
					on Credit Group</td>
				<td style="font-size: 13px; background-color: #E7E3EF">: <label
					id="leeChangeDesc"></label></td>
			</tr>
			<tr>
				<td style="font-size: 13px; background-color: #B5A2C6">Approval
					Level</td>
				<td style="font-size: 13px; background-color: #E7E3EF">: <label
					id="apprLevel"></label`></td>
			</tr>
			<tr>
				<td style="font-size: 13px; background-color: #B5A2C6">Credit
					Group Operator</td>
				<td style="font-size: 13px; background-color: #E7E3EF">: <label
					id="creditGroupLeeOperator"></label></td>
			</tr>
			<tr>
				<td style="font-size: 13px; background-color: #B5A2C6">Currencey
				</td>
				<td style="font-size: 13px; background-color: #E7E3EF">: <input
					style="width: 95%" class="k-textbox" type="text" id="currencey"
					value=""></input>
				</td>
			</tr>
			<tr>
				<td style="font-size: 13px; background-color: #B5A2C6">Limit
					Amount of xCCF</td>
				<td style="font-size: 13px; background-color: #E7E3EF">: <input
					style="width: 95%" class="k-textbox" type="text" id="amount"
					value=""></input></td>
			</tr>
			<tr>
				<td style="font-size: 13px; background-color: #B5A2C6">BOCI
					Captial Base (%)</td>
				<td style="font-size: 13px; background-color: #E7E3EF">: <input
					style="width: 95%" class="k-textbox" type="text" id="captialBase"
					value=""></input>
				</td>
			</tr>

			<tr>
				<td></td>
				<td align="right"><input type="button" class="k-button"
					onclick="toSubmit()" id="submitUpdate" value="Submit" /> <input
					type="button" class="k-button" onclick="toBack()" id="back"
					value="Close" /></td>
			</tr>
		</table>
	</div>
</body>
</html>