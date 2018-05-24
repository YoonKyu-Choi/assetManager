package com.eseict.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class AdminInterceptor extends HandlerInterceptorAdapter {
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
		try {
			if(request.getSession().getAttribute("isAdmin") != "TRUE"){
				System.out.println("Intercepted " + request.getRequestURI());
				response.sendRedirect("/assetmanager/loginGet");
				return false;
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return true;
	}
}
