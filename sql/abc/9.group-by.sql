
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


-- having 与 where 的区别
-- where 子句的作用是在对查询结果进行分组前，将不符合where条件的行去掉，即在分组之前过滤数据，where条件中不能包含聚组函数，使用where条件过滤出特定的行。
-- having 子句的作用是筛选满足条件的组，即在分组之后过滤数据，条件中经常包含聚组函数，使用having 条件过滤出特定的组，也可以使用多个分组标准进行分组。


select 类别, sum(数量) as 数量之和 from A
group by 类别
having sum(数量) > 18


select 类别, SUM(数量)from A
where 数量 > 8
group by 类别
having SUM(数量) > 10
