
# 专项突破「SQL」

第 1 天 **选择**

- [专项突破「SQL」](#专项突破sql)
  - [595. 大的国家](#595-大的国家)
  - [1757. 可回收且低脂的产品](#1757-可回收且低脂的产品)
  - [584. 寻找用户推荐人](#584-寻找用户推荐人)
    - [关于 NULL](#关于-null)
    - [三值逻辑](#三值逻辑)
    - [为什么是`IS NULL`, 而不是 `= NULL`?](#为什么是is-null-而不是--null)
    - [如何理解IS NULL?是两个单词？IS空格NULL?](#如何理解is-null是两个单词is空格null)
    - [三值逻辑运算](#三值逻辑运算)
    - [重点：【三值逻辑运算】](#重点三值逻辑运算)
  - [183. 从不订购的客户](#183-从不订购的客户)

## 595. 大的国家

- <https://leetcode.cn/problems/big-countries>

```sql
# Write your MySQL query statement below
# 方法一：使用 WHERE 子句和 OR
select t.name, t.population, t.area from world t
    where t.area >= 3000000 or t.population >= 25000000

# 方法二：使用 WHERE 子句和 UNION
# 使用 or 会使索引会失效，在数据量较大的时候查找效率较低，通常建议使用 union 代替 or
select t.name, t.population, t.area from world t
    where t.area >= 3000000
    union
select t.name, t.population, t.area from world t
    where t.population >= 25000000
```

对于单列来说，用or是没有任何问题的，但是or涉及到多个列的时候，每次select只能选取一个index，如果选择了area，population就需要进行table-scan，即全部扫描一遍，但是使用union就可以解决这个问题，分别使用area和population上面的index进行查询。

但是这样还会有另一个问题就是，UNION会对结果进行排序去重，可能会降低一些performance(这有可能是方法一比方法二快的原因），所以最佳的选择应该是两种方法都进行尝试比较。

另外运算符大致速度差异是

1. `=` 快于 `> 或 <` 快于 `!=`
2. `and` 快于 `or`

## 1757. 可回收且低脂的产品

```sql
select product_id
from products
where low_fats = 'Y' and recyclable = 'Y'
```

## 584. 寻找用户推荐人

考点：null值无法与确定的值作比较，用 is NULL 或者 is not NULL 判断

```sql
select name
from customer
where referee_id != 2 or referee_id is null;

-- 带null的列无法与值做比较，需要先把null转为0
select name
from customer
where
    ifnull(referee_id,0) != 2;

-- 可以避开NULL的 一种算法，运算速度还可以
select name
from customer
where id not in
    (select id
    from customer
    where referee_id = 2)

-- 使用 <=>
select name
from customer
where not referee_Id <=> 2;

-- union会去除重复的行,当用户name相同但id不同的时候,用union会丢失结果.
-- 换成union all即可

```

MySQL 运算符

> `is` 专门也只能用来判断是否为 `NULL`
> `=` 或 `!=` 用来判断非NULL以外的所有数据类型使用（基本数据类型）
> `<=>` 是前两者合起来，既能判断 `null` 又能判断基本数据类型

- 在MySQL中`!=` 和 `<>` 的功能一致，在sql92规范中建议是：`!=`，新的规范中建议为: `<>`
- `<=>` 只用于MySQL数据库，这是 `NULL` 安全的相等运算符
  - 当两个操作数都可能包含NULL并且您需要在两列之间获得一致的比较结果时，这会很有用。

参考：https://stackoverflow.com/questions/21927117/what-is-this-operator-in-mysql

```sql
-- You can think of them as specialisations of MySQL's <=>:
'a' IS NULL     ==> 'a' <=> NULL
'a' IS NOT NULL ==> NOT('a' <=> NULL)
```

### 关于 NULL

MySQL中null代表位置值，任何值（包括null）都不与它相等，任何值（包括null）也都不与它相等。

怎么会这样子? 一切只因为 null 是表示一种“未知”的类型。也就是说，用常规的比较操作符(normal conditional operators)来将 null 与其他值比较是没有意义的。 Null 也不等于 Null(近似理解: 未知的值不能等于未知的值，两者间的关系也是未知，否则数学和逻辑上就乱套了)。

- 参考链接：https://blog.csdn.net/weixin_40000131/article/details/113911795

### 三值逻辑

- https://leetcode.cn/problems/find-customer-referee/solution/san-by-xiang-shu-k-7ywp/

`NULL`有两种，“未知”`unknown`和“`inapplicable`”不适用。

- 不知道戴眼镜的人眼睛是什么颜色，就是未知。只要不摘掉眼睛，就不知道，但是这个人眼睛肯定有颜色的。
- 不知道冰箱的眼睛是什么颜色。这就是不适用，这个属性不适用于冰箱。冰箱是没有眼睛的。

现在 DBMS 都将这两种类型`NULL`归为了一类，并采用三值逻辑。

### 为什么是`IS NULL`, 而不是 `= NULL`?

很奇怪，是不是？小学的时候学的=就是表示相等关系。但是，对`NULL`使用谓词得到的结果是 `unknown`。

> Tip: SQL 的保留字中，很多都被归类为谓词一类，例如`>`,`<>`, `=` 等比较谓词，以及`BETWEEN`, `LIKE`, `IN`, `IS NULL`等。总结，谓词是一种特殊的函数，返回值是真值。
> (前面提到的诶个谓词，返回值都是`true`, `false`, `unknown`, SQL是三值逻辑，所以有三种真值）

因为查询结果只会包含 `WHERE` 子句里的判断结果为 `true` 的行！不包含判断结果为`false`和`unknown`的行。且不仅是等号，对`NULL`使用其他比较谓词（比如`> NULL`），结果也都是`unknown`。

重点理解：

- `NULL`不是值，所以不能对其使用谓词，如果使用谓词，结果是`unknown`。
- 可以认为它只是一个没有值的标记，而比较谓词只适用于比较值。
- 因此对非值的`NULL`使用比较谓词是没有意义的

### 如何理解IS NULL?是两个单词？IS空格NULL?

"NULL值" 和 "列的值为NULL"这个说法是错误的。NULL不属于关系型数据库中的某种类型。

我们为什么会误认为NULL是一个值？

可能因为混淆了别的语言，在一些语言中NULL是一个常量。还有个重要原因是IS NULL是两个单词，所以我以前也把IS当作谓词，比如IS-A,所以误认为NULL是一个值。特别是SQL里有IS TRUE, IS FALSE。在讲解SQL标准的书里提醒人那么样，我们应该把IS NULL看作一个谓词，如果可以IS_NULL或许更合适。

### 三值逻辑运算

unknown小写，是第三个真值。与作为NULL的一种UNKNOWN(未知)是不同的东西。小写是明确的布尔类型的真值，后者大写的既不是值也不是变量。为了对比不同：看x=x的情况。

```sql
unknown = unknown -> true
UNKNOWN = UNKNOWN -> unknown
```

### 重点：【三值逻辑运算】

```sql
NOT unknown => unknown

true          OR unknown => true
unknown OR unknown => unknown
false         OR unknown => unknown

true          AND unknown => unknown
unknown AND unknown => unknown
false         AND unknown => false

-- 记忆：优先级：
AND:    false > unknown > true
OR:     true > unknown > false
```

实战

方法一：使用 `NOT IN`, 注意不能先查出name，否则可能name有重名，id不同，导致数据查询不全。我一开始就犯了这个错误。应该查询出id，去避免这个问题。同样，用`UNION`也会自动去重，要用的话用`UNION ALL`.

```sql
SELECT name
FROM customer C
WHERE C.id NOT IN
    (SELECT C1.id
    FROM customer C1
    WHERE C1.referee_id = 2);
```

> 注意code格式规范：
> 所有关键字大写，关键字右边对齐，子句缩进。
> 即使很短的代码，也要严格要求自己，好的代码不仅自己能懂，也要让一个新人能很容易读懂。
> 切不可随意潦草，我自己要慢慢修炼！

方法二：使用`exists`，先查出referee_id的数据，再用`exists`,注意语法，`exists`需要关联表。

```sql
SELECT C.name
FROM customer C
WHERE NOT EXISTS
    (SELECT C1.name
    FROM  customer C1
    WHERE  C1.id = C.id
    AND  C1.referee_id = 2);
```

方法三：直接增加第二个判断，用 `OR`

```sql
SELECT C.name
FROM customer C
WHERE
    C.referee_id <> 2 OR C.referee_id IS NULL;
```

方法四：用 `UNION ALL`

```sql
SELECT name
FROM customer
WHERE referee_id <> 2
UNION ALL
SELECT name
FROM customer
WHERE referee_id IS NULL
```

为什么有时`NOT IN` 会查不到值，以及推导公式。
如果用`WHERE id NOT IN (1, 2, NULL)`, 是不能查出数据的。

推导【经典】：

```sql
=> WHERE NOT id IN (1, 2, NULL) // NOT和IN等价改写NOT IN
=> WHERE NOT（（id = 1）OR（id = 2）OR（id= NULL））// 用OR等价改写谓词IN
=> WHERE NOT (id = 1) AND NOT (id = 2) AND NOT( id = NULL) // 德摩根定律等价改写
=> WHERE (id <> 1) AND (id <> 2) AND (id <> NULL)// 用<>改写NOT 和 =
=> WHERE (id <> 1) AND (id <> 2) AND unknown // 对NULL使用<>,结果为unknown
=> WHERE false 或者 unknown // AND运算包含unknown, 结果不可能为true
```

结论：如果`NOT IN`的子查询用到的表里被选择的列中存在`NULL`，则SQL整体的查询结果永远是空！

为了解决烦人的NULL，最好在表里添加`NOT NULL`约束来尽力排除`NULL`

## 183. 从不订购的客户

```sql
-- `left join` + 判断 `is null`
select Name customers
from
    (select c.Id,c.Name,o.Id oid
    from customers c
    left join orders o
    on c.Id = o.CustomerId) t
where t.oid is null

-- SQL 不区分大小写, TODO
select name customers
from customers c
left join orders o
on c.id = o.customerid
where customerid is null

-- 其他思路, 子查询
-- not in
SELECT Name 'Customers'
FROM Customers
WHERE Id NOT IN (
    SELECT CustomerId
    FROM Orders
)
-- not exists
select Name Customers
from Customers c
where not exists (
    select 1
    from Orders o
    where o.CustomerId=c.Id
)
```
