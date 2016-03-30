
function getProperty(key){
	var value;
ermsresource.init({
	  // path to directory containing message resource files(.properties files),
	  // give empty string or discard this configuration if files are in the
	  // same directory as that of html file.
	  filePath : '/ermsweb/resources/messages/'
	});
ermsresource.load('erms', function(){ 
	  // load file callback 
	
	  // get value corresponding  to a key from config.properties  
	  value = ermsresource.get(key, 'erms');
	 

	});
alert(value);
return value;
}