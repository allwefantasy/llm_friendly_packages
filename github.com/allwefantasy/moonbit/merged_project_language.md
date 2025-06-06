# MoonBit 项目：language

项目路径：`next/sources/language`

生成时间：2025-06-05 21:14:15

## 项目目录结构

```
language/
├── src
│   ├── attributes
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   ├── benchmark
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   ├── builtin
│   │   ├── __snapshot__
│   │   │   ├── byte_1
│   │   │   ├── string_1
│   │   │   ├── string_4
│   │   │   └── tuple_1
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   ├── controls
│   │   ├── __snapshot__
│   │   │   ├── for_loop_1
│   │   │   ├── for_loop_4
│   │   │   ├── for_loop_7
│   │   │   ├── for_loop_8
│   │   │   ├── while_loop_1
│   │   │   ├── while_loop_2
│   │   │   ├── while_loop_3
│   │   │   ├── while_loop_4
│   │   │   └── while_loop_5
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   ├── data
│   │   ├── __snapshot__
│   │   │   ├── enum_11
│   │   │   ├── enum_3
│   │   │   ├── enum_6
│   │   │   ├── enum_9
│   │   │   ├── newtype_2
│   │   │   ├── newtype_3
│   │   │   ├── struct_1
│   │   │   └── struct_4
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   ├── derive
│   │   ├── default.mbt
│   │   ├── eq_compare.mbt
│   │   ├── hash.mbt
│   │   ├── json.mbt
│   │   ├── moon.pkg.json
│   │   └── show.mbt
│   ├── error
│   │   ├── __snapshot__
│   │   │   └── error_9
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   ├── functions
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   ├── generics
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   ├── is
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   ├── iter
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   ├── main
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   ├── method
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   ├── method2
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   ├── misc
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   ├── operator
│   │   ├── __snapshot__
│   │   │   └── operator_3
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   ├── packages
│   │   ├── implement
│   │   │   ├── moon.pkg.json
│   │   │   └── top.mbt
│   │   ├── pkgA
│   │   │   ├── moon.pkg.json
│   │   │   └── top.mbt
│   │   ├── pkgB
│   │   │   ├── moon.pkg.json
│   │   │   └── top.mbt
│   │   ├── pkgC
│   │   │   ├── moon.pkg.json
│   │   │   └── top.mbt
│   │   ├── use_implement
│   │   │   ├── moon.pkg.json
│   │   │   └── top.mbt
│   │   └── virtual
│   │       ├── moon.pkg.json
│   │       ├── top.mbt
│   │       └── virtual.mbti
│   ├── pattern
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   ├── test
│   │   ├── __snapshot__
│   │   │   └── record_anything.txt
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   ├── trait
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   └── variable
│       ├── moon.pkg.json
│       └── top.mbt
├── .gitignore
├── LICENSE
├── moon.mod.json
└── README.md
```

## 文件统计

- 总文件数：84
- 文档文件：2 个
- 代码文件：57 个
- 文本文件：24 个
- 其他文件：1 个

## 文档文件

### 文件：`README.md`

```markdown
# moonbit-community/language

Covers everything mentioned in `language` section.
```

---

### 文件：`src/test/__snapshot__/record_anything.txt`

```text
Hello, world! And hello, MoonBit!
```

---

## 代码文件

### 文件：`moon.mod.json`

```json
{
  "name": "moonbit-community/language",
  "version": "0.1.0",
  "readme": "README.md",
  "repository": "",
  "license": "Apache-2.0",
  "keywords": [],
  "description": "",
  "source": "src"
}
```

---

### 文件：`src/attributes/moon.pkg.json`

```json
{
    "is-main": true,
    "warn-list": "-1-2-4-7-9-28"
}
```

---

### 文件：`src/attributes/top.mbt`

```moonbit
// start deprecated
#deprecated
pub fn foo() -> Unit {
  ...
}

#deprecated("Use Bar2 instead")
pub(all) enum Bar {
  Ctor1
  Ctor2
}
// end deprecated

// start visibility
// in @util package
#visibility(change_to="readonly", "Point will be readonly in the future.")
pub(all) struct Point {
  x : Int
  y : Int
}

#visibility(change_to="abstract", "Use new_text and new_binary instead.")
pub(all) enum Resource {
  Text(String)
  Binary(Bytes)
}

pub fn new_text(str : String) -> Resource {
  ...
}

pub fn new_binary(bytes : Bytes) -> Resource {
  ...
}

// in another package
fn main {
  let p = Point::{ x: 1, y: 2 } // warning 
  let { x, y } = p // ok
  println(p.x) // ok
  match Resource::Text("") { // warning
    Text(s) => ... // waning
    Binary(b) => ... // warning
  }
}

// end visibility
```

---

### 文件：`src/benchmark/moon.pkg.json`

```json
{
  "warn-list": "-1" 
}
```

---

### 文件：`src/benchmark/top.mbt`

```moonbit
// start bench 1
fn fib(n : Int) -> Int {
  if n < 2 {
    return n
  }
  return fib(n - 1) + fib(n - 2)
}

test (b : @bench.T) {
  b.bench(fn() { b.keep(fib(20)) })
}
// end bench 1

// start bench 2
test (b : @bench.T) {
  b.bench(fn() { b.keep(fib(20)) }, count=20)
}
// end bench 2

// start bench 3
fn fast_fib(n : Int) -> Int {
  if n < 2 {
    return n
  } else {
    let mut a = 0
    let mut b = 1
    for i = 2; i <= n; i = i + 1 {
      let t = a + b
      a = b
      b = t
    }
    b
  }
}

test (b : @bench.T) {
  b.bench(name="naive_fib", fn() { b.keep(fib(20)) })
  b.bench(name="fast_fib", fn() { b.keep(fast_fib(20)) })
}
// end bench 3

// start bench 4
fn collect_bench() -> Unit {
  let mut saved = 0
  let summary : @bench.Summary = @bench.single_bench(name="fib", fn() {
    saved = fib(20)
  })
  println(saved)
  println(summary.to_json().stringify(escape_slash=true, indent=4))
}
// end bench 4
```

---

### 文件：`src/builtin/moon.pkg.json`

```json
{
    "warn-list": "-1-2"
}
```

---

### 文件：`src/builtin/top.mbt`

```moonbit
let boolean : Unit = {
  // start boolean 1
  let a = true
  let b = false
  let c = a && b
  let d = a || b
  let e = not(a)
  // end boolean 1

}

let number : Unit = {
  // start number 1
  let a = 1234
  let b : Int = 1_000_000 + a
  let unsigned_num       : UInt   = 4_294_967_295U
  let large_num          : Int64  = 9_223_372_036_854_775_807L
  let unsigned_large_num : UInt64 = 18_446_744_073_709_551_615UL
  // end number 1

  // start number 2
  let bin = 0b110010
  let another_bin = 0B110010
  // end number 2

  // start number 3
  let octal = 0o1234
  let another_octal = 0O1234
  // end number 3

  // start number 4
  let hex = 0XA
  let another_hex = 0xA_B_C
  // end number 4

  // start number 6
  let double = 3.14 // Double
  let float : Float = 3.14
  let float2 = (3.14 : Float)
  // end number 6

  // start number 7
  let hex_double = 0x1.2P3 // (1.0 + 2 / 16) * 2^(+3) == 9
  // end number 7

  // start number 5
  let int : Int = 42
  let uint : UInt = 42
  let int64 : Int64 = 42
  let double : Double = 42
  let float : Float = 42
  let bigint : BigInt = 42
  // end number 5

}

test "string 1" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start string 1
  let a = "兔rabbit"
  println(a.char_at(0))
  println(a.char_at(1))
  let b =
    #| Hello
    #| MoonBit\n
    #|
  println(b)
  // end string 1
  t.snapshot!(filename="string_1")
}

let string : Unit = {
  // start string 3
  let x = 42
  println("The answer is \{x}")
  // end string 3
}

test "string 4" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start string 4
  let lang = "MoonBit"
  let str =
    #| Hello
    #| ---
    $| \{lang}\n
    #| ---
  println(str)
  // end string 4
  t.snapshot!(filename="string_4")
}

// start string 5
test {
  let c : Char = '中'
  let s : String = [c, '文']
  inspect!(s, content="中文")
}
// end string 5

let char : Unit = {
  // start char 1
  let a : Char = 'A'
  let b = '兔'
  let zero = '\u{30}'
  let zero = '\u0030'
  // end char 1

}

// start char 2
test {
  let s : String = "hello"
  // charcode_at has type Int 
  let b = s.charcode_at(0) - 'a'
  inspect!(b, content="7")
}
// end char 2

test "byte 1" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start byte 1
  let b1 : Byte = b'a'
  println(b1.to_int())
  let b2 = b'\xff'
  println(b2.to_int())
  // end byte 1
  t.snapshot!(filename="byte_1")
}

// start byte 2
test {
  let b1 : Bytes = b"abcd"
  let b2 = b"\x61\x62\x63\x64"
  assert_eq!(b1, b2)
}
// end byte 2

// start bytes 1
test {
  let b : Byte = '\xFF'
  let bs : Bytes = [b, '\x01']
  inspect!(
    bs,
    content=
      #|b"\xff\x01"
    ,
  )
}
// end bytes 1

// start buffer 1
test "buffer 1" {
  let buf : @buffer.T = @buffer.new()
  buf.write_bytes(b"Hello")
  buf.write_byte(b'!')
  assert_eq!(buf.contents(), b"Hello!")
}
// end buffer 1

test "tuple 1" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start tuple 1
  fn pack(
    a : Bool,
    b : Int,
    c : String,
    d : Double
  ) -> (Bool, Int, String, Double) {
    (a, b, c, d)
  }

  let quad = pack(false, 100, "text", 3.14)
  let (bool_val, int_val, str, float_val) = quad
  println("\{bool_val} \{int_val} \{str} \{float_val}")
  // end tuple 1
  t.snapshot!(filename="tuple_1")
}

// start tuple 2
test {
  let t = (1, 2)
  let (x1, y1) = t
  let x2 = t.0
  let y2 = t.1
  assert_eq!(x1, x2)
  assert_eq!(y1, y2)
}
// end tuple 2

let array : Unit = {
  // start array 1
  let numbers = [1, 2, 3, 4]
  // end array 1

}

// start array 2
test {
  let numbers = [1, 2, 3, 4]
  let a = numbers[2]
  numbers[3] = 5
  let b = a + numbers[3]
  assert_eq!(b, 8)
}
// end array 2

// start array 3
let fixed_array_1 : FixedArray[Int] = [1, 2, 3]

let fixed_array_2 = ([1, 2, 3] : FixedArray[Int])

let array_3 = [1, 2, 3] // Array[Int]
// end array 3

// start array pitfall
test {
  let two_dimension_array = FixedArray::make(10, FixedArray::make(10, 0))
  two_dimension_array[0][5] = 10
  assert_eq!(two_dimension_array[5][5], 10)
}
// end array pitfall

// start array pitfall solution
test {
  let two_dimension_array = FixedArray::makei(10, fn(_i) {
    FixedArray::make(10, 0)
  })
  two_dimension_array[0][5] = 10
  assert_eq!(two_dimension_array[5][5], 0)
}
// end array pitfall solution

// start map 1
let map : Map[String, Int] = { "x": 1, "y": 2, "z": 3 }
// end map 1

// start json 1
let moon_pkg_json_example : Json = {
  "import": ["moonbitlang/core/builtin", "moonbitlang/core/coverage"],
  "test-import": ["moonbitlang/core/random"],
}
// end json 1

// start ref 1
let a : Ref[Int] = { val: 100 }

test {
  a.val = 200
  assert_eq!(a.val, 200)
  a.val += 1
  assert_eq!(a.val, 201)
}
// end ref 1

// start option result 1
test {
  let a : Int? = None
  let b : Option[Int] = Some(42)
  let c : Result[Int, String] = Ok(42)
  let d : Result[Int, String] = Err("error")
  match a {
    Some(_) => assert_true!(false)
    None => assert_true!(true)
  }
  match d {
    Ok(_) => assert_true!(false)
    Err(_) => assert_true!(true)
  }
}
// end option result 1

// start overloaded literal 1
fn expect_double(x : Double) -> Unit {
  
}

test {
  let x = 1 // type of x is Int
  let y : Double = 1 
  expect_double(1) 
}
// end overloaded literal 1
```

