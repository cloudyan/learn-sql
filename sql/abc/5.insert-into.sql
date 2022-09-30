
-- INSERT INTO 语句
-- 用于向表中插入新记录。


-- INSERT INTO 语法
-- 可以有两种编写形式。
-- * 第一种形式无需指定要插入数据的列名，只需提供被插入的值即可：
--   INSERT INTO table_name
--   VALUES (value1,value2,value3,...);
-- * 第二种形式需要指定列名及被插入的值：
--   INSERT INTO table_name (column1,column2,column3,...)
--   VALUES (value1,value2,value3,...);


-- 示例
INSERT INTO websites
VALUES ('百度','https://www.baidu.com/','4','CN');
INSERT INTO websites (name, url, alexa, country)
VALUES ('百度','https://www.baidu.com/','4','CN');


-- 在指定的列插入数据。（id 字段会自动更新）
INSERT INTO websites (name, url, country)
VALUES ('stackoverflow', 'http://stackoverflow.com/', 'IND');
