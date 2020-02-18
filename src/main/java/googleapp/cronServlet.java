package googleapp;

import java.io.IOException;
import java.util.Properties;
import java.util.logging.Logger;

import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.google.appengine.api.datastore.DatastoreService;

import javax.mail.Message;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.Query;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@SuppressWarnings("serial")
public class cronServlet extends HttpServlet{
	private static final Logger _logger =
			Logger.getLogger(cronServlet.class.getName());
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
	throws IOException{
		
		
		Properties props = new Properties();
		Session session = Session.getDefaultInstance(props, null);
		try {
			_logger.info("cron job has been executed");
			 String emailName = req.getParameter("googleappName");
			
			  Message msg = new MimeMessage(session);
			  msg.setFrom(new InternetAddress("michaelthilborn@gmail.com", "BlogSpot Project"));
			  
			  DatastoreService dataStore = DatastoreServiceFactory.getDatastoreService();
			  Key subscriberKey = KeyFactory.createKey("Subscribers", emailName);

				Query subscriberQuery = new Query("Subscriber", subscriberKey);
				List<Entity> subscribers = dataStore.prepare(subscriberQuery).asList(FetchOptions.Builder.withDefaults());
				for(Entity sub: subscribers){
					msg.addRecipient(Message.RecipientType.TO,
			                   new InternetAddress((String) sub.getProperty("email") + "@gmail.com", "Subscriber"));
					_logger.info("cron job has been executed");
				}
		
			  msg.setSubject("Blogs posted in last 24 hours on Blog Spot");
			  
			  String body = new String();
			  
			  Key emailKey = KeyFactory.createKey("emailName", emailName);

				Query commentQuery = new Query("Email", emailKey).addSort("date", Query.SortDirection.DESCENDING);
				List<Entity> emails = dataStore.prepare(commentQuery).asList(FetchOptions.Builder.withDefaults());
				for(Entity email: emails){
					body += email.getProperty("title") + " by " + email.getProperty("user") + "\n";
				}
				dataStore.delete(emailKey);
				msg.setText(body);
				_logger.info("cron job has been executed");
				
				Transport.send(msg);
		}
		catch(Exception e) {
			// log any exceptions that happen in cron job
			_logger.info("fuck");
		}
	}
	
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException{
		doGet(req,resp);
	}
}