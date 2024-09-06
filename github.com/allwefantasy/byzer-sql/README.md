# Byzer-SQL 快速入门文档

## 数据加载/Load

Byzer-Lang 的设计理念是 `Everything is a table`，在 Byzer-Lang 中所有的文件都可以被抽象成表的概念。

多样的数据源例如：数据库，数据仓库，数据湖甚至是 Rest API 都可以被 Byzer-lang 抽象成二维表的方式读入并进行后续的分析处理，而读入数据源的这一重要过程主要通过 `load` 句式来达成。

### 1. 基本语法

先来看一个最简单的 load 语句：

```sql
set abc='''
{ "x": 100, "y": 200, "z": 200 ,"dataType":"A group"}
{ "x": 120, "y": 100, "z": 260 ,"dataType":"B group"}
''';
load jsonStr.`abc` as table1;
```

在这个示例中，设置了一个变量，变量名称是 `abc`， 通过 `jsonStr` 数据源，使用 `load` 语句将这段文本注册成一张视图（表）。


**我们来解析一下该句中的语法含义和需要注意的关键点：**

```sql
load jsonStr.`abc` as table1;
```

- 第一个关键点是 `load`，代表读入数据源的行为
- 第二个关键点是 `jsonStr` ，这里代表的是数据源或者格式名称，该句表示这里加载的是一个 json 的字符串，
- 第三个关键点是 `.` 和 `abc` ， 通常反引号内是个路径，比如:

```
csv.`/tmp/csvfile`
```

- 第四个关键点：为了方便引用加载的结果表，我们需要使用 `as` 句式，将结果存为一张新表，这里我们取名为 `table1`。`table1` 可以被后续的 `select` 句式引用，例如：

```sql
set abc='''
{ "x": 100, "y": 200, "z": 200 ,"dataType":"A group"}
{ "x": 120, "y": 100, "z": 260 ,"dataType":"B group"}
''';
load jsonStr.`abc` as table1;
select * from table1 as output;
```

### 2. 如何获取可用数据源

1）既然 `load` 句式是用来获取数据源的，用户如何知道当前实例中支持的数据源（例如上述的 jsonStr） 有哪些呢？

可以通过如下指令来查看当前实例支持的数据源（内置或者通过插件安装的）：

```sql
!show datasources;
```

输出如下：

```
rate
streamJDBC
custom
model
jsonStr
image
jdbc
parquet
libsvm
xml
model2
hive
carbondata
delta
es
streamParquet
webConsole
redis
kafka9
script
binaryFile
hbase
binlog
mongo
console
Everything
solr
parquet
csv
jsonStr
csvStr
json
text
orc
kafka
kafka8
kafka9
crawlersql
image
script
hive
xml
mlsqlAPI
mlsqlConf
```

2）用户如果想知道某个数据源是否支持该怎么做？

可以通过 **模糊匹配** 来定位某个数据源是否支持。

例如，我们想要知道是否支持读取 `csvStr`：

```sql
!show datasources;
!lastCommand named datasources;
select * from datasources where name like "%csv%" as output;
```

3）当用户想知道数据源对应的一些参数时该如何查看？

可以通过如下命令查看，例如这里我们想要知道 `csv` 支持的相关参数：

```sql
!show datasources/params/csv;
```

### 3. Load 和 Connect 句式的配合使用

`load` 支持 `connect` 语句的引用。

比如：

```sql
connect jdbc where
url="jdbc:mysql://127.0.0.1:3306/wow?characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&tinyInt1isBit=false"
and driver="com.mysql.jdbc.Driver"
and user="xxxxx"
and password="xxxxx"
as db_1;

load jdbc.`db_1.<TABLE_NAME>` as output;
```

在这个例子中，我们通过`connect` 语句去连接了一个 jdbc 数据源，再通过 Load 语句读取该数据源中对应的库表。

此处`connect` 语句并不是真的去连接数据库，而仅仅是方便后续记在同一数据源，避免在 `load/save` 句式中反复填写相同的参数。

对于示例中的 `connect` 语句， jdbc + db_1 为唯一标记。 当系统遇到下面 `load` 语句中jdbc.`db_1.<TABLE_NAME>` 时，他会通过 jdbc 以及 db_1 找到所有的配置参数， 如 driver， user, url, 等等，然后自动附带上到 `load` 语句中。



### 4. 直接查询模式(DirectQuery)

有部分数据源支持直接查询模式，目前官方内置了 JDBC 数据源直接查询模式的支持。

示例：

```sql
connect jdbc where
 url="jdbc:mysql://127.0.0.1:3306/wow?characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&tinyInt1isBit=false"
 and driver="com.mysql.jdbc.Driver"
 and user="xxxx"
 and password="xxxx"
 as mysql_instance;

load jdbc.`mysql_instance.<TABLE_NAME>` where directQuery='''
select * from <TABLE_NAME> limit 10
''' as newtable;

select * from newtable as output;
```

在 JDBC 数据源的 `where/options` 参数里，用户可以配置一个 `directQuery` 参数。
该参数可以写数据源原生支持的语法。比如对于 ClickHouse 可能就是一段合乎 ClickHouse 用法的 SQL, 而对于 MySQL 则可能是合乎 MySQL 语法的 SQL。

Byzer-lang 会将 `directQuery` 的查询下推到底层引擎，并且将执行的结果作为注册成新的表。 
在上面的例子中，新表名称为 `newtable`。 这个表可以被后续的 Byzer-lang 代码引用。


## 数据转换/Select

`select` 句式是 Byzer-lang 中处理数据最重要的方式之一。

> Byzer-lang 中的 `select` 句式除了最后 `as 表名` 以外，完全兼容 Spark SQL。
> 一般来讲，可以结合使用 Spark SQL 中的函数和算子以及 Byzer 的一些特定语法命令或 UDF 来完成数据转换的功能

### 1. 基本语法

最简单的一个 `select` 语句：

```sql
select 1 as col1 
as table1;
```

结果为：col1: 1。

从上面代码可以看到，Byzer-lang 中的 `select` 语法和传统 SQL `select` 语法唯一的差别就是后面多了一个 `as tableName`。
这也是为了方便后续对该 SQL 处理的结果进行引用引入的微小改良。

**正常的 SQL 语句：**

```sql
SELECT
b.* 
FROM
 table_a as a
 LEFT JOIN table_b as b 
 ON a.id = b.id 
WHERE
 a.study_id in( '12345678' )
 AND a.status <> 3 
 AND b.use_status = 0；
```

**Byzer 语法：**

```sql
SELECT
b.* 
FROM
 table_a as a
 LEFT JOIN table_b as b 
 ON a.id = b.id 
WHERE
 a.study_id in( '12345678' )
 AND a.status <> 3 
 AND b.use_status = 0 as new_table;
 
 select * from new_table as traindata;
```

比如，对于 `new_table`, 用户可以在新的 `select` 语句中进行引用：

### 2. Select 句式中的模板功能

实际在书写 `select` 语句可能会非常冗长。Byzer-lang 提供了两种方法帮助大家简化代码。

对于如下代码示例：

```sql
select "" as features, 1 as label as mockData;

select 
SUM( case when features is null or features='' then 1 else 0 end ) as features,
SUM( case when label is null or label='' then 1 else 0 end ) as label,
1 as a from mockData as output;
```

如果字段特别多，而且都要做类似的事情，可能要写非常多的 SUM 语句。

用户可以通过如下语法进行改进：

```sql
select "" as features, 1 as label as mockData;

select 
#set($colums=["features","label"])
#foreach( $column in $colums )
    SUM( case when `$column` is null or `$column`='' then 1 else 0 end ) as $column,
#end
 1 as a from mockData as output;
```

`#set` 设置了一个模板变量 `$columns`, 然后使用 `#foreach` 对该变量进行循环，里面的 SUM 本质上成了一个模板。
系统在执行该 `select` 语句的时候，会自动根据这些指令展开成类似前面手写的代码。

