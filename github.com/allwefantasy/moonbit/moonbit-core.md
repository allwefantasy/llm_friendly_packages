# MoonBit Core 标准库完整指南

MoonBit Core 是 MoonBit 语言的标准库，提供了编程中常用的核心功能和数据结构。本文档参考了 MoonBit 项目的文档格式，全面介绍 Core 库的各个模块及其使用方法。

## 概述

MoonBit Core 标准库包含以下主要功能模块：

- **基础类型与操作**: builtin, string, array, bytes 等
- **数据结构**: hashmap, list, deque, queue, priority_queue 等
- **数学运算**: math, bigint, rational 等
- **数据转换**: json, strconv, encoding 等
- **函数式编程**: option, result, iter 等
- **并发与异步**: 支持结构化并发编程
- **工具类**: random, quickcheck, test 等

## 基础类型与操作

### builtin - 内置类型和核心功能

builtin 包提供了 MoonBit 的核心类型、断言、测试和基础功能。

#### 断言和测试

```moonbit
///|
test "基础断言" {
  // 相等断言
  assert_eq(1 + 1, 2)
  assert_eq("hello", "hello")

  // 布尔断言
  assert_true(5 > 3)
  assert_false(2 > 5)

  // 不等断言
  assert_not_eq(1, 2)
  assert_not_eq("foo", "bar")
}
```

#### inspect 函数用于测试和调试

```moonbit
///|
test "inspect 用法" {
  let value = 42
  inspect(value, content="42")

  let list = [1, 2, 3]
  inspect(list, content="[1, 2, 3]")

  let result : Result[Int, String] = Ok(100)
  inspect(result, content="Ok(100)")
}
```

#### Result 类型

Result 类型表示可能成功或失败的操作：

```moonbit
///|
test "Result 类型使用" {
  // 创建 Result 值
  let success : Result[Int, String] = Ok(42)
  let failure : Result[Int, String] = Err("错误信息")

  // 模式匹配
  match success {
    Ok(value) => inspect(value, content="42")
    Err(msg) => panic()
  }

  // 使用 map 转换成功值
  let doubled = success.map(x => x * 2)
  inspect(doubled, content="Ok(84)")

  // 使用 unwrap_or 提供默认值
  let value = failure.unwrap_or(0)
  inspect(value, content="0")
}
```

#### Option 类型

Option 类型表示可能存在或不存在的值：

```moonbit
///|
test "Option 类型使用" {
  // 创建 Option 值
  let some_value : Option[Int] = Some(42)
  let none_value : Option[Int] = None

  // 模式匹配
  match some_value {
    Some(x) => inspect(x, content="42")
    None => panic()
  }

  // 使用 map 转换值
  let doubled = some_value.map(x => x * 2)
  inspect(doubled, content="Some(84)")

  // 使用 unwrap_or 提供默认值
  let value = none_value.unwrap_or(0)
  inspect(value, content="0")
}
```

### string - 字符串操作

string 包提供了丰富的字符串操作功能。

#### 基础字符串操作

```moonbit
///|
test "字符串基础操作" {
  let s = "Hello, MoonBit!"

  // 长度和判空
  inspect(s.length(), content="15")
  inspect(s.is_empty(), content="false")

  // 字符访问
  inspect(s[0], content="72") // 'H' 的 ASCII 值
  inspect(s.get_char(0), content="Some('H')")

  // 子字符串
  let substr = s[0:5]
  inspect(substr, content="Hello")

  // 查找
  inspect(s.contains("Moon"), content="true")
  inspect(s.index_of("Moon"), content="Some(7)")
}
```

#### 字符串转换和处理

```moonbit
///|
test "字符串转换" {
  let s = "  Hello World  "

  // 去除空白
  inspect(s.trim(), content="Hello World")
  inspect(s.trim_start(), content="Hello World  ")
  inspect(s.trim_end(), content="  Hello World")

  // 大小写转换
  inspect(s.to_upper(), content="  HELLO WORLD  ")
  inspect(s.to_lower(), content="  hello world  ")

  // 分割
  let parts = "a,b,c".split(",")
  inspect(parts, content="[\"a\", \"b\", \"c\"]")

  // 替换
  let replaced = "hello world".replace("world", "MoonBit")
  inspect(replaced, content="hello MoonBit")
}
```

#### 字符串插值

```moonbit
///|
test "字符串插值" {
  let name = "MoonBit"
  let version = 1.0
  let message = "Hello \{name} v\{version}"
  inspect(message, content="Hello MoonBit v1.0")

  // 多行字符串
  let multi_line =
    #|第一行
    #|第二行
    #|第三行
    #|
  inspect(multi_line, content="第一行\n第二行\n第三行\n")
}
```