---

### 文件：`src/controls/moon.pkg.json`

```json
{
    "warn-list": "-1-2-4-6-7"
}
```

---

### 文件：`src/controls/top.mbt`

```moonbit
fn a() -> Int {
  let x = 1
  let y = 1
  let z = 1
  let expr1 = 1
  let expr2 = 1
  let expr3 = 1
  // start conditional expressions 1
  if x == y {
    expr1
  } else if x == z {
    expr2
  } else {
    expr3
  }
  // end conditional expressions 1
}

fn c() -> Unit {
  let size = 0
  // start conditional expressions 3
  let initial = if size < 1 { 1 } else { size }
  // end conditional expressions 3
}

test "while loop 1" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start while loop 1
  let mut i = 5
  while i > 0 {
    println(i)
    i = i - 1
  }
  // end while loop 1
  t.snapshot!(filename="while_loop_1")
}

test "while loop 2" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start while loop 2
  let mut i = 5
  while i > 0 {
    i = i - 1
    if i == 4 {
      continue
    }
    if i == 1 {
      break
    }
    println(i)
  }
  // end while loop 2
  t.snapshot!(filename="while_loop_2")
}

test "while loop 3" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start while loop 3
  let mut i = 2
  while i > 0 {
    println(i)
    i = i - 1
  } else {
    println(i)
  }
  // end while loop 3
  t.snapshot!(filename="while_loop_3")
}

test "while loop 4" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start while loop 4
  let mut i = 10
  let r = while i > 0 {
    i = i - 1
    if i % 2 == 0 {
      break 5
    }
  } else {
    7
  }
  println(r)
  // end while loop 4
  t.snapshot!(filename="while_loop_4")
}

test "while loop 5" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start while loop 5
  let mut i = 10
  let r = while i > 0 {
    i = i - 1
  } else {
    7
  }
  println(r)
  // end while loop 5
  t.snapshot!(filename="while_loop_5")
}

test "for loop 1" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start for loop 1
  for i = 0; i < 5; i = i + 1 {
    println(i)
  }
  // end for loop 1
  t.snapshot!(filename="for_loop_1")
}

fn d() -> Unit {
  // start for loop 2
  for i = 0, j = 0; i + j < 100; i = i + 1, j = j + 1 {
    println(i)
  }
  // end for loop 2
}

fn infinite_loop() -> Unit {
  // start for loop 3
  for i = 1; ; i = i + 1 {
    println(i)
  }
  for {
    println("loop forever")
  }
  // end for loop 3
}

test "for loop 4" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start for loop 4
  let sum = for i = 1, acc = 0; i <= 6; i = i + 1 {
    if i % 2 == 0 {
      println("even: \{i}")
      continue i + 1, acc + i
    }
  } else {
    acc
  }
  println(sum)
  // end for loop 4
  t.snapshot!(filename="for_loop_4")
}

fn e() -> Unit {
  // start for loop 5
  for x in [1, 2, 3] {
    println(x)
  }
  // end for loop 5
  // start for loop 6
  for k, v in { "x": 1, "y": 2, "z": 3 } {
    println(k)
    println(v)
  }
  // end for loop 6
  // start for loop 7
  for index, elem in [4, 5, 6] {
    let i = index + 1
    println("The \{i}-th element of the array is \{elem}")
  }
  // end for loop 7
}

test "for loop 7" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start for loop 7
  for index, elem in [4, 5, 6] {
    let i = index + 1
    println("The \{i}-th element of the array is \{elem}")
  }
  // end for loop 7
  t.snapshot!(filename="for_loop_7")
}

test "for loop 8" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start for loop 8
  let map = { "x": 1, "y": 2, "z": 3, "w": 4 }
  for k, v in map {
    if k == "y" {
      continue
    }
    println("\{k}, \{v}")
    if k == "z" {
      break
    }
  }
  // end for loop 8
  t.snapshot!(filename="for_loop_8")
}

// start for loop 9
test {
  fn sum(xs : @immut/list.T[Int]) -> Int {
    loop xs, 0 {
      Nil, acc => break acc // <=> Nil, acc => acc
      Cons(x, rest), acc => continue rest, x + acc
    }
  }

  assert_eq!(sum(Cons(1, Cons(2, Cons(3, Nil)))), 6)
}
// end for loop 9

// start for loop 10
test {
  let mut i = 0
  for j in 0..<10 {
    i += j
  }
  assert_eq!(i, 45)
  let mut k = 0
  for l in 0..=10 {
    k += l
  }
  assert_eq!(k, 55)
}
// end for loop 10

// start loop label
test "break label" {
  let mut count = 0
  let xs = [1, 2, 3]
  let ys = [4, 5, 6]
  let res = outer~: for i in xs {
    for j in ys {
      count = count + i
      break outer~ j
    }
  } else {
    -1
  }
  assert_eq!(res, 4)
  assert_eq!(count, 1)
}

test "continue label" {
  let mut count = 0
  let init = 10
  let res = outer~: loop init {
    0 => 42
    i =>
      for {
        count = count + 1
        continue outer~ i - 1
      }
  }
  assert_eq!(res, 42)
  assert_eq!(count, 10)
}
// end loop label

// start guard 1
fn guarded_get(array : Array[Int], index : Int) -> Int? {
  guard index >= 0 && index < array.length() else { None }
  Some(array[index])
}

test {
  inspect!(guarded_get([1, 2, 3], -1), content="None")
}
// end guard 1

fn process(string : String) -> String {
  string
}

// start guard 2
enum Resource {
  Folder(Array[String])
  PlainText(String)
  JsonConfig(Json)
}

fn getProcessedText(
  resources : Map[String, Resource],
  path : String
) -> String!Error {
  guard resources.get(path) is Some(resource) else {
    fail!("\{path} not found")
  }
  guard resource is PlainText(text) else { fail!("\{path} is not plain text") }
  process(text)
}
// end guard 2

fn g() -> Unit {
  let condition = true
  let expr = Some(5)
  // start guard 3
  guard condition  // <=> guard condition else { panic() }
  guard expr is Some(x)
  // <=> guard expr is Some(x) else { _ => panic() }
  // end guard 3
}

// start match 1
fn decide_sport(weather : String, humidity : Int) -> String {
  match weather {
    "sunny" => "tennis"
    "rainy" => if humidity > 80 { "swimming" } else { "football" }
    _ => "unknown"
  }
}

test {
  assert_eq!(decide_sport("sunny", 0), "tennis")
}
// end match 1
```

---

### 文件：`src/data/moon.pkg.json`

```json
{
    "warn-list": "-1-2-3-4-6-7-9-28"
}
```

---

### 文件：`src/data/top.mbt`