Byzer-lang 还提供了一个更加易用的模板方案：

```sql
 set sum_tpl = '''
SUM( case when `{0}` is null or `{0}`='' then 1 else 0 end ) as {0}
''';

select ${template.get("sum_tpl","label")},
${template.get("sum_tpl","label")}
from mockData as output;
```

通过变量声明设置一个模板，该模板通过名为 `sum_tpl` 变量持有，并且支持位置参数。接着，在 `select` 句式中使用 `${template.get}` 对模板进行渲染了。
第一个参数是模板名，后面的参数则是模板的参数。

Byzer SQL 脚本也有作用域的概念。作用域是指变量的生命周期。

## 变量设置/Set

Byzer-lang 支持变量的设置和复用。

### 1. 基础应用

```sql
set hello="world";
```

此时用户运行后不会有任何输出结果。

如果希望看到此变量，可以通过 `select` 语句进行查看。

示例：

```sql

set hello="world";

select "hello ${hello}" as title 
as output;
```

得到结果如下：


|title|
|----|
|hello world|

通常， 变量可以用于任何语句的任何部分。甚至可以是结果输出表名，比如下面的例子


```sql

set hello="world";

select "hello William" as title 
as `${hello}`;

select * from world as output;
```

结果如下：

| title         |
| ------------- |
| hello William |

在上面代码中，并没有显式的定义 `world` 表，但用户依然可以在 `select` 语句中使用 `world` 表。

> 表名需要使用反引号将其括起来，避免语法解析错误



#### 生命周期

值得一提的是，`set` 语法当前的生命周期是 `request` 级别的，也就是每次请求有效。

通常在 Byzer-lang 中，生命周期分成三个部分：

1. request （当前执行请求有效/ Notebook 中实现为 Cell 等级）
2. session  （当前会话周期有效 /Notebook 的用户等级）
3. application （全局应用有效，暂不支持）


`request` 级别表示什么含义呢？ 如果你先执行

```sql
set hello="world";
```

然后再单独执行

```sql
select "hello William" as title 
as `${hello}`;

select * from world as output;
```

系统会提示报错：

```
Illegal repetition near index 17
((?i)as)[\s|\n]+`${hello}`
                 ^
java.util.regex.PatternSyntaxException: Illegal repetition near index 17
((?i)as)[\s|\n]+`${hello}`
                 ^
java.util.regex.Pattern.error(Pattern.java:1955)
java.util.regex.Pattern.closure(Pattern.java:3157)
java.util.regex.Pattern.sequence(Pattern.java:2134)
java.util.regex.Pattern.expr(Pattern.java:1996)
java.util.regex.Pattern.compile(Pattern.java:1696)
java.util.regex.Pattern.<init>(Pattern.java:1351)
java.util.regex.Pattern.compile(Pattern.java:1028)
java.lang.String.replaceAll(String.java:2223)
tech.mlsql.dsl.adaptor.SelectAdaptor.analyze(SelectAdaptor.scala:49)
```

系统找不到 ${hello} 这个变量,然后原样输出，最后导致语法解析错误。

如果你希望变量可以跨 cell ( Notebook中 )使用，可以通过如下方式来设置。

```sql
set hello="abc" where scope="session";
```

变量默认生命周期是 `request`。 也就是当前脚本或者当前 cell 中有效。 


### 2. 变量类型

Byzer-lang 的变量被分为五种类型：

1. `text`
2. `conf`
3. `shell`
4. `sql`
5. `defaultParam`

- 第一种 `text`， 前面演示的代码大部分都是这种变量类型。

示例：

```sql
set hello="world";
```



- 第二种 `conf` 表示这是一个配置选项，通常用于配置系统的行为，比如：

```sql
set spark.sql.shuffle.partitions=200 where type="conf";
```

该变量表示将底层 Spark 引擎的 shuffle 默认分区数设置为 200。 



- 第三种是 `shell`，也就是 `set` 后的 key 最后是由 shell 执行生成的。 

> 不推荐使用该方式， 安全风险较大

典型的例子比如：

```sql
set date=`date` where type="shell";
select "${date}" as dt as output;
```
注意：这里需要使用反引号括住该命令。

输出结果为：

|dt|
|----|
|`Mon Aug 19 10:28:10 CST 2019`|



- 第四种是 `sql` 类型，这意味着 `set` 后的 key 最后是由 sql 引擎执行生成的。下面的例子可以看出其特点和用法：

```sql
set date=`select date_sub(CAST(current_timestamp() as DATE), 1) as dt` 
where type="sql";

select "${date}" as dt as output;
```

注意这里也需要使用反引号括住命令。 最后结果输出为：

|dt|
|----|
|2019-08-18|



- 最后一种是 `defaultParam`。

示例：

```sql
set hello="foo";
set hello="bar";

select "${hello}" as name as output;
```

结果输出是：

| name |
| ---- |
| bar  |

上述代码中后面的`"bar"` 会覆盖前面的 `"foo"`。而 Byzer-lang 引入了 `defaultParam` 类型的变量来达到一种效果：如果变量已经设置了，新变量声明就失效，如果变量没有被设置过，则生效。 

```sql
set hello="foo";
set hello="bar" where type="defaultParam";

select "${hello}" as name as output;
```

最后输出结果是：

| name |
| ---- |
| foo  |

如果前面没有设置过 `hello="foo"`,


```sql
set hello="bar" where type="defaultParam";

select "${hello}" as name as output;
```

则输出结果为：

| name |
| ---- |
| bar  |



### 3. 编译时和运行时变量

Byzer-lang 有非常完善的权限体系，可以轻松控制任何数据源到列级别的访问权限，而且创新性的提出了预处理时权限，
也就是通过静态分析 Byzer-lang 脚本从而完成表级别权限的校验（列级别依然需要运行时完成）。

但是预处理期间，权限最大的挑战在于 `set` 变量的解析，比如：

```sql
select "foo" as foo as foo_table;
set hello=`select foo from foo_table` where type="sql";
select "${hello}" as name as output; 
```

在没有执行第一个句子，那么第二条 `set` 语句在预处理期间执行就会报错，因为此时并没有叫 `foo_table` 的表。

为了解决这个问题，Byzer-lang 引入了 `compile/runtime` 两个模式。如果用户希望在 `set` 语句预处理阶段就可以 evaluate 值，那么添加该参数即可。

```sql
set hello=`select 1 as foo ` where type="sql" and mode="compile";
```

如果希望 `set` 变量，只在运行时才需要执行，则设置为 `runtime`:

```sql
set hello=`select 1 as foo ` where type="sql" and mode="runtime";
```

此时，Byzer-lang 在预处理阶段不会进行该变量的创建。


### 4. 内置变量

Byzer-lang 提供了一些内置变量，看下面的代码：

```sql
set jack='''
 hello today is:${date.toString("yyyyMMdd")}
''';
```

`date` 是内置的，你可以用他实现丰富的日期处理。

1. 临时表，比如 `select 1 as number as tempTable;` 这个 tempTable 就是一个临时表。默认是用户级别的作用域。
2. set 语法变量，比如 `set a=1;` 这个 a 就是一个变量。变量可以手动设置作用域。比如 `set a=1 where scope="session";` 这个 a 就是一个 用户级别的 作用域的变量。默认是 request 级别，也就是单次和引擎的交互中有效。
3. 分支条件语句里. 比如 `if ":number > 10" ;` 这种可以引用外部的 set 变量，但是只在分支条件语句里有效。
4. connect 语句中的连接名称。他是 applicaiton 级别的。所有用户都可以使用。

### 作用域

Byzer SQL 中的作用域分成三种：

