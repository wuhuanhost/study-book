# -*- force_encoding:utf-8 -*-
# -*- coding:utf-8 -*-

#本脚本用户生成课文分组页面的数据
require 'json'

mp3path='mp3/'
imgpath='img/'
filename=''
lineFlag='<br/>'		#换行标记
data={}

if(ARGV.length!=1)
	puts "USAGE:==============\n\tStart:ruby xxx.rb 第一组.txt"
else
	filename=ARGV[0]

	
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


	f1=File.new(filename.split('.')[0]+'_ok.txt', "w")
	f1.puts data.to_json
	f1.close
end




