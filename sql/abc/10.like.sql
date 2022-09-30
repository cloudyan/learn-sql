
-- LIKE 操作符
-- 用于在 WHERE 子句中搜索列中的指定模式。

-- 语法
-- SELECT column_name(s)
-- FROM table_name
-- WHERE column_name LIKE pattern;



-- 示例
-- 选取 name 以字母 "G" 开始的所有客户：
SELECT * FROM websites
WHERE name LIKE 'G%';

-- 提示："%" 符号用于在模式的前后定义通配符（默认字母）。

-- 选取 name 以字母 "k" 结尾的所有客户：
-- 选取 name 包含模式 "oo" 的所有客户：
-- 选取 name 不包含模式 "oo" 的所有客户：

SELECT * FROM websites
WHERE name LIKE '%k';

SELECT * FROM websites
WHERE name LIKE '%oo%';

SELECT * FROM websites
WHERE name NOT LIKE '%oo%';



-- '%a'    // 以a结尾的数据
-- 'a%'    // 以a开头的数据
-- '%a%'   // 含有a的数据
-- '_a_'   // 三位且中间字母是a的
-- '_a'    // 两位且结尾字母是a的
-- 'a_'    // 两位且开头字母是a的


-- 如果里面包括 _ % 怎么转义，查下，可以通过 escape

select * from username where 用户名 like '段_%'    -- 会查出来段煜 段鑫
select * from username where 用户名 like '段\_%' escape '\'   -- 通过 \转义,只能查出来 段_煜



-- 复杂过滤，模糊匹配 like 函数
-- % 代表任意多个字符（可以是 0 个），_ 代表一个字符，__ 代表两个字符。

