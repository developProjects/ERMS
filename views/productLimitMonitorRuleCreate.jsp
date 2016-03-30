<!DOCTYPE html>
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
	<!-- jQuery JavaScript -->
	<script src="/ermsweb/resources/js/jquery.min.js"></script>

	<!-- Kendo UI combined JavaScript -->
	<script src="/ermsweb/resources/js/kendo.all.min.js"></script>

 	<script>
	 	var objPastToPager = null; // This value will be used to pass the value to another list

	 	var initialLoad = true; // Nothing
		$(document).ready(function(){
			
			
			var newLmtProdRecord = new kendo.data.DataSource({
				transport: {
					create:{
						type:"POST",
						url: window.sessionStorage.getItem('serverPath')+"lmtMonitorRule/submit",
						dataType: "json",
						xhrFields: {
                        	withCredentials: true
                        },
						contentType:"application/json",
						complete: function (jqXHR, textStatus){
							
							var response = JSON.parse(jqXHR.responseText);
							//console.log(response);
							if(response.action=="success"){
								toBack();
							}else{
								$(".confirm-del").html(response.message);
							}
						}
						
					},
					parameterMap: function(options, operation) {
					      if (operation != "read") {
					     	return JSON.stringify(options);
						}
					} 
				},
				error:function(e){
									if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
								},
				schema: { 
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
					dataSource: dsData,
					change:function(e){
						var dsProductTypes = dsData[this.selectedIndex - 1];
						fecthProducts(dsProductTypes)
					}
				});
			});
			
			function fecthProducts(dsProductTypes){
				var optionHtml = "";
				var disableFlag = ((dsProductTypes.lmtType).toLowerCase() == "all") ? true : false;
				$.each(dsProductTypes.product, function(index, element){
					if((dsProductTypes.lmtType).toLowerCase() == "all"){
						optionHtml = optionHtml+"<option value='"+element.prodType+"' selected>"+element.prodType+"</option>";	
					}else{
						optionHtml = optionHtml+"<option value='"+element.prodType+"'>"+element.prodType+"</option>";
					}
					
				});
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
      		var validator = $("#create_newmonitorRule_form").kendoValidator().data("kendoValidator");
			
			$("#saveBtn").kendoButton({
				click: function(){
					
					if (validator.validate()) {
						var partyTypeVal =$("input[name='radio_acg']:checked").attr("fieldBlock");
						var partyId = $("input[name='radio_acg']:checked").attr("saveField");
						var prodTypeListVal = ($("#prodType").val()) ? $("#prodType").val().toString() : "";
						newLmtProdRecord.transport.options.create.url= window.sessionStorage.getItem('serverPath')+"lmtMonitorRule/save";
						
						newLmtProdRecord.add({
							"ruleName":$("#ruleName").val(),
							"oriRuleName":"",
							"lmtTypeCode":$("#limitType").val(),
							"prodTypeList":prodTypeListVal,
							"ruleBookEntity":$("#entity").val(),
							"ruleLmtCcy":$("#limitCcy").val(),
							"ruleLmtAmt":$("#limitAmt").val(),
							"firstWarnRatio":$("#firstWarnRatio").val(),
							"secondWarnRatio":$("#secondWarnRatio").val(),
							"partyType":partyTypeVal.toUpperCase(),
							"partyId":partyId,							
							"partySubId":$("#subAcctNo").text(),
							"crStatus":"saved",
							"dataSourceAppId":"",
							"crAction":"CREATE"
						});
						//console.log(dataDatasource);
						newLmtProdRecord.sync();
					}
				}
			});
			
			$("#submitBtn").kendoButton({
				click: function(){
					
					if (validator.validate()) {
						var partyTypeVal =$("input[name='radio_acg']:checked").attr("fieldBlock");
						var partyId = $("input[name='radio_acg']:checked").attr("saveField");
						var prodTypeListVal = ($("#prodType").val()) ? $("#prodType").val().toString() : "";
						newLmtProdRecord.transport.options.create.url= window.sessionStorage.getItem('serverPath')+"lmtMonitorRule/submit";
						
						newLmtProdRecord.add({
							"ruleName":$("#ruleName").val(),
							"oriRuleName":"",
							"lmtTypeCode":$("#limitType").val(),
							"prodTypeList":prodTypeListVal,
							"ruleBookEntity":$("#entity").val(),
							"ruleLmtCcy":$("#limitCcy").val(),
							"ruleLmtAmt":$("#limitAmt").val(),
							"firstWarnRatio":$("#firstWarnRatio").val(),
							"secondWarnRatio":$("#secondWarnRatio").val(),
							"partyType":partyTypeVal.toUpperCase(),
							"partyId":partyId,							
							"partySubId":$("#subAcctNo").text(),
							"crStatus":"pending for Approval",
							"dataSourceAppId":"",
							"crAction":"CREATE"
						});
						//console.log(dataDatasource);
						newLmtProdRecord.sync();
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
				searchCriteria['userId'] = window.sessionStorage.getItem('username');
				$("."+searchBlock).each(function(index, element){
					var fieldId = $(this).attr("id");
					searchCriteria[fieldId] = $("#"+fieldId).val();	 
				});
				if(activeSearchBlock && activeSearchBlock != "entity"){
					dataGrids(searchCriteria, activeSearchBlock);
				}
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
				getActiveListDetailsURL = window.sessionStorage.getItem('serverPath')+"acct/searchAccounts";
				break;
			case "client":
				optionColumns.push(
					{field:"ccdNameEng", title:"Client / Counterparty Name"},
					{field:"ccdNameChi", title:"Client / Counterparty Chi Name"}
				);
				//getActiveListDetailsURL = "/ermsweb/resources/js/searchLegalparties.json";
				getActiveListDetailsURL = window.sessionStorage.getItem('serverPath')+"legalParty/searchLegalParties";
				break;
			case "group":
				optionColumns.push(
					{field:"groupTypeDesc", title:"Group Type"},
					{field:"rmdGroupDesc", title:"Group Name"}
				);
				//getActiveListDetailsURL = "/ermsweb/resources/js/searchGroups.json";
				getActiveListDetailsURL = window.sessionStorage.getItem('serverPath')+"groupDetail/searchGroups";
				break;
			default:
				break;
		}
		optionColumns.push({command: { text: "Select", click: showDetails }, title:""});//Command Button will display for every row
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
	
	/* External function called from Grid custom command*/
	function showDetails(e){
		e.preventDefault();
		var activeSearchBlock = $("input[name='radio_acg']:checked").attr("fieldBlock");
		var dataItem = "";
		dataItem = this.dataItem($(e.currentTarget).closest("tr"));// Returned the selected object
		//console.log(activeSearchBlock);
		selectData(activeSearchBlock, dataItem);
	}
	/* Populate date to the form from the Search Grid*/
	function selectData(searchObj, dataItem){
		//console.log(dataItem);
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
		//$("#active-list").empty().removeClass();
		$("#active-list").replaceWith("<div id='active-list'></div>");
		$(".search-option").hide();
		$(".acgSearch").text("");
		$("#create_search_details_container").hide();
		clearSearchInputs();
	}
	
	function clearSearchInputs(){
		$(".search-option").find(".field-search-text").each(function(){
			var isSelectBox = $(this).find("input").hasClass("select-textbox");
			if(!isSelectBox){
				$(this).find("input").val("");
			}else{
				$("#"+$(this).find("input").attr("id")).data("kendoDropDownList").value("");
			}
		});
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
				<button class="k-button" id="submitBtn" href="#">Submit</button>
				<button class="k-button" id="clearBtn" href="#">Clear</button>
				<button class="k-button" onclick="toBack()" href="#">Back</button>
			</div>
			<div class="confirm-del"></div>
	    	<div class="clear"></div>
			<div id="create_details_container" class="detail-section monitor-rule-details">
				<div class="monitor-rule-details-header">
					Monitor Rule Details
				</div>
				<form id="create_newmonitorRule_form">
					<table class="create-details-table">					
						<tr>
							<td class="field-label">Monitor Rule Name</td>
							<td colspan="3">
								<input type="text" class="k-textbox" name="ruleName" id="ruleName" required/>
							</td>
						</tr>
						<!-- <tr>
							<td>Mode</td>
							<td colspan="3">
								<input type="radio" name="monitorMode" id="batchMode"/><label for="batchMode">Bacth</label>
								<input type="radio" name="monitorMode" id="intrDayMode"/><label for="intrDayMode">Intraday</label>
							</td>
						</tr> -->
						<tr>
							<td>Limit Type</td>
							<td colspan="3">
								<input type="text" class="select-textbox" name="limitType" id="limitType" required/>
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
								<input type="text" class="select-textbox" name="entity" id="entity" required/>
							</td>
						</tr>
						<tr>
							<td>Limit CCY</td>
							<td colspan="3">
								<input type="text" class="select-textbox" name="limitCcy" value="hkd" id="limitCcy"/>
							</td>
						</tr>
						<tr>
							<td>Limit Amount</td>
							<td colspan="3">
								<input type="text" class="k-textbox num-text" name="limitAmt" id="limitAmt" required/>
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
								<input type="radio" name="radio_acg" saveField="" fieldBlock = "entity" id="radio_entity"><label for="radio_entity">Entity Level Only</label>
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