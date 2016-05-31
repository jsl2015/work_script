#! /bin/bash

mysqldump=/usr/bin/mysqldump
my_passwd=EK3FMif4pPQY
mysql=/usr/bin/mysql
back_dir=/home/back_hefu
hefu_file=/home/hefu/hefu_server/ebin/hefu_server.app
master_ip=10.105.211.129
master_id=56
slave1_ip=10.105.119.31
slave1_id=57
slave2_ip=10.105.118.14
slave2_id=58

cd /home/server
sh stop.sh
cd /home
mkdir back_hefu
$mysqldump -uroot -p$my_passwd --opt --single-transaction dgame_game_db_1  > back_hefu/dgame.sql
$mysqldump -uroot -p$my_passwd --opt --single-transaction test  > back_hefu/test.sql
echo -e "\033[33m Backup finished. \033[0m"

sed -i 's/1, "127.0.0.1"/1, "'$master_ip'"/g' $hefu_file
sed -i 's/id_1, "1"/id_1, "'$master_id'"/g' $hefu_file
sed -i 's/2, "127.0.0.1"/2, "'$slave1_ip'"/g' $hefu_file
sed -i 's/id_2, "2"/id_2, "'$slave1_id'"/g' $hefu_file
sed -i '/^$/d' hefu/hefu_server/start-dev.sh
sed -i 's/reloader/reloader \\/g' hefu/hefu_server/start-dev.sh
echo "    -noshell" >> hefu/hefu_server/start-dev.sh

cd /home/hefu/hefu_server 
make 
./start-dev.sh > /home/hefu.log 2>&1 &
echo -e "\033[33m hefu begining================= \033[0m"
#sleep 40
while :
  do
	if tail /home/hefu.log | grep change_all_end;then
		kill -2 $!
		if [ -e /home/charge_2.sql ];then
        		$mysql -uroot -p$my_passwd test < /home/charge_2.sql
        		$mysql -e 'alter table test.charge rename to test.charge_2;' -uroot -p$my_passwd
        		$mysql -e 'alter table dgame_game_db_1.charge modify dtEventTime timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP;' -uroot -p$my_passwd
        		$mysql -e 'alter table test.charge_2 modify dtEventTime timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP;' -uroot -p$my_passwd 
        		$mysql -e "update dgame_game_db_1.charge set vUin = CONCAT(vUin,'#fsid$master_id');" -uroot -p$my_passwd
        		$mysql -e "update test.charge_2 set vUin = CONCAT(vUin,'#fsid$slave1_id');" -uroot -p$my_passwd
        		$mysql -e "insert into dgame_game_db_1.charge
                	select vSerial,vFrom,vUin,dtEventTime,iOrderMoney,iGoodsId,iGoodsCnt,iStatus,b.iUserId  
                	from test.charge_2 a, dgame_game_db_1.user b 
                	where a.vUin = b.vDeviceId;" -uroot -p$my_passwd
		else echo "Please put charge_2.sql into /home."
		fi
        break
	fi
done	
sleep 3
user_count=`$mysql -e 'select count(*) from dgame_game_db_1.user;' -uroot -p$my_passwd`
charge_count=`$mysql -e 'select count(*) from dgame_game_db_1.charge;' -uroot -p$my_passwd`
charge_sum=`$mysql -e 'select sum(iordermoney) from dgame_game_db_1.charge;' -uroot -p$my_passwd`
echo -e "\033[33m Total user is:${user_count}\nTotal charge is:${charge_count}\nSum of iordermoney is:${charge_sum} \033[0m"
sleep 10

while :
 do
   if [ $slave2_ip = 0 ];then
     echo "finished."
     break
   elif [ -e /home/charge_3.sql ];then
     sed -i 's/change_db_1, false/change_db_1, true/g' $hefu_file
     sed -i 's/2, "'$slave1_ip'"/2, "'$slave2_ip'"/g' $hefu_file
     sed -i 's/id_2, "'$slave1_id'"/id_2, "'$slave2_id'"/g' $hefu_file
     make
     ./start-dev.sh > /home/hefu2.log 2>&1 &
     echo -e "\033[33m hefu begining================= \033[0m"
       while :
	do
           if tail /home/hefu2.log | grep change_all_end;then
             kill -2 $!
             $mysql -uroot -p$my_passwd test < /home/charge_3.sql
             $mysql -e 'alter table test.charge rename to test.charge_3;' -uroot -p$my_passwd
             $mysql -e 'alter table test.charge_3 modify dtEventTime timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP;' -uroot -p$my_passwd
             $mysql -e "update test.charge_3 set vUin = CONCAT(vUin,'#fsid$slave2_id');" -uroot -p$my_passwd
             $mysql -e "insert into dgame_game_db_1.charge
                        select vSerial,vFrom,vUin,dtEventTime,iOrderMoney,iGoodsId,iGoodsCnt,iStatus,b.iUserId  
                        from test.charge_3 a, dgame_game_db_1.user b 
                        where a.vUin = b.vDeviceId;" -uroot -p$my_passwd
             user_count=`$mysql -e 'select count(*) from dgame_game_db_1.user;' -uroot -p$my_passwd`
             charge_count=`$mysql -e 'select count(*) from dgame_game_db_1.charge;' -uroot -p$my_passwd`
             charge_sum=`$mysql -e 'select sum(iordermoney) from dgame_game_db_1.charge;' -uroot -p$my_passwd`
             echo -e "\033[33m Total user is:${user_count}\nTotal charge is:${charge_count}\nSum of iordermoney is:${charge_sum} \033[0m"
             sleep 3
           break  
	   fi
       done
   break
   else echo "Please put charge_3.sql into /home."
   fi
done
