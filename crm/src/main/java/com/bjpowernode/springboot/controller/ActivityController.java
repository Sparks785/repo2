package com.bjpowernode.springboot.controller;

import com.bjpowernode.springboot.beans.Activity;
import com.bjpowernode.springboot.beans.User;
import com.bjpowernode.springboot.service.UserService;
import com.bjpowernode.springboot.utils.DateTimeUtil;
import com.bjpowernode.springboot.utils.UUIDUtil;
import com.bjpowernode.springboot.vo.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.bjpowernode.springboot.service.ActivityService;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

//市场活动控制器
@Controller
@RequestMapping("/activity")
public class ActivityController {
	@Autowired
	private ActivityService activityService;

	@Autowired
	private UserService userService;

	//获取所有的用户
	@RequestMapping("getUserList.do")
	@ResponseBody
	public List getUserList(){
		List<User> list=userService.getUsers();
		return list;
	}

	//保存市场活动
	@RequestMapping("save.do")
	@ResponseBody
	public Boolean save(Activity act, HttpServletRequest request){
		//设置id
		String id= UUIDUtil.getUUID();
		//创建时间：当前系统时间
		String createTime= DateTimeUtil.getSysTime();
		//创建人：当前登陆的用户
		String creatBy=((User)request.getSession().getAttribute("user")).getName();
		act.setId(id);
		act.setCreatetime(createTime);
		act.setCreateby(creatBy);
		int i=activityService.save(act);
		if(i==1){
			return true;
		}else {
			return false;
		}
	}

	//市场活动分页
	@RequestMapping("pageList.do")
	@ResponseBody
	//结合条件查询、分页查询
	public Page pageList(int pageNo,int pageSize,Activity activity){
		//略过的记录数
		int index=(pageNo-1)*pageSize;
		Map map=new HashMap();
		map.put("index",index);
		map.put("pageSize",pageSize);
		map.put("activity",activity);
		/*
		* 业务层拿到数据后，返回 市场活动信息列表、查询记录总条数
		* 那么返回什么类型好一点
		* （1）map 简单存储以下
		* （2）vo类 复用率高 √
		* 	使该列灵活，可以接受各种类型（通用性）
		*    page<T>
		* 		private int total;
		* 		private List<T> dataList;
		*
		* 将来分页查询，每个模块都由，所以我们选择一个通用的VO类
		* */
		Page<Activity> vo=activityService.pageList(map);
		return vo;
	}
	@RequestMapping("delete.do")
	@ResponseBody
	public Boolean deleteActivity(String[] id){
		Boolean msg=activityService.delete(id);
		return msg;
	}
	@RequestMapping("getUserListAndActivity.do")
	@ResponseBody
	public Map getUserListAndActivity(String id){
		Activity act=activityService.getActivity(id);
		List<User> userList=userService.getUsers();
		Map map=new HashMap();
		map.put("a",act);
		map.put("userList",userList);
		return map;
	}
	@RequestMapping("update.do")
	@ResponseBody
	public Boolean Update(Activity act, HttpServletRequest request){
		//修改时间：当前系统时间
		String editTime= DateTimeUtil.getSysTime();
		//修改人：当前登陆的用户
		String editBy=((User)request.getSession().getAttribute("user")).getName();
		act.setCreatetime(editTime);
		act.setCreateby(editBy);
		int i=activityService.update(act);
		if(i==1){
			return true;
		}else {
			return false;
		}
	}
}
