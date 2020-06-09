package com.bjpowernode.springboot.Dao;

import com.bjpowernode.springboot.beans.ActivityRemark;
import java.util.List;

public interface ActivityRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(ActivityRemark record);

    ActivityRemark selectByPrimaryKey(String id);

    List<ActivityRemark> selectAll();

    int updateByPrimaryKey(ActivityRemark record);

    int getCount(String[] id);

    int deleteByid(String[] id);
}