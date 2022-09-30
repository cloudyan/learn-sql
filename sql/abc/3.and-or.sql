
-- AND & OR 运算符
-- 用于基于一个以上的条件对记录进行过滤。

-- * 如果第一个条件和第二个条件都成立，则 AND 运算符显示一条记录。
-- * 如果第一个条件和第二个条件中只要有一个成立，则 OR 运算符显示一条记录。


-- 示例
SELECT * FROM websites
WHERE country='CN'
AND alexa > 50;


SELECT * FROM websites
WHERE country='USA'
OR country='CN';


SELECT * FROM websites
WHERE alexa > 15
AND (country='CN' OR country='USA');
