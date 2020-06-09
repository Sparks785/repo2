package com.bjpowernode.springboot.service;

import com.bjpowernode.springboot.beans.Activity;
import com.bjpowernode.springboot.vo.Page;

import java.util.List;
import java.util.Map;

public interface ActivityService {

    int save(Activity act);

    Page<Activity> pageList(Map map);

    Boolean delete(String[] id);

    Activity getActivity(String id);

    int update(Activity act);
}
