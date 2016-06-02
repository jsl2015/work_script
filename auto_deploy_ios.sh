#! /bin/bash
#usage: sh android_auto_deploy.sh tool_id  服务器名 IP

dir1=/var/www/html
dir2=/usr/local/src/lilith_op
dir3=/usr/local/back
old_ip=`awk -F"\"" '/=>/ {print $2}' $dir1/djsyapp/host.php | tail -1`
old_name=`awk -F"\"" '/=>/ {print $4}' $dir1/djsyapp/host.php | tail -1`
old_tool_id=$(($1-1))

#备份
for i in $dir1/1/gameweb $dir1/djsyapp $dir1/daojian/app/config $dir2/dotalegend $dir2/conf;do
        cd $i
          if [ "$i" = "$dir1/1/gameweb" ];then
            tar -czvf $dir3/list_`date +%m-%d`.tar.gz *
          elif [ "$i" = "$dir1/djsyapp" ];then
            tar -czvf $dir3/host_`date +%m-%d`.tar.gz *
          elif [ "$i" = "$dir1/daojian/app/config" ];then
            tar -czvf $dir3/new_`date +%m-%d`.tar.gz *
          elif [ "$i" = "$dir2/dotalegend" ];then
            tar -czvf $dir3/settings_`date +%m-%d`.tar.gz *
          elif [ "$i" = "$dir2/conf" ];then
            tar -czvf $dir3/servera_cfg_`date +%m-%d`.tar.gz *
          fi
done
find $dir3 -mtime +3 | xargs rm -fr {}
echo "backup finished."

#加入列表
sed -i ' s/  {id = "12".*/  {id = "12", name = "'$2'", ip = "'$3'", port=10000,state="推荐", color=0xFF5014},/g' $dir1/1/gameweb/serverlist.txt
sed -i '/'$old_ip'/h; //G' $dir1/djsyapp/host.php
sed -i '/'$old_ip'/{x;s/^/./;/^.\{2\}$/{x;s/'$old_ip'/'$3'/;b};x}' $dir1/djsyapp/host.php
sed -i '/'$old_name'/{x;s/^/./;/^.\{2\}$/{x;s/'$old_name'/'$2'/;b};x}' $dir1/djsyapp/host.php
#新工具后台配置
sed -i '/"oss'$old_tool_id'" =>"AppStore'$old_name'",/h; {//G}' $dir1/daojian/app/config/serverslist.php
sed -i '/oss'$old_tool_id'/{x;s/^/./;/^.\{2\}$/{x;s/oss'$old_tool_id'/oss'$1'/;b};x}' $dir1/daojian/app/config/serverslist.php
sed -i '/'$old_name'/{x;s/^/./;/^.\{2\}$/{x;s/'$old_name'/'$2'/;b};x}' $dir1/daojian/app/config/serverslist.php
sed -i '/'oss"$old_tool_id"'.*/,/oss4001/H; {//g}' $dir1/daojian/app/config/database.php
sed -i '/oss'$old_tool_id'/{x;s/^/./;/^.\{2\}$/{x;s/oss'$old_tool_id'/oss'$1'/;b};x}' $dir1/daojian/app/config/database.php
sed -i '/'$old_ip'/{x;s/^/./;/^.\{2\}$/{x;s/'$old_ip'/'$3'/;b};x}' $dir1/daojian/app/config/database.php

#旧工具后台配置
#################################config settings.py
sed -i "/'oss"$old_tool_id"': {/,/'oss10001'/H; {//g}" $dir2/dotalegend/settings.py
sed -i "/'oss"$old_tool_id"': {/{x;s/^/./;/^.\{2\}$/{x;s/oss"$old_tool_id"/oss"$1"/;b};x}" $dir2/dotalegend/settings.py
sed -i '/'$old_ip'/{x;s/^/./;/^.\{2\}$/{x;s/'$old_ip'/'$3'/;b};x}' $dir2/dotalegend/settings.py

sed -i "/'oss"$old_tool_id"_gdb': {/,/'oss4001_gdb': {/H; {//g}" $dir2/dotalegend/settings.py
sed -i "/'oss"$old_tool_id"_gdb': {/{x;s/^/./;/^.\{2\}$/{x;s/oss"$old_tool_id"/oss"$1"/;b};x}" $dir2/dotalegend/settings.py
sed -i '/'$old_ip'/{x;s/^/./;/^.\{3\}$/{x;s/'$old_ip'/'$3'/;b};x}' $dir2/dotalegend/settings.py

sed -i "/'oss"$old_tool_id"':u'AppStore"$old_name"',/h; //G" $dir2/dotalegend/settings.py
sed -i "/'oss"$old_tool_id"':u'AppStore"$old_name"',/{x;s/^/./;/^.\{2\}$/{x;s/oss"$old_tool_id"/oss"$1"/;b};x}" $dir2/dotalegend/settings.py
sed -i "/'oss"$1"'/s/"$old_name"/"$2"/" $dir2/dotalegend/settings.py

sed -i "/'oss"$old_tool_id"':{/h; //G" $dir2/dotalegend/settings.py
sed -i "/'oss"$old_tool_id"':{/{x;s/^/./;/^.\{2\}$/{x;s/oss"$old_tool_id"/oss"$1"/;b};x}" $dir2/dotalegend/settings.py
sed -i "/'oss"$1"'/s/"$old_ip"/"$3"/" $dir2/dotalegend/settings.py
##################################config server_cfg.py
sed -i "/'oss"$old_tool_id"':u'AppStore"$old_name"',/h; //G" $dir2/conf/server_cfg.py
sed -i "/'oss"$old_tool_id"':u'AppStore"$old_name"',/{x;s/^/./;/^.\{2\}$/{x;s/oss"$old_tool_id"/oss"$1"/;b};x}" $dir2/conf/server_cfg.py
sed -i "/'oss"$1"'/s/"$old_name"/"$2"/" $dir2/conf/server_cfg.py

sed -i "/'oss"$old_tool_id"':{/h; //G" $dir2/conf/server_cfg.py
sed -i "/'oss"$old_tool_id"':{/{x;s/^/./;/^.\{2\}$/{x;s/oss"$old_tool_id"/oss"$1"/;b};x}" $dir2/conf/server_cfg.py
sed -i "/'oss"$1"'/s/"$old_ip"/"$3"/" $dir2/conf/server_cfg.py
###################################把oss工具号加入oss库server表
old_id=`mysql -uroot -p$my_passwd -e 'select max(id) from oss.servers;'| grep -v "max(id)"`
id=$(($old_id+1))
echo "id is $id".
mysql -uroot -p$my_passwd -e 'insert into oss.servers(id,name) values('$id',"oss'$1'")'

echo "deploy finished."

