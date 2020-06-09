package com.bjpowernode.springboot.service;

import com.bjpowernode.springboot.Dao.ActivityRemarkMapper;
import com.bjpowernode.springboot.beans.Activity;
import com.bjpowernode.springboot.vo.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.bjpowernode.springboot.Dao.ActivityMapper;

import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {
	@Autowired
	private ActivityMapper activityMapper;
	@Autowired
	private ActivityRemarkMapper activityRemarkMapper;


	@Override
	public int save(Activity act) {
		int i=activityMapper.insert(act);
		return i;
	}

	@Override
	public Page<Activity> pageList(Map map) {
		//取得total
		int total=activityMapper.getTotalByCondition(map);

		//取得dataList
		List<Activity> dataList =activityMapper.getActivityByCondition(map);
		//将total和dataList封装到VO中返回
		Page page=new Page<Activity>();
		page.setTotal(total);
		page.setDataList(dataList);
		return page;
	}

	@Override
	public Boolean delete(String[] id) {
		System.out.println(id);
		boolean msg=true;
		//先查询出需要删除的备注的数量
		int count1=activityRemarkMapper.getCount(id);

		//删除备注，返回受到影响的条数（实际删除的数量）
		int count2=activityRemarkMapper.deleteByid(id);

		if(count1!=count2){
			msg=false;
		}

		//删除市场活动
		int count3=activityMapper.delete(id);
		if(id.length!=count3){
			msg=false;
		}
		return msg;
	}

	@Override
	public Activity getActivity(String id) {
		Activity act=activityMapper.selectByPrimaryKey(id);
		return act;
	}

	@Override
	public int update(Activity act) {
		int i=activityMapper.updateByPrimaryKey(act);
		return i;
	}
}