#### StringBuilder

```moonbit
///|
test "StringBuilder 使用" {
  let sb = StringBuilder::new()
  sb.write_string("Hello")
  sb.write_char(' ')
  sb.write_string("World")

  let result = sb.to_string()
  inspect(result, content="Hello World")

  // 链式调用
  let sb2 = StringBuilder::new()
  sb2..write_string("A")..write_string("B")..write_string("C")
  inspect(sb2.to_string(), content="ABC")
}
```

### array - 数组操作

array 包提供了动态数组 (Array)、固定数组 (FixedArray) 和数组视图 (ArrayView) 的操作。

#### 数组创建

```moonbit
///|
test "数组创建" {
  // 使用字面量
  let arr1 = [1, 2, 3]
  inspect(arr1, content="[1, 2, 3]")

  // 使用索引创建
  let arr2 = Array::makei(5, i => i * 2)
  inspect(arr2, content="[0, 2, 4, 6, 8]")

  // 从迭代器创建
  let arr3 = Array::from_iter("hello".iter())
  inspect(arr3, content="['h', 'e', 'l', 'l', 'o']")

  // 重复元素
  let arr4 = Array::make(3, "x")
  inspect(arr4, content="[\"x\", \"x\", \"x\"]")
}
```

#### 数组操作

```moonbit
///|
test "数组操作" {
  let nums = [1, 2, 3, 4, 5]

  // 过滤和映射
  let evens = nums.filter(x => x % 2 == 0)
  inspect(evens, content="[2, 4]")

  let doubled = nums.map(x => x * 2)
  inspect(doubled, content="[2, 4, 6, 8, 10]")

  // filter_map 组合操作
  let neg_evens = nums.filter_map(x => if x % 2 == 0 { Some(-x) } else { None })
  inspect(neg_evens, content="[-2, -4]")

  // 折叠操作
  let sum = nums.fold(init=0, (acc, x) => acc + x)
  inspect(sum, content="15")

  let product = nums.fold(init=1, (acc, x) => acc * x)
  inspect(product, content="120")
}
```

#### 数组查找和访问

```moonbit
///|
test "数组查找" {
  let arr = [10, 20, 30, 40, 50]

  // 索引访问
  inspect(arr[0], content="10")
  inspect(arr.get(0), content="Some(10)")
  inspect(arr.get(10), content="None")

  // 查找元素
  inspect(arr.contains(30), content="true")
  inspect(arr.index_of(30), content="Some(2)")

  // 第一个和最后一个
  inspect(arr.first(), content="Some(10)")
  inspect(arr.last(), content="Some(50)")

  // 查找满足条件的元素
  let found = arr.find(x => x > 25)
  inspect(found, content="Some(30)")
}
```

#### 数组排序

```moonbit
///|
test "数组排序" {
  let arr = [3, 1, 4, 1, 5, 9, 2, 6]

  // 基础排序 - 修改原数组
  let sorted1 = arr.copy()
  sorted1.sort()
  inspect(sorted1, content="[1, 1, 2, 3, 4, 5, 6, 9]")

  // 自定义比较排序
  let strs = ["apple", "pie", "a"]
  let sorted2 = strs.copy()
  sorted2.sort_by((a, b) => a.length().compare(b.length()))
  inspect(sorted2, content="[\"a\", \"pie\", \"apple\"]")

  // 按键排序
  let pairs = [(2, "b"), (1, "a"), (3, "c")]
  let sorted3 = pairs.copy()
  sorted3.sort_by_key(p => p.0)
  inspect(sorted3, content="[(1, \"a\"), (2, \"b\"), (3, \"c\")]")
}
```

#### FixedArray 固定数组

```moonbit
///|
test "FixedArray 使用" {
  // 创建固定大小数组
  let fixed = FixedArray::make(5, 0)
  fixed[0] = 10
  fixed[1] = 20

  inspect(fixed.length(), content="5")
  inspect(fixed[0], content="10")

  // 转换为动态数组
  let dynamic = fixed.to_array()
  inspect(dynamic, content="[10, 20, 0, 0, 0]")
}
```

### bytes - 字节数组操作

bytes 包提供字节数组 (Bytes) 和字节视图 (BytesView) 操作。

