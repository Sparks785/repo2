package com.bjpowernode.springboot.service;

import com.bjpowernode.springboot.beans.User;
import com.bjpowernode.springboot.exception.LoginException;

import java.util.List;

public interface UserService {

	User login(String loginAct, String loginPwd, String ip) throws LoginException;

    List<User> getUsers();
}
