package com.bjpowernode.springboot.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bjpowernode.springboot.Dao.UserMapper;
import com.bjpowernode.springboot.beans.User;
import com.bjpowernode.springboot.exception.LoginException;
import com.bjpowernode.springboot.utils.DateTimeUtil;

@Service
public class UserServiceImpl implements UserService {
	@Autowired
	private UserMapper userMapper;

	public User login(String loginAct, String loginPwd, String ip) throws LoginException {
		Map map =new HashMap();
		map.put("loginAct", loginAct);
		map.put("loginPwd", loginPwd);
		User user=userMapper.login(map);
		//判断账号密码是否正确
		if(user==null) {
			throw new LoginException("账号密码错误");
		}
		
		//验证失效时间
		String expireTime = user.getExpiretime();
		//获取当前时间
		String currentTime=DateTimeUtil.getSysTime();
		if(expireTime.compareTo(currentTime)<0) {
			throw new LoginException("账号已失效");
		}
		
		//判断锁定状态
		String lockState=user.getLockstate();
		if("0".equals(lockState)) {
			throw new LoginException("账号已锁定");
		}
		
		//判断IP地址
		String Ip=user.getAllowips();
		if(!Ip.contains(ip)) {
			throw new LoginException("ip地址受限 ");
		}
		
		//验证通过
		return user;
	}

	@Override
	public List<User> getUsers() {
		List<User> list=userMapper.selectAll();
		return list;
	}

}
