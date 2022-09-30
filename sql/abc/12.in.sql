
-- IN 操作符
-- 允许您在 WHERE 子句中规定多个值。

-- 语法
-- SELECT column_name(s)
-- FROM table_name
-- WHERE column_name IN (value1,value2,...);



-- 示例
SELECT * FROM websites
WHERE name IN ('Google','菜鸟教程');



-- IN 与 = 的异同
--  相同点：均在WHERE中使用作为筛选条件之一、均是等于的含义
--  不同点：IN可以规定多个值，等于规定一个值



-- 可转换
select * from Websites where name in ('Google','菜鸟教程');
select * from Websites where name='Google' or name='菜鸟教程';


-- NOT IN 语法

-- SELECT 字段(s)
-- FROM 表名
-- WHERE 条件字段 NOT IN (v1,v2,...);

-- SELECT 字段(s)
-- FROM 表名
-- WHERE 条件字段 <> v1 AND 条件字段 <> v2 ...;