1. request 级别，也就是单次和引擎的交互中有效。
2. session/user 级别，也就是用户级别的作用域。比如用户登录后，可以在 session 级别的作用域里设置变量，这个变量在用户的整个会话中有效。
3. application 级别，也就是应用级别的作用域。比如在应用启动后，可以在 application 级别的作用域里设置变量，这个变量在应用的整个生命周期中有效。


#### request 级别作用域

前面我们看到， 目前只有 `set` 一个变量，这个变量的作用域默认就是 request 级别的。也就是说，这个变量只在当前的请求中有效。

你可以通过 `set a=1 where scope="request";` 来显式的设置一个变量的作用域为 request 级别。为了能够跨 Cell/Notebook 有效，你可以在 `set` 语句中加入 `where scope="session"` 来改成 session/user 级别的作用域。

#### session/user 级别作用域

这个作用域最主要就是为了方便在 Byzer Notebook 中调试。比如你在一个 Notebook 中设置了一个变量，你希望在另外一个 Notebook 中也能够使用这个变量，那么你就可以在 `set` 语句中加入 `where scope="session"` 来改成 session/user 级别的作用域。

或者你在一个 Notebook 得到一个表，在另外一个 Notebook 中继续使用这个表，方便调试和使用。

> 注意： Byzer Notebook 和 Jupyter 不一样， Byzer Notebook 的不同的 Notebook 默认是共享一个 Byzer 引擎实例的，所以同一个用户的不同 Notebook 之间是可以共享变量的。

#### 常见问题

1. 假设我写了两个脚本，A，B ，现在我同时提交了 A，B 到引擎，此时会导致 A,B 之间的变量互相冲突，导致结果异常。

分析： 因为表名是 session/user 级别作用域的。只要是以同一个账户提交的，那么不同脚本之间是可以互相看到对方变量的。这个时候因为执行顺序问题，会发生变量互相覆盖的问题，导致结果异常。为了解决这个问题，可以在提交的时候，同时设置两个HTTP请求参数：

1. sessionPerUser=true
2. sessionPerRequest=true

第一个是默认的，就是每个用户是绑定一个session的，第二个设置为true，表示在 session/user 隔离的基础上，每次请求，都复制一个session出来，不同副本之间就毫无关系了，这样就可以避免不同脚本之间的变量互相冲突的问题。

2. 如果我写了很多脚本，放到调度系统里去，脚本之间互相有依赖，是不是可以利用同一个用户的 session/user 级别作用域来实现数据表之间的呢？

答案是不推荐。如果你开启了  `sessionPerRequest=true`, 那么这种依赖就会失效。 如果你没有开启，复杂的依赖里，会有脚本并行执行的可能性，导致前面我们提到的异常。并且还会产生一个比较大的问题，在 A 脚本中设置了一个变量，在B 脚本中没有重置，会导致这个变量影响到了 B 脚本。

所以，如果你的脚本是有依赖的，那么你可以保证脚本的独立性，脚本和脚本之间通过持久化存储来完成衔接。

## 数据保存/Save

`save` 句式类似传统 SQL 中的 `insert` 语法。但同 `load` 语法一样，Byzer-lang 是要面向各种数据源的，譬如各种对象存储，亦或是各种类型的库表，不仅仅局限在数仓。`insert` 语法无法很好的满足该诉求，
同时 `insert` 语法过于繁琐，所以 Byzer-lang 提供了新的 `save` 句式专门应对数据存储。

### 1. 基本语法

```sql
set rawData='''
  {"jack":1,"jack2":2}
  {"jack":2,"jack2":3}
''';
load jsonStr.`rawData` as table1;

save overwrite table1 as json.`/tmp/jack`;
```

最后一句就是 `save` 句式了。 

上面的 `save` 语句的含义是： 将 `table1` 进行覆盖保存，存储的格式为 Json 格式，保存位置是 `/tmp/jack`。 

通常，`save` 语句里的数据源或者格式和 `load` 是保持一致的，配置参数也几乎保持一致。但是否能同时应用这两种句式由数据源的特性决定，典型的比如 `jsonStr` 就只支持 `load`,而不支持 `save`。

`save` 语句也支持 `where/options` 条件子句。比如，如果用户希望保存时控制文件数量，那么可以使用 `where/options` 子句中的 `fileNum` 参数进行控制：

```sql
save overwrite table1 as json.`/tmp/jack` where fileNum="10";
```

### 2. Save 保存方式

`save` 支持四种存储方式：

1. overwrite：覆盖写

```sql
	save overwrite table1 as json.`/tmp/jack` where fileNum="10";
```

表示覆盖 `/tmp/jack` 路径下的表 table1，并以 json 格式保存.

2. append：追加写

```sql
	save append table1 as json.`/tmp/jack` where fileNum="10";
```

表示追加内容至 `/tmp/jack` 路径下的表 table1，并以 json 格式保存.

3. ignore：文件存在跳过不写

```sql
	save ignore table1 as json.`/tmp/jack` where fileNum="10";
```

4. errorIfExists：文件存在则报错

```sql
	save errorIfExists table1 as json.`/tmp/jack` where fileNum="10";
```



### 3. Save Connect 支持
`save` 也支持 `connect` 语句的引用。

比如：

```sql

select 1 as a as tmp_article_table;

connect jdbc where
url="jdbc:mysql://127.0.0.1:3306/wow?characterEncoding=utf8&zeroDateTimeBehavior=convertToNull&tinyInt1isBit=false"
and driver="com.mysql.jdbc.Driver"
and user="xxxxx"
and password="xxxxx"
as db_1;

save append tmp_article_table as jdbc.`db_1.crawler_table`;
```

在这个例子中，我们通过`connect` 语句去连接了一个 jdbc 数据源，再通过 save 语句将处理好的库表存储进该数据源中。

`connect` 语句并不是真的去连接数据库，而仅仅是方便后续记在同一数据源，避免在 `load/save` 句式中反复填写相同的参数。

对于示例中的 `connect` 语句， jdbc + db_1 为唯一标记。 当系统遇到下面 `save` 语句中 jdbc.`db_1.crawler_table` 时，他会通过 jdbc 以及 db_1 找到所有的配置参数， 如 driver， user, url, 等等，然后自动附带上到 `save` 语句中。


## 分支/If|Else

传统 SQL 是不支持分支语句的，因此如果想要在 SQL 中添加判断或过滤条件，往往需要多条 SQL 拼接才能完成需求。但是在 Byzer-lang 中配合宏命令做到了分支语句的支持，允许我们正常使用 if/else，强化拓展了语言自身的能力。



### 1. 基本用法

一段最简单的分支语法示例：

```sql
set a = "wow,jack";
!if ''' split(:a,",")[0] == "jack" ''';
   select 1 as a as b;
!else;
   select 2 as a as b;
!fi;

select * from b as output;
```

结果为：a：2。

`!if/!else`  在 Byzer-lang 中并非关键字,都是 [宏函数](/byzer-lang/zh-cn/grammar/macro.md)。

在上面的示例中：

1. 先通过变量申明得到一个变量 `a`。 然后在宏函数 `!if` 只接受一个位置参数，因为是一个宏函数，调用的最后必须加上分号 `;` 。

2. `!if` 后面接一个文本参数，该文本的内容是一个表达式。在表达式里可以使用 Spark SQL 支持所有函数。比如上面的例子是 `split` 函数。表达式也支持使用 register 句式注册的函数，本文后面部分会有使用示例。 

3. 在条件表达式中使用 `:` 来标识一个变量。变量来源于 [set 句式](/byzer-lang/zh-cn/grammar/set.md)。比如示例中表达式的 `:a` 变量对应的值为 "wow,jack" 。如果表达式： 

```sql
split(:a,",")[0] == "jack" 
```

返回 true ， 那么会执行：

```sql
select 1 as a as b;
```

这条 `select` 语句会通过 `as 语法` 生成一个临时表 `b`, 该表只有一个 `a` 字段，并且值为 `1`.

如果返回 false， 那么会执行：

```sql
select 2 as a as b;
```

