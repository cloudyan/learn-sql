# 专项突破「SQL」

第 2 天 排序 & 修改

- [专项突破「SQL」](#专项突破sql)
  - [1873. 计算特殊奖金](#1873-计算特殊奖金)
  - [627. 变更性别](#627-变更性别)
  - [196. 删除重复的电子邮箱](#196-删除重复的电子邮箱)
    - [使用 `DELETE` 和 `WHERE` 子句](#使用-delete-和-where-子句)

## 1873. 计算特殊奖金

考察 `if` `like`

```sql
select
    employee_id,
    if (employee_id % 2 = 1 and name not like 'M%', salary, 0) bonus
from Employees
order by employee_id
```

其他解题思路，下面有一些基础知识

- IF判断
  - IF第一个参数写条件，第二个参数写条件成立返回的内容，第三个参数写条件不成立返回的内容
  - 语法结构: `IF(expr,v1,v2)`
- MOD取余
  - Mod(a,b) 在sql中的意思是 a / b 的余数
  - 基础用法：如果id需要是偶数或者奇数时就可以使用 mod。
  - mod(id,2)=1 是指id是奇数。
  - mod(id,2)=0 是指id是偶数。
- 使用 `CASE` 配合`WHEN`、`THEN`判断，`LEFT`和’=‘判断，`MOD`取余
  - `CASE`配合`WHEN`,`THEN`使用，`WHEN`后接条件，`THEN`后接符合条件返回的内容，
  - 有多个条件时使用需要用`ELSE`返回以上条件都不成立时返回的内容
  - 最后以`END`结尾

```sql
-- 方法 1
SELECT
    employee_id,
IF(MOD(employee_id,2)!=0 AND LEFT(name,1)!='M',salary,0) bonus
FROM Employees
ORDER BY employee_id

-- 方法 2
SELECT
    employee_id,
    CASE
        WHEN MOD(employee_id,2)!=0 AND LEFT(name,1)!='M' THEN salary
        -- WHEN MOD(employee_id,2)=0 OR LEFT(name,1)='M' THEN 0  -- 这里省略,直接用else
        ELSE 0
    END AS bonus
FROM Employees
ORDER BY employee_id

-- 计算雇员的id是奇数
employee_id&1
employee_id%2=1
mod(employee_id, 2)=1

-- 计算名字不是以'M'开头
name not like 'M%'
name regexp '^[^M]'
name not regexp('^M')
LEFT(name,1)!='M'
substr(name, 1, 1)<>'M'
substring(name, 1, 1)<>'M'
```

## 627. 变更性别

更新性别数据取反

```sql
-- 使用 if 语句
update salary
set sex = if(sex = 'm','f','m')
```

其他思路

```sql
-- 使用 case...when
update salary
set sex = (
    case sex
        when 'm' then 'f'
        else 'm'
        end
);

-- 使用 ascii 值 f: 102, m: 109
-- ascii(): 将字符转为 ASCII 码值；
update salary
set sex = char(ascii('m') + ascii('f') - ascii(sex));

-- ascii 值二进制异或运算
-- f: 1100110, m: 1101101, 11: 1011
-- char(): 将 ASCII 码值转为字符；
-- ^运算符：异或运算、即两值的二进制数在同位上相同则为0不同则为1；
-- 为什么用 11 呢？因为 f 与 m 异或得 1011, 逆运算相当于取反
update salary
set sex = char(11^ascii(sex))

-- 上面的异或应该这样用
update salary
set sex = char(ascii(sex) ^ ascii('m') ^ ascii('f'));
```

## 196. 删除重复的电子邮箱

```sql
delete from Person
where id not in(
    select * from (
        select min(id)
        from Person
        group by email
    ) t
)
```

注意：在MYSQL中，不能先Select一个表的记录，再按此条件Update和Delete同一个表的记录，否则会出错：`You can't specify target table 'xxx' for update in FROM clause.`

解决方法：使用嵌套Select——将Select得到的查询结果作为中间表，再Select一遍中间表作为结果集，即可规避错误。

其他思路

```sql
-- 笛卡尔积，非等值筛选
delete u
from Person u, Person v
where v.id < u.id and u.email = v.email
```

### 使用 `DELETE` 和 `WHERE` 子句

- https://leetcode.cn/problems/delete-duplicate-emails/solution/shan-chu-zhong-fu-de-dian-zi-you-xiang-by-leetcode/

解题思路

1. 筛选重复邮箱的记录
2. 以上数据排除最小 ID的记录
3. 删除这些记录

我们可以使用以下代码，将此表与它自身在电子邮箱列中连接起来。

```sql
SELECT p1.*
FROM Person p1,
    Person p2
WHERE
    p1.Email = p2.Email
;
```

然后我们需要找到其他记录中具有相同电子邮件地址的更大 ID。所以我们可以像这样给 WHERE 子句添加一个新的条件。

```sql
SELECT p1.*
FROM Person p1,
    Person p2
WHERE
    p1.Email = p2.Email AND p1.Id > p2.Id
;
```

因为我们已经得到了要删除的记录，所以我们最终可以将该语句更改为 DELETE。

```sql
DELETE p1 FROM Person p1,
    Person p2
WHERE
    p1.Email = p2.Email AND p1.Id > p2.Id
```

深入分析：https://leetcode.cn/problems/delete-duplicate-emails/solution/dui-guan-fang-ti-jie-zhong-delete-he-de-jie-shi-by/

当然这个sql是很ok的，简洁清晰，且用了自连接的方式。

有慢查询优化经验的同学会清楚，在实际生产中，面对千万上亿级别的数据，连接的效率往往最高，因为用到索引的概率较高。

两条解释：

1. 解释 `DELETE p1` 就表示从p1表中删除满足WHERE条件的记录
   1. `DELETE` 官方文档：https://dev.mysql.com/doc/refman/8.0/en/delete.html
   2. 用法：`DELETE t1 FROM t1 LEFT JOIN t2 ON t1.id=t2.id WHERE t2.id IS NULL;`
2. 解释 `p1.Id > p2.Id`
   1. 从驱动表（左表）取出N条记录；
   2. 拿着这N条记录，依次到被驱动表（右表）查找满足WHERE条件的记录；
