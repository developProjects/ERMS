<html lang="en">

	<meta http-equiv="Content-Style-Type" content="text/css">
    <meta http-equiv="Content-Script-Type" content="text/javascript">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>
    
    <!-- General layout Style -->
    <link href="/ermsweb/resources/css/layout.css" rel="stylesheet" type="text/css">

    <!-- Kendo UI API -->
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.common.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.rtl.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.default.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.dataviz.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.dataviz.default.min.css">
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.mobile.all.min.css">

    <!-- jQuery JavaScript -->
    <script src="/ermsweb/resources/js/jquery.min.js"></script>

    <!-- Kendo UI combined JavaScript -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>

    <!-- <head>Enquiry Loan Sub-Participation Ratio</head> -->

 	<script>
	 	var objPastToPager = null; // This value will be used to pass the value to another list

	 	var initialLoad = true; // Nothing
 			$(document).ready(
 				function(){
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

					/* Get the action type - view for directing to the view mode on this page */
					/* Replacing the button, label from update to view */
					/* Maker action -> */
	 					// var regex =  new RegExp("action\=view");
	 					// if(regex.test($(location).attr('href'))){
						var paramCCDID = getURLParameters("ccdid");
						var dataSource = new kendo.data.DataSource({
								transport: {
									read: {
										url: "/ermsweb/resources/js/getClientCounterDetails.json",
										dataType: "json"
									}
								},
							  change: function() {
                    var response=this.view();
                    var jsonObj= response;
                    $.each(jsonObj, function(i){
						if (jsonObj[i].ccdId == paramCCDID){
						$("#pageTitle").html("Maintenance - Client Counterparty RMD Detail Maintenance - View Client Counterparty Detail");
						$("#ccd_id_label").html("<label>"+jsonObj[i].ccdId+"</label>");
							$("#client_counterparty_name_label").html("<label>"+jsonObj[i].clnCptyName+"</label>");
							$("#client_counterparty_category_label").html("<label>"+jsonObj[i].clnCptyCat+"</label>");
							$("#domicile_label").html("<label>"+jsonObj[i].domicile+"</label>");
							$("#nationality_label").html("<label>"+jsonObj[i].nationality+"</label>");
							$("#business_nature_label").html("<label>"+jsonObj[i].busNature+"</label>");
							$("#annual_income_label").html("<label>"+jsonObj[i].annualIncome+"</label>");
							$("#estimate_net_worth_label").html("<label>"+jsonObj[i].estNetWorth+"</label>");
							$("#credit_rating_internal_private_label").html("<label>"+jsonObj[i].creditRatingInternal+"</label>");
							$("#credit_rating_moodys_label").html("<label>"+jsonObj[i].CreditRatingMoody+"</label>");
							$("#credit_rating_s_p_label").html("<label>"+jsonObj[i].creditRatingSNP+"</label>");
							$("#credit_rating_fitch_label").html("<label>"+jsonObj[i].creditRatingFitch+"</label>");
							$("#last_credit_check_approved_condition_remark_label").html("<label>"+jsonObj[i].lastCreditCheckAprvdRmk+"</label>");
							$("#stock_code_for_listed_company_label").html("<label>"+jsonObj[i].stockCode+"</label>");
							$("#aum_in_boci_group_label").html("<label>"+jsonObj[i].aumBociGrp+"</label>");							
							$("#checkEXTKey1").html("<label>"+jsonObj[i].externalKey1+"</label>");
							$("#checkEXTKey2").html("<label>"+jsonObj[i].externalKey2+"</label>");
							$("#checkEXTKey3").html("<label>"+jsonObj[i].externalKey3+"</label>");
							$("#checkEXTKey4").html("<label>"+jsonObj[i].externalKey4+"</label>");
							$("#checkEXTKey5").html("<label>"+jsonObj[i].externalKey5+"</label>");
							$("#checkEXTKey6").html("<label>"+jsonObj[i].externalKey6+"</label>");
							$("#checkEXTKey7").html("<label>"+jsonObj[i].externalKey7+"</label>");
							$("#checkEXTKey8").html("<label>"+jsonObj[i].externalKey8+"</label>");
							$("#checkEXTKey9").html("<label>"+jsonObj[i].externalKey9+"</label>");
							$("#checkEXTKey10").html("<label>"+jsonObj[i].externalKey10+"</label>");
							$("#buttonType").html("<button id=\"updateBtn\" style=\"background:blue; color:white\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\" onclick=\"toUpdate()\">Update</button><label>    </label><button id=\"discardBtn\" onclick=\"toDiscard()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Discard</button><label>    </label><button id=\"backBtn\" onclick=\"toBack()\" type=\"button\" data-role=\"button\" class=\"k-button\" role=\"button\" aria-disabled=\"false\" tabindex=\"0\">Back</button>");
						
						}
					});
                }
    });
	dataSource.read();	
	 						
				
})
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
	/* Open spinner while getting the data from back-end*/
	function openModal() {
	     document.getElementById('modal').style.display = 'block';
		 document.getElementById('modal1').style.display = 'block';
	     document.getElementById('modal2').style.display = 'block';
		 document.getElementById('modal3').style.display = 'block';
	}

	/* Close spinner when all the data have been received*/
	function closeModal() {
	    document.getElementById('modal').style.display = 'none';
		document.getElementById('modal1').style.display = 'none';
	    document.getElementById('modal2').style.display = 'none';
		document.getElementById('modal3').style.display = 'none';
	}

	/* Action - Update button */
	function toUpdate(){ /* Direct me to update page */
		window.location = "ccpDetailMaintenanceUpdate?action=update &ccdId="+getURLParameters("ccdId");
	}

	/* Action - View button */
	function toView(){ /* Direct me to view page */
		var updateBtn = document.getElementById("submitBtn");
	}

	/* Action - Back button */
	function toBack(){
		window.history.back();
	}

	/* The method which is used for capturing the parameters from URL */
	/* Return  : a Parameter  */
	/* Receive : Parameter Name */
	function getURLParameters(paramName){
		var sURL = window.document.URL.toString();
		if(sURL.indexOf("?") > 0){
			var arrParams = sURL.split("?");
			var arrURLParams = arrParams[1].split("&");
			var arrParamNames = new Array(arrURLParams.length);
			var arrParamValues = new Array(arrURLParams.length)
		}
		var i = 0;
		for(i = 0; i < arrURLParams.length; i++){
			var sParam = arrURLParams[i].split("=");
			arrParamNames[i] = sParam[0];
			if(sParam[1] != ""){
				arrParamValues[i] = unescape(sParam[1]);
			}else{
				arrParamValues[i] = "No Value";
			}
		}

		for(i = 0; i < arrURLParams.length; i++){
			if(arrParamNames[i] == paramName){
				return arrParamValues[i];
			}
		}
		return "No Parameters Found";
	}

    </script>

	<body>

