/* Check the field which is not inputed the special charactors */
function checkInvalidCharactor(fromUI){
	
	var test1 = "12212";
	var regex =  new RegExp("[!@#$%^&*()]");

    if(regex.test(test1)){
    	alert("true");
    }else{
    	alert("false")
    }
}
