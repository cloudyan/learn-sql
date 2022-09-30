
-- BETWEEN 操作符
-- 用于选取介于两个值之间的数据范围内的值。

-- 选取介于两个值之间的数据范围内的值。这些值可以是数值、文本或者日期。


-- 语法
-- SELECT column_name(s)
-- FROM table_name
-- WHERE column_name BETWEEN value1 AND value2;



-- 示例
SELECT * FROM websites
WHERE alexa BETWEEN 1 AND 20;


SELECT * FROM websites
WHERE alexa NOT BETWEEN 1 AND 20;


-- 选取 alexa 介于 1 和 20 之间但 country 不为 USA 和 IND 的所有网站
SELECT * FROM websites
WHERE (alexa BETWEEN 1 AND 20)
AND country NOT IN ('USA', 'IND');


-- 带有文本值
-- 选取 name 以介于 'A' 和 'H' 之间字母开始的所有网站
SELECT * FROM Websites
WHERE name BETWEEN 'A' AND 'H';


SELECT * FROM Websites
WHERE name NOT BETWEEN 'A' AND 'H';


-- 带有日期值
SELECT * FROM access_log
WHERE date BETWEEN '2016-05-10' AND '2016-05-14';


-- -- !!! 请注意，在不同的数据库中，BETWEEN 操作符会产生不同的结果！
-- BETWEEN 选取介于两个值之间, 但 包括或不包括 两个测试值的字段。这个需要检查确认
