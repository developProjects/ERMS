<!DOCTYPE html>
<html lang="en">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 
<script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jszip/2.5.0/jszip.min.js"></script>


<!-- Kendo UI API -->
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
<!-- General layout Style -->
<link href="/ermsweb/resources/css/layout.css" rel="stylesheet"
	type="text/css">
<!-- jQuery JavaScript -->
<script src="/ermsweb/resources/js/jquery.min.js"></script>

<!--     <script src="/ermsweb/resources/js/jszip.js"></script> -->
<!-- Kendo UI combined JavaScript -->

<!--  <script src="http://kendo.cdn.telerik.com/2014.3.1029/js/kendo.all.min.js"></script>  -->
<script src="/ermsweb/resources/js/kendo.all.min.js"></script>
<script>
    $(document).ready(function(){
    	
	    		
			    var dataSource = new kendo.data.DataSource({
						transport: {
							read: {
								url: "/ermsweb/resources/js/businessunit.json",
								dataType: "json"
							}
						}
			    });
			   
    	        $("#businessUnit").kendoDropDownList({			
               		dataTextField: "text",
               		dataValueField: "value",
               		dataSource:dataSource
    	        });	  
    	
    	        var teamdataSource = new kendo.data.DataSource({
    				transport: {
    					read: {
    						url: window.sessionStorage.getItem('serverPath')+"team/getTeam?userId="+window.sessionStorage.getItem('username'),
    						dataType: "json",
                            
    						xhrFields: {
	                            withCredentials: true
	                           }
    						},
    					create: {
    			            url:window.sessionStorage.getItem('serverPath')+"team/saveTeam",
    			            type: "post",
    			            dataType: "json",
    			            xhrFields: {
	                            withCredentials: true
	                           },
    			            contentType: "application/json; charset=utf-8", 
                            complete: function (jqXHR, textStatus){
                                    var response = JSON.parse(jqXHR.responseText);
                                    if(response.action){
                                        if(response.action == "success"){
                                            $("#list").data("kendoGrid").dataSource.read();
                                        }
                                    }
                                    
                                }
    						
    			        },
    	                 parameterMap: function(options, operation) {                                 
                             // note that you may need to merge that postData with the options send from the DataSource
                           return JSON.stringify(options);                                 
                    	}
    				},
                    error:function(e){
                        if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
                    },                      
    				schema: {
    					 data: function(data) {              // the data which the data source will be bound to is in the values field
    			                //console.log(data);
    			                return data;
    			            },
    					model:{
    		            	id:"id"
    		            } 
    				},
    				
    				
    				pageSize:4
    			
    			});
    			
    			$("#list").kendoGrid({
    				excel: {
    			          allPages: true
    			        },
    				dataSource: teamdataSource,
    				
    				scrollable:true,
    				pageable: true,
    				selectable: "row",
    				change: function(e) {
    					var selectedRows = this.select();
    				    var selectedDataItems = [];
    				    for (var i = 0; i < selectedRows.length; i++) {
    				      var dataItem = this.dataItem(selectedRows[i]);
    				      selectedDataItems.push(dataItem);
    				     
    				    }
    				    
    				    $(".team-details-section").attr("rowid",selectedDataItems[0].id);
    				    $("#credit_team_label").val(selectedDataItems[0].id.teamCode);
     				    $("#businessUnit").data("kendoDropDownList").value(selectedDataItems[0].id.bizUnit);
    				    $("input[name='viewer']").each(function(){
    				    	var viewer=selectedDataItems[0].viewer;
    		    			if(viewer == $(this).val()){
    		    				$(this).prop("checked",true);
    		    			}
    		    		});
    				    $("input[name='status']").each(function(){
    				    	 var status=selectedDataItems[0].status;
    		    			if(status == $(this).val()){
    		    				$(this).prop("checked",true);
    		    			}
    		    		});
    	
    				},
    				columns: [
    					{ field: "id.teamCode", title: "Credit Team " , width: 30},
    					{ field: "id.bizUnit", title: "Business Unit", width: 30},
    					{ field: "status", title: "Status", width: 30},
    					{ field: "lastUpdateBy", title: "Updated By", width: 30},
    					{ field: "lastUpdateDt", title: "Last Update Time", width: 30,template: "#=toDateFormat(lastUpdateDt)#"}
    					
    				]
    			});
    			
    			$("#add_updateBtn").kendoButton({
        			click: function(){
        				var updateCriteria = {};
        				updateCriteria = {
        						teamCode:$("#credit_team_label").val(),
        						bizUnit:$("#businessUnit").val(),
        						status:$("input[name='status']:checked").val(),
        						userid:window.sessionStorage.getItem('username'),
        						};
        				if(updateCriteria.teamCode!="" && updateCriteria.bizUnit !=""){
        					teamdataSource.add(updateCriteria);
           					teamdataSource.sync();
        				}
        				else{
        					alert("Team Code and Business Unit can't be empty ");
        				}
       				}
        				
        		});

    			$("#exportBtn").click(function(e){
    				// trigger export of the AccDetails grid
    				var dataKendoGrid = $("#list").data("kendoGrid");
    				if(dataKendoGrid){
    					dataKendoGrid.saveAsExcel();
    				}
    			});
    	        
    	        
    });
    	
    function toClear(){
    	$("input:text").val("");
		var businessUnit = $("#businessUnit").data("kendoDropDownList");
		businessUnit.value("");
		$("#active").prop("checked",true);
		$("#no").prop("checked",true);
		
    }
    function toDateFormat(dateObj){
		var jsonDate = "/Date("+dateObj+")/";
	    var date = new Date(parseInt(jsonDate.substr(6)));

        return date.toString() != "Invalid Date" ? date.getDate().toString()+"/"+(date.getMonth()+1).toString()+"/"+date.getFullYear().toString() : "" ;
	}
    </script>