```moonbit
// start struct 1
struct User {
  id : Int
  name : String
  mut email : String
}
// end struct 1

test "struct 1" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start struct 2
  let u = User::{ id: 0, name: "John Doe", email: "john@doe.com" }
  u.email = "john@doe.name"
  //! u.id = 10
  println(u.id)
  println(u.name)
  println(u.email)
  // end struct 2
  t.snapshot!(filename="struct_1")
}

let struct_3 : Unit = {
  // start struct 3
  let name = "john"
  let email = "john@doe.com"
  let u = User::{ id: 0, name, email }
  // end struct 3
  // start struct 5
  let u2 = { id: 0, name, email }
  // end struct 5

}

test "struct 4" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start struct 4
  let user = { id: 0, name: "John Doe", email: "john@doe.com" }
  let updated_user = { ..user, email: "john@doe.name" }
  println(
    $|{ id: \{user.id}, name: \{user.name}, email: \{user.email} }
    $|{ id: \{updated_user.id}, name: \{updated_user.name}, email: \{updated_user.email} }
    ,
  )
  // end struct 4
  t.snapshot!(filename="struct_4")
}

// start enum 1
/// An enum type that represents the ordering relation between two values,
/// with three cases "Smaller", "Greater" and "Equal"
enum Relation {
  Smaller
  Greater
  Equal
}
// end enum 1

test "enum 3" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start enum 2
  /// compare the ordering relation between two integers
  fn compare_int(x : Int, y : Int) -> Relation {
    if x < y {
      // when creating an enum, if the target type is known, 
      // you can write the constructor name directly
      Smaller
    } else if x > y {
      // but when the target type is not known,
      // you can always use `TypeName::Constructor` to create an enum unambiguously
      Relation::Greater
    } else {
      Equal
    }
  }

  /// output a value of type `Relation`
  fn print_relation(r : Relation) -> Unit {
    // use pattern matching to decide which case `r` belongs to
    match r {
      // during pattern matching, if the type is known, 
      // writing the name of constructor is sufficient
      Smaller => println("smaller!")
      // but you can use the `TypeName::Constructor` syntax 
      // for pattern matching as well
      Relation::Greater => println("greater!")
      Equal => println("equal!")
    }
  }
  // end enum 2
  // start enum 3
  print_relation(compare_int(0, 1))
  print_relation(compare_int(1, 1))
  print_relation(compare_int(2, 1))
  // end enum 3
  t.snapshot!(filename="enum_3")
}

// start enum 4
enum List {
  Nil
  // constructor `Cons` carries additional payload: the first element of the list,
  // and the remaining parts of the list
  Cons(Int, List)
}
// end enum 4

test "enum 6" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start enum 5
  // In addition to binding payload to variables,
  // you can also continue matching payload data inside constructors.
  // Here's a function that decides if a list contains only one element
  fn is_singleton(l : List) -> Bool {
    match l {
      // This branch only matches values of shape `Cons(_, Nil)`, 
      // i.e. lists of length 1
      Cons(_, Nil) => true
      // Use `_` to match everything else
      _ => false
    }
  }

  fn print_list(l : List) -> Unit {
    // when pattern-matching an enum with payload,
    // in additional to deciding which case a value belongs to
    // you can extract the payload data inside that case
    match l {
      Nil => println("nil")
      // Here `x` and `xs` are defining new variables 
      // instead of referring to existing variables,
      // if `l` is a `Cons`, then the payload of `Cons` 
      // (the first element and the rest of the list)
      // will be bind to `x` and `xs
      Cons(x, xs) => {
        println("\{x},")
        print_list(xs)
      }
    }
  }
  // end enum 5
  // start enum 6
  // when creating values using `Cons`, the payload of by `Cons` must be provided
  let l : List = Cons(1, Cons(2, Nil))
  println(is_singleton(l))
  print_list(l)
  // end enum 6
  t.snapshot!(filename="enum_6")
}

// start enum 7
enum E {
  // `x` and `y` are labelled argument
  C(x~ : Int, y~ : Int)
}
// end enum 7

test "enum 9" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start enum 8
  // pattern matching constructor with labelled arguments
  fn f(e : E) -> Unit {
    match e {
      // `label=pattern`
      C(x=0, y=0) => println("0!")
      // `x~` is an abbreviation for `x=x`
      // Unmatched labelled arguments can be omitted via `..`
      C(x~, ..) => println(x)
    }
  }
  // end enum 8
  // start enum 9
  f(C(x=0, y=0))
  let x = 0
  f(C(x~, y=1)) // <=> C(x=x, y=1)
  // end enum 9
  t.snapshot!(filename="enum_9")
}

// start enum 10
enum Object {
  Point(x~ : Double, y~ : Double)
  Circle(x~ : Double, y~ : Double, radius~ : Double)
}

type! NotImplementedError  derive(Show)

fn distance_with(self : Object, other : Object) -> Double!NotImplementedError {
  match (self, other) {
    // For variables defined via `Point(..) as p`,
    // the compiler knows it must be of constructor `Point`,
    // so you can access fields of `Point` directly via `p.x`, `p.y` etc.
    (Point(_) as p1, Point(_) as p2) => {
      let dx = p2.x - p1.x
      let dy = p2.y - p1.y
      (dx * dx + dy * dy).sqrt()
    }
    (Point(_), Circle(_)) | (Circle(_), Point(_)) | (Circle(_), Circle(_)) =>
      raise NotImplementedError
  }
}
// end enum 10

test "enum 11" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start enum 11
  let p1 : Object = Point(x=0, y=0)
  let p2 : Object = Point(x=3, y=4)
  let c1 : Object = Circle(x=0, y=0, radius=2)
  try {
    println(p1.distance_with!(p2))
    println(p1.distance_with!(c1))
  } catch {
    e => println(e)
  }
  // end enum 11
  t.snapshot!(filename="enum_11")
}

// start enum 12
// A set implemented using mutable binary search tree.
struct Set[X] {
  mut root : Tree[X]
}

fn[X : Compare] Set::insert(self : Set[X], x : X) -> Unit {
  self.root = self.root.insert(x, parent=Nil)
}

// A mutable binary search tree with parent pointer
enum Tree[X] {
  Nil
  // only labelled arguments can be mutable
  Node(
    mut value~ : X,
    mut left~ : Tree[X],
    mut right~ : Tree[X],
    mut parent~ : Tree[X]
  )
}

// In-place insert a new element to a binary search tree.
// Return the new tree root
fn[X : Compare] Tree::insert(
  self : Tree[X],
  x : X,
  parent~ : Tree[X]
) -> Tree[X] {
  match self {
    Nil => Node(value=x, left=Nil, right=Nil, parent~)
    Node(_) as node => {
      let order = x.compare(node.value)
      if order == 0 {
        // mutate the field of a constructor
        node.value = x
      } else if order < 0 {
        // cycle between `node` and `node.left` created here
        node.left = node.left.insert(x, parent=node)
      } else {
        node.right = node.right.insert(x, parent=node)
      }
      // The tree is non-empty, so the new root is just the original tree
      node
    }
  }
}
// end enum 12

// start newtype 1
// `UserId` is a fresh new type different from `Int`, 
// and you can define new methods for `UserId`, etc.
// But at the same time, the internal representation of `UserId` 
// is exactly the same as `Int`
type UserId Int

type UserName String
// end newtype 1

test "newtype 2" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start newtype 2
  let id : UserId = UserId(1)
  let name : UserName = UserName("John Doe")
  let UserId(uid) = id // uid : Int
  let UserName(uname) = name // uname: String
  println(uid)
  println(uname)
  // end newtype 2
  t.snapshot!(filename="newtype_2")
}

test "newtype 3" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start newtype 3
  let id : UserId = UserId(1)
  let uid : Int = id._
  println(uid)
  // end newtype 3
  t.snapshot!(filename="newtype_3")
}

// start typealias 1
pub typealias Index = Int

// type alias are private by default
typealias MapString[X] = Map[String, X]
// end typealias 1

// start local-type 1
fn[T : Show] toplevel(x : T) -> Unit {
  enum LocalEnum {
    A(T)
    B(Int)
  } derive(Show)
  struct LocalStruct {
    a : (String, T)
  } derive(Show)
  type LocalNewtype T derive(Show)
  ...
}
// end local-type 1
```

---

### 文件：`src/derive/default.mbt`

```moonbit
// start derive default struct
struct DeriveDefault {
  x : Int
  y : String?
} derive(Default, Eq, Show)

test "derive default struct" {
  let p = DeriveDefault::default()
  assert_eq!(p, DeriveDefault::{ x: 0, y: None })
}
// end derive default struct

// start derive default enum
enum DeriveDefaultEnum {
  Case1(Int)
  Case2(label~ : String)
  Case3
} derive(Default, Eq, Show)

test "derive default enum" {
  assert_eq!(DeriveDefaultEnum::default(), DeriveDefaultEnum::Case3)
}
// end derive default enum
```

---

### 文件：`src/derive/eq_compare.mbt`

```moonbit
// start derive eq_compare struct
struct DeriveEqCompare {
  x : Int
  y : Int
} derive(Eq, Compare)

test "derive eq_compare struct" {
  let p1 = DeriveEqCompare::{ x: 1, y: 2 }
  let p2 = DeriveEqCompare::{ x: 2, y: 1 }
  let p3 = DeriveEqCompare::{ x: 1, y: 2 }
  let p4 = DeriveEqCompare::{ x: 1, y: 3 }

  // Eq
  assert_eq!(p1 == p2, false)
  assert_eq!(p1 == p3, true)
  assert_eq!(p1 == p4, false)

  assert_eq!(p1 != p2, true)
  assert_eq!(p1 != p3, false)
  assert_eq!(p1 != p4, true)

  // Compare
  assert_eq!(p1 < p2, true)
  assert_eq!(p1 < p3, false)
  assert_eq!(p1 < p4, true)
  assert_eq!(p1 > p2, false)
  assert_eq!(p1 > p3, false)
  assert_eq!(p1 > p4, false)
  assert_eq!(p1 <= p2, true)
  assert_eq!(p1 >= p2, false)
}
// end derive eq_compare struct

