# -*- force_encoding:utf-8 -*-
# -*- coding:utf-8 -*-


data=''

if(ARGV.length!=1)
	puts "USAGE:==============\n\tStart:ruby xxx.rb 第一课.txt"
else
	filename=ARGV[0]


	f=File.open(filename,"r:utf-8")
	f.each_line do |line|
		line.strip!
		if(line.match(/@[\S]*?@/))
			data<<'##'+line.gsub!("@",'')+"\n"
		elsif line.match(/^#[^#]*?[\s]/)
			arr=line.sub!('#','').split(/[ 　\s]{1,2}/)
			data<<'###'+arr[0]+' '+arr[2]+"\n"
		end
	end


	f1=File.new('nav.txt', "a")
	f1.puts data
	f1.puts "\n"
	f1.close
end




