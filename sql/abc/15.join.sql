
-- JOIN 子句，联合表
-- 用于把来自两个或多个表的行结合起来，基于这些表之间的共同字段


-- 用于将两个或者多个表联合起来进行查询
-- 联合表时需要在每个表中选择一个字段，并对这些字段的值进行比较，值相同的两条记录将合并为一条。
-- 联合表的本质就是将不同表的记录合并起来，形成一张新表。当然，这张新表只是临时的，它仅存在于本次查询期间。
-- 一个典型的例子是，将一个表的主键和另一个表的外键进行匹配。在表中，每个主键的值都是唯一的，这样做的目的是在不重复每个表中所有记录的情况下，将表之间的数据交叉捆绑在一起。


-- 7 种链接类型
-- * inner join   内链接：如果表中有至少一个匹配，则返回行(内链接，其他为外连接)，表1, 表2交集
--                产生的结果集中，是表1和表2的交集。
--                注释：如果不加任何修饰词，只写 JOIN，那么默认为 INNER JOIN（默认连接方式）
-- * left join    左链接：即使右表中没有匹配，也从左表返回所有的行
--                产生表1的完全集，而2表中匹配的则有值，没有匹配的则以null值取代。
--                左外连接，同 left outer join
-- * right join   有链接：即使左表中没有匹配，也从右表返回所有的行
--                产生表2的完全集，而1表中匹配的则有值，没有匹配的则以null值取代。
--                同 right outer join
-- * full join    外连接：只要其中一个表中存在匹配，则返回行
--                产生表1和表2的并集。但是需要注意的是，对于没有匹配的记录，则会以null做为值。
--                同 full outer join
-- * self join    将一个表连接到自身，就像该表是两个表一样。为了区分两个表，在 SQL 语句中需要至少重命名一个表。
-- * cross join   交叉连接，从两个或者多个连接表中返回记录集的笛卡尔积。就是第一个表的行数乘以第二个表的行数。


-- 连接的结果可以在逻辑上看作是由SELECT语句指定的列组成的新表。
-- 左连接与右连接的左右指的是以两张表中的哪一张为基准，它们都是外连接。
-- 外连接就好像是为非基准表添加了一行全为空值的万能行，用来与基准表中找不到匹配的行进行匹配。假设两个没有空值的表进行左连接，左表是基准表，左表的所有行都出现在结果中，右表则可能因为无法与基准表匹配而出现是空值的字段。


-- 示例
-- INNER JOIN 关键字在表中存在至少一个匹配时返回行。
-- 如果 "websites" 表中的行在 "access_log" 中没有匹配，则不会列出这些行。
SELECT websites.id, websites.name, access_log.count, access_log.date
FROM websites
INNER JOIN access_log
ON websites.id=access_log.site_id; -- 只有满足此链接条件的记录才会合并为一行


SELECT websites.id, websites.name, access_log.count, access_log.date
FROM websites
INNER JOIN access_log
ON websites.id=access_log.site_id
ORDER BY websites.id;


-- INSERT INTO `websites` (`name`, `url`, `alexa`, `country`) VALUES ('github', 'https://github.com', 30, 'USA');

-- left join
SELECT websites.name, access_log.count, access_log.date
FROM websites
LEFT JOIN access_log
ON websites.id=access_log.site_id
ORDER BY websites.name DESC;


-- 在 access_log 表添加一条数据，该数据在 websites 表没有对应的数据
INSERT INTO `access_log` (`aid`, `site_id`, `count`, `date`) VALUES ('10', '6', '111', '2016-03-09');

-- right join
SELECT websites.name, access_log.count, access_log.date
FROM websites
RIGHT JOIN access_log
ON websites.id=access_log.site_id
ORDER BY websites.name DESC;


-- full join (MySQL中不支持 FULL OUTER JOIN，你可以在 SQL Server 测试以下实例)
SELECT websites.name, access_log.count, access_log.date
FROM websites
FULL OUTER JOIN access_log
ON websites.id=access_log.site_id
ORDER BY access_log.count DESC;

-- full join 可改为如下（左右表各插入对方不存在的数据，便于对比）
SELECT a.id, a.name, b.count, b.date
FROM websites a LEFT JOIN access_log b
ON a.id = b.site_id

UNION

SELECT a.id, a.name, b.count, b.date
FROM websites a RIGHT JOIN access_log b
ON a.id = b.site_id;




-- 如果不希望选取表的所有记录，也可以加上 WHERE 子句
SELECT websites.id, websites.name, access_log.count, access_log.date
FROM websites
INNER JOIN access_log
ON websites.id=access_log.site_id



-- 得到的结果数
inner join <= min(left join, right join)
full join >= max(left join, right join)
当 inner join < min(left join, right join) 时， full join > max(left join, right join)


-- MySQL 暂不支持 FULL JOIN, 要实现完全外部链接需要额外处理。
-- MySQL实现完全外部链接，要使用 UNION 将一个左链接、和一个右链接去重合并
SELECT a.*,b.*
FROM 表1 a LEFT JOIN 表2 b
ON a.unit_NO = b.unit_NO

UNION

SELECT a.*,b.*
FROM 表1 a RIGHT JOIN 表2 b
ON a.unit_NO = b.unit_NO;



-- ON 和 WHERE 的区别

-- 连接表时，SQL 会根据连接条件生成一张新的临时表。
-- ON 就是连接条件，它决定临时表的生成（在生成临时表时使用）。
-- WHERE 是在临时表生成后使用，对临时表中的数据进行过滤，生成最终的结果集，这个时候已经没有 JOIN-ON 了。
-- SQL 先根据 ON 生成一张临时表，然后再根据 WHERE 对临时表进行筛选。

-- 因为 left join、right join、full join 的特殊性，不管 on 上的条件是否为真都会返回 left 或 right 表中的记录，full 则具有 left 和 right 的特性的并集。
-- 而 inner jion 没这个特殊性，则条件放在 on 中和 where 中，返回的结果集是相同的。