// start derive eq_compare enum
enum DeriveEqCompareEnum {
  Case1(Int)
  Case2(label~ : String)
  Case3
} derive(Eq, Compare)

test "derive eq_compare enum" {
  let p1 = DeriveEqCompareEnum::Case1(42)
  let p2 = DeriveEqCompareEnum::Case1(43)
  let p3 = DeriveEqCompareEnum::Case1(42)
  let p4 = DeriveEqCompareEnum::Case2(label="hello")
  let p5 = DeriveEqCompareEnum::Case2(label="world")
  let p6 = DeriveEqCompareEnum::Case2(label="hello")
  let p7 = DeriveEqCompareEnum::Case3

  // Eq
  assert_eq!(p1 == p2, false)
  assert_eq!(p1 == p3, true)
  assert_eq!(p1 == p4, false)

  assert_eq!(p1 != p2, true)
  assert_eq!(p1 != p3, false)
  assert_eq!(p1 != p4, true)

  // Compare
  assert_eq!(p1 < p2, true) // 42 < 43
  assert_eq!(p1 < p3, false)
  assert_eq!(p1 < p4, true) // Case1 < Case2
  assert_eq!(p4 < p5, true)
  assert_eq!(p4 < p6, false)
  assert_eq!(p4 < p7, true) // Case2 < Case3
}
// end derive eq_compare enum
```

---

### 文件：`src/derive/hash.mbt`

```moonbit
// start derive hash struct
struct DeriveHash {
  x : Int
  y : String?
} derive(Hash, Eq, Show)

test "derive hash struct" {
  let hs = @hashset.new()
  hs.add(DeriveHash::{ x: 123, y: None })
  hs.add(DeriveHash::{ x: 123, y: None })
  assert_eq!(hs.size(), 1)
  hs.add(DeriveHash::{ x: 123, y: Some("456") })
  assert_eq!(hs.size(), 2)
}
// end derive hash struct
```

---

### 文件：`src/derive/json.mbt`

```moonbit
// start json basic
struct JsonTest1 {
  x : Int
  y : Int
} derive(FromJson, ToJson, Eq, Show)

enum JsonTest2 {
  A(x~ : Int)
  B(x~ : Int, y~ : Int)
} derive(FromJson, ToJson, Eq, Show)

test "json basic" {
  let input = JsonTest1::{ x: 123, y: 456 }
  let expected : Json = { "x": 123, "y": 456 }
  assert_eq!(input.to_json(), expected)
  assert_eq!(@json.from_json!(expected), input)

  let input = JsonTest2::A(x=123)
  let expected : Json = { "$tag": "A", "x": 123 }
  assert_eq!(input.to_json(), expected)
  assert_eq!(@json.from_json!(expected), input)
}
// end json basic

// start json args
struct JsonTest3 {
  x : Int
  y : Int
} derive (
  FromJson(fields(x(rename="renamedX"))),
  ToJson(fields(x(rename="renamedX"))),
  Eq,
  Show,
)

enum JsonTest4 {
  A(x~ : Int)
  B(x~ : Int, y~ : Int)
} derive (
  FromJson(rename_fields="SCREAMING_SNAKE_CASE", repr(ext_tagged)),
  ToJson(rename_fields="SCREAMING_SNAKE_CASE", repr(ext_tagged)),
  Eq,
  Show,
)

test "json args" {
  let input = JsonTest3::{ x: 123, y: 456 }
  let expected : Json = { "renamedX": 123, "y": 456 }
  assert_eq!(input.to_json(), expected)
  assert_eq!(@json.from_json!(expected), input)

  let input = JsonTest4::A(x=123)
  let expected : Json = { "A": { "X": 123 } }
  assert_eq!(input.to_json(), expected)
  assert_eq!(@json.from_json!(expected), input)
}
// end json args
```

---

### 文件：`src/derive/moon.pkg.json`

```json
{
  "warn-list": "-4-6"
}
```

---

### 文件：`src/derive/show.mbt`

```moonbit
// start derive show struct
struct MyStruct {
  x : Int
  y : Int
} derive(Show)

test "derive show struct" {
  let p = MyStruct::{ x: 1, y: 2 }
  assert_eq!(Show::to_string(p), "{x: 1, y: 2}")
}
// end derive show struct

// start derive show enum
enum MyEnum {
  Case1(Int)
  Case2(label~ : String)
  Case3
} derive(Show)

test "derive show enum" {
  assert_eq!(Show::to_string(MyEnum::Case1(42)), "Case1(42)")
  assert_eq!(
    Show::to_string(MyEnum::Case2(label="hello")),
    "Case2(label=\"hello\")",
  )
  assert_eq!(Show::to_string(MyEnum::Case3), "Case3")
}
// end derive show enum
```

---

### 文件：`src/error/moon.pkg.json`

```json
{
  "warn-list": "-1-2-3-4-6-15-24-28"
}
```

---

### 文件：`src/error/top.mbt`

```moonbit
// start error 1
type! E1 Int // error type E1 has one constructor E1 with an Int payload

type! E2  // error type E2 has one constructor E2 with no payload

type! E3 { // error type E3 has three constructors like a normal enum type
  A
  B(Int, x~ : String)
  C(mut x~ : String, Char, y~ : Bool)
}
// end error 1

// start error 2
type! DivError String

fn div(x : Int, y : Int) -> Int!DivError {
  if y == 0 {
    raise DivError("division by zero")
  }
  x / y
}
// end error 2

impl Show for DivError with output(self, logger) {
  match self {
    DivError(e) => Show::output(e, logger)
  }
}

let signature : Unit = {
  // start error 3
  fn f() -> Unit! {
    ...
  }

  fn g!() -> Unit {
    ...
  }

  fn h() -> Unit!Error {
    ...
  }
  // end error 3

}

// start error 4
type! IntError Int

fn h(f : (Int) -> Int!, x : Int) -> Unit {
  ...
}

fn g() -> Unit {
  let _ = h(fn! { x => raise IntError(x) }, 0)
  let _ = h(fn!(x) { raise IntError(x) }, 0)

}
// end error 4

// start error 5
// Result::unwrap_or_error
fn[T, E : Error] unwrap_or_error(result : Result[T, E]) -> T!E {
  match result {
    Ok(x) => x
    Err(e) => raise e
  }
}
// end error 5

test {
  (Ok(1) : Result[Int, Error]).unwrap_or_error!() |> ignore
}

// start error 6
fn f(e : Error) -> Unit {
  match e {
    E2 => println("E2")
    A => println("A")
    B(i, x~) => println("B(\{i}, \{x})")
    _ => println("unknown error")
  }
}
// end error 6

// start error 7
fn div_reraise(x : Int, y : Int) -> Int!DivError {
  div(x, y) + div!(x, y) // Rethrow the error if `div` raised an error
}
// end error 7

// start error 8
test {
  let res = div?(6, 3)
  inspect!(res, content="Ok(2)")
  let res = try? div(6, 0) * div(6, 3)
  inspect!(
    res,
    content=
      #|Err("division by zero")
    ,
  )
}
// end error 8

test "error 9" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start error 9
  try div!(42, 0) catch {
    DivError(s) => println(s)
  } else {
    v => println(v)
  }
  // end error 9
  t.snapshot!(filename="error_9")
}

fn error() -> Unit {
  // start error 10
  try println(div!(42, 0)) catch {
    _ => println("Error")
  }
  // end error 10

  // start error 11
  let a = try div!(42, 0) catch {
    _ => 0
  }
  println(a)
  // end error 11
}

fn catch_() -> Unit! {
  // start error 13
  fn f1() -> Unit!E1 {
    ...
  }

  fn f2() -> Unit!E2 {
    ...
  }

  try {
    f1!()
    f2!()
  } catch {
    E1(_) => ...
    E2 => ...
    _ => ...
  }
  // end error 13
  // start error 14
  try {
    f1!()
    f2!()
  } catch! {
    E1(_) => ...
  }
  // end error 14
}

// start custom error conversion
type! CustomError UInt
test {
  let e : Error = CustomError(42)
  guard e is CustomError(m)
  assert_eq!(m, 42)
}
// end custom error conversion
```

---

### 文件：`src/functions/moon.pkg.json`

```json
{
    "warn-list": "-1-2-4-7-9-28"
}
```

---

### 文件：`src/functions/top.mbt`

```moonbit
// start expression
fn foo() -> Int {
  let x = 1
  x + 1
}

fn bar() -> Int {
  let x = 1
  //! x + 1
  x + 2
}
// end expression

// start top-level functions
fn add3(x : Int, y : Int, z : Int) -> Int {
  x + y + z
}
// end top-level functions

// start function application 1
test {
  let add3 = fn(x, y, z) { x + y + z }
  assert_eq!(add3(1, 2, 7), 10)
}
// end function application 1

// start function application 2
test {
  let f = fn(x) { x + 1 }
  let g = fn(x) { x + 2 }
  let w = (if true { f } else { g })(3)
  assert_eq!(w, 4)
}
// end function application 2

// start partial application 1
fn add(x : Int, y : Int) -> Int {
  x + y
}

test {
  let add10 : (Int) -> Int = add(10, _)
  println(add10(5)) // prints 15
  println(add10(10)) // prints 20
}
// end partial application 1

// start local functions 1
fn local_1() -> Int {
  fn inc(x) { // named as `inc`
    x + 1
  }
  // anonymous, instantly applied to integer literal 6
  (fn(x) { x + inc(2) })(6)
}

test {
  assert_eq!(local_1(), 9)
}
// end local functions 1

// start local functions 2
let global_y = 3

