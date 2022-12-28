# date_add 和 adddate

- https://github.com/astak16/blog-mysql/issues/5

## date_add 对指定的日期加上间隔时间，得到一个新的日期

语法: `date_add(date, interval num type)`

第一个参数是 `date` 或者 `date-time` 都行，
第二个参数是有三部分组成的: `interval` 关键字，间隔时间，间隔单位。


 `type` 取值 | 描述
----------- | ---
microsecond | 毫秒
second      | 秒
minute      | 分钟
hour        | 小时
day         | 天
week        | 周
month       | 月
quarter     | 季
year        | 年

```sql
select date_add('2022-01-03', interval 1 day); // 2022-01-04
```

如果日期是个无效的日期，返回值是 null

```sql
select date_add('2022-01-33', interval 1 day); // null
```

如果第一个参数只有日期，没有时间，也可以写间隔时间的

```sql
select date_add('2022-01-03', inteval 1 minute); // 2022-01-03 00:01:00
```

间隔时间也可以是负数

```sql
select date_add('2022-01-03', interval -1 day); // 2022-01-02
```

可以接受复合时间，不过时间要用引号，能用的复合时间只有这五种

- year_month
- day_hour
- hour_minute
- minute_second
- second_microsecond

其他的复合时间会报错，有两个例外

- day_minute 结果和 hour_minute 一样。
- minute_microsecond 结果和 second_microsecond 一样

```sql
select date_add('2022-01-03', interval '1-1' day_hour); // 2022-01-04 01:00:00
-----
select date_add('2022-01-03', interval '1-1' day_minute); // 2022-01-03 01:01:00
select date_add('2022-01-03', interval '1-1' hour_minute); // 2022-01-03 01:01:00
```

复合时间的 - 号要写在最前面

```sql
select date_add('2022-01-03', '-1-1', day_hour); // 2022-01-01 23:00:00
```

## adddate 和 date_add 一样

语法: `adddate(date, interval num type)` 或者 `adddate(date, num)`

第二种语法是一种简写，只是在天的基础上增加间隔时间。

```sql
select adddate('2022-01-03', 1); // 2022-01-04
```
