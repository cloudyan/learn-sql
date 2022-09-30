
-- 通配符
-- 可用于替代字符串中的任何其他字符。

-- 在 SQL 中，通配符与 SQL LIKE 操作符一起使用。
-- SQL 通配符用于搜索表中的数据。在 SQL 中，可使用以下通配符：

-- 通配符            描述
-- %                替代 0 个或多个字符
-- _                替代一个字符
-- [charlist]	      字符列中的任何单一字符
-- [^charlist] 或 [!charlist]   不在字符列中的任何单一字符


-- 示例
SELECT * FROM websites
WHERE url LIKE 'https%';


SELECT * FROM websites
WHERE url LIKE '%oo%';


SELECT * FROM websites
WHERE name LIKE 'G_o_le';


-- 使用 REGEXP 或 NOT REGEXP 运算符 (或 RLIKE 和 NOT RLIKE) 来操作正则表达式
-- 选取 name 以 "G"、"F" 或 "s" 开始的所有网站
SELECT * FROM websites
WHERE name REGEXP '^[GFs]';


-- 选取 name 以 A 到 H 字母开头的网站
-- 选取 name 不以 A 到 H 字母开头的网站


SELECT * FROM websites
WHERE name REGEXP '^[A-H]';

SELECT * FROM websites
WHERE name REGEXP '^[^A-H]';




-- 这个是普通字符，而不是通配符
select * from persons WHERE City LIKE '[b]eijing'

-- 通配符和正则不是一回事。
-- MySQL 中要完成 [^charlist] 或 [!charlist] 通配符的查询效果，需要通过正则表达式来完成。
-- select * from persons WHERE City REGEXP '[b]eijing'


-- 正则表达式

-- ^ 所匹配的字符串以后面的字符串开头
-- $ 所匹配的字符串以前面的字符串结尾
-- . 匹配任何字符（包括新行）
-- a* 匹配任意多个a（包括空串)
-- a+ 匹配任意多个a（不包括空串)
-- a? 匹配一个或零个 a
-- de|abc 匹配 de 或 abc
-- (abc)* 匹配任意多个abc（包括空串)
-- {1} 、{2,3} 这是一个更全面的方法
--    a  可以写成 a{1}
--    a* 可以写成 a{0,}
--    a+ 可以写成 a{1,}
--    a? 可以写成 a{0,1}
-- 其中的整型参数必须大于等于 0，小于等于 RE_DUP_MAX（默认是 255）。 如果有两个参数，第二个必须大于等于第一个。
-- [] 必须成对使用
--    [a-dX]  匹配 “a”、“b”、“c”、“d” 或 “X”。
--    [^a-dX] 匹配除 “a”、“b”、“c”、“d”、“X” 以外的任何字符。


-- 查找用户表中 Email 格式错误的用户记录
SELECT *
FROM users
WHERE email NOT REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+.[A-Z]{2,4}$'
