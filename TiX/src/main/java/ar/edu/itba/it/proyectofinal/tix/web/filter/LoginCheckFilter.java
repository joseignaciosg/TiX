package ar.edu.itba.it.proyectofinal.tix.web.filter;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

@Component
public class LoginCheckFilter extends OncePerRequestFilter {

	protected static Logger logger = Logger.getLogger(LoginCheckFilter.class);
	
	public LoginCheckFilter() {
	}

	@Override
	protected void doFilterInternal(HttpServletRequest req, HttpServletResponse resp, FilterChain chain)
			throws ServletException, IOException {
		HttpServletRequest httpReq = (HttpServletRequest) req;
		String requestUrl = getRequestUrl(httpReq);

		Integer userId = (Integer) httpReq.getSession().getAttribute("userId");
		boolean isloggedIn = (userId != null);
		req.setAttribute("isLogged", isloggedIn);
		if (!isloggedIn) {
			if (isAvaiableWithoutLogin(requestUrl) || req.getServerName().equals("localhost")) {
//				System.out.println("ADDDDDDDRESSSSSSS: " +  req.getRemoteAddr());
//				System.out.println("ADDDDDDDRESSSSSSS2: " +  req.getLocalAddr());
//				System.out.println("ADDDDDDDRESSSSSSS3: " +  req.getLocalName());
//				System.out.println("ADDDDDDDRESSSSSSS3: " +  req.getServerName());
				chain.doFilter(req, resp);
			} else {
				req.setAttribute("errorDescription", "No posee permisos suficientes para ver esta p&aacute;gina.");
				req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, resp);
			}
			return;
		}
		chain.doFilter(req, resp);
	}
	
	

	private boolean isAvaiableWithoutLogin(String requestUrl) {
		String[] availableUrl = {
			"login/", "login/login", "user/home","account/register","account/recover",
			"account/login", "account/changepassword", "account/recoverpassword", 
			"static/about", "api/authenticate", "api/newInstallation", "api/newISPPost", "user/users", "user/ispcharts"
		};
		for (String url: availableUrl) {
			if (requestUrl.startsWith("bin/" + url)) {
				return true;
			}
		}
		return false;
	}

	private String getRequestUrl(HttpServletRequest httpReq) {
		String context = httpReq.getContextPath() + "/";
		String requestUrl = httpReq.getRequestURI();
		requestUrl = requestUrl.substring(requestUrl.indexOf(context) + context.length());
		return requestUrl;
	}

}