

t:pv |
select
  count(1) as pv,
  approx_distinct(uid) as uv
order by
  pv desc
limit
  10000000


-- 按日期分组
-- 参考：https://help.aliyun.com/document_detail/93089.html
-- https://help.aliyun.com/document_detail/56728.html
-- https://help.aliyun.com/document_detail/63451.html
-- date_trunc('day', __time__) as dt
-- date_format(date / 1000, '%Y-%m-%d') as dt

t:pv |
select
  count(1) as pv,
  approx_distinct(uid) as uv,
  date_format(date / 1000, '%Y-%m-%d') as dt
group by
  dt
order by
  dt
limit
  10000000



-- 基于灵活时间分组统计
-- 将每条日志分组到了一个5分钟（300秒）的分区中进行统计总数（count(1)）
__topic__: aegis-log-login
| select from_unixtime(__time__ - __time__% 300) as dt,
count(1) as PV
group by dt
order by dt
limit 1000


* | select count(1) as pv , http_referer  group by http_referer order by pv desc limit 10


-- 参考

-- 计算每5分钟请求的平均延时和最大延时，从整体了解延时情况。
* | select from_unixtime(__time__ -__time__% 300) as time,
        avg(request_time) as avg_latency ,
        max(request_time) as max_latency
        group by __time__ -__time__% 300

-- 统计最大延时对应的请求页面，进一步优化页面响应。
* | select from_unixtime(__time__ - __time__% 60) ,
        max_by(request_uri,request_time)
        group by __time__ - __time__%60


-- 统计分析网站所有请求的延时分布，将延时分布分成10个组，分析每个延时区间的请求个数。
* | select numeric_histogram(10,request_time)
-- 计算最大的十个延时及其对应值。
* | select max(request_time,10)