这条 `select` 语句会通过 `as 语法` 生成一个临时表 `b`, 该表只有一个 `a` 字段，并且值为 `2`.

示例代码最后通过下列语句对 `b` 表进行输出：

```sql
select * from b as output;
```

从上面的例子可以看到，Byzer-lang 的条件判断语句具有以下特色：

1. 语法设计遵循 SQL 的一些原则。比如采用 `and/or` 替代 `&&/||`。使用 `select` 语句做变量赋值
2. 兼容 Spark SQL 函数
3. 支持用户自定义函数（参看文章后半部分）



### 2. 分支语句嵌套

Byzer-lang 也支持分支语句的嵌套。

示例：

```sql
set a="jack,2";

!if ''' select split(:a,",")[0] as :name, split(:a,",")[1] as :num;
:name == "jack" and :num == 3
''';
    select 0 as a as b;
!elif ''' select split(:a,",")[1] as :num; :num==2 ''';
    !if ''' 2==1 ''';
       select 1.1 as a as b;
    !else;
       select 1.2 as a as b;
    !fi;
!else;
  select 2 as a as b;
!fi;


select * from b as output;
```

在上述代码中，`!if` 表达式里变得复杂了：

```sql
!if ''' select split(:a,",")[0] as :name, split(:a,",")[1] as :num;
:name == "jack" and :num == 3
''';
```

和第一个例子不同之处在于多了一个 `select` 句法结构， 该结构如下：


```sql
select split(:a,",")[0] as :name, split(:a,",")[1] as :num;
```

在上面的示例代码中，通过 `select` 生成了 `:name` 和 `:num` 两个变量。

接着，用户可以使用 `;` 对提交表达式的不同语句进行分割。 第二条语句是对新产生的两个变量进行条件表达式判定：

```sql
:name == "jack" and :num == 3
```

Byzer-lang 会在执行时对变量 `:num` 自动进行类型转换，转换为数字。

### 3. 表达式中变量的作用域

在 `!if/!elif` 里申明的变量有效范围是整个 `!if/!fi` 区间。子 `!if/!else` 语句可以使用上层 `!if/!else` 语句的变量。 


对于以下示例：

```sql
set name = "jack";
!if '''select :name as :newname ;:name == "jack" ''';
    !if ''' :newname == "jack" ''';
       !println '''====1''';
    !else;
       !println '''====2 ''';
    !fi;
!else;
   !println '''=====3''';
!fi;
```

该语句输出为 `====1`，子 `!if` 语句中使用了上层 `!if` 语句中的 `select` 产生的 `:newname` 变量。

同样的，用户也可以在分支语句内部的代码中引用条件表达式里的变量，比如：

```sql
set name = "jack";
!if '''select concat(:name,"dj") as :newname ;:name == "jack" ''';
    !if ''' :newname == "jackdj" ''';
       !println '''====${newname}''';
       select "${newname}" as a as b;
    !else;
       !println '''====2 ''';
    !fi;
!else;
   !println '''=====3''';
!fi;

select * from b as output;
```

在该示例中，用户在 `select`, `!println` 语句里通过 `${}` 引用了 `!if` 或者 `!elif` 里声明的变量。


### 4. 结合 defaultParam 变量

条件分支语句可以与强大的变量声明语法结合。

这里主要介绍和 [defaultParam 变量](/byzer-lang/zh-cn/grammar/set.md) 的结合。

比如：

```sql
set a = "wow,jack" where type="defaultParam";
!if ''' split(:a,",")[0] == "jack" ''';
   select 1 as a as b;
!else;
   select 2 as a as b;
!fi;

select * from b as output;

```

此时代码的输出会是 `2`。 但是如果在前面加一句：

```sql
set a = "jack,";
set a = "wow,jack" where type="defaultParam";
!if ''' split(:a,",")[0] == "jack" ''';
   select 1 as a as b;
!else;
   select 2 as a as b;
!fi;

select * from b as output;
```

这个时候会输出 `1`。 这意味着，用户可以通过执行脚本时，动态在脚本最前面添加一些变量就可以覆盖掉脚本原有的变量，从而实现更加动态的控制脚本的执行流程。


### 5. 在条件表达式中使用自定义函数

前面提到, Byzer-lang 支持使用自定义 UDF 函数，经过注册的 UDF 函数，也可以用在条件分支语句中的条件表达式中。

示例：

```sql
register ScriptUDF.`` as title where 
lang="scala"
and code='''def apply()={
   "jack"
}'''
and udfType="udf";

!if ''' title() == "jack" ''';
   select 1 as a as b;
!else;
   select 2 as a as b;
!fi;

select * from b as output;
```

### 6. !if/!else 子语句中表的生命周期问题以及解决办法

在 Byzer-lang 中，表的生命周期是 session 级别的。这意味着在一个 session 中， 表都是会被自动注册在系统中的，除非被删除或者被重新定义了亦或是 session 失效。
session 级别的生命周期主要配套 notebook 使用，方便用户进行调试。 然而，这在使用 `!if/!else` 的时候则会有困惑发生。

来看下面这个例子：

```sql
!if ''' 2==1 ''';
   select 1 as a as b;
!else;   
!fi;

select * from b as output;
```

当第一次运行的时候，因为 `2==1` 会返回 false， 所以会执行 `!else` 后面的空分支。 接着我们再引用 `b` 进行查询，系统会报错，因为没有表 `b`。 

于是我们修改下条件，将 `2==1` 修改为 `1==1` 时，此时，系统执行了 `select 1 as a as b;`, 产生了 `b` 表， 整个脚本正常运行。 

再次，我们将 `1==1` 再次修改为 `2==1` 此时，系统输出了和条件 `1==1` 时一样的结果。这显然不符合逻辑。

原因在于，系统记住了上次运行的 `b`,所以虽然当前没有执行 `select` 语句，但是依然有输出，从而造成错误。

解决办法有两个：

1. 请求参数设置 `sessionPerRequest`,这样每次请求表的生命周期都是 `request`。
2. 在脚本里备注 `set __table_name_cache__ = "false";` 让系统不要记住表名，逻辑上是每次执行完脚本后，系统自动清理产生运行产生的临时表。

其中第二个办法的使用示例如下：

```sql
set __table_name_cache__ = "false";
!if ''' 2==1 ''';
   select 1 as a as b;
!else;   
!fi;

select * from b as output;
```

## 注册函数，模型/Register

Register 句式在 Byzer-lang 中主要可以完成三类工作：

1. 动态注册 Java/Scala 写的 UDF/UDAF 函数
2. 将内置或者 Python 模型注册成 UDF 函数
3. 在流式计算中，注册 watermark/window

### 1. 注册 SQL 函数

在 SQL 中，最强大的莫过于函数了。Byzer-lang 支持动态创建 UDF/UDAF 函数。

示例代码：

```sql
register ScriptUDF.`` as plusFun where
lang="scala"
and udfType="udf"
and code='''
def apply(a:Double,b:Double)={
   a + b
}
''';
```

上面代码的含义是，使用 ET ScriptUDF 注册一个函数叫 `plusFun`，这个函数使用 Scala 语言，函数的类型是 UDF,对应的实现代码在 code 参数里。

在 Byzer-lang 中， 执行完上面代码后，用户可以直接在 `select` 语句中使用 `plusFun` 函数：

```sql
-- 创建数据表
 set data='''
 {"a":1}
 {"a":2}
 {"a":3}
 {"a":4}
 ''';
 load jsonStr.`data` as dataTable;

 -- 在 SQL 中使用 echofun
 select plusFun(a,2) as res from dataTable as output;
```

其中：

1. lang 支持 java/scala
2. udfType 支持 udf/udaf 

#### 1）通过变量持有代码片段

代码片段也可以使用变量持有，然后在 ScriptUDF 中引用：

