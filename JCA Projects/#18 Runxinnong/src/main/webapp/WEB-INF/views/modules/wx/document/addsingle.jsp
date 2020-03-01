<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>微信图文消息管理</title>
	<link rel="stylesheet" href="${ctx}/static/layui/css/layui.css">
    <link rel="stylesheet" href="${ctxStatic}/static/weixin/css/iconfont.css">
    <link rel="stylesheet" href="${ctxStatic}/static/weixin/css/build/common.css">
    <script src="${ctxStatic}/static/jquery/jquery-1.8.3.min.js"></script>
	<script src="${ctxStatic}/static/pagination/pagination.js"></script>
    <script src="${ctxStatic}/template-web.js"></script>
    <script src="${ctxStatic}/layui/src/layui.js"></script>
    <script src="${ctxStatic}/layui/mylayui.js"></script>
	<meta name="decorator" content="default"/>
	<style>
    .layui-input {
       height: 38px !important;
    }

</style>
	<script type="text/javascript">
	 layui.use(['layedit', "upload", "form"], function () {
	        var layedit = layui.layedit;
	        var $ = layui.$;
	        var upload = layui.upload;
	        var form = layui.form;
	        form.render();
	        var layeditIndex = layedit.build('content');

	        //开启关闭留言
	        form.on('switch(comment)', function(data){
	            if(data.elem.checked){
	                $("#add_comment_type").show();
	            }else{
	                $("#add_comment_type").hide();
	            }
	        });

	        //同步标题
	        $("#add_tltle").keyup(function () {
	            var v = $(this).val();
	            $(".wxmp-doclist .main p").html(v ? v : "请输入标题")
	        });
	        //提交
	        form.on('submit(addsingle_form)', function (d) {
	            var formData = d.field;
	            var data = {};
	            data.multType=1;//这里指定死
	            data.title = formData.title;
	            data.author = formData.author;

	            data.thumbMediaId = formData.thumbMediaId;
	            data.picPath = formData.picPath;
	            data.showPic = formData.showPic?1:0;

	            data.brief = formData.brief;
	            data.fromUrl = formData.fromUrl;
	            data.needOpenComment=formData.open_comment?1:0;
	            data.onlyFansCanComment=formData.fans_can_comment;
	            data.description = layedit.getContent(layeditIndex);
	            if (data.thumbMediaId == "") {
	                layer.msg("请上传封面图");
	                return false;
	            }
	            if (data.description == "") {
	                layer.msg("请输入文章内容");
	                return false;
	            }
	            $.ajax({
	                url: '${ctx}/wx/wxMsgNews/addSingleNews',
	                data: data,
	                success: function (result) {
	                    if (result.success) {
	                        layer.msg("保存成功");
	                        setTimeout(function () {
	                        	location.href ="${ctx}/wx/wxMsgNews/list?multType=1";
	                        }, 1000);
	                    }
	                },
	            });
	            return false;
	        });
	        //上传
	        upload.render({
	            elem: '#uploader'
	            , url: '${ctx}/wx/wxImgResource/uploadImg'
	            , done: function (result) {
	                if (result.success == 1) {
	                    $("#uploader").html("<img src='" + result.data.url + "' style='width: 150px;height: 150px;'/><p>点击重新上传，或将文件拖拽到此处</p>");
	                    $("#add_picpath").val(result.data.url);
	                    $("#add_thumbMediaId").val(result.data.imgMediaId);
	                    $(".wxmp-doclist .main img").attr("src",result.data.url);
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
        <h2>添加单图文</h2>
    </blockquote>
    <div class="layui-form" action="">
        <div class="layui-row">
            <div class="wxmp-doclist">
                <div class="content">
                    <div class="main">
                        <img src="${ctxStatic}/images/default.png" alt="">
                        <p>请输入标题</p>
                    </div>
                </div>
            </div>
            <div class="fsh-form-lg" id="add_form" style="overflow: hidden;">
                <div class="layui-form-item">
                    <label class="layui-form-label"><i>*</i>标题</label>
                    <div class="layui-input-block">
                        <input type="text" name="title" id="add_tltle" lay-verify="required" placeholder="请输入标题"
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
                        <input type="hidden" name="picPath" id="add_picpath" value="">
                        <input type="hidden" name="thumbMediaId" id="add_thumbMediaId" value="">
                        <div class="layui-upload-drag" id="uploader">
                            <i class="layui-icon"></i>
                            <p>点击上传，或将文件拖拽到此处</p>
                        </div>
                        <input type="checkbox" name="showPic" title="封面图片显示在正文中" lay-skin="primary" id="add_showpic" value="1">
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label"><i>*</i>摘要</label>
                    <div class="layui-input-block">
                        <input type="text" name="brief" id="add_digest" lay-verify="required" placeholder="请输入摘要"
                               class="layui-input">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label">原文链接</label>
                    <div class="layui-input-block">
                        <input type="text" name="fromUrl" id="add_fromurl" lay-verify="required" placeholder="请输入原文链接"
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
                        <textarea name="content" id="content" cols="30" rows="10"></textarea>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label"></label>
                    <div class="layui-input-block">
                        <button type="button" class="layui-btn" lay-submit lay-filter="addsingle_form">立即提交</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>