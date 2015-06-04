# -*- force_encoding:utf-8 -*-
# -*- coding:utf-8 -*-

#本脚本用户生成课文分组页面的数据
require 'json'

mp3path='mp3/'
imgpath='img/'
filename=''
htmlname=''
lineFlag='<br/>'		#换行标记
data={}

if(ARGV.length!=2)
	puts "USAGE:==============\n\tStart:ruby xxx.rb 第一组.txt zu_01.html"
else
	filename=ARGV[0]
	htmlname='output/'+ARGV[1]
	
	f=File.open(filename)

	#设置一个闭合标记
	blocking=false		
	keyflag=''
	value=''

	#读取文本的每一行
	f.each_line do |line|
		line.force_encoding("UTF-8")
		line.strip!

		if line[0]=="#"
			#将包封闭
			if(blocking)
				blocking=false
				data[keyflag]=value
				keyflag=''
				value=''
			end


			if(line.match('#组'))
				data['bigTitle']= line.split(' ')[1]
			elsif (line.match('#标题'))
				data['title']=line.split(' ')[1]
			elsif (line.match('#音乐'))
				data['mp3']=mp3path+line.split(' ')[1]
			elsif (line.match('#序言'))
				blocking=true
				keyflag='contents'
				value=[]
			elsif line.match('#图')
				blocking=true
				keyflag='imgs'
				value=[]
			elsif line.match('#课')
				# blocking=true
				# keyflag='lessons'
				# value=[]
				link=line.split(/[ 　\s]{1,2}/)[1]
				title=f.readline
				lesson=f.readline
				f.readline
				title.force_encoding('UTF-8')
				title.strip!
				lesson.force_encoding('UTF-8')
				lesson.strip!
				if(!data['lessons'])
					data['lessons']=[]
				end
				b={}
				b['title']=title
				b['lesson']=lesson
				b['link']=link
				data['lessons'].push(b)

			end
		elsif keyflag=='contents'
			value.push(line)
		elsif keyflag=='imgs'
			value.push(imgpath+line)
		end
	end

	str=%Q{<!DOCTYPE html><html lang="zh_CN"><head><meta charset="UTF-8"><title>demo</title><link href="image/favicon.ico"rel="shortcut icon"type="image/vnd.microsoft.icon"/><link rel="stylesheet"type="text/css"href="css/Normalize.css"/><link rel="stylesheet"type="text/css"href="css/dtree.css"/><link rel="stylesheet"type="text/css"href="css/style.css"/><link rel="stylesheet"type="text/css"href="css/plugins-css/brush.css"/><script type="text/javascript"src="js/jquery-1.11.2.min.js"></script><script type="text/javascript"src="js/dtree.js"></script><script type="text/javascript"src="js/plugins-js/draw.js"></script><script type="text/javascript"src="js/plugins-js/jquery.mousewheel.js"></script><script type="text/javascript"src="js/nav.js"></script><script type="text/javascript"src="js/index.js"></script><style type="text/css">#indexStyle1{width:720px;border:1px solid#ccc}#indexStyle2{width:720px;background-color:#C0E7F7;border:1px solid#ccc;margin-top:-2px}h1{text-align:right;font-family:"微软雅黑";color:#0095D9;line-height:60px;padding-right:60px;font-size:40px}h2{text-align:right;font-family:"微软雅黑";color:#0095D9;line-height:60px;padding-right:60px;font-size:32px}#contents p{font-family:"楷体";text-align:right;padding-right:60px}ul{margin-left:-75px}li{float:left;list-style:none;margin-left:70px}.indexSpan1{font-family:"微软雅黑";font-weight:bold;display:inline-block;line-height:36px;margin-left:80px}.indexSpan2{font-family:"楷体";font-size:18px;display:inline-block;line-height:36px;margin-left:100px}.bottomSpan{width:720px;display:block;height:36px;background-color:#75C3DF}button{cursor:pointer}#bianji{font-size:16px;position:fixed;top:300px;width:30px;height:138px;background-color:#0095d9;text-align:center;line-height:23px;cursor:pointer;color:#FFFFFF}#bianji1{display:none;font-size:16px;position:fixed;top:300px;width:30px;height:92px;background-color:#f05183;text-align:center;line-height:23px;cursor:pointer;color:#FFFFFF}#brush{display:none}</style><script type="text/javascript">$(document).ready(function(){var isScorll=true;$("#hide").click(function(){$("#nav").css("margin-left","-30%");$("#contents").css("width","100%");$("#contents").css("margin-left","-30%");$("#show").show();$("#hide").hide();$("#content").css("width","70%");$("#content").css("margin-left","-35%");$("html").css("background-color","#EEEEEE")});$("#show").click(function(){$("#nav").css("margin-left","0px");$("#contents").css("width","70%");$("#contents").css("margin-left","0px");$("#show").hide();$("#hide").show();$("#content").css("width","100%");$("#content").css("margin-left","-50%")});$("#showDiv").click(function(){$("#showDiv").hide();$("#showDivss").hide()});$("#bianji").click(function(){isScorll=false;$("#brush").show();$("#bianji").hide();$("#bianji1").show()});$("#exitbianji").click(function(){isScorll=true;$("#brush").hide();$("#bianji").show();$("#bianji1").hide();clearContext('1');$("#color").hide()});$("body").on('mousewheel',function(event){if(!isScorll){event.preventDefault();event.stopPropagation()}});$("body").keydown(function(event){if(event.which==33||event.which==34||event.which==37||event.which==38||event.which==39||event.which==40){if(!isScorll){event.preventDefault();event.stopPropagation()}}})});function showBtn(id){$("param").attr("value","swf/"+id+'.swf');$("object").attr("data","swf/"+id+'.swf');$("#showDiv").show();$("#showDivss").show()}</script></head><body><div style="position:fixed;width:100%;z-index:100000000000000000;"id="brush"><canvas id="canvas">浏览器不支持哦，亲</canvas><canvas id="canvas_bak"></canvas><div id="drawController"><img src='img/plugins-img/pencil.png'width='20px;'height='20px;'class="img"onclick="draw_graph('pencil',this)"class='border_nochoose'title='铅笔'/><img src='img/plugins-img/line.png'width='20px;'height='20px;'class="img"onclick="draw_graph('line',this);"class='border_nochoose'title='画直线'/><img src='img/plugins-img/cancel.png'width='20px;'height='20px;'class="img"onclick="cancel(this)"class='border_nochoose'title='撤销上一个操作'/><img src='img/plugins-img/next.png'width='20px;'height='20px;'class="img"onclick="next(this)"class='border_nochoose'title='重做上一个操作'/><img src='img/plugins-img/square.png'width='20px;'height='20px;'class="img"onclick="draw_graph('square',this)"class='border_nochoose'title='方形'/><img src='img/plugins-img/circle.png'width='20px;'height='20px;'class="img"onclick="draw_graph('circle',this)"class='border_nochoose'title='圆'/><img src='img/plugins-img/handwriting.png'width='20px;'height='20px;'class="img"onclick="draw_graph('handwriting',this)"class='border_nochoose'title='涂鸦'/><img src='img/plugins-img/rubber.png'width='20px;'height='20px;'class="img"onclick="draw_graph('rubber',this)"class='border_nochoose'title='橡皮擦'/><img src='img/plugins-img/xx.png'width='20px;'height='20px;'class="img"onclick="clearContext('1')"class='border_nochoose'title='清屏'/><!--<img src='img/plugins-img/line_size_1.png'id="chooseSize"width='20px;'height='20px;'class="img"onclick="showLineSize(this)"class='border_nochoose'title='线条大小'/><img src='img/plugins-img/save.png'width='20px;'height='20px;'class="img"onclick="save()"class='border_nochoose'title='保存'/>--><a href="#"download="picture.png"id="downloadImage_a"><img src='img/plugins-img/download.png'width='20px;'height='20px;'class="img"class='border_nochoose'title='下载'onclick="downloadImage();"/></a>&nbsp;&nbsp;&nbsp;<input id="chooseColor"type="button"class='i1 border_nochoose'onclick="showColor(this)"title='选择颜色'/>&nbsp;<!--<div style="clear: both;"></div>--><br/><br/><button style="background-color: #f05183;"id="exitbianji">退出编辑模式</button><span style="color:#F05183">注意：编辑模式下屏幕将不能滚动</span></div></div><div id="color"class="color">&nbsp;&nbsp;&nbsp;&nbsp;<input class="i1"type="button"/><input class="i2"type="button"/><input class="i3"type="button"/><input class="i4"type="button"/><input class="i5"type="button"/><input class="i6"type="button"/><input class="i7"type="button"/><input class="i8"type="button"/><input class="i9"type="button"/><input class="i10"type="button"/><input class="i11"type="button"/><input class="i12"type="button"/><input class="i13"type="button"/><input class="i14"type="button"/></div><div id="nav"><span id="hide">隐藏目录</span><span id="bianji">进入编辑模式</span><span id="bianji1">编辑模式</span><div class="dtree"><p><a href="javascript: d.openAll();">展开全部</a>|<a href="javascript: d.closeAll();">关闭全部</a></p><script type="text/javascript">makeNav();</script></div></div><div id="contents"><div id="content"><div id="page"><div id="contentss"><label for=""id="qqwe"></label><br/><script>index.init(@data@);index.genHtml();console.log(index.html);document.write(index.html)</script><span id="show">显示目录</span><a href="#content"><span id="top">返回顶部</span></a><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p></div><script>function playVideo(id){var audio=$("#"+id)[0];audio.load();audio.play()}function stopVideo(id){var audio=$("#"+id)[0];audio.pause()}</script>}
	f1=File.new(htmlname, "w")
	f1.puts str.gsub!(/@data@/,data.to_json)
	f1.close
end




