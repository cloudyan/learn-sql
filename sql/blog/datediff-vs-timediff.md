# datediff 和 timediff

- https://github.com/astak16/blog-mysql/issues/2

## `datediff()` 计算两个日期之间的间隔差

语法: `datediff(date1, date2)`, `date1` 是起始时间, `date2` 是截止时间

```sql
select datediff('2021-12-31', '2022-01-02'); // -2
```

如果时间不存在，返回 `null`

```sql
select datediff('2021-12-32', '2022-01-02'); // null
```

只有时间的日期部分是参与计算的。

```sql
select datediff('2021-12-31 23:59:59', '2022-01-02 00:00:00'); // -2
```


## `timediff()` 计算两个时间之间间隔差

语法: `timediff(date-time1, date-time2)`, `date-time1` 是开始时间, `date-time2` 是结束时间。

```sql
select timediff('2022-01-01 00:00:00', '2022-01-02 00:00:00'); // -24:00:00
```

计算最大的时间差 `838:59:59` ， `35` 天不到， `35` 天是 `840` 小时。

```sql
select timediff('2021-11-10 00:00:00', '2022-01-02 00:00:00'); // -838:59:59
```

如果时间或者日期不存在，则返回 `null`

```sql
select timediff('2022-01-01 40:00:00', '2022-01-02 00:00:00'); // null
select timediff('2022-01-41 00:00:00', '2022-01-02 00:00:00'); // null
```

如果不传时间，有个有意思的现象：

- 如果不跨年永远返回 `00:00:00` ，
- 如果跨年返回
  - `date-time1` > `date-time2` 返回 `00:00:01`
  - `date-time1` < `date-time2` 返回 `-00:00:01`

```sql
select timediff('2022-01-31', '2022-01-02'); // 00:00:00
select timediff('2022-01-02', '2021-12-31'); // 00:00:01
select timediff('2021-12-31', '2022-01-02'); // -00:00:01
```
