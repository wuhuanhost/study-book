# encoding: utf-8

require 'json'

@mp3path='mp3/'
@imgpath='img/'
@swfpath='swf/'
filename=''
outname=''
@lineFlag='<br/>'		#换行标记

data={}



#处理图解新词
def tujiexinci (f)
	data={}
	first=f.readline.strip!.gsub!("#","").split(/[ 　\s]{1,2}/)
	data["title"]=first[0]
	data["titleImg"]=@imgpath+first[1]
	data["id"]=first[2]
	arrImg=[]
	f.each_line do |line|
		line.strip!
		if(line=="#end")
			break
		elsif(line!="")
			lineArr=line.split(" ")
			arrImg.push({'title'=>lineArr[0],'img'=>@imgpath+lineArr[1]})
		end
	end
	data["arrImg"]=arrImg
	data
end

#课题解析
def ketijiexi(f)
	data={}
	first=f.readline.strip!.gsub!("#","").split(/[ 　\s]{1,2}/)
	data["title"]=first[0]
	data["titleImg"]=@imgpath+first[1]
	data["id"]=first[2]
	contents=[]
	f.each_line do |line|
		line.strip!
		if(line=="#end")
			break
		elsif(line!="")
			contents.push({'content'=>line})
		end
	end
	data["contents"]=contents
	data
end

#学习目标
def xueximubiao(f)
	data={}
	first=f.readline.strip!.gsub!("#","").split(/[ 　\s]{1,2}/)
	data["title"]=first[0]
	data["titleImg"]=@imgpath+first[1]
	data["id"]=first[2]
	content=''
	f.each_line do |line|
		line.strip!
		line.gsub!(/\t/," ")	#替换制表符
		if(line=="#end")
			break
		elsif(line!="")
			if(content!='')
				content+=@lineFlag
			end
			content+=line
		end
	end
	data["content"]=content
	data
end

#作者简介
def zuozhejianjie(f)
	data={}
	first=f.readline.strip!.gsub!("#","").split(/[ 　\s]{1,2}/)
	data["title"]=first[0]
	data["titleImg"]=@imgpath+first[1]
	data["id"]=first[2]
	authimgArr=[]
	authinfoArr=[]
	f.each_line do |line|
		line.strip!
		if(line=="#end")
			break
		elsif(line!="")
			if authinfoArr.length>authimgArr.length
				raise '作者简介板块缺少图片'.encode!('GBK')
			elsif line.match(/.jpg$/)
				authimgArr.push(line)
			elsif authimgArr.length>0&&authimgArr.length==authinfoArr.length
				authinfoArr[authinfoArr.length-1]<<@lineFlag+line
			else
				authinfoArr.push(line)
			end
		end
	end
	if(authinfoArr.length!=authimgArr.length)
		raise '作者简介板块的图片和文字数量不符！！'.encode!("GBK")
	end
	contents=[];
	i=0
	while i<authimgArr.length
		contents.push({'content'=>authinfoArr[i],'autherImg'=>@imgpath+authimgArr[i]})
		i+=1
	end
	data["contents"]=contents
	data
end

