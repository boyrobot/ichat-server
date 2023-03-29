#!/bin/sh
# 部署安装脚本

echo "*************************部署开始*************************"

#移动文件到指定位置
echo "=============将fastdfs文件移动到指定位置...========================="
cp -r fastdfs /usr/local/
echo "=============将数据库sql文件移动到指定位置...========================="
mkdir /usr/local/mysql/
cp chat.sql /usr/local/mysql/
echo "=============将yml文件移动到指定位置...========================="
mkdir /usr/local/apps/ichat/conf/
cp *.yml /usr/local/apps/ichat/conf/

#拉取镜像文件
echo "===============拉取fastdfs镜像文件...==============="
docker pull season/fastdfs:1.2
docker tag season/fastdfs:1.2 fastdfs-nginx:v5.11
echo "===============加载ichat镜像文件...==============="
docker build -t ichat:1.0.0 .
echo "===============加载mysql镜像文件...==============="
cd mysql
docker build -t mysql:5.7.26 .

#检测ip
function check_ip() {
  local IP=$IP
  VALID_CHECK=$(echo $IP|awk -F. '$IP<=255&&$2<=255&&$3<=255&&$4<=255{print "yes"}')
  if echo $IP|grep -E "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$"; then
    if [ $VALID_CHECK == "yes" ]; then
      echo "IP: $IP  为合法IP"
      return 0
    else
      echo "IP: $IP  为不合法IP，请重新输入"
      return 1
    fi
  else
    echo "IP: $IP  格式错误，请重新输入"
    return 1
  fi
}
#直到输入合法的ip才继续
while true; do
  read -p "请输入服务器IP地址(input current linux IP address here,please)：" IP
  check_ip $IP
  [ $? -eq 0 ] && break
done

#修改fastdfs配置文件
echo "===============修改fastdfs配置文件...==============="
echo "输入的服务器IP地址为：" $IP
sed -i -e "s|tracker_server=.*:22122|tracker_server=$IP:22122|g" /usr/local/fastdfs/conf/storage.conf

#创建运行环境容器并启动
echo "===============创建mysql容器并启动...==============="
docker run --name mysql --net=host --restart=always -v /usr/local/mysql/conf:/etc/mysql/conf.d -v /usr/local/mysql/data:/var/lib/mysql -v /usr/local/mysql/log:/log -e MYSQL_ROOT_PASSWORD=root --privileged=true -d mysql:5.7.26 --lower_case_table_names=1

echo "===============创建fastdfs容器并启动...==============="
docker run --restart=always -m 512m -v /usr/local/fastdfs/storage:/data/fastdfs/storage -v /usr/local/fastdfs/tracker:/data/fastdfs/tracker -v /usr/local/fastdfs/conf/storage.conf:/etc/fdfs/storage.conf -v /usr/local/fastdfs/conf/tracker.conf:/etc/fdfs/tracker.conf -v /usr/local/fastdfs/conf/client.conf:/etc/fdfs/client.conf -v /usr/local/fastdfs/conf/mod_fastdfs.conf:/etc/fdfs/mod_fastdfs.conf --name fastdfs -d --net=host --privileged=true fastdfs-nginx:5.11

sleep 40s
#初始化mysql数据库（sql路径为宿主机）
echo "===============初始化ichat数据库脚本ichat.sql...==============="
docker exec -i mysql sh -c "exec mysql -uroot -proot" < /usr/local/mysql/chat.sql
#创建ichat容器并启动
echo "===============创建ichat容器并启动...==============="
docker run --name ichat --net=host --restart=always -m 1024m -e JAVA_OPTIONS="-Xmx768m" -e appName="ichat.jar" --privileged=true -e serverPort=8080 -v /usr/local/apps/ichat/conf:/data/apps/config -v /usr/local/apps/ichat/log:/data/log -d ichat:1.0.0
echo "===============修改ichat服务yml配置文件...==============="
echo "输入的服务器IP地址为：" $IP
sed -i -e "s|private: .*|private: $IP|g" /usr/local/apps/ichat/conf/application.yml
echo "===============重启ichat容器使配置生效...==============="
docker restart ichat
echo "*************************部署完成*************************"