fn local_2(x : Int) -> (Int, Int) {
  fn inc() {
    x + 1
  }

  fn four() {
    global_y + 1
  }

  (inc(), four())
}

test {
  assert_eq!(local_2(3), (4, 4))
}
// end local functions 2

// start local functions 3
let extract : (Int?, Int) -> Int = fn {
  Some(x), _ => x
  None, default => default
}
// end local functions 3

// start labelled arguments 1
fn labelled_1(arg1~ : Int, arg2~ : Int) -> Int {
  arg1 + arg2
}
// end labelled arguments 1

// start labelled arguments 2
test {
  let arg1 = 1
  assert_eq!(labelled_1(arg2=2, arg1~), 3)
}
// end labelled arguments 2

// start optional arguments 1
fn optional(opt~ : Int = 42) -> Int {
  opt
}

test {
  assert_eq!(optional(), 42)
  assert_eq!(optional(opt=0), 0)
}
// end optional arguments 1

// start optional arguments 2
fn incr(counter~ : Ref[Int] = { val: 0 }) -> Ref[Int] {
  counter.val = counter.val + 1
  counter
}

test {
  inspect!(incr(), content="{val: 1}")
  inspect!(incr(), content="{val: 1}")
  let counter : Ref[Int] = { val: 0 }
  inspect!(incr(counter~), content="{val: 1}")
  inspect!(incr(counter~), content="{val: 2}")
}
// end optional arguments 2

// start optional arguments 3
let default_counter : Ref[Int] = { val: 0 }

fn incr_2(counter~ : Ref[Int] = default_counter) -> Int {
  counter.val = counter.val + 1
  counter.val
}

test {
  assert_eq!(incr_2(), 1)
  assert_eq!(incr_2(), 2)
}
// end optional arguments 3

// start optional arguments 4
fn[X] sub_array(
  xs : Array[X],
  offset~ : Int,
  len~ : Int = xs.length() - offset
) -> Array[X] {
  xs[offset:offset + len].iter().to_array()
}

test {
  assert_eq!(sub_array([1, 2, 3], offset=1), [2, 3])
  assert_eq!(sub_array([1, 2, 3], offset=1, len=1), [2])
}
// end optional arguments 4

struct Image {
  width : Int
  height : Int
}

// start optional arguments 5
fn ugly_constructor(width~ : Int? = None, height~ : Int? = None) -> Image {
  ...
}

let img : Image = ugly_constructor(width=Some(1920), height=Some(1080))
// end optional arguments 5

// start optional arguments 6
fn nice_constructor(width? : Int, height? : Int) -> Image {
  ...
}

let img2 : Image = nice_constructor(width=1920, height=1080)
// end optional arguments 6

// start optional arguments 7
fn image(width? : Int, height? : Int) -> Image {
  ...
}

fn fixed_width_image(height? : Int) -> Image {
  image(width=1920, height?)
}
// end optional arguments 7

// start autofill arguments
fn f(_x : Int, loc~ : SourceLoc = _, args_loc~ : ArgsLoc = _) -> String {
  $|loc of whole function call: \{loc}
  $|loc of arguments: \{args_loc}
  // loc of whole function call: <filename>:7:3-7:10
  // loc of arguments: [Some(<filename>:7:5-7:6), Some(<filename>:7:8-7:9), None, None]
}
// end autofill arguments

// start function alias
// `hashmap_new` will become an alias of `@hashmap.new`
fnalias @hashmap.new as hashmap_new

// same as `fnalias @hashmap.new as new`
fnalias @hashmap.new

// local alias is also allowed
fnalias new as new_2

// creating multiple alias in one package
fnalias @moonbitlang/core/prelude.(
  tap,
  then as touch
)
// end function alias
```

---

### 文件：`src/generics/moon.pkg.json`

```json
{
    "warn-list": "-4"
}
```

---

### 文件：`src/generics/top.mbt`

```moonbit
enum List[T] {
  Nil
  Cons(T, List[T])
}

fn[S, T] map(self : List[S], f : (S) -> T) -> List[T] {
  match self {
    Nil => Nil
    Cons(x, xs) => Cons(f(x), xs.map(f))
  }
}

fn[S, T] reduce(self : List[S], op : (T, S) -> T, init : T) -> T {
  match self {
    Nil => init
    Cons(x, xs) => xs.reduce(op, op(init, x))
  }
}
```

---

### 文件：`src/is/moon.pkg.json`

```json
{
  "warn-list": "-1-28"
}
```

---

### 文件：`src/is/top.mbt`

```moonbit
// start is 1
fn[T] is_none(x : T?) -> Bool {
  x is None
}

fn start_with_lower_letter(s : String) -> Bool {
  s is ['a'..='z', ..]
}
// end is 1

// start is 2
fn f(x : Int?) -> Bool {
  x is Some(v) && v >= 0
}
// end is 2

// start is 3
fn g(x : Array[Int?]) -> Unit {
  if x is [v, .. rest] && v is Some(i) && i is (0..=10) {
    println(v)
    println(i)
    println(rest)
  }
}
// end is 3

// start is 4
fn h(x : Int?) -> Unit {
  guard x is Some(v)
  println(v)
}
// end is 4

// start is 5
fn i(x : Int?) -> Unit {
  let mut m = x
  while m is Some(v) {
    println(v)
    m = None
  }
}
// end is 5

// start is 6
fn j(x : Int) -> Int? {
  Some(x)
}

fn init {
  guard j(42) is (Some(a) as b)
  println(a)
  println(b)
}
// end is 6
```

---

### 文件：`src/iter/moon.pkg.json`

```json
{
    "warn-list": "-1"
}
```

---

### 文件：`src/iter/top.mbt`

```moonbit
// start iter 1
///|
fn filter_even(l : Array[Int]) -> Array[Int] {
  let l_iter : Iter[Int] = l.iter()
  l_iter.filter(fn { x => (x & 1) == 0 }).collect()
}

///|
fn fact(n : Int) -> Int {
  let start = 1
  let range : Iter[Int] = start.until(n)
  range.fold(Int::op_mul, init=start)
}
// end iter 1

// start iter 2
///|
fn iter(data : Bytes) -> Iter[Byte] {
  Iter::new(fn(visit : (Byte) -> IterResult) -> IterResult {
    for byte in data {
      guard visit(byte) is IterContinue else { break IterEnd }

    } else {
      IterContinue
    }
  })
}
// end iter 2
```

---

### 文件：`src/main/moon.pkg.json`

```json
{
  "is-main": true
}
```

---

### 文件：`src/main/top.mbt`

```moonbit
// start init
fn init {
  let x = 1
  println(x)
}
// end init

// start main
fn main {
  let x = 2
  println(x)
}
// end main
```

---

### 文件：`src/method2/moon.pkg.json`

```json
{
    "import": [
        {
            "path": "moonbit-community/language/method",
            "alias": "list"
        }
    ],
    "warn-list": "-1-2-4-6-28"
}
```

---

### 文件：`src/method2/top.mbt`

```moonbit
// start method declaration example
enum List[X] {
  Nil
  Cons(X, List[X])
}

fn[X] List::length(xs : List[X]) -> Int {
  ...
}
// end method declaration example

fn _call_syntax_example() -> Unit {
  // start method call syntax example
  let l : List[Int] = Nil
  println(l.length())
  println(List::length(l))
  // end method call syntax example
}

fn f() -> Unit {
  let xs : @list.List[@list.List[Unit]] = Nil
  // start dot syntax example
  // assume `xs` is a list of lists, all the following two lines are equivalent
  let _ = xs.concat()
  let _ = @list.List::concat(xs)
  // end dot syntax example
}
```

---

### 文件：`src/method/moon.pkg.json`

```json
{
    "warn-list": "-1-2-4-6-7-13-28"
}
```

---

### 文件：`src/method/top.mbt`

```moonbit
// start method 1
pub(all) enum List[X] {
  Nil
  Cons(X, List[X])
}

pub fn[X] List::concat(list : List[List[X]]) -> List[X] {
  ...
}
// end method 1

pub fn[X, Y] List::map(self : List[X], f : (X) -> Y) -> List[Y] {
  match self {
    Nil => Nil
    Cons(x, xs) => Cons(f(x), xs.map(f))
  }
}

// start method overload example
struct T1 {
  x1 : Int
}

fn T1::default() -> T1 {
  { x1: 0 }
}

struct T2 {
  x2 : Int
}

fn T2::default() -> T2 {
  { x2: 0 }
}

test {
  let t1 = T1::default()
  let t2 = T2::default()

}
// end method overload example

// start method alias
// same as `fnalias List::map as map`
fnalias List::map

// list_concat is an alias of `List::concat`
fnalias List::concat as list_concat

// creating multiple alias in typename
fnalias List::(concat as c, map as m)
// end method alias
```

---

### 文件：`src/misc/moon.pkg.json`

```json
{
    "warn-list": "-1-2-28"
}
```

---

### 文件：`src/misc/top.mbt`

```moonbit
// start doc string 1
/// Return a new array with reversed elements.
///
/// # Example
///
/// ```
/// reverse([1,2,3,4]) |> println()
/// ```
fn[T] reverse(xs : Array[T]) -> Array[T] {
  ...
}
// end doc string 1

// start todo 1
fn todo_in_func() -> Int {
  ...
}
// end todo 1
```

---

### 文件：`src/operator/moon.pkg.json`

```json
{
  "warn-list": "-1-2-4-11"
}
```

---

### 文件：`src/operator/top.mbt`

```moonbit
// start operator 1
struct T {
  x : Int
}

impl Add for T with op_add(self : T, other : T) -> T {
  { x: self.x + other.x }
}

test {
  let a = { x: 0 }
  let b = { x: 2 }
  assert_eq!((a + b).x, 2)
}
// end operator 1

