package com.bjpowernode.springboot.beans;

public class User {
	//时间有两种格式 
	
	/*
	 * 日期+时间
		 yyyy-MM-dd 10位字符串
	         日期+时间：年月日 时分秒
	         yyyy-MM-dd HH:mm:ss 19位
	*/
	
	/*
	 * 关于登陆
	 * 验证账号和密码
	 * User user = select * from tlb_user where loginAct = ? and loginPwd = ?
	 * user对象为空，则账号密码错误
	 * 再判断 是否失效，锁定状态，浏览器ip是否符合 
	*/
    private String id;//编号，主键

    private String loginact;//登陆账号

    private String name;//用户姓名

    private String loginpwd;//用户密码

    private String email;//用户邮箱

    private String expiretime;//失效时间

    private String lockstate;//锁定状态  0表示锁定  1表示启用

    private String deptno;//部门编号

    private String allowips;//允许访问的ip地址

    private String createtime;//记录创建时间

    private String createby;//创建人

    private String edittime;//修改时间

    private String editby;//修改人

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    public String getLoginact() {
        return loginact;
    }

    public void setLoginact(String loginact) {
        this.loginact = loginact == null ? null : loginact.trim();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getLoginpwd() {
        return loginpwd;
    }

    public void setLoginpwd(String loginpwd) {
        this.loginpwd = loginpwd == null ? null : loginpwd.trim();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email == null ? null : email.trim();
    }

    public String getExpiretime() {
        return expiretime;
    }

    public void setExpiretime(String expiretime) {
        this.expiretime = expiretime == null ? null : expiretime.trim();
    }

    public String getLockstate() {
        return lockstate;
    }

    public void setLockstate(String lockstate) {
        this.lockstate = lockstate == null ? null : lockstate.trim();
    }

    public String getDeptno() {
        return deptno;
    }

    public void setDeptno(String deptno) {
        this.deptno = deptno == null ? null : deptno.trim();
    }

    public String getAllowips() {
        return allowips;
    }

    public void setAllowips(String allowips) {
        this.allowips = allowips == null ? null : allowips.trim();
    }

    public String getCreatetime() {
        return createtime;
    }

    public void setCreatetime(String createtime) {
        this.createtime = createtime == null ? null : createtime.trim();
    }

    public String getCreateby() {
        return createby;
    }

    public void setCreateby(String createby) {
        this.createby = createby == null ? null : createby.trim();
    }

    public String getEdittime() {
        return edittime;
    }

    public void setEdittime(String edittime) {
        this.edittime = edittime == null ? null : edittime.trim();
    }

    public String getEditby() {
        return editby;
    }

    public void setEditby(String editby) {
        this.editby = editby == null ? null : editby.trim();
    }
}