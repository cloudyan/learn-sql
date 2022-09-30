
-- UNION 操作符
-- 用于合并两个或多个 SELECT 语句的结果集。

-- -- !!!请注意
-- UNION 内部的每个 SELECT 语句必须拥有相同数量的列。列也必须拥有相似的数据类型。
-- 同时，每个 SELECT 语句中的列的顺序必须相同。



-- UNION 语法
-- SELECT column_name(s) FROM table1
-- UNION
-- SELECT column_name(s) FROM table2;
-- 注释：默认地，UNION 操作符选取不同的值。如果允许重复的值，请使用 UNION ALL。

-- UNION ALL 语法
-- SELECT column_name(s) FROM table1
-- UNION ALL
-- SELECT column_name(s) FROM table2;
-- 注释：UNION 结果集中的列名总是等于 UNION 中第一个 SELECT 语句中的列名。




-- 示例
SELECT country FROM websites
UNION
SELECT country FROM apps
ORDER BY country;

-- 注释：UNION 不能用于列出两个表中所有的country。如果一些网站和APP来自同一个国家，每个国家只会列出一次。UNION 只会选取不同的值。请使用 UNION ALL 来选取重复的值！


SELECT country FROM websites
UNION ALL
SELECT country FROM apps
ORDER BY country;


-- 带有 WHERE 的 SQL UNION ALL
-- 从 "websites" 和 "apps" 表中选取所有的中国(CN)的数据（也有重复的值）
SELECT country, name FROM websites
WHERE country='CN'
UNION ALL
SELECT country, app_name FROM apps
WHERE country='CN'
ORDER BY name;


-- 使用UNION命令时需要注意，只能在最后使用一个ORDER BY命令，是将两个查询结果合在一起之后，再进行排序！绝对不能写两个ORDER BY命令。
-- 另外，在使用ORDER BY排序时，注意两个结果的别名保持一致，使用别名排序很方便。当然也可以使用列数。

-- ORDER BY 除了可以对指定的字段进行排序，还可以使用函数进行排序:
order by abs(a);

-- ORDER BY 只能当前 SQL 查询结果进行排序，如要对 union all 出来的结果进行排序，需要先做集合。
select aa.* from
(select country,name from websites where country = 'CN'
union all select country,app_name from apps where country='CN' ) aa
order by aa.name;


-- 当字段唯一时，可省略表名 aa
select * from
(select country,name from websites where country = 'CN'
union all select country,app_name from apps where country='CN' ) aa
order by name;
