package com.bjpowernode.springboot.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bjpowernode.springboot.beans.User;
import com.bjpowernode.springboot.exception.LoginException;
import com.bjpowernode.springboot.service.UserService;
import com.bjpowernode.springboot.utils.MD5Util;

@Controller
@RequestMapping("/user")
public class UserController{
	
	@Autowired
	private UserService userService;
	
	@RequestMapping("login.do")
	@ResponseBody
	public Map login(String loginAct,String loginPwd,HttpServletRequest request) {
		//将拿到的明文密码形式，转换成MD5的形式
		loginPwd=MD5Util.getMD5(loginPwd);
		//接受浏览器端ip地址
		String ip=request.getRemoteAddr();
		Map map=new HashMap();
		
		try {
			//service层如果有异常向上抛出异常
			User user=userService.login(loginAct,loginPwd,ip);
			//如果程序执行到此处，表示业务层没有抛出异常，登陆成功
			request.getSession().setAttribute("user", user);
			//登陆成功，向后台返回
			/*
			 * data {"success":true}
			*/
			map.put("success", true);
			
		} catch (LoginException e) {
			//一旦执行catch块的信息，说明业务层验证登陆失败，为controller抛出异常
			e.printStackTrace();
			/*
			 * 登陆失败
			 * data {"success":false,"msg":?}
			*/
			String msg=e.getMessage();
			map.put("success", false);
			map.put("msg", msg);
			
		}
		return map;
	}
}
