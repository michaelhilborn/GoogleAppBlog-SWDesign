package googleapp;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.*;

@SuppressWarnings("serial")
public class cronServlet extends HttpServlet{
	private static final Logger _logger =
			Logger.getLogger(cronServlet.class.getName());
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
	throws IOException{
		
		try {
			_logger.info("cron job has been executed");
			
			// our logic will go here
			// begin
			// end
		}
		catch(Exception e) {
			// log any exceptions that happen in cron job
		}
	}
	
	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException{
		doGet(req,resp);
	}
}