```sql
set plusFun='''
    def apply(a:Double,b:Double)={
       a + b
    }
''';

-- 将脚本加载成表，在 byzer 中一切皆可成表 
-- 这样处理起来就十分方便
load script.`plusFun` as scriptTable;
-- 将 `apply` 注册成名为 `plusFun` 的 UDF 函数 
register ScriptUDF.`scriptTable` as plusFun;
-- 创建数据表
set data='''
  {"a":1}
  {"a":2}
  {"a":3}
  {"a":4}
''';
load jsonStr.`data` as dataTable;
-- 在 SQL 中使用 echofun
select plusFun(a,2) as res from dataTable as output;
```

一个变量可以持有多个方法，然后分别进行注册：

```sql
set plusFun='''
class A {

    def apply(a:Double,b:Double)={
       a + b
    }

    def hello(a:String)={
       "hello: "+a
    }
}
''';


load script.`plusFun` as scriptTable;
register ScriptUDF.`scriptTable` as plusFun where methodName="apply" and className="A";
register ScriptUDF.`scriptTable` as helloFun options
methodName="hello"  and className="A";

-- 在 SQL 中使用 echofun
select plusFun(1,2) as plus, helloFun("jack") as jack as output;
```

#### 2）Scala UDAF 示例

```sql
set plusFun='''
import org.apache.spark.sql.expressions.{MutableAggregationBuffer, UserDefinedAggregateFunction}
import org.apache.spark.sql.types._
import org.apache.spark.sql.Row
class SumAggregation extends UserDefinedAggregateFunction with Serializable{
    def inputSchema: StructType = new StructType().add("a", LongType)
    def bufferSchema: StructType =  new StructType().add("total", LongType)
    def dataType: DataType = LongType
    def deterministic: Boolean = true
    def initialize(buffer: MutableAggregationBuffer): Unit = {
      buffer.update(0, 0l)
    }
    def update(buffer: MutableAggregationBuffer, input: Row): Unit = {
      val sum   = buffer.getLong(0)
      val newitem = input.getLong(0)
      buffer.update(0, sum + newitem)
    }
    def merge(buffer1: MutableAggregationBuffer, buffer2: Row): Unit = {
      buffer1.update(0, buffer1.getLong(0) + buffer2.getLong(0))
    }
    def evaluate(buffer: Row): Any = {
      buffer.getLong(0)
    }
}
''';


--加载脚本
load script.`plusFun` as scriptTable;
--注册为UDF函数 名称为plusFun
register ScriptUDF.`scriptTable` as plusFun options
className="SumAggregation"
and udfType="udaf"
;

set data='''
{"a":1}
{"a":1}
{"a":1}
{"a":1}
''';
load jsonStr.`data` as dataTable;

-- 使用plusFun
select a,plusFun(a) as res from dataTable group by a as output;
```

#### 3）Java 语言 UDF 示例


```sql
set echoFun='''
import java.util.HashMap;
import java.util.Map;
public class UDF {
  public Map<String, Integer[]> apply(String s) {
    Map<String, Integer[]> m = new HashMap<>();
    Integer[] arr = {1};
    m.put(s, arr);
    return m;
  }
}
''';

load script.`echoFun` as scriptTable;

register ScriptUDF.`scriptTable` as funx
options lang="java"
;

-- 创建数据表
set data='''
{"a":"a"}
''';
load jsonStr.`data` as dataTable;

select funx(a) as res from dataTable as output;
```

由于 Java 语言的特殊性，有如下几点注意事项：

> 1. 传递的代码必须是一个 Java 类，并且默认系统会寻找 `UDF.apply()` 做为运行的 udf，如果需要特殊类名和方法名，需要在 `register` 时声明必要的 `options`，参考例子2。
> 2. 不支持包名( package 声明)

例子2：

```sql
set echoFun='''
import java.util.HashMap;
import java.util.Map;
public class Test {
    public Map<String, String> test(String s) {
      Map m = new HashMap<>();
      m.put(s, s);
      return m;
  }
}
''';

load script.`echoFun` as scriptTable;

register ScriptUDF.`scriptTable` as funx
options lang="java"
and className = "Test"
and methodName = "test"
;

-- 创建数据表
set data='''
{"a":"a"}
''';
load jsonStr.`data` as dataTable;

select funx(a) as res from dataTable as output;
```



### 2. 注册模型

具体使用方式如下：

```sql
register  RandomForest.`/tmp/rf` as rf_predict;

select rf_predict(features) as predict_label from trainData
as output;
```

`register` 语句的含义是： 将 `/tmp/rf ` 中的 RandomForest 模型注册成一个函数，函数名叫 rf_predict.

`register` 后面也能接 `where/options` 子句：

```sql
register  RandomForest.`/tmp/rf` as rf_predict
options algIndex="0"
-- and autoSelectByMetric="f1" 
;
```

如果训练时同时训练了多个模型的话：

1. `algIndex` 可以让用户手动指定选择哪个模型
2. `autoSelectByMetric` 则可以通过一些指标，让系统自动选择一个模型。内置算法可选的指标有： f1|weightedPrecision|weightedRecall|accuracy。

如果两个参数都没有指定话的，默认会使用 `f1` 指标。




### 3. 流式程序中注册 Watermark

在流式计算中，有 watermark 以及 window 的概念。我们可以使用 `Register` 句式来完成这个需求：

```sql
-- 为 table1 注册 watermark
register WaterMarkInPlace.`table1` as tmp1
options eventTimeCol="ts"
and delayThreshold="10 seconds";
```

## 模块化/Include

### Byzer Notebook 里的 Notebook 之间引用

Byzer-lang 提供了很好的 IDE 工具，诸如纯 Web 版本的 Byzer Notebook  ，还有 本地版本的 Byzer-desktop (基于VsCode), 他们都是以 Notebook 形式提供了对 Byzer 语言的支持，对于用户调试、管理和模块化 Byzer 代码具有非常大的价值。当然，还有程序员们喜欢的 Byzer-shell ,Byzer-cli ， 在 Byzer 的 All-in-one 版本里都默认包含了。

话题拉回来，假设用户开发了一个 UDF 函数（Byzer 支持动态定义UDF函数，意味着不用编译，不用打包发布重启等繁琐流程），然后它可能会在很多 Notebook 里都用到这个函数。
此时，用户可以将所有 UDF 函数都放到一个 Notebook 里，然后在其他 Notebook 里引用。 具体做法分成两步。

第一步，创建一个 用于存储 UDF 的 Notebook, 比如 Notebook 名字叫 udfs.bznb,第一个cell的内容为：

```sql
register ScriptUDF.`` as arrayLast
where lang="scala"
and code='''
def apply(a:Seq[String])={
    a.last
}
'''
and udfType="udf";
```

第二步，新创建一个 Notebook, 比如叫 job.bznb， 在该 Notebook 里可以通过如下方式引入 arrayLast 函数：

```sql
include http.`project.demo.udfs`;
select arrayLast(array("a","b")) as lastChar as output;
```

这个时候上面的代码就等价于：

```sql
register ScriptUDF.`` as arrayLast
where lang="scala"
and code='''
def apply(a:Seq[String])={
    a.last
}
'''
and udfType="udf";
select arrayLast(array("a","b")) as lastChar as output;

```

实现了代码的模块化复用。

在 Byzer Notebook 中，需要在一个 Notebook 里引入另外一个 Notebook，可以通过 Include语法，其中 http 和 project 是固定的。 后面  demo.udfs 则是目录路径，只不过用 . 替换了 /。

假设 udfs 里有很多函数，不希望把所有的函数都包含进来，那么可以指定 Cell 的 序号 。 比如只包含第一个 cell, 那么可以这么写：