// start operator 2
struct Coord {
  mut x : Int
  mut y : Int
} derive(Show)

fn op_get(self : Coord, key : String) -> Int {
  match key {
    "x" => self.x
    "y" => self.y
  }
}

fn op_set(self : Coord, key : String, val : Int) -> Unit {
  match key {
    "x" => self.x = val
    "y" => self.y = val
  }
}
// end operator 2

test "operator 3" (t : @test.T) {
  let println = fn(show) { t.writeln(show) }
  // start operator 3
  let c = { x: 1, y: 2 }
  println(c)
  println(c["y"])
  c["x"] = 23
  println(c)
  println(c["x"])
  // end operator 3
  t.snapshot!(filename="operator_3")
}

fn add(i : Int, j : Int) -> Int {
  i + j
}

fn pipe() -> Unit {
  // start operator 4
  5 |> ignore // <=> ignore(5)
  [] |> Array::push(5) // <=> Array::push([], 5)
  1
  |> add(5) // <=> add(1, 5)
  |> ignore // <=> ignore(add(1, 5))
  // end operator 4
}

trait Ignore {
  f(Self) -> Unit
}

impl Ignore for Unit with f(u) {
  u
}

fn cascade() -> Unit {
  let x : Unit = ()
  // start operator 5
  x..f()
  // end operator 5
  // start operator 6
  let builder = StringBuilder::new()
  builder.write_char('a')
  builder.write_char('a')
  builder.write_object(1001)
  builder.write_string("abcdef")
  let result = builder.to_string()
  // end operator 6

  // start operator 7
  let result = StringBuilder::new()
    ..write_char('a')
    ..write_char('a')
    ..write_object(1001)
    ..write_string("abcdef")
    .to_string()
  // end operator 7

}

impl BitAnd for T with land(self : T, other : T) -> T {
  { x: self.x & other.x }
}

impl BitOr for T with lor(self : T, other : T) -> T {
  { x: self.x | other.x }
}

impl BitXOr for T with lxor(self : T, other : T) -> T {
  { x: self.x ^ other.x }
}

impl Shl for T with op_shl(self : T, other : Int) -> T {
  { x: self.x << other }
}

impl Shr for T with op_shr(self : T, other : Int) -> T {
  { x: self.x >> other }
}

test {
  let a = { x: 0b1010 }
  let b = { x: 0b1100 }
  assert_eq!((a & b).x, 0b1000)
  assert_eq!((a | b).x, 0b1110)
  assert_eq!((a ^ b).x, 0b0110)
  assert_eq!((a << 2).x, 0b101000)
  assert_eq!((b >> 2).x, 0b11)
}

// start view 1
test {
  let xs = [0, 1, 2, 3, 4, 5]
  let s1 : ArrayView[Int] = xs[2:]
  inspect!(s1, content="[2, 3, 4, 5]")
  inspect!(xs[:4], content="[0, 1, 2, 3]")
  inspect!(xs[2:5], content="[2, 3, 4]")
  inspect!(xs[:], content="[0, 1, 2, 3, 4, 5]")
}
// end view 1

// start view 2
type DataView String

struct Data {}

fn Data::op_as_view(_self : Data, start~ : Int = 0, end? : Int) -> DataView {
  "[\{start}, \{end.or(100)})"
}

test {
  let data = Data::{  }
  inspect!(data[:]._, content="[0, 100)")
  inspect!(data[2:]._, content="[2, 100)")
  inspect!(data[:5]._, content="[0, 5)")
  inspect!(data[2:5]._, content="[2, 5)")
}
// end view 2

// start spread 1
test {
  let a1 : Array[Int] = [1, 2, 3]
  let a2 : FixedArray[Int] = [4, 5, 6]
  let a3 : @immut/list.T[Int] = @immut/list.from_array([7, 8, 9])
  let a : Array[Int] = [..a1, ..a2, ..a3, 10]
  inspect!(a, content="[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]")
}
// end spread 1

// start spread 2
test {
  let s1 : String = "Hello"
  let s2 : @string.View = "World".view()
  let s3 : Array[Char] = [..s1, ' ', ..s2, '!']
  let s : String = [..s1, ' ', ..s2, '!', ..s3]
  inspect!(s, content="Hello World!Hello World!")
}
// end spread 2

// start spread 3
test {
  let b1 : Bytes = "hello"
  let b2 : @bytes.View = b1[1:4]
  let b : Bytes = [..b1, ..b2, 10]
  inspect!(
    b,
    content=
      #|b"\x68\x65\x6c\x6c\x6f\x65\x6c\x6c\x0a"
    ,
  )
}
// end spread 3
```

---

### 文件：`src/packages/implement/moon.pkg.json`

```json
{
  "implement": "moonbit-community/language/packages/virtual"
}
```

---

### 文件：`src/packages/implement/top.mbt`

```moonbit
pub fn log(string : String) -> Unit {
  ignore(string)
}
```

---

### 文件：`src/packages/pkgA/moon.pkg.json`

```json
{}
```

---

### 文件：`src/packages/pkgA/top.mbt`

```moonbit
pub fn incr(x : Int) -> Int {
  x + 1
}
```

---

### 文件：`src/packages/pkgB/moon.pkg.json`

```json
{
    "import": [
        "moonbit-community/language/packages/pkgA",
        {
            "path": "moonbit-community/language/packages/pkgC",
            "alias": "c"
        }
    ]
}
```

---

### 文件：`src/packages/pkgB/top.mbt`

```moonbit
pub fn add1(x : Int) -> Int {
  @moonbitlang/core/int.abs(@c.incr(@pkgA.incr(x)))
}
```

---

### 文件：`src/packages/pkgC/moon.pkg.json`

```json
{}
```

---

### 文件：`src/packages/pkgC/top.mbt`

```moonbit
pub fn incr(x : Int) -> Int {
  x + 1
}
```

---

### 文件：`src/packages/use_implement/moon.pkg.json`

```json
{
  "overrides": ["moonbit-community/language/packages/implement"],
  "import": [
    "moonbit-community/language/packages/virtual"
  ],
  "is-main": true
}
```

---

### 文件：`src/packages/use_implement/top.mbt`

```moonbit
fn main {
  @virtual.log("Hello")
}
```

---

### 文件：`src/packages/virtual/moon.pkg.json`

```json
{
  "virtual": {
    "has-default": true
  }
}
```

---

### 文件：`src/packages/virtual/top.mbt`

```moonbit
pub fn log(s : String) -> Unit {
  println(s)
}
```

---

### 文件：`src/pattern/moon.pkg.json`

```json
{
  "warn-list": "-1-2-4-6-7-9-10-11-12-28"
}
```

---

### 文件：`src/pattern/top.mbt`

```moonbit
struct User {
  id : String
  name : String
  email : String
}

let user : Unit = {
  let u = { id: "1", name: "John", email: "john@example.com" }
  // start pattern 1
  let id = match u {
    { id, name: _, email: _ } => id
  }

  // <=>
  let { id, name: _, email: _ } = u

  // <=>
  let { id, .. } = u
  // end pattern 1

}

// start pattern 2
test {
  let ary = [1, 2, 3, 4]
  if ary is [a, b, .. rest] && a == 1 && b == 2 && rest.length() == 2 {
    inspect!("a = \{a}, b = \{b}", content="a = 1, b = 2")
  } else {
    fail!("")
  }
  guard ary is [.., a, b] else { fail!("") }
  inspect!("a = \{a}, b = \{b}", content="a = 3, b = 4")
}
// end pattern 2

// start array pattern 1
test {
  fn palindrome(s : String) -> Bool {
    loop s.view() {
      [] | [_] => true
      [a,  .. rest,  b] => if a == b { continue rest } else { false }
    }
  }

  inspect!(palindrome("abba"), content="true")
  inspect!(palindrome("中b中"), content="true")
  inspect!(palindrome("文bb中"), content="false")
}
// end array pattern 1

// start array pattern 2
const NO : Bytes = "no"

test {
  fn match_string(s : String) -> Bool {
    match s {
      [.. "yes", ..] => true // equivalent to ['y', 'e', 's', ..]
    }
  }

  fn match_bytes(b : Bytes) -> Bool {
    match b {
      [.. NO, ..] => false // equivalent to ['n', 'o', ..]
    }
  }
}
// end array pattern 2

enum Arith {
  Lit(Int)
  Add(Arith, Arith)
  Mul(Arith, Arith)
}

fn eval(expr : Arith) -> Int {
  // start pattern 3
  match expr {
    //! Add(e1, e2) | Lit(e1) => ...
    Lit(n) as a => ...
    Add(e1, e2) | Mul(e1, e2) => ...
    _ => ...
  }
  // end pattern 3
}

// start pattern 4
const Zero = 0

fn sign(x : Int) -> Int {
  match x {
    _..<Zero => -1
    Zero => 0
    1..<_ => 1
  }
}

fn classify_char(c : Char) -> String {
  match c {
    'a'..='z' => "lowercase"
    'A'..='Z' => "uppercase"
    '0'..='9' => "digit"
    _ => "other"
  }
}
// end pattern 4

fn map() -> Unit {
  let map = { "a": 1 }
  // start pattern 5
  match map {
    // matches if any only if "b" exists in `map`
    { "b": _, .. } => ...
    // matches if and only if "b" does not exist in `map` and "a" exists in `map`.
    // When matches, bind the value of "a" in `map` to `x`
    { "b"? : None, "a": x, .. } => ...
    // compiler reports missing case: { "b"? : None, "a"? : None }
  }
  // end pattern 5
}

fn json() -> Unit {
  let json = Json::null()
  // start pattern 6
  match json {
    { "version": "1.0.0", "import": [..] as imports, .. } => ...
    { "version": Number(i), "import": Array(imports), .. } => ...
    _ => ...
  }
  // end pattern 6
}

