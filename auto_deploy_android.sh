#! /bin/bash
#usage: sh android_auto_deploy.sh tool_id  服务器名 IP

old_tool_id=$(($1-1))
dir1=/var/www/html

#sed -i ' s/  {id = "8".*/{id = "8", name = "'$2'", ip = "'$3'", port=10000,state="推荐", color=0xFF5014},/g' $dir1/1/gameweb/serverlist.txt
sed -i '/'oss00"$old_tool_id"'.*/,/oss1001/H; {//g}' $dir1/daojian/app/config/database.php
sed -i '/oss00'$old_tool_id'/{x;s/^/./;/^.\{2\}$/{x;s/oss00'$old_tool_id'/oss00'$1'/;b};x}' $dir1/daojian/app/config/database.php

