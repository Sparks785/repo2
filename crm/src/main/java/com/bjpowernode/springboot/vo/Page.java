package com.bjpowernode.springboot.vo;

import java.util.List;

public class Page<T> {
    //总记录条数
    private int total;
    //返回的数据集合
    private List<T> dataList;

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }
}