```moonbit
///|
test "Bytes 操作" {
  // 创建字节数组
  let b1 : Bytes = b"hello"
  let b2 : Bytes = [0x48, 0x65, 0x6c, 0x6c, 0x6f] // "Hello"

  // 字节访问
  inspect(b1[0], content="104") // 'h'
  inspect(b1.length(), content="5")

  // 转换
  let s = String::from_bytes(b1)
  inspect(s, content="hello")

  // 字节视图
  let view = b1[1:4] // "ell"
  inspect(view.length(), content="3")
}
```

## 数据结构

### hashmap - 哈希映射

hashmap 提供了基于 Robin Hood 哈希表的可变哈希映射。

#### 基础操作

```moonbit
///|
test "HashMap 基础操作" {
  let map : @hashmap.HashMap[String, Int] = @hashmap.new()

  // 设置和获取
  map.set("apple", 5)
  map.set("banana", 3)
  map.set("orange", 8)

  inspect(map.get("apple"), content="Some(5)")
  inspect(map.get("grape"), content="None")
  inspect(map.get_or_default("grape", 0), content="0")

  // 检查存在
  inspect(map.contains("banana"), content="true")
  inspect(map.contains("grape"), content="false")

  // 大小
  inspect(map.length(), content="3")
  inspect(map.is_empty(), content="false")
}
```

#### 高级操作

```moonbit
///|
test "HashMap 高级操作" {
  let map = @hashmap.of([("a", 1), ("b", 2), ("c", 3)])

  // 删除
  map.remove("b")
  inspect(map.contains("b"), content="false")

  // 迭代
  let keys = []
  let values = []
  map.each(fn(k, v) {
    keys.push(k)
    values.push(v)
  })

  // 转换为数组
  let pairs = map.to_array()
  inspect(pairs.length(), content="2")

  // 清空
  map.clear()
  inspect(map.is_empty(), content="true")
}
```

### list - 链表

list 包提供了不可变链表数据结构。

```moonbit
///|
test "List 操作" {
  // 创建链表
  let list1 = @list.of([1, 2, 3, 4, 5])
  let list2 = @list.Cons(0, list1) // 前置元素

  // 基础操作
  inspect(list1.length(), content="5")
  inspect(list1.head(), content="Some(1)")
  inspect(list1.tail().unwrap().head(), content="Some(2)")

  // 函数式操作
  let doubled = list1.map(x => x * 2)
  inspect(doubled.to_array(), content="[2, 4, 6, 8, 10]")

  let evens = list1.filter(x => x % 2 == 0)
  inspect(evens.to_array(), content="[2, 4]")

  let sum = list1.fold(init=0, (acc, x) => acc + x)
  inspect(sum, content="15")
}
```

### deque - 双端队列

```moonbit
///|
test "Deque 操作" {
  let dq = @deque.new()

  // 前端操作
  dq.push_front(2)
  dq.push_front(1)

  // 后端操作
  dq.push_back(3)
  dq.push_back(4)

  inspect(dq.length(), content="4")
  inspect(dq.front(), content="Some(1)")
  inspect(dq.back(), content="Some(4)")

  // 弹出操作
  inspect(dq.pop_front(), content="Some(1)")
  inspect(dq.pop_back(), content="Some(4)")
  inspect(dq.length(), content="2")
}
```

### queue - 队列

```moonbit
///|
test "Queue 操作" {
  let q = @queue.new()

  // 入队
  q.push(1)
  q.push(2)
  q.push(3)

  inspect(q.length(), content="3")
  inspect(q.peek(), content="Some(1)")

  // 出队
  inspect(q.pop(), content="Some(1)")
  inspect(q.pop(), content="Some(2)")
  inspect(q.length(), content="1")
}
```

### priority_queue - 优先队列

```moonbit
///|
test "PriorityQueue 操作" {
  let pq = @priority_queue.new()

  // 插入元素（默认最大堆）
  pq.push(3)
  pq.push(1)
  pq.push(4)
  pq.push(2)

  inspect(pq.length(), content="4")
  inspect(pq.peek(), content="Some(4)") // 最大值

  // 弹出元素
  inspect(pq.pop(), content="Some(4)")
  inspect(pq.pop(), content="Some(3)")
  inspect(pq.length(), content="2")
}
```

### set - 集合和 sorted_set - 有序集合

```moonbit
///|
test "Set 操作" {
  let set1 = @set.of([1, 2, 3, 4])
  let set2 = @set.of([3, 4, 5, 6])

  // 基础操作
  inspect(set1.contains(3), content="true")
  inspect(set1.size(), content="4")

  // 集合运算
  let union = set1.union(set2)
  inspect(union.to_array(), content="[1, 2, 3, 4, 5, 6]")

  let intersection = set1.intersection(set2)
  inspect(intersection.to_array(), content="[3, 4]")

  let difference = set1.difference(set2)
  inspect(difference.to_array(), content="[1, 2]")
}
```

