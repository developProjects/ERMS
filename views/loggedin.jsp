<%@taglib prefix="kendo" uri="http://www.kendoui.com/jsp/tags"%>
<%@taglib prefix="shared" tagdir="/WEB-INF/tags"%>
<!DOCTYPE html>

<shared:header></shared:header>
<style>
#loginForm {
	width: 100%;
	font-size: 80%;
}

#loginForm h2 {
	border-bottom: 3px solid #8C435A;
	font-size: 2.4em;
	font-weight: strong;
	padding: 6px;
	margin: 0;
	color: #8C435A;
}
</style>
<body>

	<div id="loginForm">
		<h2>
			<img src="/ermsweb/resources/images/logo.png"></img>Enterprise Risk
			Management Systems
		</h2>
		<shared:menu></shared:menu>
		<div>
			<div class="k-block">
				<div class="k-header k-shadow" style="background-color: #e80505">Loggedin</div>
			</div>
		</div>
	</div>
	<script>

var crudServiceBaseUrl = "http://localhost:10080/ermsweb/validate";
var dataSource = new kendo.data.DataSource({
	  batch: true,
	  transport: {
		create: {
	      url: crudServiceBaseUrl
	    },
	    parameterMap: function(data) {
	      return { models: kendo.stringify(data.models) };
	    }
	  },
	  schema: {
	    model: { status: "status" }
	  },
	  requestEnd: function(e) {
          var response = e.response;
      }
	});
	
	$("#save").on("click", function() {
		var un= $("#username").val();
		var ps=$("#password").val();
		var dm=$("#domain").val();
		dataSource.add( { username: un,password:ps,domain:dm} );
		dataSource.sync();
	});
</script>

</body>
</html>