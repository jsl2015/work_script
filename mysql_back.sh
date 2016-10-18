#! /bin/bash

my_passwd=redhat
#备份目录
back_dir=/myback
back_full=/myback/back_full
back_daily=/myback/back_daily

#数据目录
datadir=/var/lib/mysql

expire_time=`date +%Y%m%d -d '-30 day'`
now_time=`date +%Y%m%d`
now_hour=`date +%H`

[ -d ${back_dir} ] || mkdir ${back_dir}
[ -d ${back_full} ] || mkdir ${back_full}
[ -d ${back_daily} ] || mkdir ${back_daily}

if [ ${now_hour} -eq 02 ];then 
	[ -d ${back_full}/backup.${now_time}/ ] || mkdir ${back_full}/backup.${now_time}/
	back_db=`mysql -uroot -p${my_passwd} -e 'show databases;' | grep -Ev 'mysql|information_schema|Database'`
	for db in ${back_db}
	do
		mysqldump -uroot -p${my_passwd} --default-character-set=utf8 --single-transaction  --master-data=2 ${db} | gzip > ${back_full}/backup.${now_time}/${db}.${now_time}.sql.gz
	done
	rm -fr ${back_full}/backup.${expire_time}*

#binlog备份
else
	mysqladmin -uroot -p${my_passwd} flush-logs
	loglist=`cat ${datadir}/mysql-bin.index`
	counter=`${loglist} | wc -l`
	num=0
	for i in ${loglist}
	do
		num=$[$num+1]
		if [ $num -ne ${counter} ];then
			binlog=`basename $i`
			if test -e ${binlog};then
				echo "skip------"
			else
				cp ${datadir}/${binlog} ${back_daily}
			fi
		else
			break
		fi
	done
fi
find ${back_daily} -mtime +1 | xargs rm -fr {}