```moonbit
///|
test "SortedSet 操作" {
  let sorted_set = @sorted_set.new()
  sorted_set.insert(3)
  sorted_set.insert(1)
  sorted_set.insert(4)
  sorted_set.insert(2)

  // 有序迭代
  let values = []
  sorted_set.each(fn(x) { values.push(x) })
  inspect(values, content="[1, 2, 3, 4]")

  // 范围查询
  let range = sorted_set.range(2, 4)
  inspect(range.to_array(), content="[2, 3]")
}
```

## 数学运算

### math - 数学函数

math 包提供了常用的数学函数。

#### 基础数学函数

```moonbit
///|
test "基础数学函数" {
  // 数学常量
  inspect(@math.PI, content="3.141592653589793")

  // 舍入函数
  inspect(@math.round(3.7), content="4")
  inspect(@math.ceil(3.2), content="4")
  inspect(@math.floor(3.7), content="3")
  inspect(@math.trunc(-3.7), content="-3")

  // 绝对值和符号
  inspect(@math.abs(-5.0), content="5")
  inspect(@math.sign(-3.0), content="-1")
  inspect(@math.sign(0.0), content="0")
  inspect(@math.sign(3.0), content="1")
}
```

#### 指数和对数函数

```moonbit
///|
test "指数对数函数" {
  // 指数函数
  inspect(@math.exp(1.0), content="2.718281828459045")
  inspect(@math.exp2(3.0), content="8")
  inspect(@math.expm1(1.0), content="1.718281828459045")

  // 对数函数
  inspect(@math.ln(@math.E), content="1")
  inspect(@math.log2(8.0), content="3")
  inspect(@math.log10(100.0), content="2")
  inspect(@math.ln_1p(0.0), content="0")
}
```

#### 三角函数

```moonbit
///|
test "三角函数" {
  // 基础三角函数
  inspect(@math.sin(@math.PI / 2.0), content="1")
  inspect(@math.cos(0.0), content="1")
  inspect(@math.tan(@math.PI / 4.0), content="0.9999999999999999")

  // 反三角函数
  inspect(@math.asin(1.0), content="1.5707963267948966")
  inspect(@math.acos(1.0), content="0")
  inspect(@math.atan(1.0), content="0.7853981633974483")

  // 双曲函数
  inspect(@math.sinh(0.0), content="0")
  inspect(@math.cosh(0.0), content="1")
  inspect(@math.tanh(0.0), content="0")
}
```

#### 幂函数和根函数

```moonbit
///|
test "幂函数和根函数" {
  // 幂运算
  inspect(@math.pow(2.0, 3.0), content="8")
  inspect(@math.pow(9.0, 0.5), content="3")

  // 平方根
  inspect(@math.sqrt(16.0), content="4")
  inspect(@math.sqrt(2.0), content="1.4142135623730951")

  // 立方根
  inspect(@math.cbrt(8.0), content="2")
  inspect(@math.cbrt(27.0), content="3")

  // 平方
  inspect(@math.square(5.0), content="25")
}
```

### bigint - 大整数

```moonbit
///|
test "BigInt 操作" {
  // 创建大整数
  let a = @bigint.from_string("123456789012345678901234567890")
  let b = @bigint.from_int(999999999)

  // 基础运算
  let sum = a + b
  let product = a * b

  // 比较
  inspect(a > b, content="true")
  inspect(a.compare(b), content="1")

  // 转换
  inspect(b.to_string(), content="999999999")
  inspect(@bigint.from_int(42).to_int(), content="Some(42)")
}
```

### rational - 有理数

```moonbit
///|
test "Rational 操作" {
  // 创建有理数
  let r1 = @rational.new(3, 4)    // 3/4
  let r2 = @rational.new(1, 2)    // 1/2

  // 运算
  let sum = r1 + r2               // 3/4 + 1/2 = 5/4
  let product = r1 * r2           // 3/4 * 1/2 = 3/8

  // 转换
  inspect(r1.to_double(), content="0.75")
  inspect(sum.to_string(), content="5/4")

  // 约分
  let r3 = @rational.new(6, 8)    // 6/8 = 3/4
  inspect(r3.to_string(), content="3/4")
}
```

## 数据转换

### json - JSON 处理

json 包提供了完整的 JSON 处理功能。

#### JSON 解析和生成

