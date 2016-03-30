
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
/* Handle underfined / null element */
function checkUndefinedElement(element){
	if(element === null || element === undefined || element === "null" || element === ""){
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

function getMonth(date) {
    var month = date.getMonth() + 1;
    return month < 10 ? '0' + month : '' + month; // ('' + month) for string result
}  

function getDay(date) {
    var day = date.getDate();
    return day < 10 ? '0' + day : '' + day; // ('' + day) for string result
}  

function toDateFormat(dateObj){
	var jsonDate = "/Date("+dateObj+")/";
    var date = new Date(parseInt(jsonDate.substr(6)));

    return date.toString() != "Invalid Date" ? getDay(date)+"/"+getMonth(date)+"/"+date.getFullYear().toString() : "" ;
}
function toDateFormatReverse(dateObj){

	var jsonDate = "/Date("+dateObj+")/";
    var date = new Date(parseInt(jsonDate.substr(6)));

    return date.toString() != "Invalid Date" ? date.getFullYear().toString()+"/"+getMonth(date)+"/"+getDay(date) : "" ;
}
function toDateTimeFormatReverse(dateObj){

	var jsonDate = "/Date("+dateObj+")/";
    var date = new Date(parseInt(jsonDate.substr(6)));

    return date.toString() != "Invalid Date" ? date.getFullYear().toString()+"/"+getMonth(date)+"/"+getDay(date)+ "   " + date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds() : "" ;
}
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
			arrParamValues[i] = "";
		}
	}

	for(i = 0; i < arrURLParams.length; i++){
		if(arrParamNames[i] == paramName){
			return arrParamValues[i];
		}
	}
	return "";
}

function validateResponse(data){
	return (data != null) ? data : "";
}

function getUserId(){
	return window.sessionStorage.getItem("username");
}

function strToDate(dateStr){ // This function is for transforming dd/mm/yyyy -> Data(mm, dd, yyyy)
	var date = new Date();
	if(checkUndefinedElement(dateStr) != "" && checkUndefinedElement(dateStr) != null){

	    var date = new Date();
	    var m = dateStr.match(/^(\d{1,2})\/(\d{1,2})\/(\d{4})$/);


	    date.setDate(m[1]);
	    date.setMonth(m[2]-1);
	    date.setFullYear(m[3]);
	    return date;

	}else{
		return "";
	} 
}

function strToDateReverse(dateStr){ // This function is for transforming dd/mm/yyyy -> Data(mm, dd, yyyy)
	var date = new Date();
	if(checkUndefinedElement(dateStr) != "" && checkUndefinedElement(dateStr) != null){

	    var date = new Date();
	    var m = dateStr.match(/^(\d{4})\/(\d{1,2})\/(\d{1,2})$/);
	    console.log(m[3],m[2],m[1]);

	    date.setDate(m[3]);
	    date.setMonth(m[2]-1);
	    date.setFullYear(m[1]);
	    return date;

	}else{
		return "";
	} 
}