#生字全析
def shengziquanxi(f)
	data={}
	first=f.readline.strip!.gsub!("#","").split(/[ 　\s]{1,2}/)
	data["title"]=first[0]
	data["titleImg"]=@imgpath+first[1]
	data["id"]=first[2]

	one=nil
	two=nil
	while true
		line=f.readline
		if(line.strip.match(/^#end/))
			break
		end

		if(line.match("##课标要求会写的字"))
			oneTitleArr=line.strip!.gsub!("#","").split(/[ 　\s]{1,2}/)
			one={'title'=>oneTitleArr[0],'titleImg'=>@imgpath+oneTitleArr[1]}
			contents=[]
			line=f.readline
			while !line.strip.match(/^##end/) do
				line.strip!
				if(line=="")		#过滤掉空行
					line=f.readline
					next
				end
				lineArr=line.split(/[ 　\s]{1,2}/)
				contents.push({'imgSrc'=>@imgpath+lineArr[0],'flashSrc'=>@swfpath+lineArr[1]})
				line=f.readline
			end
			one['contents']=contents
		end


		if(line.match("##我会认的字"))
			twoTitleArr=line.strip!.gsub!('##',"").split(/[ 　\s]{1,2}/)
			two={'title'=>twoTitleArr[0],'titleImg'=>@imgpath+twoTitleArr[1]}
			contents=[]
			line=f.readline
			while !line.strip.match(/^##end/) do
				line.strip!
				if(line=="")		#过滤掉空行
					line=f.readline
					next
				end
				lineArr=line.split(/[ 　\s]{1,2}/)
				contents.push({'imgSrc'=>@imgpath+lineArr[0],'flashSrc'=>@swfpath+lineArr[1]})
				line=f.readline
			end
			two['contents']=contents
		end
	end

	if(one)
		data['one']=one
	end
	if(two)
		data['two']=two
	end
	data
end

#易错防火墙
def yicuofanghuoqiang(f)
	data={}
	first=f.readline.strip!.gsub!("#","").split(/[ 　\s]{1,2}/)
	data["title"]=first[0]
	data["titleImg"]=@imgpath+first[1]
	data["id"]=first[2]
	data["img"]=@imgpath+f.readline.strip!
	data
end

#词语集锦
def ciyujijin(f)
	data={}
	first=f.readline.strip!.gsub!("#","").split(/[ 　\s]{1,2}/)
	data["title"]=first[0]
	data["titleImg"]=@imgpath+first[1]
	data["id"]=first[2]

	xincijieshi=nil	#新词解释
	jinyici=nil	#近义词
	fanyici=nil	#反义词
	duoyinzizuci=nil	#多音字组词
	jinyicibianxi=nil	#近义词辨析
	tingxieleyuan=nil	#听写乐园
	meiduzhidao=nil	#美读指导
	kewendaoxue=nil	#课文导学
	while true
		line=f.readline
		if(line.strip.match(/^#end/))
			break
		end

		if(line.match("##新词解释"))
			titleArr=line.strip!.gsub!("##","").split(/[ 　\s]{1,2}/)
			xincijieshi={'title'=>titleArr[0],'titleImg'=>@imgpath+titleArr[1]}
			contents=[]
			line=f.readline
			while !line.strip.match(/^##end/) do
				line.strip!
				if(line=="")		#过滤掉空行
					line=f.readline
					next
				end
				line.sub!(/[:：]/,"@@")
				lineArr=line.split('@@')
				contents.push({'question'=>lineArr[0],'answer'=>lineArr[1]})
				line=f.readline
			end
			xincijieshi['contents']=contents
		end

		if(line.match("##近义词 "))
			titleArr=line.strip!.gsub!("##","").split(/[ 　\s]{1,2}/)
			jinyici={'title'=>titleArr[0],'titleImg'=>@imgpath+titleArr[1]}
			contents=[]
			line=f.readline
			while !line.strip.match(/^##end/) do
				line.strip!
				if(line=="")		#过滤掉空行
					line=f.readline
					next
				end
				line.sub!(/[-—]{1,2}/,"@@")
				lineArr=line.split('@@')
				contents.push({'question'=>lineArr[0],'answer'=>lineArr[1]})
				line=f.readline
			end
			jinyici['contents']=contents
		end

		if(line.match("##反义词 "))
			titleArr=line.strip!.gsub!("##","").split(/[ 　\s]{1,2}/)
			fanyici={'title'=>titleArr[0],'titleImg'=>@imgpath+titleArr[1]}
			contents=[]
			line=f.readline
			while !line.strip.match(/^##end/) do
				line.strip!
				if(line=="")		#过滤掉空行
					line=f.readline
					next
				end
				line.sub!(/[-—]{1,2}/,"@@")
				lineArr=line.split('@@')
				contents.push({'question'=>lineArr[0],'answer'=>lineArr[1]})
				line=f.readline
			end
			fanyici['contents']=contents
		end

		if(line.match("##多音字组词 "))
			titleArr=line.strip!.gsub!("##","").split(/[ 　\s]{1,2}/)
			duoyinzizuci={'title'=>titleArr[0],'titleImg'=>@imgpath+titleArr[1]}
			line=f.readline
			line.strip!
			duoyinzizuci['img']=@imgpath+line
		end

		if(line.match("##近义词辨析"))
			titleArr=line.strip!.gsub!("##","").split(' ')
			jinyicibianxi={'title'=>titleArr[0],'titleImg'=>@imgpath+titleArr[1]}
			contents=[]
			content={}
			line=f.readline
			while !line.strip.match(/^##end/) do
				line.strip!
				if(line=="")		#过滤掉空行
					line=f.readline
					next
				end
				#拆分词语
				if(line.match(/[ 　\s]{1,2}/))
					line.sub!(/[ 　\s]{1,2}/,"@@")
					lineArr=line.split("@@")
					content["company1"]=lineArr[0]
					content["company2"]=lineArr[1]
				elsif line.match(/相同[:：]/)	#相同
					line.sub!(/[:：]/,"@@")
					lineArr=line.split('@@')
					content["xiangtong"]=lineArr[1]
				elsif line.match(/不同[:：]/)	#不同
					line.sub!(/[:：]/,"@@")
					lineArr=line.split('@@')
					content["butong"]=lineArr[1]
				elsif line.match(/造句[:：]/)	#造句
					line.sub!(/[:：]/,"@@")
					lineArr=line.split('@@')
					#====================================
					#以下暂时作废
					# str=lineArr[1].gsub!(/【/,'【<span class="hide">')
					# str=str.gsub!(/】/,'</span>】')
					# content["zhaoju"]=str
					#====================================
					content["zaoju"]=lineArr[1]
				else	#造句下面的内容
					#====================================
					#以下暂时作废，改由渲染器处理
					# str=line.gsub!(/【/,'【<span class="hide">')
					# str=str.gsub!(/】/,'</span>】')
					# content["zhaoju"] << "<br/>"+str
					content["zaoju"] << "<br/>"+line
				end
				line=f.readline
			end
			contents.push(content)
			jinyicibianxi['contents']=contents
		end

		if(line.match("##听写乐园 "))
			titleArr=line.strip!.gsub!("##","").split(/[ 　\s]{1,2}/)
			tingxieleyuan={'title'=>titleArr[0],'titleImg'=>@imgpath+titleArr[1],'mp3'=>@mp3path+titleArr[2]}
			line=f.readline.strip!
			tingxieleyuan['img']=@imgpath+line
		end

		if(line.match("##美读指导"))
			titleArr=line.strip!.gsub!("##","").split(/[ 　\s]{1,2}/)
			meiduzhidao={'title'=>titleArr[0],'titleImg'=>@imgpath+titleArr[1],'mp3'=>@mp3path+titleArr[2]}
			contents=[]
			line=f.readline
			while !line.strip.match(/^##end/) do
				line.strip!
				if(line=="")		#过滤掉空行
					line=f.readline
					next
				end
				contents.push({'content'=>line})
				line=f.readline
			end
			meiduzhidao['contents']=contents
		end

		if(line.match("##课文导学"))
			titleArr=line.strip!.gsub!("##","").split(/[ 　\s]{1,2}/)
			kewendaoxue={'title'=>titleArr[0],'titleImg'=>@imgpath+titleArr[1]}
			contents=[]
			line=f.readline
			while !line.strip.match(/^##end/) do
				line.strip!
				if(line=="")		#过滤掉空行
					line=f.readline
					next
				end
				contents.push({'content'=>line})
				line=f.readline
			end
			kewendaoxue['contents']=contents
		end
	end

	if(xincijieshi)
		data['xincijieshi']=xincijieshi
	end
	if(jinyici)
		data['jinyici']=jinyici
	end
	if(fanyici)
		data['fanyici']=fanyici
	end
	if(duoyinzizuci)
		data['duoyinzizuci']=duoyinzizuci
	end
	if(jinyicibianxi)
		data['jinyicibianxi']=jinyicibianxi
	end

	if(tingxieleyuan)
		data['tingxieleyuan']=tingxieleyuan
	end

	if(meiduzhidao)
		data['meiduzhidao']=meiduzhidao
	end

	if(kewendaoxue)
		data['kewendaoxue']=kewendaoxue
	end
	
	data
end

#课文全析
def kewenquanxi(f)
	data={}
	first=f.readline.strip!.gsub!("#","").split(/[ 　\s]{1,2}/)
	data["title"]=first[0]
	data["titleImg"]=@imgpath+first[1]
	data["id"]=first[2]
	kewenArr=[]
	kewen=''
	duanxi=''
	beizhu=''
	dianping=''
	kewenclose=false	#标记课文部分是否闭合
	while true
		line=f.readline
		line.strip!
		if(line.match(/^#end/))
			arr={}
			if kewen!=''
				#已经作废改为渲染器处理
				#kewen.gsub!(/【/,'<span class="describe-style">【')
				#kewen.gsub!(/】/,'】</span>')
				arr['kewen']=kewen
			end
			arr['duanxi']=duanxi if duanxi!=''
			arr['beizhu']=beizhu if beizhu!=''
			arr['dianping']=dianping if dianping!=''
			kewenArr.push(arr)
			kewen=''
			duanxi=''
			beizhu=''
			dianping=''
			break
		elsif line==""
			next
		elsif (line.match(/^段析[:：]/))
			kewenclose=true
			line.sub!(/^段析[:：]/,"")
			duanxi=line
		elsif (line.match(/^备注[:：]/))
			line.sub!(/^备注[:：]/,"")
			beizhu=line
		elsif (line.match(/^点评[:：]/))
			line.sub!(/^点评[:：]/,"")
			dianping=line
		elsif kewenclose	#课文块已经封闭
			arr={}
			if kewen!=''
				#以下已经作废改由渲染器处理
				# kewen.gsub!(/【/,'<span class="describe-style">【')
				# kewen.gsub!(/】/,'】</span>')
				arr['kewen']=kewen
			end
			arr['duanluojiexi']=duanxi if duanxi!=''
			arr['remark']=beizhu if beizhu!=''
			arr['suitangdianping']=dianping if dianping!=''
			kewenArr.push(arr)
			kewen=''
			duanxi=''
			beizhu=''
			dianping=''
			kewenclose=false
			kewen<<line
		else

			kewen<<"<br/>"+line
		end
	end
	data['kewenArr']=kewenArr
	data
end

#课文结构
def kewenjiegou(f)
	data={}
	first=f.readline.strip!.gsub!("#","").split(/[ 　\s]{1,2}/)
	data["title"]=first[0]
	data["titleImg"]=@imgpath+first[1]
	data["id"]=first[2]


	jiegoutushi=nil	#结构图示
	zhutilingwu=nil	#主题领悟
	xiezuotedian=nil	#写作特点
	while true
		line=f.readline
		if(line.strip.match(/^#end/))
			break
		end

		if(line.match("##结构图示"))
			titleArr=line.strip!.gsub!("##","").split(/[ 　\s]{1,2}/)
			jiegoutushi={'title'=>titleArr[0],'titleImg'=>@imgpath+titleArr[1]}
			line=f.readline
			while !line.strip.match(/^##end/) do
				line.strip!
				if(line=="")		#过滤掉空行
					line=f.readline
					next
				end
				jiegoutushi['img']=@imgpath+line
				line=f.readline
			end
		end

		if(line.match("##主题领悟"))
			titleArr=line.strip!.gsub!("##","").split(/[ 　\s]{1,2}/)
			zhutilingwu={'title'=>titleArr[0],'titleImg'=>@imgpath+titleArr[1]}
			contents=[]
			line=f.readline
			while !line.strip.match(/^##end/) do
				line.strip!
				if(line=="")		#过滤掉空行
					line=f.readline
					next
				end
				contents.push(line)
				line=f.readline
			end
			zhutilingwu['contents']=contents
		end

		if(line.match("##写作特点"))
			titleArr=line.strip!.gsub!("##","").split(/[ 　\s]{1,2}/)
			xiezuotedian={'title'=>titleArr[0],'titleImg'=>@imgpath+titleArr[1]}
			contents=[]
			line=f.readline
			while !line.strip.match(/^##end/) do
				line.strip!
				if(line=="")		#过滤掉空行
					line=f.readline
					next
				end
				contents.push(line)
				line=f.readline
			end
			xiezuotedian['contents']=contents
		end
	end
	data['jiegoutushi']=jiegoutushi if(jiegoutushi)
	data['zhutilingwu']=zhutilingwu if(zhutilingwu)
	data['xiezuotedian']=xiezuotedian if(xiezuotedian)
	data
end

#互动提问
def hudongtiwen(f)
	data={}
	first=f.readline.strip!.gsub!("#","").split(/[ 　\s]{1,2}/)
	data["title"]=first[0]
	data["titleImg"]=@imgpath+first[1]
	data["id"]=first[2]
	contents=[]
	question=nil
	answer=nil
	questionOpen=false	#写入问题
	answerOpen=false	#写入答案
	while true
		line=f.readline
		line.strip!

		if(line.strip.match(/^#end/))
			if(question&&answer)
				contents.push({'question'=>question,'answer'=>answer})
			else
				raise '互动提问板块有不匹配的问答！！'.encode!("GBK")
			end
				
			break
		elsif (line=='')
			next
		elsif (line.match(/^问[:：]/))
			#之前已经有组合好的问答配对
			if(question&&answer)
				contents.push({'question'=>question,'answer'=>answer})
				question=nil
				answer=nil
				questionOpen=true
				answerOpen=false
				question=line.sub(/^问[:：]/,'')
			#问、答都是空的
			elsif question==nil&&answer==nil
				questionOpen=true
				answerOpen=false
				question=line.sub(/^问[:：]/,'')
			#缺少答案的情况下继续出问题
			else
				raise '互动提问板块缺少答案！！'.encode!("GBK")
			end
		elsif(line.match(/^答[:：]/))
			#缺少提问
			if(question==nil)
				raise '互动提问板块缺少提问！！'.encode!("GBK")
			#之前已经有答案存在
			elsif answer!=nil
				raise '互动提问板块缺少提问！！'.encode!("GBK")
			else
				questionOpen=false
				answerOpen=true
				answer=line.sub(/^答[:：]/,'')
			end
		else #可能是问题也可能是答案
			if(questionOpen)
				question<<"<br/>"+line
			elsif(answerOpen)
				answer<<'<br/>'+line
			end
		end
	end
	data['contents']=contents
	data
end

#习题指导
def xitizhidao(f)
	data={}
	first=f.readline.strip!.gsub!("#","").split(/[ 　\s]{1,2}/)
	data["title"]=first[0]
	data["titleImg"]=@imgpath+first[1]
	data["id"]=first[2]
	contents=[]
	question=nil
	answer=nil
	questionOpen=false	#写入问题
	answerOpen=false	#写入答案
	while true
		line=f.readline
		line.strip!

		if(line.strip.match(/^#end/))
			if(question&&answer)
				contents.push({'question'=>question,'answer'=>answer})
			else
				raise '互动提问板块有不匹配的问答！！'.encode!("GBK")
			end
				
			break
		elsif (line=='')
			next
		elsif (line.match(/^问[:：]/))
			#之前已经有组合好的问答配对
			if(question&&answer)
				contents.push({'question'=>question,'answer'=>answer})
				question=nil
				answer=nil
				questionOpen=true
				answerOpen=false
				question=line.sub(/^问[:：]/,'')
			#问、答都是空的
			elsif question==nil&&answer==nil
				questionOpen=true
				answerOpen=false
				question=line.sub(/^问[:：]/,'')
			#缺少答案的情况下继续出问题
			else
				raise '互动提问板块缺少答案！！'.encode!("GBK")
			end
		elsif(line.match(/^答[:：]/))
			#缺少提问
			if(question==nil)
				raise '互动提问板块缺少提问！！'.encode!("GBK")
			#之前已经有答案存在
			elsif answer!=nil
				raise '互动提问板块缺少提问！！'.encode!("GBK")
			else
				questionOpen=false
				answerOpen=true
				answer=line.sub(/^答[:：]/,'')
			end
		else #可能是问题也可能是答案
			if(questionOpen)
				question<<"<br/>"+line
			elsif(answerOpen)
				answer<<'<br/>'+line
			end
		end
	end
	data['contents']=contents
	data
end

myhtml=%Q{<!DOCTYPE html><html lang="zh_CN"><head><meta charset="UTF-8"><title>demo</title><link href="image/favicon.ico"rel="shortcut icon"type="image/vnd.microsoft.icon"/><link rel="stylesheet"type="text/css"href="css/Normalize.css"/><link rel="stylesheet"type="text/css"href="css/picture-style.css"/><link rel="stylesheet"type="text/css"href="css/dtree.css"/><link rel="stylesheet"type="text/css"href="css/style.css"/><link rel="stylesheet"type="text/css"href="css/kewen.css"/><script type="text/javascript"src="js/jquery-1.11.2.min.js"></script><script type="text/javascript"src="js/dtree.js"></script><script type="text/javascript"src="js/picture.js"></script><script type="text/javascript"src="js/zuozhe.js"></script><script type="text/javascript"src="js/shengziquanxi.js"></script><script type="text/javascript"src="js/xincijieshi.js"></script><script type="text/javascript"src="js/ciyu.js"></script><script type="text/javascript"src="js/fanyici.js"></script><script type="text/javascript"src="js/ciyujijing.js"></script><script type="text/javascript"src="js/jingyicibianxi.js"></script><script type="text/javascript"src="js/tingxieleyuan.js"></script><script type="text/javascript"src="js/meiduzhidao.js"></script><script type="text/javascript"src="js/kewendaoxue.js"></script><script type="text/javascript"src="js/duoyingzi.js"></script><script type="text/javascript"src="js/kewen-new.js"></script><script type="text/javascript"src="js/kewenjiegou.js"></script><script type="text/javascript"src="js/hudongtiwen.js"></script><script type="text/javascript"src="js/xitizhidao.js"></script><script type="text/javascript"src="js/xueximubiao.js"></script><script type="text/javascript"src="js/ketijiexi.js"></script><script type="text/javascript"src="js/nav.js"></script></script><style type="text/css">.chinese{text-indent:2em;line-height:30px;font-family:"楷体";font-size:16px;margin-top:30px;width:700px}.chinese-bottom{text-indent:2em;line-height:0px;font-family:"楷体";font-size:16px;margin-top:30px;width:700px}.chinese-bottom1{text-indent:2em;line-height:20px;font-family:"楷体";font-size:16px;margin-top:30px;width:700px}.chinese-1{text-indent:2em;line-height:10px;font-size:14px}.chinese-1 label{color:red}#showDivss{position:fixed;display:none;width:800px;height:600px;top:50%;left:50%;margin-left:-306px;margin-top:-300px;background-color:#FFFFFF;border:6px solid#045a36;z-index:10000000000000000000}#showDivBtn{position:fixed;width:100px;height:36px;top:50%;left:50%;margin-left:400px;margin-top:-340px;background-color:#f05183;z-index:100000000000000000000000;text-align:center;font-size:20px;color:#FFFFFF;font-weight:bold;line-height:36px;display:none;cursor:pointer}#showDiv{position:fixed;width:100%;height:100%;bottom:0px;display:none;filter:alpha(opacity=100);-moz-opacity:0.75;opacity:0.55;background-color:black;z-index:99999999;cursor:pointer}.word{float:left;width:360px;min-height:100px;background-color:red}.word span{text-align:center;display:block;line-height:36px}*{outline:none}.jingyicibianxi{display:none}</style><script type="text/javascript">$(document).ready(function(){$(document).ready(function(){$("#hide").click(function(){$("#nav").css("margin-left","-30%");$("#contents").css("width","100%");$("#contents").css("margin-left","-30%");$("#show").show();$("#hide").hide();$("#content").css("width","70%");$("#content").css("margin-left","-35%");$("html").css("background-color","#EEEEEE")});$("#show").click(function(){$("#nav").css("margin-left","0px");$("#contents").css("width","70%");$("#contents").css("margin-left","0px");$("#show").hide();$("#hide").show();$("#content").css("width","100%");$("#content").css("margin-left","-50%")})});$("#showDiv").click(function(){$("#showDiv").hide();$("#showDivss").hide();$("#showDivBtn").hide()});$("#showDivBtn").click(function(){$("#showDiv").hide();$("#showDivss").hide();$("#showDivBtn").hide()});var color="";$("button[class!='noHover']").hover(function(){color=$(this).css("background-color");$(this).css("background-color","#efc851")},function(){$(this).css("background-color",color)})});function showBtn(id){$("object").attr("data",id);$("#showDiv").show();$("#showDivss").show();$("#showDivBtn").show()}</script></head><body><div id="showDivBtn">关闭窗口</div><div id="showDiv"></div><div id="showDivss"><object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"width="800"height="600"id="allgames"align="middle"><param name="movie"value="swf/font-1.swf"/><param name="quality"value="high"/><param name="bgcolor"value="#ffffff"/><param name="play"value="true"/><param name="loop"value="true"/><param name="wmode"value="window"/><param name="scale"value="showall"/><param name="menu"value="true"/><param name="devicefont"value="false"/><param name="salign"value=""/><param name="allowScriptAccess"value="sameDomain"/><!--[if!IE]>--><object type="application/x-shockwave-flash"data="swf/font-1.swf"width="800"height="600"><param name="movie"value="swf/font-1.swf"/><param name="quality"value="high"/><param name="bgcolor"value="#ffffff"/><param name="play"value="true"/><param name="loop"value="true"/><param name="wmode"value="window"/><param name="scale"value="showall"/><param name="menu"value="true"/><param name="devicefont"value="false"/><param name="salign"value=""/><param name="allowScriptAccess"value="sameDomain"/><!--<![endif]--><a href="https://www.adobe.com/go/getflash"><img src="https://www.adobe.com/images/shared/download_buttons/get_flash_player.gif"alt="获得 Adobe Flash Player"/></a><!--[if!IE]>--></object><!--<![endif]--></object></div><div id="nav"><span id="hide">隐藏目录</span><div class="dtree"><p><a href="javascript: d.openAll();">展开全部</a>|<a href="javascript: d.closeAll();">关闭全部</a></p><script type="text/javascript">makeNav();</script></div></div><div id="contents"><div id="content"><div id="title"><span class="unit">第一课窃读记</span></div><div id="page"><div id="contentss"><!--作者：mr.ziqiang@qq.com时间：2015-05-18描述：<h2>第1课窃读记</h2>--><br/></div><span id="show">显示目录</span><a href="#content"><span id="top">返回顶部</span></a><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p></div><script type="text/javascript"src="js/gen.js"></script><script>gen.init(@data@);gen.allHtml();$("#contentss").append(gen.html);</script></html>}



if(ARGV.length!=2)
	puts "USAGE:==============\n\tStart:ruby xxx.rb 第一课.txt lesson_01.html"
else
	outname='output/'+ARGV[1]
	filename=ARGV[0]


	f=File.open(filename,"r:utf-8")
	f.each_line do |line|
		if line.match(/@([\S]*?)@/)!=nil
			data["title"]= line.match(/@([\S]*?)@/)[1]
		elsif line.match("#图解新词")
			f.pos=f.pos-line.bytesize-1		#重新定位读取指针
			data["tujiexinci"]=tujiexinci(f)
		elsif line.match("#课题解析")
			f.pos=f.pos-line.bytesize-1		#重新定位读取指针
			data["ketijiexi"]=ketijiexi(f)
		elsif line.match("#学习目标")
			f.pos=f.pos-line.bytesize-1		#重新定位读取指针
			data["xueximubiao"]=xueximubiao(f)
		elsif line.match("#作者简介")
			f.pos=f.pos-line.bytesize-1		#重新定位读取指针
			data["zuozhejianjie"]=zuozhejianjie(f)
		elsif line.match("#生字全析")
			f.pos=f.pos-line.bytesize-1		#重新定位读取指针
			data["shengziquanxi"]=shengziquanxi(f)
		elsif line.match("#易错防火墙")
			f.pos=f.pos-line.bytesize-1		#重新定位读取指针
			data["yicuofanghuoqiang"]=yicuofanghuoqiang(f)
		elsif line.match("#词语集锦")
			f.pos=f.pos-line.bytesize-1		#重新定位读取指针
			data["ciyujijin"]=ciyujijin(f)
		elsif line.match("#课文全析")
			f.pos=f.pos-line.bytesize-1		#重新定位读取指针
			data["kewenquanxi"]=kewenquanxi(f)
		elsif line.match("#课文结构")
			f.pos=f.pos-line.bytesize-1		#重新定位读取指针
			data["kewenjiegou"]=kewenjiegou(f)
		elsif line.match("#互动提问")
			f.pos=f.pos-line.bytesize-1		#重新定位读取指针
			data["hudongtiwen"]=hudongtiwen(f)
		elsif line.match("#习题指导")
			f.pos=f.pos-line.bytesize-1		#重新定位读取指针
			data["xitizhidao"]=xitizhidao(f)
		end
	end

	# puts data.to_json

	f1=File.new(outname, "w")
	f1.puts myhtml.gsub!(/@data@/,data.to_json);
	f1.close
end


