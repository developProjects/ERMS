<!DOCTYPE html>
<html lang="en">
<head>
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

	<!-- Kendo UI combined JavaScript -->
	<script src="/ermsweb/resources/js/kendo.all.min.js"></script>

 	<script>
	 	var objPastToPager = null; // This value will be used to pass the value to another list
	 	var initialLoad = true; // Nothing
		$(document).ready(function(){
			/* Control and initialize the menu bar of header
			 (8 options of menu)
			*/
			$("#menu1").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			$("#menu2").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			$("#menu3").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			$("#menu4").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			$("#menu5").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			$("#menu6").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			$("#menu7").kendoMenu({
				animation: {open: {effects: "slideIn:down"}}
			});
			
			/* $("#prodType").kendoDropDownList({
				optionLabel: "Select"
			}); */
			var ruleName = getURLParameters('ruleId');
			var getLmtProdRecord = new kendo.data.DataSource({
				transport: {
					read: {
						url: window.sessionStorage.getItem('serverPath')+"lmtMonitorRule/getRecord?userId='"+window.sessionStorage.getItem('username')+"'&crId=''&ruleName="+ruleName,
						dataType: "json",
						
						xhrFields: {
                        	withCredentials: true
                        }
					},
					update:{
						type:"POST",
						url: window.sessionStorage.getItem('serverPath')+"lmtMonitorRule/submit",
						dataType: "json",
						contentType:"application/json",
						complete: function (jqXHR, textStatus){
							var response = JSON.parse(jqXHR.responseText);
							if(response.action=="success"){
								toBack();
							}else{
								$(".confirm-del").html(response.message);
							}
						},
						xhrFields: {
	                        withCredentials: true
	                       }
					},
					parameterMap: function(options, operation) {
					      if (operation != "read") {
					     	return /* kendo.stringify(options); */JSON.stringify(options);
						}
					} 
				},
				error:function(e){
									if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
								},						
				schema: {                               // describe the result format
		            data: function(data) {              // the data which the data source will be bound to is in the values field
		                return [data];
		            },
		            model:{
		            	id:"crId"
		            }
		        }				
			});
			
			var getLmtDroplist=window.sessionStorage.getItem('serverPath')+"lmtMonitorRule/getLmtProdTypeList?userId="+window.sessionStorage.getItem('username');
			
			var ddlLimitProductDataSource = new kendo.data.DataSource({
				transport: {
					read: {
						url: getLmtDroplist,
						dataType: "json",
						xhrFields: {
                        	withCredentials: true
                        }
					}
				},
				schema:{
					data: function(data){
						return [data];
					}
				}
			});
			
			ddlLimitProductDataSource.fetch(function(){
				var dsData = this.view()[0];
				$('#limitType').kendoDropDownList({
					optionLabel: "Select",
					dataTextField: "lmtDesc",
					dataValueField: "lmtType",
					dataSource:dsData,
					change:function(e){
						var dsProductTypes = dsData[this.selectedIndex - 1];
						fecthProducts(dsProductTypes);						
					}
				});
			});
			
			function fecthProducts(dsProductTypes){
				var optionHtml = "";
				var disableFlag = ((dsProductTypes.lmtType).toLowerCase() == "all") ? true : false;
				if((dsProductTypes.lmtType).toLowerCase() == "all"){
					optionHtml = optionHtml+"<option value='"+element.prodType+"' selected>"+element.prodType+"</option>";	
				}else{
					optionHtml = optionHtml+"<option value='"+element.prodType+"'>"+element.prodType+"</option>";
				}
				$('#prodType').html(optionHtml);
				$('#prodType').prop("disabled", disableFlag);
			}
			
			$('#entity').kendoDropDownList({
				dataSource: ["BOCIL","BOCIS","BOCIFP","BOCIGC","BOCI Finance","ALL"],
				value: "ALL",
				index:0
			});

			$('#groupTypeCode').kendoDropDownList({
				optionLabel: "Select",
				dataTextField: "dataText",
				dataValueField: "dataField",
				dataSource: {
					transport: {
						read: {
							url: window.sessionStorage.getItem('serverPath')+"common/getGroupTypeList",
							dataType: "json",
							xhrFields: {
	                        	withCredentials: true
	                        }
						}
					}
				},
				index:0
			}); 
			
			$('#limitCcy').kendoDropDownList({
				optionLabel: "Select",
				dataTextField: "dataText",
				dataValueField: "dataField",
				dataSource: {
					transport: {
						read: {
							url: window.sessionStorage.getItem('serverPath')+"common/getCcyList",
							dataType: "json",
							xhrFields: {
	                        	withCredentials: true
	                        }
						}
					}
				},
				index:0
			}); 
			
			$('#limitAmt').kendoNumericTextBox({
				decimals:2,			
				spinners: false
			});
			
			$('#firstWarnRatio, #secondWarnRatio').kendoNumericTextBox({
				spinners: false
			});
			
			//var paramCrId = "CR1237";
			getLmtProdRecord.fetch(function(){
				var jsonObj = this.view();
				$.each(jsonObj, function(i){
					//if (validateResponse(jsonObj[i].crId) == paramCrId){
						$("#ruleName").val(validateResponse(jsonObj[i].ruleName));
						
						$("#limitType").data("kendoDropDownList").value(validateResponse(jsonObj[i].lmtTypeCode));
						
						$("#limitType").data("kendoDropDownList").trigger("change");//To show the Product Details triggering manually
						
						var objProdTypeList = jsonObj[i].prodTypeList.match(/(?=\S)[^,]+?(?=\s*(,|$))/g);
						$('#prodType').val(objProdTypeList);
						
						$("#entity").data("kendoDropDownList").value(validateResponse(jsonObj[i].ruleBookEntity));
						$("#limitCcy").data("kendoDropDownList").value(validateResponse(jsonObj[i].ruleLmtCcy));
						
						$("#limitAmt").data("kendoNumericTextBox").value(validateResponse(jsonObj[i].ruleLmtAmt));
						$("#firstWarnRatio").data("kendoNumericTextBox").value(validateResponse(jsonObj[i].firstWarnRatio));
						$("#secondWarnRatio").data("kendoNumericTextBox").value(validateResponse(jsonObj[i].secondWarnRatio));
						
						if(validateResponse(jsonObj[i].partyType)){
							var radioGroup = $.trim(validateResponse(jsonObj[i].partyType)).toLowerCase();
							$("input[fieldBlock='"+radioGroup+"']").prop("checked",true).attr("saveField",validateResponse(jsonObj[i].partyId));
							if(radioGroup == "account"){
								$("#Acct").text(validateResponse(jsonObj[i].partyId));						
								$("#subAcctNo").text(validateResponse(jsonObj[i].partySubId));
							}else if(radioGroup == "client"){
								$("#client").text(validateResponse(jsonObj[i].partyName));
							}
						}

						$("#groupType").text(validateResponse(jsonObj[i].groupType));
						$("#group").text(validateResponse(jsonObj[i].groupTypeDesc));
						
						$("#created_by").html(jsonObj[i].createBy);
						$("#created_at").html(validDate(jsonObj[i].createDt));
						$("#updated_by").html(jsonObj[i].lastUpdateBy);
						$("#updated_at").html(validDate(jsonObj[i].lastUpdateDt));
						$("#verified_by").html(jsonObj[i].verifyBy);
						$("#verified_at").html(validDate(jsonObj[i].verifyDt));
						$("#status_last").html(jsonObj[i].status);
					//}
				});
			});
			
			/* Clear the Input Fields*/
			$("#clearBtn").click(function(){
      			var parent = $(this).closest(".form");
      			parent.find("input[type='text']").val("");
      			parent.find('input[type=radio]').prop('checked', false);
      			parent.find('[data-role="dropdownlist"]').each(function(){
      				var default_attr = $(this).attr("default-attr");
      				$(this).data("kendoDropDownList").value((default_attr) ? default_attr : "");
      			})
      			parent.find('[data-role="numerictextbox"]').each(function(){
      				$(this).data("kendoNumericTextBox").value("");    
      			});
      		
      		}); 
			// Validators    		
      		var validator = $("#produtLmtMonitorRuleform").kendoValidator().data("kendoValidator");
			$("#saveBtn").kendoButton({
				click: function(){
					if (validator.validate()) {
						var partyId = $("input[name='radio_acg']:checked").attr("saveField");
						var partyType = $("input[name='radio_acg']:checked").attr("fieldBlock");
						var dataDatasource = getLmtProdRecord.at(0);
						getLmtProdRecord.transport.options.update.url= window.sessionStorage.getItem('serverPath')+"lmtMonitorRule/save";
						dataDatasource.set("ruleName",$("#ruleName").val());
						dataDatasource.set("oriRuleName","");
						//dataDatasource.set("modeType",$("#modeType").val());
						dataDatasource.set("lmtTypeCode",$("#limitType").val());
						dataDatasource.set("prodTypeList",($("#prodType").val()) ? $("#prodType").val().toString() : "");
						dataDatasource.set("ruleBookEntity",$("#entity").val());
						dataDatasource.set("ruleLmtCcy",$("#limitCcy").val());
						dataDatasource.set("ruleLmtAmt",$("#limitAmt").val());
						dataDatasource.set("firstWarnRatio",$("#firstWarnRatio").val());
						dataDatasource.set("secondWarnRatio",$("#secondWarnRatio").val());
						
						dataDatasource.set("partyId",partyId);
						dataDatasource.set("partyType",partyType.toUpperCase());
						dataDatasource.set("partySubId",$("#subAcctNo").text());
						dataDatasource.set("crStatus","saved");
						dataDatasource.set("dataSourceAppId","");
						dataDatasource.set("crAction","UPDATE");
						//console.log(dataDatasource);
						getLmtProdRecord.sync();
					}
				}
			});
			
			$("#submitBtn").kendoButton({
				click: function(){
					if (validator.validate()) {
						var partyId = $("input[name='radio_acg']:checked").attr("saveField");
						var partyType = $("input[name='radio_acg']:checked").attr("fieldBlock");
						var dataDatasource = getLmtProdRecord.at(0);
						getLmtProdRecord.transport.options.update.url= window.sessionStorage.getItem('serverPath')+"lmtMonitorRule/submit";
						dataDatasource.set("ruleName",$("#ruleName").val());
						dataDatasource.set("oriRuleName","");
						//dataDatasource.set("modeType",$("#modeType").val());
						dataDatasource.set("lmtTypeCode",$("#limitType").val());
						dataDatasource.set("prodTypeList",($("#prodType").val()) ? $("#prodType").val().toString() : "");
						dataDatasource.set("ruleBookEntity",$("#entity").val());
						dataDatasource.set("ruleLmtCcy",$("#limitCcy").val());
						dataDatasource.set("ruleLmtAmt",$("#limitAmt").val());
						dataDatasource.set("firstWarnRatio",$("#firstWarnRatio").val());
						dataDatasource.set("secondWarnRatio",$("#secondWarnRatio").val());
						
						dataDatasource.set("partyId",partyId);
						dataDatasource.set("partyType",partyType.toUpperCase());
						dataDatasource.set("partySubId",$("#subAcctNo").text());
						dataDatasource.set("crStatus","Pending for Approval");
						dataDatasource.set("dataSourceAppId","");
						dataDatasource.set("crAction","UPDATE");
						//console.log(dataDatasource);
						getLmtProdRecord.sync();
					}
				}
			});
			
			$("input[name='radio_acg']").each(function(){
				$(this).click(function(){
					var enable_search = $(this).attr("fieldBlock");
					//$(".button_search").attr("searchTerm",enable_search);
					$(".dyn-search-header").html(enable_search.charAt(0).toUpperCase() + enable_search.slice(1));
					enable_search = (enable_search == "entity") ? "default" : enable_search;					
					resetToDefaults();
					if(enable_search != "default"){
						$("#create_search_details_container").show();
						$("#"+enable_search+"_search").show();
					}
				});
			});
			var searchCriteria = {};
			$(".button_search").click(function(){
				var activeSearchBlock = $("input[name='radio_acg']:checked").attr("fieldBlock");
				var searchBlock = activeSearchBlock+"-on";
				searchCriteria = {};
				
				$("."+searchBlock).each(function(index, element){
					var fieldId = $(this).attr("id");
					if(fieldId){
						searchCriteria[fieldId] = $("#"+fieldId).val();
					}
				});				
				dataGrids(searchCriteria, activeSearchBlock);
			});
					
		});
		
	//Displaying Data in the Grids
	function dataGrids(searchCriteria, searchTable){		
		openModal();
		var optionColumns = [];
		var getActiveListDetailsURL = "";
		
		switch(searchTable){
			case "account":
				optionColumns.push(
					{field:"acctId", title:"Account No."},
					{field:"subAcc", title:"Sub acc."},
					{field:"accNameEng", title:"Account - Name"},
					{field:"accNameChi", title:"Account - Name(Chi)"},
					{field:"accEntity", title:"Acc - Entity"},
					{field:"accBizUnit", title:"Acc - Biz Unit"}
				);
				//getActiveListDetailsURL = "/ermsweb/resources/js/searchAccounts.json";
				getActiveListDetailsURL = window.sessionStorage.getItem('serverPath')+"acct/searchAccounts?userId='"+window.sessionStorage.getItem('username')+"'&accountNo='"+searchCriteria.accountNo+"'&accName="+searchCriteria.accName;
				break;
			case "client":
				optionColumns.push(
					{field:"ccdNameEng", title:"Client / Counterparty Name"},
					{field:"ccdNameChi", title:"Client / Counterparty Chi Name"}
				);
				//getActiveListDetailsURL = "/ermsweb/resources/js/searchLegalparties.json";
				getActiveListDetailsURL = window.sessionStorage.getItem('serverPath')+"legalParty/searchLegalParties?userId='"+window.sessionStorage.getItem('username')+"'&ccdId='"+searchCriteria.ccdId+"'&ccdName="+searchCriteria.ccdName;
				break;
			case "group":
				optionColumns.push(
					{field:"groupTypeDesc", title:"Group Type"},
					{field:"rmdGroupDesc", title:"Group Name"}
				);
				//getActiveListDetailsURL = "/ermsweb/resources/js/searchGroups.json";
				getActiveListDetailsURL = window.sessionStorage.getItem('serverPath')+"groupDetail/searchGroups?userId='"+window.sessionStorage.getItem('username')+"'&rmdGroupDesc='"+searchCriteria.rmdGroupDesc+"'&groupTypeDesc="+searchCriteria.groupTypeCode;
				break;
			default:
				break;
		}
		optionColumns.push({command: { text: "Select", click: showDetails }, title:""});
		//console.log(optionColumns);
		var activeDataSource = new kendo.data.DataSource({
			transport: {
				read: {
					url: getActiveListDetailsURL,
					dataType: "json",
					data:searchCriteria,
					xhrFields: {
                    	withCredentials: true
                    }
				}
			},
			pageSize: 3
		});
		
		$("#active-list").kendoGrid({
			dataSource: activeDataSource,
			sortable:false,
			scrollable:false,
			pageable: true,				
			columns: optionColumns
		});			
		closeModal();
	}
	
	function showDetails(e){
		e.preventDefault();
		var activeSearchBlock = $("input[name='radio_acg']:checked").attr("fieldBlock");
		var dataItem = this.dataItem($(e.currentTarget).closest("tr"));
		//console.log(activeSearchBlock);
		selectData(activeSearchBlock, dataItem);
	}
	/* Populate date to the form from the Search Grid*/
	function selectData(searchObj, dataItem){
		if(searchObj == "account"){
			$("#Acct").text(dataItem.acctId);
			$("#subAcctNo").text(dataItem.subAcc);
			$("#radio_account").attr("saveField",dataItem.acctId);
		}else if(searchObj == "client"){
			$("#client").text(dataItem.ccdNameEng);
			$("#radio_client").attr("saveField",dataItem.ccdId);
		}else if(searchObj == "group"){
			$("#groupType").text(dataItem.groupTypeDesc);
			$("#group").text(dataItem.rmdGroupDesc);
			$("#radio_group").attr("saveField",dataItem.rmdGroupId);
		}
	}
	
	function resetToDefaults(){
		$("#active-list").empty().removeClass();
		$(".search-option").hide();
		$(".acgSearch").html("");
		clearSearchInputs();
	}
	
	function clearSearchInputs(){
		$(".search-option").find(".field-search-text").each(function(){
			var isSelectBox = $(this).find("input").hasClass("select-textbox");
			if(!isSelectBox){
				$(this).find("input").val("");
			}else{
				//console.log($(this).find("input").attr("id"));
				$("#"+$(this).find("input").attr("id")).data("kendoDropDownList").value("");
			}
		});
	}
	
	function validDate(obj){
    	return kendo.toString( new Date(parseInt(obj)), "MM/dd/yyyy HH:MM:tt" )
    }
	
	function validateResponse(data){
		return (data != null) ? data : "";
	}
	/* Action - Back button */
	function toBack(){
		window.location = "/ermsweb/productLimitMonitorMaintenance";
	}

	function openModal() {
	     $("#modal, #modal1").show();
	}

	function closeModal() {
	    $("#modal, #modal1").hide();	    
	}
    </script>	
