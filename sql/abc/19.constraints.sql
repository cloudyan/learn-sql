
-- constraints 约束用于规定表中的数据规则。

-- 如果存在违反约束的数据行为，行为会被约束终止。
-- 约束可以在创建表时规定（通过 CREATE TABLE 语句），或者在表创建之后规定（通过 ALTER TABLE 语句）。


-- 在 SQL 中有如下约束：
-- * NOT NULL       指示某列不能存储 NULL 值。
-- * UNIQUE         保证某列的每行必须有唯一的值。
-- * PRIMARY KEY    NOT NULL 和 UNIQUE 的结合。
--                  确保某列（或两个列多个列的结合）有唯一标识，有助于更容易更快速地找到表中的一个特定的记录。
-- * FOREIGN KEY    保证一个表中的数据匹配另一个表中的值的参照完整性。
-- * CHECK          保证列中的值符合指定的条件。
-- * DEFAULT        规定没有给列赋值时的默认值。



-- 1. NOT NULL
-- NOT NULL 约束强制列不接受 NULL 值。
-- NOT NULL 约束强制字段始终包含值。这意味着，如果不向字段添加值，就无法插入新记录或者更新记录。
-- 示例
CREATE TABLE Persons (
  ID int NOT NULL,
  LastName varchar(255) NOT NULL,
  FirstName varchar(255) NOT NULL,
  Age int
);

-- 已创建的表，添加 NOT NULL
ALTER TABLE Persons
MODIFY Age int NOT NULL;

-- 删除 NOT NULL
ALTER TABLE Persons
MODIFY Age int NULL;



-- 2. UNIQUE
-- UNIQUE 约束唯一标识数据库表中的每条记录。
-- UNIQUE 和 PRIMARY KEY 约束均为列或列集合提供了唯一性的保证。
-- PRIMARY KEY 约束拥有自动定义的 UNIQUE 约束。
-- 请注意，每个表可以有多个 UNIQUE 约束，但是每个表只能有一个 PRIMARY KEY 约束。

-- UNIQUE 示例
-- MySQL
CREATE TABLE Persons (
  P_Id int NOT NULL,
  LastName varchar(255) NOT NULL,
  FirstName varchar(255),
  Address varchar(255),
  City varchar(255),
  UNIQUE (P_Id)
);
-- SQL Server / Oracle / MS Access：
CREATE TABLE Persons (
  P_Id int NOT NULL UNIQUE,
  LastName varchar(255) NOT NULL,
  FirstName varchar(255),
  Address varchar(255),
  City varchar(255)
);

-- 定义多个列的 UNIQUE 约束
-- MySQL / SQL Server / Oracle / MS Access
CREATE TABLE Persons (
  P_Id int NOT NULL,
  LastName varchar(255) NOT NULL,
  FirstName varchar(255),
  Address varchar(255),
  City varchar(255),
  CONSTRAINT uc_PersonID UNIQUE (P_Id, LastName)
);


-- 已创建的表
-- MySQL / SQL Server / Oracle / MS Access
ALTER TABLE Persons
ADD UNIQUE (P_Id)
-- MySQL / SQL Server / Oracle / MS Access (多个)
ALTER TABLE Persons
ADD CONSTRAINT uc_PersonID UNIQUE (P_Id,LastName)

-- 撤销 UNIQUE 约束
-- MySQL
ALTER TABLE Persons
DROP INDEX uc_PersonID
-- SQL Server / Oracle / MS Access
ALTER TABLE Persons
DROP CONSTRAINT uc_PersonID







-- 3. PRIMARY KEY 约束唯一标识数据库表中的每条记录。

-- * 主键必须包含唯一的值。
-- * 主键列不能包含 NULL 值。
-- * 每个表都应该有一个主键，并且每个表只能有一个主键。



-- 示例
-- MySQL
CREATE TABLE Persons (
  P_Id int NOT NULL,
  LastName varchar(255) NOT NULL,
  FirstName varchar(255),
  Address varchar(255),
  City varchar(255),
  PRIMARY KEY (P_Id)
);
CREATE TABLE Persons (
  P_Id int NOT NULL PRIMARY KEY,
  LastName varchar(255) NOT NULL,
  FirstName varchar(255),
  Address varchar(255),
  City varchar(255)
);

-- 定义多个列的 PRIMARY KEY 约束
CREATE TABLE Persons (
  P_Id int NOT NULL,
  LastName varchar(255) NOT NULL,
  FirstName varchar(255),
  Address varchar(255),
  City varchar(255),
  CONSTRAINT pk_PersonID PRIMARY KEY (P_Id, LastName)
);
-- 注释：在上面的实例中，只有一个主键 PRIMARY KEY（pk_PersonID）。然而，pk_PersonID 的值是由两个列（P_Id 和 LastName）组成的。


-- 已创建的表
ALTER TABLE Persons
ADD PRIMARY KEY (P_Id)