```sql
include http.`project.demo.udfs#1`;
select arrayLast(array("a","b")) as lastChar as output;
```

期待 Byzer notebook 以后可以支持给 cell 命名  

### 代码片段的引用

假设我们有个 case when (case when 其实是很有业务价值的东西)，我们可以创建一个 case_when 的一个 Notebook:

```sql
set gender_case_when = '''

CASE 
WHEN gender=0 THEN "男"
ELSE "女"
END
''';
```

然后我在某个 Notebook  比如 main 里就可以这么用：


```sql
select 0 as gender as mockTable;

include http.`project.demo.casewhen`;

select ${gender_case_when} as gender from mockTable
as output;

```

上面的本质是把代码片段放到一个变量里去，然后在语句中引用变量。

问题来了，在本例中，如果 case when 里的 gender 字段可能是变化的怎么办？ 可能有人叫 gender, 有人叫 sex， 该如何复用？ 这当然难不倒我们, 新写一段代码：

```sql
set gender_case_when = '''

CASE 
WHEN {0}=0 THEN "男"
ELSE "女"
END
''';

```

此时把原来写 gender 的地方改成 {0}, 然后调用时，这么调用：


```sql
select 0 as gender as mockTable;

include http.`project.demo.casewhen`;

select ${template.get("gender_case_when","gender")} as gender from mockTable
as output;

```


我们使用 `template.get` 来获取模板以及使用位置参数来渲染这个模板。更多细节参考这篇专门的文章： Byzer Man：Byzer 模板编程入门

### 宏函数的使用

Byzer 也支持函数的概念，这个函数和 SQL 中的函数不同， Byzer 的宏函数是对 SQL 代码进行复用。
我们在 case_when Notebook 中再加一段代码：

```sql
set showAll='''

select CASE 
WHEN {0}=0 THEN "男"
ELSE "女"
END as gender from mockTable 
as output

''';
```


在变量 showAll 中填写了一段完整的 Byzer 代码（注意，当前版本 Byzer 不支持 宏函数嵌套，也就是宏函数里不能再使用宏函数）。接着，我们可以在 main Notebook 中引用：


```sql
select 0 as gender as mockTable;

include http.`project.demo.casewhen#3`;

!showAll gender;
```


通过 宏函数，也能有效提升我们对 Byzer 的封装性。

### 在脚本中引入 Git 托管的 Byzer 代码

几乎所有的语言都有模块化管理代码的能力，比如 Java 的 jar, Python的 Pip, Rust 的crate 等。 Byzer 也具有相同的能力。 Byzer 支持直接引用 git 仓库的中代码。假设用户开发了一个业务库，使用 Byzer 语句，此时他可以把代码放到 gitee 上，其他人就可以通过这个方式引用这个代码库：

```sql
include lib.`gitee.com/allwefantasy/lib-core`
where 
-- commit="xxxxx" and
alias="libCore";
```

接着可以可以引用里面的具体某个文件：

```sql
include local.`libCore.udf.hello`;
select hello() as name as output;
```

在上面的案例中，我们引用了 lib-core 项目里的一个 hello 函数，然后接着就可以在 select 语法中使用。include 也支持 commit 进行版本指定，很方便。
结果如下：

使用 Git 进行 Module 的托管，可以更好的对代码进行封装。

另外，如果假设你已经进行过 lib 的include(下载到服务器上了)，那么你也可以按下面的方式
应用已经缓存在本地的lib库：

```sql
include local.`gitee.com/allwefantasy/lib-core.udf.hello`;
select hello() as name as output;
```

### Byzer desktop

Byzer desktop 如果没有配置远程的引擎地址，默认会使用内置的引擎，这意味着我们可以使用Byzer 操作本地的文件。
模块的使用和 Byzer Notebook 完全一致。但对于本地的脚本的引入略有区别，它使用 project 关键词，支持相对路径：

```​sql
include project.`./udf.hello`;
```​

我们可以看到， Byzer 提供了很强的代码复用能力，结构化管理能力，能够实现代码片段到模块级别的管理能力。
对于提升用户效率，增强业务资产的沉淀能力带来很大的助力。

## 断言支持

断言可以让 Byzer 在 SQL 脚本中的任何一个位置实现中断，判断某个条件是否成立。

```sql
set abc='''
{ "x": 120, "y": 100, "z": 260 ,"dataType":"B group"}
{ "x": 160, "y": 100, "z": 260 ,"dataType":"C group"}
{ "x": 170, "y": 100, "z": 260 ,"dataType":"C group"}
{ "x": 150, "y": 100, "z": 260 ,"dataType":"B group"}
{ "x": 110, "y": 100 ,"dataType":"A group"}
{ "x": 130 ,"dataType":"A group"}
{ "x": 140, "y": 200 ,"dataType":"A group"}
''';
load jsonStr.`abc` as table1;
```
> 注意：
> 
> 1.下面相关算子，不带有Throw的不会打断脚本运行，并且会返回具体的异常数据集，通长用来做数据探查。
> 
> 2.如果希望在执行的过程中，像执行代码一样遇到异常直接打断运行，可以使用带有Throw的算子，这样会抛出异常，不会返回数据集。

### 常用单表或视图Data Quality验证算子
#### assertNotNull tableName 'fieldName1,fieldName2...'

判断表中的某些字段是否为空,默认会返回具体的非空数据集
```sql
!assertNotNull table1 'z';
```
#### assertNotNullThrow tableName 'fieldName1,fieldName2...' 
判断表中的某些字段是否为空,不满足条件则会抛出异常
```sql
!assertNotNullThrow table1 'z';
```

#### assertUniqueKey tableName 'fieldName1,fieldName2...'
判断表中的某些字段是否唯一,默认会非唯一的字段名
```sql
!assertUniqueKey table1 "z";
```


#### assertUniqueKeyThrow tableName 'fieldName1,fieldName2...'
判断表中的某些字段是否唯一,不满足条件则会抛出异常
```sql
!assertUniqueKeyThrow table1 "z";
```

#### assertUniqueKeys tableName 'fieldName1,fieldName2...'
判断组合字段是否全局唯一,默认会返回具体的非唯一数据集
```sql
!assertUniqueKeys table1 "dataType,y";
```



#### assertUniqueKeysThrow tableName 'fieldName1,fieldName2...'
判断组合字段是否全局唯一,不满足条件则会抛出异常
```sql
!assertUniqueKeysThrow table1 "z,y";
```

#### assertCondition tableName 'expression'
判断表中的某些字段是否满足设定的条件,默认会返回具体的不满足条件的数据集
```sql
!assertCondition table1 "x > 180";
```

#### assertConditionThrow tableName 'expression'
判断表中的某些字段是否满足设定的条件,不满足条件则会抛出异常 
> 注意：当你使用spark3.3.0的时候这个功能会有bug，升级到更上面的版本不会有这个问题。
> 详细原因请查看：https://issues.apache.org/jira/browse/SPARK-39612
```sql
!assertCondition table1 "x > 180";
```


#### 通用表达式校验

Byzer 支持断言，断言的语法如下：

```sql
!assert <tableName> <expr> <message>;
```
让我们来解释下上面的三个参数：

- tableName: 表名，这个表名的表必须存在，否则会抛出异常。
- expr: 一个表达式，这个表达式的值必须是一个 boolean 值，如果是 true，则不会抛出异常，如果是 false，则会抛出异常。
- message: 异常信息，当 expr 为 false 时，这个信息会在抛出异常时显示。

因为 Byzer 是使用 表 来进行上下语句的衔接的。所以，和传统语言直接对标量进行判定不同， Byzer 的断言是对表内的数据进行判定。

##### 例子

我们来看一个例子，假设我加载了一个数据集，我要判断该数据集不为空的情况下，才能继续执行后续的 SQL 语句,把结果保存起来。


```sql
load csv.`/tmp/upload/visual_data_0.csv` 
where inferSchema="true" and header="true"
as vega_datasets;

select count(*) as v from vega_datasets as vega_datasets_count;
!assert vega_datasets_count 
''' :v>0 ''' 
"数据集不能为空";

