#! /bin/bash

dir1=/var/www/html
dir2=/usr/local/backup

#备份
for i in appstore hsjsapp;do
    cd $dir1/$i/gameweb
    tar czf $dir2/$i.`date +%m-%d`.tar.gz  *
    find $dir2 -mtime +3 | xargs rm -fr {}
done
echo "tar finished."

#配置
cd $dir1
for i in appstore hsjsapp;do
#取到区服号
    old_area_code=`awk '/name/ {print $6}' $i/gameweb/backdoor.txt | cut -b2,3`
    new_area_code=$(($old_area_code+1))

#config backdoor.txt
#    sed -i '/\[\[/,/\]\]/{//!d}' $i/gameweb/backdoor.txt 
#    sed -i '/\[\[/r '$4''        $i/gameweb/backdoor.txt
    sed -i 's/^{id.*\,$/{id = "'$1'", name = "'$new_area_code'区 '$2'", ip = "'$3'", port = 10000,state="推荐", color=0x14FF3A},/g' $i/gameweb/backdoor.txt 

#config serverlist.txt
    sed -i '/return {/a\  {id = "'$1'", name = "'$new_area_code'区 '$2'", ip = "'$3'", port = 10000,state="推荐", color=0x14FF3A},' $i/gameweb/serverlist.txt
    sed -i -e '/'$old_area_code'区/  s/推荐/爆满/g' -i -e '/'$old_area_code'区/ s/0x14FF3A/0xFF5014/g' $i/gameweb/serverlist.txt
done
echo "configure finished."
