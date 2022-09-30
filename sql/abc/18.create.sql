
-- CREATE DATABASE 语句用于创建数据库
-- CREATE TABLE 语句用于创建数据库中的表。表由行和列组成，每个表都必须有个表名。


-- CREATE DATABASE 语法
-- CREATE DATABASE dbname;


-- 示例
CREATE DATABASE my_db;



-- CREATE TABLE 语法
-- CREATE TABLE table_name
-- (
-- column_name1 data_type(size),
-- column_name2 data_type(size),
-- column_name3 data_type(size),
-- ....
-- );

-- * column_name 参数规定表中列的名称。
-- * data_type 参数规定列的数据类型（例如 varchar、integer、decimal、date 等等）。
-- * size 参数规定表中列的最大长度。
-- 更多参见 [SQL 用于各种数据库的数据类型](https://www.runoob.com/sql/sql-datatypes.html)


-- 示例
CREATE TABLE Persons (
  PersonID int,
  LastName varchar(255),
  FirstName varchar(255),
  Address varchar(255),
  City varchar(255)
);

-- PersonID 列的数据类型是 int，包含整数。
-- LastName、FirstName、Address 和 City 列的数据类型是 varchar，包含字符，且这些字段的最大长度为 255 个字符。
