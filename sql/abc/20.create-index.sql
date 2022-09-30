
-- CREATE INDEX 语句
-- 用于在表中创建索引。
-- 在不读取整个表的情况下，索引使数据库应用程序可以更快地查找数据。


-- 您可以在表中创建索引，以便更加快速高效地查询数据。
-- 用户无法看到索引，它们只能被用来加速搜索/查询。
-- 注释：更新一个包含索引的表需要比更新一个没有索引的表花费更多的时间，这是由于索引本身也需要更新。因此，理想的做法是仅仅在常常被搜索的列（以及表）上面创建索引。


-- 语法
CREATE INDEX index_name
ON table_name (column_name)

-- 创建唯一的索引
-- 不允许使用重复的值：唯一的索引意味着两个行不能拥有相同的索引值。
CREATE UNIQUE INDEX index_name
ON table_name (column_name)



-- 示例
CREATE INDEX PIndex
ON Persons (LastName)

-- 索引不止一个列
CREATE INDEX PIndex
ON Persons (LastName, FirstName)
