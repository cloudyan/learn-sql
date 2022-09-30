
-- TOP, LIMIT, ROWNUM 子句

-- 用于规定要返回的记录的数目。
-- 对于拥有数千条记录的大型表来说，是非常有用的。

-- 注意: 并非所有的数据库系统都支持 SELECT TOP 语句。
--   MySQL 支持 LIMIT 语句来选取指定的条数数据，
--   Oracle 可以使用 ROWNUM 来选取。

-- SQL Server 语法
-- SELECT TOP number|percent column_name(s)
-- FROM table_name;

-- MySQL 语法
-- SELECT column_name(s)
-- FROM table_name
-- LIMIT number;

-- Oracle 语法
-- SELECT column_name(s)
-- FROM table_name
-- WHERE ROWNUM <= number;



-- 示例
SELECT * FROM websites;

SELECT * FROM websites LIMIT 2;



-- 在 Microsoft SQL Server 中还可以使用百分比作为参数。
SELECT TOP 50 PERCENT * FROM websites;



-- 查询最后 N 行

-- 前5行
select * from websites order by id desc limit 5;
select top 5 * from table

-- 后5行
-- desc 表示降序排列 asc 表示升序
select top 5 * from table order by id desc
