
-- UPDATE 语句
-- 用于更新表中的记录。

-- 用于更新表中已存在的记录。

-- 语法
-- UPDATE table_name
-- SET column1=value1,column2=value2,...
-- WHERE some_column=some_value;

-- -- !!! 请注意 SQL UPDATE 语句中的 WHERE 子句！
-- WHERE 子句规定哪条记录或者哪些记录需要更新。如果您省略了 WHERE 子句，所有的记录都将被更新！


-- 示例
UPDATE websites
SET alexa='5000', country='USA'
WHERE name='菜鸟教程';



-- -- !!!Update 警告！
-- 执行没有 WHERE 子句的 UPDATE 要慎重，再慎重。
UPDATE websites
SET alexa='5000', country='USA'


-- 在 MySQL 中可以通过设置 sql_safe_updates 这个自带的参数来解决，当该参数开启的情况下，
-- 你必须在update 语句后携带 where 条件，否则就会报错。
-- set sql_safe_updates=1; -- 表示开启该参数

-- 如何查询更多的配置项 https://www.cnblogs.com/wangqiideal/p/6321910.html
-- show global variables;
-- show global variables like "%datadir%"
