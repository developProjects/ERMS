<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>

<script src="/ermsweb/resources/js/ermsresources.js"></script>

<link rel="shortcut icon" href="/ermsweb/resources/images/boci.ico" />
<shared:header></shared:header>
<style>

	
           
	#loginForm {
		width: 100%;
		font-size:17px;
		font-weight: 600;
		font-family: "Trebuchet MS", Helvetica, sans-serif;
	    }
  
	  #login .k-textbox{
			 box-sizing: content-box;
			 font-family: "Trebuchet MS", Helvetica, sans-serif;
			 font-size:15px;
			 font-weight: 600;
			 width:50%;
	  }
	  #login #domain{
			 box-sizing: content-box;
			 font-family: "Trebuchet MS", Helvetica, sans-serif;
			 font-size:15px;
			 font-weight: 600;
			 width:50%;
	  }
       }
    #loginForm ul {
        list-style-type: none;
    }
    #loginForm ul li {
        margin: 10px;
    }
    #loginForm ul label {
        display: inline-block;
        width: 90px;
        text-align: left;
		font-weight: 600;
    }
    #loginForm label {
        display: block;
        margin-bottom: 10px;
		font-weight: 600;
    }
    #loginForm .k-button {
        width: 100px;
    }
    .invalid {
   		color: red;
	}
	select{
		background-color: #ffffff;
	    border: 1px solid #cccccc;
	    width: 170px;
	}
	#child-panel
    {
        margin-left: 20px;
        text-align: center;
    }
    #child-panel li
    {
        margin-right: 10px;
        margin-bottom: 10px;
        list-style: none;
        
    }
    #child-panel .k-block{
   		background-color:transparent;
		#text-align:left;
    }
    #loginForm > div{
	   padding-left:28%;
	   width: 30%;
	   padding-top: 5%;
    }
    #tableheader{
    	background-color: #7A0802;
		color: #fff;
		font-size: 21px;
		font-weight: 600;
		text-align: left;
     }
     #loginForm .k-button{
     	background-color:#7A0802;
     	color:#FFFFFF;
     }
     #loginForm .buttons{
     	 padding-left:6%;
     	 margin-top:15px;
     }
	  #login-page{
	  	background:transparent url('/ermsweb/resources/images/loginbkg.jpg') no-repeat 50% 10%;
	  }
	  .k-widget.k-tooltip-validation{margin-left:18%;}
	  #login #child-panel .k-block ul{margin:0;}
	  
</style>  
<body id="login-page">

<div id="loginForm">
   <img src="/ermsweb/resources/images/logo.png"></img> <img src="/ermsweb/resources/images/title.png"></img>
    <div id="login">
		<ul id="child-panel">            
		    <li>
		        <div class="k-block">
				<div class="k-header" id="tableheader">Login</div>
				<ul>
				<li>
				    <label for="username" class="required">User Name</label>
				    <input type="text"  id="username" name="username"  class="k-textbox" placeholder="e.g. user name" required  data-username-msg="Please Enter User Name"/>
				</li>
				<li>
				    <label for="password" class="required">Password</label>
				    <input type="password" id="password" name="password" class="k-textbox" placeholder="password" required min="1"/> 
				</li>
				<li>
				    <label for="domain" class="required">Domain</label>
				    <select id="domain">
				    <option value="HKDM">HKDM</option>
				    <option value="BOCI">BOCI</option>
				    <option value="BOCIS1">BOCIS1</option>
					</select>
				</li>				
				<li class="buttons">
				    <button class="k-button btnSave" id="save">Login</button>
				    <div class="status"></div>
				</li>
			    </ul>
			</div>
		    </li>           
		</ul>
    </div>
</div>

<script>
/* ermsresource.init({
	 	  filePath : '/ermsweb/resources/messages/'
	});
ermsresource.load('erms', function(){ 
	  domain = ermsresource.get('erms.domains', 'erms');
	  var select = $("#domain")[0];
	  var values=domain.split(",");
	  $.each(values, function(index, value) {
		  select.add(new Option(value));
	  });
	});  */
	

	var serverPath = "";

    ermsresource.init({
        filePath : '/ermsweb/resources/messages/' //Path of properties file
    });

    ermsresource.load('erms', function(){ 
    	serverPath = ermsresource.get('erms.baseurl','erms');
    });


	
	var validator = $("#loginForm").kendoValidator().data("kendoValidator");

	$("#save").on("click keypress",function(e) {
	    if(e.which == 13 || jQuery.Event( "click" )) {
	    	if (validator.validate()) {
				var un= $("#username").val().toUpperCase();				
				var ps=encodeURIComponent($("#password").val());
				var dm=$("#domain").val();
				loginCheck(un,ps,dm);
			}
	    }	    
	});
	
	function loginCheck(un,ps,dm,cnfrm){
		var crudServiceBaseUrl = "";
		if(cnfrm){
			crudServiceBaseUrl = serverPath+"login?username="+un+"&password="+ps+"&domain="+dm+"&confirm=Y";
		}else{			
			crudServiceBaseUrl = serverPath+"login?username="+un+"&password="+ps+"&domain="+dm;
		}
		 
		var redirecturl = "/ermsweb/index";
		var dataSource = new kendo.data.DataSource({
			  transport: {
				read: {
				  type: "POST",
				  url: crudServiceBaseUrl,
				  dataType: "json",
				  xhrFields: {
					withCredentials: true
				  }
				}	
			  },
			  schema:{
				  data:function(data){
					  return [data];
				  }
			  },
			requestEnd: function(e) {
				var response = e.response;
				if(response.action=="success"){
				//  window.sessionStorage.setItem('username',response.username.toString().replace("\\", "\\"));
				   window.sessionStorage.setItem('username',response.username);
				   window.sessionStorage.setItem('domain',$("#domain").val());
				   window.sessionStorage.setItem('userId',response.userId);
				   window.sessionStorage.setItem('lastLogin',response.lastLogin);
				   window.sessionStorage.setItem('userRole',response.userRole);
				   window.sessionStorage.setItem('serverPath',serverPath);
				   window.location.href = redirecturl;
				}else{					
					if(response.action =="confirm"){
						var r =  confirm(response.message);
						if (r == true){ 					        			 
							loginCheck(un,ps,dm,true);
						}
					}else{
						$(".status").text("Oops! There is invalid data in the form.").addClass("invalid");
					}
				}
					 
			}			  
		});
		dataSource.read();	
	}
</script>  

</body>
</html>