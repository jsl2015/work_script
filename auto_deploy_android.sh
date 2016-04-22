#! /bin/bash
#usage: sh android_auto_deploy.sh tool_id  服务器名 IP

dir1=/var/www/html
dir2=/usr/local/src/lilith_op
dir3=/usr/local/back
old_ip=`awk -F"\"" '/=>/ {print $2}' $dir1/djsy/host.php | tail -1`
old_name=`awk -F"\"" '/=>/ {print $4}' $dir1/djsy/host.php | tail -1`
old_tool_id=$(($1-1))

#备份
a=(list host new settings server_cfg)
for i in $dir1/1/gameweb $dir1/djsy $dir1/daojian/app/config $dir2/dotalegend $dir2/conf;do
        cd $i
          if [ "$i" = "$dir1/1/gameweb" ];then
            tar -czvf $dir3/${a[0]}_`date +%m-%d`.tar.gz *
          elif [ "$i" = "$dir1/djsy" ];then
            tar -czvf $dir3/${a[1]}_`date +%m-%d`.tar.gz *
          elif [ "$i" = "$dir1/daojian/app/config" ];then
            tar -czvf $dir3/${a[2]}_`date +%m-%d`.tar.gz *
          elif [ "$i" = "$dir2/dotalegend" ];then
            tar -czvf $dir3/${a[3]}_`date +%m-%d`.tar.gz *
          elif [ "$i" = "$dir2/conf" ];then
            tar -czvf $dir3/${a[4]}_`date +%m-%d`.tar.gz *
          fi
done

#加入列表
sed -i ' s/  {id = "8".*/  {id = "8", name = "'$2'", ip = "'$3'", port=10000,state="推荐", color=0xFF5014},/g' $dir1/1/gameweb/serverlist.txt
sed -i '/'$old_ip'/h; //G' $dir1/djsy/host.php
sed -i '/'$old_ip'/{x;s/^/./;/^.\{2\}$/{x;s/'$old_ip'/'$3'/;b};x}' $dir1/djsy/host.php
sed -i '/'$old_name'/{x;s/^/./;/^.\{2\}$/{x;s/'$old_name'/'$2'/;b};x}' $dir1/djsy/host.php
#新工具后台配置
sed -i '/"oss00'$old_tool_id'"=>"'$old_name'",/h; {//G}' $dir1/daojian/app/config/serverslist.php
sed -i '/oss00'$old_tool_id'/{x;s/^/./;/^.\{2\}$/{x;s/oss00'$old_tool_id'/oss00'$1'/;b};x}' $dir1/daojian/app/config/serverslist.php
sed -i '/'$old_name'/{x;s/^/./;/^.\{2\}$/{x;s/'$old_name'/'$2'/;b};x}' $dir1/daojian/app/config/serverslist.php
sed -i '/'oss00"$old_tool_id"'.*/,/oss1001/H; {//g}' $dir1/daojian/app/config/database.php
sed -i '/oss00'$old_tool_id'/{x;s/^/./;/^.\{2\}$/{x;s/oss00'$old_tool_id'/oss00'$1'/;b};x}' $dir1/daojian/app/config/database.php
sed -i '/'$old_ip'/{x;s/^/./;/^.\{2\}$/{x;s/'$old_ip'/'$3'/;b};x}' $dir1/daojian/app/config/database.php

#旧工具后台配置
#################################config settings.py
sed -i "/'oss00"$old_tool_id"': {/,/'oss1001'/H; {//g}" $dir2/dotalegend/settings.py
sed -i "/'oss00"$old_tool_id"': {/{x;s/^/./;/^.\{2\}$/{x;s/oss00"$old_tool_id"/oss00"$1"/;b};x}" $dir2/dotalegend/settings.py
sed -i '/'$old_ip'/{x;s/^/./;/^.\{2\}$/{x;s/'$old_ip'/'$3'/;b};x}' $dir2/dotalegend/settings.py

sed -i "/'oss00"$old_tool_id"_gdb': {/,/'oss1001_gdb': {/H; {//g}" $dir2/dotalegend/settings.py
sed -i "/'oss00"$old_tool_id"_gdb': {/{x;s/^/./;/^.\{2\}$/{x;s/oss00"$old_tool_id"/oss00"$1"/;b};x}" $dir2/dotalegend/settings.py
sed -i '/'$old_ip'/{x;s/^/./;/^.\{3\}$/{x;s/'$old_ip'/'$3'/;b};x}' $dir2/dotalegend/settings.py

sed -i "/'oss00"$old_tool_id"':u'"$old_name"',/h; //G" $dir2/dotalegend/settings.py
sed -i "/'oss00"$old_tool_id"':u'"$old_name"',/{x;s/^/./;/^.\{2\}$/{x;s/oss00"$old_tool_id"/oss00"$1"/;b};x}" $dir2/dotalegend/settings.py
sed -i "/'oss00"$1"'/s/"$old_name"/"$2"/" $dir2/dotalegend/settings.py

sed -i "/'oss00"$old_tool_id"':{/h; //G" $dir2/dotalegend/settings.py
sed -i "/'oss00"$old_tool_id"':{/{x;s/^/./;/^.\{2\}$/{x;s/oss00"$old_tool_id"/oss00"$1"/;b};x}" $dir2/dotalegend/settings.py
sed -i "/'oss00"$1"'/s/"$old_ip"/"$3"/" $dir2/dotalegend/settings.py
##################################config server_cfg.py
sed -i "/'oss00"$old_tool_id"':u'"$old_name"',/h; //G" $dir2/conf/server_cfg.py
sed -i "/'oss00"$old_tool_id"':u'"$old_name"',/{x;s/^/./;/^.\{2\}$/{x;s/oss00"$old_tool_id"/oss00"$1"/;b};x}" $dir2/conf/server_cfg.py
sed -i "/'oss00"$1"'/s/"$old_name"/"$2"/" $dir2/conf/server_cfg.py

sed -i "/'oss00"$old_tool_id"':{/h; //G" $dir2/conf/server_cfg.py
sed -i "/'oss00"$old_tool_id"':{/{x;s/^/./;/^.\{2\}$/{x;s/oss00"$old_tool_id"/oss00"$1"/;b};x}" $dir2/conf/server_cfg.py
sed -i "/'oss00"$1"'/s/"$old_ip"/"$3"/" $dir2/conf/server_cfg.py