-- 定义多个列的 PRIMARY KEY 约束
ALTER TABLE Persons
ADD CONSTRAINT pk_PersonID PRIMARY KEY (P_Id,LastName)
-- 注释：如果您使用 ALTER TABLE 语句添加主键，必须把主键列声明为不包含 NULL 值（在表首次创建时）。


-- 说明
-- 撤销PRIMARY KEY约束时，不论约束条件为一列还是多列，对于MySQL，撤销都是
ALTER TABLE Persons
DROP PRIMARY KEY
-- 由于PRIMARY KEY唯一性，MYSQL处理办法简单。

ALTER TABLE Persons
DROP CONSTRAINT pk_PersonID




-- 4. FOREIGN KEY 约束
-- 一个表中的 FOREIGN KEY 指向另一个表中的 UNIQUE KEY(唯一约束的键)。

-- FOREIGN KEY 约束用于预防破坏表之间连接的行为。
-- FOREIGN KEY 约束也能防止非法数据插入外键列，因为它必须是它指向的那个表中的值之一。
-- 注意，在创建外键约束时，必须先创建外键约束所依赖的表，并且该列为该表的主键


-- 使用类似 PRIMARY KEY
-- 示例
CREATE TABLE Orders (
  O_Id int NOT NULL,
  OrderNo int NOT NULL,
  P_Id int,
  PRIMARY KEY (O_Id),
  FOREIGN KEY (P_Id) REFERENCES Persons(P_Id)
);

CREATE TABLE Orders (
  O_Id int NOT NULL,
  OrderNo int NOT NULL,
  P_Id int,
  PRIMARY KEY (O_Id),
  CONSTRAINT fk_PerOrders FOREIGN KEY (P_Id) REFERENCES Persons(P_Id)
);

ALTER TABLE Orders
ADD FOREIGN KEY (P_Id)
REFERENCES Persons(P_Id)

ALTER TABLE Orders
ADD CONSTRAINT fk_PerOrders
FOREIGN KEY (P_Id)
REFERENCES Persons(P_Id)

ALTER TABLE Orders
DROP FOREIGN KEY fk_PerOrders

ALTER TABLE Orders
DROP CONSTRAINT fk_PerOrders


-- MySql 中如何删除未命名的外键？
-- 删除外键需要知道外键的名称，如果创建时没有设置名称则会自动生成一个，你需要获取改外键的信息。





-- 其他

-- PRIMARY KEY 约束的实例
CREATE TABLE Persons (
  Id_P int NOT NULL,
  LastName varchar(255) NOT NULL,
  FirstName varchar(255),
  Address varchar(255),
  City varchar(255),
  PRIMARY KEY (Id_P) -- PRIMARY KEY 约束
);
--

CREATE TABLE Persons (
  Id_P int NOT NULL PRIMARY KEY,
  -- PRIMARY KEY 约束
  LastName varchar(255) NOT NULL,
  FirstName varchar(255),
  Address varchar(255),
  City varchar(255)
);


-- foreign key 用法
create table if not exists per(
  id bigint auto_increment comment '主键',
  name varchar(20) not null comment '人员姓名',
  work_id bigint not null comment '工作id',
  create_time date default '2021-04-02',
  primary key(id),
  foreign key(work_id) references work(id)
);
--

create table if not exists work(
  id bigint auto_increment comment '主键',
  name varchar(20) not null comment '工作名称',
  create_time date default '2021-04-02',
  primary key(id)
);





-- 5. CHECK 约束
-- 用于限制列中的值的范围。
-- 如果对单个列定义 CHECK 约束，那么该列只允许特定的值。
-- 如果对一个表定义 CHECK 约束，那么此约束会基于行中其他列的值在特定的列中对值进行限制。


CREATE TABLE Persons (
  P_Id int NOT NULL,
  LastName varchar(255) NOT NULL,
  FirstName varchar(255),
  Address varchar(255),
  City varchar(255),
  CHECK (P_Id > 0)
);

CREATE TABLE Persons (
  P_Id int NOT NULL,
  LastName varchar(255) NOT NULL,
  FirstName varchar(255),
  Address varchar(255),
  City varchar(255),
  CONSTRAINT chk_Person CHECK (
    P_Id > 0
    AND City = 'Sandnes'
  )
);







-- 6. DEFAULT 约束
-- 用于向列中插入默认值。
-- 如果没有规定其他的值，那么会将默认值添加到所有的新记录。

-- 示例
CREATE TABLE Persons (
  P_Id int NOT NULL,
  LastName varchar(255) NOT NULL,
  FirstName varchar(255),
  Address varchar(255),
  City varchar(255) DEFAULT 'Sandnes'
);

ALTER TABLE Persons
ALTER City SET DEFAULT 'SANDNES'

ALTER TABLE Persons
ALTER City DROP DEFAULT