```moonbit
///|
test "JSON 解析生成" {
  // 验证 JSON
  inspect(@json.valid("{\"key\": 42}"), content="true")
  inspect(@json.valid("invalid"), content="false")

  // 解析 JSON
  let json = @json.parse("{\"name\": \"MoonBit\", \"version\": 1.0}")

  // 美化输出
  let pretty = json.stringify(indent=2)
  inspect(
    pretty,
    content="{\\n  \"name\": \"MoonBit\",\\n  \"version\": 1\\n}"
  )
}
```

#### JSON 数据访问

```moonbit
///|
test "JSON 数据访问" {
  let json = @json.parse(
    "{\"string\":\"hello\",\"number\":42,\"array\":[1,2,3],\"bool\":true}"
  )

  // 访问字符串
  let string_val = json.value("string").unwrap().as_string()
  inspect(string_val, content="Some(\"hello\")")

  // 访问数字
  let number_val = json.value("number").unwrap().as_number()
  inspect(number_val, content="Some(42)")

  // 访问数组
  let array_val = json.value("array").unwrap().as_array()
  inspect(array_val.unwrap().length(), content="3")

  // 访问布尔值
  let bool_val = json.value("bool").unwrap().as_bool()
  inspect(bool_val, content="Some(true)")

  // 处理不存在的键
  inspect(json.value("missing"), content="None")
}
```

#### JSON 数组操作

```moonbit
///|
test "JSON 数组操作" {
  let array = @json.parse("[1, 2, 3, 4, 5]")

  // 按索引访问
  let first = array.item(0)
  inspect(first.unwrap().as_number(), content="Some(1)")

  // 越界访问
  let out_of_bounds = array.item(10)
  inspect(out_of_bounds, content="None")

  // 数组长度
  let length = array.as_array().unwrap().length()
  inspect(length, content="5")
}
```

#### 类型安全的 JSON 转换

```moonbit
///|
struct Person {
  name : String
  age : Int
  email : Option[String]
} derive(ToJson, FromJson)

test "类型安全 JSON 转换" {
  let person = Person::{ name: "Alice", age: 30, email: Some("alice@example.com") }

  // 转换为 JSON
  let json = person.to_json()
  let json_string = json.stringify()

  // 从 JSON 转换回来
  let parsed_json = @json.parse(json_string)
  let restored_person = Person::from_json(parsed_json)

  match restored_person {
    Ok(p) => {
      inspect(p.name, content="Alice")
      inspect(p.age, content="30")
    }
    Err(_) => panic()
  }
}
```

### strconv - 字符串转换

strconv 包实现基础数据类型与字符串之间的转换。

#### 解析函数

```moonbit
///|
test "字符串解析" {
  // 解析布尔值
  let b = @strconv.parse_bool("true")
  inspect(b, content="true")

  // 解析整数
  let i1 = @strconv.parse_int("1234567")
  inspect(i1, content="1234567")

  // 指定进制解析
  let i2 = @strconv.parse_int("101", base=2)
  inspect(i2, content="5")

  let i3 = @strconv.parse_int("FF", base=16)
  inspect(i3, content="255")

  // 解析浮点数
  let d = @strconv.parse_double("123.4567")
  inspect(d, content="123.4567")
}
```

#### 通用解析函数

```moonbit
///|
test "通用解析" {
  // 使用 FromStr trait 的通用解析
  let a : Int = @strconv.parse("123")
  inspect(a, content="123")

  let b : Bool = @strconv.parse("false")
  inspect(b, content="false")

  let c : Double = @strconv.parse("3.14159")
  inspect(c, content="3.14159")
}
```

#### 格式化输出

```moonbit
///|
test "格式化输出" {
  // 整数格式化
  inspect(@strconv.format_int(255, base=16), content="ff")
  inspect(@strconv.format_int(255, base=2), content="11111111")

  // 浮点数格式化
  inspect(@strconv.format_double(3.14159, precision=2), content="3.14")
  inspect(@strconv.format_double(1234.5, scientific=true), content="1.2345e+03")
}
```

### encoding/utf8 - UTF-8 编码

```moonbit
///|
test "UTF-8 编码解码" {
  let text = "Hello, 世界! 🌍"

  // 编码为字节数组
  let bytes = @encoding/utf8.encode(text)
  inspect(bytes.length(), content="16")

  // 解码回字符串
  let decoded = @encoding/utf8.decode(bytes)
  inspect(decoded, content="Hello, 世界! 🌍")

  // 验证 UTF-8
  inspect(@encoding/utf8.valid(bytes), content="true")

  // 处理无效字节
  let invalid_bytes = b"\xFF\xFE"
  match @encoding/utf8.decode(invalid_bytes) {
    Ok(_) => panic()
    Err(_) => inspect("解码失败", content="解码失败")
  }
}
```

