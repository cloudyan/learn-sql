# MySQL 基本语法

- https://github.com/astak16/blog-mysql/issues/31

- [MySQL 基本语法](#mysql-基本语法)
  - [SQL 的概念](#sql-的概念)
  - [SQL 语言的分类](#sql-语言的分类)
  - [DDL 语法](#ddl-语法)
    - [操作数据库](#操作数据库)
    - [操作数据表](#操作数据表)
  - [DML 语句](#dml-语句)
  - [DQL 语句](#dql-语句)
  - [数据库约束](#数据库约束)
    - [主键](#主键)
      - [删除主键](#删除主键)
      - [主键自增](#主键自增)
      - [修改主键自增默认值](#修改主键自增默认值)
    - [唯一约束](#唯一约束)
    - [非空约束](#非空约束)
    - [默认设定](#默认设定)

## SQL 的概念

什么是 SQL：Structured Query Language 结构化查询语言

SQL 作用：通过 SQL 语句我们可以方便的操作数据库中的数据库、表、数据。SQL 是数据库管理系统都需要遵循的规范。不同的数据库生产厂商都支持 SQL 语句，但都有特有内容。

## SQL 语言的分类

- DDL 语句操作数据库以及表的 create，drop，alter 等
- DML 语句对表数据进行 insert，delete，update
- DQL 语句对表数据进行各种维度 select 查询
- DCL 数据控制语言，用来定义数据库的访问权限和安全级别，及创建用户。关键字 grant，revoke 等

MySQL 数据库的约束保证数据的正确性、有效性和完整性，包括：主键约束，唯一约束，非空约束

## DDL 语法

### 操作数据库

1. 显示所有数据库：

    ```sql
    show databases;
    ```

2. 显示数据库：

    ```sql
    show database <database_name>;
    ```

3. 显示创建的数据库信息：

    ```sql
    show create database <database_name>;
    ```

4. 创建数据库：

    ```sql
    create database <database_name>;
    ```

5. 判断数据库是否存在，并创建数据库：

    ```sql
    create database if not exists <database_name>;
    ```

6. 创建数据库并指定字符集：

    ```sql
    create database <database_name> character set <utf8>;
    ```

7. 使用数据：

    ```sql
    use <database_name>;
    ```

8. 查看使用数据库：

    ```sql
    select database();
    ```

9. 修改数据库字符集：

    ```sql
    alter database <database_name> default character set <utf8>;
    ```

10. 删除数据库：

    ```sql
    drop database <database_name>;
    ```

### 操作数据表



1. 查看所有表：

    ```sql
    show tables;
    ```

2. 创建表：

    ```sql
    create table <table_name> (<name1> <type1>, <name2> <type2>);
    ```

3. 查看表结构：

    ```sql
    desc <table_name>;
    ```

4. 查看建表语句：

    ```sql
    show create table <table_name>;
    ```

5. 创建一个表结构相同的表：

    ```sql
    create table <new_table_name> like <old_table_name>;
    ```

6. 删除表：

    ```sql
    drop table <table_name>;
    ```

7. 判断表存在并删除表：

    ```sql
    drop table if exists <table_name>;
    ```

8. 添加表列：

    ```sql
    alter table <table_name> add <col_name> <type>;
    ```

9. 修改表列类型：

    ```sql
    alter table <table_name> modify <col_name> <type>;
    ```

10. 修改列名：

    ```sql
    alter table <table_name> change <old_col_name> <new_col_name> <type>;
    ```

11. 删除列：

    ```sql
    alter table <table_name> drop <col_name>;
    ```

12. 修改表名：

    ```sql
    rename table <old_table_name> to <new_table_name>;
    ```

13. 修改表字符集：

    ```sql
    alter table <table_name> character set <utf8>;
    ```

## DML 语句

1. 插入全部数据：

    - 值与字段必须对应，个数相同，类型相同
    - 值的数据大小必须在字段的长度范围内
    - 除了数值类型外，其他的字段类型的值必须使用引号（单引号）
    - 如果要插入空值，可以不写字段，或者插入 null

    ```sql
    insert into <table_name>(name1, name2, ...) values(vaule1, value2, ...);
    -- 等价于
    insert into values(vaule1, value2, ...);
    ```

2. 蠕虫复制：

    - 如果只想复制 student 表中 user_name, age 字段数据到 student2 表中使用下面格式

        ```sql
        insert into student2(user_name, age) select user_name, age from student;
        ```

    ```sql
    insert into student2() select * from student;
    ```

3. 更新表记录

    - 不带条件修改数据：

        ```sql
        update <table_name> set <name>=<value>;
        ```

    - 带条件修改数据：

        ```sql
        update <table_name> set <name>=<value> where <name>=<value>;
        ```

4. 删除表记录

    - 不带条件删除数据：

        ```sql
        delete from <table_name>;
        ```

    - 带条件删除数据：

        ```sql
        delete from <table_name> where <name>=<value>;
        ```

    - 删除数据
      - delete 是将表中的数据一条一条删除
      - truncate 是将整个表摧毁，重新创建一个新的表，新的表结构和原来的表结构一模一样
      - 主键自增，delete auto_increment 不重置，truncate auto_increment 重置为 1

        ```sql
        truncate table <table_name>;
        ```

## DQL 语句

查询不会对数据库中的数据进行修改，只是一种显示数据的方式。

1. 查询值：

    ```sql
    select * from student;
    ```

2. 别名查询： (ps: as 可省略不写)

    ```sql
    select <old_col_name> as <new_col_name> from student;
    ```

3. 查询 name，age 结果不出现重复的 name：

    ```sql
    select distinct name, age from student;
    ```

4. 查询结果参与运算：(ps: 参与运算的必须是数值类型)

    ```sql
    select <col_name> + 固定值 from <table_name>;
    select <col1_name> + <col2_name> from <table_name>;
    ```

5. 查询 id 为 1、3、5 的数据：

    ```sql
    select * from <table_name> where id = 1 or id = 3 or id = 5;

    -- 等于

    select * from <table_name> where id in (1, 3, 5);
    ```

6. 查询 id 不为 1、3、5 的数据：

    ```sql
    select * from <table_name> where id not in (1, 3, 5);
    ```

7. 查询 id 在 3 到 7 之间的数据：(闭合区间)

    ```sql
    select * from <table_name> where id between 3 and 7;
    ```

8. 模糊查询:

   - `%`: 表示 0 个或者多个字符（任意字符）
   - `_`: 表示一个字符

    ```sql
    select * from <table_name> where <name> like <'通配符字符串'>;
    ```

9. 排序：

    - `asc`: 升序（默认）
    - `desc`: 降序

    ```sql
    select * from <table_name> order by age desc, id asc;
    ```

10. 聚合函数

    - count: 统计指定列记录数，记录为 NULL 的不统计。(ps: 用 * 可计算所有不为 NULL 的列)
    - sum: 计算指定列的数值和，如果不是数据类型，计算结果为 0
    - max: 计算指定列的最大值
    - min: 计算指定列的最小值
    - avg: 计算指定列的平均值，如果不是数值类型，那么计计算结果为 0

    ```sql
    select count(<col_name>) from <table_name>;
    ```

11. 分组查询： (ps: 一般两个 name 是一样的)

    ```sql
    select count(*),<name> from <table_name> group by <name>;
    ```

    分组查询后，在进行筛选

    > having 和 where 的区别
    >
    > having 是在分组后对数据进行过滤，where 是在分组前对数据进行过滤
    > having 后面可以使用聚合函数，where 后面不可以使用聚合函数

    ```sql
    select count(*),<name> from <table_name> group by <name> having count(*) > 2;
    ```

12. 限制: `limit` `offset` `length`

    - `offset`: 偏移量，可以认为是跳过的数量，默认 0
    - `length`: 需要显示几条数据。

    ```sql
    select * from <table_name> limit 3,6;
    ```

    顺序：

    ```sql
    select *|字段名 [as 别名]
    from 表名
    [where 子句]
    [group by 子句]
    [having 子句]
    [order by 子句]
    [limit 子句];
    ```

## 数据库约束

保证数据的正确性、有效性、完整性。

约束种类：

- primary key：主键
- unique：唯一
- not null：非空
- default：默认
- foreign key：外键

### 主键

作用：用来唯一标识一条记录，每个表应该有一个主键，并且每个表只能有一个主键。

通过不用业务字段作为主键，单独给每张表设计一个 id 字段，把 id 作为主键。主键是给数据库和程序员使用的，不是给最终客户使用的。主键有没有含义没有关系，只要不重复，非空就行。

```sql
create table <table_name> (
   id int primary key,
   name varchar(20)
);
```

#### 删除主键

```sql
alter table <table_name> drop primary key;
```

#### 主键自增

```sql
create table <table_name> (
    id int primary key auto_increment,
    name varchar(20)
);

-- 等价于

create table <table_name> (
    id int auto_increment,
    name varchar(20),
    primary key(name) USING BTREE
);
```

#### 修改主键自增默认值

```sql
alter table <table_name> auto_increment = 100;
```

### 唯一约束

不能插入相同名字，但是可以插入两个 null

索引类别：

- unique index：唯一索引
- normal index：普通索引

索引方式：

- BTREE
- HASH

```sql
create table <table_name> (
   id int,
   name varchar(20) unique index
);

-- 等价于

create table <table_name> (
    id int,
    name varchar(20),
    UNIQUE INDEX name(name) USING BTREE
);
```

### 非空约束

```sql
create table <table_name> (
   id int,
   name varchar(20) not null,
   gender char(2)
);
```

### 默认设定

```sql
create table <table_name> (
   id int,
   name varchar(20),
   location varchar(50) default "射手"
);
```
