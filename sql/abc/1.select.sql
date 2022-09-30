
-- SELECT 用于重数据库中选取数据。
-- 结果被存储在一个结果表中，称为结果集。


-- 语法
-- SELECT column_name,column_name
-- FROM table_name;
-- 与
-- SELECT * FROM table_name;



-- 示例
SELECT name,country FROM websites;

SELECT * FROM websites;



-- 在表中，一个列可能会包含多个重复值，有时您也许希望仅仅列出不同（distinct）的值。
-- DISTINCT 关键词用于返回唯一不同的值。

-- 示例
SELECT DISTINCT country FROM websites;

