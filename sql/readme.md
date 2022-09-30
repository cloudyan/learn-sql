# SQL

SQL (Structured Query Language:结构化查询语言) 是用于管理关系数据库管理系统（RDBMS）。 SQL 的范围包括数据插入、查询、更新和删除，数据库模式创建和修改，以及数据访问控制。

- https://www.runoob.com/sql/sql-tutorial.html

本教程 abc 演示数据库表在 abc/table 目录中

本教程使用到的 websites 表 SQL 文件：websites.sql。
本教程使用到的 access_log 表 SQL 文件：access_log.sql。
本教程使用到的 apps 表 SQL 文件：apps.sql。

## SQL 是什么？

- SQL 指结构化查询语言，全称是 Structured Query Language。
- SQL 让您可以访问和处理数据库，包括数据插入、查询、更新和删除。
- SQL 在1986年成为 ANSI（American National Standards Institute 美国国家标准化组织）的一项标准，在 1987 年成为国际标准化组织（ISO）标准。

## SQL 能做什么？

- SQL 面向数据库执行查询
- SQL 可从数据库取回数据
- SQL 可在数据库中插入新的记录
- SQL 可更新数据库中的数据
- SQL 可从数据库删除记录
- SQL 可创建新数据库
- SQL 可在数据库中创建新表
- SQL 可在数据库中创建存储过程
- SQL 可在数据库中创建视图
- SQL 可以设置表、存储过程和视图的权限

## SQL 是一种标准 - 但是...

虽然 SQL 是一门 ANSI（American National Standards Institute 美国国家标准化组织）标准的计算机语言，但是仍然存在着多种不同版本的 SQL 语言。

然而，为了与 ANSI 标准相兼容，它们必须以相似的方式共同地来支持一些主要的命令（比如 SELECT、UPDATE、DELETE、INSERT、WHERE 等等）。

## RDBMS

RDBMS 指关系型数据库管理系统，全称 Relational Database Management System。

RDBMS 是 SQL 的基础，同样也是所有现代数据库系统的基础，比如 MS SQL Server、IBM DB2、Oracle、MySQL 以及 Microsoft Access。

RDBMS 中的数据存储在被称为表的数据库对象中。

表是相关的数据项的集合，它由列和行组成。

## 请记住...

SQL 对大小写不敏感：SELECT 与 select 是相同的。

## 一些最重要的 SQL 命令

- SELECT - 从数据库中提取数据
- UPDATE - 更新数据库中的数据
- DELETE - 从数据库中删除数据
- INSERT INTO - 向数据库中插入新数据
- CREATE DATABASE - 创建新数据库
- ALTER DATABASE - 修改数据库
- CREATE TABLE - 创建新表
- ALTER TABLE - 变更（改变）数据库表
- DROP TABLE - 删除表
- CREATE INDEX - 创建索引（搜索键）
- DROP INDEX - 删除索引

### 数据库表

链接本地 Docker 里的 MySQL

```bash
docker ps
docker exec -it fb1743be9de0 /bin/bash
mysql -u root -p

mysql> show databases;
mysql> show tables;
mysql> use learn-sql;
mysql> set names utf8;
mysql> SELECT * FROM websites;
```

执行 `SET NAMES utf8` 的效果等同于同时设定如下：

```SQL
SET character_set_client='utf8';      -- 指客户端发送过来的语句的编码
SET character_set_connection='utf8';  -- 指mysqld收到客户端的语句后，要转换到的编码
SET character_set_results='utf8';     -- 指server执行语句后，返回给客户端的数据的编码

-- 测试
show variables like 'character%';
```

### 关于编码

MySQL 在 5.5.3 之后增加了这个 utf8mb4 的编码，mb4 就是 most bytes 4 的意思，专门用来兼容四字节的 unicode。

为了节省空间，一般情况下使用utf8也就够了。

utf8能够存下大部分中文汉字, 那为什么还要使用utf8mb4呢?

mysql支持的 utf8 编码最大字符长度为 3 字节，如果遇到 4 字节的宽字符就会插入异常了。三个字节的 UTF-8 最大能编码的 Unicode 字符是 0xffff;

为了获取更好的兼容性，应该总是使用 utf8mb4 而非 utf8。 对于 CHAR 类型数据，utf8mb4 会多消耗一些空间，根据 Mysql 官方建议，使用 VARCHAR 替代 CHAR。

### utf8升级utf8mb4具体步骤

将我们数据库默认字符集由utf8 更改为utf8mb4，对应的表默认字符集也更改为utf8mb4

```SQL
-- 修改数据库
ALTER DATABASE database_name CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- 修改表
ALTER TABLE table_name CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;  

-- 修改表字段
ALTER TABLE table_name CHANGE column_name column_name VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;  


-- 检查
show variables like 'character%';
SHOW VARIABLES WHERE Variable_name LIKE 'character\_set\_%' OR Variable_name LIKE 'collation%';
```

修改MySQL配置文件

```ini
default-character-set= utf8mb4
default-character-set= utf8mb4
character-set-client-handshake =FALSE
character-set-server= utf8mb4
collation-server= utf8mb4_unicode_ci 
init_connect='SET NAMES utf8mb4'
```


## SQL 学习

- 如何使用 SQL 在数据库中执行查询、获取数据、插入新的记录、删除记录以及更新记录。
- 如何通过 SQL 创建数据库、表、索引，以及如何撤销它们。
- SQL 中最重要的 Aggregate 函数。

SQL 是一种与数据库系统协同工作的标准语言，这些数据库系统包括 MS SQL Server、IBM DB2、Oracle、MySQL 和 MS Access 等等。

## SQL JOIN 类型

```SQL
SELECT websites.id, websites.name, access_log.count, access_log.date
FROM websites
INNER JOIN access_log
ON websites.id=access_log.site_id;
```

- INNER JOIN：如果表中有至少一个匹配，则返回行
- LEFT JOIN：即使右表中没有匹配，也从左表返回所有的行
- RIGHT JOIN：即使左表中没有匹配，也从右表返回所有的行
- FULL JOIN：只要其中一个表中存在匹配，则返回行
