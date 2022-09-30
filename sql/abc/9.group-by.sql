
-- GROUP BY 语句
-- 可结合一些聚合函数来使用

-- 用于结合聚合函数，根据一个或多个列对结果集进行分组。


-- 语法
-- SELECT column_name, aggregate_function(column_name)
-- FROM table_name
-- WHERE column_name operator value
-- GROUP BY column_name;



-- 示例
-- 统计 access_log 各个 site_id 的访问量：
SELECT site_id, SUM(access_log.count) AS nums
FROM access_log GROUP BY site_id;


-- 多表连接
-- 统计有记录的网站的记录数量
SELECT websites.name,COUNT(access_log.aid) AS nums FROM access_log
LEFT JOIN websites
ON access_log.site_id=websites.id
GROUP BY websites.name;
