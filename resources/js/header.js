$('header_menu').on('mouseover', 'tr td', function(){
	$(this).css(
		{
			'background-color:': '#DBE9FF'	
		}
	);
})
$('header_menu').on('mouseout', 'tr td', function(){
	$(this).css(
		{
			'background-color:': '#FFFFFF'	
		}
	);
})
function getHeader(){
	document.write("<table width=\"1000\" cellpadding=\"0\" cellspacing=\"0\">");

	document.write("<tr> <td colspan='3' width=\"200 \"><img src=\"images/logo.png\"/></img></td><td><img src=\"images/title.png\"/></td> <td colspan='3' style=\"font-size:13px\" > User: David<br> Last Login: 20150115 18:40:30 </td> </tr>");

	document.write("<tr><td colspan='6'>");

	document.write("<table id=\"header_menu\" cellpadding=\"0\" cellspacing=\"0\" width=\"1000\"><tr height=\"50\" style=\"background-color:#953735;color:white;border-style: solid; border-right-color:red\"> <td style=\"cursor: pointer;border-right-style:solid;border-right-color:red\" align=\"center\" width=\"143\">Home</td> <td style=\"cursor: pointer;border-right-style:solid;border-right-color:red\" align=\"center\" width=\"143\"><a style='color:#fff;text-decoration:none;' href=\"ccp_rmd_detail_maintenance.html\">Client/Counterparty<a/></td> <td style=\"cursor: pointer;border-right-style:solid;border-right-color:red\" align=\"center\" width=\"143\">Limit</td> <td style=\"cursor: pointer;border-right-style:solid;border-right-color:red\" align=\"center\" width=\"143\">Daily Monitoring</td> <td style=\"cursor: pointer;border-right-style:solid;border-right-color:red\" align=\"center\" width=\"143\">Report</td> <td style=\"cursor: pointer;border-right-style:solid;border-right-color:red\" align=\"center\" > <ul id=\"menu6\" style=\"border: 0\"> <li>Maintenance <ul><li style=\"overflow: hidden;\"><a href=\"group_rmd_detail_maintenance.html\">Group Maintenance</a></li></ul> </li> </ul> </td> <td style=\"cursor: pointer;border-right-style:solid;border-right-color:red\" align=\"center\" width=\"143\">Logout</td></tr></table>");

	document.write("</td></tr>")
	document.write("</table>");
}
getHeader();
