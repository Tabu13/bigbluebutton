<!--

BigBlueButton - http://www.bigbluebutton.org

Copyright (c) 2008-2009 by respective authors (see below). All rights reserved.

BigBlueButton is free software; you can redistribute it and/or modify it under the 
terms of the GNU Lesser General Public License as published by the Free Software 
Foundation; either version 3 of the License, or (at your option) any later 
version. 

BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY 
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along 
with BigBlueButton; if not, If not, see <http://www.gnu.org/licenses/>.

Author: Fred Dixon <ffdixon@bigbluebutton.org>
  
-->

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>API Demo - 3</title>

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
<script type="text/javascript" src="heartbeat.js"></script>


</head>
<body>


<%@ include file="bbb_api.jsp"%>
<%@ include file="demo_header.jsp"%>

<%@ page import="java.util.regex.*" %>

<br>

<% 
if (request.getParameterMap().isEmpty()) {
	//
	// Assume we want to create a meeting
	//
	%>

<hr />
<h2>Demo #3: Create a You Own Meeting.2.</h2>
<hr />

<p />
<FORM NAME="form1" METHOD="GET">

<table width=600 cellspacing="20" cellpadding="20"
	style="border-collapse: collapse; border-right-color: rgb(136, 136, 136);"
	border=3>
	<tbody>
		<tr>
			<td width="50%">Enter your name: <input type="text" name="username" />
			<br />

			<p />
			</td>
			<td width="50%"><INPUT TYPE=hidden NAME=action VALUE="create">
			<br />
			<input type="submit" value="Create" /></td>
		</tr>
	</tbody>
</table>

</FORM>


<%
} else  if (request.getParameter("action").equals("create")) {
	//
	// User has requested to create a meeting
	//
	
    String username = request.getParameter("username");
	String meetingID = URLEncoder.encode(username+"'s meeting","UTF-8");

    String meetingToken = "";
    
	String joinURL = getJoinURL(URLEncoder.encode(username,"UTF-8"), meetingID);

	 	String p = "meetingToken=[^&]*";
	 Pattern pattern =
         Pattern.compile( p );

	 Matcher matcher =
      pattern.matcher( joinURL );
	 
	if (matcher.find()) {
		meetingToken = joinURL.substring(matcher.start(), matcher.end());
	} else {
		out.print("Error: Did not find meeting token.");
	}
	//out.print ("Match : " + meetingToken );
	String inviteURL = BigBlueButtonURL+"demo/demo3.jsp?action=invite&meetingID="+meetingID+"&"+meetingToken;
	
	%>

<hr />
<h2>Created: <%=username %>'s meeting.</h2>
<hr />


<table width="800" cellspacing="20" cellpadding="20"
	style="border-collapse: collapse; border-right-color: rgb(136, 136, 136);"
	border=3>
	<tbody>
		<tr>
			<td width="50%">
			<center><strong> <%=username %>'s meeting</strong> has been
			created.</center>
			</td>

			<td width="50%">Click (or bookmark) the following link to join:
			<p />
			<center><a href="<%=joinURL%>">Join</a> </center>
			<p />&nbsp;
			<p />To invite others, send them the following <a
				href="<%=inviteURL%>">link</a>:
			<form name="empty" method="POST"><textarea cols="60" rows="5"
				name="myname" style="overflow: hidden">
<%=inviteURL%>
</textarea></form>
			</td>
		</tr>
	</tbody>
</table>







<%
	
} else if (request.getParameter("action").equals("enter")) {
	String meetingID = request.getParameter("meetingID");
	String username = request.getParameter("username");
	String meetingToken = request.getParameter("meetingToken");
	out.println( "MeetingID: #"+meetingID+"#");
	
	String enterURL = BigBlueButtonURL+"demo/demo3.jsp?action=join&username="+URLEncoder.encode(username,"UTF-8")+"&meetingID="+URLEncoder.encode(meetingID,"UTF-8");
	//out.print( "meetingID: # 1 #" + meetingID +"#" );	
	//out.print( "meetingToken: ##" + meetingToken +"#" );
	// out.print( "meetingRunning: ## ##" + isMeetingRunning( meetingToken, meetingID ) + "## #"); 
	//out.print( "meetingRunning: ##" + getURLisMeetingRunning(meetingToken, meetingID ));

	if ( isMeetingRunning( meetingToken, URLEncoder.encode(meetingID,"UTF-8")).equals("true") ) {
		//
		// The meeting is running so let's join now
		//
		%> 
<script type="text/javascript">
	window.location = "<%=enterURL %>";
</script>
<% 
	} else {
		//
		// The meeting has not yet started, so let's poll every five seconds until the meeting begins
		//
	String checkMeetingStatus = getURLisMeetingRunning(meetingToken, URLEncoder.encode(meetingID,"UTF-8") );

	%>

<script type="text/javascript">
$(document).ready(function(){
 $("#msgid1").html("This is Hello World by JQuery 13");
});

	$(document).ready(function(){
		$.jheartbeat.set({
		   url: "<%=checkMeetingStatus%>",
		   delay: 5000
		}, function () {
			mycallback();
		});
		});


function mycallback() {
	var isMeetingRunning = $("#HeartBeatDIV > response > running").text();
	if ( isMeetingRunning == "true" ) {
		//alert("true");
		window.location = "<%=enterURL %>";
	}
	
	$("#msgid1").text( "*********** fred #" + isMeetingRunning + "# " + new Date() );

}
</script>

<hr />
<h2>Now waiting for <strong><%=meetingID %></strong> to start.</h2>
<hr />


<table width=600 cellspacing="20" cellpadding="20"
	style="border-collapse: collapse; border-right-color: rgb(136, 136, 136);"
	border=3>
	<tbody>
		<tr>
			<td width="50%">

			<p>Hi <%=username %>.  Waiting for <strong><%=meetingID %></strong> to start.</p>
			<br/>
			<p>(You will be automatically entered into the meeting when it starts).</p>
			</td>
			<td width="50%">&nbsp;</td>
		</tr>
	</tbody>
</table>


<%
	}
} else if (request.getParameter("action").equals("invite")) {
	//
	// We have an invite to an active meeting.  Ask the person for their name 
	// so they can join.
	//
	String meetingID = request.getParameter("meetingID");
	String meetingToken = request.getParameter("meetingToken");
	//out.print( "meetingID: #" + meetingID +"#" );	
	//out.print( "meetingToken: #" + meetingToken +"#" );
	//out.print( "meetingRunning: #" + isMeetingRunning( meetingToken, meetingID ));

	
	%>

<hr />
<h2><strong>You are requesting to join <%=meetingID %></strong>.</h2>
<hr />

<FORM NAME="form1" METHOD="GET">

<table width=600 cellspacing="20" cellpadding="20"
	style="border-collapse: collapse; border-right-color: rgb(136, 136, 136);"
	border=3>
	<tbody>
		<tr>
			<td width="50%">Enter your name: <input type="text" name="username" />
			<br />
			<INPUT TYPE=hidden NAME=meetingID VALUE="<%=meetingID %>">
			<INPUT TYPE=hidden NAME=meetingToken VALUE="<%=meetingToken %>">
						<p />You are requesting to join <strong><%=meetingID %></strong>.
			</td>
			<td width="50%"><INPUT TYPE=hidden NAME=action VALUE="enter">
			<br />
			<input type="submit" value="Enter" /></td>
		</tr>
	</tbody>
</table>

</FORM>




<%
} else if (request.getParameter("action").equals("join")) {
	//
	// We have an invite request to join an existing meeting and the meeting is running
	//
	String username = URLEncoder.encode(request.getParameter("username"),"UTF-8");
	String meetingID = URLEncoder.encode(request.getParameter("meetingID"),"UTF-8");
	String joinURL = getJoinURL(username, meetingID);
	%>

<script language="javascript" type="text/javascript">
	window.location.href="<%=joinURL%>";
</script>

<% } %>

<%@ include file="demo_footer.jsp"%>

</body>
</html>