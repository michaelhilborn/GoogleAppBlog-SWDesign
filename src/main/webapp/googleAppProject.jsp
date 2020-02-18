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
	List<Entity> greetings = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5));
	if(greetings.isEmpty()){
%>
	<p>Basic BlogSpot currently has no blogs posted :'(</p>
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
			
	<a href = "/blog-history.jsp">View All Blogs</a>
	
	<%
	DatastoreService commentDataStore = DatastoreServiceFactory.getDatastoreService();
	Key commentGoogleAppKey = KeyFactory.createKey("appComments",googleappName);
	// run an ancestore query to ensure we see the most up-to-date
	// view of the greetings belonging to the selected googleapp

	Query commentQuery = new Query("Comment",commentGoogleAppKey).addSort("date", Query.SortDirection.DESCENDING);
	List<Entity> comments = commentDataStore.prepare(commentQuery).asList(FetchOptions.Builder.withLimit(3));
	%>
	<h3><b><u>Comment Section</u></b></h3>
	<%
	for(Entity comment: comments){
		pageContext.setAttribute("comment",
						comment.getProperty("comment"));
		pageContext.setAttribute("comment_date",
				comment.getProperty("date"));
	%>
		<div class = "commentPost">
			
			<blockquote>${fn:escapeXml(comment)}</blockquote>
			
			<p>Posted on ${fn:escapeXml(comment_date)}</p>
		</div>
	<%
	}
	%>
	<form id="newComment" action="/writecomment" method="post">

		<label for="content"><b>Comment:</b></label>
    	<div><textarea name="content" rows="3" cols="60"></textarea></div>

    	<div><input type="submit" value="Post Comment" /></div>
    	<input type="hidden" name="googleappName" value="${fn:escapeXml(googleappName)}"/>

	</form>
	<button onclick="subscribe()">Subscribe</button>
	<button onclick="unsubscribe()">Unsubscribe</button>
</body>
<script>
function subscribe(){
	<%
	
	Key subscriberKey = KeyFactory.createKey("Subscribers",googleappName);
	Entity subscriber = new Entity("Subscriber",googleappKey);
	subscriber.setProperty("email", user);
	DatastoreService subscriberDatastore = DatastoreServiceFactory.getDatastoreService();
	subscriberDatastore.put(subscriber);
	
	%>
}

function unsubscribe(){
<%
	
	Key unsubscriberKey = KeyFactory.createKey("Subscribers",googleappName);
	DatastoreService unsubscriberDatastore = DatastoreServiceFactory.getDatastoreService();
	unsubscriberDatastore.delete(unsubscriberKey);
	
	%>
}

</script>
</html>
	