## 函数式编程

### iter - 迭代器

迭代器提供了函数式编程的强大工具。

#### 基础迭代器操作

```moonbit
///|
test "迭代器基础操作" {
  let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

  // 链式操作
  let result = numbers
    .iter()
    .filter(x => x % 2 == 0)    // 偶数
    .map(x => x * x)            // 平方
    .take(3)                    // 取前3个
    .collect()

  inspect(result, content="[4, 16, 36]")

  // 折叠操作
  let sum = numbers.iter().fold(init=0, (acc, x) => acc + x)
  inspect(sum, content="55")

  // 查找操作
  let found = numbers.iter().find(x => x > 7)
  inspect(found, content="Some(8)")
}
```

#### 高级迭代器操作

```moonbit
///|
test "高级迭代器操作" {
  let words = ["apple", "banana", "cherry", "date"]

  // 枚举
  let enumerated = words.iter().enumerate().collect()
  inspect(enumerated, content="[(0, \"apple\"), (1, \"banana\"), (2, \"cherry\"), (3, \"date\")]")

  // 分组
  let grouped = words.iter().group_by(w => w.length()).collect()
  // 按长度分组

  // 压缩
  let numbers = [1, 2, 3, 4]
  let zipped = words.iter().zip(numbers.iter()).collect()
  inspect(zipped, content="[(\"apple\", 1), (\"banana\", 2), (\"cherry\", 3), (\"date\", 4)]")
}
```

#### 无限迭代器

```moonbit
///|
test "无限迭代器" {
  // 生成斐波那契数列
  let fib = @iter.unfold((0, 1), fn((a, b)) {
    Some((a, (b, a + b)))
  })

  let first_10_fib = fib.take(10).collect()
  inspect(first_10_fib, content="[0, 1, 1, 2, 3, 5, 8, 13, 21, 34]")

  // 重复元素
  let repeated = @iter.repeat(42).take(5).collect()
  inspect(repeated, content="[42, 42, 42, 42, 42]")

  // 范围
  let range = @iter.range(1, 6).collect()
  inspect(range, content="[1, 2, 3, 4, 5]")
}
```

## 工具类

### random - 随机数生成

```moonbit
///|
test "随机数生成" {
  let rng = @random.new()

  // 生成随机整数
  let random_int = rng.int()
  let bounded_int = rng.int_range(1, 100) // 1-99

  // 生成随机浮点数
  let random_double = rng.double() // 0.0-1.0
  let bounded_double = rng.double_range(0.0, 10.0)

  // 生成随机布尔值
  let random_bool = rng.bool()

  // 从数组中随机选择
  let choices = ["red", "green", "blue"]
  let random_choice = rng.choose(choices)

  // 打乱数组
  let numbers = [1, 2, 3, 4, 5]
  rng.shuffle(numbers)
  // numbers 现在被随机打乱
}
```

### ref - 引用类型

```moonbit
///|
test "引用类型" {
  // 创建可变引用
  let counter = @ref.new(0)

  // 读取值
  inspect(counter.val, content="0")

  // 修改值
  counter.val = 42
  inspect(counter.val, content="42")

  // 原子操作
  let old_value = counter.swap(100)
  inspect(old_value, content="42")
  inspect(counter.val, content="100")

  // 比较并交换
  let success = counter.compare_and_swap(100, 200)
  inspect(success, content="true")
  inspect(counter.val, content="200")
}
```

### quickcheck - 属性测试

```moonbit
///|
test "属性测试" {
  // 测试列表反转的性质
  @quickcheck.test(
    "reverse twice equals original",
    fn(list : Array[Int]) {
      let reversed_twice = list.copy()
      reversed_twice.reverse()
      reversed_twice.reverse()
      reversed_twice == list
    }
  )

  // 测试加法交换律
  @quickcheck.test(
    "addition is commutative",
    fn(a : Int, b : Int) {
      a + b == b + a
    }
  )

  // 测试字符串长度
  @quickcheck.test(
    "string concatenation length",
    fn(s1 : String, s2 : String) {
      (s1 + s2).length() == s1.length() + s2.length()
    }
  )
}
```

## 数值类型

### 整数类型

MoonBit Core 提供了多种整数类型：

