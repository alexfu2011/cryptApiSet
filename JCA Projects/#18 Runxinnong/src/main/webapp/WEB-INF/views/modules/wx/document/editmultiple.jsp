<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/static/layui/css/layui.css">
    <link rel="stylesheet" href="/static/layui/css/layui.css">
    <link rel="stylesheet" href="/static/weixin/css/iconfont.css">
    <link rel="stylesheet" href="/static/weixin/css/build/common.css">
    <script src="/static/jquery/jquery-1.8.3.min.js"></script>
	<script src="/static/pagination/pagination.js"></script>
	<script src="/static/template-web.js"></script>
	<script src="/static/layui/src/layui.js"></script>
	<script src="/static/layui/mylayui.js"></script>
	<style>
		.layui-form-checkbox span{
			height:auto;
		}
	</style>
<script>
layui.use(['layedit', "upload", "form"], function () {
        var layedit = layui.layedit;
        var form = layui.form;
        var layeditIndex=layedit.build('content'); //建立编辑器
        var upload = layui.upload;
        var listData = [];
        var $ = layui.$;
		var id = "${wxMsgNews.id}";
        $.ajax({
            url: "${ctx}/wx/wxMsgNews/toUpdateMultiple",
            data: {id:id},
            success: function (result) {
                if(result.success){
                    listData=result.data;
                    showDataByt(result.data[0].id);
                    $(".wxmp-doclist .main p").html(result.data[0].title);
                    $("#add_tltle").val(result.data[0].title);
                    $("#add_auth").val(result.data[0].author);
//                     $("#add_digest").val(result.data[0].digest);
                    $("#add_fromurl").val(result.data[0].contentSourceUrl);
                    $("#content").html(result.data[0].content);
                    $("#uploader").html("<img src='" + result.data[0].picUrl + "' style='width: 150px;height: 150px;'/><p>点击重新上传，或将文件拖拽到此处</p>");
                    $("#add_picpath").val(result.data[0].picUrl);
                    $("#add_thumbMediaId").val(result.data[0].thumbMediaId);
                    $(".wxmp-doclist .main img").attr("src",result.data[0].picUrl);
                    $("#add_showpic").prop("checked", result.data[0].showCoverPic ? true : false);
                    layeditIndex=layedit.build('content');
                    $.each(listData,function (_,v) {
                        if(_!=0){
                            $(".wxmp-doclist .content").append(template.render(TEMP(v.id,v.title), {}));
                        }
                    });
                    $(".wxmp-doclist .content>.main").attr("data-t",listData[0].id);
                    form.render();
                }
            }
        });





        var TEMP =function (t,title) {
        	var img;
        	$.each(listData,function (_,v) {
                if(v.id==t){
                    if(v.picUrl){
                    	img=v.picUrl
                    }
                }
            });
            return '<div class="item" data-t="'+t+'">'
                + '<img src="'+(img?img:"/images/common/default.png")+'" alt="">'
                + '<p>'+(title?title:"请输入标题")+'</p>'
//                 + '<button class="layui-btn layui-btn-danger">删除</button>'
                + '</div>';
        };
        //取消
        $("#add_canl").click(function () {
//         	location.href = "/views/index.html#/system/document/document";
        	jump("/system/document/document[type=more]");
        });
        //增加一条
        $("#doclist_add").click(function () {
            syncData();
            var t = new Date().getTime();
            $(".wxmp-doclist .content").append(template.render(TEMP(t), {}));
            //设置默认数据
            listData.push(
       		{	
       			id: t,
            	url:'',
            	mediaId:'',
            	newsIndex:listData.length,
            	newsId:0,
            	page:1,
            	pageSize:20,
            	total:0,
            	totalPage:1,
            	account:'',
            	digest:''
            });
            showDataByt(t);
        });
		
        //开启关闭留言
        form.on('switch(comment)', function(data){
            if(data.elem.checked){
                $("#add_comment_type").show();
            }else{
                $("#add_comment_type").hide();
            }
        });

        
        //点击回显
        $(".wxmp-doclist").on("click",".content>.item,.content>.main",function () {
            var t=$(this).attr("data-t");
            $(this).addClass("active").siblings(".active").removeClass("active");
            showDataByt(t);
        });

        //删除一条
        $(".wxmp-doclist").on("click", "button", function () {
            var $item=$(this).parent();
            var isShow=$item.hasClass("active");
            var t=$item.attr("data-t");
            $.each(listData,function (i,v) {
                if(v.id==t){
                    listData.splice(i, 1);
                    $item.remove();
                }
            });
            
            if(isShow){
                $(".wxmp-doclist .main").trigger("click");
            }
        });

        //点击提交
        $("#add_submit").click(function () {
            syncData();
            var isValidated=true;
            var t = $("#add_form").attr("data-t");
			var data=null;
            $.each(listData,function (i,v) {
                if(v.id == t){
                	data=v;
                    return false;
                }
            });
                if(data.title == ""){
                    layer.msg("请完善标题信息");
                    isValidated == false;
                    showDataByt(t);
                    return false;
                }
                if(data.author == ""){
                    layer.msg("请完善作者信息");
                    isValidated == false;
                    showDataByt(t);
                    return false;
                }
                if(data.thumbMediaId == ""){
                    layer.msg("请完善图文封面信息");
                    isValidated == false;
                    showDataByt(t);
                    return false;
                }
                if(data.content == ""){
                    layer.msg("请完善图文正文信息");
                    isValidated == false;
                    showDataByt(t);
                    return false;
                }

                if(isValidated){
                    $.ajax({
                    	type:"POST",
                    	url: '${ctx}/wx/wxMsgNews/updateSubMoreNews',
                        data: {rows:JSON.stringify(data)},
                        success: function (result) {
                            if (result.success) {
                                layer.msg("修改成功");
                                setTimeout(function () {
                                	location.href ="${ctx}/wx/wxMsgNews/list?multType=2";
                                }, 1000);
                            }
                        },
                    });
                }
        });

        //同步标题
        $("#add_tltle").keyup(function () {
            var v=$(this).val();
            var t=$("#add_form").attr("data-t");
            $(".wxmp-doclist div[data-t="+t+"] p").html(v?v:"请输入标题")
        });


        //当前数据同步到listData
        function syncData() {
            var title = $("#add_tltle").val();
            var author = $("#add_auth").val();

            var thumbMediaId = $("#add_thumbMediaId").val();
            var picpath = $("#add_picpath").val();
            var showpic = $("#add_showpic").prop("checked") ? 1 : 0;

//             var brief = $("#add_digest").val();
            var fromurl = $("#add_fromurl").val();
            var open_comment = $("#add_open_comment").prop("checked") ? 1 : 0;
            var fans_can_comment = parseInt($("input[name=fans_can_comment]:checked").val());

            var content=layedit.getContent(layeditIndex);
            var t = $("#add_form").attr("data-t");

            $.each(listData,function (_,v) {
                if(v.id==t){
                    v.title=title;
                    v.auth=author;
//                     v.digest=brief;
                    v.showCoverPic=showpic;
                    v.showCoverPic=showpic;
                    v.picUrl=picpath;
                    v.thumbMediaId=thumbMediaId;
                    v.contentSourceUrl=fromurl;
                    v.needOpenComment=open_comment;
                    v.onlyFansCanComment=fans_can_comment;
                    v.content=content;
                    return false;
                }
            });
        }
        //回显表单
        function showDataByt(t) {
            $.each(listData,function (_,v) {
                if(v.id==t){
                    $("#add_tltle").val(v.title ? v.title : "");
                    $("#add_auth").val(v.author ? v.author : "");

                    $("#add_thumbMediaId").val(v.thumbMediaId ? v.thumbMediaId : "");
                    $("#add_picpath").val(v.picUrl ? v.picUrl : "");
                    $("#add_showpic").prop("checked", v.showCoverPic ? true : false);
                    $("#uploader").html(
                        v.picUrl
                            ? '<img src="' + v.picUrl + '" style="width: 150px;height: 150px;"/><p>点击重新上传，或将文件拖拽到此处</p>'
                            : '<i class="layui-icon"></i><p>点击上传，或将文件拖拽到此处</p>'
                    );

//                     $("#add_digest").val(v.digest ? v.digest : "");
					
                    $("#add_fromurl").val(v.contentSourceUrl ? v.contentSourceUrl : "");
					if(v.needOpenComment==1){
						$("#add_open_comment").prop("checked",true);
						$("#add_comment_type").show();
					}else{
						$("#add_open_comment").prop("checked",false);
						$("#add_comment_type").hide();
					}
					if(v.onlyFansCanComment==1){
						$("input[name=fans_can_comment][value=1]").prop("checked",true);
					}else{
						$("input[name=fans_can_comment][value=0]").prop("checked",true);
					}
                    $("#content").html(v.content ? v.content : "");

                    form.render();
                    layeditIndex = layedit.build('content');

                    $(".wxmp-doclist div[data-t=" + t + "]").addClass("active").siblings(".active").removeClass("active")
                    $("#add_form").attr("data-t", t);
                    return false;
                }
            });
        }
      //上传
        upload.render({
            elem: '#uploader'
            , url: '${ctx}/wx/wxImgResource/uploadImg'
            , done: function (result) {
                if (result.success == 1) {
                    $("#uploader").html("<img src='" + result.data.url + "' style='width: 150px;height: 150px;'/><p>点击重新上传，或将文件拖拽到此处</p>");
                    $("#add_picpath").val(result.data.url);
                    $("#add_thumbMediaId").val(result.data.imgMediaId);
                    var t = $("#add_form").attr("data-t");
                    $(".wxmp-doclist div[data-t=" + t + "] img").attr("src", result.data.url);
                    alert($("#add_picpath").val());
                } else {
                    layer.msg("上传接口异常");
                }
            }
        });
    });
