
-- WHERE 子句用于过滤记录
-- WHERE 子句用于提取那些满足指定条件的记录。


-- 语法
-- SELECT column_name,column_name
-- FROM table_name
-- WHERE column_name operator value;



-- 示例
SELECT * FROM websites WHERE country='CN';



-- ## 文本字段 vs. 数值字段
-- SQL 使用单引号来环绕文本值（大部分数据库系统也接受双引号）。
-- 在上个实例中 'CN' 文本字段使用了单引号。
-- 如果是数值字段，请不要使用引号。

-- 示例
SELECT * FROM websites WHERE id=1;




-- ## WHERE 子句中的运算符
-- =
-- <>       不等于。注释：在 SQL 的一些版本中，该操作符可被写成 !=
-- >
-- <
-- >=
-- <=
-- BETWEEN  在某个范围内
-- LIKE     搜索某种模式
-- IN       指定针对某个列的多个可能值


-- 示例

-- 逻辑运算 and or not
Select * from emp where sal > 2000 and sal < 3000;
Select * from emp where sal > 2000 or comm < 3000;
select * from emp where not sal > 1500;

-- 空置判断 is null
Select * from emp where comm is null;

Select * from emp where sal between 1500 and 3000;

Select * from emp where sal in (5000,3000,1500);

Select * from emp where ename like 'M%';
-- 查询 EMP 表中 Ename 列中有 M 的值，M 为要查询内容中的模糊信息。

--  % 表示多个字值，_ 下划线表示一个字符；
--  M% : 为能配符，正则表达式，表示的意思为模糊查询信息为 M 开头的。
--  %M% : 表示查询包含M的所有内容。
--  %M_ : 表示查询以M在倒数第二位的所有内容。


-- WHERE 子句并不一定带比较运算符，当不带运算符时，会执行一个隐式转换。当 0 时转化为 false，1 转化为 true。
SELECT studentNO FROM student WHERE 0;
-- 则会返回一个空集，因为每一行记录 WHERE 都返回 false。

SELECT  studentNO  FROM student WHERE 1;
-- 返回 student 表所有行中 studentNO 列的值。因为每一行记录 WHERE 都返回 true。
