package googleapp;



import java.io.IOException;
import java.util.logging.Logger;
import javax.servlet.http.*;


import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;



public class SigngoogleappServlet extends HttpServlet {
	private static final Logger log = Logger.getLogger(SigngoogleappServlet.class.getName());
	
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
		throws IOException{
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();
		
		//we have one entity group per googleapp with all greetings residing
		// in the same entity group as the googleapp to which they belong.
		// this lets us run a transactional ancestor query to retrive all
		// greetings for a given googleapp. however the write rate to each
		// googleapp should be limited to ~1/second.
		String content = req.getParameter("content");
		if(content==null) {
			log.info("Greeting posted by user "+ user.getNickname() + ": "+content);
		}else {
			log.info("Greeting posted anonymously: "+content);
		}
			resp.sendRedirect("/googleAppProject.jsp");
		}
						
	}