```moonbit
///|
test "整数类型" {
  // 基础整数类型
  let i : Int = 42
  let u : UInt = 42U

  // 64位整数
  let i64 : Int64 = 42L
  let u64 : UInt64 = 42UL

  // 16位整数
  let i16 : Int16 = 42S
  let u16 : UInt16 = 42US

  // 字节类型
  let b : Byte = b'A'

  // 类型转换
  inspect(i.to_int64(), content="42L")
  inspect(i64.to_int(), content="42")
  inspect(b.to_int(), content="65")
}
```

### 浮点类型

```moonbit
///|
test "浮点类型" {
  let f : Float = 3.14
  let d : Double = 3.14159265359

  // 特殊值
  inspect(Double::infinity(), content="inf")
  inspect(Double::neg_infinity(), content="-inf")
  inspect(Double::nan().is_nan(), content="true")

  // 精度比较
  let a = 0.1 + 0.2
  let b = 0.3
  inspect(@math.abs(a - b) < 1e-10, content="true")
}
```

## 错误处理和调试

### 错误处理模式

```moonbit
///|
suberror MyError {
  InvalidInput(String)
  NetworkError(Int)
  ParseError
}

fn risky_operation(input : String) -> String raise MyError {
  if input.is_empty() {
    raise MyError::InvalidInput("输入不能为空")
  }
  if input.contains("error") {
    raise MyError::ParseError
  }
  "处理成功: " + input
}

test "错误处理" {
  // 使用 try? 转换为 Result
  let result1 = try? risky_operation("hello")
  inspect(result1, content="Ok(\"处理成功: hello\")")

  let result2 = try? risky_operation("")
  match result2 {
    Ok(_) => panic()
    Err(MyError::InvalidInput(msg)) => inspect(msg, content="输入不能为空")
    Err(_) => panic()
  }

  // 使用 try-catch 处理
  let result3 = risky_operation("error") catch {
    MyError::ParseError => "解析错误"
    MyError::InvalidInput(msg) => "输入错误: " + msg
    MyError::NetworkError(code) => "网络错误: " + code.to_string()
  }
  inspect(result3, content="解析错误")
}
```

### 调试和日志

```moonbit
///|
test "调试工具" {
  let data = [1, 2, 3, 4, 5]

  // 使用 inspect 调试
  inspect(data, content="[1, 2, 3, 4, 5]")

  // 使用 @json.inspect 查看复杂结构
  let complex_data = {
    "name": "MoonBit",
    "version": 1.0,
    "features": ["fast", "safe", "simple"]
  }
  @json.inspect(complex_data, content="{\"name\": \"MoonBit\", \"version\": 1, \"features\": [\"fast\", \"safe\", \"simple\"]}")

  // 条件调试
  let debug = true
  if debug {
    println("调试信息: 数据长度为 \{data.length()}")
  }
}
```

## 性能优化和最佳实践

### 内存管理

```moonbit
///|
test "内存优化" {
  // 使用 StringBuilder 而不是字符串拼接
  let sb = StringBuilder::new()
  for i in 0..<1000 {
    sb.write_string("item \{i}\n")
  }
  let result = sb.to_string()

  // 使用 ArrayView 避免复制
  let large_array = Array::makei(10000, i => i)
  let view = large_array[100:200] // 不复制数据

  // 预分配容量
  let optimized_array = Array::with_capacity(1000)
  for i in 0..<1000 {
    optimized_array.push(i)
  }
}
```

### 函数式编程优化

```moonbit
///|
test "函数式优化" {
  let data = Array::makei(10000, i => i)

  // 使用迭代器链式操作（惰性求值）
  let result = data
    .iter()
    .filter(x => x % 2 == 0)
    .map(x => x * x)
    .take(100)
    .collect()

  // 避免中间集合
  let sum = data
    .iter()
    .filter(x => x % 3 == 0)
    .fold(init=0, (acc, x) => acc + x)

  inspect(result.length(), content="100")
}
```

### 并发编程模式

```moonbit
///|
test "并发模式" {
  // 使用 Ref 进行线程安全的状态管理
  let shared_counter = @ref.new(0)

  // 原子操作
  let old_value = shared_counter.swap(10)
  let success = shared_counter.compare_and_swap(10, 20)

  // 使用队列进行任务分发
  let task_queue = @queue.new()
  task_queue.push("task1")
  task_queue.push("task2")

  while not(task_queue.is_empty()) {
    match task_queue.pop() {
      Some(task) => println("处理任务: \{task}")
      None => break
    }
  }
}
```

## 测试和质量保证

### 单元测试模式