// start simple pattern 1
const ONE = 1

fn match_int(x : Int) -> Unit {
  match x {
    0 => println("zero")
    ONE => println("one")
    value => println(value)
  }
}
// end simple pattern 1

// start simple pattern 2
struct Point3D {
  x : Int
  y : Int
  z : Int
}

fn match_point3D(p : Point3D) -> Unit {
  match p {
    { x: 0, .. } => println("on yz-plane")
    _ => println("not on yz-plane")
  }
}

enum Point[T] {
  Point2D(Int, Int, name~ : String, payload~ : T)
}

fn[T] match_point(p : Point[T]) -> Unit {
  match p {
    //! Point2D(0, 0) => println("2D origin")
    Point2D(0, 0, ..) => println("2D origin")
    Point2D(_) => println("2D point")
    _ => panic()
  }
}
// end simple pattern 2

// start guard condition 1
fn guard_cond(x : Int?) -> Int {
  fn f(x : Int) -> Array[Int] {
    [x, x + 42]
  }

  match x {
    Some(a) if f(a) is [0, b] => a + b
    Some(b) => b
    None => -1
  }
}

test {
  assert_eq!(guard_cond(None), -1)
  assert_eq!(guard_cond(Some(0)), 42)
  assert_eq!(guard_cond(Some(1)), 1)
}
// end guard condition 1

// start guard condition 2
fn guard_check(x : Int?) -> Unit {
  match x {
    Some(a) if a >= 0 => ()
    Some(a) if a < 0 => ()
    None => ()
  }
}
// end guard condition 2
```

---

### 文件：`src/test/moon.pkg.json`

```json
{
    "warn-list": "-3-4"
}
```

---

### 文件：`src/test/top.mbt`

```moonbit
// start test 1
test "test_name" {
  assert_eq!(1 + 1, 2)
  assert_eq!(2 + 2, 4)
  inspect!([1, 2, 3], content="[1, 2, 3]")
}
// end test 1

// start test 2
test "panic_test" {
  let _ : Int = Option::None.unwrap()

}
// end test 2

// start snapshot test 1
struct X {
  x : Int
} derive(Show)

test "show snapshot test" {
  inspect!({ x: 10 }, content="{x: 10}")
}
// end snapshot test 1

// start snapshot test 2
enum Rec {
  End
  Really_long_name_that_is_difficult_to_read(Rec)
} derive(Show, ToJson)

test "json snapshot test" {
  let r = Really_long_name_that_is_difficult_to_read(
    Really_long_name_that_is_difficult_to_read(
      Really_long_name_that_is_difficult_to_read(End),
    ),
  )
  inspect!(
    r,
    content="Really_long_name_that_is_difficult_to_read(Really_long_name_that_is_difficult_to_read(Really_long_name_that_is_difficult_to_read(End)))",
  )
  @json.inspect!(r, content={
    "$tag": "Really_long_name_that_is_difficult_to_read",
    "0": {
      "$tag": "Really_long_name_that_is_difficult_to_read",
      "0": {
        "$tag": "Really_long_name_that_is_difficult_to_read",
        "0": { "$tag": "End" },
      },
    },
  })
}
// end snapshot test 2

// start snapshot test 3
test "record anything" (t : @test.T) {
  t.write("Hello, world!")
  t.writeln(" And hello, MoonBit!")
  t.snapshot!(filename="record_anything.txt")
}
// end snapshot test 3
```

---

### 文件：`src/trait/moon.pkg.json`

```json
{
    "warn-list": "-1-2-3-4-5-6-9-28"
}
```

---

### 文件：`src/trait/top.mbt`

```moonbit
// start trait 1
pub(open) trait I {
  method_(Int) -> Int
  method_with_label(Int, label~ : Int) -> Int
  //! method_with_label(Int, label?: Int) -> Int
}
// end trait 1

// start trait 2
pub(open) trait MyShow {
  to_string(Self) -> String
}

struct MyType {}

pub impl MyShow for MyType with to_string(self) {
  ...
}

struct MyContainer[T] {}

// trait implementation with type parameters.
// `[X : Show]` means the type parameter `X` must implement `Show`,
// this will be covered later.
pub impl[X : MyShow] MyShow for MyContainer[X] with to_string(self) {
  ...
}
// end trait 2

// start trait 3
pub(open) trait J {
  f(Self) -> Unit
  f_twice(Self) -> Unit = _
}

impl J with f_twice(self) {
  self.f()
  self.f()
}
// end trait 3

// start trait 4
impl J for Int with f(self) {
  println(self)
}

impl J for String with f(self) {
  println(self)
}

impl J for String with f_twice(self) {
  println(self)
  println(self)
}

// end trait 4

// start trait 5
fn[X : Eq] contains(xs : Array[X], elem : X) -> Bool {
  for x in xs {
    if x == elem {
      return true
    }
  } else {
    false
  }
}
// end trait 5

// start trait 6
struct Point {
  x : Int
  y : Int
}

impl Eq for Point with op_equal(p1, p2) {
  p1.x == p2.x && p1.y == p2.y
}

test {
  assert_false!(contains([1, 2, 3], 4))
  assert_true!(contains([1.5, 2.25, 3.375], 2.25))
  assert_false!(contains([{ x: 2, y: 3 }], { x: 4, y: 9 }))
}
// end trait 6

// start trait 7
test {
  assert_eq!(Show::to_string(42), "42")
  assert_eq!(Compare::compare(1.0, 2.5), -1)
}
// end trait 7

// start trait 8
struct MyCustomType {}

pub impl Show for MyCustomType with output(self, logger) {
  ...
}

fn f() -> Unit {
  let x = MyCustomType::{  }
  let _ = x.to_string()

}
// end trait 8

// start trait 9
struct T {
  a : Int
  b : Int
} derive(Eq, Compare, Show, Default)

test {
  let t1 = T::default()
  let t2 = T::{ a: 1, b: 1 }
  inspect!(t1, content="{a: 0, b: 0}")
  inspect!(t2, content="{a: 1, b: 1}")
  assert_not_eq!(t1, t2)
  assert_true!(t1 < t2)
}
// end trait 9

// start super trait 1
pub(open) trait Position {
  pos(Self) -> (Int, Int)
}

pub(open) trait Draw {
  draw(Self, Int, Int) -> Unit
}

pub(open) trait Object: Position + Draw {}
// end super trait 1

// start super trait 2
impl Position for Point with pos(self) {
  (self.x, self.y)
}

impl Draw for Point with draw(self, x, y) {
  ()
}

pub fn[O : Object] draw_object(obj : O) -> Unit {
  let (x, y) = obj.pos()
  obj.draw(x, y)
}

test {
  let p = Point::{ x: 1, y: 2 }
  draw_object(p)
}
// end super trait 2

// start trait object 1
pub(open) trait Animal {
  speak(Self) -> String
}

type Duck String

fn Duck::make(name : String) -> Duck {
  Duck(name)
}

impl Animal for Duck with speak(self) {
  "\{self._}: quack!"
}

type Fox String

fn Fox::make(name : String) -> Fox {
  Fox(name)
}

impl Animal for Fox with speak(_self) {
  "What does the fox say?"
}

test {
  let duck1 = Duck::make("duck1")
  let duck2 = Duck::make("duck2")
  let fox1 = Fox::make("fox1")
  let animals : Array[&Animal] = [duck1, duck2, fox1]
  inspect!(
    animals.map(fn(animal) { animal.speak() }),
    content=
      #|["duck1: quack!", "duck2: quack!", "What does the fox say?"]
    ,
  )
}
// end trait object 1

// start trait object 2
pub(open) trait Logger {
  write_string(Self, String) -> Unit
}

pub(open) trait CanLog {
  log(Self, &Logger) -> Unit
}

fn[Obj : CanLog] &Logger::write_object(self : &Logger, obj : Obj) -> Unit {
  obj.log(self)
}

// use the new method to simplify code
pub impl[A : CanLog, B : CanLog] CanLog for (A, B) with log(self, logger) {
  let (a, b) = self
  logger
  ..write_string("(")
  ..write_object(a)
  ..write_string(", ")
  ..write_object(b)
  ..write_string(")")
}
// end trait object 2

// start trait alias
// CanCompare is an alias of Compare
traitalias @builtin.Compare as CanCompare
// end trait alias
```

---

### 文件：`src/variable/moon.pkg.json`

```json
{
  "is-main": true
}
```

---

### 文件：`src/variable/top.mbt`

```moonbit
let zero = 0

const ZERO = 0

