# any、all、some 用法

- https://github.com/astak16/blog-mysql/issues/19

any 、 all 、 some 是子查询关键词之一，必须与一个比较操作符进行一起使用。

- any 和子查询返回的列中 任一值 比较为 true 则返回为 true 。
- all 和子查询返回的列中 所有值 比较为 true 则返回为 true 。
- some 的用法和 any 一样，在 != 的场景中，用 any 容易产生误解，用 some 更容易理解

```sql
create table t1 (id int, value int);
create table t2 (id int, value int);

insert into t1 values(1, 10), (2, 300), (3, 40), (4, 60), (5, 70), (6, 80);
insert into t2 values(1, 100), (2, 300), (3, 40), (4, 600), (5, 70), (6, 800);
```


## all 用法



## any 用法


## some 用法
