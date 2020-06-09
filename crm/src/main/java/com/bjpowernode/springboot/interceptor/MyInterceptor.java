package com.bjpowernode.springboot.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.bjpowernode.springboot.beans.User;

public class MyInterceptor implements HandlerInterceptor {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		// TODO Auto-generated method stub
		User user=(User)request.getSession().getAttribute("user");
		//判断是否登陆过
		if(user==null) {
			//如果没有登陆过
			//重定向到登录页
			//在实际开发中，对路径的使用一律写成绝对路径
			response.sendRedirect(request.getContextPath()+"/login.jsp");
		}
		return HandlerInterceptor.super.preHandle(request, response, handler);
	}
	
}
