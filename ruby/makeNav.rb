# -*- force_encoding:utf-8 -*-
# -*- coding:utf-8 -*-
#创建导航
require 'json'

#index	自己的序号
#id     父级的序号
#title
#link

myjs=%Q{function makeNav(){d=new dTree('d');var ddd=@nav@;for(var i=0;i<ddd.length;i++){d.add(ddd[i].index,ddd[i].id,ddd[i].title,ddd[i].link)};document.write(d)}}

data=[]
current_ke_url=''
current_zu_url=''
index=0;
zuid=-1
keid=-1
jieid=-1
title=''
url=''

	f=File.open('nav.txt',"r:utf-8")
	f.each_line do |line|
		line.strip!
		if line.match(/^#[^#]*?[\s]/)
			txtArr=line.gsub!(/#/,"").split(/[ 　\s]{1,2}/)
			title=txtArr[0]
			url=txtArr[1]
			data.push({'index'=>index,'id'=>zuid,'title'=>title,'link'=>url})
			keid=index
			index+=1
		elsif line.match(/^##[^#]*?[\s]/)
			txtArr=line.gsub!(/#/,"").split(/[ 　\s]{1,2}/)
			title=txtArr[0]
			url=txtArr[1]
			data.push({'index'=>index,'id'=>keid,'title'=>title,'link'=>url})
			jieid=index
			index+=1
		elsif line.match(/^###[^#]*?[\s]/)
			txtArr=line.gsub!(/#/,"").split(/[ 　\s]{1,2}/)
			title=txtArr[0]
			curl=txtArr[1]
			data.push({'index'=>index,'id'=>jieid,'title'=>title,'link'=>url+"#"+curl})
			index+=1
		end
	end

	f1=File.new('output/js/nav.js', "w")
	f1.puts myjs.gsub!(/@nav@/,data.to_json)
	f1.close







