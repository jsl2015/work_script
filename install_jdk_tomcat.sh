#! /bin/bash

yum install cronolog -y

jdk_bundle=$(ls /usr/local/src/|grep jdk)
tomcat_bundle=$(ls /usr/local/src/|grep tomcat)
tomcat_dir=/opt/$(ls /usr/local/src|grep -oP "tomcat-\d\.\d\.\d+")
jdk_dir=/opt/$(ls /opt|grep jdk)

#解压
tar xf /usr/local/src/$jdk_bundle -C /opt
tar xf /usr/local/src/$tomcat_bundle -C /opt
mv /opt/$(ls /opt|grep tomcat) $tomcat_dir

#jdk环境变量
echo 'export JAVA_HOME=/opt/jdk1.8.0_121
export PATH=$PATH:$JAVA_HOME/bin
export CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar' >> /etc/profile 
source /etc/profile

#修改端口;日志切割
sed -i 's/<Connector port="8080"/<Connector port="80"/g' $tomcat_dir/conf/server.xml
sed -i 's/org.apache.catalina.startup.Bootstrap "$@" start \\/org.apache.catalina.startup.Bootstrap "$@" start 2\>\&1 \\/g' $tomcat_dir/bin/catalina.sh
sed -i 's/>> "$CATALINA_OUT" 2>&1 "&"/| \/usr\/sbin\/cronolog "$CATALINA_BASE"\/logs\/catalina.%Y-%m-%d.out >> \/dev\/null \&/g' $tomcat_dir/bin/catalina.sh
echo "0 2 * * *  find /opt/tomcat-8.5.13/logs/* -mtime +7|xargs rm -fr {}" >> /var/spool/cron/root

#启动tomcat
nohup sh $tomcat_dir/bin/startup.sh &
sleep 5
netstat -ntlp


