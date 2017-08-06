<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://eos.primeton.com/tags/html" prefix="h"%>
<%@ taglib uri="http://eos.primeton.com/tags/logic" prefix="l"%>
<%@ taglib uri="http://eos.primeton.com/tags/bean" prefix="b"%>
<%@ taglib uri="http://eos.primeton.com/tags/eos" prefix="e"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path;
    //首先判断MUO中是否语言
    String currentLang = "";
    String vTokenDummy = "";
    com.eos.data.datacontext.IMUODataContext muo = com.eos.data.datacontext.DataContextManager.current().getMUODataContext();
    if (muo.get("currentLanguage") != null){
       currentLang = muo.get("currentLanguage").toString();
       javax.servlet.http.Cookie cookie = new Cookie("SAIPLANG", currentLang);
       cookie.setPath("/");
       cookie.setMaxAge(3600*24*10);       
       response.addCookie(cookie);
       vTokenDummy = "通过MUO设置了一次";
    }
    if (currentLang.equals("")){//如果MUO中没有语言,检查Cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null){
	        for(int i = 0; i < cookies.length; i++){
	           if (cookies[i].getName().equalsIgnoreCase("SAIPLANG")){
	               currentLang = cookies[i].getValue();
	               vTokenDummy = vTokenDummy + "通过Cookie设置了一次";
	           }
	        }
        }
    }
	String tmp = request.getHeader("Accept-Language"); 
  	if(tmp==null || tmp.equals("")) {
		tmp = "zh-cn";
	}
	String[] ls = tmp.split(",");
	if (currentLang.equals("")){ //如果Cookie中也没有找到，就取浏览器传入的语言
	   currentLang = ls[0];
	    vTokenDummy = vTokenDummy + "通过浏览器语言设置了一次";
	}
	
	String currentSrcLang = currentLang;
	if (currentLang.indexOf("-") > 0){
	    String[] vDummy = currentLang.split("-");
	    if (vDummy.length > 1){
	        currentSrcLang = vDummy[0] + "_" + vDummy[1].toUpperCase();
	    }else{
	        currentSrcLang = vDummy[0];
	    }
	}else if (currentLang.indexOf("_") > 0) {
	    String[] vDummy = currentLang.split("_");
	    if (vDummy.length > 1){
	        currentSrcLang = vDummy[0] + "_" + vDummy[1].toUpperCase();
	    }else{
	        currentSrcLang = vDummy[0];
	    }
	}
	//
	//String vQueryLable = com.eos.foundation.eoscommon.ResourcesMessageUtil.getI18nResourceMessage("l_sys_main_title", currentSrcLang);	//获取标签中使用的国际化资源信息
	//上面这样取，到直有问题，改成下面的
	String vQueryLable="新决裁系统";
	String ShowMainFrame = request.getAttribute("ShowMainFrame")==null?"N":request.getAttribute("ShowMainFrame").toString();
	String TargetMenuIds = request.getAttribute("TargetMenuIds")==null?"":request.getAttribute("TargetMenuIds").toString();		
%>
<html>
<head>
	<%@include file="/scripts/common/domain.jsp"%>	
    <title><%=vQueryLable %></title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <link href="<%=basePath %>/scripts/dtree/dtree.css" rel="stylesheet" type="text/css" />
    <link href="<%=basePath %>/css/mdp.css" rel="stylesheet" type="text/css" />  
	<script src="<%=basePath %>/scripts/bootmdp.js" type="text/javascript"></script>	        
    <script src="<%=basePath %>/scripts/main/main.js" type="text/javascript"></script>
    <script src="<%=basePath %>/scripts/dtree/dtree.js" type="text/javascript"></script>
	
	<!--添加消息推送服务-->
	<link rel="stylesheet" href="<%=basePath %>/scripts/ems-push/push-client.css">
    <script src="<%=basePath %>/scripts/ems-push/push-client.js"></script>
	
</head>
<body>
    <input id="ShowMainFrame" class="sui-hidden" value="<%=ShowMainFrame %>"/>
    <input id="TargetMenuIds" class="sui-hidden" value="<%=TargetMenuIds %>"/>    
	<form id="mainForm" checkType="blur" method="post" action="com.saip.mainframework.login.flow" >
		<input type="hidden" name="_eosFlowAction" id="idAction">
	</form>
	<div id="layout1" class="sui-layout" style="width:100%;height:100%;">
	    <div class="header" region="north" height="50" showSplit="true" showHeader="false" showSplitIcon="true">
		  <div id="header_title"><span style="color:#fff;"> Panasonic 新决裁系统</span></div>
		  <div id="header_info">
			<span>
				<span style="font-size:12px;color:#fff;"><b:message key="l_welcome1"  locale="<%=currentSrcLang %>"/>:${userObject.userName}</span>
				<input type="hidden" id='userId' name = 'userId' value='${userObject.userId}'/>
				<a href="#" onclick="main.onPWD()"><b:message key="l_changePwd" locale="<%=currentSrcLang %>"/></a>
				<a href="#" onclick="main.onPreferencesSetting()"><b:message key="l_preferences" locale="<%=currentSrcLang %>"/></a>
				<!--a href="#" onclick="main.onClickLogout()"><b:message key="l_logout" locale="<%=currentSrcLang %>"/></a -->
				<a href="javascript:window.opener=null;window.open('','_self');window.close();">退出</a>
			</span>
			
		  </div>
	    </div>
	    <div title="center" region="center" style="border:0; top:-20px;" bodyStyle="overflow:hidden;" >
	        <div class="sui-splitter" style="width:100%;height:100%;" borderStyle="border:0;">
	            <div id="leftTree" size="180" maxSize="250" minSize="100" showCollapseButton="true" style="border:0;overflow:auto;" >
	            </div>
	            <div showCollapseButton="true" style="border:0;">
	                <div id="mainTabs" class="sui-tabs" activeIndex="0" style="width:100%;height:100%;" plain="false" 
	                	contextMenu="#tabsMenu" oncloseclick="main.closeTab" ontabload="main.onFinish">
	                    <div id="home" name="first" title="首页" url="<%=basePath %>/apps/process/tabPage.jsp" >
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>

	</div>
    <ul id="tabsMenu" class="sui-contextmenu" onbeforeopen="main.onBeforeOpen">
        <li onclick="main.closeTab">关闭标签页</li>
        <li onclick="main.closeAllBut">关闭其他标签页</li>
        <li onclick="main.closeAll">关闭所有标签页</li>
        <li onclick="main.closeAllButFirst">关闭其他[首页除外]</li>
    </ul>
	<%@include file="../scripts/common/script.jsp"%>
</body>
</html>