fn main {
  //! const ZERO = 0 
  let mut i = 10
  i = 20
  println(i + zero + ZERO)
}
```

---

## 文本文件

### 文件：`LICENSE`

```text
Apache License
                           Version 2.0, January 2004
                        http://www.apache.org/licenses/

   TERMS AND CONDITIONS FOR USE, REPRODUCTION, AND DISTRIBUTION

   1. Definitions.

      "License" shall mean the terms and conditions for use, reproduction,
      and distribution as defined by Sections 1 through 9 of this document.

      "Licensor" shall mean the copyright owner or entity authorized by
      the copyright owner that is granting the License.

      "Legal Entity" shall mean the union of the acting entity and all
      other entities that control, are controlled by, or are under common
      control with that entity. For the purposes of this definition,
      "control" means (i) the power, direct or indirect, to cause the
      direction or management of such entity, whether by contract or
      otherwise, or (ii) ownership of fifty percent (50%) or more of the
      outstanding shares, or (iii) beneficial ownership of such entity.

      "You" (or "Your") shall mean an individual or Legal Entity
      exercising permissions granted by this License.

      "Source" form shall mean the preferred form for making modifications,
      including but not limited to software source code, documentation
      source, and configuration files.

      "Object" form shall mean any form resulting from mechanical
      transformation or translation of a Source form, including but
      not limited to compiled object code, generated documentation,
      and conversions to other media types.

      "Work" shall mean the work of authorship, whether in Source or
      Object form, made available under the License, as indicated by a
      copyright notice that is included in or attached to the work
      (an example is provided in the Appendix below).

      "Derivative Works" shall mean any work, whether in Source or Object
      form, that is based on (or derived from) the Work and for which the
      editorial revisions, annotations, elaborations, or other modifications
      represent, as a whole, an original work of authorship. For the purposes
      of this License, Derivative Works shall not include works that remain
      separable from, or merely link (or bind by name) to the interfaces of,
      the Work and Derivative Works thereof.

      "Contribution" shall mean any work of authorship, including
      the original version of the Work and any modifications or additions
      to that Work or Derivative Works thereof, that is intentionally
      submitted to Licensor for inclusion in the Work by the copyright owner
      or by an individual or Legal Entity authorized to submit on behalf of
      the copyright owner. For the purposes of this definition, "submitted"
      means any form of electronic, verbal, or written communication sent
      to the Licensor or its representatives, including but not limited to
      communication on electronic mailing lists, source code control systems,
      and issue tracking systems that are managed by, or on behalf of, the
      Licensor for the purpose of discussing and improving the Work, but
      excluding communication that is conspicuously marked or otherwise
      designated in writing by the copyright owner as "Not a Contribution."

      "Contributor" shall mean Licensor and any individual or Legal Entity
      on behalf of whom a Contribution has been received by Licensor and
      subsequently incorporated within the Work.

   2. Grant of Copyright License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      copyright license to reproduce, prepare Derivative Works of,
      publicly display, publicly perform, sublicense, and distribute the
      Work and such Derivative Works in Source or Object form.

   3. Grant of Patent License. Subject to the terms and conditions of
      this License, each Contributor hereby grants to You a perpetual,
      worldwide, non-exclusive, no-charge, royalty-free, irrevocable
      (except as stated in this section) patent license to make, have made,
      use, offer to sell, sell, import, and otherwise transfer the Work,
      where such license applies only to those patent claims licensable
      by such Contributor that are necessarily infringed by their
      Contribution(s) alone or by combination of their Contribution(s)
      with the Work to which such Contribution(s) was submitted. If You
      institute patent litigation against any entity (including a
      cross-claim or counterclaim in a lawsuit) alleging that the Work
      or a Contribution incorporated within the Work constitutes direct
      or contributory patent infringement, then any patent licenses
      granted to You under this License for that Work shall terminate
      as of the date such litigation is filed.

   4. Redistribution. You may reproduce and distribute copies of the
      Work or Derivative Works thereof in any medium, with or without
      modifications, and in Source or Object form, provided that You
      meet the following conditions:

      (a) You must give any other recipients of the Work or
          Derivative Works a copy of this License; and

      (b) You must cause any modified files to carry prominent notices
          stating that You changed the files; and

      (c) You must retain, in the Source form of any Derivative Works
          that You distribute, all copyright, patent, trademark, and
          attribution notices from the Source form of the Work,
          excluding those notices that do not pertain to any part of
          the Derivative Works; and

      (d) If the Work includes a "NOTICE" text file as part of its
          distribution, then any Derivative Works that You distribute must
          include a readable copy of the attribution notices contained
          within such NOTICE file, excluding those notices that do not
          pertain to any part of the Derivative Works, in at least one
          of the following places: within a NOTICE text file distributed
          as part of the Derivative Works; within the Source form or
          documentation, if provided along with the Derivative Works; or,
          within a display generated by the Derivative Works, if and
          wherever such third-party notices normally appear. The contents
          of the NOTICE file are for informational purposes only and
          do not modify the License. You may add Your own attribution
          notices within Derivative Works that You distribute, alongside
          or as an addendum to the NOTICE text from the Work, provided
          that such additional attribution notices cannot be construed
          as modifying the License.

      You may add Your own copyright statement to Your modifications and
      may provide additional or different license terms and conditions
      for use, reproduction, or distribution of Your modifications, or
      for any such Derivative Works as a whole, provided Your use,
      reproduction, and distribution of the Work otherwise complies with
      the conditions stated in this License.

   5. Submission of Contributions. Unless You explicitly state otherwise,
      any Contribution intentionally submitted for inclusion in the Work
      by You to the Licensor shall be under the terms and conditions of
      this License, without any additional terms or conditions.
      Notwithstanding the above, nothing herein shall supersede or modify
      the terms of any separate license agreement you may have executed
      with Licensor regarding such Contributions.

   6. Trademarks. This License does not grant permission to use the trade
      names, trademarks, service marks, or product names of the Licensor,
      except as required for reasonable and customary use in describing the
      origin of the Work and reproducing the content of the NOTICE file.

   7. Disclaimer of Warranty. Unless required by applicable law or
      agreed to in writing, Licensor provides the Work (and each
      Contributor provides its Contributions) on an "AS IS" BASIS,
      WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
      implied, including, without limitation, any warranties or conditions
      of TITLE, NON-INFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A
      PARTICULAR PURPOSE. You are solely responsible for determining the
      appropriateness of using or redistributing the Work and assume any
      risks associated with Your exercise of permissions under this License.

   8. Limitation of Liability. In no event and under no legal theory,
      whether in tort (including negligence), contract, or otherwise,
      unless required by applicable law (such as deliberate and grossly
      negligent acts) or agreed to in writing, shall any Contributor be
      liable to You for damages, including any direct, indirect, special,
      incidental, or consequential damages of any character arising as a
      result of this License or out of the use or inability to use the
      Work (including but not limited to damages for loss of goodwill,
      work stoppage, computer failure or malfunction, or any and all
      other commercial damages or losses), even if such Contributor
      has been advised of the possibility of such damages.

   9. Accepting Warranty or Additional Liability. While redistributing
      the Work or Derivative Works thereof, You may choose to offer,
      and charge a fee for, acceptance of support, warranty, indemnity,
      or other liability obligations and/or rights consistent with this
      License. However, in accepting such obligations, You may act only
      on Your own behalf and on Your sole responsibility, not on behalf
      of any other Contributor, and only if You agree to indemnify,
      defend, and hold each Contributor harmless for any liability
      incurred by, or claims asserted against, such Contributor by reason
      of your accepting any such warranty or additional liability.

   END OF TERMS AND CONDITIONS

   APPENDIX: How to apply the Apache License to your work.

      To apply the Apache License to your work, attach the following
      boilerplate notice, with the fields enclosed by brackets "[]"
      replaced with your own identifying information. (Don't include
      the brackets!)  The text should be enclosed in the appropriate
      comment syntax for the file format. We also recommend that a
      file or class name and description of purpose be included on the
      same "printed page" as the copyright notice for easier
      identification within third-party archives.

   Copyright [yyyy] [name of copyright owner]

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
```

---

### 文件：`src/builtin/__snapshot__/byte_1`

```text
97
255
```

---

### 文件：`src/builtin/__snapshot__/string_1`

```text
兔
r
 Hello
 MoonBit\n
```

---

### 文件：`src/builtin/__snapshot__/string_4`

```text
Hello
 ---
 MoonBit

 ---
```

---

### 文件：`src/builtin/__snapshot__/tuple_1`

```text
false 100 text 3.14
```

---

### 文件：`src/controls/__snapshot__/for_loop_1`

```text
0
1
2
3
4
```

---

### 文件：`src/controls/__snapshot__/for_loop_4`

```text
even: 2
even: 4
even: 6
12
```

---

### 文件：`src/controls/__snapshot__/for_loop_7`

```text
The 1-th element of the array is 4
The 2-th element of the array is 5
The 3-th element of the array is 6
```

---

### 文件：`src/controls/__snapshot__/for_loop_8`

```text
x, 1
z, 3
```

---

### 文件：`src/controls/__snapshot__/while_loop_1`

```text
5
4
3
2
1
```

---

### 文件：`src/controls/__snapshot__/while_loop_2`

```text
3
2
```

---

### 文件：`src/controls/__snapshot__/while_loop_3`

```text
2
1
0
```

---

### 文件：`src/controls/__snapshot__/while_loop_4`

```text
5
```

---

### 文件：`src/controls/__snapshot__/while_loop_5`

```text
7
```

---

### 文件：`src/data/__snapshot__/enum_3`

```text
smaller!
equal!
greater!
```

---

### 文件：`src/data/__snapshot__/enum_6`

```text
false
1,
2,
nil
```

---

### 文件：`src/data/__snapshot__/enum_9`

```text
0!
0
```

---

### 文件：`src/data/__snapshot__/enum_11`

```text
5
NotImplementedError
```

---

### 文件：`src/data/__snapshot__/newtype_2`

```text
1
John Doe
```

---

### 文件：`src/data/__snapshot__/newtype_3`

```text
1
```

---

### 文件：`src/data/__snapshot__/struct_1`

```text
0
John Doe
john@doe.name
```

---

### 文件：`src/data/__snapshot__/struct_4`

```text
{ id: 0, name: John Doe, email: john@doe.com }
{ id: 0, name: John Doe, email: john@doe.name }
```

---

### 文件：`src/error/__snapshot__/error_9`

```text
division by zero
```

---

### 文件：`src/operator/__snapshot__/operator_3`

```text
{x: 1, y: 2}
2
{x: 23, y: 2}
23
```

---

## 其他文件

### 文件：`src/packages/virtual/virtual.mbti`

```text
package "moonbit-community/language/packages/virtual"

fn log(String) -> Unit
```

---
