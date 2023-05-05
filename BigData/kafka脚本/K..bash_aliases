#! /bin/bash


case $1 in
"-s1"){
echo "==========查看Kafka的所有主题topic==========="
kafka-topics.sh --zookeeper hadoop202:2181 --list
};;
"-s2"){
echo "==========创建Kafka的主题topic==========="
read -p '请输入分区副本数：' replic
read -p '请输入分区数：' partitions
read -p '请输入主题名称：' topic
kafka-topics.sh --zookeeper hadoop202:2181 --create --replication-factor $topic --partitions $partitions --topic $topic
};;
"-s3"){
echo "==========删除Kafka的所有主题topic==========="
read -p '请输入删除的主题名称:' topic

kafka-topics.sh --zookeeper hadoop202:2181 --delete --topic $topic

};;
"-s4"){
echo "==========查看Kafka的主题topic详情==========="
read -p '请输入删除的主题名称:' topic

kafka-topics.sh --zookeeper hadoop202:2181 --describe –-topic $topic

};;

"-s5"){
echo "==========启动Kafka的生产者==========="
read -p '请输入启动的主题名称:' topic

kafka-console-producer.sh -broker-list hadoop202:9092 --topic $topic

};;

"-s6"){
echo "==========启动Kafka的消费者==========="
read -p '请输入启动的主题名称:' topic

kafka-console-consumer.sh --bootstrap-server hadoop202:9092 --topic $topic

};;
"-s7"){
echo "==========启动Kafka的消费者【查看以往的消息】==========="
read -p '请输入启动的主题名称:' topic

kafka-console-consumer.sh --bootstrap-server hadoop202:9092 --from-beginning --topic $topic

};;
"-s8"){
echo "==========修改Kafka的主题topic分区数==========="
read -p '请输入修改的主题名称:' topic
read -p '请输入修改的分区数量:' partitions

kafka-topics.sh --zookeeper hadoop102:2181 --alter –-topic $topic --partitions $partitions

};;


*)#*匹配其他的参数
echo "命令输入错误,正确命令：
-s1		查看Kafka的所有主题topic
-s2		创建Kafka的主题topic
-s3		删除Kafka的主题topic
-s4		查看Kafka的主题topic详情
-s5		启动Kafka的生产者
-s6		启动Kafka的消费者
-s7		启动Kafka的消费者【查看以往的消息】
-s8		修改Kafka的主题topic分区数
"
exit;
;;
esac

echo "Execution Done!!!"