```moonbit
///|
fn factorial(n : Int) -> Int {
  if n <= 1 { 1 } else { n * factorial(n - 1) }
}

test "阶乘函数测试" {
  // 边界条件测试
  inspect(factorial(0), content="1")
  inspect(factorial(1), content="1")

  // 正常情况测试
  inspect(factorial(5), content="120")
  inspect(factorial(10), content="3628800")

  // 性能测试
  let start_time = @time.now()
  let _ = factorial(20)
  let end_time = @time.now()
  let duration = end_time - start_time
  assert_true(duration < 1000) // 应该在1秒内完成
}
```

### 集成测试

```moonbit
///|
struct Calculator {
  mut value : Double
}

fn Calculator::new() -> Calculator {
  { value: 0.0 }
}

fn Calculator::add(self : Calculator, x : Double) -> Unit {
  self.value += x
}

fn Calculator::multiply(self : Calculator, x : Double) -> Unit {
  self.value *= x
}

fn Calculator::get_result(self : Calculator) -> Double {
  self.value
}

test "计算器集成测试" {
  let calc = Calculator::new()

  // 测试链式操作
  calc.add(10.0)
  calc.multiply(2.0)
  calc.add(5.0)

  inspect(calc.get_result(), content="25")

  // 测试重置
  calc.value = 0.0
  calc.add(1.0)
  inspect(calc.get_result(), content="1")
}
```

## 常见用例和模式

### 配置管理

```moonbit
///|
struct Config {
  host : String
  port : Int
  debug : Bool
  max_connections : Int
} derive(ToJson, FromJson)

fn load_config(json_str : String) -> Config raise {
  let json = @json.parse(json_str)
  Config::from_json(json)
}

test "配置管理" {
  let config_json = "{\"host\": \"localhost\", \"port\": 8080, \"debug\": true, \"max_connections\": 100}"

  let config = load_config(config_json)
  inspect(config.host, content="localhost")
  inspect(config.port, content="8080")
  inspect(config.debug, content="true")
  inspect(config.max_connections, content="100")
}
```

### 数据处理管道

```moonbit
///|
struct User {
  id : Int
  name : String
  age : Int
  active : Bool
} derive(Show)

test "数据处理管道" {
  let users = [
    { id: 1, name: "Alice", age: 25, active: true },
    { id: 2, name: "Bob", age: 30, active: false },
    { id: 3, name: "Charlie", age: 35, active: true },
    { id: 4, name: "Diana", age: 28, active: true }
  ]

  // 数据处理管道
  let active_adults = users
    .iter()
    .filter(user => user.active)
    .filter(user => user.age >= 25)
    .map(user => user.name)
    .collect()

  inspect(active_adults, content="[\"Alice\", \"Charlie\", \"Diana\"]")

  // 统计信息
  let avg_age = users
    .iter()
    .filter(user => user.active)
    .map(user => user.age)
    .fold(init=0, (sum, age) => sum + age) /
    users.iter().filter(user => user.active).count()

  inspect(avg_age, content="29")
}
```

### 缓存实现

```moonbit
///|
struct Cache[K : Hash + Eq, V] {
  mut data : @hashmap.HashMap[K, V]
  mut capacity : Int
}

fn Cache::new[K : Hash + Eq, V](capacity : Int) -> Cache[K, V] {
  { data: @hashmap.new(), capacity }
}

fn Cache::get[K : Hash + Eq, V](self : Cache[K, V], key : K) -> Option[V] {
  self.data.get(key)
}

fn Cache::put[K : Hash + Eq, V](self : Cache[K, V], key : K, value : V) -> Unit {
  if self.data.length() >= self.capacity {
    // 简单的 LRU 策略：删除第一个元素
    let first_key = self.data.to_array()[0].0
    self.data.remove(first_key)
  }
  self.data.set(key, value)
}

test "缓存实现" {
  let cache = Cache::new(2)

  cache.put("key1", "value1")
  cache.put("key2", "value2")

  inspect(cache.get("key1"), content="Some(\"value1\")")
  inspect(cache.get("key2"), content="Some(\"value2\")")

  // 超出容量
  cache.put("key3", "value3")
  inspect(cache.data.length(), content="2")
}
```

## 总结

MoonBit Core 标准库提供了丰富而完整的功能集合，涵盖了现代编程语言所需的各个方面：

### 最佳实践

1. **优先使用不可变数据结构**，需要时才使用可变版本
2. **利用迭代器链式操作**进行数据处理
3. **使用 Result 和 Option 类型**进行错误处理
4. **编写全面的测试**，包括单元测试和属性测试
5. **合理使用类型推导**，在需要时提供类型注解