</script>
</head>
<body>
<div class="fsh-rightPanel">
    <blockquote class="site-text layui-elem-quote">
        <h2>编辑多图文</h2>
    </blockquote>
    <div class="layui-form" action="">
        <div class="layui-row">
            <div class="wxmp-doclist">
                <div class="content">
                    <div class="main active" data-t="1">
                        <img src="/images/common/default.png" alt="">
                        <p>请输入标题</p>
                    </div>
                </div>
                <!-- <div class="add" id="doclist_add">
                    <i class="iconfont icon-add"></i>
                </div> -->
            </div>
            <div class="fsh-form-lg" id="add_form" style="overflow: hidden;" data-t="1">
                <div class="layui-form-item">
                    <label class="layui-form-label"><i>*</i>标题</label>
                    <div class="layui-input-block">
                        <input type="text" name="tltle" id="add_tltle" lay-verify="required" placeholder="请输入标题"
                               class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label"><i>*</i>作者</label>
                    <div class="layui-input-block">
                        <input type="text" name="author" id="add_auth" lay-verify="required" placeholder="请输入作者"
                               class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label"><i>*</i>封面图</label>
                    <div class="layui-input-block">
                        <input type="hidden" name="picpath" id="add_picpath" value="">
                        <input type="hidden" name="thumbMediaId" id="add_thumbMediaId" value="">
                        <div class="layui-upload-drag" id="uploader">
                            <i class="layui-icon"></i>
                            <p>点击上传，或将文件拖拽到此处</p>
                        </div>
                        <input type="checkbox" name="showpic" title="封面图片显示在正文中" lay-skin="primary" id="add_showpic"
                               value="1">
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">原文链接</label>
                    <div class="layui-input-block">
                        <input type="text" name="fromurl" id="add_fromurl" lay-verify="required" placeholder="请输入原文链接"
                               class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">留言</label>
                    <div class="layui-input-block">
                        <input type="checkbox" name="open_comment" value="1" lay-skin="switch" lay-text="开启|关闭" checked lay-filter="comment" id="add_open_comment">
                        <div class="layui-inline" id="add_comment_type" style="margin-bottom:0;">
                            <input type="radio" name="fans_can_comment" value="0" title="所有人可留言" checked>
                            <input type="radio" name="fans_can_comment" value="1" title="仅粉丝可留言">
                        </div>
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label"><i>*</i>内容</label>
                    <div class="layui-input-block">
                        <textarea name="" id="content" cols="30" rows="10"></textarea>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label"></label>
                    <div class="layui-input-block">
                        <button type="button" class="layui-btn" id="add_submit">立即提交</button>
<!--                         <button type="button" class="layui-btn" id="add_canl">取消</button> -->
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>