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
			  Message msg = new MimeMessage(session);
			  msg.setFrom(new InternetAddress("michaelthilborn@gmail.com", "Example.com Admin"));
			  msg.addRecipient(Message.RecipientType.TO,
			                   new InternetAddress("mtrilborn@gmail.com", "Mr. User"));
			  msg.setSubject("Your Example.com account has been activated");
			  msg.setText("This is a test");
			  Transport.send(msg);
			} catch (Exception e) {
			  // ...
			}
	}
	
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException{
		doGet(req,resp);
	}
}