<!-- 		<script type="text/javascript" src="js/header.js"></script> -->
		<div id="pageTitle" style="background-color:pink; width:1000">
		</div>
		<br>

		<table id="listTable" width="500" style=" overflow-y :scroll" >
			<tr>
				<td colspan="4" style="background-color:#393052;color:white; width:500; font-size:13px">Client Counterparty RMD Detail section</td>
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">CCD ID.</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF"><div id="ccd_id_label"><label></label></div></td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">Client/Counterparty Name.</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF"><div id="client_counterparty_name_label"><label></label></div></td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">Client/Counterparty Category.</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF"><div id="client_counterparty_category_label"><label></label></div></td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">Domicile.</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF"><div id="domicile_label"><label></label></div></td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">Nationality.</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF"><div id="nationality_label"><label></label></div></td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">Business Nature.</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF"><div id="business_nature_label"><label></label></div></td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">Annual Income.</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF"><div id="annual_income_label"><label></label></div></td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">Estimate Net Worth.</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF"><div id="estimate_net_worth_label"><label></label></div></td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">Credit Rating - Internal (Private).</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF"><div id="credit_rating_internal_private_label"><label></label></div></td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">Credit Rating - Moody's.</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF"><div id="credit_rating_moodys_label"><label></label></div></td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">Credit Rating - S&nbp;P.</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF"><div id="credit_rating_s_p_label"><label></label></div></td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">Credit Rating – Fitch.</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF"><div id="credit_rating_fitch_label"><label></label></div></td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">Last Credit Check Approved Condition Remark.</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF"><div id="last_credit_check_approved_condition_remark_label"><label></label></div></td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">Stock Code (for listed company).</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF"><div id="stock_code_for_listed_company_label"><label></label></div></td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">AUM in BOCI Group.</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF"><div id="aum_in_boci_group_label"><label></label></div></td>				
			</tr>			
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">External Key ID #1</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF">
					<div id="checkEXTKey1"/>
				</td>
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">External Key ID #2</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF">
					<div id="checkEXTKey2"/>
				</td>
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">External Key ID #3</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF">
					<div id="checkEXTKey3"/>
				</td>
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">External Key ID #4</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF">
					<div id="checkEXTKey4"/>
				</td>
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">External Key ID #5</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF">
					<div id="checkEXTKey5"/>
				</td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">External Key ID #6</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF">
					<div id="checkEXTKey6"/>
				</td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">External Key ID #7</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF">
					<div id="checkEXTKey7"/>
				</td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">External Key ID #8</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF">
					<div id="checkEXTKey8"/>
				</td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">External Key ID #9</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF">
					<div id="checkEXTKey9"/>
				</td>				
			</tr>
			<tr>
				<td width="166" style="font-size:13px; background-color:#B5A2C6">External Key ID #10</td>
				<td width="333" style="font-size:13px; background-color:#E7E3EF">
					<div id="checkEXTKey10"/>
				</td>				
			</tr>
			<tr>
				<td><br></td>
			</tr>
			<tr>
				<td></td>				
				<td align="right">
					<div id="buttonType">
						<button id="submitBtn" class="k-button" type="button">Update</button>
						<button id="resetBtn" type="button">Back</button>
					</div>
				</td>
			</tr>
			<tr></tr>
			<tr></tr>
		</table>
		<br/>
		
		<div style="width:1000px;">
			<table id="list" width="1000" >
				<tr style="background-color:#082439; color:white">
					<td colspan="16">
						<div style="font-size:13px">Client Counterparty Account List</div>
					</td>
				</tr>
				<tr style="background-color:#BDCFE7; font-size:13px;">
					<td width="166">CCD ID&nbsp;</td>
					<td width="166">CMD Client ID&nbsp;</td>
					<td width="166">Client/Counterparty&nbsp;</td>
					<td width="166">Account No.&nbsp;</td>
					<td width="166">Sub Acc&nbsp;</td>
					<td width="166">Account_Name&nbsp;</td>
					<td width="166">Acc - is Joint (Y/N)&nbsp;</td>
					<td width="166">Acc - Acc Type&nbsp;</td>
					<td width="166">Acc - Open Date&nbsp;</td>
					<td width="166">Acc - Status&nbsp;</td>
					<td width="166">Acc - Entity&nbsp;</td>
					<td width="166">Acc - Biz Unit&nbsp;</td>
					<td width="166">Acc - Sales Code&nbsp;</td>
					<td width="166">Acc - Sales Name&nbsp;</td>
					<td width="166">Acc - Dept Code&nbsp;</td>
					<td width="166">Acc - Source System&nbsp;</td>
				</tr>
				<tr>
					<td colspan="8">
						<div id="modal" align="center" style="display:none;">
							<img id="loader" src="/ermsweb/resources/images/ajax-loader.gif" />
						</div>
					</td>
				</tr>					
			</table>
			<br/>
		</div>
		<div style="font-size: 13px" id="countRow1"></div>
		<br/>
		
		<div style="width:1000px;">
			<table id="list1" width="1000" >
				<tr style="background-color:#082439; color:white">
					<td colspan="13">
						<div style="font-size:13px">Guarantor List section</div>
					</td>
				</tr>
				<tr style="background-color:#BDCFE7; font-size:13px;">
					<td width="166">Guarantor ID&nbsp;</td>
					<td width="166">Limit Type&nbsp;</td>
					<td width="166">Facility ID&nbsp;</td>
					<td width="166">Guarantor Name&nbsp;</td>
					<td width="166">Relationship with Borrower&nbsp;</td>
					<td width="166">Guarantor Domicile&nbsp;</td>
					<td width="166">Guarantor Address&nbsp;</td>
					<td width="166">Credit Support Scope&nbsp;</td>
					<td width="166">Support Type&nbsp;</td>
					<td width="166">Guarantee / Collateral Amount Cap Ccy&nbsp;</td>
					<td width="166">Guarantee / Collateral Amount Cap&nbsp;</td>
					<td width="166">Guarantee Expiry Date&nbsp;</td>
					<td width="166">Notice Period&nbsp;</td>
				</tr>
				<tr>
					<td colspan="8">
						<div id="modal1" align="center" style="display:none;">
							<img id="loader" src="/ermsweb/resources/images/ajax-loader.gif" />
						</div>
					</td>
				</tr>					
			</table>
			<br/>
		</div>
		<div style="font-size: 13px" id="countRow2"></div>
		<br/>
		
		<div style="width:1000px;">
			<table id="list2" width="1000" >
				<tr style="background-color:#082439; color:white">
					<td colspan="5">
						<div style="font-size:13px">3rd Party Collateral Provider List</div>
					</td>
				</tr>
				<tr style="background-color:#BDCFE7; font-size:13px;">
					<td width="166">Relationship&nbsp;</td>
					<td width="166">Chargor/Borrower Name&nbsp;</td>
					<td width="166">Cross collateral cap currency on Relationship&nbsp;</td>
					<td width="166">Cross collateral cap amount on Relationship&nbsp;</td>
					<td width="166">Relationship Expiry Date&nbsp;</td>					
				</tr>
				<tr>
					<td colspan="8">
						<div id="modal2" align="center" style="display:none;">
							<img id="loader" src="/ermsweb/resources/images/ajax-loader.gif" />
						</div>
					</td>
				</tr>					
			</table>
			<br/>
		</div>
		
		<div style="font-size: 13px" id="countRow3"></div>
		<br/>
		<div style="width:1000" id='MyGrid'>
			<div id="modal3" align="center" style="display:none;">
	            <img id="loader2" src="/ermsweb/resources/images/ajax-loader.gif" />
	        </div>
		</div>
		<table border="0" style="background-color:#B5D5AB">
			<tr>
				<td width="195.5" style="font-size:13px"><b>Created By</b></td>
				<td width="195.5" style="font-size:13px"><label id="created_by"></label></td>
				<td width="195.5" style="font-size:13px"></td>
				<td width="195.5" style="font-size:13px"><b>Created At</b></td>
				<td width="195.5" style="font-size:13px"><label id="created_at"></label></td>
			</tr>
			<tr>
				<td width="195.5" style="font-size:13px"><b>Updated By</b></td>
				<td width="195.5" style="font-size:13px"><label id="updated_by"></label></td>
				<td width="195.5" style="font-size:13px"></td>
				<td width="195.5" style="font-size:13px"><b>Updated At</b></td>
				<td width="195.5" style="font-size:13px"><label id="updated_at"></label></td>
			</tr>
			<tr>
				<td width="195.5" style="font-size:13px"><b>Verified By</b></td>
				<td width="195.5" style="font-size:13px"><label id="verified_by"></label></td>
				<td width="195.5" style="font-size:13px"></td>
				<td width="195.5" style="font-size:13px"><b>Verified At</b></td>
				<td width="195.5" style="font-size:13px"><label id="verified_at"></label></td>
			</tr>
			<tr>
				<td width="195.5" style="font-size:13px"><b>Status</b></td>
				<td width="195.5" style="font-size:13px"><label id="status_last"></label></td>
				<td width="195.5" style="font-size:13px"></td>
				<td width="195.5" style="font-size:13px"></td>
				<td width="195.5" style="font-size:13px"></td>
			</tr>
		</table>
	</body>
</html>	