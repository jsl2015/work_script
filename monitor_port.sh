#! /bin/bash
NAME=`sed -n '2p' /home/script/dataware/baidu.sql | awk -F"'" '{print $2}'`
while :
do
  VALUE=`netstat -ntlp | grep ":1000*" | wc -l`
  if [ $VALUE -eq 0 ];then
    sleep 300
      if [ $VALUE -eq 0 ];then
        echo 'Sending mail...'
        echo "$NAME Game service is down." | /bin/mail -s "GAME service faillure" 13548972503@163.com
        break
      else
        continue
      fi
  else
    sleep 5
  fi
done