function checkSessionAlive(){

	var checkSessionURL = "http://lxdapp25:8080/ERMSCore/sessionAlive";

	var dataSource = new kendo.data.DataSource({
		transport: {
			read: {
				url: checkSessionURL,
				dataType: "json",
				xhrFields: {
		    		withCredentials: true
		    	},				
				type: "GET",
				complete: function (response, status){
		     		$.each(JSON.parse(response.responseText), function(key, value) {
     					if(value == "false"){
     						window.location.href = "/ermsweb/home";
     					}
		     		});
				}
			}
		},
		schema:{
			model:{
				id: "alive",
				fields: {
					alive: {type: "string"}   
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
function clearDropDownWithoutBlank(params){

	try{

		var item = document.getElementById(params);

		for(var i = item.options.length - 1; i >= 0; i--){
	      	item.remove(i);
	   	}

	}catch(err){
		console.log(err);
	}
}
function displayResult(listName) {
    var x = document.getElementById(listName);
    var txt = "";
    var i;
    for (i = 0; i < x.length; i++) {
        txt = txt + x.options[i].value + ","
    }
    return txt;
}
function displayReturnMessage(jqXHR){
	var obj = JSON.parse(jqXHR.responseText);
	console.log(obj.message.toUpperCase());
	if(obj.message.toUpperCase() == "SUCCESS"){
		document.getElementById('returnMessage').style.color = "green"
		document.getElementById('returnMessage').innerHTML = "Save Successfully.";			
	}else{
		document.getElementById('returnMessage').style.color = "red"
		document.getElementById('returnMessage').innerHTML = "Save Failed : " + obj.message.toUpperCase();			
	}
}
function getBizUnit(selectOption){

	clearDropDownWithoutBlank(selectOption);
    
    var teamdataSource = new kendo.data.DataSource({
        transport: {
            read: {
                url: "/ermsweb/resources/js/businessunit.json",
                dataType: "json",
               /* xhrFields: {
                    withCredentials: true
                },*/
                complete: function(response, status){
                    $.each(JSON.parse(response.responseText), function(key, value) {
                        var option = document.createElement("option");
                        option.text = checkUndefinedElement(value.value);
                        option.value = checkUndefinedElement(value.value);
                        document.getElementById(selectOption).appendChild(option);
                        option = null;
                    });
                }
            }
        },
        schema: {
            data: function(data) {              // the data which the data source will be bound to is in the values field
                //console.log(data);
                return data;
            },
            model:{
                id:"id"
            } 
        }
    });
    teamdataSource.read();
}

function autoSelectedByValue(selectOpt, value){
	$("#"+selectOpt+" option").filter(function() {
	    return $(this).val() == value; 
	}).prop('selected', true);
}
function autoSelectedByText(selectOpt, value){
	$("#"+selectOpt+" option").filter(function() {
	    return $(this).text() == value; 
	}).prop('selected', true);
}
function zeroToEmpty(num){
	if(num == 0){
		return "";
	}else{
		return num;
	}
}
function test(str){
	console.log(str);
}

function removeAllRowsFromGrid(gridName){
	$("#"+gridName).data('kendoGrid').dataSource.data([]); 
}

function fillInToDropDown(listId, value, text){
	var option = document.createElement("option");
	option.text = checkUndefinedElement(text);
	option.value = checkUndefinedElement(value);
	document.getElementById(listId).appendChild(option);
}

function getCheckedCheckbox(scopeId){

	var checkboxes = document.querySelectorAll("#"+scopeId+" input[type='checkbox']:checked");
	var toJsonFormat = "{";

	for (var i = 0; i < checkboxes.length; i++) {
		if(checkboxes[i].value != "" && checkboxes[i].value != null){
			toJsonFormat += "\"" + checkboxes[i].id + "\"  : \"" + checkboxes[i].value + "\", ";	
		}
	};

	if(checkboxes.length > 0){

		toJsonFormat = toJsonFormat.substring(0, toJsonFormat.length - 2);
		toJsonFormat += "}";

	}else{
		toJsonFormat += "}";
	}

	console.log(toJsonFormat);

	return JSON.parse(toJsonFormat);
}

function getSelectOptionFields(scopeId){

	var selectOptions = document.querySelectorAll("#"+scopeId+" select");
	var toJsonFormat = "{";
	var counter = 0;

	for (var i = 0; i < selectOptions.length; i++) {
		if(selectOptions[i].value != "" && selectOptions[i].value != null){
			toJsonFormat += "\"" + selectOptions[i].id + "\"  : \"" + selectOptions[i].value + "\", ";	
			counter++;
		}
	};

	if(counter > 0){

		toJsonFormat = toJsonFormat.substring(0, toJsonFormat.length - 2);
		toJsonFormat += "}";

	}else{
		toJsonFormat += "}";
	}

	console.log(toJsonFormat);

	return JSON.parse(toJsonFormat);
	
}

function getAllInputTextFields(scopeId){

	var textBoxes = document.querySelectorAll("#"+scopeId+" input[type=text]");
	var toJsonFormat = "{";
	var counter = 0;

	for (var i = 0; i < textBoxes.length; i++) {
		if(textBoxes[i].value != "" && textBoxes[i].value != null){
			if(new RegExp("Date").test(textBoxes[i].id)){
				console.log("date ->");
				toJsonFormat += "\"" + textBoxes[i].id + "\" : \"" + formatDate(strToDateReverse(textBoxes[i].value)) +"\", ";
			}else{
				toJsonFormat += "\"" + textBoxes[i].id + "\" : \"" + textBoxes[i].value +"\", ";
			}
			
			counter++;
		}
	};

	if(counter > 0){
		toJsonFormat = toJsonFormat.substring(0, toJsonFormat.length - 2);
		toJsonFormat += "}";	

	}else{
		toJsonFormat += "}";	
	}

	console.log(toJsonFormat);

	return JSON.parse(toJsonFormat);
}

function getAllInputTextFields2(scopeId){

	var textBoxes = document.querySelectorAll("#"+scopeId+" input[type=text]");
	var toJsonFormat = "{";
	var counter = 0;

	for (var i = 0; i < textBoxes.length; i++) {
		if(textBoxes[i].value != "" && textBoxes[i].value != null){
			/*if(new RegExp("Date").test(textBoxes[i].id)){
				console.log("date ->");
				toJsonFormat += "\"" + textBoxes[i].id + "\" : \"" + formatDate(strToDateReverse(textBoxes[i].value)) +"\", ";*/
			
				toJsonFormat += "\"" + textBoxes[i].id + "\" : \"" + textBoxes[i].value +"\", ";
			
			
			counter++;
		}
	};

	if(counter > 0){
		toJsonFormat = toJsonFormat.substring(0, toJsonFormat.length - 2);
		toJsonFormat += "}";	

	}else{
		toJsonFormat += "}";	
	}

	console.log(toJsonFormat);

	return JSON.parse(toJsonFormat);
}

function getAllHiddenFields(scopeId){

	var hiddenField = document.querySelectorAll("#"+scopeId+" input[type=hidden]");
	var toJsonFormat = "{";
	var counter = 0;

	for (var i = 0; i < hiddenField.length; i++) {
		if(hiddenField[i].value != "" && hiddenField[i].value != null){
			if(new RegExp("Date").test(hiddenField[i].id)){
				console.log("date ->");
				toJsonFormat += "\"" + hiddenField[i].id + "\" : \"" + strToDateReverse(hiddenField[i].value) +"\", ";
			}else{
				toJsonFormat += "\"" + hiddenField[i].id + "\" : \"" + hiddenField[i].value +"\", ";
			}
			
			counter++;
		}
	};

	if(counter > 0){
		toJsonFormat = toJsonFormat.substring(0, toJsonFormat.length - 2);
		toJsonFormat += "}";	

	}else{
		toJsonFormat += "}";	
	}

	console.log(toJsonFormat);

	return JSON.parse(toJsonFormat);
}

function formatDate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [day, month, year].join('');
}
function getGridFields(gridName){
	
	var displayedData = $("#"+gridName).data().kendoGrid.dataSource.view();
	var displayedDataAsJSON = JSON.stringify(displayedData);
	var toJsonFormat = "";
	var i = 0;

	$.each(JSON.parse(displayedDataAsJSON), function(key, value) {
		$.each(value, function(key, value) {
			toJsonFormat += "\"" + key + "\"  : \"" + value + "\", ";	
		});
		i++;
	});

	if(i > 0){

		toJsonFormat = toJsonFormat.substring(0, toJsonFormat.length - 2);
		toJsonFormat += ",";

	}else{
		toJsonFormat += "";
	}

	/*console.log(toJsonFormat);*/
	
	return toJsonFormat;
}

function dateToTime(date){
	return date.getTime();
}

function set_multiple_select_prod(selectObj, ary) {

	if(ary.length != 0){
		for(var i = 0; i < selectObj.length; i++) {
			for (var j = 0; j < ary.length; j++) {
				if(ary[j].prodCode == selectObj.options[i].value)	
					selectObj.options[i].selected = true;
			};
		}
	}
}

function set_multiple_select_pme(selectObj, ary) {

	if(ary.length != 0){
		for(var i = 0; i < selectObj.length; i++) {
			for (var j = 0; j < ary.length; j++) {
				if(ary[j].pmeExpoType == selectObj.options[i].value)	
					selectObj.options[i].selected = true;
			};
		}
	}
}

function set_multiple_select_loan(selectObj, ary) {

	if(ary.length != 0){
		for(var i = 0; i < selectObj.length; i++) {
			for (var j = 0; j < ary.length; j++) {
				if(ary[j].loanableCcy == selectObj.options[i].value)	
					selectObj.options[i].selected = true;
			};
		}
	}
}