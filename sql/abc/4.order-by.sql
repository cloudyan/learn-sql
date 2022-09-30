
-- ORDER BY 关键字
-- 用于对结果集进行排序。

-- 1. 用于对结果集按照一个列或者多个列进行排序。
-- 2. 默认按照升序对记录进行排序。如果需要按照降序对记录进行排序，您可以使用 DESC 关键字。


-- 语法
-- SELECT column_name,column_name
-- FROM table_name
-- ORDER BY column_name,column_name ASC|DESC;



-- 示例
-- 默认升序
SELECT * FROM websites
ORDER BY alexa;


-- 降序
SELECT * FROM websites
ORDER BY alexa DESC;


-- 多列
SELECT * FROM websites
ORDER BY country,alexa;