save overwrite vega_datasets as parquet.`/tmp/visual_data_0`;
```

上面的例子中，我们使用了 `!assert` 语句，来判断数据集的数量是否大于 0，如果不大于 0，则会抛出异常，异常信息是 "数据集不能为空"。
但是判断自身，其实是通过 `select count(*) as v from vega_datasets as vega_datasets_count;` 这条辅助 SQL 语句来实现的，这条语句的结果会被传递给 `!assert` 语句，然后我们对 v 字段进行判断。

判断中对于变量的引用使用了 `:<varName>` 的语法, 这种变量引用的方式，我们在 Byzer 的条件分支表达式里也会用到。

## 注意

1. 断言中的表必须是一个结果表（一般里面只会有一条记录），因为他会在内存中使用，如果表太大可能会导致系统崩溃。
2. 断言会触发一次实际的SQL执行，可能会极大的降低了脚本的执行速度，请在确实需要的地方使用。

## 举一反三

如果我想看一个表是不是年份字段是不是重复，如果有的话，那么停止执行，否则往后执行，该怎么实现呢？
下面的例子我们使用变量的方式

```sql
load csv.`/tmp/upload/visual_data_0.csv` 
where inferSchema="true" and header="true"
as vega_datasets;

set vega_datasets_count = `select count(*) as v from vega_datasets` where type="sql" ;
set vega_datasets_distinct_count = `select count(Year) as distinct_v from vega_datasets group by Year` where type="sql" ;

select ${vega_datasets_count} as vega_datasets_count, ${vega_datasets_distinct_count} as vega_datasets_distinct_count as assertTable;

!assert assertTable 
''' :vega_datasets_count == :vega_datasets_distinct_count ''' 
"Year 字段不能有重复";

save overwrite vega_datasets as parquet.`/tmp/visual_data_0`;
```

上面的例子中，我们使用了两个辅助 SQL 语句，来获取数据集的总数和去重后的总数，并且构建成一个新表，然后通过 `!assert` 语句来判断新表中这两个值是否相等，如果不相等，则会抛出异常，异常信息是 "Year 字段不能有重复"。

为了做这个判断，我们相当于执行了两条count语句，这个在数据量大的时候，可能会导致脚本执行的很慢，所以请谨慎使用。

#### Byzer 模块中使用 !assert 语法

我们知道 Byzer 是支持模块的，也就是代码文件的的引用。模块在使用之前，需要用户传递一些参数，此时可以通过 !assert 来确定参数是否存在或者是否正确。

下面的代码来自 一个示例模块

```sql
/**
Usage:

set inputTable="abc";
include local.`libCore.alg.xgboost`;
**/

!assert inputTable in __set__  ''' inputTable is missing. Try set inputTable="" ''';
!assert rayAddress in __set__ ''' rayAddress is missing. Try set rayAddress="127.0.0.1:10001" ''';

set inModule="true" where type="defaultParam";
set rayAddress="127.0.0.1:10001" where type="defaultParam";
set outputTable="xgboost_model" where type="defaultParam";

!python conf "rayAddress=${rayAddress}";
!python conf "runIn=driver";
!python conf "schema=file";
!python conf "dataMode=model";

-- 引入python脚本
!if ''' :inModule == "true" ''';
!then;
    !println "include from module";
    !pyInclude local 'github.com/allwefantasy/lib-core.alg.xgboost.py' named rawXgboost;
!else;
    !println "include from project";
    !pyInclude project 'src/algs/xgboost.py' named rawXgboost;
!fi;  
```

在这个例子里，我们通过 !assert 检查用户是不是通过 set 设置了参数 inputTable, rayAddress的，如果没有，那么我们会报错。 这段脚本，用户可以这么用：

```sql
-- 引入第三方依赖
include lib.`gitee.com/allwefantasy/lib-core`
where alias="libCore";

-- 调用依赖里的模块
set inputTable="abc";
include local.`libCore.alg.xgboost`;
```

## 扩展/Train|Run|Predict

Train/Run/Predict 都属于 Byzer-lang 里独有的并且可扩展的句式，一般用于机器学习模型的训练和预测，以及特征工程相关的数据处理操作。

想了解更多 [内置算法](/byzer-lang/zh-cn/ml/algs/README.md) 和 [特征工程](/byzer-lang/zh-cn/ml/feature/README.md) 算子的应用，可跳转置对应章节。

### 1. 基础语法

#### Train

`train` 顾名思义，就是进行训练，主要是对算法进行训练时使用。下面是一个比较典型的示例：

```sql

load json.`/tmp/train` as trainData;

train trainData as RandomForest.`/tmp/rf` where
keepVersion="true"
and fitParam.0.featuresCol="content"
and fitParam.0.labelCol="label"
and fitParam.0.maxDepth="4"
and fitParam.0.checkpointInterval="100"
and fitParam.0.numTrees="4"
;
```

- 第一行代码，含义是加载位于 `/tmp/train` 目录下的，数据格式为 JSON 的数据，并且给该表取名为 `trainData`；
- 第二行代码，则表示提供 `trainData` 为数据集，使用算法 RandomForest，将模型保存在 `/tmp/rf` 下，训练的参数为 `fitParam.0.*` 参数组里指定的那些。其中 `fitParam.0` 表示第一组参数，用户可以递增设置 N 组，Byzer-lang 会自动运行多组，最后返回结果列表。例如：

```sql
load json.`/tmp/train` as trainData;

train trainData as RandomForest.`/tmp/rf` where
-- 每次模型不要覆盖，保持版本
keepVersion = "true"
and `fitParam.0.labelCol`= "label"  --y标签
and `fitParam.0.featuresCol`= "features"  -- x特征
and `fitParam.0.maxDepth`= "4"

--设置了两组参数同时运行可对比结果优劣
and `fitParam.1.labelCol`= "label"  --y标签
and `fitParam.1.featuresCol`= "features"  -- x特征
and `fitParam.1.maxDepth`= "10";
```

#### Run

`run` 的语义是对数据进行处理，而不是训练。

下面来看一个例子：

```sql
run testData as TableRepartition.`` where partitionNum="5" as newdata; 
```

格式和 `train` 是一致的，其含义为运行 `testData` 数据集，使用内置插件 TableRepartition 对其重分区处理，
处理的参数是 `partitionNum="5"`，最后处理后的表叫 `newdata`。


#### Predict

`predict` 顾名思义，应该和机器学习相关预测相关。比如上面的 train 示例中，用户将随机森林的模型放在了
`/tmp/rf` 目录下，用户可以通过 `predict` 语句加载该模型，并且对表 `testData` 进行预测。

示例代码如下：

```sql
predict testData as RandomForest.`/tmp/rf`;
```

## 宏函数/Macro Function

Byzer-lang 中的宏函数和 `select` 句式中函数是不一样的。 宏函数主要是为了复用 Byzer-lang 代码。

### 1. 基础用法

以加载 `excel` 文件的代码为例:

```sql
load excel.`./example-data/excel/hello_world.xlsx` 
where header="true" 
as hello_world;

select hello from hello_world as output;
```

如果每次都写完整的 `load` 语句，可能会比较繁琐。此时用户可以将其封装成一个宏函数：

```sql
set loadExcel = '''
load excel.`{0}` 
where header="true" 
as {1}
''';

!loadExcel ./example-data/excel/hello_world.xlsx helloTable;

```

在上面示例代码中，分成两步，第一步是定义一个变量，该变量的值为一段 Byzer-lang 代码。代码中的 `{0}` , `{1}` 等为位置参数，会在调用的时候被替换。
第二步，使用 `!` 实现宏函数的调用，参数传递则使用类似命令行的方式。

如果参数中包含空格等特殊字符，可以将参数括起来：

```sql
set loadExcel = '''
load excel.`{0}` 
where header="true" 
as {1}
''';

!loadExcel "./example-data/excel/hello_world.xlsx" "helloTable";
```

宏函数也支持命名参数：

```sql
set loadExcel = '''
load excel.`${path}` 
where header="true" 
as ${tableName}
''';

