#! /bin/bash
#usage: sh auto_install.sh SVS_ID 服务器名 IP

my_passwd="EK3FMif4pPQY"
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
mysql -uroot -p$my_passwd dgame_game_db_1 -e 'CREATE TABLE `cross_rankboard` (
  `vKey` varchar(64) NOT NULL,
  `bValue` mediumblob,
  PRIMARY KEY (`vKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;'

#服务器改名（sql改名、mysql备份脚本ip、存储过程服务器名、SVS_ID、crontab）
sed -i 's/精灵王子/'$2'/g' /home/script/dataware/*
sed -i 's/myIP=182.254.245.135/myIP='$3'/g' /home/script/mysqlbackup.sh
sed -i 's/SVS_ID=51/SVS_ID='$1'/g' /home/server/deploy_cfg.ini
sed -i '1,3 s/#//g' /var/spool/cron/root
sed -i "s/120.26.112.52/10.105.200.123/g" /home/script/rsy_djsy.sh
sed -i "s/djsy/qst/g" /home/script/*.sh 
sed -i "s/djsy_dw/qst_dw/g" /home/script/dataware/* 
mv /home/script/rsy_djsy.sh /home/script/rsy_qst.sh
