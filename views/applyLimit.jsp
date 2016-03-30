<!DOCTYPE html>
<html lang="en">
	<link rel="shortcut icon" href="/ermsweb/resources/images/boci.ico" />
	
	<meta http-equiv='cache-control' content='no-cache'>
	<meta http-equiv='expires' content='0'>
	<meta http-equiv='pragma' content='no-cache'>
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10">
	<meta http-equiv="Content-Style-Type" content="text/css">
    <meta http-equiv="Content-Script-Type" content="text/javascript">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
 <meta http-equiv="x-ua-compatible" content="IE=10">
 
    <script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>
	<script src="/ermsweb/resources/js/common_tools.js"></script>	    

   
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
	<script src="/ermsweb/resources/js/common_tools.js"></script>
	
    <!-- Kendo UI combined JavaScript -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
    <script src="/ermsweb/resources/js/jszip.min.js"></script>

    <body>

        <script type="text/javascript">

            $(document).ready(function () {

                loadDropDownList();
                getBizUnit("bizUnit");

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
            });
            
            function onClickSearchGroup(){
                $("#searchWindow").data("kendoWindow").open();
                $("#searchWindow").data("kendoWindow").center();
            }

            function onClickSearchCcpty(){
                $("#searchWindow2").data("kendoWindow").open();
                $("#searchWindow2").data("kendoWindow").center();
            }
            function onClickSearchAccount(){
                $("#searchWindow3").data("kendoWindow").open();
                $("#searchWindow3").data("kendoWindow").center();
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
                                complete: function (jqXHR, textStatus){
                                var response = JSON.parse(jqXHR.responseText);
                                if(response.action){
                                    if(response.action == "success"){
                                         var i = 0
                                        $.each(JSON.parse(response.responseText), function(key, value) {
                                            option = document.createElement("option");
                                            option.text = checkUndefinedElement(value.apprMatrixOption);
                                            option.value = checkUndefinedElement(value.apprMatrixOption);
                                            document.getElementById("apprMatrixOpt").appendChild(option);
                                            document.getElementById("apprMatrixOpt").selectedIndex = 0;
                                            option = null;
                                        });
                                    }
                                }
                               
                            }
                         } 
                            
                    },
                    error:function(e){
                        if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
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

            function clickSearchGroup(){

                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            url:window.sessionStorage.getItem('serverPath')+"groupDetail/searchGroups?userId="+window.sessionStorage.getItem("username")+"&rmdGroupDesc="+document.getElementById('groupName2').value+"&groupTypeDesc="+document.getElementById('groupType2').value,
                            type: "GET",
                            dataType: "json",
                            
                            xhrFields: {
                                withCredentials: true
                            }
                        }
                    },
                    error:function(e){
                        if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
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
            function clickSearchCcpty(){

                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            url:window.sessionStorage.getItem('serverPath')+"legalParty/searchLegalPartiesGroup?userId="+window.sessionStorage.getItem("username")+"&ccdName="+$("#ccptyName").val()+"&legalPartyCat="+$("#legalPartyCat").val(),
                            type: "GET",
                            dataType: "json",
                            
                            xhrFields: {
                                withCredentials: true
                            }
                        }
                    },
                    error:function(e){
                        if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
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
                $('#grid2').kendoGrid({
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
                    error:function(e){
                        if(e.xhr.status == "401"){alert("Your session is expired, redirecting to login page");window.parent.location = "/ermsweb/home";}else{alert(e.errorThrown);}
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
            function selectGroupAction(rmdGroupId, groupTypeDesc, rmdGroupDesc){
                return "<input class='k-button' type='button' onclick='changeGroupFieldsValue(\""+rmdGroupId+"\", \""+rmdGroupDesc+"\")' value='Select'/>";
            }   
            function selectCcptyAction(ccdId, ccdNameEng, rmdGroupId){
                return "<input class='k-button' type='button' onclick='changeCcptyFieldsValue(\""+ccdId+"\",\""+ccdNameEng+"\", \""+rmdGroupId+"\")' value='Select'/>";
            }
            function selectAccountAction(ccdId, accountNo, rmdGroupId, subAccountNo){
                return "<input class='k-button' type='button' onclick='changeAccountFieldsValue(\""+ccdId+"\",\""+accountNo+"\", \""+rmdGroupId+"\",\""+subAccountNo+"\")' value='Select'/>";
            }
            function changeGroupFieldsValue(rmdGroupId, rmdGroupDesc){
                $("#groupId").val(checkUndefinedElement(rmdGroupId));
                $("#ccdId").val("");
                $("#groupName").val(checkUndefinedElement(rmdGroupDesc));
                $("#searchWindow").data("kendoWindow").close();
            }
            function changeCcptyFieldsValue(ccdId, ccdNameEng, rmdGroupId){
                $("#CcptyName").val(checkUndefinedElement(ccdNameEng));
                $("#groupId").val(checkUndefinedElement(rmdGroupId));
                $("#ccdId").val(checkUndefinedElement(ccdId));
                $("#searchWindow2").data("kendoWindow").close();
            }
            function changeAccountFieldsValue(ccdId, accountNo, rmdGroupId, subAccountNo){
                $("#accountNo").val(checkUndefinedElement(accountNo));  
                $("#subAccountNo").val(checkUndefinedElement(subAccountNo));
                $("#groupId").val(checkUndefinedElement(rmdGroupId));
                $("#ccdId").val(checkUndefinedElement(ccdId));
                $("#searchWindow3").data("kendoWindow").close();
            }
            function toNext(){

                /*alert("\nAccount No. :" + $("#accountNo").val() + "\nSub-Account No. :" + $("#subAccountNo").val() + "\ngroupId : " + $("#groupId").val() + "\nccdId :" + $("#ccdId").val() + "\nbizUnit :" + $("#bizUnit").val() + "\napprMatrixOpt : " + $("#apprMatrixOpt").val());*/

                window.location = "/ermsweb/limitApplicationDetail?userId=" + window.sessionStorage.getItem("username") + "&rmdGroupId=" + $("#groupId").val() + "&ccdId=" + $("#ccdId").val() + "&approvalMatrixBu=" + $("#bizUnit").val() + "&approvalMatrixOption=" + $("#apprMatrixOpt").val();
            }
            function toReset(scope){
                if(scope == "group"){
                    $("#groupName").val("");
                    $("#groupType2").val("");
                }else if(scope == "ccpty"){
                    $("#ccpty").val("");
                    $("#ccptyName").val("");
                }else if(scope == "acct"){
                    $("#acctNo").val("");
                    $("#subAcctNo").val("");
                    $("#acctName").val("");     
                }
                $("#groupId").val("");
                $("#ccdId").val("");
            }

        </script>

        <input type="hidden" id="pagetitle" name="pagetitle" value="Apply Limit"> 
            <div align="right" style="padding-right: 50px">

                <input type="button" class="k-button" value="  Next  " id="Next" onclick="toNext()"></input>
                
            </div>
            <br>

            <input type="hidden" id="groupId" name="groupId" value=""></input>
            <input type="hidden" id="ccdId" name="ccdId" value=""></input>
            
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
                        <td>Group Name.</td>
                        <td>&nbsp; : &nbsp; </td>
                        <td><input id="groupName" disabled class="k-textbox" style="width: 300px;" type="text"/><input type="button" id="searchGroup" class="k-button" value="Search" onclick="onClickSearchGroup()"></input></td>                                  
                    </tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td>Client / Counter Party Name</td>
                        <td>&nbsp; : &nbsp; </td>
                        <td><input id="CcptyName" disabled class="k-textbox" style="width: 300px;" type="text"/><input type="button" id="searchCcpty" class="k-button" value="Search" onclick="onClickSearchCcpty()"></input></td>                                  
                    </tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td>Account No.</td>
                        <td>&nbsp; : &nbsp; </td>
                        <td><input id="accountNo" disabled class="k-textbox" style="width: 300px;" type="text"/><input type="button" class="k-button" value="Search" onclick="onClickSearchAccount()"></input></td>
                    </tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td>Sub-Account No.</td>
                        <td>&nbsp; : &nbsp; </td>
                        <td><input id="subAccountNo" disabled class="k-textbox" style="width: 300px;" type="text"/></td>
                    </tr>
                    <tr>   
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                </tbody>
            </table>
            <table style="border-bottom: 1px; background-color:#DBE5F1;" cellpadding="0" cellspacing="0"  width="100%">
                <tr>
                    <td colspan="3" style="background-color:#393052; color:white;">
                        Approval Matrix Information
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <br>
                    </td>
                </tr>
                <tbody id="filterBody" style="display : block; padding-left: 7px; border: 0">
                    <tr>
                        <td width="180">Business Unit</td>
                        <td>&nbsp; : &nbsp; </td>
                        <td>
                            <select style="width: 300px;" id="bizUnit" class="select_join">
                                
                            </select>
                        </td>                                  
                    </tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td width="180">Approval Matrix Option</td>
                        <td>&nbsp; : &nbsp; </td>
                        <td>
                            <select style="width: 300px;" id="apprMatrixOpt" class="select_join">
                                
                            </select>
                        </td>                                  
                    </tr>
                    <tr style="border-bottom: 1px solid">
                        <td colspan="3">&nbsp;</td>
                    </tr>
                </tbody>
                <tr>
                    <td colspan="3" style="background-color:#393052; color:white;">
                        &nbsp;
                    </td>
                </tr>
            </table>

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
                                <button class="k-button" id="submitBtn"  type="button" onclick="clickSearchGroup()">Search</button>
                                <button class="k-button" id="resetBtn" type="button" onclick="toReset('group')">Reset</button>
                            </td>
                        </tr>
                    </tbody>
                    <tr>
                        <td colspan="4">
                             <div id="grid"></div>
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
                                <button class="k-button" id="submitBtn"  type="button" onclick="clickSearchCcpty()">Search</button>
                                <button class="k-button" id="resetBtn" type="button" onclick="toReset('ccpty')">Reset</button>
                            </td>
                        </tr>
                    </tbody>
                    <tr>
                        <td colspan="4">
                             <div id="grid2"></div>
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
                                <button class="k-button" id="submitBtn"  type="button" onclick="clickSearchAccount()">Search</button>
                                <button class="k-button" id="resetBtn" type="button" onclick="toReset('acct')">Reset</button>
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
                        

    </body>
</html>