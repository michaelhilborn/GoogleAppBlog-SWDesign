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
	<link type="text/css" rel="stylesheet"
href="/stylesheets/main.css"/>
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
  <div class="loginbuttondiv">
  	<a id="loginButt" href="<%= userService.createLogoutURL(request.getRequestURI()) %>" class="loginbutton">Log Out</a>
    <button onclick="writeBlog()" class="writeBlogButt">Write Blog</button>
  </div>  
  <form id="newBlog" class="blog-popup" action="/sign" method="post">

	<div><input type="text" placeholder ="Title of Blog" name="title" required/></div>
	
	<label for="content"><b>Body of Blog</b></label>
    <div><textarea name="content" rows="3" cols="60"></textarea></div>

    <div><input type="submit" value="Post Blog" /></div>
    <button type="button" onclick="hideBlog()">Close</button>

    <input type="hidden" name="googleappName" value="${fn:escapeXml(googleappName)}"/>

  </form>
<%
	}else {
%>
  <div class="loginbuttondiv">
  	<a id="loginButt" href="<%= userService.createLoginURL(request.getRequestURI())%>" class="loginbutton">Login</a>
  </div>
  
<%		
}
%>
  <h1>Basic BlogSpot</h1>
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
</body>
<script>
function writeBlog(){
	var x = document.getElementById("newBlog");
	x.style.display = "block";
}
function hideBlog(){
	var x = document.getElementById("newBlog");
	x.style.display = "none";
}
</script>
</html>
	
