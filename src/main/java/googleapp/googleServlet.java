package googleapp;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class googleServlet extends HttpServlet{
	
	
	public void doPost(HttpServletRequest req,HttpServletResponse resp)
		throws IOException{
		
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		//we have one entity group per guestbook with all greetings residing
		// in the same entity group as the guestbook to which they belong.
		// this lets us run a transactional ancestor query to retrive all
		// greetings for a given guestbook. however the write rate to each
		// guestbook should be limited to ~1/second.
		
		String googleappName = req.getParameter("googleappName");
		
		Key googleappKey = KeyFactory.createKey("appComments",googleappName);
		
		String content = req.getParameter("content");
		Date date = new Date();
		Entity comment = new Entity("Comment",googleappKey);
		comment.setProperty("date", date);
		comment.setProperty("comment", content);
		
		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
			datastore.put(comment);
			
			
		
		resp.sendRedirect("/googleAppProject.jsp");
	}
}