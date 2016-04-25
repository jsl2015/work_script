#! /bin/bash
#usage: sh auto_install.sh SVS_ID 服务器名 IP

#挂载云盘
mkdir /homebak
mv /home/* /homebak/
fdisk /dev/vdb << end
n
p
1


w
end

mkfs.ext3 /dev/vdb1
mount /dev/vdb1 /home
df -h
mv /homebak/* /home
echo "/dev/vdb1              /home                   ext3    defaults        0 0" >> /etc/fstab

if [ `ls /homebak | wc -l` -eq 0 ];then
    service mysqld start
fi
echo "Mysql started."

#服务器改名（sql改名、mysql备份脚本ip、存储过程服务器名、SVS_ID、crontab）
sed -i 's/虚幻之风/'$2'/g' /home/script/dataware/*
sed -i 's/myIP=115.159.39.35/myIP='$3'/g' /home/script/mysqlbackup.sh
sed -i 's/SVS_ID=10003/SVS_ID='$1'/g' /home/server/deploy_cfg.ini
sed -i '1,3 s/#//g' /var/spool/cron/root
