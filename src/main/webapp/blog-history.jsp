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
    <a href="/new-blog.jsp" class="writeBlogButt">Write Blog</a>
  </div>  
<%
	}else {
%>
  <div class="loginbuttondiv">
  	<a id="loginButt" href="<%= userService.createLoginURL(request.getRequestURI())%>" class="loginbutton">Login</a>
  </div>
  
<%		
}
%>
  <div class ="Headline">
  <h1>Basic BlogSpot</h1>
</div>
<%
DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
Key googleappKey = KeyFactory.createKey("googleapp",googleappName);
// run an ancestore query to ensure we see the most up-to-date
// view of the greetings belonging to the selected googleapp

	Query query = new Query("Greeting",googleappKey).addSort("date", Query.SortDirection.DESCENDING);
	List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());
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
		pageContext.setAttribute("greeting_user",
				greeting.getProperty("user"));
		pageContext.setAttribute("blog_date",
				greeting.getProperty("date"));
		%>
		<div class = "blogPost">

			<h4><b><u>${fn:escapeXml(blog_title)}</u></b> -by ${fn:escapeXml(greeting_user.nickname)}</h4>
			
			<blockquote>${fn:escapeXml(greeting_content)}</blockquote>
			
			<p>Posted on ${fn:escapeXml(blog_date)}</p>
		</div>
			<%
			}
		}
			%>
			<a href="/googleAppProject.jsp">Return to Landing Page</a>
</body>
</html>
	