<style type="text/css">
.team-maintenance-list {
	border: 2px solid brown;
}

.team-details-section {
	margin-top: 40px;
	border: 2px solid brown;
	width: 400px;
	padding: 10px 40px;
	margin-left: 20px;
}

.team-details-section table tr td:nth-child(odd) {
	font-weight: bold;
}

.buttonPanel button {
	float: right;
	font-size: 16px;
	margin-bottom: 10px;
	margin-top: 10px;
}

#add_updateBtn {
	margin-left: 60px;
	margin-right: 20px;
}

.clear {
	clear: both;
}

.team-details-section table tr td {
	padding: 5px 10px;
}
</style>
<body>
	
	<div class="boci-wrapper">
		<%@include file="header1.jsp"%>
	<div class="page-title">Team Maintenance</div>
		<div class="boci-content-wrapper">
			<div class="buttonPanel">
				<button id="exportBtn" class="k-button">Export</button>
				<div class="clear"></div>
			</div>

			<div class="team-maintenance-list">
				<div class="list-header">Team Table</div>
				<div id="list"></div>
			</div>
			<div class="team-details-section" rowid="">
				<table>
					<tr>
						<td>Credit Team</td>
						<td><input type="text" class="k-textbox"
							id="credit_team_label"></td>
					</tr>

					<tr>
						<td>Business Unit</td>
						<td><input id="businessUnit" /></td>
					</tr>

					<tr>
						<td>Status</td>
						<td><input type='radio' name='status' value='Active'
							checked="true" id="active" /><label style="padding-right: 30px;"
							for="active">Active</label><input type='radio' name='status'
							value='Inactive' id="disable" /><label for="disable">Disable</label></td>

					</tr>

					

					<tr>
						<td colspan="2"><button id="add_updateBtn" class="k-button">Add/Update</button>
							<button id="clearBtn" class="k-button" onclick="toClear()">Clear</button></td>
					</tr>

				</table>
			</div>
		</div>
	</div>

</body>
</html>
