<!DOCTYPE html>
<html lang="en">

    <!-- Page Configuation -->
	<link rel="shortcut icon" href="/ermsweb/resources/images/boci.ico" />
	<meta http-equiv="x-ua-compatible" content="IE=10">
	<meta http-equiv='cache-control' content='no-cache'>
	<meta http-equiv='expires' content='0'>
	<meta http-equiv='pragma' content='no-cache'>
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE10">
	<meta http-equiv="Content-Style-Type" content="text/css">
    <meta http-equiv="Content-Script-Type" content="text/javascript">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <script type="text/javascript" src="/ermsweb/resources/js/validation.js"></script>

   

    <!-- Kendo UI API -->
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.common.min.css">	
    <link rel="stylesheet" href="/ermsweb/resources/css/kendo.default.min.css">
    
     <!-- General layout Style -->
    <link href="/ermsweb/resources/css/layout.css" rel="stylesheet" type="text/css">
    
    <!-- jQuery JavaScript -->
    <script src="/ermsweb/resources/js/jquery.min.js"></script>
	<script src="/ermsweb/resources/js/common_tools.js"></script>
	
    <!-- Kendo UI combined JavaScript -->
    <script src="/ermsweb/resources/js/kendo.all.min.js"></script>
    <script src="/ermsweb/resources/js/jszip.min.js"></script>
    <script src="/ermsweb/resources/js/web_scrapy.js"></script>

    <body>

        <script type="text/javascript">

        var countNewExpDate = 0;
        var countCoExpDate = 0;

        var dataSourceCapture = new kendo.data.DataSource();
        var dataSourceGarbage = new kendo.data.DataSource();
        var dataSourceStaticData = new kendo.data.DataSource();

        var getDetailURL =window.sessionStorage.getItem('serverPath')+"limitapplication/getLimitAppDetailList?userId="+window.sessionStorage.getItem("username").replace("\\","\\")+"&rmdGroupId="+getURLParameters("rmdGroupId")+"&approvalMatrixBu="+getURLParameters("approvalMatrixBu")+"&approvalMatrixOption="+getURLParameters("approvalMatrixOption")+"&ccdId="+getURLParameters("ccdId")+"&action="+getURLParameters("action");


        var staticDataSource;

            function initialDocList(list){

                var grid = $("#fileDetailGrid").data("kendoGrid");

                grid.setDataSource(new kendo.data.DataSource());

                if(remarkAllList != null && remarkAllList != ""){
                    $.each(list, function(key, value) {
                        grid.dataSource.add(
                            value
                        );
                    });    
                }
            }

            function getStaticData(){

                var getStaticData =window.sessionStorage.getItem('serverPath')+"limitapplication/getLimitAppStaticData?userId="+window.sessionStorage.getItem("username").replace("\\","\\")+"&rmdGroupId="+getURLParameters("rmdGroupId")+"&approvalMatrixBu="+getURLParameters("approvalMatrixBu")+"&approvalMatrixOption="+getURLParameters("approvalMatrixOption")+"&action=a&ccdId="+getURLParameters("ccdId");

                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getStaticData,   
                            cache: false,                       
                            dataType: "json",
                            contentType: 'application/json; charset=utf-8',
                            xhrFields: {
                                withCredentials: true
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

                dataSourceStaticData = dataSource;
            }

            
            function toRatio(isRoot, ratio){
                if(isRoot == "Y"){
                    return "";
                }else{
                    return ratio * 100;    
                }
                
            }

            function enableRadioTextField(obj){

                var whichSection = "";

                var getSections = "/ermsweb/resources/js/staticData.json";

                if(obj.value == "group"){

                    $("#ccptyRadioText").prop('disabled', true);    
                    $("#ccptyRadioText").css({'background-color': '#ccc'});    

                    $("#accountRadioText").prop('disabled', true);   
                    $("#accountRadioText").css({'background-color': '#ccc'}); 

                    $("#subAccountRadioText").prop('disabled', true);    
                    $("#subAccountRadioText").css({'background-color': '#ccc'});     

                    whichSection = "groupInfo";

                   

                }else if(obj.value == "ccpty"){
                    
                    $("#ccptyRadioText").prop('disabled', false);    
                    $("#ccptyRadioText").css({'background-color': 'white'});    

                    $("#accountRadioText").prop('disabled', true);   
                    $("#accountRadioText").css({'background-color': '#ccc'}); 

                    $("#subAccountRadioText").prop('disabled', true);    
                    $("#subAccountRadioText").css({'background-color': '#ccc'});     

                    whichSection = "clientInfoList";

                }else if(obj.value == "account"){
                    
                    $("#ccptyRadioText").prop('disabled', true);    
                    $("#ccptyRadioText").css({'background-color': '#ccc'});    

                    $("#accountRadioText").prop('disabled', false);   
                    $("#accountRadioText").css({'background-color': 'white'}); 

                    $("#subAccountRadioText").prop('disabled', true);    
                    $("#subAccountRadioText").css({'background-color': '#ccc'});  

                    whichSection = "acctInfoList";
                }
                else if(obj.value == "subAccount"){
                    
                    $("#ccptyRadioText").prop('disabled', true);    
                    $("#ccptyRadioText").css({'background-color': '#ccc'});    

                    $("#accountRadioText").prop('disabled', true);   
                    $("#accountRadioText").css({'background-color': '#ccc'}); 

                    $("#subAccountRadioText").prop('disabled', false);    
                    $("#subAccountRadioText").css({'background-color': 'white'});  

                    whichSection = "subAcctInfoList";

                }

                var dataSource = new kendo.data.DataSource({
                   transport: {
                       read: {
                           type: "GET",
                           async: false,
                           url: getSections,   
                           cache: false,                       
                           dataType: "json",
                           xhrFields: {
                               withCredentials: true
                           },
                           complete: function(response, status){
                               clearDropDownWithoutBlank("ccptyRadioText");
                               clearDropDownWithoutBlank("accountRadioText");
                               clearDropDownWithoutBlank("subAccountRadioText");
                               /*$("#groupName").html("");*/
                              
                               if(status == "success"){
                                   $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {

                                        if(key == whichSection){
                                            $.each(value, function(key, value) {

                                                if(whichSection == "clientInfoList"){
                                                    
                                                    var option = document.createElement("option");
                                                    option.text = checkUndefinedElement(value.clientName);
                                                    option.value = checkUndefinedElement(value.ccdId);
                                                    document.getElementById("ccptyRadioText").appendChild(option);
                                                    option = null;

                                                }else if(whichSection == "acctInfoList"){
                                                    var option = document.createElement("option");
                                                    option.text = checkUndefinedElement(value.acctId);
                                                    option.value = value.acctId +"||"+value.bizUnit+"||"+value.bookEntity+"||"+value.dataSourceAppId;
                                                    document.getElementById("accountRadioText").appendChild(option);
                                                    option = null;

                                                }else if(whichSection == "subAcctInfoList"){
                                                    var option = document.createElement("option");
                                                    option.text = checkUndefinedElement(value.acctId + " - " + value.subAcctId);
                                                    option.value = value.acctId +"||"+value.bizUnit+"||"+value.bookEntity+"||"+value.dataSourceAppId+"||"+value.subAcctId;
                                                    document.getElementById("subAccountRadioText").appendChild(option);
                                                    option = null;
                                                }
                                            });
                                        }
                                        if(whichSection == "groupInfo"){

                                            

                                            $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {
                                                 if(key == whichSection){
                                                    renewGroupInfo(value.groupId); 
                                                 }
                                            });



                                        }else if(whichSection == "clientInfoList"){

                                            var valueOfRenewDropDown = document.getElementById("ccptyRadioText");
                                            renewCcptyInfo(valueOfRenewDropDown);

                                        }else if(whichSection == "acctInfoList"){

                                            var valueOfRenewDropDown = document.getElementById("accountRadioText");
                                            renewAcctInfo(valueOfRenewDropDown);

                                        }else if(whichSection == "subAcctInfoList"){

                                            var valueOfRenewDropDown = document.getElementById("subAccountRadioText");
                                            renewSubAcctInfo(valueOfRenewDropDown);
                                        }
                                   });
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
        
            function initialLoadGrid(){

                if(getURLParameters("action") == "V"){
                    $("#recalculateButton").css({"display":"none"});
                }else{
                    $("#recalculateButton").css({"display":"inline"});
                }

                /*var getDetailURL =window.sessionStorage.getItem('serverPath')+"limitapplication/getLimitAppDetailList?userId="+window.sessionStorage.getItem("username").replace("\\","\\")+"&rmdGroupId=1&ccdId=1&approvalMatrixBu=1&apprMatrixOpt=1";  */
                    
               /*http://lxdapp25:8080/ERMSCore/limitapplication/getLimitAppDetailList? userId="+window.sessionStorage.getItem("username").replace("\\","\\")+"&rmdGroupId="+getURLParameters("rmdGroupId")+"&approvalMatrixBu="+getURLParameters("approvalMatrixBu")+"&approvalMatrixOption="+getURLParameters("approvalMatrixOption");*/

               $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {
                    if(key == "actionButton"){

                        /*
                        SUBMIT = "S";
                        SAVE = "T";
                        DISCARD = "D";
                        RETURN = "R";
                        VERIFY = "VA"; 
                        ENDORSE = "E";
                        APPROVE = "A";
                        APPROVE_WITH_COND = "AC";
                        REJECT = "J";
                        CHECKER = "C";*/

                        var buttonAry = [];

                        console.log(value);

                        if(value == null){

                            buttonAry = [];

                        }else{

                            buttonAry = value.split("|");

                            console.log("Action Buttons ----->" + buttonAry);

                            for (var i = 0; i < buttonAry.length; i++) {

                                if("S" == buttonAry[i]){
                                   
                                   $("#submit").css({"display":"inline"}) ;

                                }
                                if("T" == buttonAry[i]){
                                       
                                    $("#save").css({"display":"inline"}) ;

                                }
                                if("D" == buttonAry[i]){
                                    
                                    $("#discard").css({"display":"inline"}) ;

                                }
                                if("R" == buttonAry[i]){
                                    
                                    $("#return").css({"display":"inline"}) ;

                                }
                                if("VA" == buttonAry[i]){
                                    
                                    $("#verify").css({"display":"inline"}) ;

                                }
                                if("E" == buttonAry[i]){
                                    
                                    $("#endose").css({"display":"inline"}) ;

                                }
                                if("A" == buttonAry[i]){
                                    
                                    $("#approve").css({"display":"inline"}) ;

                                }
                                if("AC" == buttonAry[i]){
                                    
                                    $("#approve_With_condition").css({"display":"inline"}) ;

                                }
                                if("J" == buttonAry[i]){
                                    
                                    $("#reject").css({"display":"inline"}) ;

                                }
                                if("C" == buttonAry[i]){

                                    $("#checker").css({"display":"inline"}) ;

                                }                            
                            };
                        }
                    }
               });

              /* var getDetailURL =window.sessionStorage.getItem('serverPath')+"limitapplication/getLimitAppDetailList?userId="+window.sessionStorage.getItem("username").replace("\\","\\")+"&rmdGroupId="+getURLParameters("groupId")+"&approvalMatrixBu="+getURLParameters("approvalMatrixBu")+"&approvalMatrixOption="+getURLParameters("approvalMatrixOption")+"";*/

                var totalPages = 0, totalPages2 = 0;
                var tmpDataSource;
                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getDetailURL,
                            cache: false,                       
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
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
                    /*serverPaging: true*/
                });   

                dataSourceCapture = dataSource;



                $('#grid').kendoGrid({
                    dataSource: dataSourceCapture,
                    filterable: false,
                    columnMenu: false,
                    sortable: true,
                    scrollable: true,
                    columns: [  
                        { 
                            field: "enableFulfill", 
                            title: "Fulfill" ,
                            width:50, 
                            template: "#=createRadioButtonFulfill(enableFulfill, isFulfill, partyNo, partyType, lmtTypeCode, bizUnit, dataSourceAppId, bookEntity, novaSubAcctId, crId)#"
                        },
                        { 
                            field: "enableFulfill",
                            title: "Not Fulfill" ,
                            width:50, 
                            template: "#=createRadioButtonNotFulfill(enableFulfill, isFulfill, partyNo, partyType, lmtTypeCode, bizUnit, dataSourceAppId, bookEntity, novaSubAcctId, crId)#"
                        },
                        { 
                            field: "bizUnit", 
                            title: "Business Unit" ,
                            width:150
                        },
                        { 
                            field: "groupName", 
                            title: "Group Name" ,
                            width:150
                        },
                        { 
                            field: "ccdName", 
                            title: "Client/Counter Party Name" ,
                            width:150
                        },
                        { 
                            field: "partyNo", 
                            title: "Account No." ,
                            width:150, template: "#=getAccountNo(partyNo, partyType)#"
                        },
                        { 
                            field: "novaSubAcctId", 
                            title: "Sub-Account No." ,
                            width:150
                        },
                        { 
                            field: "lmtTypeCode", 
                            title: "limit Type Desc." ,
                            width:150
                        },
                        { 
                            field: "facId", 
                            title: "Facility ID" ,
                            width:150
                        },
                        { 
                            field: "ccfRatio", 
                            title: "CCF (%)" ,
                            width:150,
                            template: "#=toRatio(isRoot, ccfRatio)#"
                        },
                        {
                            title: "Existing Facility",
                            width:150,
                            columns: [
                                {
                                    field: "existLmtCcy",
                                    title: "Currency",
                                    width:150
                                },
                                {
                                    field: "existLmtAmt",
                                    title: "Limit Amount",
                                    width:150  
                                },
                                {
                                    field: "existLmtExpiryDate",
                                    title: "Expiry Date(yyyy/mm/dd)",
                                    width:150,
                                    template: "#=toDateFormatReverse(existLmtExpiryDate)#"
                                },
                                {
                                    field: "existCcfLmtAmt",
                                    title: "Limit Amount X CCF (HKD)",
                                    width:150  
                                }
                            ]
                        },
                        {
                            title: "New Facility Limit",
                            width:150,
                            columns: [
                                {   
                                    field: "newLmtCcy",
                                    title: "Currency",
                                    width:150,
                                    template: "#=setCurrencyList(isRoot, crId, partyNo, partyType, 'new', bizUnit, bookEntity, dataSourceAppId, novaSubAcctId)#"
                                },
                                {
                                    field: "newLmtAmt",
                                    title: "Limit Amount",
                                    width:150,
                                    template: "#=setLimitAmount(isRoot, crId, partyNo, partyType, 'new', bizUnit, bookEntity, dataSourceAppId, novaSubAcctId, newLmtAmt)#"
                                },
                                {
                                    field: "newLmtExpiryDate",
                                    title: "Expiry Date(yyyy/mm/dd)",
                                    template: "#=toDateFormatField(isRoot, crId, partyNo, partyType, 'new', bizUnit, bookEntity, dataSourceAppId, novaSubAcctId, newLmtExpiryDate)#",
                                    width:150  
                                },
                                {
                                    field: "newCcyLmtAmt",
                                    title: "Limit Amount X CCF (HKD)",
                                    template: "#=checkUndefinedElement(newCcfLmtAmt)#",
                                    width:150  
                                }
                            ]
                        },
                        {
                            title: "Counter Offer : New Facility Limit",
                            width:150,
                            columns: [
                                {
                                    field: "coLmtCcy",
                                    title: "Currency",
                                    width:150,
                                    template: "#=setCurrencyList(isRoot, crId, partyNo, partyType, 'co', bizUnit, bookEntity, dataSourceAppId, novaSubAcctId)#"
                                },
                                {
                                    field: "coLmtAmt",
                                    title: "Limit Amount",
                                    width:150,
                                    template: "#=setLimitAmount(isRoot, crId, partyNo, partyType, 'co', bizUnit, bookEntity, dataSourceAppId, novaSubAcctId, coLmtAmt)#"
                                },
                                {
                                    field: "coLmtExpiryDate",
                                    title: "Expiry Date(yyyy/mm/dd)",
                                    width:150,
                                    template: "#=toDateFormatField(isRoot, crId, partyNo, partyType, 'co', bizUnit, bookEntity, dataSourceAppId, novaSubAcctId, coLmtExpiryDate)#",
                                },
                                {
                                    field: "coNewCcfLmtAmt",
                                    title: "Limit Amount X CCF (HKD)",
                                    template: "#=checkUndefinedElement(coNewCcfLmtAmt)#",
                                    width:150  
                                }
                            ]
                        },
                        { 
                            field: "crStatus", 
                            title: "Status" ,
                            width:150
                        },
                        { 
                            field: "action", 
                            title: "Action" ,
                            width:150,
                            template: "#=replacedByIconOfDetails(isRoot, recordAccess, partyNo, partyType, lmtTypeCode, bizUnit, dataSourceAppId, bookEntity, novaSubAcctId, crId)#"
                        }
                    ]
                });

                

                dataSourceCapture.fetch(function(){
                    refreshTheGridFields();
                });

                $("#grid tbody tr:first").css({"background-color":"pink"});

                var values = dataSourceCapture.data();

                for (var i = 0; i < values.length; i++) {
                    if(values[i].enableNewSection != "Y"){

                        autoSelectedByValue("currencyList-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId, values[i].newLmtCcy);

                        $("#currencyList-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).css({"border-width":"0"}); 
                        $("#currencyList-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});

                        $("#newLimitAmount-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).css({"border-width":"0"});
                        $("#newLimitAmount-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});


                        $("#newLmtExpiryDate-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});
                    }

                    if(values[i].enableCoSection != "Y"){

                        autoSelectedByValue("currencyList-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId, values[i].coLmtCcy);

                        $("#currencyList-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).css({"border-width":"0"});
                        $("#currencyList-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});


                        $("#coLimitAmount-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).css({"border-width":"0"});
                        $("#coLimitAmount-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});



                         $("#coLmtExpiryDate-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});
                    }
                }
                console.log(dataSourceStaticData.data()[0]);
            }
            
            function replacedByIconOfDetails(isRoot, action, partyNo, partyType, lmtTypeCode, bizUnit, dataSourceAppId, bookEntity, novaSubAcctId, crId){

                var recordAccessStr = "";
                
                if(new RegExp("V").test(action)){ 

                    if(partyType == "GROUP"){
                        
                        recordAccessStr += "<a onclick=\"changeDetail('"+crId+"','"+partyNo+"','"+partyType+"','"+bizUnit+"','"+bookEntity+"','"+dataSourceAppId+"','"+novaSubAcctId+"', 'view')\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_view.png\" width=\"20\" height=\"20\"/></a>";
                        
                    }else if(partyType == "LEGAL_PARTY"){
                        
                        recordAccessStr += "<a onclick=\"changeDetail('"+crId+"','"+partyNo+"','"+partyType+"','"+bizUnit+"','"+bookEntity+"','"+dataSourceAppId+"','"+novaSubAcctId+"', 'view')\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_view.png\" width=\"20\" height=\"20\"/></a>";
                        
                    }else if(partyType == "ACCOUNT"){
                        
                        recordAccessStr += "<a onclick=\"changeDetail('"+crId+"','"+partyNo+"','"+partyType+"','"+bizUnit+"','"+bookEntity+"','"+dataSourceAppId+"','"+novaSubAcctId+"', 'view')\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_view.png\" width=\"20\" height=\"20\"/></a>";

                    }else if(partyType == "SUB_ACCOUNT"){
                        
                        recordAccessStr += "<a onclick=\"changeDetail('"+crId+"','"+partyNo+"','"+partyType+"','"+bizUnit+"','"+bookEntity+"','"+dataSourceAppId+"','"+novaSubAcctId+"', 'view')\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_view.png\" width=\"20\" height=\"20\"/></a>";
                    }        

                }
                if(new RegExp("E").test(action)){ 
                    if(partyType == "GROUP"){
                        
                        recordAccessStr += "<a onclick=\"changeDetail('"+crId+"','"+partyNo+"','"+partyType+"','"+bizUnit+"','"+bookEntity+"','"+dataSourceAppId+"','"+novaSubAcctId+"', 'edit')\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_update.png\" width=\"20\" height=\"20\"/></a>";
                        
                    }else if(partyType == "LEGAL_PARTY"){
                        
                        recordAccessStr += "<a onclick=\"changeDetail('"+crId+"','"+partyNo+"','"+partyType+"','"+bizUnit+"','"+bookEntity+"','"+dataSourceAppId+"','"+novaSubAcctId+"', 'edit')\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_update.png\" width=\"20\" height=\"20\"/></a>";
                        
                    }else if(partyType == "ACCOUNT"){
                        
                        recordAccessStr += "<a onclick=\"changeDetail('"+crId+"','"+partyNo+"','"+partyType+"','"+bizUnit+"','"+bookEntity+"','"+dataSourceAppId+"','"+novaSubAcctId+"', 'edit')\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_update.png\" width=\"20\" height=\"20\"/></a>";

                    }else if(partyType == "SUB_ACCOUNT"){
                        
                        recordAccessStr += "<a onclick=\"changeDetail('"+crId+"','"+partyNo+"','"+partyType+"','"+bizUnit+"','"+bookEntity+"','"+dataSourceAppId+"','"+novaSubAcctId+"', 'edit')\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_update.png\" width=\"20\" height=\"20\"/></a>";
                    }        


                }
                if(new RegExp("D").test(action)){ 

                     recordAccessStr += "<a onclick=\"toDeleteRow('"+isRoot+"','"+crId+"','"+partyNo+"','"+bizUnit+"','"+dataSourceAppId+"','"+bookEntity+"','"+partyType+"','"+novaSubAcctId+"', '')\"><img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_discard2.png\" width=\"20\" height=\"20\"/></a>";
                    
                }
                return recordAccessStr;
            }

            function toDeleteRow(isRoot, crId, partyNo, bizUnit, dataSourceAppId, bookEntity, partyType, novaSubAcctId, action){

                console.log("toDelete");
                
                $("#mainContainer").css({"display":"none"});

                var grid = $("#grid").data("kendoGrid");

                grid.setDataSource(dataSourceCapture);

                dataSourceCapture.fetch(function(){
                    
                    var values = dataSourceCapture.data();

                    for (var i = 0 ; i < values.length ; i++) {

                       if(isRoot != "Y" && checkUndefinedElement(values[i].partyType) == checkUndefinedElement(partyType) && checkUndefinedElement(values[i].partyNo) == checkUndefinedElement(partyNo) && checkUndefinedElement(values[i].crId) == checkUndefinedElement(crId) && checkUndefinedElement(values[i].bizUnit) == checkUndefinedElement(bizUnit) && checkUndefinedElement(values[i].bookEntity) == checkUndefinedElement(bookEntity) && checkUndefinedElement(values[i].dataSourceAppId) == checkUndefinedElement(dataSourceAppId) && checkUndefinedElement(values[i].dataSourceAppId) == checkUndefinedElement(dataSourceAppId) && checkUndefinedElement(values[i].novaSubAcctId) == checkUndefinedElement(novaSubAcctId)){

                            if(values[i].isEdit == "N" && values[i].isNew == "Y"){
                                values[i].isNew = null;
                                console.log(" opt 1 ");
                                console.log(values[i]);
                                dataSourceCapture.remove(values[i]);

                            }else{
                                values[i].isDeleted ="Y";
                                console.log(values[i].uid);
                            }
                        }
                    };
                });

                 var values = dataSourceCapture.data();

                 for (var i = 0 ; i < values.length ; i++) {
                    if(values[i].isDeleted == "Y"){
                        console.log(values[i].uid);
                        $("tr[data-uid=" + values[i].uid + "]").css({"display":"none"});
                    }
                 }

                refreshTheGridFields();
            }

            function getLmtCategory(){

                var getLmtCat = "/ermsweb/resources/js/staticData.json";
                var currenceyList = [];
                var addOptions = "";
                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getLmtCat,   
                            cache: false,                       
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            },
                            complete: function(response, status){
                                clearDropDownWithoutBlank("lmtCategory");
                                clearDropDownWithoutBlank("lmtTypeHierLvlId");
                                clearDropDownWithoutBlank("lmtTypeCode");

                                if(status == "success"){

                                    $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {

                                        if(key == "lmtCategoryList"){
                                            $.each(value, function(key, value) {
                                                
                                                var option = document.createElement("option");
                                                option.text = checkUndefinedElement(value.categoryKey);
                                                option.value = checkUndefinedElement(value.categoryKey);
                                                document.getElementById("lmtCategory").appendChild(option);
                                                option = null;

                                                var valueOfCatKey = document.getElementById("lmtCategory");
                                                /*alert(valueOfCatKey.options[valueOfCatKey.selectedIndex].value);*/
                                                if(value.categoryKey == valueOfCatKey.options[valueOfCatKey.selectedIndex].value){

                                                    $.each(value.hierList, function(key, value) {

                                                        var option = document.createElement("option");
                                                        option.text = checkUndefinedElement(value.hierKey);
                                                        option.value = checkUndefinedElement(value.hierKey);
                                                        document.getElementById("lmtTypeHierLvlId").appendChild(option);
                                                        option = null;

                                                        $.each(value.lmtTypeList, function(key, value) {

                                                            var option = document.createElement("option");
                                                            option.text = checkUndefinedElement(value);
                                                            option.value = checkUndefinedElement(key);
                                                            document.getElementById("lmtTypeCode").appendChild(option);
                                                            option = null;                                                            
                                                        });
                                                    });
                                                }
                                           });
                                            
                                            
                                        }
                                    });
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

            function getHierList(){
                var getHier = "/ermsweb/resources/js/staticData.json";
                var currenceyList = [];
                var addOptions = "";
                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getHier,   
                            cache: false,                       
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            },
                            complete: function(response, status){

                                clearDropDownWithoutBlank("lmtTypeHierLvlId");
                                clearDropDownWithoutBlank("lmtTypeCode");

                               if(status == "success"){

                                    $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {

                                        if(key == "lmtCategoryList"){
                                            $.each(value, function(key, value) {
                                                
                                                var valueOfCatKey = document.getElementById("lmtCategory");
                                                /*alert(valueOfCatKey.options[valueOfCatKey.selectedIndex].value);*/
                                                if(value.categoryKey == valueOfCatKey.options[valueOfCatKey.selectedIndex].value){

                                                    $.each(value.hierList, function(key, value) {

                                                        var option = document.createElement("option");
                                                        option.text = checkUndefinedElement(value.hierKey);
                                                        option.value = checkUndefinedElement(value.hierKey);
                                                        document.getElementById("lmtTypeHierLvlId").appendChild(option);
                                                        option = null;

                                                        $.each(value.lmtTypeList, function(key, value) {

                                                            var option = document.createElement("option");
                                                            option.text = checkUndefinedElement(value);
                                                            option.value = checkUndefinedElement(key);
                                                            document.getElementById("lmtTypeCode").appendChild(option);
                                                            option = null;                                                            
                                                        });
                                                    });
                                                }
                                           });
                                        }
                                    });
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

            function getLimitType(){

                var getLimitType = "/ermsweb/resources/js/staticData.json";
                var currenceyList = [];
                var addOptions = "";
                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getLimitType,   
                            cache: false,                       
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            },
                            complete: function(response, status){

                                clearDropDownWithoutBlank("lmtTypeCode");

                               if(status == "success"){

                                    $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {

                                        if(key == "lmtCategoryList"){
                                            $.each(value, function(key, value) {
                                                
                                                var valueOfCatKey = document.getElementById("lmtCategory");

                                                /*alert(valueOfCatKey.options[valueOfCatKey.selectedIndex].value);*/

                                                if(value.categoryKey == valueOfCatKey.options[valueOfCatKey.selectedIndex].value){

                                                    $.each(value.hierList, function(key, value) {
                                                        var valueOfHierKey = document.getElementById("lmtTypeHierLvlId");
                                                        if(value.hierKey == valueOfHierKey.options[valueOfHierKey.selectedIndex].value){
                                                            $.each(value.lmtTypeList, function(key, value) {

                                                                var option = document.createElement("option");
                                                                option.text = checkUndefinedElement(value);
                                                                option.value = checkUndefinedElement(key);
                                                                document.getElementById("lmtTypeCode").appendChild(option);
                                                                option = null;                                                            
                                                            });
                                                        }
                                                    });
                                                }
                                           });
                                        }
                                    });
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

            function onClickNewButton(){

                $("#mainContainer .k-button").css({'color': "black"});

                $("#isdaResultGrid").kendoGrid({
                    dateSource: new kendo.data.DataSource(),
                    columns: [  
                        { 
                            field: "pmeIsdaId", 
                            title: "ISDA ID" ,
                            width: 100
                        },
                        { 
                            field: "pmeIsdaEntity",
                            title: "Entity" ,
                            width: 100
                        },
                        { 
                            field: "isdaPaymentCcy", 
                            title: "Payment Currency" ,
                            width: 100
                        },
                        { 
                            field: "isdaNettingCcy", 
                            title: "Netting Currency" ,
                            width: 100
                        },
                        { 
                            field: "isdaNettingInstrument", 
                            title: "Netting Instrument" ,
                            width: 100
                        }
                    ]
                });
                
                $('#csaResultGrid').kendoGrid({
                    dateSource: new kendo.data.DataSource(),
                    editable: true,
                    columns: [  
                        { 
                            field: "pmeCsaId", 
                            title: "CSA ID" ,
                            width: 100
                        },
                        { 
                            field: "pmeCsaEntity",
                            title: "Entity" ,
                            width: 100
                        },
                        { 
                            field: "csaCollateralCcy", 
                            title: "CSA Collateral Currency" ,
                            width: 100
                        },
                        { 
                            field: "csaBociThreshold", 
                            title: "Threshholde To BOCI" ,
                            width: 100
                        },
                        { 
                            field: "csaCptyThreshold", 
                            title: "Threshholde To Counterparty" ,
                            width: 100
                        },
                        { 
                            field: "bociMta", 
                            title: "CSA MTA to BOCI" ,
                            width: 100
                        },
                        { 
                            field: "csaCptyMta", 
                            title: "CSA MTA to Counterparty" ,
                            width: 100
                        },
                        { 
                            field: "csaBociIndependentAmount", 
                            title: "CSA Independent Amount To BOCI" ,
                            width: 100
                        },
                        { 
                            field: "csaCptyIndependentAmount", 
                            title: "CSA Independent Amount To Counterparty" ,
                            width: 100
                        },
                        { 
                            field: "csaMarginCallFrequency", 
                            title: "CSA Margin Call Frequency" ,
                            width: 100
                        }
                    ]
                });

                removeAllRowsFromGrid("isdaResultGrid");
                removeAllRowsFromGrid("csaResultGrid");

                $("#apprDetailList").css({"display":"none"});

                /*$("#lendingUnit").val($("#lendingUnit option:first").val());
                $("#whlProdList").val($("#whlProdList option:first").val());*/

                $("#isNew").val("Y");                
                $("#isEdit").val("N");                

                $("#lmtTypeCode").val("");
                $("#partyNo").val("");
                $("#partyType").val("");
                $("#crId").val("");
                $("#approvalBizUnit").html(getURLParameters("approvalMatrixBu"));
                $("#bookEntity").val("");
                $("#dataSourceAppId").val("");
                $("#novaSubAcctId").val("");
                autoSelectedByValue("approvalMatrixOption", getURLParameters("approvalMatrixOption"));

                $("#group").prop("disabled", false);
                $("#ccpty").prop("disabled", false);
                $("#account").prop("disabled", false);
                $("#subAccount").prop("disabled", false);
                $("#bizUnitDropDown").prop("disabled", false);
                $("#bizUnitDropDown").css({"background-color":"white"});

                getCurrencyList("newLmtCcy");
                getCurrencyList("pfLoanCcy");

                getCollateralList("collType");
                
                $("#groupCreditRatingInr").html("");
                $("#groupCreditRatingMoody").html("");
                $("#groupCreditRatingSnp").html("");
                $("#groupCreditRatingFitch").html("");
                $("#groupRiskRatingForAppr").html("");
                
                $("#connectedPartyType").html("");
                $("#countryOfDomicile").html("");
                $("#creditRatingInr").html("");
                $("#creditRatingMoody").html("");
                $("#creditRatingSnp").html("");
                $("#creditRatingFitch").html("");
                $("#riskRatingForApproval").html("");
                $("#chargor").val("");
                $("#holdingType").html("");

                $("#facId").html("");

                $("#lmtCategory").html("");                            
                $("#lmtTypeHierLvlId").html("");
                $("#lmtTypeCode").html("");

                $("#facPurpose").val("");
                $("#existLmtCcy").html("");
                $("#existLmtAmt").html("");
                $("#newLmtAmt").val("");
                $("#coLmtCcy").html("");
                $("#coLmtAmt").val("");
                $("#existLmtExpiryDate").html(toDateFormatReverse(""));
                $("#newLmtExpiryDateField").val(toDateFormatReverse(""));
                $("#coLmtExpiryDate").val(toDateFormatReverse(""));

                $("#lmtRiskRating").val("");
                $("#existLeeCcy").html("");
                $("#existLeeAmt").html("");
                $("#lastApprovalDate").html("");
                $("#existCcfLmtAmtCcy").html("");
                $("#existCcfLmtAmt").html("");
                $("#newCcfLmtAmtCcy").html("");
                $("#newCcyLmtAmt").html("");
                $("#coNewCcfLmtCcy").html("");
                $("#coNewCcfLmtAmt").html("");
                $("#lmtTenor").html("");
                $("#month").prop("checked", true);
                $("#isBatchUpload").html("");
                $("#isAnnualLmtReview").html("");
                $("#lmtTenor").val("");
                $("#shlBreachDetail").val("");
                $("#shlBreachHaObtain").val("");

                $("#fdImRatio").val("");
                $("#fdGreyPeriodDay").val("");
                $("#fdIsUfMarginWPdCntlY").prop("checked", true);
                $("#fdIsLoanProvideY").prop("checked", true);
                $("#fdIsDefferralAllowY").prop("checked", true);
                $("#isShlBreachY").prop("checked", true);
                $("#fdOtherControl").val("");

                $("#prlMaxTenorAllow").val("");
                $("#prlHaircutRatio").val("");

                $("#pmeMaxTenorAllow").val("");
                $("#pmeMaxTenorAllowUnit").val("");
                $("#pmeGreyPeriod").val("");
                /*$("#pmeIsdaIdText").val("");
                $("#csaIdText").val("");
*/
                
                $("#whlOtherControl").val("");

                $("#ppProposePrice").val("");
                $("#ppRatioSign").val("");
                $("#ppRatio").val("");
                $("#ppFeeComm").val("");
                $("#ppArrangeHandleFee").val("");
                $("#ppOthers").val("");


                $("#sblrExcessCashRecallBuf").val("");
                $("#sblrMarginCallBuf").val("");
                $("#sblrBorrowImRatio").val("");
                $("#sblrLendImRatio").val("");
                $("#sblrRepoStockMarginRatio").val("");



                /*$("#sblrSblVolatility").html("");
                $("#sblrRepoVolatility").html("");
                */

                $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {
                    if(key == "sblVol" || key == "repoVol"){
                        $("#sblrSblVolatility").html(parseFloat(value)*100);
                        $("#sblrRepoVolatility").html(parseFloat(value)*100);   
                    }
                    
                });


                $("#shareHolderScope").html("");
                initalShareHolderGrid(null);

                $("#lmtApplicationScope").html("");

                $("#ibdMaxTenorAllow").html("");
                $("#ibdMaxTenorAllowUnit").html("");


                initialLimitAllocationGrid(null);
                initalGuarGrid(null);
                getCurrencyList("pfCurrency");

                onLoadSupInfoOfGroupClientGrid(true, "");

                $("#aiLastApproveDate").html("");

                $("#mainContainer").css({"display":"block"});
                document.getElementById("group").checked = true;
                renewGroupInfo($("#groupName").html()); 
                enableRadioTextField(document.getElementById("group"));

                getLmtCategory();
                /*getLendingUnit();*/

                onLoadRemarkAllList({});
                onLoadRemarkCurrUserList({});
                getCurrencyList("guarCollCapCcy");

                $("#idlBuGroupMarketCap").html("");
                $("#idlBuTotApproveAmtHkd").html("");
                $("#idlBuBocRiskRating").html("");
                $("#idlBuExceptApprLmtHkd").html("");
                $("#idlBuIsExceptApprove").html("");

                set_multiple_select_prod(document.getElementById("prProdType"), []);
                set_multiple_select_prod(document.getElementById("dvpProdList"), []);
                set_multiple_select_pme(document.getElementById("pmeExpoType"), []);
                set_multiple_select_prod(document.getElementById("whlProdList"), []);
                set_multiple_select_loan(document.getElementById("pfCurrency"), []);

                
                    $("#newLmtCcy").prop('disabled', false);
                    $("#newLmtCcy").css({'border-width': "1"});
                    $("#newLmtAmt").prop('disabled', false);
                    $("#newLmtAmt").css({'border-width': "1"});
                    $("#newLmtExpiryDateField").prop('disabled', false);
                    $("#newLmtExpiryDateField").kendoDatePicker({
                        format: "yyyy/MM/dd"
                    }); 
                

                    $("#coLmtCcy").prop('disabled', false);
                    $("#coLmtCcy").css({'border-width': "1"});
                    $("#coLmtAmt").prop('disabled', false);
                    $("#coLmtAmt").css({'border-width': "1"});
                    $("#coLmtExpiryDate").prop('disabled', false);
                    $("#coLmtExpiryDate").kendoDatePicker({
                        format: "yyyy/MM/dd"
                    });

                $("#coLmtCcy").text("");
                onChangeCcfRatio($("#lmtTypeCode :selected").val());
                

                // Disable Textboxes //
                var textBoxes = document.querySelectorAll("#mainContainer input[type=text]");
                for (var i = 0; i < textBoxes.length; i++) {
                       $("#"+textBoxes[i].id).prop('disabled', false);
                        $("#"+textBoxes[i].id).css({'border-width': "1"});
                };

                // Disable Radios //
                var radios = document.querySelectorAll("#mainContainer input[type=radio]");
                for (var i = 0; i < radios.length; i++) {
                    if($("#"+radios[i].id).attr('name') != "radioSet")
                        $("#"+radios[i].id).prop('disabled', false);
                        $("#"+radios[i].id).css({'border-width': "1"});
                };

                // Disable selectOpt //
                var selectOptions = document.querySelectorAll("#mainContainer select");
                for (var i = 0; i < selectOptions.length; i++) {
                    if($("#"+selectOptions[i].id).css("background-color") != "#ccc"){
                        if(selectOptions[i].id != "bizUnitDropDown" && selectOptions[i].id != "ccptyRadioText" && selectOptions[i].id != "accountRadioText" &&selectOptions[i].id != "subAccountRadioText" ){
                            $("#"+selectOptions[i].id).prop('disabled', false);
                            $("#"+selectOptions[i].id).css({'background-color':"white"});
                            $("#"+selectOptions[i].id).css({'border-width': "1"});
                        }
                    }
                };

                // Disable file //
                var files = document.querySelectorAll("#mainContainer input[type=file]");
                for (var i = 0; i < files.length; i++) {
                       $("#"+files[i].id).prop('disabled', false);
                };

                $("#mainContainer .k-button").prop('disabled', false);

                var all = document.querySelectorAll("#mainContainer input");
                for (var i = 0; i < files.length; i++) {
                       $("#"+files[i].id).css({'border-width': "1"});
                };

            
                $("#newLmtCcy").prop('disabled', false);
                $("#newLmtCcy").css({'border-width': "1"});
                $("#newLmtAmt").prop('disabled', false);
                $("#newLmtAmt").css({'border-width': "1"});
                $("#newLmtExpiryDateField").prop('disabled', false);
                $("#newLmtExpiryDateField").kendoDatePicker({
                    format: "yyyy/MM/dd"
                }); 
            

            
                 $("#coLmtCcy").prop('disabled', true);
                $("#coLmtCcy").css({'border-width': "0"});
                $("#coLmtAmt").prop('disabled', true);
                $("#coLmtAmt").css({'border-width': "0"});
                $("#coLmtExpiryDate").prop('disabled', true);
                $("#coLmtExpiryDate").kendoDatePicker({});


                $("#approvalMatrixOption").prop("disabled", "disabled");
                $("#approvalMatrixOption").css({"background-color":"#ccc"});
                
                /*onChangeLimitType($("#lmtTypeCode").val());*/
                var values = dataSourceCapture.data();

                if(values.length != 0){
                    for (var i = 1; i < 2; i++) {
                        initialDocList(values[i].docMapList);
                        onLoadRemarkAllList(values[i].remarkAllList);
                        onLoadRemarkCurrUserList(values[i].remarkCurrUserList);
                        $("#riBrRoleDesc").val(values[i].riBrRoleDesc);
                        $("#riBrName").val(values[i].riBrName);
                        $("#riBrEmailAddr").val(values[i].riBrEmailAddr);
                        $("#riBrReviewDate").val(toDateFormatReverse(values[i].riBrReviewDate));
                        $("#riBcRoleDesc").val(values[i].riBcRoleDesc);
                        $("#riBcName").val(values[i].riBcName);
                        $("#riBcEmailAddr").val(values[i].riBcEmailAddr);
                        $("#riBcReviewDate").val(toDateFormatReverse(values[i].riBcReviewDate));
                        $("#riBaRoleDesc").val(values[i].riBaRoleDesc);
                        $("#riBaName").val(values[i].riBaName);
                        $("#riBaEmailAddr").val(values[i].riBaEmailAddr);
                        $("#riBaReviewDate").val(toDateFormatReverse(values[i].riBaReviewDate));
                        $("#riMakerRoleDesc").html(values[i].riMakerRoleDesc);
                        $("#riMakerName").html(values[i].riMakerName);
                        $("#riMakerReviewDate").html(toDateFormatReverse(values[i].riMakerReviewDate));
                        $("#riCheckerRoleDesc").html(values[i].riCheckerRoleDesc);
                        $("#riCheckerName").html(values[i].riCheckerName);
                        $("#riCheckerReviewDate").html(toDateFormatReverse(values[i].riCheckerReviewDate));
                        $("#riEndorserRoleDesc").html(values[i].riEndorserRoleDesc);
                        $("#riEndorserName").html(values[i].riEndorserName);
                        $("#riEndorserReviewDate").html(toDateFormatReverse(values[i].riEndorserReviewDate));
                        $("#riApproverRoleDesc").html(values[i].riApproverRoleDesc);
                        $("#riApproverName").html(values[i].riApproverName);
                        $("#riApproverReviewDate").html(toDateFormatReverse(values[i].riApproverReviewDate));
                        $("#riCaCheckerRoleDesc").html(values[i].riCaCheckerRoleDesc);
                        $("#riCaCheckerName").html(values[i].riCaCheckerName);
                        $("#riCaCheckerReviewDate").html(toDateFormatReverse(values[i].riCaCheckerReviewDate));
                        $("#riCalApproverLevel").html(values[i].riCalApproverLevel);
                        onLoadSupInfoOfGroupClientGrid(false, values[i].suppInfoForIDLList);
                        $("#idlBuGroupMarketCap").html(values[i].idlBuGroupMarketCap);
                        $("#idlBuTotApproveAmtHkd").html(values[i].idlBuTotApproveAmtHkd);
                        $("#idlBuBocRiskRating").html(values[i].idlBuBocRiskRating);
                        $("#idlBuExceptApprLmtHkd").html(values[i].idlBuExceptApprLmtHkd);
                        $("#idlBuIsExceptApprove").html(values[i].idlBuIsExceptApprove);
                        if(values[i].idlBuIsExceptApprove == "Y"){
                            
                            $("#idlBuIsExceptApproveY").prop("checked", true);
                            $("#idlBuIsExceptApproveN").prop("checked", false);
                        }else{
                            $("#idlBuIsExceptApproveY").prop("checked", false);
                            $("#idlBuIsExceptApproveN").prop("checked", true);
                        }

                        $("#aiLastApproveDate").html(toDateFormatReverse(values[i].aiLastApproveDate));
                        autoSelectedByValue("overrideApprList", values[i].aiOverrideApproveLvl);
                        onLoadApprDetailsGrid();
                        addToApprDetail(values[i].apprDetailList);
                        if(values[i].enableOverrideApprFlag == "Y"){
                            $("#overrideApprList").prop("disabled", false);
                            $("#overrideApprList").css({"background-color":"white"});
                        }else{
                            $("#overrideApprList").prop("disabled", true);
                            $("#overrideApprList").css({"background-color":"#ccc"});
                        }

                        if(values[i].enableApprovalSection == "Y"){
                            $("#apprDetailList").css({"display" : "block"});
                        }else{
                            $("#apprDetailList").css({"display" : "none"});
                        }

                    }
                }
            }

            function changeDetail(crId, partyNo, partyType, bizUnit, bookEntity, dataSourceAppId, novaSubAcctId, action){

                $("#isNew").val("N");
                $("#isEdit").val("Y");
                $("#apprDetailList").css({"display":"block"});


                $("#underlyingStkCode").val("");
                $("#underlyingStkMktCode").val("");
                $("#shareHolderRole").val("");
                $("#shlTotQtyHeldInMrkt").val("");


                console.log(action);
                
                var displayedData = $("#grid").data().kendoGrid.dataSource.view().toJSON();
               /* var getDetailURL =window.sessionStorage.getItem('serverPath')+"limitapplication/getLimitAppDetailList?userId=RISKADMIN&rmdGroupId=PP_GROUP1&approvalMatrixBu=PB&approvalMatrixOption=LEE";*/

                $.each(displayedData, function(key, value) {

                    if(value.isRoot != "Y" && checkUndefinedElement(value.partyType) == checkUndefinedElement(partyType) && checkUndefinedElement(value.partyNo) == checkUndefinedElement(partyNo) && checkUndefinedElement(value.crId) == checkUndefinedElement(crId) && checkUndefinedElement(value.bizUnit) == checkUndefinedElement(bizUnit) && checkUndefinedElement(value.bookEntity) == checkUndefinedElement(bookEntity) && checkUndefinedElement(value.dataSourceAppId) == checkUndefinedElement(dataSourceAppId)  && checkUndefinedElement(value.novaSubAcctId) == checkUndefinedElement(novaSubAcctId)){
                            
                            autoSelectedByValue("currencyList_new_"+partyNo+"_"+partyType, $("#newLmtCcy :selected").val());

                            if(value.enableOverrideApprFlag != "Y"){
                                $("#overrideApprList").prop("disabled", true);
                            }else{
                                $("#overrideApprList").prop("disabled", false);
                            }

                            $("#partyNo").val(partyNo);
                            $("#partyType").val(partyType);
                            $("#crId").val(crId);
                            $("#bizUnit").val(bizUnit);
                            $("#bookEntity").val(bookEntity);
                            $("#dataSourceAppId").val(dataSourceAppId);
                            $("#novaSubAcctId").val(novaSubAcctId);

                            /*removeAllRowsFromGrid("guarantorGrid");
                            removeAllRowsFromGrid("Shareholder Role");*/
                            /*$('#remarkAllList').kendoGrid({
                                                    dataSource : new kendo.data.DataSource(),
                                                    cache: false,
                                                    editable: true,
                                                    columns: [  
                                                        { 
                                                            field: "createDt", 
                                                            title: "Create Date" ,
                                                            width: 100,
                                                            template: "#=toDateTimeFormatReverse(createDt)#"
                                                        },
                                                        { 
                                                            field: "createBy",
                                                            title: "Create By" ,
                                                            width: 100
                                                        },
                                                        { 
                                                            field: "remarkCat", 
                                                            title: "Remark Cat." ,
                                                            width: 100
                                                        },
                                                        { 
                                                            field: "remark", 
                                                            title: "Remarks" ,
                                                            width: 100
                                                        }
                                                    ]
                                                });
                             $('#remarkCurrUserList').kendoGrid({
                                                dataSource : new kendo.data.DataSource(),
                                                cache: false,
                                                editable: true,
                                                columns: [  
                                                    { 
                                                        field: "createDt", 
                                                        title: "Create Date" ,
                                                        width: 100,
                                                        template: "#=toDateTimeFormatReverse(createDt)#"
                                                    },
                                                    { 
                                                        field: "createBy",
                                                        title: "Create By" ,
                                                        width: 100
                                                    },
                                                    { 
                                                        field: "remarkCat", 
                                                        title: "Remark Cat." ,
                                                        width: 100
                                                    },
                                                    { 
                                                        field: "remark", 
                                                        title: "Remarks" ,
                                                        width: 100
                                                    }
                                                ]
                                            });*/

                            $("#guarantorGridScope").html("");
                            $("#shareHolderScope").html("");
                            $("#lmtApplicationScope").html("");

                            $("#guarantorGridScope").html("<div id=\"guarantorGrid\"></div>");
                            $('#guarantorGrid').kendoGrid({
                            
                                dataSource: new kendo.data.DataSource(),
                                cache: false,
                                editable: true,
                                columns: [  
                                    { 
                                        field: "guarId", 
                                        title: "Guarantor ID" ,
                                        width: 100
                                    },
                                    { 
                                        field: "guarName",
                                        title: "Guarantor Name" ,
                                        width: 100
                                    },
                                    { 
                                        field: "guarDomicile", 
                                        title: "Guarantor Domicile" ,
                                        width: 100
                                    },{ 
                                        field: "guarAddress", 
                                        title: "Guarantor Address" ,
                                        width: 100
                                    },{ 
                                        field: "relWBorrower", 
                                        title: "Relation with Borrower" ,
                                        width: 100
                                    },{ 
                                        field: "suppType", 
                                        title: "Support Type" ,
                                        width: 100
                                    },{ 
                                        field: "amtType", 
                                        title: "Limited / Unlimited Amount" ,
                                        width: 100
                                    },{ 
                                        field: "guarCollCapCcy", 
                                        title: "Guarantee / Collateral Amount Currency." ,
                                        width: 100
                                    },{ 
                                        field: "guarCollCapAmt", 
                                        title: "Guarantee / Collateral Amount Cap" ,
                                        width: 100
                                    },{ 
                                        field: "guarExpiryDate", 
                                        title: "Guarantor Expiry Date(yyyy/mm/dd)" ,
                                        width: 100,
                                        template: "#=toDateFormatReverse(zeroToEmpty(guarExpiryDate))#"
                                    },{ 
                                        field: "noticePeriod", 
                                        title: "Notice Period (Days)" ,
                                        width: 100
                                    },
                                    { 
                                        command: "destroy", 
                                        width: "150px"
                                    }
                                ]
                            });
                            $("#shareHolderScope").html("<div id=\"shareHolderGrid\"></div>");
                            $('#shareHolderGrid').kendoGrid({
                            
                                dataSource: new kendo.data.DataSource(),
                                cache: false,
                                editable: true,
                                columns: [  
                                    { 
                                        field: "shlUlyStockCode", 
                                        title: "Underlying Stock Code" ,
                                        width: 100
                                    },
                                    { 
                                        field: "shlUlyStockMarketCode",
                                        title: "Underlying Stock Market Code" ,
                                        width: 100
                                    },
                                    { 
                                        field: "shlShareholderRole", 
                                        title: "Shareholder Role" ,
                                        width: 100
                                    },
                                    { 
                                        field: "shlTotQtyHeldInMrkt", 
                                        title: "Total Quantity" ,
                                        width: 100
                                    },
                                    { 
                                        command: "destroy", 
                                        width: "150px"
                                    }
                                ]
                            });
                            $("#lmtApplicationScope").html("<div id=\"lmtApplicationGrid\"></div>");

                            $('#lmtApplicationGrid').kendoGrid({
                            
                                dataSource: new kendo.data.DataSource(),
                                cache: false,
                                editable: true,
                                columns: [  
                                    { 
                                        field: "lspEntityId", 
                                        title: "Entity" ,
                                        width: 100
                                    },
                                    { 
                                        field: "lspAllocateRatio",
                                        title: "Allocation Percentage (%)" ,
                                        width: 100
                                    },
                                    { 
                                        command: "destroy", 
                                        width: "150px"
                                    }
                                ]
                            });

                            $("#fileDescription").val("");

                            $("#action").val(action);
                            $("#pfLoanAmt").val(value.pfLoanAmt);

                            $("#group").prop("disabled", true);
                            $("#ccpty").prop("disabled", true);
                            $("#account").prop("disabled", true);
                            $("#subAccount").prop("disabled", true);
                            $("#bizUnitDropDown").prop("disabled", true);
                            $("#bizUnitDropDown").css({"background-color":"#ccc"});

                            $("#bizUnit").html(value.bizUnit);
                            $("#approvalBizUnit").html(getURLParameters("approvalMatrixBu"));
                            autoSelectedByValue("approvalMatrixOption", value.approvalMatrixOption);

                            $("#groupCreditRatingInr").html(value.groupCreditRatingInr);
                            $("#groupCreditRatingMoody").html(value.groupCreditRatingMoody);
                            $("#groupCreditRatingSnp").html(value.groupCreditRatingSnp);
                            $("#groupCreditRatingFitch").html(value.groupCreditRatingFitch);
                            $("#groupRiskRatingForAppr").html(value.groupRiskRatingForAppr);
                            autoSelectedByValue("bizUnitDropDown", value.bizUnit);
                            $("#groupName").html(value.groupName);

                            $("#connectedPartyType").html(value.connectedPartyType);
                            $("#countryOfDomicile").html(value.countryOfDomicile);
                            $("#creditRatingInr").html(value.creditRatingInr);
                            $("#creditRatingMoody").html(value.creditRatingMoody);
                            $("#creditRatingSnp").html(value.creditRatingSnp);
                            $("#creditRatingFitch").html(value.creditRatingFitch);
                            $("#riskRatingForApproval").html(value.riskRatingForApproval);
                            $("#chargor").val(value.chargor);
                            $("#holdingType").html(value.holdingType);

                            $("#facId").html(value.facId);

                            getLmtCategory();                        
                            autoSelectedByValue("lmtCategory", value.lmtCategory);      
                            getHierList();                
                            autoSelectedByValue("lmtTypeHierLvlId", value.lmtTypeHierLvlId);
                            /*getLimitType();*/
                            autoSelectedByValue("lmtTypeCode", value.lmtTypeCode);
                            onChangeCcfRatio($("#lmtTypeCode :selected").val());
                            onChangeLimitType(document.getElementById("lmtTypeCode"));
                            
                            $("#facPurpose").val(value.facPurpose);
                            $("#existLmtCcy").html(value.existLmtCcy);
                            $("#existLmtAmt").html(value.existLmtAmt);
                            $("#dslOtherProdTypeDesc").val(value.dslOtherProdTypeDesc);

                            /*$("#newLmtCcy").val(value.newLmtCcy);*/
                            getCurrencyList("newLmtCcy");
                            autoSelectedByValue("newLmtCcy", value.newLmtCcy);

                            $("#newLmtAmt").val(value.newLmtAmt);
                            $("#coLmtCcy").html(value.coLmtCcy);
                            $("#coLmtAmt").val(value.coLmtAmt);
                            $("#existLmtExpiryDate").html(toDateFormatReverse(value.existLmtExpiryDate));
                            $("#newLmtExpiryDateField").val(toDateFormatReverse(value.newLmtExpiryDate));
                            $("#coLmtExpiryDate").val(toDateFormatReverse(value.coLmtExpiryDate));
                            $("#ccfRatio").html(parseFloat(value.ccfRatio)*100);
                            $("#lmtRiskRating").val(value.lmtRiskRating);
                            $("#existLeeCcy").html(value.existLeeCcy);
                            $("#existLeeAmt").html(value.existLeeAmt);
                            $("#lastApprovalDate").html(toDateFormat(value.lastApprovalDate));
                            $("#existCcfLmtAmtCcy").html(value.existCcfLmtAmtCcy);
                            $("#existCcfLmtAmt").html(value.existCcfLmtAmt);
                            $("#newCcfLmtAmtCcy").html(value.newCcfLmtAmtCcy);
                            $("#newCcyLmtAmt").html(value.newCcyLmtAmt);
                            $("#coNewCcfLmtCcy").html(value.coNewCcfLmtCcy);
                            $("#coNewCcfLmtAmt").html(value.coNewCcfLmtAmt);

                            /*$("#collType").html(value.collType);*/
                            getCollateralList("collType");
                            autoSelectedByValue("collType", value.collType);


                            $("#lmtTenor").html(value.lmtTenor);
                            $("#lmtTenorUnit").html(value.lmtTenorUnit);
                            $("#isBatchUpload").html(value.isBatchUpload);
                            $("#isAnnualLmtReview").html(value.isAnnualLmtReview);

                            $("#isShlBreach").val(value.isShlBreach);
                            $("#shlBreachDetail").val(value.shlBreachDetail);
                            $("#shlBreachHaObtain").val(value.shlBreachHaObtain);

                            $("#lmtTenor").val(value.lmtTenor);

                            if(value.lmtTenorUnit == "year"){
                                $("#year").prop("checked", true);
                                $("#month").prop("checked", false);
                            }else{
                                $("#year").prop("checked", false);
                                $("#month").prop("checked", true);
                            }

                            if(value.isShlBreach == "Y"){
                                $("#isShlBreachY").prop("checked", true);
                                $("#isShlBreachN").prop("checked", false);
                            }else{
                                $("#isShlBreachY").prop("checked", false);
                                $("#isShlBreachN").prop("checked", true);
                            }

                            getCurrencyList("pfLoanCcy");
                            autoSelectedByValue("pfLoanCcy", value.pfLoanCcy);

                            /*autoSelectedByValue("lendingUnit", value.lendingUnitList);*/


                            /*initalShareHolderGrid();*/

                             $("#shareHolderScope").html("");

                            if(checkUndefinedElement(value.shlMapList) != "" && value.shlMapList != null){  
                                initalShareHolderGrid(value.shlMapList);
                            }else{
                                initalShareHolderGrid(null);
                            }

                            $("#fdImRatio").val(value.fdImRatio);
                            $("#fdGreyPeriodDay").val(value.fdGreyPeriodDay);
                            $("#fdOtherControl").val(value.fdOtherControl);
                            $("#pmeMaxTenorAllow").val(value.pmeMaxTenorAllow);
                            $("#pmeMaxTenorAllowUnit").val(value.pmeMaxTenorAllowUnit);
                            $("#pmeGreyPeriod").val(value.pmeGreyPeriod);
                            /*$("#pmeIsdaIdText").val(value.pmeIsdaId);*/
                            $("#pmeOtherExpoType").val(value.pmeOtherExpoType);
                            /*$("#csaIdText").val(value.pmeCsaId);*/


                            if(value.pmeMaxTenorAllowUnit == "year"){
                                $("#pmeMaxTenorAllowUnitYear").prop("checked", true);
                                $("#pmeMaxTenorAllowUnitMonth").prop("checked", false);
                            }else{
                                $("#pmeMaxTenorAllowUnitYear").prop("checked", false);
                                $("#pmeMaxTenorAllowUnitMonth").prop("checked", true);
                            }

                            if(value.fdIsUfMarginWPdCntl == "Y"){
                                $("#fdIsUfMarginWPdCntlY").prop("checked", true);
                                $("#fdIsUfMarginWPdCntlN").prop("checked", false);
                            }else{
                                $("#fdIsUfMarginWPdCntlY").prop("checked", false);
                                $("#fdIsUfMarginWPdCntlN").prop("checked", true);
                            }

                            if(value.fdIsLoanProvide == "Y"){
                                $("#fdIsLoanProvideY").prop("checked", true);
                                $("#fdIsLoanProvideN").prop("checked", false);
                            }else{
                                $("#fdIsLoanProvideY").prop("checked", false);
                                $("#fdIsLoanProvideN").prop("checked", true);
                            } 

                            if(value.fdIsDefferralAllow == "Y"){
                                $("#fdIsDefferralAllowY").prop("checked", true);
                                $("#fdIsDefferralAllowN").prop("checked", false);
                            }else{
                                $("#fdIsDefferralAllowY").prop("checked", false);
                                $("#fdIsDefferralAllowN").prop("checked", true);
                            }

                            $("#prlMaxTenorAllow").val(value.prlMaxTenorAllow);

                            if(value.prlMaxTenorAllowUnit == "year"){
                                $("#prlMaxTenorAllowUnitYear").prop("checked", true);
                                $("#prlMaxTenorAllowUnitMonth").prop("checked", false);
                            }else{
                                $("#prlMaxTenorAllowUnitYear").prop("checked", false);
                                $("#prlMaxTenorAllowUnitMonth").prop("checked", true);
                            }

                            $("#prlHaircutRatio").val(value.prlHaircutRatio);

                            $("#mainContainer").css({"display" : "block"});

                            $("#whlOtherControl").val(value.whlOtherControl);


                            autoSelectedByValue("ppProposePrice", value.ppProposePrice);
                            autoSelectedByValue("ppRatioSign", value.ppRatioSign);

                            $("#ppRatio").val(value.ppRatio);
                            $("#ppFeeComm").val(value.ppFeeComm);
                            $("#ppArrangeHandleFee").val(value.ppArrangeHandleFee);
                            $("#ppOthers").val(value.ppOthers);
                            $("#ppOthers").val(value.ppOthers);

                            if(checkUndefinedElement(value.spRatioList) != "" && value.spRatioList != null){  
                                initialLimitAllocationGrid(value.spRatioList);
                            }

                            $("#sblrExcessCashRecallBuf").val(value.sblrExcessCashRecallBuf);
                            $("#sblrMarginCallBuf").val(value.sblrMarginCallBuf);
                            $("#sblrBorrowImRatio").val(value.sblrBorrowImRatio);
                            $("#sblrLendImRatio").val(value.sblrLendImRatio);
                            $("#sblrRepoStockMarginRatio").val(value.sblrRepoStockMarginRatio);



                            $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {
                                if(key == "sblVol" || key == "repoVol"){
                                    $("#sblrSblVolatility").html(parseFloat(value)*100);
                                    $("#sblrRepoVolatility").html(parseFloat(value)*100);   
                                }
                                
                            });



                            $("#ibdMaxTenorAllow").val(value.ibdMaxTenorAllow);
                            
                            if(value.ibdMaxTenorAllowUnit == "year"){
                                $("#ibdMaxTenorAllowUnitYear").prop("checked", true);
                                $("#ibdMaxTenorAllowUnitMonth").prop("checked", false);
                            }else{
                                $("#ibdMaxTenorAllowUnitYear").prop("checked", false);
                                $("#ibdMaxTenorAllowUnitMonth").prop("checked", true);
                            }

                            getCurrencyList("guarCollCapCcy");
                            if(value.guarMapList != null && value.guarMapList != ""){
                                initalGuarGrid(value.guarMapList);    
                            }

                            onLoadRemarkAllList(value.remarkAllList);
                            onLoadRemarkCurrUserList(value.remarkCurrUserList);

                            $("#riBrRoleDesc").val(value.riBrRoleDesc);
                            $("#riBrName").val(value.riBrName);
                            $("#riBrEmailAddr").val(value.riBrEmailAddr);
                            $("#riBrReviewDate").val(toDateFormatReverse(value.riBrReviewDate));
                            $("#riBcRoleDesc").val(value.riBcRoleDesc);
                            $("#riBcName").val(value.riBcName);
                            $("#riBcEmailAddr").val(value.riBcEmailAddr);
                            $("#riBcReviewDate").val(toDateFormatReverse(value.riBcReviewDate));
                            $("#riBaRoleDesc").val(value.riBaRoleDesc);
                            $("#riBaName").val(value.riBaName);
                            $("#riBaEmailAddr").val(value.riBaEmailAddr);
                            $("#riBaReviewDate").val(toDateFormatReverse(value.riBaReviewDate));
                            $("#riMakerRoleDesc").html(value.riMakerRoleDesc);
                            $("#riMakerName").html(value.riMakerName);
                            $("#riMakerReviewDate").html(toDateFormatReverse(value.riMakerReviewDate));
                            $("#riCheckerRoleDesc").html(value.riCheckerRoleDesc);
                            $("#riCheckerName").html(value.riCheckerName);
                            $("#riCheckerReviewDate").html(toDateFormatReverse(value.riCheckerReviewDate));
                            $("#riEndorserRoleDesc").html(value.riEndorserRoleDesc);
                            $("#riEndorserName").html(value.riEndorserName);
                            $("#riEndorserReviewDate").html(toDateFormatReverse(value.riEndorserReviewDate));
                            $("#riApproverRoleDesc").html(value.riApproverRoleDesc);
                            $("#riApproverName").html(value.riApproverName);
                            $("#riApproverReviewDate").html(toDateFormatReverse(value.riApproverReviewDate));
                            $("#riCaCheckerRoleDesc").html(value.riCaCheckerRoleDesc);
                            $("#riCaCheckerName").html(value.riCaCheckerName);
                            $("#riCaCheckerReviewDate").html(toDateFormatReverse(value.riCaCheckerReviewDate));
                            $("#riCalApproverLevel").html(value.riCalApproverLevel);

                            onLoadSupInfoOfGroupClientGrid(false, value.suppInfoForIDLList);

                            $("#idlBuGroupMarketCap").html(value.idlBuGroupMarketCap);
                            $("#idlBuTotApproveAmtHkd").html(value.idlBuTotApproveAmtHkd);
                            $("#idlBuBocRiskRating").html(value.idlBuBocRiskRating);
                            $("#idlBuExceptApprLmtHkd").html(value.idlBuExceptApprLmtHkd);
                            $("#idlBuIsExceptApprove").html(value.idlBuIsExceptApprove);

                            if(value.idlBuIsExceptApprove == "Y"){
                                
                                $("#idlBuIsExceptApproveY").prop("checked", true);
                                $("#idlBuIsExceptApproveN").prop("checked", false);
                            }else{
                                $("#idlBuIsExceptApproveY").prop("checked", false);
                                $("#idlBuIsExceptApproveN").prop("checked", true);
                            }
                            
                            $("#aiLastApproveDate").html(toDateFormatReverse(value.aiLastApproveDate));

                            autoSelectedByValue("overrideApprList", value.aiOverrideApproveLvl);

                            onLoadApprDetailsGrid();
                            addToApprDetail(value.apprDetailList);

                            if(value.enableOverrideApprFlag == "Y"){
                                $("#overrideApprList").prop("disabled", false);
                                $("#overrideApprList").css({"background-color":"white"});
                            }else{
                                $("#overrideApprList").prop("disabled", true);
                                $("#overrideApprList").css({"background-color":"#ccc"});
                            }

                            if(value.enableApprovalSection == "Y"){
                                $("#apprDetailList").css({"display" : "block"});
                            }else{
                                $("#apprDetailList").css({"display" : "none"});
                            }


                            set_multiple_select_prod(document.getElementById("prProdType"), value.prProdList);
                            set_multiple_select_prod(document.getElementById("dvpProdList"), value.dvpProdList);
                            set_multiple_select_pme(document.getElementById("pmeExpoType"), value.pmeExpoTypeList);
                            set_multiple_select_prod(document.getElementById("whlProdList"), value.whlProdList);
                            set_multiple_select_loan(document.getElementById("pfCurrency"), value.premFinLoanCcyList);
                            set_multiple_select_lend(document.getElementById("lendingUnit"), value.lendingUnitList);

                            if(value.partyType == "GROUP"){

                                document.getElementById("group").checked = true;
                                renewGroupInfo($("#groupName").html());

                                clearDropDownWithoutBlank("ccptyRadioText");
                                clearDropDownWithoutBlank("accountRadioText");
                                clearDropDownWithoutBlank("subAccountRadioText");

                            }else if(value.partyType == "LEGAL_PARTY"){

                                document.getElementById("ccpty").checked = true;
                                renewGroupInfo($("#groupName").html());
                                enableRadioTextField(document.getElementById("ccpty"));
                                $("#ccptyRadioText").prop('disabled', true);    
                                $("#ccptyRadioText").css({'background-color': '#ccc'});
                                autoSelectedByValue("ccptyRadioText", value.partyNo);
                                clearDropDownWithoutBlank("accountRadioText");
                                clearDropDownWithoutBlank("subAccountRadioText");

                            }else if(value.partyType == "ACCOUNT"){

                                document.getElementById("account").checked = true;
                                enableRadioTextField(document.getElementById("account"));
                                renewGroupInfo($("#groupName").html());
                                $("#accountRadioText").prop('disabled', true);    
                                $("#accountRadioText").css({'background-color': '#ccc'});
                                autoSelectedByValue("accountRadioText", value.partyNo);
                                clearDropDownWithoutBlank("ccptyRadioText");
                                clearDropDownWithoutBlank("subAccountRadioText");

                            }else if(value.partyType == "SUB_ACCOUNT"){

                                document.getElementById("subAccount").checked = true;
                                enableRadioTextField(document.getElementById("subAccount"));
                                renewGroupInfo($("#groupName").html());
                                $("#subAccountRadioText").prop('disabled', true);    
                                $("#subAccountRadioText").css({'background-color': '#ccc'});
                                autoSelectedByValue("subAccountRadioText", value.partyNo);
                                clearDropDownWithoutBlank("accountRadioText");
                                clearDropDownWithoutBlank("ccptyRadioText");
                            }

                            initialDocList(value.docMapList);


                            removeAllRowsFromGrid("isdaResultGrid");
                            removeAllRowsFromGrid("csaResultGrid");

                            var grid = $("#isdaResultGrid").data("kendoGrid");

                            grid.dataSource.add(
                                {
                                    pmeIsdaId : value.pmeIsdaId,
                                    pmeIsdaEntity : value.pmeIsdaEntity,
                                    isdaPaymentCcy : value.pmeIsdaPaymentCcy,
                                    isdaNettingCcy : value.pmeIsdaNettingCcy,
                                    isdaNettingInstrument : value.pmeIsdaNettingInstrument
                                }
                            );

                            grid = $("#csaResultGrid").data("kendoGrid");

                            grid.dataSource.add(
                                {
                                    pmeCsaId : value.pmeCsaId,
                                    pmeCsaEntity : value.pmeCsaEntity,
                                    csaCollateralCcy : value.pmeCsaCollateralCcy,
                                    csaBociThreshold : value.pmeCsaBociThreshold,
                                    csaCptyThreshold : value.pmeCsaCptyThreshold,
                                    bociMta : value.pmeBociMta,
                                    csaCptyMta : value.pmeCsaCptyMta,
                                    csaBociIndependentAmount : value.pmeCsaBociIndependentAmount,
                                    csaCptyIndependentAmount : value.pmeCsaCptyIndependentAmount,
                                    csaMarginCallFrequency : value.pmeCsaMarginCallFrequency
                                }
                            );





                        if(action == "view"){

                            // Disable Textboxes //
                            var textBoxes = document.querySelectorAll("#mainContainer input[type=text]");
                            for (var i = 0; i < textBoxes.length; i++) {
                                   $("#"+textBoxes[i].id).prop('disabled', true);
                                   $("#"+textBoxes[i].id).css({'border-width': "0"});
                            };

                            // Disable Radios //
                            var radios = document.querySelectorAll("#mainContainer input[type=radio]");
                            for (var i = 0; i < radios.length; i++) {
                                $("#"+radios[i].id).prop('disabled', true);
                            };

                            // Disable selectOpt //
                            var selectOptions = document.querySelectorAll("#mainContainer select");
                            for (var i = 0; i < selectOptions.length; i++) {
                                $("#"+selectOptions[i].id).prop('disabled', true);
                                $("#"+selectOptions[i].id).css({'border-width': "0"});
                            };

                            // Disable file //
                            var files = document.querySelectorAll("#mainContainer input[type=file]");
                            for (var i = 0; i < files.length; i++) {
                                   $("#"+files[i].id).prop('disabled', true);
                                   $("#"+files[i].id).css({'border-width': "0"});
                            };

                            $("#mainContainer .k-button").prop('disabled', true);
                            $("#mainContainer .k-button").css({'color': "#ccc"});

                            var all = document.querySelectorAll("#mainContainer input");
                            for (var i = 0; i < files.length; i++) {
                                   $("#"+files[i].id).css({'border-width': "0"});
                            };

                            $("#newLmtExpiryDateField").kendoDatePicker({}); 
                            $("#coLmtExpiryDate").kendoDatePicker({});
                            $("#riBrReviewDate").kendoDatePicker({});
                            $("#riBcReviewDate").kendoDatePicker({});
                            $("#riBaReviewDate").kendoDatePicker({});

                        }else if(action == "edit"){

                            if(value.enableEditLimitInfo == "Y" || value.enableEditLimitInfo == null){
                                // Disable Textboxes //
                                var textBoxes = document.querySelectorAll("#mainContainer input[type=text]");
                                for (var i = 0; i < textBoxes.length; i++) {
                                       $("#"+textBoxes[i].id).prop('disabled', false);
                                        $("#"+textBoxes[i].id).css({'border-width': "1"});
                                };

                                // Disable Radios //
                                var radios = document.querySelectorAll("#mainContainer input[type=radio]");
                                for (var i = 0; i < radios.length; i++) {
                                    if($("#"+radios[i].id).attr('name') != "radioSet")
                                        $("#"+radios[i].id).prop('disabled', false);
                                        $("#"+radios[i].id).css({'border-width': "1"});
                                };

                                // Disable selectOpt //
                                var selectOptions = document.querySelectorAll("#mainContainer select");
                                for (var i = 0; i < selectOptions.length; i++) {
                                    if($("#"+selectOptions[i].id).css("background-color") != "#ccc"){
                                        if(selectOptions[i].id != "bizUnitDropDown" && selectOptions[i].id != "ccptyRadioText" && selectOptions[i].id != "accountRadioText" &&selectOptions[i].id != "subAccountRadioText" ){
                                            $("#"+selectOptions[i].id).prop('disabled', false);
                                            $("#"+selectOptions[i].id).css({'background-color':"white"});
                                            $("#"+selectOptions[i].id).css({'border-width': "1"});
                                        }
                                    }
                                };

                                // Disable file //
                                var files = document.querySelectorAll("#mainContainer input[type=file]");
                                for (var i = 0; i < files.length; i++) {
                                       $("#"+files[i].id).prop('disabled', false);
                                };

                                $("#mainContainer .k-button").prop('disabled', false);
                                $("#mainContainer .k-button").css({'color': "black"});

                                var all = document.querySelectorAll("#mainContainer input");
                                for (var i = 0; i < files.length; i++) {
                                       $("#"+files[i].id).css({'border-width': "1"});
                                };

                                if(value.enableNewSection != "Y"){
                                    $("#newLmtCcy").prop('disabled', true);
                                    $("#newLmtCcy").css({'border-width': "0"});
                                    $("#newLmtAmt").prop('disabled', true);
                                    $("#newLmtAmt").css({'border-width': "0"});
                                    $("#newLmtExpiryDateField").prop('disabled', true);
                                    $("#newLmtExpiryDateField").kendoDatePicker({}); 
                                }else{
                                    $("#newLmtCcy").prop('disabled', false);
                                    $("#newLmtCcy").css({'border-width': "1"});
                                    $("#newLmtAmt").prop('disabled', false);
                                    $("#newLmtAmt").css({'border-width': "1"});
                                    $("#newLmtExpiryDateField").prop('disabled', false);
                                    $("#newLmtExpiryDateField").kendoDatePicker({
                                        format: "yyyy/MM/dd"
                                    }); 
                                }

                                if(value.enableCoSection != "Y"){
                                    $("#coLmtCcy").prop('disabled', true);
                                    $("#coLmtCcy").css({'border-width': "0"});
                                    $("#coLmtAmt").prop('disabled', true);
                                    $("#coLmtAmt").css({'border-width': "0"});
                                    $("#coLmtExpiryDate").prop('disabled', true);
                                    $("#coLmtExpiryDate").kendoDatePicker({});
                                }else{
                                    $("#coLmtCcy").prop('disabled', false);
                                    $("#coLmtCcy").css({'border-width': "1"});
                                    $("#coLmtAmt").prop('disabled', false);
                                    $("#coLmtAmt").css({'border-width': "1"});
                                    $("#coLmtExpiryDate").prop('disabled', false);
                                    $("#coLmtExpiryDate").kendoDatePicker({
                                        format: "yyyy/MM/dd"
                                    });
                                }

                                refreshTheGridFields();

                            }else{

                                // Disable Textboxes //
                                var textBoxes = document.querySelectorAll("#block1to2 input[type=text]");
                                for (var i = 0; i < textBoxes.length; i++) {
                                       $("#"+textBoxes[i].id).prop('disabled', true);
                                       $("#"+textBoxes[i].id).css({'border-width': "0"});
                                };

                                // Disable Radios //
                                var radios = document.querySelectorAll("#block1to2 input[type=radio]");
                                for (var i = 0; i < radios.length; i++) {
                                    $("#"+radios[i].id).prop('disabled', true);
                                };

                                // Disable selectOpt //
                                var selectOptions = document.querySelectorAll("#block1to2 select");
                                for (var i = 0; i < selectOptions.length; i++) {
                                    $("#"+selectOptions[i].id).prop('disabled', true);
                                    $("#"+selectOptions[i].id).css({'border-width': "0"});
                                };

                                // Disable file //
                                var files = document.querySelectorAll("#block1to2 input[type=file]");
                                for (var i = 0; i < files.length; i++) {
                                       $("#"+files[i].id).prop('disabled', true);
                                       $("#"+files[i].id).css({'border-width': "0"});
                                };

                                $("#block1to2 .k-button").prop('disabled', true);
                                $("#block1to2 .k-button").css({'color': "#ccc"});

                                var all = document.querySelectorAll("#block1to2 input");
                                for (var i = 0; i < files.length; i++) {
                                       $("#"+files[i].id).css({'border-width': "0"});
                                };

                                $("#newLmtExpiryDateField").kendoDatePicker({}); 
                                $("#coLmtExpiryDate").kendoDatePicker({});
                                $("#riBrReviewDate").kendoDatePicker({});
                                $("#riBcReviewDate").kendoDatePicker({});
                                $("#riBaReviewDate").kendoDatePicker({});
                            }
                            $("#lmtCategory").prop("disabled", "disabled");
                            $("#lmtTypeHierLvlId").prop("disabled", "disabled");
                            $("#lmtTypeCode").prop("disabled", "disabled");
                            $("#approvalMatrixOption").prop("disabled", "disabled");
                            $("#lmtCategory").css({"background-color":"#ccc"});
                            $("#lmtTypeHierLvlId").css({"background-color":"#ccc"});
                            $("#lmtTypeCode").css({"background-color":"#ccc"});
                            $("#approvalMatrixOption").css({"background-color":"#ccc"});
                        }
                    }
                });
            }

            function loadApprMatrixOpt(){

                var url =window.sessionStorage.getItem('serverPath')+"lmtApprMatrix/getOptionList?userId="+window.sessionStorage.getItem("username").replace("\\","\\");

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
                                clearDropDownWithoutBlank("approvalMatrixOption");
                                if(status == "success"){
                                    var i = 0
                                    $.each(JSON.parse(response.responseText), function(key, value) {
                                        option = document.createElement("option");
                                        option.text = checkUndefinedElement(value.apprMatrixOption);
                                        option.value = checkUndefinedElement(value.apprMatrixOption);
                                        document.getElementById("approvalMatrixOption").appendChild(option);
                                        
                                        option = null;
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

            function toDateFormatField(isRoot, crId, partyNo, partyType, type, bizUnit, bookEntity, dataSourceAppId, novaSubAcctId, dataObj){

                if(isRoot != "Y"){
                        if(type == "new"){

                            return "<input style=\"width: 100%\" id=\"newLmtExpiryDate-"+type+"-"+partyNo+"-"+partyType+"-"+crId+"-"+bizUnit+"-"+bookEntity+"-"+dataSourceAppId+"-"+novaSubAcctId+"\" value=\""+checkUndefinedElement(toDateFormatReverse(dataObj))+"\"/>";    

                        }else if(type == "co"){

                            return "<input style=\"width: 100%\" id=\"coLmtExpiryDate-"+type+"-"+partyNo+"-"+partyType+"-"+crId+"-"+bizUnit+"-"+bookEntity+"-"+dataSourceAppId+"-"+novaSubAcctId+"\" value=\""+checkUndefinedElement(toDateFormatReverse(dataObj))+"\"/>";       

                        }else{

                            return checkUndefinedElement(toDateFormatReverse(dataObj));
                        }
                }else{
                    return "<label>"+checkUndefinedElement(toDateFormatReverse(dataObj))+"</label>"
                }
            }

            function getAccountNo(partyNo, partyType){
                if(partyType == "ACCOUNT" || partyType == "SUB_ACCOUNT"){
                    return partyNo;
                }else{
                    return "";
                }
            }

            function setLimitAmount(isRoot, crId, partyNo, partyType, type, bizUnit, bookEntity, dataSourceAppId, novaSubAcctId, lmtAmt){

                if(isRoot != "Y"){
                    if(type == "new"){
                        return "<input class=\"k-textbox\" style=\"width: 100%\" id=\"newLimitAmount-"+type+"-"+partyNo+"-"+partyType+"-"+crId+"-"+bizUnit+"-"+bookEntity+"-"+dataSourceAppId+"-"+novaSubAcctId+"\" type=\"text\" value=\""+checkUndefinedElement(lmtAmt) +"\"></input>";
                    }else if(type == "co"){
                        return "<input class=\"k-textbox\" style=\"width: 100%\" id=\"coLimitAmount-"+type+"-"+partyNo+"-"+partyType+"-"+crId+"-"+bizUnit+"-"+bookEntity+"-"+dataSourceAppId+"-"+novaSubAcctId+"\" type=\"text\" value=\""+checkUndefinedElement(lmtAmt) +"\"></input>";
                    }
                }else{
                    return "<label style=\"width: 100%\" id=\"coLimitAmount-"+partyNo+"-"+partyType+"\" type=\"text\">"+checkUndefinedElement(lmtAmt)+"</label>";
                }
            }

            function getCurrencyList(listNmae){

                var getCurrencyJson = "/ermsweb/resources/js/staticData.json";
                var currenceyList = [];
                var addOptions = "";
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
                                clearDropDownWithoutBlank(listNmae);
                               
                                if(status == "success"){
                                    $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {
                                        if(key == "ccyList"){
                                           $.each(value, function(key, value) {
                                                var option = document.createElement("option");
                                                option.text = checkUndefinedElement(value);
                                                option.value = checkUndefinedElement(value);
                                                document.getElementById(listNmae).appendChild(option);
                                                /*
                                                document.getElementById("newLmtCcy").selectedIndex = 0;
                                                */
                                                option = null;
                                                
                                           });
                                        }

                                    });
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
            function getCollateralList(listNmae){

                var getCollateral = "/ermsweb/resources/js/staticData.json";
                var currenceyList = [];
                var addOptions = "";
                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getCollateral,   
                            cache: false,                       
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            },
                            complete: function(response, status){
                                clearDropDownWithoutBlank(listNmae);
                               
                                if(status == "success"){
                                    $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {

                                        if(key == "collateralList"){
                                           $.each(value, function(key, value) {
                                                var option = document.createElement("option");
                                                option.text = checkUndefinedElement(value);
                                                option.value = checkUndefinedElement(value);
                                                document.getElementById(listNmae).appendChild(option);
                                                /*
                                                document.getElementById("newLmtCcy").selectedIndex = 0;
                                                */
                                                option = null;
                                                
                                           });
                                        }

                                    });
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
            function setCurrencyList(isRoot, crId, partyNo, partyType, type, bizUnit, bookEntity, dataSourceAppId, novaSubAcctId){

                var getCurrencyJson = "/ermsweb/resources/js/staticData.json";
                var currenceyList = [];
                var addOptions = "";
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

                                    /*clearDropDownWithoutBlank("newLmtCcy");*/

                                    $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {

                                        if(key == "ccyList"){
                                           $.each(value, function(key, value) {
                                                currenceyList.push(value);
                                           });
                                        }
                                    });
                                    
                                    for (var i = 0; i < currenceyList.length; i++) {
                                        addOptions += "<option value=\""+currenceyList[i]+"\">"+currenceyList[i]+"</option>";
                                    };
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

                if(isRoot != "Y"){
                    return "<select style=\"width: 100%\" class=\"select_join\" id=\"currencyList-"+type+"-"+partyNo+"-"+partyType+"-"+crId+"-"+bizUnit+"-"+bookEntity+"-"+dataSourceAppId+"-"+novaSubAcctId+"\">"+addOptions+"</select>";    
                }else{
                    return "";
                }
            }
            function onloadCurrency(){
                var getCurrencyJson = "/ermsweb/resources/js/staticData.json";
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
                                clearDropDown("currencyList");
                                if(status == "success"){
                                    $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {
                                        
                                        if(key == "ccyList"){
                                           $.each(value, function(key, value) {
                                                var option = document.createElement("option");
                                                option.text = checkUndefinedElement(value);
                                                option.value = checkUndefinedElement(value);
                                                document.getElementById("currencyList").appendChild(option);
                                                document.getElementById("currencyList").selectedIndex = 0;
                                                option = null;
                                           });
                                        }
                                    });
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

            function createRadioButtonFulfill(enableFulfill, isFulfill, partyNo, partyType, lmtTypeCode, bizUnit, dataSourceAppId, bookEntity, novaSubAcctId, crId){

                if(enableFulfill == 'Y'){
                    if(partyType == "GROUP"){
                        if(isFulfill == 'Y'){
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"Y\" checked></input>"
                        }else if(isFulfill == 'N'){
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"Y\"></input>"
                        }else{
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"Y\"></input>"
                        }
                    }else if(partyType == "LEGAL_PARTY"){
                        if(isFulfill == 'Y'){
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"Y\" checked></input>"
                        }else if(isFulfill == 'N'){
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"Y\"></input>"
                        }else{
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"Y\"></input>"
                        }
                    }else if(partyType == "ACCOUNT"){
                        if(isFulfill == 'Y'){
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"Y\" checked></input>"
                        }else if(isFulfill == 'N'){
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"Y\"></input>"
                        }else{
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"Y\"></input>"
                        }
                    }else if(partyType == "SUB_ACCOUNT"){
                        if(isFulfill == 'Y'){
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"Y\" checked></input>"
                        }else if(isFulfill == 'N'){
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"Y\"></input>"
                        }else{
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"Y\"></input>"
                        }
                    }    

                }else{
                    return "";
                }
            }

            function updateShareHolderScope(){
                
                var grid = $("#shareHolderGrid").data("kendoGrid");

                var tmpUnderlyingStkCode = $("#underlyingStkCode").val();
                var tmpUnderlyingStkMktCode = $("#underlyingStkMktCode").val();
                var tmpShareHolderRole = $("#shareHolderRole").val();
                var tmpShlTotQtyHeldInMrkt = $("#shlTotQtyHeldInMrkt").val();

                grid.dataSource.add(
                    {
                        shlUlyStockCode : tmpUnderlyingStkCode,
                        shlUlyStockMarketCode : tmpUnderlyingStkMktCode,
                        shlShareholderRole : tmpShareHolderRole,
                        shlTotQtyHeldInMrkt : tmpShlTotQtyHeldInMrkt
                    }
                );
            }

            function createRadioButtonNotFulfill(enableFulfill, isFulfill, partyNo, partyType, lmtTypeCode, bizUnit, dataSourceAppId, bookEntity, novaSubAcctId, crId){


                if(enableFulfill == 'Y'){
                    if(partyType == "GROUP"){
                        if(isFulfill == 'Y'){
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"N\"></input>"
                        }else if(isFulfill == 'N'){
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"Y\" checked></input>"
                        }else{
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"N\"></input>"
                        }
                    }else if(partyType == "LEGAL_PARTY"){
                        if(isFulfill == 'Y'){
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"N\"></input>"
                        }else if(isFulfill == 'N'){
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"Y\" checked></input>"
                        }else{
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"N\"></input>"
                        }
                    }else if(partyType == "ACCOUNT"){
                        if(isFulfill == 'Y'){
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"N\"></input>"
                        }else if(isFulfill == 'N'){
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"Y\" checked></input>"
                        }else{
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"N\"></input>"
                        }
                    }else if(partyType == "SUB_ACCOUNT"){
                        if(isFulfill == 'Y'){
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"N\"></input>"
                        }else if(isFulfill == 'N'){
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"Y\" checked></input>"
                        }else{
                            return "<input type=\"radio\" name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"-"+crId+"\" onclick=\"updateFulfill(this, '"+partyNo+"', '"+partyType+"', '"+lmtTypeCode+"', '"+bizUnit+"', '"+dataSourceAppId+"', '"+bookEntity+"', '"+novaSubAcctId+"', '"+crId+"')\"  value=\"N\"></input>"
                        }
                    }      
                }else{
                    return "";
                }
            }

            function updateFulfill(obj, partyNo, partyType, lmtTypeCode, bizUnit, dataSourceAppId, bookEntity, novaSubAcctId, crId){
                  
                var gridData = dataSourceCapture.data();

                for (var i = 1; i < gridData.length; i++) {

                    if(gridData[i].crId == crId){

                        gridData[i].isFulfill =  getCheckedValue(obj);
                    }
                };
            }


            function getLendingUnit(){

                var getLendingUnit = "/ermsweb/resources/js/staticData.json";
                var currenceyList = [];
                var addOptions = "";
                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getLendingUnit,   
                            cache: false,                       
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            },
                            complete: function(response, status){
                                clearDropDownWithoutBlank("lendingUnit");
                               
                                if(status == "success"){
                                    $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {

                                        if(key == "lendingUnitList"){
                                           $.each(value, function(key, value) {
                                               var option = document.createElement("option");
                                               option.text = checkUndefinedElement(value);
                                               option.value = checkUndefinedElement(key);
                                               document.getElementById("lendingUnit").appendChild(option);
                                               option = null;
                                           });
                                        }

                                    });
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

            function renewCcptyInfo(opt){
                var getRenewCcptyInfo = "/ermsweb/resources/js/staticData.json";
                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getRenewCcptyInfo,   
                            cache: false,                       
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            },
                            complete: function(response, status){
                                if(status == "success"){
                                    $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {
                                        
                                        if(key == "clientInfoList"){
                                            
                                                $.each(value, function(key, value) {
                                                    if(opt.value.split("||")[0]  == value.ccdId){
                                                        $("#connectedPartyType").html(value.connectedPartyType);
                                                        $("#countryOfDomicile").html(value.countryOfDomicile);
                                                        $("#creditRatingInr").html(value.creditRatingInr);
                                                        $("#creditRatingMoody").html(value.creditRatingMoody);
                                                        $("#creditRatingSnp").html(value.creditRatingSnp);
                                                        $("#creditRatingFitch").html(value.creditRatingFitch);
                                                        $("#riskRatingForApproval").html(value.riskRatingForApproval);
                                                        $("#holdingType").html(value.holdingType);
                                                    }
                                                });
                                            
                                        }
                                    });
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
            
            function renewGroupInfo(obj){

                var getRenewGroupInfo = "/ermsweb/resources/js/staticData.json";
                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getRenewGroupInfo,   
                            cache: false,                       
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            },
                            complete: function(response, status){
                                if(status == "success"){
                                    $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {
                                        
                                        if(key == "groupInfo"){          
                                                    if(obj == value.groupId){
                                                        $("#hiddenGroupId").val(value.groupId);
                                                        $("#tmpPartyNo").val(value.groupId);
                                                        $("#groupName").html(value.groupName);
                                                        $("#connectedPartyType").html("");
                                                        $("#countryOfDomicile").html("");
                                                        $("#creditRatingInr").html("");
                                                        $("#creditRatingMoody").html("");
                                                        $("#creditRatingSnp").html("");
                                                        $("#creditRatingFitch").html("");
                                                        $("#riskRatingForApproval").html("");
                                                        $("#holdingType").html("");
                                                        $("#groupCreditRatingInr").html(value.creditRatingInr);
                                                        $("#groupCreditRatingMoody").html(value.creditRatingMoody);
                                                        $("#groupCreditRatingSnp").html(value.creditRatingSnp);
                                                        $("#groupCreditRatingFitch").html(value.creditRatingFitch);
                                                        $("#groupRiskRatingForAppr").html(value.riskRatingForApproval);
                                                    }
                                            
                                        }
                                    });
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

            function renewAcctInfo(opt){
                var getRenewAcctInfo = "/ermsweb/resources/js/staticData.json";
                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getRenewAcctInfo,   
                            cache: false,                       
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            },
                            complete: function(response, status){
                                if(status == "success"){
                                    $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {
                                        
                                        if(key == "acctInfoList"){
                                            $.each(value, function(key, value) {

                                                if(opt.value.split("||")[0] == value.acctId){
                                                    $("#connectedPartyType").html(value.connectedPartyType);
                                                    $("#countryOfDomicile").html(value.countryOfDomicile);
                                                    $("#creditRatingInr").html(value.creditRatingInr);
                                                    $("#creditRatingMoody").html(value.creditRatingMoody);
                                                    $("#creditRatingSnp").html(value.creditRatingSnp);
                                                    $("#creditRatingFitch").html(value.creditRatingFitch);
                                                    $("#riskRatingForApproval").html(value.riskRatingForApproval);
                                                    /*$("#chargor").val(value.chargor);*/
                                                    $("#holdingType").html(value.holdingType);
                                                }
                                            });
                                        }
                                    });
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

            function renewSubAcctInfo(opt){
                var getSubAcctInfo = "/ermsweb/resources/js/staticData.json";
                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getSubAcctInfo,   
                            cache: false,                       
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            },
                            complete: function(response, status){
                                if(status == "success"){
                                    $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {
                                        if(key == "subAcctInfoList"){
                                                $.each(value, function(key, value) {
                                                    if(opt.value.split("||")[4]  == value.subAcctId && opt.value.split("||")[0]  == value.acctId){
                                                        console.log("#######");
                                                        $("#connectedPartyType").html(value.connectedPartyType);
                                                        $("#countryOfDomicile").html(value.countryOfDomicile);
                                                        $("#creditRatingInr").html(value.creditRatingInr);
                                                        $("#creditRatingMoody").html(value.creditRatingMoody);
                                                        $("#creditRatingSnp").html(value.creditRatingSnp);
                                                        $("#creditRatingFitch").html(value.creditRatingFitch);
                                                        $("#riskRatingForApproval").html(value.riskRatingForApproval);
                                                        /*$("#chargor").val(value.chargor);*/
                                                        $("#holdingType").html(value.holdingType);
                                                    }
                                                });
                                            
                                        }
                                    });
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



            function initalShareHolderGrid(shlMapList){

                var shareHolderList = shlMapList;

                $("#shareHolderScope").html("<div id='shareHolderGrid'></div>");

                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: function (e) {
                            e.success(shareHolderList);
                        }
                    }
                });   

                if(shareHolderList != null){

                    $('#shareHolderGrid').kendoGrid({
                    
                        dataSource: dataSource,
                        cache: false,
                        editable: true,
                        columns: [  
                            { 
                                field: "shlUlyStockCode", 
                                title: "Underlying Stock Code" ,
                                width: 100
                            },
                            { 
                                field: "shlUlyStockMarketCode",
                                title: "Underlying Stock Market Code" ,
                                width: 100
                            },
                            { 
                                field: "shlShareholderRole", 
                                title: "Shareholder Role" ,
                                width: 100
                            },
                            { 
                                field: "shlTotQtyHeldInMrkt", 
                                title: "Total Quantity" ,
                                width: 100
                            },
                            { 
                                command: "destroy", 
                                width: "150px"
                            }
                        ]
                    });

                }else{

                    $('#shareHolderGrid').kendoGrid({
                    
                        cache: false,
                        editable: true,
                        columns: [  
                            { 
                                field: "shlUlyStockCode", 
                                title: "Underlying Stock Code" ,
                                width: 100
                            },
                            { 
                                field: "shlUlyStockMarketCode",
                                title: "Underlying Stock Market Code" ,
                                width: 100
                            },
                            { 
                                field: "shlShareholderRole", 
                                title: "Shareholder Role" ,
                                width: 100
                            },
                            { 
                                field: "shlTotQtyHeldInMrkt", 
                                title: "Total Quantity" ,
                                width: 100
                            },
                            { 
                                command: "destroy", 
                                width: "150px"
                            }
                        ]
                    });
                }
            }


            function initialPmeLimitScope(){

                /*var getPemLimitScope =window.sessionStorage.getItem('serverPath')+"limitapplication/getLimitAppDetailList?userId=RISKADMIN&rmdGroupId=PP_GROUP1&approvalMatrixBu=PB&approvalMatrixOption=LEE";*/
                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getDetailURL,   
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
                    }
                });    
                
            }

            function onLoadDslProdList(){
                var getDslProd = "/ermsweb/resources/js/staticData.json";
                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getDslProd,   
                            cache: false,                       
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            },
                            complete: function(response, status){
                                if(status == "success"){
                                    $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {
                                        if(key == "prProdType"){
                                            $.each(value, function(key, value) {
                                                var option = document.createElement("option");
                                                option.text = checkUndefinedElement(value);
                                                option.value = checkUndefinedElement(key);
                                                document.getElementById("dvpProdList").appendChild(option);
                                                option = null;
                                            });
                                        }
                                    });
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

            function onLoadprProdList(){
                var getPrProd = "/ermsweb/resources/js/staticData.json";
                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getPrProd,   
                            cache: false,                       
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            },
                            complete: function(response, status){
                                if(status == "success"){
                                    $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {
                                        if(key == "prProdType"){
                                            $.each(value, function(key, value) {
                                                var option = document.createElement("option");
                                                option.text = checkUndefinedElement(value);
                                                option.value = checkUndefinedElement(key);
                                                document.getElementById("prProdType").appendChild(option);
                                                option = null;
                                            });
                                        }
                                    });
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
            function onLoadWhlProdList(){
                var getPrProd = "/ermsweb/resources/js/staticData.json";
                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getPrProd,   
                            cache: false,                       
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            },
                            complete: function(response, status){
                                if(status == "success"){

                                    $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {
                                        if(key == "whlProdType"){
                                            $.each(value, function(key, value) {
                                                var option = document.createElement("option");
                                                option.text = checkUndefinedElement(value);
                                                option.value = checkUndefinedElement(key);
                                                document.getElementById("whlProdList").appendChild(option);
                                                option = null;
                                            });
                                        }
                                    });
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

            function onLoadPmeExpoType(){
            
                var getPmeExpo = "/ermsweb/resources/js/staticData.json";
                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getPmeExpo,   
                            cache: false,                       
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            },
                            complete: function(response, status){
                                if(status == "success"){
                                   $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {
                                        if(key == "pmeExpoType"){
                                            $.each(value, function(key, value) {
                                                var option = document.createElement("option");
                                                option.text = checkUndefinedElement(value);
                                                option.value = checkUndefinedElement(key);
                                                document.getElementById("pmeExpoType").appendChild(option);
                                                option = null;
                                            });
                                        }
                                    });
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

            function onChangeLimitType(lmtType){

                console.log("ddddddddddddd ::"+lmtType.value);

                if(lmtType.value == "LOAN FOR MARGIN DEPOSIT LIMIT"){

                    $("#mdl-table").css({"display":"none"});
                    $("#idl-table").css({"display":"none"});
                    $("#whu-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#shl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#pme-table").css({"display":"none"});
                    $("#prl-table").css({"display":"none"});
                    $("#fdl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#pfl-table").css({"display":"none"});
                    $("#mdl-table").css({"display":"table"});

                }
                else if(lmtType.value == "INTERBANK & DEPOSIT LIMIT" || lmtType.value == "INTERBANK & DEPOSIT (LC DISCOUNTING BANK) LIMIT" || lmtType.value == "INTERBANK & DEPOSIT (LC ISSUING BANK) LIMIT" || lmtType.value == "INTERBANK & DEPOSIT (LC PLEDGE BANK) LIMIT" ){

                    $("#mdl-table").css({"display":"none"});
                    $("#idl-table").css({"display":"none"});
                    $("#whu-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#shl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#pme-table").css({"display":"none"});
                    $("#prl-table").css({"display":"none"});
                    $("#fdl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#pfl-table").css({"display":"none"});
                    $("#idl-table").css({"display":"table"});

                }
                else if(lmtType.value == "WAREHOUSE LIMIT"){

                    $("#mdl-table").css({"display":"none"});
                    $("#idl-table").css({"display":"none"});
                    $("#whu-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#shl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#pme-table").css({"display":"none"});
                    $("#prl-table").css({"display":"none"});
                    $("#fdl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#pfl-table").css({"display":"none"});
                    $("#whu-table").css({"display":"table"});

                }
                else if(lmtType.value == "STOCK BORROWING LIMIT" || lmtType.value == "REPO BORROWING LIMIT" || lmtType.value == "REPO LENDING LIMIT" || lmtType.value == "REPO LENDING LIMIT" ){

                    $("#mdl-table").css({"display":"none"});
                    $("#idl-table").css({"display":"none"});
                    $("#whu-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#shl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#pme-table").css({"display":"none"});
                    $("#prl-table").css({"display":"none"});
                    $("#fdl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#pfl-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"table"});

                }
                else if(lmtType.value == "SHAREHOLDER LOAN LIMIT TYPE 1" || lmtType.value == "SHAREHOLDER LOAN LIMIT TYPE 2" || lmtType.value == "SHAREHOLDER LOAN LIMIT TYPE 3"  ){

                    $("#mdl-table").css({"display":"none"});
                    $("#idl-table").css({"display":"none"});
                    $("#whu-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#shl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#pme-table").css({"display":"none"});
                    $("#prl-table").css({"display":"none"});
                    $("#fdl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#pfl-table").css({"display":"none"});
                    $("#shl-table").css({"display":"table"});

                }
                else if(lmtType.value == "DAILY SETTLEMENT LIMIT"){

                    $("#mdl-table").css({"display":"none"});
                    $("#idl-table").css({"display":"none"});
                    $("#whu-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#shl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#pme-table").css({"display":"none"});
                    $("#prl-table").css({"display":"none"});
                    $("#fdl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#pfl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"table"});

                }
                else if(lmtType.value == "PME LIMIT"){

                    $("#mdl-table").css({"display":"none"});
                    $("#idl-table").css({"display":"none"});
                    $("#whu-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#shl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#pme-table").css({"display":"none"});
                    $("#prl-table").css({"display":"none"});
                    $("#fdl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#pfl-table").css({"display":"none"});
                    $("#pme-table").css({"display":"table"});

                }
                else if(lmtType.value == "PHYSICAL REPO LIMIT"){

                    $("#mdl-table").css({"display":"none"});
                    $("#idl-table").css({"display":"none"});
                    $("#whu-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#shl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#pme-table").css({"display":"none"});
                    $("#prl-table").css({"display":"none"});
                    $("#fdl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#pfl-table").css({"display":"none"});
                    $("#prl-table").css({"display":"table"});

                }
                else if(lmtType.value == "FUTURES DEPOSIT LIMIT"){

                    $("#mdl-table").css({"display":"none"});
                    $("#idl-table").css({"display":"none"});
                    $("#whu-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#shl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#pme-table").css({"display":"none"});
                    $("#prl-table").css({"display":"none"});
                    $("#fdl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#pfl-table").css({"display":"none"});
                    $("#fdl-table").css({"display":"table"});

                }
                else if(lmtType.value == "DVP LIMIT"){

                    $("#mdl-table").css({"display":"none"});
                    $("#idl-table").css({"display":"none"});
                    $("#whu-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#shl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#pme-table").css({"display":"none"});
                    $("#prl-table").css({"display":"none"});
                    $("#fdl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#pfl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"table"});

                }
                else if(lmtType.value == "REPO LOAN LIMIT"){

                    $("#mdl-table").css({"display":"none"});
                    $("#idl-table").css({"display":"none"});
                    $("#whu-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#shl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#pme-table").css({"display":"none"});
                    $("#prl-table").css({"display":"none"});
                    $("#fdl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#pfl-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"table"});

                }
                else if(lmtType.value == "PREMIUM FINANCING LIMIT"){

                    $("#mdl-table").css({"display":"none"});
                    $("#idl-table").css({"display":"none"});
                    $("#whu-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#shl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#pme-table").css({"display":"none"});
                    $("#prl-table").css({"display":"none"});
                    $("#fdl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#pfl-table").css({"display":"none"});
                    $("#pfl-table").css({"display":"table"});
                    console.log("VV");
                }else{
                    $("#mdl-table").css({"display":"none"});
                    $("#idl-table").css({"display":"none"});
                    $("#whu-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#shl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#pme-table").css({"display":"none"});
                    $("#prl-table").css({"display":"none"});
                    $("#fdl-table").css({"display":"none"});
                    $("#dsl-dvp-table").css({"display":"none"});
                    $("#sbl-rl-table").css({"display":"none"});
                    $("#pfl-table").css({"display":"none"});
                }


                onChangeCcfRatio(lmtType.value);
            }

            $(document).ready(function () {
                
                getStaticData();
                initialLoadGrid();        
                /*initializeGarbage();        */
                loadApprMatrixOpt();  
                getCurrencyList("pfCurrency");
                getBizUnit("bizUnitDropDown");
                getLmtCategory();
                /*getLendingUnit();*/
                
                onLoadDslProdList();
                onLoadprProdList();
                onLoadPmeExpoType();
                onLoadWhlProdList();
                onLoadRemarksCat();
                onLoadFileGrid();
                onLoadSupInfoOfGroupClientGrid(true, "");
                onLoadApprLevel();
                onLoadApprDetailsGrid();
                initialLimitAllocationGrid(null);


                $("#newLmtExpiryDateField").kendoDatePicker({
                    value: "",
                    format: "yyyy/MM/dd"
                });


                $("#coLmtExpiryDate").kendoDatePicker({
                    value: "",
                    format: "yyyy/MM/dd"
                });

                refreshTheGridFields();

                $("#guarExpiryDate").kendoDatePicker({
                    value: "",
                    format: "yyyy/MM/dd"
                });
                $("#guarExpiryDate").attr("readonly","readonly");

                $("#searchWindowIsda").kendoWindow({
                    width: "800px",
                    height: "650px",
                    modal: true,
                    title: "Search ISDA",
                    visible: false
                }); 

                $("#searchWindowCsa").kendoWindow({
                    width: "800px",
                    height: "650px",
                    modal: true,
                    title: "Search CSA",
                    visible: false
                });

                $("#searchWindowGuarantor").kendoWindow({
                    width: "800px",
                    height: "650px",
                    modal: true,
                    title: "Search Guarantor",
                    visible: false
                });

               
                $("#riBrReviewDate").kendoDatePicker({
                    value: "",
                    format: "yyyy/MM/dd"
                });
                $("#riBrReviewDate").attr("readonly","readonly");
                $("#riBcReviewDate").kendoDatePicker({
                    value: "",
                    format: "yyyy/MM/dd"
                });
                $("#riBcReviewDate").attr("readonly","readonly");
                $("#riBaReviewDate").kendoDatePicker({
                    value: "",
                    format: "yyyy/MM/dd"
                });
                $("#riBaReviewDate").attr("readonly","readonly");

                initalGuarGrid(null);

                $("#isdaResultGrid").kendoGrid({
                    dateSource: new kendo.data.DataSource(),
                    columns: [  
                        { 
                            field: "pmeIsdaId", 
                            title: "ISDA ID" ,
                            width: 100
                        },
                        { 
                            field: "pmeIsdaEntity",
                            title: "Entity" ,
                            width: 100
                        },
                        { 
                            field: "isdaPaymentCcy", 
                            title: "Payment Currency" ,
                            width: 100
                        },
                        { 
                            field: "isdaNettingCcy", 
                            title: "Netting Currency" ,
                            width: 100
                        },
                        { 
                            field: "isdaNettingInstrument", 
                            title: "Netting Instrument" ,
                            width: 100
                        }
                    ]
                });
                
                $('#csaResultGrid').kendoGrid({
                    dateSource: new kendo.data.DataSource(),
                    editable: true,
                    columns: [  
                        { 
                            field: "pmeCsaId", 
                            title: "CSA ID" ,
                            width: 100
                        },
                        { 
                            field: "pmeCsaEntity",
                            title: "Entity" ,
                            width: 100
                        },
                        { 
                            field: "csaCollateralCcy", 
                            title: "CSA Collateral Currency" ,
                            width: 100
                        },
                        { 
                            field: "csaBociThreshold", 
                            title: "Threshholde To BOCI" ,
                            width: 100
                        },
                        { 
                            field: "csaCptyThreshold", 
                            title: "Threshholde To Counterparty" ,
                            width: 100
                        },
                        { 
                            field: "bociMta", 
                            title: "CSA MTA to BOCI" ,
                            width: 100
                        },
                        { 
                            field: "csaCptyMta", 
                            title: "CSA MTA to Counterparty" ,
                            width: 100
                        },
                        { 
                            field: "csaBociIndependentAmount", 
                            title: "CSA Independent Amount To BOCI" ,
                            width: 100
                        },
                        { 
                            field: "csaCptyIndependentAmount", 
                            title: "CSA Independent Amount To Counterparty" ,
                            width: 100
                        },
                        { 
                            field: "csaMarginCallFrequency", 
                            title: "CSA Margin Call Frequency" ,
                            width: 100
                        }
                    ]
                });

            });

            

            function onLoadFileGrid(){
                $('#fileDetailGrid').kendoGrid({
                    dateSource: null,
                    editable: true,
                    columns: [  
                        { 
                            field: "fileKey", 
                            title: "File Key" ,
                            width: 100,
                            hidden: true
                        },
                        { 
                            field: "fileDesc", 
                            title: "File Description" ,
                            width: 100
                        },
                        { 
                            field: "fileName",
                            title: "File Name" ,
                            width: 100
                        },
                        { 
                            field: "isNew", 
                            title: "File Description" ,
                            width: 100,
                            hidden: true
                        },
                        { 
                            field: "createDt", 
                            title: "Created Date" ,
                            width: 100,
                            template: "#=toDateFormatReverse(new Date().getTime())#"
                        },
                        { 
                            field: "lastUpdateDt", 
                            title: "Last Update Date" ,
                            width: 100,
                            hidden: true
                        },
                        { 
                            command: "destroy", 
                            width: "150px"
                        },
                        { 
                            title: "", 
                            width: "150px",
                            template: "#=downloadFileIcon(fileName, fileKey, isNew)#"
                        }
                    ]
                });

            }

            
            function addExtensionClass(extension) {
                switch (extension) {
                    case '.jpg':
                    case '.img':
                    case '.png':
                    case '.gif':
                        return "img-file";
                    case '.doc':
                    case '.docx':
                        return "doc-file";
                    case '.xls':
                    case '.xlsx':
                        return "xls-file";
                    case '.pdf':
                        return "pdf-file";
                    case '.zip':
                    case '.rar':
                        return "zip-file";
                    default:
                        return "default-file";
                }
            }

            function getCheckedValue(radioObj) {
                if(!radioObj)
                    return "";
                var radioLength = radioObj.length;
                if(radioLength == undefined)
                    if(radioObj.checked)
                        return radioObj.value;
                    else
                        return "";
                for(var i = 0; i < radioLength; i++) {
                    if(radioObj[i].checked) {
                        return radioObj[i].value;
                    }
                }
                return "";
            }

            function onActions(actions){

                saveGrid();

                dataSourceCapture.fetch(function(){
                    
                    var values = dataSourceCapture.data();

                    for (var i = 0; i < values.length; i++) {

                        if(actions == "SAVE"){

                            values[i].action = "T";

                        }else if(actions == "DISCARD"){

                            values[i].action = "D";
                            
                        }else if(actions == "SUBMIT"){

                            values[i].action = "S";
                            
                        }else if(actions == "RETURN"){

                            values[i].action = "R";
                            
                        }else if(actions == "ENDORSE"){

                            values[i].action = "E";
                            
                        }else if(actions == "APPROVE"){

                            values[i].action = "A";
                            
                        }else if(actions == "REJECT"){

                            values[i].action = "J";
                            
                        }else if(actions == "APPROVE_WITH_COND"){

                            values[i].action = "AC";

                        }else if(actions == "VERIFY"){

                            values[i].action = "VA";
                            
                        }else if(actions == "CHECKER"){
                            
                            values[i].action = "C";

                        }

                        values[i].userId = window.sessionStorage.getItem("username").replace("\\","\\");

                    }
                });

                /*dataSourceCapture.add(dataSourceGarbage.data());*/
                var gridData = dataSourceCapture.data();

                /*
                name=\"fulfill-"+partyNo+"-"+partyType+"-"+bizUnit+"-"+dataSourceAppId+"-"+bookEntity+"-"+novaSubAcctId+"_"+crId+"\"
                */

                console.log(gridData);
              
                var values = JSON.stringify(gridData);


                console.log();

                /*$('input[name=""]:checked').val();*/
                /*fulfill-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].bizUnit+"-"+values[i].dataSourceAppId+"-"+values[i].bookEntity+"-"+values[i].novaSubAcctId*/



                $.ajax({
                    url:window.sessionStorage.getItem('serverPath')+"limitapplication/facilityAction",
                    type: "POST",
                    dataType: "json",
                    data: values,
                    contentType: "application/json; charset=utf-8",
                    success: function (result) {
                        console.log(result);
                        window.location.reload();
                    },
                    xhrFields: {
                        withCredentials: true
                    }
                });
            }

            function recalculate(){

                var calculateData = "[";
                saveGrid();

                dataSourceCapture.fetch(function(){
                    
                    var values = dataSourceCapture.data();

                    for (var i = 1; i < values.length; i++) {
                        if(values.isRoot != "Y")
                            calculateData += recalculateSchema("RISKADMIN", values[i].inGrpId, values[i].inCcdId, values[i].inApprovalMatrixBu, values[i].inApprovalMatrixOpt, values[i].crId , values[i].crStatus, values[i].lmtTypeCode, values[i].newLmtCcy, values[i].newLmtAmt, values[i].coLmtCcy, values[i].coLmtAmt, values[i].partyType )+",";
                    }

                    calculateData = calculateData.substring(0, calculateData.length - 1);
                    calculateData += "]"

                    console.log(calculateData);

                    var url =window.sessionStorage.getItem('serverPath')+"limitapplication/recalLmtAmt";

                    var dataSource = new kendo.data.DataSource({

                        transport: {
                            read: function(options) {
                                $.ajax({
                                    type: "POST",
                                    url: url,
                                    data: calculateData,
                                    contentType: "application/json; charset=utf-8",
                                    dataType: "json",
                                    success: function (result) {
                                        options.success(result);
                                    },
                                    complete: function (jqXHR, textStatus){
                                        if(textStatus == "success"){

                                            console.log(jqXHR.responseText);
                                            var countJsonLayer = 1;
                                            var sumOfNew = 0;
                                            var sumOfCo = 0;

                                            $.each(JSON.parse(jqXHR.responseText), function(key, value){
                                                
                                                    values[0].coNewCcfLmtAmt   = value.outSumCoFacilLmtAmtCcf;
                                                    values[0].newCcfLmtAmt  = value.outSumNewFacilLmtAmtCcf;

                                                    if(values[countJsonLayer].isRoot != "Y"){
                                                        values[countJsonLayer].coNewCcfLmtAmt = value.outCoFacilLmtAmtCcf;
                                                        values[countJsonLayer].newCcfLmtAmt   = value.outNewFacilLmtAmtCcf;
                                                    }else{
                                                        values[countJsonLayer].coNewCcfLmtAmt = "";
                                                        values[countJsonLayer].newCcfLmtAmt   = "";
                                                        values[countJsonLayer].coNewCcfLmtAmt   = value.outSumCoFacilLmtAmtCcf;
                                                        values[countJsonLayer].newCcfLmtAmt  = value.outSumNewFacilLmtAmtCcf;

                                                        sumOfNew = value.outSumCoFacilLmtAmtCcf;
                                                        sumOfCo = value.outSumNewFacilLmtAmtCcf;
                                                        console.log(">>>> " + sumOfNew);
                                                        console.log(">>>> " +sumOfCo);
                                                    }

                                                    ++countJsonLayer;


                                                var grid = $("#grid").data("kendoGrid");
                                                grid.setDataSource(dataSourceCapture);
                                                for (var i = 0; i < values.length; i++) {
                                                    console.log(values[i].enableNewSection );
                                                    console.log(values[i].enableCoSection );
                                                    if(values[i].enableNewSection != "Y"){

                                                        autoSelectedByValue("currencyList-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId, values[i].newLmtCcy);

                                                        $("#currencyList-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).css({"border-width":"0"}); 
                                                        $("#currencyList-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});

                                                        $("#newLimitAmount-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).css({"border-width":"0"});
                                                        $("#newLimitAmount-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});


                                                        $("#newLmtExpiryDate-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});
                                                    }

                                                    if(values[i].enableCoSection != "Y"){

                                                        autoSelectedByValue("currencyList-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId, values[i].coLmtCcy);

                                                        $("#currencyList-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).css({"border-width":"0"});
                                                        $("#currencyList-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});


                                                        $("#coLimitAmount-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).css({"border-width":"0"});
                                                        $("#coLimitAmount-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});



                                                         $("#coLmtExpiryDate-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});
                                                    }
                                                }
                                                refreshTheGridFields();
                                                
                                            });

                                            
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
                                id: "inCrId",
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
                });
            }

            function recalculateSchema(userId, inGrpId, inCcdId, inApprovalMatrixBu, inApprovalMatrixOpt, crId,crStatus, lmtTypeCode, newLmtCcy, newLmtAmt, coLmtCcy, coLmtAmt, partyType){

                return JSON.stringify({
                        userId : userId,
                        inRmdGroupId : inGrpId,
                        inCcdId : inCcdId,
                        inApprovalMatrixBu : inApprovalMatrixBu,
                        inapprovalMatrixOption : inApprovalMatrixOpt,
                        inCrId : crId,
                        inCrStatus : crStatus,
                        inCrLmtTypeCode : lmtTypeCode,
                        inNewFacilLmtAmt : newLmtAmt,
                        inNewFacilLmtCcy : newLmtCcy,
                        inCoFacilLmtAmt : coLmtAmt,
                        inCoFacilLmtCcy : coLmtCcy,
                        outNewFacilLmtAmtCcf: null,
                        outCoFacilLmtAmtCcf: null,
                        outSumNewFacilLmtAmtCcf: null,
                        outSumCoFacilLmtAmtCcf: null,
                        inPartyType : partyType
                    });

            }

            function saveGrid(){

                var values = dataSourceCapture.data();

                for (var i = 1 ; i < values.length ; i++) {


                    console.log($("#currencyList-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId+" :selected").val());

                    console.log($("#ccurrencyList-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId+" :selected").val());



                    values[i].newLmtCcy = $("#currencyList-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId+" :selected").val();

                    values[i].newLmtAmt = $("#newLimitAmount-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).val();

                    values[i].newLmtExpiryDate = dateToTime(strToDateReverse($("#newLmtExpiryDate-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).val()));



                    values[i].coLmtCcy = $("#currencyList-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId+" :selected").val();

                    values[i].coLmtAmt = $("#coLimitAmount-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).val();

                    values[i].coLmtExpiryDate = dateToTime(strToDateReverse($("#coLmtExpiryDate-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).val()));;

                };
            }

            function makeAllFieldsOfGridBeEmpty(){
                var textBoxes = document.querySelectorAll("#grid input[type=text]");

                for (var i = 0; i < textBoxes.length; i++) {
                    textBoxes[i].value = "";
                };

                var selectOptions = document.querySelectorAll("#grid select");
                for (var i = 0; i < selectOptions.length; i++) {
                    selectOptions[i].selectedIndex = 0;
                };
            }

        </script>

        <style type="text/css">

            .sendRequestButton{
                line-height: 2cm;
                vertical-align: right;
                padding-right: 30px;
            }
            .clearFloat{
                float: both;
            }
            .tableTitle{
                background-color:#9C3E3E; 
                color:white;
                padding-left: 0.5cm;
                line-height:20px;
            }
            .withBorder{
                border-bottom-style: solid; 
                border-bottom-color: #9C3E3E;
                padding-left: 0.5cm;
                line-height:40px;
                width: 25%;
            }
            .withoutBorder{
                border-bottom-style: 0; 
                border-bottom-color: white;
                padding-left: 0.5cm;
                line-height:40px;
                width: 25%;
            }
            .withoutBorderthin{
                border-bottom-style: 0; 
                border-bottom-color: white;
                padding-left: 0.5cm;
                line-height:40px;
                width: 10%;
            }
        </style>

        <input type="hidden" id="partyNo"></input>
        <input type="hidden" id="partyType"></input>
        <input type="hidden" id="crId"></input>
        <input type="hidden" id="bizUnit"></input>
        <input type="hidden" id="bookEntity"></input>
        <input type="hidden" id="dataSourceAppId"></input>
        <input type="hidden" id="novaSubAcctId"></input>

        <input type="hidden" id="action"></input>
        <input type="hidden" id="isNew"></input>
        <input type="hidden" id="isEdit"></input>
        <input type="hidden" id="hiddenGroupId"></input>

        <div class="page-title">Limit Application</div>
        <div align="left" id="sendRequestButton" class="sendRequestButton">

            <input type="button" class="k-button" style="display: none; background-color: blue; color: white;  margin-left: 9px; width: 80px" value="Save" id="save" onclick="onActions('SAVE')"></input>

            <input type="button" class="k-button" style="display: none; background-color: blue; color: white;  margin-left: 9px; width: 80px" value="Discard" id="discard" onclick="onActions('DISCARD')"></input>

            <input type="button" class="k-button" style="display: none; background-color: blue; color: white;  margin-left: 9px; width: 80px" value="Submit" id="submit" onclick="onActions('SUBMIT')"></input>

            <input type="button" class="k-button" style="display: none; background-color: blue; color: white;  margin-left: 9px; width: 80px" value="Return" id="return" onclick="onActions('RETURN')"></input>

            <input type="button" class="k-button" style="display: none; background-color: blue; color: white;  margin-left: 9px; width: 80px" value="Endose" id="endose" onclick="onActions('ENDOSE')"></input>

            <input type="button" class="k-button" style="display: none; background-color: blue; color: white;  margin-left: 9px; width: 80px" value="Approve" id="approve" onclick="onActions('APPROVE')"></input>

            <input type="button" class="k-button" style="display: none; background-color: blue; color: white;  margin-left: 9px; width: 80px" value="Reject" id="reject" onclick="onActions('REJECT')"></input>

            <input type="button" class="k-button" style="display: none; background-color: blue; color: white;  margin-left: 9px; width: 190px" value="Approve With Condition" id="approve_With_condition" onclick="onActions('APPROVE_WITH_COND')"></input>

            <input type="button" class="k-button" style="display: none; background-color: blue; color: white;  margin-left: 9px; width: 80px" value="Verify" id="verify" onclick="onActions('VERIFY')"></input>

            <input type="button" class="k-button" style="display: none; background-color: blue; color: white;  margin-left: 9px; width: 80px" value="Checker" id="checker" onclick="onActions('CHECKER')"></input>

        </div>
        <br>
        <div align="right" id="gridCal" class="sendRequestButton">
            <!-- <input type="button" class="k-button" style="background-color: blue; color: white; width: 100px" value="Save Grid" onclick=""></input> -->
            <input type="button" class="k-button" style="background-color: blue; color: white; width: 150px" value="Re-Calculate" id="recalculateButton" onclick="recalculate()"></input>
            <input type="button" class="k-button" style="background-color: blue; color: white; width: 80px" value="Reset" onclick="makeAllFieldsOfGridBeEmpty()"></input>
        </div>
        <div id="grid"></div>
        <br>
        
        <div style="float: both"><br><br></div>

        <div id="buttonBlock">
            
            <!-- <input type="button" class="k-button" style="background-color: blue; color: white; float: right; padding-left: 10px; margin-left: 9px; width: 80px" value="Delete"></input> -->
            <input type="button" class="k-button" style="background-color: blue; color: white; float: right; padding-left: 10px; margin-left: 9px; width: 80px" value="Update" onclick="updateToCapturedDatasource()"></input>
            <input type="button" class="k-button" style="background-color: blue; color: white; float: right; padding-left: 10px; margin-left: 9px; width: 80px" value="Reset" onclick="onClickNewButton()"></input>
            <input type="button" class="k-button" style="background-color: blue; color: white; float: right; padding-left: 10px; margin-left: 9px; width: 80px" value="New" onclick="onClickNewButton()"></input>

        </div>

        <div style="display: none" id="mainContainer">
        <div id="block1to2">
            <!-- Appr Matrix Information -->
            <table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-color: white;">
                <tr>
                    <td class="tableTitle" colspan="4">Approval Matrix Information</td>
                </tr>
                <tr>
                    <td class="withBorder">Business Unit</td>
                    <td class="withBorder">
                    <span id="approvalBizUnit"></span>
                    </td>
                    <td class="withBorder">Approval Matrix Option</td>
                    <td class="withBorder"> 
                        <select class="select_join" id="approvalMatrixOption"></select>
                    </td>
                </tr>
            </table>
            
            <br>
            
            <!-- Group Information -->
            <table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-color: white;">
                <tr>
                    <td class="tableTitle" colspan="4">
                        Group Information
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Internal Credit Rating (Basel)</td>
                    <td class="withoutBorder">
                        <span id="groupCreditRatingInr"></span></td>
                    <td class="withoutBorder">Credit Rating - Moody's</td>
                    <td class="withoutBorder"> 
                        <span id="groupCreditRatingMoody"></span>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Credit Rating (S&P)</td>
                    <td class="withoutBorder"> 
                        <span id="groupCreditRatingSnp"></span></td>
                    <td class="withoutBorder">Credit Rating - Fitch</td>
                    <td class="withoutBorder">
                        <span id="groupCreditRatingFitch"></span>
                    </td>
                </tr>
                <tr>
                    <td class="withBorder">Risk Rating for Approval</td>
                    <td class="withBorder">
                        <span id="groupRiskRatingForAppr"></span>
                    </td>
                    <td class="withBorder"></td>
                    <td class="withBorder"></td> 
                </tr>
            </table>

            <br>

            <!-- Apply Limit to -->
            <table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-color: white;">
                <tr>
                    <td class="tableTitle" colspan="4">
                        Apply Limit to
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Business Unit</td>
                    <td class="withoutBorder" colspan="3">
                        <select class="select_join" style="width:47%" id="bizUnitDropDown"></select>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Client/Counter Party Hierarchy</td>
                    <td class="withoutBorder"><input checked type="radio" onclick="enableRadioTextField(this)" name="radioSet" id="group" value="group"></input> <label for="group">Group Name</label> </td> 
                    <td class="withoutBorder"><span id="groupName"></span></td>
                    <td class="withoutBorder"></td>
                </tr>
                <tr>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"><input onclick="enableRadioTextField(this)" type="radio" name="radioSet" id="ccpty" value="ccpty"></input> <label for="ccpty">Client / Counter Party</label> </td> 
                    <td class="withoutBorder"><select style="background-color: #ccc" onChange="renewCcptyInfo(this)" id="ccptyRadioText" disabled class="select_join"></select></td>
                    <td class="withoutBorder"></td>
                </tr>
                <tr>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"><input onclick="enableRadioTextField(this)" type="radio" name="radioSet" id="account" value="account"></input> <label for="account">Account</la></td> 
                    <td class="withoutBorder"><select onchange="renewAcctInfo(this)" style="background-color: #ccc" id="accountRadioText" disabled class="select_join"></select></td>
                    <td class="withoutBorder"></td>
                </tr>
                <tr>
                    <td class="withBorder"></td>
                    <td class="withBorder"><input onclick="enableRadioTextField(this)" id="subAccount" value="subAccount" type="radio" name="radioSet"></input><label for="subAccount"> Sub-Account</label></td> 
                    <td class="withBorder"><select onchange="renewSubAcctInfo(this)" id="subAccountRadioText" style="background-color: #ccc" disabled class="select_join"></select></td>
                    <td class="withBorder"></td>
                </tr>
            </table>

            <br></br>

            <!-- Client / CounterParty Information -->
            <table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-color: white;">
                <tr>
                    <td class="tableTitle" colspan="4">
                        Client / CounterParty Information
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Connected Party</td>
                    <td class="withoutBorder"><span id="connectedPartyType"></span></td>
                    <td class="withoutBorder">Country of Domicile</td>
                    <td class="withoutBorder"><span id="countryOfDomicile"></span></td>
                </tr>
                <tr>
                    <td class="withoutBorder">Internal Credit Rating (Basel)</td>
                    <td class="withoutBorder"><span id="creditRatingInr"></span></td>
                    <td class="withoutBorder">Credit Rating - Moody's</td>
                    <td class="withoutBorder"><span id="creditRatingMoody"></span></td>
                </tr>
                <tr>
                    <td class="withoutBorder">Credit Rating S&P</td>
                    <td class="withoutBorder"><span id="creditRatingSnp"></span></td>
                    <td class="withoutBorder">Credit Rating - Fitch</td>
                    <td class="withoutBorder"><span id="creditRatingFitch"></span></td> 
                </tr>
                <tr>
                    <td class="withoutBorder">Risk Rating - For Approved</td>
                    <td class="withoutBorder"><span id="riskRatingForApproval"></span></td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                </tr>
                <tr>
                    <td class="withBorder">Chargor</td>
                    <td class="withBorder"><input type="text" style="width: 80%" class="k-textbox" id="chargor"></input></td>
                    <td class="withBorder">Operating / Investment Holding</td>
                    <td class="withBorder"><span id="holdingType"></span></td>
                </tr>
            </table>

            <br></br>

            <!-- Facility Recommended -->
            <table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-color: white;">
                <tr>
                    <td class="tableTitle" colspan="4">
                        Facility Recommended
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Facility</td>
                    <td class="withoutBorder"><span id="facId"></span></td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                </tr>
                <tr>
                    <td class="withoutBorder">* Limit Category</td>
                    <td class="withoutBorder"><select onchange="getHierList()" class="select_join" style="width: 80%" id="lmtCategory"></select></td>
                    <td class="withoutBorder">* Limit Hierachy Level</td>
                    <td class="withoutBorder"><select onchange="getLimitType()" class="select_join" style="width: 80%" id="lmtTypeHierLvlId"></select></td>
                </tr>
                <tr>
                    <td class="withoutBorder">* Limit Type</td>
                    <td class="withoutBorder"><select onchange="onChangeLimitType(this)" class="select_join" style="width: 80%" id="lmtTypeCode"></select></td>
                    <td class="withoutBorder">Facility Purpose</td>
                    <td class="withoutBorder"><input type="text" class="k-textbox" style="width: 80%;" id="facPurpose"></input></td> 
                </tr>
                <tr>
                    <td class="withoutBorder">Lending Unit</td>
                    <td class="withoutBorder">
                        <select multiple style="width: 80%; height: 150px" id="lendingUnit">
                            <option value="BOCIH">BOCIH</option>
                            <option value="BOCIL">BOCIL</option>
                            <option value="BOCICNF">BOCICNF</option>
                            <option value="BOCIS">BOCIS</option>
                            <option value="BOCIGCH">BOCIGCH</option>
                            <option value="BOCIGC">BOCIGC</option>
                            <option value="BOCIAsia">BOCIAsia</option>
                            <option value="BOCIH(USA)">BOCIH(USA)</option>
                            <option value="BOCI(USA)">BOCI(USA)</option>
                            <option value="BOCICNF(USA)">BOCICNF(USA)</option>
                            <option value="BOCIFP">BOCIFP</option>
                            <option value="BOCISG">BOCISG</option>
                            <option value="BOCICNFSG">BOCICNFSG</option>
                            <option value="BOCICTSG">BOCICTSG</option>
                            <option value="BOCISGH">BOCISGH</option>
                            <option value="BOCIUK">BOCIUK</option>
                            <option value="BOCIGC(UK)">BOCIGC(UK)</option>
                        </select>
                    </td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                </tr>
                <tr>
                    <td class="withoutBorder">Existing Facility Limit</td>
                    <td class="withoutBorder"><span id="existLmtCcy"></span><span id="existLmtAmt"></span></td>
                    <td class="withoutBorder">New Facility Limit</td>
                    <td class="withoutBorder">
                        <select class="select_join" style="width: 30%" id="newLmtCcy"></select>
                        <input class="k-textbox" style="width: 50%;" type="text" id="newLmtAmt"></input>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder">Counter Offer : New Facility Limit</td>
                    <td class="withoutBorder"><label id="coLmtCcy"></label><input class="k-textbox" id="coLmtAmt" style="width: 80%" type="text"></input></td>
                </tr>
                <tr>
                    <td class="withoutBorder">Existing Expiry Date</td>
                    <td class="withoutBorder"><span id="existLmtExpiryDate"></span></td>
                    <td class="withoutBorder">New Expiry Date</td>
                    <td class="withoutBorder"> 
                        <input style="width: 85%" id="newLmtExpiryDateField"></input>
                    </td> 
                </tr>
                <tr>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder">Counter Offer : New Expiry Date</td>
                    <td class="withoutBorder"><input style="width: 85%" id="coLmtExpiryDate"></input></td> 
                </tr>
                <tr>
                    <td class="withoutBorder">CCF (%)</td>
                    <td class="withoutBorder"><span id="ccfRatio"></span></td>
                    <td class="withoutBorder">Limit Risk Rating</td>
                    <td class="withoutBorder"><input type="text" class="k-textbox" style="width: 85%" id="lmtRiskRating"></input></td> 
                </tr>
                <tr>
                    <td class="withoutBorder">Existing Loan Equivalent Exposures</td>
                    <td class="withoutBorder"><span id="existLeeCcy"></span></td>
                    <td class="withoutBorder">Last Approval Date</td>
                    <td class="withoutBorder"><span id="lastApprovalDate"></span></td> 
                </tr>
                <tr>
                    <td class="withoutBorder">Existing Limit Amount x CCF</td>
                    <td class="withoutBorder"><span id="existCcfLmtAmtCcy"></span><span id="existCcfLmtAmt"></span></td>
                    <td class="withoutBorder">New Limit Amount x CCF</td>
                    <td class="withoutBorder"><span id="newCcfLmtAmtCcy"></span><span id="newCcyLmtAmt"></span></td> 
                </tr>
                <tr>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder">Counter Offer : New Limit Amount x CCF</td>
                    <td class="withoutBorder"><span id="coNewCcfLmtCcy"></span><span id="coNewCcfLmtAmt"></span></td> 
                </tr>
                <tr>
                    <td class="withoutBorder">Collateral Type</td>
                    <td class="withoutBorder"><select style="width: 85%" class="select_join" id="collType"></select></td>
                    <td class="withoutBorder">Limit Tenor</td>
                    <td class="withoutBorder"><input type="text" maxlength="2" class="k-textbox" style="width: 45%" id="lmtTenor"></input><input type="radio" name="lmtTenorUnit" id="month" value="month"><label for="month">Month</label></input><label>&nbsp;</label><input type="radio" id="year" name="lmtTenorUnit" value="year"><label for="year">Year</label></input></td> 
                </tr>
                <tr>
                    <td class="withoutBorder">Is Batch Upload</td>
                    <td class="withoutBorder"><span id="isBatchUpload"></span></td>
                    <td class="withoutBorder">Is Annual Limit Review</td>
                    <td class="withoutBorder"><span id="isAnnualLmtReview"></span></td> 
                </tr>
            </table>

            <br></br>

            <!-- Premium Financing Limit -->
            <table border="0" id="pfl-table" width="100%" cellpadding="0" cellspacing="0" style="border-color: white; ">
                <tr>
                    <td class="tableTitle" colspan="4">Premium Financing Limit</td>
                </tr>
                <tr>
                    <td class="withoutBorder">Loan Amount (Minimum USD 1M)</td>
                    <td class="withoutBorder"><select class="select_join" id="pfLoanCcy" style="width: 30%"></select>
                        <input type="text" class="k-textbox" id="pfLoanAmt"></input>
                    </td>
                    <td class="withoutBorder">Loanable Currency</td>
                    <td class="withoutBorder"><select style="width: 50%; height: 100px" id="pfCurrency" multiple></select></td>
                </tr>
            </table>
            
            <!-- Shareholder Loan Limit -->
            <table border="0" id="shl-table" width="100%" cellpadding="0" cellspacing="0" style="border-color: white; ">
                <tr>
                    <td class="tableTitle" colspan="4">Shareholder Loan Limit</td>
                </tr>
                <tr>
                    <td class="withoutBorder">Underlying Stock Code</td>
                    <td class="withoutBorder">
                        <input type="text" class="k-textbox" style="width: 100%" id="underlyingStkCode"></input>
                    </td>
                    <td class="withoutBorder">Underlying Stock Market Code</td>
                    <td class="withoutBorder">
                        <input type="text" class="k-textbox" style="width: 50%; height: 100%" id="underlyingStkMktCode"></select>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Shareholder Role</td>
                    <td class="withoutBorder">
                        <input type="text" class="k-textbox" id="shareHolderRole" style="width: 100%"></input>
                    </td>
                    <td class="withoutBorder">Total Quantity in Market</td>
                    <td class="withoutBorder" align="left"><input type="text" class="k-textbox" id="shlTotQtyHeldInMrkt" style="width: 100%"></input></td>
                </tr>
                <tr>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder" align="left"><input type="button" onclick="updateShareHolderScope()" class="k-button" value="Update"></td>
                </tr>

                <tr>
                    <td colspan="4">
                        <br>
                        <div id="shareHolderScope"></div>
                        <br>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Breach</td>
                    <td class="withoutBorder"><input type="radio" name="isShlBreach" id="isShlBreachY" value="Y"></input> <label for="isShlBreachY">YES</label><label> &nbsp; &nbsp; </label><input type="radio" name="isShlBreach" id="isShlBreachN" value="N"></input> <label for="isShlBreachN">NO</label></td>
                    <td class="withoutBorder">Breach Details</td>
                    <td class="withoutBorder"><input class="k-textbox" type="text" id="shlBreachDetail" style="width: 80%"></input></td>
                </tr>
                <tr>
                    <td class="withBorder">Breach Handling / Approval Obtained</td>
                    <td class="withBorder"><input class="k-textbox" type="text" id="shlBreachHaObtain" style="width: 80%"></input></td>
                    <td class="withBorder"></td>
                    <td class="withBorder"></td>
                </tr>
            </table>

            <!-- Stock Borrowing and Lending / Repo Limits -->
            <table id="sbl-rl-table" border="0" width="100%" cellpadding="0" cellspacing="0" style="border-color: white; ">
                <tr>
                    <td class="tableTitle" colspan="4">Stock Borrowing and Lending / Repo Limits</td>
                </tr>
                <tr>
                    <td class="withoutBorder">Excess Cash Recall Buffer</td>
                    <td class="withoutBorder">
                        <input type="text" class="k-textbox" id="sblrExcessCashRecallBuf" style="width: 80%"></input>
                    </td>
                    <td class="withoutBorder">Margin Call Buffer</td>
                    <td class="withoutBorder">
                        <input type="text" class="k-textbox" id="sblrMarginCallBuf" style="width: 80%"></input>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Borrowing Initial Margin Requirement</td>
                    <td class="withoutBorder">
                        <input type="text" class="k-textbox" id="sblrBorrowImRatio" style="width: 80%"></input>
                    </td>
                    <td class="withoutBorder">Lending Initial Margin Requirement</td>
                    <td class="withoutBorder">
                        <input type="text" class="k-textbox" id="sblrLendImRatio" style="width: 80%"></input>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Repo Stock Standard Margin Ratio</td>
                    <td class="withoutBorder">
                        <input type="text" class="k-textbox" id="sblrRepoStockMarginRatio" style="width: 80%"></input>
                    </td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                </tr>
                <tr>
                    <td class="withBorder">SBL Volatility(%)</td>
                    <td class="withBorder">
                        <span id="sblrSblVolatility"></span>
                    </td>
                    <td class="withBorder">Repo Volatility(%)</td>
                    <td class="withBorder">
                        <span id="sblrRepoVolatility"></span>
                    </td>
                </tr>
            </table>


            <!-- Daily Settlement Limit / DVP Limit -->
            <table border="0" id="dsl-dvp-table" width="100%" cellpadding="0" cellspacing="0" style="border-color: white; ">
                <tr>
                    <td class="tableTitle" colspan="4">Daily Settlement Limit / DVP Limit</td>
                </tr>
                <tr>
                    <td class="withBorder">Applied Product Type</td>
                    <td class="withBorder"><select multiple id="dvpProdList" style="width: 80%"></select></td>
                    <td class="withBorder">Other Please Specify</td>
                    <td class="withBorder"><input type="text" id="dslOtherProdTypeDesc" style="width: 80%" class="k-textbox"></input></td>
                </tr>
            </table>
            
            <!-- Future Deposit Limit -->
            <table border="0" id="fdl-table" width="100%" cellpadding="0" cellspacing="0" style="border-color: white; ">
                <tr>
                    <td class="tableTitle" colspan="4">Future Deposit Limit</td>
                </tr>
                <tr>
                    <td class="withoutBorder">Initial Margin Requirement</td>
                    <td class="withoutBorder">
                        <input type="text" id="fdImRatio" style="width: 80%" class="k-textbox"></input>
                    </td>
                    <td class="withoutBorder">Grace Period</td>
                    <td class="withoutBorder">
                        <input type="text" id="fdGreyPeriodDay" style="width: 80%" class="k-textbox"></input>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Upfront Margin Applied With Pre-Deal Control</td>
                    <td class="withoutBorder">
                        <input type="radio" name="fdIsUfMarginWPdCntl" id="fdIsUfMarginWPdCntlY" value="Y"></input> <label for="fdIsUfMarginWPdCntlY">YES</label><label> &nbsp; &nbsp; </label><input type="radio" name="fdIsUfMarginWPdCntl" id="fdIsUfMarginWPdCntlN" value="N"></input> <label for="fdIsUfMarginWPdCntlN">NO</label>
                    </td>
                    <td class="withoutBorder">Loan to be provided</td>
                    <td class="withoutBorder">
                        <input type="radio" name="fdIsLoanProvide" id="fdIsLoanProvideY" value="Y"></input> <label for="fdIsLoanProvideY">YES</label><label> &nbsp; &nbsp; </label><input type="radio" name="fdIsLoanProvide" id="fdIsLoanProvideN" value="N"></input> <label for="fdIsLoanProvideN">NO</label>
                    </td>
                </tr>
                <tr>
                    <td class="withBorder">Deferal Allowed</td>
                    <td class="withBorder">
                    <input type="radio" name="fdIsDefferralAllow" id="fdIsDefferralAllowY" value="Y"></input> <label for="fdIsDefferralAllowY">YES</label><label> &nbsp; &nbsp; </label><input type="radio" name="fdIsDefferralAllow" id="fdIsDefferralAllowN" value="N"></input> <label for="fdIsDefferralAllowN">NO</label>
                    </td>
                    <td class="withBorder">Other Controls</td>
                    <td class="withBorder">
                        <input type="text" id="fdOtherControl" style="width: 80%" class="k-textbox"></input>
                    </td>
                </tr>
            </table>

            <!-- Loan for margin deposit limit -->
            <table border="0" id="mdl-table" width="100%" cellpadding="0" cellspacing="0" style="border-color: white; ">
                <tr>
                    <td class="tableTitle" colspan="4">Loan for margin deposit limit</td>
                </tr>
                <tr>
                    <td class="withBorder">Loan Coverage</td>
                    <td class="withBorder" align="left">
                    <select id="lmdLoanAgreementType" class="select_join" style="width: 80%">
                        <option value="LMD_IMREQ_FLOATPNL">Loan for Margin Deposit cover IM Requirement and Floating P&L</option>   
                        <option value="LMD_IMREQ_FLOATPNL_NEBAL">Loan for Margin Deposit cover IM Requirement and Floating P&L, and Negative Cash Balance</option>   
                    </select>
                    </td>
                    <td class="withBorder"></td>
                    <td class="withBorder"></td>
                </tr>
            </table>

            <br><br>

            <!-- Loan for margin deposit limit -->
            <table border="0" id="idl-table" width="100%" cellpadding="0" cellspacing="0" style="border-color: white; ">
                <tr>
                    <td class="tableTitle" colspan="4">Interbank & Deposit Limit / Interbank & Deposit limit (Treaury) / Interbank & Deposit Limit (LC Discounting Bank) / Interbank & deposit Limit (LC) Issuing Bank / Interbank & Deposit Limit (LC Pledge Bank)</td>
                </tr>
                <tr>
                    <td colspan="4">&nbsp;</td>
                </tr>
                <tr>
                    <td class="withBorder">Max Tenor Allow</td>
                    <td class="withBorder"><input type="text" maxlength="2" id="ibdMaxTenorAllow" style="width: 80%" class="k-textbox" id=""></input></td>
                    <td class="withBorder"><input type="radio" name="ibdMaxTenorAllowUnit" id="ibdMaxTenorAllowUnitMonth" value="month"><label for="ibdMaxTenorAllowUnitMonth">Month</label></input><label>&nbsp;</label><input type="radio" id="ibdMaxTenorAllowUnitYear" name="ibdMaxTenorAllowUnit" value="year"><label for="ibdMaxTenorAllowUnitYear">Year</label></input></td>
                    <td class="withBorder"></td>
                </tr>
                <tr>
                    <td colspan="4">&nbsp;</td>
                </tr>
            </table>

            <!-- Physical Repo Limit -->
            <table border="0" id="prl-table" width="100%" cellpadding="0" cellspacing="0" style="border-color: white; ">
                <tr>
                    <td class="tableTitle" colspan="4">Physical Repo Limit</td>
                </tr>
                <tr>
                    <td class="withoutBorder">Applied Product Type</td>
                    <td class="withoutBorder">
                        <select id="prProdType" multiple style="width: 80%"></select>
                    </td>
                    <td class="withoutBorder">Other. Please Specific</td>
                    <td class="withoutBorder">
                        <input type="text" id="prlOtherProdTypeDesc" class="k-textbox" style="width: 80%"></input>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Max Tenor Allowed</td>
                    <td colspan="3" class="withoutBorder">
                        <input type="text" id="prlMaxTenorAllow" maxlength="2" class="k-textbox" style="width: 15%"></input>
                        <input type="radio" name="prlMaxTenorAllowUnit" id="prlMaxTenorAllowUnitMonth" value="month"><label for="prlMaxTenorAllowUnitMonth">Month</label></input><label>&nbsp;</label><input type="radio" id="prlMaxTenorAllowUnitYear" name="prlMaxTenorAllowUnit" value="year"><label for="prlMaxTenorAllowUnitYear">Year</label></input>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Hair Cut Ratio Applied</td>
                    <td class="withoutBorder">
                       <input type="text" id="prlHaircutRatio" class="k-textbox" name="prlHaircutRatio" style="width: 85%"></input> Days
                    </td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                </tr>
            </table>

             <!-- PME Limit -->
            <table border="0" id="pme-table" width="100%" cellpadding="0" cellspacing="0" style="border-color: white; ">
                <tr>
                    <td class="tableTitle" colspan="4">PME Limit</td>
                </tr>
                <tr>
                    <td class="withoutBorder">Applied Exposure Type</td>
                    <td class="withoutBorder">
                        <select id="pmeExpoType" multiple style="width: 100%"></select>
                    </td>
                    <td class="withoutBorder">Other. Please Specific</td>
                    <td class="withoutBorder">
                        <input type="text" id="pmeOtherExpoType" class="k-textbox" style="width: 80%"></input>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Max Tenor Allowed</td>
                    <td colspan="3" class="withoutBorder">
                        <input type="text" id="pmeMaxTenorAllow" maxlength="2" class="k-textbox" style="width: 15%"></input>
                        <input type="radio" name="pmeMaxTenorAllowUnit" id="pmeMaxTenorAllowUnitMonth" value="month"><label for="pmeMaxTenorAllowUnitMonth">Month</label></input><label>&nbsp;</label><input type="radio" id="pmeMaxTenorAllowUnitYear" name="pmeMaxTenorAllowUnit" value="year"><label for="pmeMaxTenorAllowUnitYear">Year</label></input>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Grace Period</td>
                    <td class="withoutBorder">
                       <input type="text" id="pmeGreyPeriod" maxlength="3" class="k-textbox" name="pmeGreyPeriod" style="width: 85%"></input> Days
                    </td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                </tr>
                
                <tr>
                    <td class="withoutBorder">ISDA ID</td>
                    <td class="withoutBorder">
                        <input type="button" onclick="onClickSearchIsda()" class="k-button" value="Search"></input>
                    </td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                </tr>
                <tr>
                    <td colspan="4">
                        <div id="isdaResultGrid"></div>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">CSA ID</td>
                    <td class="withoutBorder"><input type="button" class="k-button" onclick="onClickSearchCsa()"  value="Search"></input></td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                </tr>
                <tr>
                    <td colspan="4">
                        <div id="csaResultGrid"></div>
                    </td>
                </tr>
            </table>

            <!-- Warehouse Unit -->
            <table border="0" id="whu-table" width="100%" cellpadding="0" cellspacing="0" style="border-color: white; ">
                <tr>
                    <td class="tableTitle" colspan="4">Warehouse Unit</td>
                </tr>
                <tr>
                    <td colspan="4">&nbsp;</td>
                </tr>
                <tr>
                    <td class="withoutBorder">Applied Product Types</td>
                    <td class="withoutBorder"><select multiple id="whlProdList"style="width: 80%"></select></td>
                    <td class="withoutBorder">Other, Please Specify</td>
                    <td class="withoutBorder"><input type="text" id="whlOtherProdTypeDesc" class="k-textbox" style="width: 80%"></input></td>
                </tr>
                <tr>
                    <td class="withoutBorder">Other Controls</td>
                    <td class="withoutBorder"><input type="text" class="k-textbox" style="width: 80%" id="whlOtherControl"></input></td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                </tr>
                <tr>
                    <td colspan="4">&nbsp;</td>
                </tr>
            </table>

            <br><br>

            <!-- Limit Allocation / Sub Participation Information -->
            <table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-color: white; ">
                <tr>
                    <td class="tableTitle" colspan="4">Limit Allocation / Sub Participation Information</td>
                </tr>
                <tr>
                    <td colspan="4">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="4" align="right">
                        <input type="button" class="k-button" value="Update" onclick="updateLmtAllocGrid()" style=" margin-left: 9px; width: 80px"></input>
                    </td>
                </tr>
                <tr>
                    <td colspan="4">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="4">&nbsp;</td>
                </tr>
                <tr>
                    <td class="withoutBorder">Entity</td>
                    <td class="withoutBorder">
                        <select id="lspEntityId" class="select_join" style="width: 80%">
                            <option value="BOCIH">BOCIH</option>
                            <option value="BOCIL">BOCIL</option>
                            <option value="BOCICNF">BOCICNF</option>
                            <option value="BOCIS">BOCIS</option>
                            <option value="BOCIGCH">BOCIGCH</option>
                            <option value="BOCIGC">BOCIGC</option>
                            <option value="BOCIAsia">BOCIAsia</option>
                            <option value="BOCIH(USA)">BOCIH(USA)</option>
                            <option value="BOCI(USA)">BOCI(USA)</option>
                            <option value="BOCICNF(USA)">BOCICNF(USA)</option>
                            <option value="BOCIFP">BOCIFP</option>
                            <option value="BOCISG">BOCISG</option>
                            <option value="BOCICNFSG">BOCICNFSG</option>
                            <option value="BOCICTSG">BOCICTSG</option>
                            <option value="BOCISGH">BOCISGH</option>
                            <option value="BOCIUK">BOCIUK</option>
                            <option value="BOCIGC(UK)">BOCIGC(UK)</option>
                        </select>
                    </td>
                    <td class="withoutBorder">Allocation Percentage</td>
                    <td class="withoutBorder"><input id="lspAllocateRatio" type="text" class="k-textbox" style="width: 80%"></input></td>
                </tr>
                <tr>
                    <td colspan="4">
                        <br>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" class="withoutBorder">
                        <div id="lmtApplicationScope"></div>
                    </td>
                </tr>
                <tr>
                    <td colspan="4">&nbsp;</td>
                </tr>
            </table>

             <!-- Proposed Pricing -->
            <table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-color: white;">
                <tr>
                    <td class="tableTitle" colspan="4">Proposed Pricing</td>
                </tr>
                <tr>
                    <td colspan="4">&nbsp;</td>
                </tr>
                <tr>
                    <td class="withoutBorder">Proposed Pricing</td>
                    <td class="withoutBorder" colspan="3">
                        <select class="select_join" id="ppProposePrice" style="width : 40%">
                            <option value="COF_H_L">COF/H/L (whichever is higher)</option>
                            <option value="PRI_RATE">Prime rate</option>
                            <option value="H_L">H/L (whichever is higher)</option>
                            <option value="COF">COF</option>
                            <option value="HIBOR">Hibor</option>
                            <option value="LIBOR">Libor</option>
                        </select>
                        <select class="select_join" type="text" id="ppRatioSign"        style="width : 10%">
                            <option value="PLUS"><font size="15px">+</font></option>
                            <option value="MINUS"><font size="15px">-</font></option>
                        </select>
                        <input  class="k-textbox"   type="text" id="ppRatio"    style="width : 10%"></input>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Fee & Commission</td>
                    <td class="withoutBorder"><input type="text" class="k-textbox" style="width : 80%" id="ppFeeComm"></input></td>
                    <td class="withoutBorder">Arrangement / Handling Fee</td>
                    <td class="withoutBorder"><input type="text" class="k-textbox" style="width : 80%" id="ppArrangeHandleFee"></input></td>
                </tr>
                <tr>
                    <td class="withoutBorder">Others</td>
                    <td class="withoutBorder"><input type="text" id="ppOthers" class="k-textbox" style="width : 80%"></input></td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                </tr>
                <tr>
                    <td colspan="4">&nbsp;</td>
                </tr>
            </table>

             <!-- Guarantor (required for all corporate borrowers) / Collateral Provider Information  -->
            <table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-color: white;">
                <tr>
                    <td class="tableTitle" colspan="4">Guarantor (required for all corporate borrowers) / Collateral Provider Information </td>
                </tr>
                <tr>
                    <td colspan="4">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="4" align="right">
                        <input type="button" class="k-button" style=" margin-left: 9px; width: 80px" value="Search" onclick="openSearchGuarGrid()"></input>
                        <input type="button" class="k-button" style=" margin-left: 9px; width: 80px" value="Update" onclick="updateGuarGrid()"></input>
                        <input type="button" class="k-button" style=" margin-left: 9px; width: 80px" value="Reset" onclick="resetGuarGrid()"></input>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Guarantor ID</td>
                    <td class="withoutBorder"><span id="guarId"></span> </td> 
                    <td class="withoutBorder">Guarantor Name </td> 
                    <td class="withoutBorder"><span id="guarName"></span></td> 
                </tr>
                <tr>
                    <td class="withoutBorder">Guarantor Domicile</td>
                    <td class="withoutBorder"><span id="guarDomicile"></span></td>
                    <td class="withoutBorder">Address</td>
                    <td class="withoutBorder"><span id="guarAddress"></span></input></td>
                </tr>
                <tr>
                    <td class="withoutBorder">Relationship with Borrower</td>
                    <td class="withoutBorder"><input type="text" class="k-textbox" style="width : 80%" id="relWBorrower"> </td>
                    <td class="withoutBorder">Support Type</td>
                    <td class="withoutBorder"><input type="text" class="k-textbox" style="width : 80%" id="suppType"> </td>
                </tr> 
                <tr>
                    <td class="withoutBorder">Limited / Unlimited Amount</td>
                    <td class="withoutBorder" colspan="3">
                    <input type="radio" name="amtType" id="amtTypeY" value="limited"></input> 
                    <span for="amtTypeY">Limited Account</span>
                    <span> &nbsp; &nbsp; </span>
                    <input type="radio" name="amtType" id="amtTypeN" value="unlimited"></input> 
                    <span for="amtTypeN">Unlimited Account</span></td>
                </tr>
                <tr>
                    <td class="withoutBorder">Guarantee / Collateral Amount Cap</td>
                    <td class="withoutBorder">
                        <select class="select_join" id="guarCollCapCcy" style="width: 25%"></select>
                        <input type="text" class="k-textbox" style="width : 65%" id="guarCollCapAmt"></td>
                    <td class="withoutBorder">Guarantee Expiry Date (yyyy/mm/dd)</td>
                    <td class="withoutBorder">
                        <input style="width: 80%" id="guarExpiryDate"></input>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Notice Period</td>
                    <td class="withoutBorder"><input type="text" id="noticePeriod" style="width: 80%" class="k-textbox"></input></td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                </tr>
                <tr>
                    <td colspan="4">&nbsp;</td>
                </tr>
                <tr>
                    <td class="withBorder" colspan="4">
                        <div id="guarantorGridScope"></div>
                        <br>
                    </td>
                </tr>
                <tr>
                    <td colspan="4"><br><br></td>
                </tr>
        </table>
        </div>
        <div id="block3">
            <!-- Documents -->
            <table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-color: white;">
                <tr>
                    <td class="tableTitle" colspan="5">Documents</td>
                </tr>
                <tr>
                    <td colspan="5">&nbsp;</td>
                </tr>
                <tr>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder">
                        <input type="button" class="k-button" value="Update" onclick="submitUpload()"></input>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">File Description</td>
                    <td class="withoutBorder"><input type="text" class="k-textbox" id="fileDescription"></input></td>
                    <td class="withoutBorder" colspan="3">File Path <input name="uploadFile" id="uploadFile" type="file"/>
                </tr>
                <tr>
                    <td colspan="5">&nbsp;</td>
                </tr>
                <tr>
                    <td class="withBorder" colspan="5">
                        <div id="fileDetailGrid" style="width: 100%"></div>
                    </td>
                </tr>
                <tr>
                    <td colspan="5">&nbsp;</td>
                </tr>
            </table>

            <!-- Remarks -->
            <table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-color: white;">
                <tr>
                    <td class="tableTitle" colspan="5">Remarks</td>
                </tr>
                <tr>
                    <td colspan="5">&nbsp;</td>
                </tr>
                <tr>
                    <td class="withoutBorder">Remarks Content of Current Request</td>
                    <td class="withoutBorder" colspan="3">
                        <!-- <select id="remarkAllList" multiple disabled style="width: 100%; height: 200px">
                        </select> -->
                        <div id="remarkAllList"/>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Remarks Category</td>
                    <td class="withoutBorder" colspan="3">
                        <select id="remarksCat" class="select_join" style="width: 35%"></select>  
                        <input type="button" value="Add" class="k-button" onclick="toAddRemarks()"/>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Remarks</td>
                    <td class="withoutBorder" colspan="3">
                        <textarea id="crRemark" style="width: 100%; height: 100px"></textarea>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">Remarks Content of Current User</td>
                    <td class="withoutBorder" colspan="3">
                        <!-- <select id="remarkCurrUserList" multiple disabled style="width: 100%; height: 200px">
                        </select> -->
                        <div id="remarkCurrUserList"/>
                    </td>
                </tr>
                <tr>
                    <td colspan="4">&nbsp;</td>
                </tr>
                <tr>
                    <td class="withBorder"></td>
                    <td class="withBorder"></td>
                    <td class="withBorder"></td>
                    <td class="withBorder"></td>
                </tr>
            </table>

            <!-- Review Information -->
            <table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-color: white;">
                <tr>
                    <td class="tableTitle" colspan="5">Review Information</td>
                </tr>
                <tr >
                    <td align="left" class="withoutBorderthin">Role</td>
                    <td align="left" class="withoutBorderthin">Role Description</td>
                    <td align="left" class="withoutBorderthin">Name</td> 
                    <td align="left" class="withoutBorderthin">Email Address</td> 
                    <td align="left" class="withoutBorderthin">Date(yyyy/mm/dd)</td> 
                </tr>
                <tr>
                    <td align="left" class="withoutBorderthin">Business Requestor</td>
                    <td align="left" class="withoutBorderthin"><input type="text" class="k-textbox" id="riBrRoleDesc" style="width: 60%"></input></td> 
                    <td align="left" class="withoutBorderthin"><input type="text" class="k-textbox" id="riBrName"> </td> 
                    <td align="left" class="withoutBorderthin"><input type="text" class="k-textbox" id="riBrEmailAddr"> </td> 
                    <td align="left" class="withoutBorderthin"><input id="riBrReviewDate"> </td> 
                </tr>
                <tr>
                    <td align="left" class="withoutBorderthin">Business Checker</td>
                    <td align="left" class="withoutBorderthin"><input type="text" class="k-textbox" id="riBcRoleDesc" style="width: 60%"> </td> 
                    <td align="left" class="withoutBorderthin"><input type="text" class="k-textbox" id="riBcName"> </td> 
                    <td align="left" class="withoutBorderthin"><input type="text" class="k-textbox" id="riBcEmailAddr"> </td> 
                    <td align="left" class="withoutBorderthin"><input id="riBcReviewDate"> </td> 
                </tr>
                <tr>
                    <td align="left" class="withoutBorderthin">Business Approver</td>
                    <td align="left" class="withoutBorderthin"><input type="text" class="k-textbox" id="riBaRoleDesc"> </td> 
                    <td align="left" class="withoutBorderthin"><input type="text" class="k-textbox" id="riBaName"> </td> 
                    <td align="left" class="withoutBorderthin"><input type="text" class="k-textbox" id="riBaEmailAddr"> </td> 
                    <td align="left" class="withoutBorderthin"><input id="riBaReviewDate"> </td> 
                </tr>
                <tr>
                    <td class="withoutBorderthin">Business RMD Maker</td>
                    <td class="withoutBorderthin"> <span id="riMakerRoleDesc"></span> </td> 
                    <td class="withoutBorderthin"> <span id="riMakerName"></span> </td> 
                    <td class="withoutBorderthin"> <span id=""></span> </td> 
                    <td class="withoutBorderthin"> <span id="riMakerReviewDate"></span> </td> 
                </tr>
                <tr>
                    <td class="withoutBorderthin">Business RMD Checker</td>
                    <td class="withoutBorderthin"> <span id="riCheckerRoleDesc"></span> </td> 
                    <td class="withoutBorderthin"> <span id="riCheckerName"></span> </td> 
                    <td class="withoutBorderthin"> <span id=""></span> </td> 
                    <td class="withoutBorderthin"> <span id="riCheckerReviewDate"></span> </td> 
                </tr>
                <tr>
                    <td class="withoutBorderthin">Business RMD Endorser</td>
                    <td class="withoutBorderthin"> <span id="riEndorserRoleDesc"></span> </td> 
                    <td class="withoutBorderthin"> <span id="riEndorserName"></span> </td> 
                    <td class="withoutBorderthin"> <span id=""></span> </td> 
                    <td class="withoutBorderthin"> <span id="riEndorserReviewDate"></span> </td> 
                </tr>
                <tr>
                    <td class="withoutBorderthin">Business RMD Approver</td>
                    <td class="withoutBorderthin"> <span id="riApproverRoleDesc"></span> </td> 
                    <td class="withoutBorderthin"> <span id="riApproverName"></span> </td> 
                    <td class="withoutBorderthin"> <span id=""></span> </td> 
                    <td class="withoutBorderthin"> <span id="riApproverReviewDate"></span> </td> 
                </tr>
                <tr>
                    <td class="withoutBorderthin">CA Checker</td>
                    <td class="withoutBorderthin"><span id="riCaCheckerRoleDesc"></span></td> 
                    <td class="withoutBorderthin"><span id="riCaCheckerName"></span></td> 
                    <td class="withoutBorderthin"><span id=""></span></td> 
                    <td class="withoutBorderthin"><span id="riCaCheckerReviewDate"></span></td> 
                </tr>

                <tr>
                    <td class="withBorder"></td>
                    <td class="withBorder"></td>
                    <td class="withBorder"></td>
                    <td class="withBorder"></td>
                    <td class="withBorder"></td>
                </tr>
            </table>

            <!-- Supplement Information for interbank & deposit limit (treasury) approval -->
            <table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-color: white;">
                <tr>
                    <td class="tableTitle" colspan="4">Supplement Information for interbank & deposit limit (treasury) approval</td>
                </tr> 
                <tr>
                    <td class="withoutBorder" colspan="4"><br></td>
                </tr> 
                <tr>
                    <td class="withoutBorder">
                        <table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-color: white;">
                            <tr>
                                <td class="tableTitle" colspan="4">Supplement of information  of Group / Client Counterparty / Account</td>
                            </tr> 
                            <tr>
                                <td class="withBorder">
                                    <div id="supInfoOfGroupClientGrid"></div>
                                </td>
                            </tr>
                            <tr>
                                <td class="withBorder">
                                    <br>
                                </td>
                            </tr>
                            
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="withoutBorder">
                        <!-- Supplement Information of BU/Limit -->
                        <table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-color: white;">
                            <tr>
                                <td class="tableTitle" colspan="4">
                                    Supplement Information of BU/Limit
                                </td>
                            </tr>
                            <tr>
                                <td class="withoutBorder">Market Capitalization of Group</td>
                                <td class="withoutBorder"><span id="idlBuGroupMarketCap"></span></td>
                                <td class="withoutBorder"></td>
                                <td class="withoutBorder"></td>
                            </tr>
                            <tr>
                                <td class="withoutBorder">Total Approved Amount of Interbank & Deposit Limit (Treasury)</td>
                                <td class="withoutBorder"><span id="idlBuTotApproveAmtHkd"></span></td>
                                <td class="withoutBorder">Risk Tating - For Approval - BOC</td>
                                <td class="withoutBorder"><span id="idlBuBocRiskRating"></span></td>
                            </tr>
                            <tr>
                                <td class="withoutBorder">Aggregated Exceptional Approval Limit Amount</td>
                                <td class="withoutBorder"><span id="idlBuExceptApprLmtHkd"></span></td>
                                <td class="withoutBorder">Is Exceptional Approval Case</td>
                                <td class="withoutBorder"><input type="radio" name="idlBuIsExceptApprove" id="idlBuIsExceptApproveY" value="Y"></input> <span for="idlBuIsExceptApproveY">YES</span><span> &nbsp; &nbsp; </span><input type="radio" name="idlBuIsExceptApprove" id="idlBuIsExceptApproveN" value="N"></input> <span for="idlBuIsExceptApproveN">NO</span></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>

            <!-- Approval Information -->
            <table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-color: white;">
                <tr>
                    <td class="tableTitle" colspan="4">Approval Information</td>
                </tr>
                <tr>
                    <td colspan="4">&nbsp;</td>
                </tr>
                <tr>
                    <td class="withoutBorder">Last Approval Date</td>
                    <td class="withoutBorder"><span id="aiLastApproveDate"></span></td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                </tr>
                <tr>
                    <td class="withoutBorder">Override Approval Level</td>
                    <td class="withoutBorder">
                        <select class="select_join" id="overrideApprList" style="width: 100%">
                        </select>
                    </td>
                    <td class="withoutBorder"></td>
                    <td class="withoutBorder"></td>
                </tr>
                <tr>
                    <td class="withoutBorder" colspan="4"></td>
                </tr>
                <tr>
                    <td  colspan="4">
                        <!-- Approval Details -->
                        <table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-color: white;">
                            <tr>
                                <td class="tableTitle" colspan="4">Approval Details</td>
                            </tr>
                            <tr>
                                <td class="withBorder" colspan="4">
                                    <div id="apprDetailList"></div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <br>
        </div>
        <br>
        <script>

            function toAddRemarks(){
                
                var remarksCatTmp = $("#remarksCat").val();
                var remarksTmp = $("#crRemark").val();

                /*var option = document.createElement("option");
                option.value = checkUndefinedElement(remarksCatTmp + "||" + remarksTmp);
                option.text = String.format("{0} \xa0\xa0\xa0\xa0\xa0\xa0\xa0 {1}", remarksCatTmp, remarksTmp);
                document.getElementById("remarkAllList").appendChild(option);
                option = null;

                var option = document.createElement("option");
                option.value = checkUndefinedElement(remarksCatTmp + "||" + remarksTmp);
                option.text = String.format("{0} \xa0\xa0\xa0\xa0\xa0\xa0\xa0 {1} ", remarksCatTmp, remarksTmp);
                document.getElementById("remarkCurrUserList").appendChild(option);
                option = null; */

                var grid = $("#remarkAllList").data("kendoGrid");

                grid.dataSource.add({
                        remarkCat : remarksCatTmp,
                        remark : remarksTmp,
                        createBy : "",
                        createDt : "",
                        lastUpdateBy: "",
                        lastUpdateDt: ""
                    }
                );

                grid = $("#remarkCurrUserList").data("kendoGrid");
                grid.dataSource.add({
                        remarkCat : remarksCatTmp,
                        remark : remarksTmp,
                        createBy : "",
                        createDt : "",
                        lastUpdateBy: "",
                        lastUpdateDt: ""
                    }
                );
            }

            function searchByIsdaId(){

                $("#isdaGrid").html("");
                $("#isdaGrid").html("<div id=\"isdaGridDetail\"></div>");

                var getIsdaList =window.sessionStorage.getItem('serverPath')+"legalParty/searchISDA?userId="+"RISKADMIN" + "&isdaId=" + $("#pmeIsdaIdSearch").val() + "&ccdName="+$("#pmeIsdaIdSearch").val();

                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getIsdaList,   
                            cache: false,                       
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            }
                        }
                    },
                    schema:{
                        model:{
                            id: "pmeIsdaId",
                            fields:{
                                csdaId: {type: "string"}
                            }
                        }
                    }
                });    

                $('#isdaGridDetail').kendoGrid({
                
                    dataSource: dataSource,
                    cache: false,
                    editable: true,
                    columns: [  
                        {
                            width: "150px",
                            template: "#=selectIsdaIdButton(isdaId, bookEntity, isdaPaymentCcy, isdaNettingCcy, isdaNettingInstrument)#"
                        },
                        { 
                            field: "isdaId", 
                            title: "ISDA ID" ,
                            width: 100
                        },
                        { 
                            field: "bookEntity",
                            title: "Entity" ,
                            width: 100
                        },
                        { 
                            field: "isdaPaymentCcy", 
                            title: "Payment Currency" ,
                            width: 100
                        },
                        { 
                            field: "isdaNettingCcy", 
                            title: "Netting Currency" ,
                            width: 100
                        },
                        { 
                            field: "isdaNettingInstrument", 
                            title: "Netting Instrument" ,
                            width: 100
                        }
                    ]
                });
            }

            function searchByCsaId(){

                var getCsaList =window.sessionStorage.getItem('serverPath')+"legalParty/searchCSA?userId="+"RISKADMIN" + "&csaId=" + $("#csaIdSearch").val() + "&ccdName="+$("#csaIdSearch").val();

                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getCsaList,   
                            cache: false,                       
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            }
                        }
                    },
                    schema:{
                        model:{
                            id: "csaId",
                            fields:{
                                csdaId: {type: "string"}
                            }
                        }
                    }
                });    

                $('#csaIdGridDetail').kendoGrid({
                
                    dataSource: dataSource,
                    cache: false,
                    editable: true,
                    columns: [
                        {
                            width: "150px",
                            template: "#=selectCsaIdButton(csaId, bookEntity, csaCollateralCcy, csaBociThreshold, csaCptyThreshold, bociMta, csaCptyMta, csaBociIndependentAmount, csaCptyIndependentAmount, csaMarginCallFrequency)#"
                        },
                        { 
                            field: "csaId", 
                            title: "CSA ID" ,
                            width: 100
                        },
                        { 
                            field: "bookEntity",
                            title: "Entity" ,
                            width: 100
                        },
                        { 
                            field: "csaCollateralCcy", 
                            title: "CSA Collateral Currency" ,
                            width: 100
                        },
                        { 
                            field: "csaBociThreshold", 
                            title: "Threshholde To BOCI" ,
                            width: 100
                        },
                        { 
                            field: "csaCptyThreshold", 
                            title: "Threshholde To Counterparty" ,
                            width: 100
                        },
                        { 
                            field: "bociMta", 
                            title: "CSA MTA to BOCI" ,
                            width: 100
                        },
                        { 
                            field: "csaCptyMta", 
                            title: "CSA MTA to Counterparty" ,
                            width: 100
                        },
                        { 
                            field: "csaBociIndependentAmount", 
                            title: "CSA Independent Amount To BOCI" ,
                            width: 100
                        },
                        { 
                            field: "csaCptyIndependentAmount", 
                            title: "CSA Independent Amount To Counterparty" ,
                            width: 100
                        },
                        { 
                            field: "csaMarginCallFrequency", 
                            title: "CSA Margin Call Frequency" ,
                            width: 100
                        }
                    ]
                });
            }

            function updateLmtAllocGrid(){
            
                var grid = $("#lmtApplicationGrid").data("kendoGrid");

                var tmpUnderlyingStkCode = document.getElementById("lspEntityId").options[document.getElementById("lspEntityId").selectedIndex].value
                var tmpUnderlyingStkMktCode = $("#lspAllocateRatio").val();

                grid.dataSource.add(
                    {
                        lspEntityId : tmpUnderlyingStkCode,
                        lspAllocateRatio : tmpUnderlyingStkMktCode
                    }
                );                
            }

            function initialLimitAllocationGrid(lmtAllcList){

                var limitAllocationList = lmtAllcList;

                $("#lmtApplicationScope").html("<div id='lmtApplicationGrid'></div>");

                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: function (e) {
                            e.success(limitAllocationList);
                        }
                    }
                });   

               if(lmtAllcList != null && lmtAllcList != ""){

                    $('#lmtApplicationGrid').kendoGrid({
                    
                        dataSource: dataSource,
                        cache: false,
                        editable: true,
                        columns: [  
                            { 
                                field: "lspEntityId", 
                                title: "Entity" ,
                                width: 100
                            },
                            { 
                                field: "lspAllocateRatio",
                                title: "Allocation Percentage (%)" ,
                                width: 100
                            },
                            { 
                                command: "destroy", 
                                width: "150px"
                            }
                        ]
                    });

                }else{

                    $('#lmtApplicationGrid').kendoGrid({
                        dataSource: null,
                        cache: false,
                        editable: true,
                        columns: [  
                            
                            { 
                                field: "lspEntityId", 
                                title: "Entity" ,
                                width: 100
                            },
                            { 
                                field: "lspAllocateRatio",
                                title: "Allocation Percentage (%)" ,
                                width: 100
                            },{ 
                                command: "destroy", 
                                width: "150px"
                            }
                        ]
                    });
                }
            }

            function initalGuarGrid(guarList){

                var guarantorGridScope = guarList;

                $("#guarantorGridScope").html("<div id='guarantorGrid'></div>");

                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: function (e) {
                            e.success(guarantorGridScope);
                        }
                    }
                });   

                if(guarList != null && guarList != ""){
                    $('#guarantorGrid').kendoGrid({
                    
                        dataSource: dataSource,
                        cache: false,
                        editable: true,
                        columns: [  
                            { 
                                field: "guarId", 
                                title: "Guarantor ID" ,
                                width: 100
                            },
                            { 
                                field: "guarName",
                                title: "Guarantor Name" ,
                                width: 100
                            },
                            { 
                                field: "guarDomicile", 
                                title: "Guarantor Domicile" ,
                                width: 100
                            },{ 
                                field: "guarAddress", 
                                title: "Guarantor Address" ,
                                width: 100
                            },{ 
                                field: "relWBorrower", 
                                title: "Relation with Borrower" ,
                                width: 100
                            },{ 
                                field: "suppType", 
                                title: "Support Type" ,
                                width: 100
                            },{ 
                                field: "amtType", 
                                title: "Limited / Unlimited Amount" ,
                                width: 100
                            },{ 
                                field: "guarCollCapCcy", 
                                title: "Guarantee / Collateral Amount Currency." ,
                                width: 100
                            },{ 
                                field: "guarCollCapAmt", 
                                title: "Guarantee / Collateral Amount Cap" ,
                                width: 100
                            },{ 
                                field: "guarExpiryDate", 
                                title: "Guarantor Expiry Date(yyyy/mm/dd)" ,
                                width: 100,
                                template: "#=toDateFormatReverse(zeroToEmpty(guarExpiryDate))#"
                            },{ 
                                field: "noticePeriod", 
                                title: "Notice Period (Days)" ,
                                width: 100
                            },
                            { 
                                command: "destroy", 
                                width: "150px"
                            }
                        ]
                    });
                }else{
                    $('#guarantorGrid').kendoGrid({
                    
                        dataSource: null,
                        cache: false,
                        editable: true,
                        columns: [  
                            { 
                                field: "guarId", 
                                title: "Guarantor ID" ,
                                width: 100
                            },
                            { 
                                field: "guarName",
                                title: "Guarantor Name" ,
                                width: 100
                            },
                            { 
                                field: "guarDomicile", 
                                title: "Guarantor Domicile" ,
                                width: 100
                            },{ 
                                field: "guarAddress", 
                                title: "Guarantor Address" ,
                                width: 100
                            },{ 
                                field: "relWBorrower", 
                                title: "Relation with Borrower" ,
                                width: 100
                            },{ 
                                field: "suppType", 
                                title: "Support Type" ,
                                width: 100
                            },{ 
                                field: "amtType", 
                                title: "Limited / Unlimited Amount" ,
                                width: 100
                            },{ 
                                field: "guarCollCapCcy", 
                                title: "Guarantee / Collateral Amount Currency." ,
                                width: 100
                            },{ 
                                field: "guarCollCapAmt", 
                                title: "Guarantee / Collateral Amount Cap" ,
                                width: 100
                            },{ 
                                field: "guarExpiryDate", 
                                title: "Guarantor Expiry Date(yyyy/mm/dd)" ,
                                width: 100,
                                template: "#=toDateFormatReverse(zeroToEmpty(guarExpiryDate))#"
                            },{ 
                                field: "noticePeriod", 
                                title: "Notice Period (Days)" ,
                                width: 100
                            },
                            { 
                                command: "destroy", 
                                width: "150px"
                            }
                        ]
                    });
                }
            }

            function updateGuarGrid(){
            
                var grid = $("#guarantorGrid").data("kendoGrid");

                /*alert(+strToDateReverse($("#guarExpiryDate").val()));*/

                grid.dataSource.add(
                    {
                        guarId : $("#guarId").html(),
                        guarName : $("#guarName").html(),
                        guarDomicile : $("#guarDomicile").html(),
                        guarAddress : $("#guarAddress").html(),
                        relWBorrower : $("#relWBorrower").val(),
                        suppType : $("#suppType").val(),
                        amtType : $("input[name='amtType']:checked").val(),
                        guarCollCapCcy : $("#guarCollCapCcy").val(),
                        guarCollCapAmt : $("#guarCollCapAmt").val(),
                        guarExpiryDate : +strToDateReverse($("#guarExpiryDate").val()),
                        noticePeriod : $("#noticePeriod").val()
                    }
                );                
            }

            function onClickSearchIsda(){
                $("#searchWindowIsda").data("kendoWindow").open();
                $("#searchWindowIsda").data("kendoWindow").center();
            }

            function selectIsdaIdButton(isdaId, bookEntity, isdaPaymentCcy, isdaNettingCcy, isdaNettingInstrument){
                return "<input type=\"button\" class=\"k-button\" onclick=\"selectIsdaId('"+isdaId+"','"+bookEntity+"','"+isdaPaymentCcy+"','"+isdaNettingCcy+"','"+isdaNettingInstrument+"')\" value=\"Select\"/>";
            }
            function selectIsdaId(isdaId, bookEntity, isdaPaymentCcy, isdaNettingCcy, isdaNettingInstrument){
                /*$("#pmeIsdaIdText").val(isdaId);*/
                var grid = $("#isdaResultGrid").data("kendoGrid");
                grid.dataSource.add(
                    {
                        pmeIsdaId : isdaId,
                        pmeIsdaEntity : bookEntity,
                        isdaPaymentCcy : isdaPaymentCcy,
                        isdaNettingCcy : isdaNettingCcy,
                        isdaNettingInstrument : isdaNettingInstrument
                    }
                );
                $("#searchWindowIsda").data("kendoWindow").close();
            }

            function onClickSearchCsa(){
                $("#searchWindowCsa").data("kendoWindow").open();
                $("#searchWindowCsa").data("kendoWindow").center();
            }

            function selectCsaIdButton(csaId, bookEntity, csaCollateralCcy, csaBociThreshold, csaCptyThreshold, bociMta, csaCptyMta, csaBociIndependentAmount, csaCptyIndependentAmount, csaMarginCallFrequency){
                return "<input type=\"button\" class=\"k-button\" onclick=\"selectCsaId('"+csaId+"','"+bookEntity+"','"+csaCollateralCcy+"','"+csaBociThreshold+"','"+csaCptyThreshold+"','"+bociMta+"','"+csaCptyMta+"','"+csaBociIndependentAmount+"','"+csaCptyIndependentAmount+"','"+csaMarginCallFrequency+"')\" value=\"Select\"/>";
            }

            function selectCsaId(csaId, bookEntity, csaCollateralCcy, csaBociThreshold, csaCptyThreshold, bociMta, csaCptyMta, csaBociIndependentAmount, csaCptyIndependentAmount, csaMarginCallFrequency){

                var grid = $("#csaResultGrid").data("kendoGrid");
                grid.dataSource.add(
                    {
                        pmeCsaId : csaId,
                        pmeCsaEntity : bookEntity,
                        csaCollateralCcy : csaCollateralCcy,
                        csaBociThreshold : csaBociThreshold,
                        csaCptyThreshold : csaCptyThreshold,
                        bociMta : bociMta,
                        csaCptyMta : csaCptyMta,
                        csaBociIndependentAmount : csaBociIndependentAmount,
                        csaCptyIndependentAmount : csaCptyIndependentAmount,
                        csaMarginCallFrequency : csaMarginCallFrequency
                    }
                );

                $("#searchWindowCsa").data("kendoWindow").close();
            }

        </script>

        <div id="searchWindowIsda">
            <table width="95%" style="background-color:#DBE5F1; overflow-x:scroll; border-bottom; position: absolute; border-collapse: collapse; " cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="3" style="background-color:#8DB4E3; width:100%">
                        <b><div id="filterTable" onclick="">(+) Filter Criteria</div></b>
                    </td>
                </tr>
                <tbody style="display: block">
                    <tr>
                        <td>Client / Counter Party Name</td>
                        <td><input class="k-textbox" id="ccdId"  type="text"/></td>
                        <td>ISDA ID</td>
                        <td><input class="k-textbox" id="pmeIsdaIdSearch" type="text"/></td>
                    </tr>
                    <tr><td><br></td></tr>
                    <tr><td><br></td></tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td colspan="2"><b></b></td>
                        <td>
                            <button class="k-button" type="button" onclick="searchByIsdaId()">Search</button>
                            <button class="k-button" type="button" onclick="toReset('isda')">Reset</button>
                        </td>
                    </tr>
                </tbody>
                <tr>
                    <td><br></td>
                </tr>
                <tr>
                    <td colspan="4">
                         <div id="isdaGrid"></div>
                    </td>
                </tr>
            </table>
        </div>
        <div id="searchWindowCsa">
            <table width="95%" style="background-color:#DBE5F1; overflow-x:scroll; border-bottom; position: absolute; border-collapse: collapse; " cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="3" style="background-color:#8DB4E3; width:100%">
                        <b><div id="filterTable" onclick="">(+) Filter Criteria</div></b>
                    </td>
                </tr>
                <tbody style="display: block">
                    <tr>
                        <td>Client / Counter Party Name</td>
                        <td><input class="k-textbox" id="ccdId"  type="text"/></td>
                        <td>CSA ID</td>
                        <td><input class="k-textbox" id="csaIdSearch" type="text"/></td>
                    </tr>
                    <tr><td><br></td></tr>
                    <tr><td><br></td></tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td colspan="2"><b></b></td>
                        <td>
                            <button class="k-button" type="button" onclick="searchByCsaId()">Search</button>
                            <button class="k-button" type="button" onclick="toReset('csa')">Reset</button>
                        </td>
                    </tr>
                </tbody>
                <tr>
                    <td><br></td>
                </tr>
                <tr>
                    <td colspan="4">
                         <div id="csaIdGridDetail"></div>
                    </td>
                </tr>
            </table>
        </div>
        <div id="searchWindowGuarantor">
            <table width="95%" style="background-color:#DBE5F1; overflow-x:scroll; border-bottom; position: absolute; border-collapse: collapse; " cellpadding="0" cellspacing="0">
                <tr>
                    <td colspan="3" style="background-color:#8DB4E3; width:100%">
                        <b><div id="filterTable" onclick="">(+) Filter Criteria</div></b>
                    </td>
                </tr>
                <tbody style="display: block">
                    <tr>
                        <td>Guarantor ID</td>
                        <td><input class="k-textbox" id="guarIdSearch"  type="text"/></td>
                        <td>Guarantor Name</td>
                        <td><input class="k-textbox" id="guarNameSearch" type="text"/></td>
                    </tr>
                    <tr><td><br></td></tr>
                    <tr><td><br></td></tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td colspan="2"><b></b></td>
                        <td>
                            <button class="k-button"  type="button" onclick="searchGuarantor()">Search</button>
                            <button class="k-button" type="button" onclick="toReset('guar')">Reset</button>
                        </td>
                    </tr>
                </tbody>
                <tr>
                    <td><br></td>
                </tr>
                <tr>
                    <td colspan="4">
                         <div id="guarSearchGrid"></div>
                    </td>
                </tr>
            </table>
        </div>

        <script type="text/javascript">

            function openSearchGuarGrid(){
                $("#searchWindowGuarantor").data("kendoWindow").open();
                $("#searchWindowGuarantor").data("kendoWindow").center();
            }

            function searchGuarantor(){

                var getGuarantor =window.sessionStorage.getItem('serverPath')+"legalParty/searchGuarantor?userId="+window.sessionStorage.getItem("username").replace("\\","\\")+"&ccdId="+$("#guarIdSearch").val()+"&ccdName="+$("#guarNameSearch").val();

                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getGuarantor,   
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

                $('#guarSearchGrid').kendoGrid({
                
                    dataSource: dataSource,
                    cache: false,
                    editable: true,
                    columns: [  
                        { 
                            command: "", 
                            width: "150px",
                            template: "#=selectGuarButton(guarId, guarName, guarDomicile, guarAddr)#"
                        },
                        { 
                            field: "guarId", 
                            title: "Guarantor ID" ,
                            width: 100
                        },
                        { 
                            field: "cmdClientId", 
                            title: "CMD Client ID" ,
                            width: 100
                        },
                        { 
                            field: "guarName",
                            title: "Guarantor Name" ,
                            width: 100
                        },
                        { 
                            field: "guarDomicile", 
                            title: "Domicile" ,
                            width: 100
                        }
                    ]
                });
            }

            function selectGuarButton(guarId, guarName, guarDomicile, guarAddr){
                return "<input type=\"button\" class=\"k-button\" onclick=\"selectGuarDetails('"+guarId+"','"+guarName+"','"+guarDomicile+"','"+guarAddr+"')\" value=\"Select\"/>";
            }

            function selectGuarDetails(guarId, guarName, guarDomicile, guarAddr){
                $("#guarId").html(checkUndefinedElement(guarId));
                $("#guarName").html(checkUndefinedElement(guarName));
                $("#guarDomicile").html(checkUndefinedElement(guarDomicile));
                $("#guarAddress").html(checkUndefinedElement(guarAddress));
                $("#searchWindowGuarantor").data("kendoWindow").close();
            }

            function toReset(scope){
                if(scope == "isda"){
                    $("#ccdId").val("");
                    $("#pmeIsdaIdSearch").val("");
                    clickSearchGroup();
                }else if(scope == "csa"){
                    $("#ccpty").val("");
                    $("#ccptyName").val("");
                    clickSearchCcpty();
                }else if(scope == "guar"){
                    $("#guarIdSearch").val("");
                    $("#guarNameSearch").val("");
                }
            }

            function onLoadRemarksCat(){

                var getRemarkCat = "/ermsweb/resources/js/staticData.json";
                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getRemarkCat,   
                            cache: false,                       
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            },
                            complete: function(response, status){
                                if(status == "success"){
                                    $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {
                                        if(key == "remarksCat"){
                                            $.each(value, function(key, value) {
                                                var option = document.createElement("option");
                                                option.text = checkUndefinedElement(value);
                                                option.value = checkUndefinedElement(key);
                                                document.getElementById("remarksCat").appendChild(option);
                                                option = null;
                                            });
                                        }
                                    });
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
            
            String.format = function() {

                var theString = arguments[0];

                for (var i = 1; i < arguments.length; i++) {
                    var regEx = new RegExp("\\{" + (i - 1) + "\\}", "gm");
                    theString = theString.replace(regEx, arguments[i]);
                }
                
                return theString;
            }

            function onLoadRemarkAllList(remarkAllList){    

                /*$.each(remarkAllList, function(key, value) {
                    var option = document.createElement("option");
                    option.value = checkUndefinedElement(value.remarkCat + "||" + value.remark);
                    option.text = String.format("{0} \xa0\xa0\xa0\xa0\xa0\xa0\xa0 {1} \xa0\xa0\xa0\xa0\xa0\xa0\xa0 {2} \xa0\xa0\xa0\xa0\xa0\xa0\xa0 {3}", toDateTimeFormatReverse(value.createDt),  value.createBy, value.remarkCat, value.remark);
                    document.getElementById("remarkAllList").appendChild(option);
                    option = null;
                });*/
    
                    $('#remarkAllList').kendoGrid({
                        dataSource : new kendo.data.DataSource(),
                        cache: false,
                        editable: true,
                        columns: [  
                            { 
                                field: "createDt", 
                                title: "Create Date" ,
                                width: 100,
                                template: "#=toDateTimeFormatReverse(createDt)#"
                            },
                            { 
                                field: "createBy",
                                title: "Create By" ,
                                width: 100
                            },
                            { 
                                field: "remarkCat", 
                                title: "Remark Cat." ,
                                width: 100
                            },
                            { 
                                field: "remark", 
                                title: "Remarks" ,
                                width: 100
                            }
                        ]
                    });

                    var grid = $("#remarkAllList").data("kendoGrid");
                    if(remarkAllList != null && remarkAllList != ""){
                        $.each(remarkAllList, function(key, value) {
                            grid.dataSource.add(
                                value
                            );
                        });    
                    }
            }

            function onLoadRemarkCurrUserList(remarkCurrUserList){

                /*$.each(remarkCurrUserList, function(key, value) {
                    var option = document.createElement("option");
                    option.value = checkUndefinedElement(value.remarkCat + "||" + value.remark);
                    option.text = String.format("{0} \xa0\xa0\xa0\xa0\xa0\xa0\xa0 {1} \xa0\xa0\xa0\xa0\xa0\xa0\xa0 {2} \xa0\xa0\xa0\xa0\xa0\xa0\xa0 {3}", toDateTimeFormatReverse(value.createDt),  value.createBy, value.remarkCat, value.remark);
                    document.getElementById("remarkCurrUserList").appendChild(option);
                    option = null; 
                });*/

                $('#remarkCurrUserList').kendoGrid({
                    dataSource : new kendo.data.DataSource(),
                    cache: false,
                    editable: true,
                    columns: [  
                        { 
                            field: "createDt", 
                            title: "Create Date" ,
                            width: 100,
                            template: "#=toDateTimeFormatReverse(createDt)#"
                        },
                        { 
                            field: "createBy",
                            title: "Create By" ,
                            width: 100
                        },
                        { 
                            field: "remarkCat", 
                            title: "Remark Cat." ,
                            width: 100
                        },
                        { 
                            field: "remark", 
                            title: "Remarks" ,
                            width: 100
                        }
                    ]
                });

                var grid = $("#remarkCurrUserList").data("kendoGrid");
                if(remarkCurrUserList != null && remarkCurrUserList != ""){
                    $.each(remarkCurrUserList, function(key, value) {
                        grid.dataSource.add(
                            value
                        );
                    });    
                }
            }

            function onLoadSupInfoOfGroupClientGrid(isNew, rowData){

                $("#supInfoOfGroupClientGrid").kendoGrid({
                    scrollable: true,
                    columns: [  
                        { 
                            field: "groupName", 
                            title: "Group Name" ,
                            width: 100
                        },
                        { 
                            field: "ccdName",
                            title: "CCD Name" ,
                            width: 100
                        },
                        { 
                            field: "acctNo", 
                            title: "Account No." ,
                            width: 100
                        },
                        { 
                            field: "subAcctNo", 
                            title: "Sub-Account No." ,
                            width: 100
                        },
                        { 
                            field: "acctName", 
                            title: "Account Name" ,
                            width: 100
                        },
                        { 
                            field: "limitType", 
                            title: "Limit Type" ,
                            width: 100
                        },
                        { 
                            field: "facId", 
                            title: "Facility ID" ,
                            width: 100
                        },
                        { 
                            field: "marketCap", 
                            title: "Market Capitalization / Client Counterparty" ,
                            width: 100
                        },
                        { 
                            field: "riskRatingForAppr", 
                            title: "Risk Rating for Approval" ,
                            width: 100
                        },
                        { 
                            field: "isHKMAAuthIns", 
                            title: "Is Authorized Institution" ,
                            width: 100
                        }
                    ]
                });

                var grid = $("#supInfoOfGroupClientGrid").data("kendoGrid");

                removeAllRowsFromGrid("supInfoOfGroupClientGrid");

                if(isNew == true){

                    var getSuppleInfo = "/ermsweb/resources/js/staticData.json";

                    var dataSource = new kendo.data.DataSource({
                        transport: {
                            read: {
                                type: "GET",
                                async: false,
                                url: getSuppleInfo,   
                                cache: false,                       
                                dataType: "json",
                                complete: function(response, status){
                                   
                                    if(status == "success"){
                                        
                                       $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {
                                            if(key == "suppInfoForIDLList"){
                                                $.each(value, function(key, value) {
                                                    grid.dataSource.add(
                                                        value
                                                    );
                                                });
                                            }
                                        });
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

                }else{
                    if(rowData != null && rowData != ""){
                        $.each(rowData, function(key, value) {            
                            grid.dataSource.add(
                                value
                            );                        
                        });
                    }
                }
            }

            function onLoadApprLevel(){
                var getApprLvl = "/ermsweb/resources/js/staticData.json";
                var dataSource = new kendo.data.DataSource({
                    transport: {
                        read: {
                            type: "GET",
                            async: false,
                            url: getApprLvl,   
                            cache: false,                       
                            dataType: "json",
                            xhrFields: {
                                withCredentials: true
                            },
                            complete: function(response, status){
                                if(status == "success"){
                                    $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {
                                        if(key == "overrideApprList"){
                                            
                                            var option = document.createElement("option");
                                            option.text = "-";
                                            option.value = "";
                                            document.getElementById("overrideApprList").appendChild(option);
                                            option = null;

                                            $.each(value, function(key, value) {
                                                option = document.createElement("option");
                                                option.text = checkUndefinedElement(value);
                                                option.value = checkUndefinedElement(key);
                                                document.getElementById("overrideApprList").appendChild(option);
                                                option = null;
                                            });
                                        }
                                    });
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

            function onLoadApprDetailsGrid(){
                $('#apprDetailList').kendoGrid({
                    dataSource: null,
                    filterable: false,
                    columnMenu: false,
                    sortable: true,
                    scrollable: true,
                    columns: [  
                        { 
                            field: "approvalLevel", 
                            title: "approvalLevel" ,
                            width: 50,
                            groupFooterTemplate: "Subtotal"
                        },
                        { 
                            field: "approvalDate",
                            title: "approvalDate" ,
                            width: 50,
                            template: "#=toDateFormatReverse(approvalDate)#"
                        },
                        { 
                            field: "",
                            title: "Approval" ,
                            width: 50,
                            template: "#=createRadioButtonApprove(approvalLevel, approvalDate, isApproveInd, positionId)#"
                        },
                        { 
                            field: "",
                            title: "Reject" ,
                            width: 50,
                            template: "#=createRadioButtonNotApprove(approvalLevel, approvalDate, isApproveInd, positionId)#"
                        },
                        { 
                            field: "memberName",
                            title: "memberName" ,
                            width: 50
                        }
                    ]
                });
            }

            function addToApprDetail(rowData){

                var grid = $("#apprDetailList").data("kendoGrid");

                if(rowData != null && rowData != ""){
                    $.each(rowData, function(key, value) {   
                        grid.dataSource.add(
                            value
                        );
                    });
                }
            }

            function createRadioButtonApprove(approvalLevel, memberName, isApproveInd, positionId){
                if(isApproveInd == "Y"){
                    return "<input type=\"radio\" name=\""+positionId+"\" id=\"approval\" value=\"Y\" checked></input>";             
                }else{
                    if(isApproveInd == "N"){
                        return "<input type=\"radio\" name=\""+positionId+"\" id=\"approval\" value=\"Y\"></input>";                               
                    }else{
                        return "<input type=\"radio\" name=\""+positionId+"\" id=\"approval\" value=\"Y\"></input>"; 
                    }  
                }
            }

            function createRadioButtonNotApprove(approvalLevel, memberName, isApproveInd, positionId){
                if(isApproveInd == "Y"){
                    return "<input type=\"radio\" name=\""+positionId+"\" id=\"approval\" value=\"N\" ></input>";             
                }else{
                    if(isApproveInd == "N"){
                        return "<input type=\"radio\" name=\""+positionId+"\" id=\"approval\" value=\"N\" checked></input>";  
                    }else{
                        return "<input type=\"radio\" name=\""+positionId+"\" id=\"approval\" value=\"N\"></input>";  
                    }           
                }
            }

            function getGridFields(gridName){
                
                var displayedData = $("#"+gridName).data().kendoGrid.dataSource.view();
                var displayedDataAsJSON = JSON.stringify(displayedData);
                var toJsonFormat = "";
                var i = 0;

                $.each(JSON.parse(displayedDataAsJSON), function(key, value) {
                    toJsonFormat += "{";
                    $.each(value, function(key, value) {
                        toJsonFormat += "\"" + key + "\"  : \"" + value + "\", ";   
                    });
                    
                    toJsonFormat = toJsonFormat.substring(0, toJsonFormat.length - 2);
                    toJsonFormat += "},";
                    i++;
                });

                toJsonFormat = toJsonFormat.substring(0, toJsonFormat.length - 1);

                return toJsonFormat;
            }

            function updateToCapturedDatasource(){

                var tmpPartyNo = "";
                var tmpPartyType = "";
                var tmpCrId = "";
                var tmpBizUnit = "";
                var tmpBookEntity = "";
                var tmpDataSourceAppId = "";
                var tmpNovaSubAcctId = "";

                console.log($("#isEdit").val());
                console.log($("#isNew").val());

                if($("#isEdit").val() == "Y" && $("#isNew").val() == "N"){

                    dataSourceCapture.fetch(function(){
                        
                        var values = dataSourceCapture.data();

                        for (var i = 0; i < values.length; i++) {
                            values[i].userId = window.sessionStorage.getItem("username").replace("\\","\\");
                            if(values[i].isRoot != "Y" && checkUndefinedElement(values[i].partyType) == checkUndefinedElement($("#partyType").val()) && checkUndefinedElement(values[i].partyNo) == checkUndefinedElement($("#partyNo").val()) && checkUndefinedElement(values[i].crId) == checkUndefinedElement($("#crId").val()) && checkUndefinedElement(values[i].bizUnit) == checkUndefinedElement($("#bizUnit").val()) && checkUndefinedElement(values[i].bookEntity) == checkUndefinedElement($("#bookEntity").val()) && checkUndefinedElement(values[i].dataSourceAppId) == checkUndefinedElement($("#dataSourceAppId").val()) && checkUndefinedElement(values[i].dataSourceAppId) == checkUndefinedElement($("#dataSourceAppId").val()) && checkUndefinedElement(values[i].novaSubAcctId) == checkUndefinedElement($("#novaSubAcctId").val())){

                                values[i].sblrSblVolatility = parseFloat($("#sblrSblVolatility").html())/100;
                                values[i].sblrRepoVolatility = parseFloat($("#sblrRepoVolatility").html())/100;


                                tmpPartyNo = values[i].partyNo;

                                tmpPartyType = values[i].partyType;

                                tmpCrId = values[i].crId;

                                tmpBizUnit = values[i].bizUnit;

                                tmpBookEntity = values[i].bookEntity;

                                tmpDataSourceAppId = values[i].dataSourceAppId;

                                tmpNovaSubAcctId = values[i].novaSubAcctId;

                                values[i].approvalMatrixBu = $("#approvalBizUnit").html();

                                values[i].approvalMatrixOption = $('#approvalMatrixOption :selected').val();

                                values[i].chargor = $("#chargor").val();

                                values[i].lmtCategory = $('#lmtCategory :selected').val();

                                values[i].lmtTypeHierLvlId = $('#lmtTypeHierLvlId :selected').val();

                                values[i].lmtTypeCode = $('#lmtTypeCode :selected').val();

                                values[i].facPurpose = $("#facPurpose").val();

                                /*values[i].lendingUnitList = $('#lendingUnitList :selected').val();*/

                                values[i].newLmtCcy = $("#newLmtCcy :selected").val();

                                values[i].newLmtAmt = $("#newLmtAmt").val();

                                values[i].coLmtAmt = $("#coLmtAmt").val();

                                values[i].newLmtExpiryDate = dateToTime(strToDateReverse($("#newLmtExpiryDateField").val()));

                                values[i].coLmtExpiryDate = dateToTime(strToDateReverse($("#coLmtExpiryDate").val()));

                                values[i].lmtRiskRating = $("#lmtRiskRating").val();

                                values[i].collType = $('#collType :selected').val();

                                values[i].lmtTenor = $("#lmtTenor").val();

                                values[i].lmtTenorUnit = $('input[name="lmtTenorUnit"]:checked').val();

                                values[i].pfLoanCcy = $('#pfLoanCcy :selected').val();

                                /* Pending :  Loanable Currency */

                                values[i].pfLoanAmt = $("#pfLoanAmt").val();

                                values[i].shlMapList = JSON.parse("["+getGridFields("shareHolderGrid")+"]");

                                values[i].isShlBreach = $('input[name="isShlBreach"]:checked').val();

                                values[i].shlBreachDetail = $('#shlBreachDetail').val();

                                values[i].shlBreachHaObtain = $('#shlBreachHaObtain').val();

                                values[i].sblrExcessCashRecallBuf = $('#sblrExcessCashRecallBuf').val();

                                values[i].sblrMarginCallBuf = $('#sblrMarginCallBuf').val();

                                values[i].sblrBorrowImRatio = $('#sblrBorrowImRatio').val();

                                values[i].sblrLendImRatio = $('#sblrLendImRatio').val();

                                values[i].sblrRepoStockMarginRatio = $('#sblrRepoStockMarginRatio').val();


                                var displayedIsdaData = $("#isdaResultGrid").data().kendoGrid.dataSource.view();

                                if(displayedIsdaData.length != 0){
                                    values[i].pmeIsdaId = displayedIsdaData[0].pmeIsdaId;
                                    values[i].pmeIsdaEntity = displayedIsdaData[0].pmeIsdaEntity;
                                    values[i].pmeIsdaPaymentCcy = displayedIsdaData[0].isdaPaymentCcy;
                                    values[i].pmeIsdaNettingCcy = displayedIsdaData[0].isdaNettingCcy;
                                    values[i].pmeIsdaNettingInstrument = displayedIsdaData[0].isdaNettingInstrument;    
                                }
                                


                                var displayedCsaData = $("#csaResultGrid").data().kendoGrid.dataSource.view();


                                if(displayedCsaData.length != 0){
                                    values[i].pmeCsaId = displayedCsaData[0].pmeCsaId;
                                    values[i].pmeCsaEntity = displayedCsaData[0].pmeCsaEntity;
                                    values[i].pmeCsaCollateralCcy = displayedCsaData[0].csaCollateralCcy;
                                    values[i].pmeCsaBociThreshold = displayedCsaData[0].csaBociThreshold;
                                    values[i].pmeCsaCptyThreshold = displayedCsaData[0].csaCptyThreshold;
                                    values[i].pmeBociMta = displayedCsaData[0].bociMta;
                                    values[i].pmeCsaCptyMta = displayedCsaData[0].csaCptyMta;
                                    values[i].pmeCsaBociIndependentAmount = displayedCsaData[0].csaBociIndependentAmount;
                                    values[i].pmeCsaCptyIndependentAmount = displayedCsaData[0].csaCptyIndependentAmount;
                                    values[i].pmeCsaMarginCallFrequency = displayedCsaData[0].csaMarginCallFrequency;
                                
                                }





                                /* Pending dvpProdList */
                                var tmpArrList = [];

                                $.each($("#dvpProdList :selected"), function(){            
                                    tmpArrList.push($(this).val());
                                });

                                if(tmpArrList.length != 0){
                                    var arrToJson = "[";
                                    for (var p = 0; p < tmpArrList.length; p++) {
                                        arrToJson += "{";
                                        arrToJson += "\"prodCode\" : \""+tmpArrList[p]+"\",";
                                        arrToJson += "\"createBy\" : \"\",";
                                        arrToJson += "\"createDt\" : null,";
                                        arrToJson += "\"lastUpdateBy\" : null,";
                                        arrToJson += "\"lastUpdateDt\" : null";
                                        arrToJson += "},";
                                    };                                
                                    arrToJson = arrToJson.substring(0, arrToJson.length - 1);
                                    arrToJson += "]";
                                    console.log(arrToJson);
                                    values[i].dvpProdList = JSON.parse(arrToJson);
                                }else{
                                    values[i].dvpProdList = [];
                                }







                                /* Pending Lending Unit */
                                var tmpArrList = [];

                                $.each($("#lendingUnit :selected"), function(){            
                                    tmpArrList.push($(this).val());
                                });

                                if(tmpArrList.length != 0){
                                    var arrToJson = "[";
                                    for (var p = 0; p < tmpArrList.length; p++) {
                                        arrToJson += "{";
                                        arrToJson += "\"lendUnit\" : \""+tmpArrList[p]+"\",";
                                        arrToJson += "\"createBy\" : \"\",";
                                        arrToJson += "\"createDt\" : null,";
                                        arrToJson += "\"lastUpdateBy\" : null,";
                                        arrToJson += "\"lastUpdateDt\" : null";
                                        arrToJson += "},";
                                    };                                
                                    arrToJson = arrToJson.substring(0, arrToJson.length - 1);
                                    arrToJson += "]";
                                    console.log(arrToJson);
                                    values[i].lendingUnitList = JSON.parse(arrToJson);
                                }else{
                                    values[i].lendingUnitList = [];
                                }
                                





                                values[i].dslOtherProdTypeDesc = $('#dslOtherProdTypeDesc').val();

                                values[i].fdImRatio = $('#fdImRatio').val();

                                values[i].fdGreyPeriodDay = $('#fdGreyPeriodDay').val();

                                values[i].fdIsUfMarginWPdCntl = $('input[name="fdIsUfMarginWPdCntl"]:checked').val();

                                values[i].fdIsLoanProvide = $('input[name="fdIsLoanProvide"]:checked').val();

                                values[i].fdIsDefferralAllow = $('input[name="fdIsDefferralAllow"]:checked').val();

                                values[i].fdOtherControl = $('#fdOtherControl').val();

                                values[i].lmdLoanAgreementType = $('#lmdLoanAgreementType :selected').val();

                                values[i].ibdMaxTenorAllow = $('#ibdMaxTenorAllow').val();

                                values[i].ibdMaxTenorAllowUnit = $('input[name="ibdMaxTenorAllowUnit"]:checked').val();









                                tmpArrList = [];

                                $.each($("#prProdList :selected"), function(){            
                                    tmpArrList.push($(this).val());
                                });

                                if(tmpArrList.length != 0){
                                    var arrToJson = "[";
                                    for (var p = 0; p < tmpArrList.length; p++) {
                                        arrToJson += "{";
                                        arrToJson += "\"prodCode\" : \""+tmpArrList[p]+"\",";
                                        arrToJson += "\"createBy\" : \"\",";
                                        arrToJson += "\"createDt\" : null,";
                                        arrToJson += "\"lastUpdateBy\" : null,";
                                        arrToJson += "\"lastUpdateDt\" : null";
                                        arrToJson += "},";
                                    };                                
                                    arrToJson = arrToJson.substring(0, arrToJson.length - 1);
                                    arrToJson += "]";
                                    console.log(arrToJson);
                                    values[i].prProdList = JSON.parse(arrToJson);
                                }else{
                                    values[i].prProdList = [];
                                }














                                values[i].prlMaxTenorAllow = $('#prlMaxTenorAllow').val();

                                values[i].prlMaxTenorAllowUnit = $('input[name="prlMaxTenorAllowUnit"]:checked').val();

                                values[i].prlHaircutRatio = $('#prlHaircutRatio').val();
                                
                                values[i].prlOtherProdTypeDesc = $('#prlOtherProdTypeDesc').val();











                                /* Pending Physical Repo Limit - others */

                                tmpArrList = [];
                                
                                $.each($("#pmeExpoType :selected"), function(){            
                                    tmpArrList.push($(this).val());
                                });

                                if(tmpArrList.length != 0){
                                    var arrToJson = "[";
                                    for (var p = 0; p < tmpArrList.length; p++) {
                                        arrToJson += "{";
                                        arrToJson += "\"pmeExpoType\" : \""+tmpArrList[p]+"\",";
                                        arrToJson += "\"createBy\" : \"\",";
                                        arrToJson += "\"createDt\" : null,";
                                        arrToJson += "\"lastUpdateBy\" : null,";
                                        arrToJson += "\"lastUpdateDt\" : null";
                                        arrToJson += "},";
                                    };                                
                                    arrToJson = arrToJson.substring(0, arrToJson.length - 1);
                                    arrToJson += "]";
                                    console.log(arrToJson);
                                    values[i].pmeExpoTypeList = JSON.parse(arrToJson);
                                }else{
                                    values[i].pmeExpoTypeList = [];
                                }







                                values[i].pmeMaxTenorAllow = $("#pmeMaxTenorAllow").val();


                                values[i].pmeMaxTenorAllowUnit = $('input[name="pmeMaxTenorAllowUnit"]:checked').val();

                                values[i].pmeGreyPeriod = $('#pmeGreyPeriod').val();

                                /*values[i].pmeIsdaId = $('#pmeIsdaIdText').val();*/

                                /*values[i].pmeCsaId = $('#csaIdText').val();*/

                                values[i].pmeOtherExpoType = $('#pmeOtherExpoType').val();






                                tmpArrList = [];

                                $.each($("#whlProdList :selected"), function(){            
                                    tmpArrList.push($(this).val());
                                });

                                if(tmpArrList.length != 0){
                                    var arrToJson = "[";
                                    for (var p = 0; p < tmpArrList.length; p++) {
                                        arrToJson += "{";
                                        arrToJson += "\"prodCode\" : \""+tmpArrList[p]+"\",";
                                        arrToJson += "\"createBy\" : \"\",";
                                        arrToJson += "\"createDt\" : null,";
                                        arrToJson += "\"lastUpdateBy\" : null,";
                                        arrToJson += "\"lastUpdateDt\" : null";
                                        arrToJson += "},";
                                    };                                
                                    arrToJson = arrToJson.substring(0, arrToJson.length - 1);
                                    arrToJson += "]";
                                    console.log(arrToJson);
                                    values[i].whlProdList = JSON.parse(arrToJson);
                                }else{
                                    values[i].whlProdList = [];
                                }










                                tmpArrList = [];

                                $.each($("#pfCurrency :selected"), function(){            
                                    tmpArrList.push($(this).val());
                                });

                                if(tmpArrList.length != 0){
                                    var arrToJson = "[";
                                    for (var p = 0; p < tmpArrList.length; p++) {
                                        arrToJson += "{";
                                        arrToJson += "\"loanableCcy\" : \""+tmpArrList[p]+"\",";
                                        arrToJson += "\"createBy\" : \"\",";
                                        arrToJson += "\"createDt\" : null,";
                                        arrToJson += "\"lastUpdateBy\" : null,";
                                        arrToJson += "\"lastUpdateDt\" : null";
                                        arrToJson += "},";
                                    };                                
                                    arrToJson = arrToJson.substring(0, arrToJson.length - 1);
                                    arrToJson += "]";
                                    console.log(arrToJson);
                                    values[i].premFinLoanCcyList = JSON.parse(arrToJson);
                                }else{
                                    values[i].premFinLoanCcyList = [];
                                }













                                values[i].whlOtherControl = $('#whlOtherControl').val();

                                values[i].whlOtherProdTypeDesc = $('#whlOtherProdTypeDesc').val();

                                values[i].spRatioList = JSON.parse("["+getGridFields("lmtApplicationGrid")+"]");

                                values[i].ppProposePrice = $('#ppProposePrice :selected').val();

                                values[i].ppRatioSign = $('#ppRatioSign :selected').text();

                                values[i].ppRatio = $('#ppRatio').val();

                                values[i].ppFeeComm = $('#ppFeeComm').val();

                                values[i].ppArrangeHandleFee = $('#ppArrangeHandleFee').val();

                                values[i].ppOthers = $('#ppOthers').val();

                                values[i].guarMapList = JSON.parse("["+getGridFields("guarantorGrid")+"]");

                                values[i].isNew = "N";
                                
                                values[i].isEdit = "Y";

                            }

                            if(values[i].isCurrentBatch == "Y" && values[i].isRoot != "Y"){

                                values[i].docMapList = JSON.parse("["+getGridFields("fileDetailGrid")+"]");

                                values[i].remarkAllList = JSON.parse("["+getGridFields("remarkAllList")+"]");

                                values[i].remarkCurrUserList = JSON.parse("["+getGridFields("remarkCurrUserList")+"]");

                                values[i].riBrRoleDesc = $("#riBrRoleDesc").val();

                                values[i].riBrName = $("#riBrName").val();

                                values[i].riBrEmailAddr = $("#riBrEmailAddr").val();

                                values[i].riBrReviewDate = dateToTime(strToDateReverse($("#riBrReviewDate").val()));

                                values[i].riBcRoleDesc = $("#riBcRoleDesc").val();

                                values[i].riBcName = $("#riBcName").val();

                                values[i].riBcEmailAddr = $("#riBcEmailAddr").val();

                                values[i].riBcReviewDate = dateToTime(strToDateReverse($("#riBcReviewDate").val()));

                                values[i].riBaRoleDesc = $("#riBaRoleDesc").val();

                                values[i].riBaName = $("#riBaName").val();

                                values[i].riBaEmailAddr = $("#riBaEmailAddr").val();

                                values[i].riBaReviewDate = dateToTime(strToDateReverse($("#riBaReviewDate").val()));

                                values[i].idlBuIsExceptApprove = $('input[name="idlBuIsExceptApprove"]:checked').val();

                                values[i].aiOverrideApproveLvl = $("#overrideApprList :selected").val();
                                
                                for (var m = 0; m < values[i].apprDetailList.length; m++) {
                                    values[i].apprDetailList[m].isApproveInd = $("input[name="+values[i].apprDetailList[m].positionId+"]:checked").val();
                                };
                            }
                        };

                        var grid = $("#grid").data("kendoGrid");
                        grid.setDataSource(dataSourceCapture);

                        autoSelectedByValue("currencyList-new-"+tmpPartyNo+"-"+tmpPartyType+"-"+tmpCrId+"-"+tmpBizUnit+"-"+tmpBookEntity+"-"+tmpDataSourceAppId+"-"+tmpNovaSubAcctId, $("#newLmtCcy").val());

                        $("#newLmtExpiryDate-new"+tmpPartyNo+"-"+tmpPartyType+"-"+tmpCrId+"-"+tmpBizUnit+"-"+tmpBookEntity+"-"+tmpDataSourceAppId+"-"+tmpNovaSubAcctId).val($("#newLmtExpiryDateField").val());

                        $("#coLmtExpiryDate-co"+tmpPartyNo+"-"+tmpPartyType+"-"+tmpCrId+"-"+tmpBizUnit+"-"+tmpBookEntity+"-"+tmpDataSourceAppId+"-"+tmpNovaSubAcctId).val($("#coLmtExpiryDate").val());
                    }); 
                    refreshTheGridFields();

                }else{

                     if($("#isEdit").val() == "N" && $("#isNew").val() == "Y"){

                            var splitStrings = [];
                            var tmpInGrpId = "";
                            var tmpInCcdId = "";

                            if($('input[name="radioSet"]:checked').val() == "group"){

                                tmpPartyType = "GROUP";
                                tmpPartyNo = $('#hiddenGroupId').val();
                                tmpInGrpId =  tmpPartyNo;

                            }else if($('input[name="radioSet"]:checked').val() == "ccpty"){

                                tmpPartyType = "LEGAL_PARTY";
                                tmpPartyNo = $('#ccptyRadioText :selected').val();
                                
                            }else if($('input[name="radioSet"]:checked').val() == "account"){

                                tmpPartyType = "ACCOUNT";
                                splitStrings = $('#accountRadioText :selected').val().split("||");
                                tmpPartyNo = splitStrings[0];
                                
                            }else if($('input[name="radioSet"]:checked').val() == "subAccount"){

                                tmpPartyType = "SUB_ACCOUNT";
                                splitStrings = $('#subAccountRadioText :selected').val().split("||");
                                console.log(splitStrings[0]);
                                tmpPartyNo = splitStrings[0];

                            }

                            dataSourceCapture.add({
                                "isCurrentBatch": null,
                                "isRoot": null,
                                "crId": null,
                                "userId": window.sessionStorage.getItem("username").replace("\\","\\"),
                                "action": null,
                                "inGrpId": tmpInGrpId,
                                "inCcdId": null,
                                "inApprovalMatrixOpt": null,
                                "inApprovalMatrixBu": null,
                                "enableOverrideApprFlag": null,
                                "enableFulfill": null,
                                "enableCoSection": "N",
                                "enableNewSection": "Y",
                                "enableApprovalSection": null,
                                "isFulfill": null,
                                "isNew": "Y",
                                "isEdit": "N",
                                "isDeleted": null,
                                "batchId": null,
                                "recordAccess": "E|D",
                                "crAction": null,
                                "partyType": tmpPartyType,
                                "partyNo": tmpPartyNo,
                                "groupId": null,
                                "ccdId": null,
                                "acctId": null,
                                "novaSubAcctId": checkUndefinedElement(splitStrings[4]),
                                "bizUnit": checkUndefinedElement(splitStrings[1]),
                                "bookEntity": checkUndefinedElement(splitStrings[2]),
                                "dataSourceAppId": checkUndefinedElement(splitStrings[3]),
                                "groupName": null,
                                "ccdName": null,
                                "acctName": null,
                                "approvalMatrixBu": null,
                                "approvalMatrixOption": null,
                                "groupCreditRatingInr": null,
                                "groupCreditRatingMoody": null,
                                "groupCreditRatingSnp": null,
                                "groupCreditRatingFitch": null,
                                "groupRiskRatingForAppr": null,
                                "connectedPartyType": null,
                                "countryOfDomicile": null,
                                "creditRatingInr": null,
                                "creditRatingMoody": null,
                                "creditRatingSnp": null,
                                "creditRatingFitch": null,
                                "riskRatingForApproval": null,
                                "chargor": null,
                                "holdingType": null,
                                "facId": null,
                                "lmtBizUnit": null,
                                "lmtCategory": null,
                                "lmtTypeHierLvlId": null,
                                "lmtTypeCode": null,
                                "facPurpose": null,
                                "existLmtCcy": null,
                                "existLmtAmt": null,
                                "newLmtCcy": null,
                                "newLmtAmt": null,
                                "coLmtCcy": null,
                                "coLmtAmt": null,
                                "existLmtExpiryDate": null,
                                "newLmtExpiryDate": null,
                                "coLmtExpiryDate": null,
                                "ccfRatio": null,
                                "lmtRiskRating": null,
                                "existLeeCcy": null,
                                "existLeeAmt": null,
                                "lastApprovalDate": null,
                                "existCcfLmtAmtCcy": null,
                                "existCcfLmtAmt": null,
                                "newCcfLmtAmtCcy": null,
                                "newCcfLmtAmt": null,
                                "coNewCcfLmtCcy": null,
                                "coNewCcfLmtAmt": null,
                                "collType": null,
                                "lmtTenor": null,
                                "lmtTenorUnit": null,
                                "isBatchUpload": null,
                                "isAnnualLmtReview": null,
                                "pfLoanAmt": null,
                                "pfLoanCcy": null,
                                "isShlBreach": null,
                                "shlBreachDetail": null,
                                "shlBreachHaObtain": null,
                                "sblrExcessCashRecallBuf": null,
                                "sblrMarginCallBuf": null,
                                "sblrBorrowImRatio": null,
                                "sblrLendImRatio": null,
                                "sblrRepoStockMarginRatio": null,
                                "sblrSblVolatility": null,
                                "sblrRepoVolatility": null,
                                "fdImRatio": null,
                                "fdGreyPeriodDay": null,
                                "fdIsUfMarginWPdCntl": null,
                                "fdIsLoanProvide": null,
                                "fdIsDefferralAllow": null,
                                "fdOtherControl": null,
                                "lmdLoanAgreementType": null,
                                "ibdMaxTenorAllow": null,
                                "ibdMaxTenorAllowUnit": null,
                                "prlOtherProdTypeDesc": null,
                                "prlMaxTenorAllow": null,
                                "prlMaxTenorAllowUnit": null,
                                "prlHaircutRatio": null,
                                "pmeOtherExpoType": null,
                                "pmeMaxTenorAllow": null,
                                "pmeMaxTenorAllowUnit": null,
                                "pmeGreyPeriod": null,
                                "pmeIsdaId": null,
                                "pmeIsdaEntity": null,
                                "pmeIsdaPaymentCcy": null,
                                "pmeIsdaNettingCcy": null,
                                "pmeIsdaNettingInstrument": null,
                                "pmeCsaId": null,
                                "pmeCsaEntity": null,
                                "pmeCsaCollateralCcy": null,
                                "pmeCsaBociThreshold": null,
                                "pmeCsaCptyThreshold": null,
                                "pmeBociMta": null,
                                "pmeCsaCptyMta": null,
                                "pmeCsaCptyIndependentAmt": null,
                                "pmeCsaBociIndependentAmt": null,
                                "pmeCsaMarginCallFrequency": null,
                                "whlOtherControl": null,
                                "whlOtherProdTypeDesc": null,
                                "ppProposePrice": null,
                                "ppRatioSign": null,
                                "ppRatio": null,
                                "ppFeeComm": null,
                                "ppArrangeHandleFee": null,
                                "ppOthers": null,
                                "riBrRoleDesc": null,
                                "riBrName": null,
                                "riBrEmailAddr": null,
                                "riBrReviewDate": null,
                                "riBcRoleDesc": null,
                                "riBcName": null,
                                "riBcEmailAddr": null,
                                "riBcReviewDate": null,
                                "riBaRoleDesc": null,
                                "riBaName": null,
                                "riBaEmailAddr": null,
                                "riBaReviewDate": null,
                                "riMakerRoleDesc": null,
                                "riMakerName": null,
                                "riMakerReviewDate": null,
                                "riCheckerRoleDesc": null,
                                "riCheckerName": null,
                                "riCheckerReviewDate": null,
                                "riEndorserRoleDesc": null,
                                "riEndorserName": null,
                                "riEndorserReviewDate": null,
                                "riApproverRoleDesc": null,
                                "riApproverName": null,
                                "riApproverReviewDate": null,
                                "riCaCheckerRoleDesc": null,
                                "riCaCheckerName": null,
                                "riCaCheckerReviewDate": null,
                                "riCalApproverLevel": null,
                                "idlBuGroupMarketCap": null,
                                "idlBuTotApproveAmtHkd": null,
                                "idlBuBocRiskRating": null,
                                "idlBuExceptApprLmtHkd": null,
                                "idlBuIsExceptApprove": null,
                                "aiLastApproveDate": null,
                                "aiOverrideApproveLvl": null,
                                "crStatus": null,
                                "crRemark": null,
                                "lastApproveStatus": null,
                                "lastApproveCrId": null,
                                "verifyBy": null,
                                "verifyDt": null,
                                "approveBy": null,
                                "approveDt": null,
                                "createBy": null,
                                "createDt": null,
                                "lastUpdateBy": null,
                                "lastUpdateDt": null,
                                "dslOtherProdTypeDesc": null,
                                "lendingUnitList": [],
                                "apprDetailList": [],
                                "docMapList": [],
                                "guarMapList": [],
                                "idlInfoMapList": [],
                                "pmeExpoTypeList": [],
                                "premFinLoanCcyList": [],
                                "dvpProdList": [],
                                "prProdList": [],
                                "whlProdList": [],
                                "remarkAllList": [],
                                "remarkCurrUserList": [],
                                "shlMapList": [],
                                "spRatioList": []
                                  
                            });

                            dataSourceCapture.fetch(function(){
                                
                                var values = dataSourceCapture.data();

                                for (var i = 0; i < values.length; i++) {


                                    console.log("=========================");

                                    if(values[i].isNew == "Y" && values[i].partyNo == tmpPartyNo && values[i].bizUnit == checkUndefinedElement(splitStrings[1]) && values[i].bookEntity == checkUndefinedElement(splitStrings[2]) && values[i].dataSourceAppId == checkUndefinedElement(splitStrings[3]) && values[i].novaSubAcctId == checkUndefinedElement(splitStrings[4])){                                        
                                        console.log("hit the target");

                                        values[i].isCurrentBatch = "Y";




                                        var displayedIsdaData = $("#isdaResultGrid").data().kendoGrid.dataSource.view();

                                        if(displayedIsdaData.length != 0){
                                            values[i].pmeIsdaId = displayedIsdaData[0].pmeIsdaId;
                                            values[i].pmeIsdaEntity = displayedIsdaData[0].pmeIsdaEntity;
                                            values[i].pmeIsdaPaymentCcy = displayedIsdaData[0].isdaPaymentCcy;
                                            values[i].pmeIsdaNettingCcy = displayedIsdaData[0].isdaNettingCcy;
                                            values[i].pmeIsdaNettingInstrument = displayedIsdaData[0].isdaNettingInstrument;    
                                        }
                                        


                                        var displayedCsaData = $("#csaResultGrid").data().kendoGrid.dataSource.view();


                                        if(displayedCsaData.length != 0){
                                            values[i].pmeCsaId = displayedCsaData[0].pmeCsaId;
                                            values[i].pmeCsaEntity = displayedCsaData[0].pmeCsaEntity;
                                            values[i].pmeCsaCollateralCcy = displayedCsaData[0].csaCollateralCcy;
                                            values[i].pmeCsaBociThreshold = displayedCsaData[0].csaBociThreshold;
                                            values[i].pmeCsaCptyThreshold = displayedCsaData[0].csaCptyThreshold;
                                            values[i].pmeBociMta = displayedCsaData[0].bociMta;
                                            values[i].pmeCsaCptyMta = displayedCsaData[0].csaCptyMta;
                                            values[i].pmeCsaBociIndependentAmount = displayedCsaData[0].csaBociIndependentAmount;
                                            values[i].pmeCsaCptyIndependentAmount = displayedCsaData[0].csaCptyIndependentAmount;
                                            values[i].pmeCsaMarginCallFrequency = displayedCsaData[0].csaMarginCallFrequency;
    
                                        }
                                        

                                        values[i].sblrSblVolatility = parseFloat($("#sblrSblVolatility").html())/100;
                                        values[i].sblrRepoVolatility = parseFloat($("#sblrRepoVolatility").html())/100;

                                        if( $('input[name="radioSet"]:checked').val() == "group"){
                                            values[i].groupName = $("#groupName").html();
                                        }
                                        if($('input[name="radioSet"]:checked').val() == "ccpty"){
                                            values[i].ccdName = $("#ccptyRadioText option:selected").text();
                                        }
                                        
                                        
                                        
                                        


                                        values[i].groupCreditRatingInr = $("#groupCreditRatingInr").html();

                                        values[i].groupCreditRatingMoody = $("#groupCreditRatingMoody").html();

                                        values[i].groupCreditRatingSnp = $("#groupCreditRatingSnp").html();

                                        values[i].groupCreditRatingFitch = $("#groupCreditRatingFitch").html();

                                        values[i].groupRiskRatingForAppr = $("#groupRiskRatingForAppr").html();

                                        values[i].connectedPartyType = $("#connectedPartyType").html();

                                        values[i].countryOfDomicile = $("#countryOfDomicile").html();

                                        values[i].creditRatingInr = $("#creditRatingInr").html();

                                        values[i].creditRatingMoody = $("#creditRatingMoody").html();

                                        values[i].creditRatingSnp = $("#creditRatingSnp").html();

                                        values[i].creditRatingFitch = $("#creditRatingFitch").html();

                                        values[i].riskRatingForApproval = $("#riskRatingForApproval").html();

                                        values[i].holdingType = $("#holdingType").html();

                                        values[i].lmtBizUnit = $('#bizUnitDropDown :selected').val();

                                        values[i].approvalMatrixBu = $("#approvalBizUnit").html();

                                        values[i].approvalMatrixOption = $('#approvalMatrixOption :selected').val();

                                        values[i].inApprovalMatrixBu = $("#approvalBizUnit").html();

                                        values[i].inApprovalMatrixOpt = $('#approvalMatrixOption :selected').val();



                                        values[i].chargor = $("#chargor").val();

                                        values[i].lmtCategory = $('#lmtCategory :selected').val();

                                        values[i].lmtTypeHierLvlId = $('#lmtTypeHierLvlId :selected').val();

                                        values[i].lmtTypeCode = $('#lmtTypeCode :selected').val();

                                        values[i].facPurpose = $("#facPurpose").val();

                                        values[i].lendingUnitList = $('#lendingUnitList :selected').val();

                                        values[i].newLmtCcy = $('#newLmtCcy :selected').val();

                                        values[i].newLmtAmt = $("#newLmtAmt").val();

                                        values[i].coLmtCcy = "";

                                        values[i].coLmtAmt = $("#coLmtAmt").val();

                                        values[i].newLmtExpiryDate = dateToTime(strToDateReverse($("#newLmtExpiryDateField").val()));

                                        values[i].coLmtExpiryDate = dateToTime(strToDateReverse($("#coLmtExpiryDate").val()));

                                        values[i].lmtRiskRating = $("#lmtRiskRating").val();

                                        values[i].collType = $('#collType :selected').val();

                                        values[i].lmtTenor = $("#lmtTenor").val();

                                        values[i].lmtTenorUnit = $('input[name="lmtTenorUnit"]:checked').val();

                                        values[i].pfLoanCcy = $('#pfLoanCcy :selected').val();

                                        /* Pending :  Loanable Currency */

                                        values[i].pfLoanAmt = $("#pfLoanAmt").val();

                                        values[i].shlMapList = JSON.parse("["+getGridFields("shareHolderGrid")+"]");

                                        values[i].isShlBreach = $('input[name="isShlBreach"]:checked').val();

                                        values[i].shlBreachDetail = $('#shlBreachDetail').val();

                                        values[i].shlBreachHaObtain = $('#shlBreachHaObtain').val();

                                        values[i].sblrExcessCashRecallBuf = $('#sblrExcessCashRecallBuf').val();

                                        values[i].sblrMarginCallBuf = $('#sblrMarginCallBuf').val();

                                        values[i].sblrBorrowImRatio = $('#sblrBorrowImRatio').val();

                                        values[i].sblrLendImRatio = $('#sblrLendImRatio').val();

                                        values[i].sblrRepoStockMarginRatio = $('#sblrRepoStockMarginRatio').val();

                                        





                                        /* Pending dvpProdList */
                                        var tmpArrList = [];

                                        $.each($("#dvpProdList :selected"), function(){            
                                            tmpArrList.push($(this).val());
                                        });

                                        

                                        if(tmpArrList.length != 0){
                                            var arrToJson = "[";
                                            for (var p = 0; p < tmpArrList.length; p++) {
                                                arrToJson += "{";
                                                arrToJson += "\"prodCode\" : \""+tmpArrList[p]+"\",";
                                                arrToJson += "\"createBy\" : \"\",";
                                                arrToJson += "\"createDt\" : null,";
                                                arrToJson += "\"lastUpdateBy\" : null,";
                                                arrToJson += "\"lastUpdateDt\" : null";
                                                arrToJson += "},";
                                            };                                
                                            arrToJson = arrToJson.substring(0, arrToJson.length - 1);
                                            arrToJson += "]";
                                            console.log(arrToJson);
                                            values[i].dvpProdList = JSON.parse(arrToJson);
                                        }else{
                                            values[i].dvpProdList = [];
                                        }









                                        /* Pending Lending Unit */
                                        var tmpArrList = [];

                                        $.each($("#lendingUnit :selected"), function(){            
                                            tmpArrList.push($(this).val());
                                        });

                                        
                                        if(tmpArrList.length != 0){
                                            var arrToJson = "[";
                                            for (var p = 0; p < tmpArrList.length; p++) {
                                                arrToJson += "{";
                                                arrToJson += "\"lendUnit\" : \""+tmpArrList[p]+"\",";
                                                arrToJson += "\"createBy\" : \"\",";
                                                arrToJson += "\"createDt\" : null,";
                                                arrToJson += "\"lastUpdateBy\" : null,";
                                                arrToJson += "\"lastUpdateDt\" : null";
                                                arrToJson += "},";
                                            };                                
                                            arrToJson = arrToJson.substring(0, arrToJson.length - 1);
                                            arrToJson += "]";
                                            console.log(arrToJson);
                                            values[i].lendingUnitList = JSON.parse(arrToJson);
                                        }else{
                                            values[i].lendingUnitList = [];
                                        }







                                        values[i].dslOtherProdTypeDesc = $('#dslOtherProdTypeDesc').val();

                                        values[i].fdImRatio = $('#fdImRatio').val();

                                        values[i].fdGreyPeriodDay = $('#fdGreyPeriodDay').val();

                                        values[i].fdIsUfMarginWPdCntl = $('input[name="fdIsUfMarginWPdCntl"]:checked').val();

                                        values[i].fdIsLoanProvide = $('input[name="fdIsLoanProvide"]:checked').val();

                                        values[i].fdIsDefferralAllow = $('input[name="fdIsDefferralAllow"]:checked').val();

                                        values[i].fdOtherControl = $('#fdOtherControl').val();

                                        values[i].lmdLoanAgreementType = $('#lmdLoanAgreementType :selected').val();

                                        values[i].ibdMaxTenorAllow = $('#ibdMaxTenorAllow').val();

                                        values[i].ibdMaxTenorAllowUnit = $('input[name="ibdMaxTenorAllowUnit"]:checked').val();






                                        /* prProdList */
                                        tmpArrList = [];

                                        $.each($("#prProdList :selected"), function(){            
                                            tmpArrList.push($(this).val());
                                        });

                                        if(tmpArrList.length != 0){
                                            var arrToJson = "[";
                                            for (var p = 0; p < tmpArrList.length; p++) {
                                                arrToJson += "{";
                                                arrToJson += "\"prodCode\" : \""+tmpArrList[p]+"\",";
                                                arrToJson += "\"createBy\" : \"\",";
                                                arrToJson += "\"createDt\" : null,";
                                                arrToJson += "\"lastUpdateBy\" : null,";
                                                arrToJson += "\"lastUpdateDt\" : null";
                                                arrToJson += "},";
                                            };                                
                                            arrToJson = arrToJson.substring(0, arrToJson.length - 1);
                                            arrToJson += "]";
                                            console.log(arrToJson);
                                            values[i].prProdList = JSON.parse(arrToJson);
                                        }else{
                                            values[i].prProdList = [];
                                        }









                                        values[i].prlMaxTenorAllow = $('#prlMaxTenorAllow').val();

                                        values[i].prlMaxTenorAllowUnit = $('input[name="prlMaxTenorAllowUnit"]:checked').val();

                                        values[i].prlHaircutRatio = $('#prlHaircutRatio').val();
                                        
                                        values[i].prlOtherProdTypeDesc = $('#prlOtherProdTypeDesc').val();






                                        /* Pending Physical Repo Limit - others */

                                        tmpArrList = [];
                                        
                                        $.each($("#pmeExpoType :selected"), function(){            
                                            tmpArrList.push($(this).val());
                                        });

                                        if(tmpArrList.length != 0){
                                            var arrToJson = "[";
                                            for (var p = 0; p < tmpArrList.length; p++) {
                                                arrToJson += "{";
                                                arrToJson += "\"pmeExpoType\" : \""+tmpArrList[p]+"\",";
                                                arrToJson += "\"createBy\" : \"\",";
                                                arrToJson += "\"createDt\" : null,";
                                                arrToJson += "\"lastUpdateBy\" : null,";
                                                arrToJson += "\"lastUpdateDt\" : null";
                                                arrToJson += "},";
                                            };                                
                                            arrToJson = arrToJson.substring(0, arrToJson.length - 1);
                                            arrToJson += "]";
                                            console.log(arrToJson);
                                            values[i].pmeExpoTypeList = JSON.parse(arrToJson);
                                        }else{
                                            values[i].pmeExpoTypeList = [];
                                        }

                                        



                                        values[i].pmeMaxTenorAllow = $("#pmeMaxTenorAllow").val();


                                        values[i].pmeMaxTenorAllowUnit = $('input[name="pmeMaxTenorAllowUnit"]:checked').val();

                                        values[i].pmeGreyPeriod = $('#pmeGreyPeriod').val();

                                        /*values[i].pmeIsdaId = $('#pmeIsdaIdText').val();

                                        values[i].pmeCsaId = $('#csaIdText').val();*/

                                        values[i].pmeOtherExpoType = $('#pmeOtherExpoType').val();





                                        /* whl */

                                        tmpArrList = [];

                                        $.each($("#whlProdList :selected"), function(){            
                                            tmpArrList.push($(this).val());
                                        });

                                        if(tmpArrList.length != 0){
                                            var arrToJson = "[";
                                            for (var p = 0; p < tmpArrList.length; p++) {
                                                arrToJson += "{";
                                                arrToJson += "\"prodCode\" : \""+tmpArrList[p]+"\",";
                                                arrToJson += "\"createBy\" : \"\",";
                                                arrToJson += "\"createDt\" : null,";
                                                arrToJson += "\"lastUpdateBy\" : null,";
                                                arrToJson += "\"lastUpdateDt\" : null";
                                                arrToJson += "},";
                                            };                                
                                            arrToJson = arrToJson.substring(0, arrToJson.length - 1);
                                            arrToJson += "]";
                                            console.log(arrToJson);
                                            values[i].whlProdList = JSON.parse(arrToJson);
                                        }else{
                                            values[i].whlProdList = [];
                                        }






                                        values[i].userId = window.sessionStorage.getItem("username").replace("\\","\\");







                                        /* values[i].premFinLoanCcyList = []; */
                                        tmpArrList = [];

                                        $.each($("#pfCurrency :selected"), function(){            
                                            tmpArrList.push($(this).val());
                                        });

                                        if(tmpArrList.length != 0){
                                            var arrToJson = "[";
                                            for (var p = 0; p < tmpArrList.length; p++) {
                                                arrToJson += "{";
                                                arrToJson += "\"loanableCcy\" : \""+tmpArrList[p]+"\",";
                                                arrToJson += "\"createBy\" : \"\",";
                                                arrToJson += "\"createDt\" : null,";
                                                arrToJson += "\"lastUpdateBy\" : null,";
                                                arrToJson += "\"lastUpdateDt\" : null";
                                                arrToJson += "},";
                                            };                                
                                            arrToJson = arrToJson.substring(0, arrToJson.length - 1);
                                            arrToJson += "]";
                                            console.log(arrToJson);
                                            values[i].premFinLoanCcyList = JSON.parse(arrToJson);
                                        }else{
                                            values[i].premFinLoanCcyList = [];
                                        }
                                        



                                        values[i].whlOtherControl = $('#whlOtherControl').val();

                                        values[i].whlOtherProdTypeDesc = $('#whlOtherProdTypeDesc').val();

                                        values[i].spRatioList = JSON.parse("["+getGridFields("lmtApplicationGrid")+"]");

                                        values[i].ppProposePrice = $('#ppProposePrice :selected').val();

                                        values[i].ppRatioSign = $('#ppRatioSign :selected').text();

                                        values[i].ppRatio = $('#ppRatio').val();

                                        values[i].ppFeeComm = $('#ppFeeComm').val();

                                        values[i].ppArrangeHandleFee = $('#ppArrangeHandleFee').val();

                                        values[i].ppOthers = $('#ppOthers').val();

                                        values[i].guarMapList = JSON.parse("["+getGridFields("guarantorGrid")+"]");

                                        values[i].docMapList = JSON.parse("["+getGridFields("fileDetailGrid")+"]");

                                        values[i].remarkAllList = JSON.parse("["+getGridFields("remarkAllList")+"]");

                                        values[i].remarkCurrUserList = JSON.parse("["+getGridFields("remarkCurrUserList")+"]");

                                        values[i].riBrRoleDesc = $("#riBrRoleDesc").val();

                                        values[i].riBrName = $("#riBrName").val();

                                        values[i].riBrEmailAddr = $("#riBrEmailAddr").val();

                                        values[i].riBrReviewDate = dateToTime(strToDateReverse($("#riBrReviewDate").val()));

                                        values[i].riBcRoleDesc = $("#riBcRoleDesc").val();

                                        values[i].riBcName = $("#riBcName").val();

                                        values[i].riBcEmailAddr = $("#riBcEmailAddr").val();

                                        values[i].riBcReviewDate = dateToTime(strToDateReverse($("#riBcReviewDate").val()));

                                        values[i].riBaRoleDesc = $("#riBaRoleDesc").val();

                                        values[i].riBaName = $("#riBaName").val();

                                        values[i].riBaEmailAddr = $("#riBaEmailAddr").val();

                                        values[i].riBaReviewDate = dateToTime(strToDateReverse($("#riBaReviewDate").val()));

                                        values[i].idlBuIsExceptApprove = $('input[name="idlBuIsExceptApprove"]:checked').val();

                                        /**/

                                        values[i].isEdit = "N";
                                        values[i].isRoot = "N";
                                        values[i].ccfRatio = parseFloat($("#ccfRatio").html())/100;

                                        

                                        /*if($('input[name="radioSet"]:checked').val() == "group"){

                                            values[i].partyType = "GROUP";
                                            values[i].partyNo = $('#groupName').text();

                                        }else if($('input[name="radioSet"]:checked').val() == "ccpty"){

                                            values[i].partyType = "LEGAL_PARTY";
                                            values[i].partyNo = $('#ccptyRadioText :selected').val();
                                            
                                        }else if($('input[name="radioSet"]:checked').val() == "account"){

                                            values[i].partyType = "ACCOUNT";
                                            values[i].partyNo = $('#accountRadioText :selected').val();
                                            
                                        }else if($('input[name="radioSet"]:checked').val() == "subAccount"){

                                            values[i].partyType = "SUB_ACCOUNT";
                                            values[i].partyNo = $('#subAccountRadioText :selected').val();

                                        }*/
                                    }
                                    
                                        if(values[i].isCurrentBatch == "Y" && values[i].isRoot != "Y"){

                                            values[i].docMapList = JSON.parse("["+getGridFields("fileDetailGrid")+"]");

                                            values[i].remarkAllList = JSON.parse("["+getGridFields("remarkAllList")+"]");

                                            values[i].remarkCurrUserList = JSON.parse("["+getGridFields("remarkCurrUserList")+"]");

                                            values[i].riBrRoleDesc = $("#riBrRoleDesc").val();

                                            values[i].riBrName = $("#riBrName").val();

                                            values[i].riBrEmailAddr = $("#riBrEmailAddr").val();

                                            values[i].riBrReviewDate = dateToTime(strToDateReverse($("#riBrReviewDate").val()));

                                            values[i].riBcRoleDesc = $("#riBcRoleDesc").val();

                                            values[i].riBcName = $("#riBcName").val();

                                            values[i].riBcEmailAddr = $("#riBcEmailAddr").val();

                                            values[i].riBcReviewDate = dateToTime(strToDateReverse($("#riBcReviewDate").val()));

                                            values[i].riBaRoleDesc = $("#riBaRoleDesc").val();

                                            values[i].riBaName = $("#riBaName").val();

                                            values[i].riBaEmailAddr = $("#riBaEmailAddr").val();

                                            values[i].riBaReviewDate = dateToTime(strToDateReverse($("#riBaReviewDate").val()));

                                            values[i].idlBuIsExceptApprove = $('input[name="idlBuIsExceptApprove"]:checked').val();

                                            values[i].aiOverrideApproveLvl = $("#overrideApprList :selected").val();

                                            values[i].apprDetailList = [];
                                            
                                        }
                                    }
                                });


                            var grid = $("#grid").data("kendoGrid");
                            grid.setDataSource(dataSourceCapture);

                            autoSelectedByValue("currencyList-new-"+tmpPartyNo+"-"+tmpPartyType+"-"+tmpCrId+"-"+tmpBizUnit+"-"+tmpBookEntity+"-"+tmpDataSourceAppId+"-"+tmpNovaSubAcctId, $("#newLmtCcy").val());

                            $("#newLmtExpiryDate-new-"+tmpPartyNo+"-"+tmpPartyType+"-"+tmpCrId+"-"+tmpBizUnit+"-"+tmpBookEntity+"-"+tmpDataSourceAppId+"-"+tmpNovaSubAcctId).val($("#newLmtExpiryDateField").val());

                            $("#coLmtExpiryDate-co-"+tmpPartyNo+"-"+tmpPartyType+"-"+tmpCrId+"-"+tmpBizUnit+"-"+tmpBookEntity+"-"+tmpDataSourceAppId+"-"+tmpNovaSubAcctId).val($("#coLmtExpiryDate").val()) ;

                            var values = dataSourceCapture.data();
                            for (var i = 0; i < values.length; i++) {
                                
                                if(values[i].enableNewSection != "Y"){

                                    autoSelectedByValue("currencyList-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId, values[i].newLmtCcy);

                                    $("#currencyList-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).css({"border-width":"0"}); 
                                    $("#currencyList-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});

                                    $("#newLimitAmount-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).css({"border-width":"0"});
                                    $("#newLimitAmount-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});


                                    $("#newLmtExpiryDate-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});
                                }

                                if(values[i].enableCoSection != "Y"){

                                    autoSelectedByValue("currencyList-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId, values[i].coLmtCcy);

                                    $("#currencyList-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).css({"border-width":"0"});
                                    $("#currencyList-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});


                                    $("#coLimitAmount-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).css({"border-width":"0"});
                                    $("#coLimitAmount-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});



                                     $("#coLmtExpiryDate-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});
                                }

                                for (var q = 0; q < values.length; q++) {
                                    if(values[q].isRoot == "Y"){
                                        values[q].userId = window.sessionStorage.getItem("username").replace("\\","\\");
                                    }
                                };
                            }

                    }
                }

                $.each(dataSourceCapture.data(), function(key, value){
                    console.log(value);
                });

                var howManyRubbish = dataSourceGarbage.data();

                for (var i = 0; i < howManyRubbish.length; i++) {
                    console.log("Rubbish Bin : ");
                    console.log(howManyRubbish[i]);
                };

               refreshTheGridFields();
               $("#mainContainer").css({"display":"none"});
            }

            function dateToTime(tmpDate){
                if(tmpDate != "" && tmpDate != null){
                    return tmpDate.getTime();
                }
            }

            function refreshTheGridFields(){

                $("#grid tbody tr:first").css({"background-color":"pink"});

                var values = dataSourceCapture.data();
                for (var i = 0; i < values.length; i++) {
                    autoSelectedByValue("currencyList-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId, values[i].newLmtCcy);

                    autoSelectedByValue("currencyList-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId, values[i].coLmtCcy);

                    $("#newLmtExpiryDate-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).kendoDatePicker({
                        value: "",
                        format: "yyyy/MM/dd"
                    });

                    $("#coLmtExpiryDate-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).kendoDatePicker({
                        value: "",
                        format: "yyyy/MM/dd"
                    });
                    if(values[i].isDeleted == "Y"){
                        console.log(values[i].uid);
                        $("tr[data-uid=" + values[i].uid + "]").css({"display":"none"});
                    }
                }
                values = dataSourceCapture.data();
                for (var i = 0; i < values.length; i++) {
                    if(values[i].enableNewSection != "Y"){

                        autoSelectedByValue("currencyList-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId, values[i].newLmtCcy);

                        $("#currencyList-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).css({"border-width":"0"}); 
                        $("#currencyList-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});

                        $("#newLimitAmount-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).css({"border-width":"0"});
                        $("#newLimitAmount-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});


                        $("#newLmtExpiryDate-new-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});
                    }

                    if(values[i].enableCoSection != "Y"){

                        autoSelectedByValue("currencyList-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId, values[i].coLmtCcy);

                        $("#currencyList-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).css({"border-width":"0"});
                        $("#currencyList-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});


                        $("#coLimitAmount-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).css({"border-width":"0"});
                        $("#coLimitAmount-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});



                         $("#coLmtExpiryDate-co-"+values[i].partyNo+"-"+values[i].partyType+"-"+values[i].crId+"-"+values[i].bizUnit+"-"+values[i].bookEntity+"-"+values[i].dataSourceAppId+"-"+values[i].novaSubAcctId).prop({"disabled":"disabled"});
                    }
                }
            }

            function onChangeCcfRatio(limitType){
                console.log(limitType);
                $.each(JSON.parse(JSON.stringify(dataSourceStaticData.data()[0])), function(key, value) {

                    if(key == "lmtTypeCcfRatio"){

                        $.each(value, function(key, value) {

                           if(limitType == key){
                                $("#ccfRatio").text(parseFloat(value)*100);
                                /*console.log(value);*/
                           }

                       });
                    }
                });
            }

            function resetGuarGrid(){
                removeAllRowsFromGrid("guarantorGrid");
            }

            function submitUpload() {
                
                var data, xhr, uploadType, monitorType;

                data = new FormData();
                data.append( "uploadFile", $("#uploadFile")[0].files[0] );

                xhr = new XMLHttpRequest();

                

                xhr.open( 'POST', window.sessionStorage.getItem('serverPath')+"limitapplication/uploadDocument?&userId="+window.sessionStorage.getItem("username")+"&fileDesc="+$("#fileDescription").val(), true );

                xhr.withCredentials = true;
                
                xhr.onreadystatechange = function () {
                    /**/
                    if (xhr.readyState == 4) { 
                        if (xhr.status == 200) {
                            var respText = xhr.responseText;
                            console.log(respText);
                            var grid = $("#fileDetailGrid").data("kendoGrid");
                            grid.dataSource.add(
                                JSON.parse(respText)                
                            );
                        }
                    }
                };
                xhr.send( data );
            }

            /*function onClickUpload(){

                $("#uploadFile").kendoUpload({
                    multiple: false,
                    async: {
                        saveUrl:window.sessionStorage.getItem('serverPath')+"limitapplication/uploadDocument?userId=RISKADMIN&fileDesc="+$("#fileDescription").val(),
                        removeUrl: true,
                        autoUpload: false
                    },
                    success : onSuccess
                });           

                
                $('.k-upload-selected').trigger('click');

            }*/
            function downloadFileIcon(fileName, fileKey, isNew){
                return "<a target=\"_blank\" href=\""+window.sessionStorage.getItem('serverPath')+"limitapplication/getUploadFile?userId="+window.sessionStorage.getItem("username").replace("\\","\\")+"&fileName="+fileName+"&fileKey="+fileKey+"&isNew="+isNew+"\"> <img style=\"border-style: none\" src=\"/ermsweb/resources/images/bg_update.png\" width=\"20\" height=\"20\"</img> </a>"; 
            }


        </script>
        </div>

    </body>
</html>