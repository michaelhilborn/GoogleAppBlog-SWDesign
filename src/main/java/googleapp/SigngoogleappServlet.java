package googleapp;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;



public class SigngoogleappServlet extends HttpServlet {
	
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
		throws IOException{
		
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		//we have one entity group per guestbook with all greetings residing
		// in the same entity group as the guestbook to which they belong.
		// this lets us run a transactional ancestor query to retrive all
		// greetings for a given guestbook. however the write rate to each
		// guestbook should be limited to ~1/second.
		
		String emailName = req.getParameter("googleappName");
		Key emailKey = KeyFactory.createKey("emailName", emailName);
		
		String googleappName = req.getParameter("googleappName");
		
		Key googleappKey = KeyFactory.createKey("googleapp",googleappName);
		
		String title = req.getParameter("title");
		String content = req.getParameter("content");
		Date date = new Date();
		Entity greeting = new Entity("Greeting",googleappKey);
		greeting.setProperty("user",user);
		greeting.setProperty("date", date);
		greeting.setProperty("content", content);
		greeting.setProperty("title", title);
		
		Entity newPost = new Entity("Email", emailKey);
		newPost.setProperty("user", user);
		newPost.setProperty("title", title);
		
		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.put(greeting);
			
		DatastoreService emailDataStore = DatastoreServiceFactory.getDatastoreService();
		emailDataStore.put(newPost);
		
		resp.sendRedirect("/googleAppProject.jsp?googleappName=" + googleappName);
		
	}
						
}

