
-- 在新记录插入表中时生成一个唯一的数字。

-- 我们通常希望在每次插入新记录时，自动地创建主键字段的值。
-- 我们可以在表中创建一个 auto-increment 字段。


-- 示例
CREATE TABLE Persons (
  ID int NOT NULL AUTO_INCREMENT,
  LastName varchar(255) NOT NULL,
  FirstName varchar(255),
  Address varchar(255),
  City varchar(255),
  PRIMARY KEY (ID)
);

-- MySQL 使用 AUTO_INCREMENT 关键字来执行 auto-increment 任务。
-- 默认地，AUTO_INCREMENT 的开始值是 1，每条新记录递增 1。

-- 要让 AUTO_INCREMENT 序列以其他的值起始，请使用下面的 SQL 语法：
ALTER TABLE Persons AUTO_INCREMENT=100




-- 给已经存在的colume添加自增语法
ALTER TABLE table_name CHANGE column_name column_name data_type(size) constraint_name AUTO_INCREMENT;
-- 如
ALTER TABLE student CHANGE id id INT( 11 ) NOT NULL AUTO_INCREMENT;
