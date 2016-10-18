#! /bin/bash
#usage: sh android_auto_deploy.sh tool_id  服务器名 IP

my_passwd="EK3FMif4pPQY"
dir1=/var/www/html
dir2=/usr/local/src/lilith_op
dir3=/usr/local/back
old_ip=`awk -F"\"" '/=>/ {print $2}' $dir1/djsy/host.php | tail -1`
old_name=`awk -F"\"" '/=>/ {print $4}' $dir1/djsy/host.php | tail -1`
old_tool_id=`printf "%04d" $[$1-1]`
new_tool_id=`printf "%04d" $1`

#备份
for i in $dir1/1/gameweb $dir1/djsy $dir1/daojian/app/config $dir2/dotalegend $dir2/conf;do
        cd $i
          if [ "$i" = "$dir1/1/gameweb" ];then
            tar -czvf $dir3/list_`date +%m-%d`.tar.gz *
          elif [ "$i" = "$dir1/djsy" ];then
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
sed -i ' s/  {id = "8".*/  {id = "8", name = "'$2'", ip = "'$3'", port=10000,state="推荐", color=0xFF5014},/g' $dir1/1/gameweb/serverlist.txt
sed -i '/'$old_ip'/h; //G' $dir1/djsy/host.php
sed -i '/'$old_ip'/{x;s/^/./;/^.\{2\}$/{x;s/'$old_ip'/'$3'/;b};x}' $dir1/djsy/host.php
sed -i '/'$old_name'/{x;s/^/./;/^.\{2\}$/{x;s/'$old_name'/'$2'/;b};x}' $dir1/djsy/host.php
#新工具后台配置
sed -i '/"oss'$old_tool_id'"=>"'$old_name'",/h; {//G}' $dir1/daojian/app/config/serverslist.php
sed -i '/oss'$old_tool_id'/{x;s/^/./;/^.\{2\}$/{x;s/oss'$old_tool_id'/oss'$new_tool_id'/;b};x}' $dir1/daojian/app/config/serverslist.php
sed -i '/'$old_name'/{x;s/^/./;/^.\{2\}$/{x;s/'$old_name'/'$2'/;b};x}' $dir1/daojian/app/config/serverslist.php
sed -i '/'oss"$old_tool_id"'.*/,/oss1001/H; {//g}' $dir1/daojian/app/config/database.php
sed -i '/oss'$old_tool_id'/{x;s/^/./;/^.\{2\}$/{x;s/oss'$old_tool_id'/oss'$new_tool_id'/;b};x}' $dir1/daojian/app/config/database.php
sed -i '/'$old_ip'/{x;s/^/./;/^.\{2\}$/{x;s/'$old_ip'/'$3'/;b};x}' $dir1/daojian/app/config/database.php

#旧工具后台配置
#################################config settings.py
sed -i "/'oss"$old_tool_id"': {/,/'oss1001'/H; {//g}" $dir2/dotalegend/settings.py
sed -i "/'oss"$old_tool_id"': {/{x;s/^/./;/^.\{2\}$/{x;s/oss"$old_tool_id"/oss"$new_tool_id"/;b};x}" $dir2/dotalegend/settings.py
sed -i '/'$old_ip'/{x;s/^/./;/^.\{2\}$/{x;s/'$old_ip'/'$3'/;b};x}' $dir2/dotalegend/settings.py

sed -i "/'oss"$old_tool_id"_gdb': {/,/'oss1001_gdb': {/H; {//g}" $dir2/dotalegend/settings.py
sed -i "/'oss"$old_tool_id"_gdb': {/{x;s/^/./;/^.\{2\}$/{x;s/oss"$old_tool_id"/oss"$new_tool_id"/;b};x}" $dir2/dotalegend/settings.py
sed -i '/'$old_ip'/{x;s/^/./;/^.\{3\}$/{x;s/'$old_ip'/'$3'/;b};x}' $dir2/dotalegend/settings.py

sed -i "/'oss"$old_tool_id"':u'"$old_name"',/h; //G" $dir2/dotalegend/settings.py
sed -i "/'oss"$old_tool_id"':u'"$old_name"',/{x;s/^/./;/^.\{2\}$/{x;s/oss"$old_tool_id"/oss"$new_tool_id"/;b};x}" $dir2/dotalegend/settings.py
sed -i "/'oss"$new_tool_id"'/s/"$old_name"/"$2"/" $dir2/dotalegend/settings.py

sed -i "/'oss"$old_tool_id"':{/h; //G" $dir2/dotalegend/settings.py
sed -i "/'oss"$old_tool_id"':{/{x;s/^/./;/^.\{2\}$/{x;s/oss"$old_tool_id"/oss"$new_tool_id"/;b};x}" $dir2/dotalegend/settings.py
sed -i "/'oss"$new_tool_id"'/s/"$old_ip"/"$3"/" $dir2/dotalegend/settings.py
##################################config server_cfg.py
sed -i "/'oss"$old_tool_id"':u'"$old_name"',/h; //G" $dir2/conf/server_cfg.py
sed -i "/'oss"$old_tool_id"':u'"$old_name"',/{x;s/^/./;/^.\{2\}$/{x;s/oss"$old_tool_id"/oss"$new_tool_id"/;b};x}" $dir2/conf/server_cfg.py
sed -i "/'oss"$new_tool_id"'/s/"$old_name"/"$2"/" $dir2/conf/server_cfg.py

sed -i "/'oss"$old_tool_id"':{/h; //G" $dir2/conf/server_cfg.py
sed -i "/'oss"$old_tool_id"':{/{x;s/^/./;/^.\{2\}$/{x;s/oss"$old_tool_id"/oss"$new_tool_id"/;b};x}" $dir2/conf/server_cfg.py
sed -i "/'oss"$new_tool_id"'/s/"$old_ip"/"$3"/" $dir2/conf/server_cfg.py

###################################把oss工具号加入oss库server表
old_id=`mysql -uroot -p$my_passwd -e 'select max(id) from oss.servers;'| grep -v "max(id)"`
id=$(($old_id+1))
echo "id is $id".
mysql -uroot -p$my_passwd -e 'insert into oss.servers(id,name) values('$id',"oss'$new_tool_id'")'

echo "deploy finished."
