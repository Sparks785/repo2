package com.bjpowernode.springboot.Dao;

import com.bjpowernode.springboot.beans.Activity;
import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    int deleteByPrimaryKey(String id);

    int insert(Activity record);

    Activity selectByPrimaryKey(String id);

    List<Activity> selectAll();

    int updateByPrimaryKey(Activity record);

    List<Activity> getActivityByCondition(Map map);

    int getTotalByCondition(Map map);

    int delete(String[] id);
}