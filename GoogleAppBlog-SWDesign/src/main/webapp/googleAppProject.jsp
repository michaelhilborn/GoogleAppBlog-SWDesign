<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List"%>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>

<head>

</head>

<body>

<% 

	String googleappName = request.getParameter("googleappName");
	if(googleappName==null){
		googleappName = "default";
	}
	
	pageContext.setAttribute("googleappName",googleappName);
	

	UserService userService = UserServiceFactory.getUserService();
	User user = userService.getCurrentUser();
	if(user != null){
		pageContext.setAttribute("user", user);
%>
<p>Hello, ${fn:escapeXml(user.nickname)}! (You can
<a href="<%=userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>
<%
	}else {
%>
<p>Hello!
<a href="<%= userService.createLoginURL(request.getRequestURI())%>">Sign in</a>
so that you can post a blog!</p>
<% 
}
%>

<%
DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
Key googleappKey = KeyFactory.createKey("googleapp",googleappName);
// run an ancestore query to ensure we see the most up-to-date
// view of the greetings belonging to the selected googleapp

	Query query = new Query("Greeting",googleappKey).addSort("user",Query.SortDirection.DESCENDING).addSort("date", Query.SortDirection.DESCENDING);
	List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
	if(greetings.isEmpty()){
%>
	<p>googleapp '${fn:escapeXml(googleappName)}' has no messages.</p>
	<%
	} else{
	%>
	<p>Most recent Blogs from BasicBlogSpot'${fn:escapeXml(googleappName)}'.</p>
	<%
	for(Entity greeting: greetings){
		pageContext.setAttribute("blog_title", greeting.getProperty("title"));
		pageContext.setAttribute("greeting_content",
						greeting.getProperty("content"));
		if(greeting.getProperty("user")==null){
		%>
		<p>An anonymous person wrote:</p>
		<%
		}else{
			pageContext.setAttribute("greeting_user",
							greeting.getProperty("user"));
							%>
			<p><b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:</p>
			<%
			}
			%>
			<h4><b>${fn:escapeXml(blog_title)}</b></h4>
			<blockquote>${fn:escapeXml(greeting_content)}</blockquote>
			<%
			}
			}
			%>

<form action="/sign" method="post">
	<div><textarea name="title" rows="1" cols="60"></textarea></div>
	<div><textarea name="content" rows="3" cols="60"></textarea></div>
	
	<%if(user != null){ %>
		<div><input type="submit" value="Post Blog" ></div>
	<%} %>
	
	<input type="hidden" name="googleappName" value="${fn:escapeXml(googleappName)}"/>
</form>

</body>
</html>
	
