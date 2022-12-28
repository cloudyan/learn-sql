# 专项突破「SQL」

第 3 天 字符串处理函数/正则

- [专项突破「SQL」](#专项突破sql)
  - [1667. 修复表中的名字](#1667-修复表中的名字)
  - [1484. 按日期分组销售产品](#1484-按日期分组销售产品)
  - [1527. 患某种疾病的患者](#1527-患某种疾病的患者)

## 1667. 修复表中的名字

查询数据，并修正显示的 name 命名格式，改为仅首字母大写

```sql
select
    user_id,
    concat(upper(left(name,1)), lower(substr(name,2))) as name
from
    Users
order by
    user_id
```

- CONCAT(str1, str2, ...) 合并字符串函数
- LOWER(str) 将字符串中字母转换成小写的函数
- UPPER(str) 转换成大写的函数
- LEFT(str, n) 获得字符串左边n个字符
- RIGHT(str, n) 获得右边n个字符
- LENGTH(str) 获得字符串长度
- substr    截取函数
- SUBSTRING(str, begin, end) 截取字符串，end 不写默认为空。
  - SUBSTRING(name, 2) 从第二个截取到末尾，注意并不是下标，就是第二个。

其他思路

```sql
-- MID/SUBSTR
SELECT
    user_id,
    CONCAT(UPPER(MID(name, 1, 1)), LOWER(MID(name, 2))) AS name
FROM Users
ORDER BY user_id;
```

## 1484. 按日期分组销售产品

查找每个日期、销售的不同产品的数量及其名称

```sql
select
    -- date_format(sell_date / 1000, '%Y-%m-%d') sell_date,
    sell_date,
    -- count(product) num_sold,
    count(distinct product) as num_sold,
    group_concat(distinct product order by product separator ',') as products
from Activities
group by sell_date
order by sell_date
```

## 1527. 患某种疾病的患者

```sql
select
    patient_id,
    patient_name,
    conditions
from Patients
where
    -- conditions like '%DIAB1%'
    conditions like 'DIAB1%' or conditions like '% DIAB1%'
```

其他思路

```sql
-- MySQL 正则表达式的转义字符要转义两次，直接使用 \b 会报错
SELECT patient_id, patient_name, conditions
FROM Patients
WHERE conditions REGEXP '\\bDIAB1.*\\b';

SELECT patient_id, patient_name, conditions
FROM Patients
WHERE conditions REGEXP '\\bDIAB1'
-- 或
-- WHERE conditions REGEXP '^DIAB1| DIAB1';
-- where conditions regexp '^DIAB1| +DIAB1';
-- where conditions regexp('(?<![a-zA-Z])DIAB1'); -- 负后发断言
```

更多正则参见：

- https://learnku.com/mysql/wikis/36463
- https://dev.mysql.com/doc/refman/8.0/en/regexp.html
