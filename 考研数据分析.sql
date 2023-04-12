--考研数据分析

show databases;

use kaoyan_analyse;

-- 考研数据分析

--考研数据字段。
-- 年份
-- 学校名称_链接
-- 学校名称
-- 院系名称_链接
-- 院系名称
-- 专业代码
-- 专业名称_链接
-- 专业名称
-- 总分
-- 政治_管综
-- 外语
-- 业务课_一
-- 业务课_二

--创建考研数据库
create database kaoyan_analyse;

--创建考研分析表
create external table if not exists ky_stu_analy(
year string comment "年份"
, school_name_link string comment "学校名称_链接"
,school_name string comment "学校名称"
,depname_link string comment "院系名称_链接"
,depname string comment "院系名称"
,spec_code string comment "专业代码"
,spec_code_link string comment "专业名称_链接"
,spec_name string comment "专业名称"
,total string comment "总分"
,poli string comment "政治_管综"
,fore_lang string comment "外语"
,busi_one string comment "业务课_一"
,busi_two string comment "业务课_二"
)
row format delimited fields terminated by '\t';

--查看表分隔符已经hdfs保存地址
show create table ky_stu_analy;

--先上传hdfs

--hdfs导入数据到ky_stu_analy
load data inpath '/input/ky_analy/考研历年国家分数线.txt' overwrite into table ky_stu_analy;

--从lunux本地导入数据到ky_stu_analy
load data local inpath '/opt/module/hive/datas/student.txt' overwrite into table ky_stu_analy;

--查询业务课丢失的数据
select * from ky_stu_analy where busi_one in ("-") or busi_two in ("-") limit 20;

--查询过滤掉带链接的字段并过滤掉丢失的数据---查询结果导入
insert overwrite table ky_stu_analy_etl
select year,school_name,depname,spec_code,spec_name,total,poli,fore_lang,busi_one,busi_two
from ky_stu_analy where busi_one not in ("-") or busi_two not in ("-");

insert overwrite table ky_stu_analy_etll
select * from ky_stu_analy_etl where busi_one not in ("-") and busi_two not in ("-");

insert overwrite table ky_stu_analy_etl
select * from ky_stu_analy_etll where busi_one not in ("-");

--过滤1
create external table if not exists ky_stu_analy_etl(
year string comment "年份"
,school_name string comment "学校名称"
,depname string comment "院系名称"
,spec_code string comment "专业代码"
,spec_name string comment "专业名称"
,total string comment "总分"
,poli string comment "政治_管综"
,fore_lang string comment "外语"
,busi_one string comment "业务课_一"
,busi_two string comment "业务课_二"
)
row format delimited fields terminated by '\t';


--根据专业代码进行进行分组过滤重复的数值
select *,(select spec_code spc
from ky_stu_analy group by spec_code) t
from  ky_stu_analy limit 10;

--表没有null值
select *
from ky_stu_analy where year is not null limit 10;


--过滤1查询
insert overwrite table ky_stu_analy_etll;

select * from ky_stu_analy_etll where busi_two not in ("-");


select count(distinct spec_code) t,year, school_name, depname, spec_code, spec_name,total,poli,fore_lang, busi_one,busi_two
from ky_stu_analy_etl group by year, school_name, depname, spec_code, spec_name,total,poli,fore_lang, busi_one,busi_two having count(1)>1 limit 10;


--查询数据导入--然后不查询t列导入数据
--etl已经过滤好了

--根据查询语句创建表并导入
create table if not exists etltest as
SELECT year, school_name, depname, spec_code, spec_name, total, poli, fore_lang, busi_one, busi_two, COUNT(DISTINCT spec_code) AS t
FROM ky_stu_analy_etl
GROUP BY year, school_name, depname, spec_code, spec_name, total, poli, fore_lang, busi_one, busi_two
HAVING COUNT(1) > 1;

--将最后清洗的数据导入到etll表中
insert overwrite table ky_stu_analy_etll
select year,school_name,depname,spec_code,spec_name,total,poli,fore_lang,busi_one,busi_two from etltest;