!loadExcel _ -path ./example-data/excel/hello_world.xlsx -tableName helloTable;
```

`-path` 后面的参数对应  `loadExcel` 函数体里的 `${path}`, 同理 `tableName`。

注意，为了识别命名参数，宏函数要求第一个参数是 `_` 。

### 2. 作用域

宏函数声明后即可使用。 可以重复声明，后声明的会覆盖前面声明的。

### 3. 宏函数的限制

宏函数的使用，目前也有几个限制：

1. 宏函数体里，最后一条语句不需要分号
2. 宏函数里不能嵌套宏函数

第一条限制比较容易理解。

第二条限制可以通过下面的代码来展示：

```sql
set hello = '''
!hdfs -ls /;
select 1 as a as output
''';

!hello;
```

该语句包含了一个内置的宏函数 `!hdfs`, 所以是非法的。

## 注册大模型为UDF函数

Byzer SQL 可以连接一个已经部署好的模型实例，然后将其转换成 SQL 函数，具体做法如下；

```
!byzerllm setup single;

run command as LLM.`` where 
action="infer"
and reconnect="true"
and pretrainedModelType="saas/openai"
and udfName="deepseek_chat";
```

上面是一个固定语法方式，唯一需要修改的事 pretrainedModelType 和 udfName，pretrainedModelType 是模型类型， saas/ 表示是saas模型，反斜杠后面
则表示模型提供商，不过很多模型提供商都可以使用 openai 接口调用。udfName 是注册的函数名，需要保持和已经部署好的模型实例同名。


## 大模型相关的辅助 SQL 函数用于自然语言处理

### llm_param 函数

#### 描述
`llm_param` 函数用于设置 LLM 的参数。

#### 语法
```sql
llm_param(map(...))
```

#### 参数
- `map(...)`: 一个包含键值对的映射，用于设置 LLM 的各种参数。

#### 示例
```sql
llm_param(map(
    "instruction", llm_prompt('...')
))
```

#### 说明
- 在示例中，我们设置了一个名为 "instruction" 的参数，其值由 `llm_prompt` 函数生成。
- 可以根据需要在 map 中添加更多参数，如模型名称、温度等。

### llm_prompt 函数

#### 描述
`llm_prompt` 函数用于构建发送给 LLM 的提示文本。

#### 语法
```sql
llm_prompt('prompt_text', array(...))
```

#### 参数
- `'prompt_text'`: 提示文本模板，可以包含占位符 `{0}`, `{1}` 等。
- `array(...)`: 一个数组，包含用于填充提示文本模板中占位符的值。

#### 示例
```sql
llm_prompt('
根据下面提供的信息，回答用户的问题。
信息上下文：
```
{0}
```
用户的问题： Byzer-SQL 是什么?
', array(context))
```

#### 说明
- 提示文本中的 `{0}` 将被 `array(context)` 中的值替换。
- 可以使用多个占位符 (`{0}`, `{1}`, ...) 并在数组中提供相应的值。

### llm_result 函数

#### 描述
`llm_result` 函数用于从 LLM 的响应中提取结果。

#### 语法
```sql
llm_result(response)
```

#### 参数
- `response`: LLM 的原始响应。

#### 示例
```sql
select llm_result(response) as result from q3 as output;
```

#### 说明
- 此函数通常用于从 LLM 的响应中提取有用的信息，并将其格式化为所需的输出格式。

### llm_stack 函数

`llm_stack` 函数是用于在多轮对话中维持上下文的一个重要工具。它的主要作用是将前一轮对话的响应与新的指令结合，以便在后续的对话中保持连贯性和上下文awareness。

下面是一段示例代码：

```sql
select 
deepseek_chat(llm_param(map(
              "instruction",'我是威廉，请记住我是谁。'
)))
as response as table1;
select llm_result(response) as result from table1 as output;

select 
deepseek_chat(llm_stack(response,llm_param(map(
              "instruction",'请问我是谁？'
))))
as response from table1
as table2;
select llm_result(response) as result from table2 as output;
```

让我们详细分析一下这个函数的使用：

1. 函数语法：
   ```sql
   llm_stack(previous_response, new_instruction)
   ```

2. 参数说明：
   - `previous_response`：前一轮对话的响应。在您的例子中，这是来自 `table1` 的 `response`。
   - `new_instruction`：新的指令，通常通过 `llm_param` 函数设置。

3. 使用场景：
   在您的例子中，`llm_stack` 被用于两轮对话中：
   - 第一轮：介绍 "我是威廉"
   - 第二轮：询问 "请问我是谁？"

4. 工作原理：
   - `llm_stack` 函数会将第一轮对话的响应（即模型记住了"威廉"这个身份）与第二轮的新指令（询问身份）结合起来。
   - 这样做可以让模型在回答第二个问题时，依然记得第一轮对话中提到的信息。

5. 在您的代码中的应用：
   - 第一个查询设置了初始上下文（介绍威廉）。
   - 第二个查询使用 `llm_stack` 来确保模型在回答 "我是谁" 的问题时，能够记住之前介绍的身份信息。

通过使用 `llm_stack`，您可以创建更自然、更连贯的多轮对话，使得大语言模型能够在整个对话过程中保持上下文awareness，提供更准确和相关的回答。这在创建聊天机器人、问答系统或任何需要维持对话历史的应用中特别有用。

### 模型 UDF 函数

任何模型注册为 UDF 函数后，都有相同的调用方式。比如上面的 `deepseek_chat`, 语法如下:

```sql
deepseek_chat(llm_param(...))
```
通过将模型 UDF 函数和其他辅助函数结合，让我们可以对SQL中的文本字段做自然语言处理，比如判断正负面情感、生成文本、回答问题等等。

### 使用 Byzer-SQL 模型 UDF 函数完成表格文本字段的自然语言处理以及统计任务

下面我们展示如何组合这些大模型辅助函数，完成一个简单的任务：统计用户正面评论的数量。

```sql
select "这个点心太好吃了" as 
context as rag_table;

select 
llm_result(deepseek_chat(llm_param(map(
              "instruction",llm_prompt('

根据下面提供的信息，回答用户的问题。

信息上下文：
```
{0}
```

用户的问题： 用户的评论是正面还是负面的。
请只输出 “正面” 或者 “负面”
',array(context))

))))

as response from rag_table as q3;

select count(*) as positive_counter from q3 where response like '%正面%' as output;


```

在这个示例中：
1. 我们首先创建了一个包含上下文信息的表 `rag_table`。
2. 然后使用 `llm_param` 和 `llm_prompt` 构建 prompt 指令。
3. 将构建的指令传递给 `deepseek_chat` 函数（这可能是一个特定的 LLM 接口）。
4. 最后，使用 `llm_result` 函数处理 LLM 的响应,得到的是一段文本，因为我们已经要求 deepseek_chat 输出包含`正面` 或者`负面`的文本了，但考虑到大模型会有一些额外的字符输出，不会只是输出我们要求的文字，所以通过 `like` 来进行匹配，从而过滤出正面评论，然后完成最后的统计结果。

通过这种方式，Byzer-SQL 能够无缝地集成 LLM 功能，使得在 SQL 环境中进行复杂的自然语言处理任务变得简单而直观。


### 注意事项

1. 务必要理解模型 UDF 函数的使用场景，仅局限对某个字段的自然语言处理上，不要滥用，大部分问题应该都通过标准的 Byzer-SQL 统计聚合来完成。
2. llm_result 等以 llm_ 开头函数，只能配合模型 UDF 函数使用，不能单独使用。
3. 在使用了模型UDF函数的 select 语句中，请使用hint  /*+ REPARTITION(500) */ 来提高性能，类似 SELECT /*+ REPARTITION(500) */ ，其中里面的数值 500 可以根据需求进一步使用更大的数值。