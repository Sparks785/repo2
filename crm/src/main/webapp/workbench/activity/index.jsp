<%@ page import="com.bjpowernode.springboot.beans.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%
	User u=(User)session.getAttribute("user");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<link href="../../jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="../../jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link href="../../jquery/bs_pagination/jquery.bs_pagination.min.css">

<script type="text/javascript" src="../../jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="../../jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="../../jquery/bs_pagination/en.js"></script>

<script type="text/javascript">
	$(function(){
		//为添加按钮绑定事件，打开添加操作模态窗口
		$("#addBtn").click(function(){

		    //给class为time的文本框引入日历格式
            $(".time").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });


            /*
                操作模态窗口的方式
                 需要操作模态窗口的jquery对象，调用modal方法，未改方法传递参数show：打开模态窗口       hide：关闭模态窗口
            */
			//$("#createActivityModal").modal("show");
			//走后台，获取用户信息列表，为所有者下拉列表
            $.get("/activity/getUserList.do",callback,"json");

            /*
            *  List<User> userList
            *  data
            *   [{用户1},{用户2},{用户3}]
            * */
            var html ="<option></option>"
            function callback(data){
                //遍历出来的每一个n就是一个user对象
                $.each(data,function (i,n) {
                    html += "<option value='"+n.id+"'>"+n.name+"<option>"
                })
                $("#owner").html(html);

                //将当前用户设置为下拉框选默认选项
				var UId = "<%=u.getId()%>";
				$("#owner").val(UId);

                //所有者下拉框处理完毕后展现模态窗口
                $("#createActivityModal").modal("show");
            }
		})
        //为保存按钮添加绑定事件，窒执行添加操作
        $("#saveBtn").click(function () {
            $.get("/activity/save.do",
                {
                    "owner":$.trim($("#owner").val()),
                    "name":$.trim($("#name").val()),
                    "startdate":$.trim($("#startDate").val()),
                    "enddate":$.trim($("#endDate").val()),
                    "cost":$.trim($("#cost").val()),
                    "description":$.trim($("#description").val()),
                },
                callback,"json");

            /*
            * 回调函数返回的数据
            * data
            * 	{
            * 		{"success":true/false}
            * 	}
            * */
			function callback(data){
				if(data){
					//添加成功后
					//刷新市场活动列表（局部刷新）
                    //pageList(1,2);
					/*
					* $("#activityPage").bs_pagination('getOption','currentPage'):操作后停留在当前页
					* $("#activityPage").bs_pagination('getOption','rowsPerPage')：操作后维持已经设置好的每页展现记录条数
					* 这两个参数，不需要我们进行任何的修改
					* */
					//pageList(1,$("#activityPage").bs_pagination('getOption','rowsPerPage'));
					pageList(1,5);

					//清空添加操作模态窗口中的数据
					$("#activityForm")[0].reset();

					//关闭添加操作的模态窗口
					$("#createActivityModal").modal("hide");
				}else{
					alert("添加市场活动失败")
				}
			}
        })

        //页面加载完毕后触发一个方法
        //默认展现列表第一页，每页展现两条记录
        pageList(1,5);

		/*
		* pageNo:页码
		* pageSize：每页展现记录条数
		* pageList函数，发出ajax请求到后台，从后台获取最新的市场活动信息列表，通过响应回来的数据局部刷新市场活动列表
		* 在什么情况下需要刷新列表
		* （1）点击左侧市场活动超链接的时候
		* （2）添加、修改、删除，需要刷新列表
		* （3）点击查询按按钮的时候需要刷新列表
		* （4）点击分页组件吗的时候
		* */
		function pageList(pageNo,pageSize){

			//将全选的复选框√干掉
			$("#qx").prop("checked",false);
		    //查询前，将隐藏域中的数据取出来，重新赋予到搜索框中
            $("#search-name").val($.trim($("#hidden-name").val()));
            $("#search-owner").val($.trim($("#hidden-owner").val()));
            $("#search-srartdate").val($.trim($("#hidden-startDate").val()));
            $("#search-enddate").val($.trim($("#hidden-endDate").val()));

			$.get("/activity/pageList.do",
					{
						"pageNo":pageNo,
						"pageSize":pageSize,
						"name":$.trim($("#search-name").val()),
						"owner":$.trim($("#search-owner").val()),
						"startdate":$.trim($("#search-startdate").val()),
						"enddate":$.trim($("#search-enddate").val()),

					},selectList,"json");

            /*
        * date
        * 	市场活动信息列表
        * List<Activity> aList
        * 	【{市场活动1}，{市场活动2}，{市场活动3}】
        *
        * 	总记录数
        *   int total
        * 	{”total“：100}
        * 拼接
        * 	{”total“:100,"dataList":{市场活动L}}
        * */
            function selectList(data){
                var Html="";
                $.each(data.dataList,function(i,n){
                    Html +='<tr class="active">';
                    Html +=' <td><input type="checkbox" value="'+n.id+'" class="xz"/></td>';
                    Html +=' <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'detail.jsp\';">'+n.name+'</a></td>';
                    Html +=' <td>'+n.owner+'</td>';
                    Html +=' <td>'+n.startdate+'</td>';
                    Html +=' <td>'+n.enddate+'</td>';
                    Html +=' </tr>';
                });
                $("#activityBody").html(Html);

                //计算总页数
                var totalPages=data.total%data.pageSize == 0 ? data.total/data.pageSize : parseInt(data.total/data.pageSize)+1;

                //数据处理完毕后结合分页插件，对前端展现分页相关信息
                $("#paginationDiv").bs_pagination({
                    currentPage:pageNo,//当前页
                    rowsPerPage:pageSize,//每页显示条数
                    maxRowsPerPage: 20,
                    totalRows:data.total,//总条数
                    totalPages: totalPages,//总页数
                    visiblePageLinks:3,//最多可以显示的页号卡片数
                    showGoToPage:true,//是否显示跳转到第几页
                    showRowsPerPage:true,//是否显示每页显示多少条
                    showRowsInfo:true,//是否显示分页信息

                    //该回调函数，在点击分页组件的时候触发
                    onChangePage: function(e,pageObj) { // returns page_num and rows_per_page after a link has clicked
                        pageList(pageObj.currentPage,pageObj.rowsPerPage);
                    }
                });
            }
		}

		//为查询按钮绑定事件，触发pagelist函数
		$("#searchBtn").click(function(){

		    /*
		    * 点击查询按钮的时候我们应该将搜索框中的数据存储起来，保存到隐藏域中
		    * */

            $("#hidden-name").val($.trim($("#search-name").val()));
            $("#hidden-owner").val($.trim($("#search-owner").val()));
            $("#hidden-srartDate").val($.trim($("#search-startdate").val()));
            $("#hidden-endDate").val($.trim($("#search-enddate").val()));

			pageList(1,2);
		})

		//为全选的复选框绑定事件
		$("#qx").click(function(){
			$(".xz").prop("checked",this.checked);
		})

		//以下做法不行，因为动态拼接的元素，是不能够以普通绑定事件的形式进行操作的
		/*$(".xz").click(function(){
			alert("123");
		})*/

	/*动态生成的元素，我们要以on方法来触发事件*/
		/*
		* 语法： $(需要绑定元素的有效外层元素).on(绑定事件的方式，需要绑定元素的jquery对象，回调函数)
		* */
		$("#activityBody").on("click",$(".xz"),function(){
			$("#qx").prop("checked",$(".xz").length==$(".xz:checked").length);
		})

		//为删除按钮绑定事件，执行活动名称删除操作
		$("#deleteBtn").click(function () {
			//找到复选框中所有挑钩的复选框对象
			var $xz=$(".xz:checked");
			//判断是否有复选框被选择
			if ($xz.length==0){
				alert("请选择需要删除的记录");
			}else {
				//删除前给用户一个友好的提示
				if(confirm("确定要删除所选中的记录吗？")){
					//url:activity/delete.do?id=xxx&id=xxx;
					//拼接参数
					var param="";
					//将$xz中的每一个dom对象遍历出来，取其value值，就相当于取得了要删除的记录的id
					for (var i=0;i<$xz.length;i++){
						param+="id="+$($xz[i]).val();
						//如果不是最后一个元素，需要在后面追加一个&
						if(i<$xz.length-1){
							param+="&";
						}
					}
					//alert(param);
					//ajax请求
					$.get("/activity/delete.do",param,deleteActivity,"json");
					function deleteActivity(data) {
						/*data
                        {"success":true/false}
                        * */
						if(data){
							//删除成功后
							pageList(1,2);
						}else{
							alert("删除市场活动失败");
						}
					}
				}
				}
		})
		//为修改按钮绑定事件
		$("#editBtn").click(function(){
			var $xz=$(".xz:checked");
			if($xz.length==0){
				alert("请选择要修改的记录");
			}else if ($xz.length>1){
				alert("只能选择一条记录进行修改");
			}else {
				//肯定只选了一条
				var id=$xz.val();
				$.get("/activity/getUserListAndActivity.do", {
					"id":id
				},getMessage,"json");
				function getMessage(data) {
					/*
					* data{
					* 	用户列表
					* 	市场活动单条记录
					*  {
					* 	"userList":[{user1},{user2},{user3}]
					* 	"a":{市场活动单条对象}
					* }
					* }
					* */
					//处理所有者的下拉框
					var html="<option></option>";
					$.each(data.userList,function (i,n) {
						html+="<option value='"+n.id+"'>"+n.name+"</option>";
					})
					$("#edit-owner").html(html);
					//处理单条记录
					$("#edit-name").val(data.a.name);
					$("#edit-owner").val(data.a.owner);
					$("#edit-startTime").val(data.a.startdate);
					$("#edit-endTime").val(data.a.enddate);
					$("#edit-cost").val(data.a.cost);
					$("#edit-describe").val(data.a.description);
					$("#edit-id").val(data.a.id);

					//所有值都修改完毕之后，打开修改操作的模态窗口
					$("#editActivityModal").modal("show");
				}
			}
			//为更新按钮绑定事件，执行市场活动的修改操作
			/*
			* 在我们的实际开发中，一定是先做添加再做修改
			* 所以为了节省开发事件，一般都是copy添加操作
			* */
			$("#update-Btn").click(function(){
				$.get("/activity/update.do",
						{
							"id":$.trim($("#edit-id").val()),
							"owner":$.trim($("#edit-owner").val()),
							"name":$.trim($("#edit-name").val()),
							"startdate":$.trim($("#edit-startTime").val()),
							"enddate":$.trim($("#edit-endTime").val()),
							"cost":$.trim($("#edit-cost").val()),
							"description":$.trim($("#edit-describe").val()),
						},
						callback,"json");

				/*
                * 回调函数返回的数据
                * data
                * 	{
                * 		{"success":true/false}
                * 	}
                * */
				function callback(data){
					if(data){
						//修改成功后
						//刷新市场活动列表（局部刷新）
						pageList(1,2);

						//关闭修改操作的模态窗口
						$("#editActivityModal").modal("hide");
					}else{
						alert("修改市场活动失败")
					}
				}
			})
		});
	});
	
</script>
</head>
<body>
    <%--创建储存查询条数据的隐藏域--%>
    <input type="hidden"id="hidden-name"/>
    <input type="hidden"id="hidden-owner"/>
    <input type="hidden"id="hidden-srartDate"/>
    <input type="hidden"id="hidden-endDate"/>

	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">

						<%--为表单添加隐藏id--%>
						<input type="hidden" id="edit-id"/>

						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
							<label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-name">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startTime" >
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endTime" >
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="update-Btn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form" id="activityForm">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="owner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="name">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="startDate">
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="endDate">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
                    <%--
                        data-dismiss="modal":关闭模态窗口
                    --%>
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls或.xlsx格式]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS/XLSX的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startTime" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endTime">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <!-- 
				  		data-toggle="modal":表示触发该按钮将打开一个模态窗口
				  		
				  		data-target="#createActivityModal"：表示要打开哪个模态窗框
				  		但是这样整体写在标签中写死了，无法进行扩充，应该由我们自己写js代码来操控。
				   -->
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--<tr class="active">
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>
                            <td>zhangsan</td>
                            <td>2020-10-10</td>
                            <td>2020-10-20</td>
                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 30px;">
                <%--画分页组件--%>
				<div id="paginationDiv"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>