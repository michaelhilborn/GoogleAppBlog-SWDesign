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
    <a href="/new-blog.html" class="writeBlogButt">Write Blog</a>
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
	<form id="newBlog" class="blog-popup" action="/sign" method="post">

		<label for="title"><b>Title of Blog</b></label>
		<div><input type="text" placeholder ="Title of Blog" name="title" required/></div>
	
		<label for="content"><b>Body of Blog</b></label>
    	<div><textarea name="content" rows="3" cols="60"></textarea></div>

    	<div><input type="submit" value="Post Blog" /></div>
    	<a href="/googleAppProject.jsp">Return to Landing Page</a>

    	<input type="hidden" name="googleappName" value="${fn:escapeXml(googleappName)}"/>

	</form>
</body>