</head>	
	<body>
		<div class="boci-wrapper form">
			<%@include file="header1.jsp"%>
			<div class="page-title">Maintenance - Product Limit Monitor Rule Maintenance - Create Monitor Rule</div>
			<div class="command-button-Section">
				<button class="k-button" id="saveBtn" href="#">Save</button>
				<button class="k-button" id="submitBtn">Submit</button>
				<button class="k-button" id="clearBtn" href="#">Clear</button>
				<button class="k-button" onclick="toBack()" href="#">Back</button>
			</div>
			<div class="confirm-del"></div>
	    	<div class="clear"></div>
			<div id="create_details_container" class="detail-section monitor-rule-details">
				<div class="monitor-rule-details-header">
					Monitor Rule Details
				</div>
				<form id="produtLmtMonitorRuleform">
					<table class="create-details-table">					
						<tr>
							<td class="field-label">Monitor Rule Name</td>
							<td colspan="3">
								<input type="text" class="k-textbox" name="ruleName" id="ruleName"/>
							</td>
						</tr>
						<!-- <tr>
							<td>Mode</td>
							<td colspan="3">
								<input type="radio" name="modeType" id="batchMode" value="B"/><label for="batchMode">Bacth</label>
								<input type="radio" name="modeType" id="intrDayMode" value="I"/><label for="intrDayMode">Intraday</label>
							</td>
						</tr> -->
						<tr>
							<td>Limit Type</td>
							<td colspan="3">
								<input type="text" class="select-textbox" name="limitType" id="limitType"/>
							</td>
						</tr>
						<tr>
							<td>Product Type</td>
							<td colspan="3">
								<!-- <input type="text" class="select-textbox" name="prodType" id="prodType"/> -->
								<select multiple class="select-textbox" name="prodType" id="prodType"></select>
							</td>
						</tr>
						<tr>
							<td>Entity</td>
							<td colspan="3">
								<input type="text" class="select-textbox" name="entity" id="entity"/>
							</td>
						</tr>
						<tr>
							<td>Limit CCY</td>
							<td colspan="3">
								<input type="text" class="select-textbox" name="limitCcy" id="limitCcy"/>
							</td>
						</tr>
						<tr>
							<td>Limit Amount</td>
							<td colspan="3">
								<input type="text" class="k-textbox num-text" name="limitAmt" id="limitAmt"/>
							</td>
						</tr>
						<tr>
							<td>1<sup>st</sup> Warning <span>&#37</span></td>
							<td colspan="3">
								<input type="text" class="k-textbox num-text" name="firstWarnRatio" id="firstWarnRatio"/>
							</td>
						</tr>
						<tr>
							<td>2<sup>nd</sup> Warning <span>&#37</span></td>
							<td colspan="3">
								<input type="text" class="k-textbox num-text" name="secondWarnRatio" id="secondWarnRatio"/>
							</td>
						</tr>
						<tr>
							<td colspan="4">&nbsp;</td>
						</tr>
						<tr>
							<td>Account/Client/Client Group</td>
							<td class="field-grouping-radio">
								<input type="radio" name="radio_acg" fieldBlock = "entity" saveField="" id="radio_entity"><label for="radio_entity">Entity Level Only</label>
							</td>					
							<td colspan="2">&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td class="field-grouping-radio">
								<input type="radio" name="radio_acg" fieldBlock = "account" saveField="" id="radio_account"><label for="radio_account">Account</label>
							</td>
							<td class="field-grouping-label">Account No:</td>
							<td>
								<label class="k-textbox acgSearch" name="Acct" id="Acct">&nbsp;</label>
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>Sub Account No:</td>
							<td>
								<label class="k-textbox acgSearch" name="subAcctNo" id="subAcctNo">&nbsp;</label>
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>
								<input type="radio" name="radio_acg" fieldBlock = "client" saveField="" id="radio_client"><label for="radio_client">Client</label>
							</td>
							<td>Client Name</td>
							<td>
								<label class="k-textbox acgSearch" name="client" id="client">&nbsp;</label>
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>
								<input type="radio" name="radio_acg" fieldBlock = "group" saveField="" id="radio_group"><label for="radio_group">Group</label>
							</td>
							<td>Group Type</td>
							<td>
								<label class="k-textbox acgSearch" name="groupType" id="groupType">&nbsp;</label>
							</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>Group Name</td>
							<td>
								<label class="k-textbox acgSearch" name="group" id="group">&nbsp;</label>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div id="create_search_details_container" class="detail-section">
				<div class="monitor-rule-details-header">
					Search <span class="dyn-search-header">Account/Client/Client Group</span>
				</div>
				<table id="default_search" class="search-option active">					
					<tr>
						<td class="field-label">Account/Client/Client Group</td>
						<td class="field-search-text">
							<input type="text" class="k-textbox" id="acg_search_key" name="search_key"/>
						</td>
						<td>
							<button class="button_search k-button" searchTerm="" >Search</button>
						</td>
						<td>&nbsp;</td>
					</tr>
				</table>
				<!-- Account search section start -->
				<table id="account_search" class="search-option">					
					<tr>
						<td class="field-label">Account No.</td>
						<td class="field-search-text">
							<input type="text" class="k-textbox account-on" id="accountNo" name=""/>
						</td>
						<td class="pLeft20">Sub Account No.</td>
						<td class="field-search-text">
							<input type="text" class="k-textbox account-on" id="subAcc" name=""/>
						</td>
					</tr>
					<tr>
						<td class="field-label">Account Name</td>
						<td class="field-search-text">
							<input type="text" class="k-textbox account-on" id="accName" name=""/>
						</td>
						<td colspan="2" align="right">
							<button class="button_search k-button" searchTerm="" >Search</button>
						</td>						
					</tr>
				</table>
				<!-- Account search section end -->				
				<!-- Client search section start -->
				<table id="client_search" class="search-option">					
					<tr>
						<td class="field-label">Client Name</td>
						<td class="field-search-text" colspan="3">
							<input type="text" class="k-textbox client-on" id="ccdName" name=""/>
						</td>
					</tr>
					<tr>
						<td class="field-label">CCD ID</td>
						<td class="field-search-text">
							<input type="text" class="k-textbox client-on" id="ccdId" name=""/>
						</td>
						<td colspan="2">
							<button class="button_search k-button" searchTerm="" >Search</button>
						</td>						
					</tr>
				</table>
				<!-- Client search section end -->
				<!-- Group search section start -->
				<table id="group_search" class="search-option">					
					<tr>
						<td class="field-label">Group Type</td>
						<td class="field-search-text" colspan="3">
							<input type="text" class="select-textbox group-on" id="groupTypeCode" name="groupTypeCode"/>
						</td>
					</tr>
					<tr>
						<td class="field-label">Group Name</td>
						<td class="field-search-text">
							<input type="text" class="k-textbox group-on" id="rmdGroupDesc" name=""/>
						</td>
						<td colspan="2">
							<button class="button_search k-button" searchTerm="" >Search</button>
						</td>						
					</tr>
				</table>
				<!-- Group search section end -->				
				<table id="search_results_section">
					<tr><td colspan="4">Result</td></tr>
					<tr>
						<td colspan="4">
							<div id="active-list">
								<!-- <table id="list-header" class="grid-container">
									<tr>
										<th>Account</th>
										<th>ID</th>
										<th>Name</th>
										<th>&nbsp;</th>
									</tr>								
								</table> -->							
							</div>
							
							<div id="modal">
								<img id="loader" src="images/ajax-loader.gif" />
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="update-details-section">
				<table id="update-details-section-table">
					<tr>
						<td>Created By</td>
						<td><label id="created_by"></label></td>
						<td></td>
						<td></td>
						<td>Created At</td>
						<td><label id="created_at"></label></td>
					</tr>
					<tr>
						<td>Updated By</td>
						<td><label id="updated_by"></label></td>
						<td></td>
						<td></td>
						<td>Updated At</td>
						<td><label id="updated_at"></label></td>
					</tr>
					<tr>
						<td>Verified By</td>
						<td><label id="verified_by"></label></td>
						<td></td>
						<td></td>
						<td>Verified At</td>
						<td><label id="verified_at"></label></td>
					</tr>
					<tr>
						<td>Status</td>
						<td><label id="status_last"></label></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</table>
			</div>
		</div>	
	</body>
</html>	