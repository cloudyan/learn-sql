
-- DELETE 语句
-- 用于删除表中的记录。

-- 语法
-- DELETE FROM table_name
-- WHERE some_column=some_value;


-- -- !!!请注意 SQL DELETE 语句中的 WHERE 子句！
-- WHERE 子句规定哪条记录或者哪些记录需要删除。如果您省略了 WHERE 子句，所有的记录都将被删除！


-- 示例
DELETE FROM websites
WHERE name='Facebook' AND country='USA';



-- 删除所有数据
-- 您可以在不删除表的情况下，删除表中所有的行。这意味着表结构、属性、索引将保持不变：

DELETE FROM table_name;
-- -- !!!注释：在删除记录时要格外小心！因为您不能重来！
