# 专项突破「SQL」

第 4 天 组合查询 & 指定选取

- [专项突破「SQL」](#专项突破sql)
  - [1965. 丢失信息的雇员](#1965-丢失信息的雇员)
  - [1795. 每个产品在不同商店的价格](#1795-每个产品在不同商店的价格)
  - [608. 树节点](#608-树节点)
  - [176. 第二高的薪水](#176-第二高的薪水)

## 1965. 丢失信息的雇员

```sql
select employee_id
from employees
where employee_id not in (
    select employee_id
    from salaries
)
union
select employee_id
from salaries
where employee_id not in (
    select employee_id
    from employees
)
order by employee_id
```

其他思路

雇员的姓名丢失了或者雇员的薪水信息丢失，都会导致employee_id 在 employees 和salaries 的并集表里面仅出现一次

1. union all 联合多表
2. group by 按照id分组
3. having 条件筛选
4. order by 升序排序

```sql
select
    employee_id
from
    (
    select employee_id from employees
    union all
    select employee_id from salaries
) as tmp
group by
    employee_id
having
    count(employee_id) = 1
order by
    employee_id;


select employee_id
from (
    (select employee_id from employees a where a.name is null)
    union
    (select employee_id from salaries b where b.salary is null)
) t
order by t.employee_id
```

`union` 和 `union all` 都可以起到关联结果集的作用，区别在于

- `union` 会自动去除关联的两个结果集中的重复数据
- `union all` 则不会主动去除两个结果集中的重复数据，会展示所有的数据

## 1795. 每个产品在不同商店的价格

```sql
-- 列转行
select
    product_id,
    store,
    price
from (
    select
        product_id,
        'store1' store,
        store1 price
    from Products
    union
    select
        product_id,
        'store2' store,
        store2 price
    from Products
    union
    select
        product_id,
        'store3' store,
        store3 price
    from Products
) tmp
where price is not null
```

其他思路

```sql
select
    product_id,
    'store1' as store,
    store1 as price
from Products
where store1 is not null
union all
select
    product_id,
    'store2' as store,
    store2 as price
from Products
where store2 is not null
union all
select
    product_id,
    'store3' as store,
    store3 as price
from Products
where store3 is not null;
```

MySQL 列转行、行转列

- 行转列
  - groupby+sumif
  - max/sum+case when+group by
- 列转行
  - union all
  - max+union+group by

1. 列转行(列变少)

    ```sql
    SELECT
        product_id,
        'store1' store,
        store1 price
    FROM products
    WHERE store1 IS NOT NULL
    UNION
    SELECT
        product_id,
        'store2' store,
        store2 price
    FROM products
    WHERE store2 IS NOT NULL
    UNION
    SELECT
        product_id,
        'store3' store,
        store3 price
    FROM products
    WHERE store3 IS NOT NULL;



    SELECT
        NAME,
        '语文' AS subject,
        MAX("语文") AS score
    FROM student2
    GROUP BY NAME
    UNION
    SELECT
        NAME,
        '数学' AS subject,
        MAX("数学") AS score
    FROM student2
    GROUP BY NAME
    UNION
    SELECT
        NAME,
        '英语' AS subject,
        MAX("英语") AS score
    FROM student2
    GROUP BY NAME
    ```

2. 行转列(列变多)

    ```sql
    SELECT
      product_id,
      SUM(IF(store = 'store1', price, NULL)) 'store1',
      SUM(IF(store = 'store2', price, NULL)) 'store2',
      SUM(IF(store = 'store3', price, NULL)) 'store3'
    FROM
      Products1
    GROUP BY product_id;



    select
        name,
        max(case when subject='语文' then score else 0 end) as "语文",
        max(case when subject='数学' then score else 0 end) as "数学",
        max(case when subject='英语' then score else 0 end) as "英语"
    from student1
    group by name
    ```


## 608. 树节点

```sql

```

## 176. 第二高的薪水

```sql

```
