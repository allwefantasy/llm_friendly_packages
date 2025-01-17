# the MoonBit language

This tour covers all aspects of the MoonBit language, and assumes you have some prior programming experience. It should teach you everything you need to write real programs in MoonBit.


```mbt
fn main {
  println("hello")
}
```

# chapter1_basics/lesson10_loop

# Loop

In this example, we use for loops and while loops to iterate over an array.

## For Loop Expression

The for loop is analogous to a C-style for loop:

```
for init; condition; increment {
    // loop body
}
```

The loop initializes the variables in the `init` part before it starts. When the loop starts, it tests the `condition` and executes the loop body if the `condition` is true. After that, it runs the `increment` expression and repeats the process until the condition is false.

In MoonBit, the for loop is more expressive than the C-style for loop. We will
explain it in the following chapters.

## While Loop Expression

The while loop is also similar to the C-style while loop.

It tests the condition before executing the loop body. If the condition is true,
it executes the loop body and repeats the process until the condition is false.

MoonBit also supports both `continue` and `break` statements within the loop.


```mbt
fn main {
  let array = [1, 2, 3]

  println("for loop:")
  for i = 0; i < array.length(); i = i + 1 {
    println("array[\{i}]: \{array[i]}")
  }

  println("\nfunctional for loop:")

  let sum = for i = 1, acc = 0; i <= 10; i = i + 1 {
    let even = i % 2 == 0
    continue i + 1, acc + i
  } else {
    acc
  }
  println(sum)

  println("\nwhile loop:")
  let mut j = 0
  while true {
    println("array[\{j}]: \{array[j]}")
    j = j + 1
    if j < array.length() {
      continue
    } else {
      break
    }
  }
}

```

# chapter1_basics/lesson11_for_in_loop

# For-in loop

It's cumbersome to write a for loop and manually decide the end condition.

If you want to iterate over a collection, you can use the `for .. in ... {}` loop.

In the first for-in loop, we iterate over an array. The loop will bind each
element to the variable `element` in each iteration.

We can also iterate over a map with key-value pairs. The second loop will bind
the key to the first variable (`k`) and the value to the second variable (`v`).

Which collections can be iterated over with a for-in loop? And when does the for-in loop support two variables? The for-in loop functionality actually depends on the API of the collection:

- If the collection provides an `iter()` method to return an `Iter[V]` iterator, then the for-in loop can iterate over it with a single variable.

- If the collection provides an `iter2()` method to return an `Iter2[K,V]` iterator, you can use two variables to iterate over it.

We will explain more details about the iterator in a later chapter.


```mbt
fn main {
  println("for-in loop:")
  let array = [1, 2, 3]
  for element in array {
    println("element: \{element}")
  }

  println("for-in loop with index:")
  for i, element in array {
    println("index: \{i}, element: \{element}")
  }
  
  println("for-in loop for map:")
  let map = { "key1": 1, "key2": 2, "key3": 3 }
  for k, v in map {
    println("key: \{k}, value: \{v}")
  }
}

```

# chapter1_basics/lesson12_range

# Range

You can also use *range* in a for-in loop.

- `start..<end` range is inclusive of the start value and exclusive of the end value. 
- `start..=end` range is inclusive of both the start and end values.



```mbt
fn main {
  println("number 1 to 3:")
  for i in 1..<4 {
    println(i)
  }
  
  println("number 1 to 4:")
  for i in 1..=4 {
    println(i)
  }
}




```

# chapter1_basics/lesson13_test

# Test

MoonBit has built-in testing support. There is no need to import or configure extra packages or tools; just use the test block and write the test code inside.

**Note: this feature is not supported in this tour. You can try it in our [playground](https://try.moonbitlang.com) or in your terminal if the MoonBit toolchain is installed.**

In the first test block, we test some properties using the built-in functions `assert_eq`, `assert_false`, and `assert_true`.
By running `moon test` in the terminal or clicking the test button in your integrated development environment (IDE), the tests will be executed.

## Maintaining Tests

Sometimes it's tedious to maintain the expected value manually. MoonBit also supports built-in *snapshot tests*. Snapshot tests will run the tested code and store the expected result as a snapshot.

In the second test block, we use the `inspect` function to test the result of `fib` and the array's `map` method.
By running `moon test --update` in the terminal or clicking the `Update test` button in your IDE, the result will be automatically inserted as the second argument.

The next time you run the test, it will report any differences between the current result and the stored result. You can update the stored result to the new result by using the `--update` flag.




```mbt
test {
  assert_eq!(1, 1 + 2)
  assert_false!(1 == 2)
  assert_true!([1,2,3] == [1,2,3])
}

test {
  inspect!(fib(5))
  inspect!([1,2,3,4].map(fib))
}

// Add test name to make it more descriptive.
test "fibonacci" {
  inspect!(fib(5), content="5")
  inspect!(fib(6), content="8")
}

fn fib(n : Int) -> Int {
  if n < 2 {
    n
  } else {
    fib(n - 1) + fib(n - 2)
  }
}


```

# chapter1_basics/lesson1_variable

# Variables

The `let` keyword is used to define a variable.

The type of the variable can be annotated by using a colon followed by the type.
It is optional; if not provided, the type will be inferred from the value.

Variables are immutable by default in MoonBit. You can add an extra `mut`
keyword to make them mutable at the local level.

If you uncomment the `d = d + 1`, you will get an error.

```mbt
fn main {
  let a : Int = 10 
  let b = 20 
  println(a + b)

  let mut  c = 10 
  c = c + 1
  println(c)

  let d = 20 
  // d = d + 1
  println(d)
}
```

# chapter1_basics/lesson2_numbers

# Numbers

Integers and floats are the most common types in MoonBit.
`Int`s can be represented in decimal, hexadecimal, octal, and binary,
and you can use the underscore to separate digits for better readability.
We call these *number literals*.

The `0xFFFF` is a hexadecimal number, `0o777` is an octal number, `0b1010` is a binary number,
and `1_000_000` is a decimal number equivalent to `1000000`.





```mbt
fn main {
  let dec : Int = 1000000
  let dec2 : Int = 1_000_000 
  let hex : Int = 0xFFFF 
  let oct = 0o777
  let bin = 0b1001 

  println(1 + 2)
  println(1 - 2)
  println(1 * 2)
  println(5 / 2)
  println(10 % 3)

  let num1 : Double = 3.14
  let num2 : Float = 3.14
}


```

# chapter1_basics/lesson3_function

# Function

This example defines two functions, `add` and `compute`.

The `add` function takes two arguments, `a` and `b`, and returns their sum.

The `compute` function takes no arguments and returns nothing. 
Its return type is `Unit`, which is used to represent the absence of a return value.








```mbt
fn add(a : Int, b : Int) -> Int {
  return a + b
}

fn compute() -> Unit {
  println(add(2, 40))
}

fn main {
  compute()
}


```

# chapter1_basics/lesson4_block

# Block and Statements

A block is an expression contains sequence of statements and an optional 
expression.

```
{
  statement1
  statement2
  expression
}
```

For example, the code above will execute `statement1`, `statement2`
and evaluate `expression` in order. The evaluation result of the block is the 
evaluation result of the expression. If the last one expression is omitted, 
the block will result in `()`, which type is `Unit`.


A statement can be a variable declaration, variable assignment, or any 
expression which type is `Unit`.  


A block is also associated with a namespace scope. In the `main` clause, the variable `a` declared in the inner block will shadow the outer `a`. It is only visible within the inner block.







```mbt
fn main {
  let a = 100

  {
    let mut a = 0
    println("checkpoint 1")
    a = a + 1
  }

  println("checkpoint 2")
  println(f())
}

fn f() -> Int {
  let b = 3.14

  let result = {
    let b = 1
    println("checkpoint 3")
    b + 5 
  }

  result // same as `return result` here
}



```

# chapter1_basics/lesson5_array

# Array

Array is a collection of elements that have the same type.

You can create an array using *array literal syntax*, which is a comma-separated list
of elements enclosed in square brackets: `[1,2,3]`.

You can also create an array by using the `Array::make` function, which takes a size and an element value,
as shown in the example, `Array::make(4,1)` creates an array equal to `[1,1,1,1]`.

The `arr3` is an array consisting of elements in `arr1`, elements in `arr2` and a few more numbers.
`..arr1` in square brackets is called an *array spread*, which is used to expand an array into another array.

## Array view

You can use the `array[start:end]` syntax to get a view of the array from index `start` to `end` (exclusive). The `start` and `end` parts are optional. A view is a reference to the original array and is used to avoid copying the array.

## Mutability of array

You may notice that we push an element to the array `arr1`, which changes the content of the array. How does that work if `arr1` is not marked with `mut`?

The answer is that the elements inside the array are mutable, which is **defined by the array type itself**. The `mut` keyword in the `let` statement is only used to determine whether the variable name you defined can be reassigned.

If you try to reassign `arr1` to another array like `arr1 = [1,2,3]`, you will get a compilation error.


```mbt
fn main {
  let arr1 : Array[Int] = [1, 2, 3, 4, 5]
  let arr2 = Array::make(4,1) 

  println(arr1.length()) // get the length of the array
  println(arr1[1]) // get the second element of the array

  // We can also use the spread operator to concatenate arrays.
  let arr3 = [..arr1, 1000, 2000, ..arr2, 3000, 4000]
  println("spread arrays:")
  println(arr3)

  let view : ArrayView[Int] = arr1[1:4]
  println("array view:")
  println(view)
  println("view[0]:")
  println(view[0])

  arr1.push(6) // push an element to the end
  println("updated array:")
  println(arr1)
}
```

# chapter1_basics/lesson6_string

# String

A string is a sequence of characters encoded in UTF-16. In MoonBit, strings are immutable,
which means you cannot change the elements inside a string.

MoonBit supports C-style escape characters in strings and chars, such as `\n` (newline),
`\t` (tab), `\\` (backslash), `\"` (double-quote), and `\'` (single-quote).

Unicode escape characters are also supported. You can use `\u{...}` (where `...` represents
the Unicode character's hex code) to represent a Unicode character by its code point.

MoonBit also supports string interpolation written like `\{variable}`, which allows you to embed expressions into strings.



```mbt
fn main {
  let str = "Hello, World!"
  // Access a character by index.
  let c : Char = str[4]
  println(c)
  let c2 = 'o'
  println(c == c2)

  // Use escape sequence.
  println("\nHello, \tWorld!")
  println("unicode \u{1F407} is a rabbit")

  // Concatenate two strings.
  println(str + " Hello, MoonBit!")

  // Use string interpolation.
  let moon = "Moon"
  let bit = "Bit"
  println("Use \{moon + bit}. Happy coding")
}
```

# chapter1_basics/lesson7_tuple

# Tuple

A tuple is a collection of values that can have different types. It is immutable,
which means that once it is created, it cannot be changed. It is created using
parentheses.

You can access the elements of tuple via the index: `tuple.0`, `tuple.1`, etc.

A tuple can be destructed via syntax like `let (a,b) = tuple`, where the `tuple` on
the right side is a tuple with two elements, and `a` and `b` are the variables to
store the elements. This is a special use case of *pattern matching* which we will
introduce in a later chapter.

It's common to use a tuple to return multiple values from a function.



```mbt
fn main {
  // create Tuple 
  let tuple = (3.14, false, [1,2,3])  
  let tuple2 : (Float, Bool, Int) = (2.1, true, 20)
  println(tuple)

  // Accessing tuple elements
  println(tuple.0)
  println(tuple.2)

  // Tuple can also be destructured. 
  let (a, b, c) = f()
  println("\{a}, \{b}, \{c}")
}

fn f() -> (Int, Bool, Double) {
  (1, false, 3.14) // return multiple values via tuple
}

```

# chapter1_basics/lesson8_map

# Map

A map is a collection of key-value pairs. Each key is unique in the map, and all keys are associated with a value. It is a mutable collection.

An expression like `{"key1": value1, "key2": value2}` represents a map, called a *map literal*.
If the key and value types of the map are basic types (`Int`, `String`,`Bool`, `Double`, etc.),
then the map can be written as a *map literal*.

In other cases, you can create the map using the `Map::of` function. It takes an array of two-element tuples, where the first element is the key and the second element is the value.

Values in a map can be accessed by the key using the `map[key]` syntax.

The elements in a map can be updated using the syntax: `map[key] = new_value`.


```mbt
fn main {
  // Create a map by map literal
  let map1 = { "key1": 1, "key2": 2, "key3": 3 }
  println(map1)
  // You can also create a map by Map::of, from a list of key-value pairs
  let map2 = Map::of([("key1", 1), ("key2", 2), ("key3", 3)])
  println(map1 == map2)

  // Access a value by key
  println(map1["key1"])

  // Update a value by key
  map1["key1"] = 10
  println(map1)

  // test a if a key exists
  println(map1.contains("key1"))
}

```

# chapter1_basics/lesson9_if_else

# If expression

An if expression is a conditional control flow expression that has a result value.

In an if expression, each branch must have the same type. If the condition is true, it returns the result value of the first branch. Otherwise, it returns the result value of the second branch.

The `else` part is optional. If it is omitted, the type of the whole if expression will be `Unit`.

Nested if expressions in the else part can be shortened by using `else if`.







```mbt
fn fib(x : Int) -> Int {
  if x < 2 {
    x
  } else {
    fib(x - 1) + fib(x - 2)
  }
}

fn main {
  if 5 > 1 {
    println("5 is greater than 1")
  }
  println(fib(5))
  println(weekday(3))
}

fn weekday(x : Int) -> String {
  if x == 1 {
    "Monday"
  } else if x == 2 {
    "Tuesday"
  } else if x == 3 {
    "Wednesday"
  } else if x == 4 {
    "Thursday"
  } else if x == 5 {
    "Friday"
  } else if x == 6 {
    "Saturday"
  } else if x == 7 {
    "Sunday"
  } else {
    "Invalid day"
  }
}

```

# chapter2_data_types/lesson1_struct

# Struct

Struct is a new type composed of other types.

In the example we define a struct `Point` with two fields, `x` and `y`, both of which are integers.

We can create an instance of `Point` by writing `{ x: 3, y: 4 }`. The struct name can be omitted since the compiler can infer it from the labels `x` and `y`.

We can also add a `Point::` prefix to create an instance explicitly to disambiguate its type.

Analogous to tuples, we can access the fields of a struct using the syntax `point.x`.

The `derive(Show)` after the struct definition means that we can print the struct using the `println` function.

The fields of a struct are immutable by default; they can't be changed after they are created. There is a syntax called *functional update* that allows you to create a new struct with some fields updated.

We will learn how to make the fields mutable in the next lesson.



```mbt
struct Point {
  x : Int
  y : Int
} derive(Show)

fn main {
  // create a point
  let point = { x: 3, y: 4 }
  println("point: \{point}")
  println("point.x: \{point.x}")
  println("point.y: \{point.y}")
  
  // functional update
  let point2 = {..point, x: 20}
  println(point2)
}


```

# chapter2_data_types/lesson2_mutable_field

# Mutable fields in Struct

Struct fields are immutable by default, but we can make them mutable by using the `mut` keyword in the field declaration.

In previous lessons, we have learned that collections in MoonBit can be either mutable or immutable. This is achieved by using the `mut` keyword in their type declaration.

The `MutPoint` struct in the example has two fields, mutable `mx` and immutable `y`.
You can change the value of the `mx` field via reassignment but not the value of `y`.


```mbt
struct MutPoint {
  mut mx : Int
  y : Int
} derive(Show)

fn main {
  let point = { mx: 3, y: 4 }
  println("point: \{point}")
  point.mx = 10
  println("point: \{point}")
}


```

# chapter2_data_types/lesson3_enum

# Enum

An enum is used to define a type by enumerating its possible values.
Unlike traditional enums, MoonBit enums can have data associated with each enumeration.
We call each enumeration an *enum constructor*.

In this example, we define an enum `Color`, which has five enum constructors: `Red`, `Green`, `Blue`, `RGB`, and `CMYK`.
The `Red`, `Green`, and `Blue` values directly represent the colors they describe, while `RGB` and `CMYK` have data associated with them.

Values like `Red` and `RGB(255,255,255)` are both instances of the `Color` type. To create an instance more explicitly, you can use `Color::Red`, similar to creating an instance of a struct.

We use a bit of *pattern matching* to distinguish different *enum constructors* in `print_color`. It's a control flow similar to switch-case in C-like languages. Here is a slight difference: you can extract the associated data by giving them a name on the left of `=>`, and use them as variables on the right side.

We will explore more powerful features of *pattern matching* in the next chapter.



```mbt
enum Color {
  Red
  Green
  Blue
  RGB(Int, Int, Int)
  CMYK(Int, Int, Int, Int)
}

fn print_color(color : Color) -> Unit {
  match color {
    Red => println("Red")
    Green => println("Green")
    Blue => println("Blue")
    // Take the three Int values from RGB and print them.
    RGB(r, g, b) => println("RGB: \{r}, \{g}, \{b}")
    CMYK(c, m, y, k) => println("CMYK: \{c}, \{m}, \{y}, \{k}")
  }
}

fn main {
  let red = Red
  let green = Color::Green
  let blue = RGB(0, 0, 255)
  let black = CMYK(0, 0, 0, 100)
  print_color(red)
  print_color(green)
  print_color(blue)
  print_color(black)
}

```

# chapter2_data_types/lesson4_newtype

# Newtype

Newtypes are similar to enums with only one constructor (with the same name as the newtype itself). You can use the constructor to create values of the newtype and use `._` to extract the internal representation. 

You can also use *pattern matching* with newtypes.



```mbt
type UserId Int
type UserName String

fn main {
  let user_id : UserId = UserId(1)
  let user_name : UserName = UserName("Alice")
  println(user_id._)
  println(user_name._)
  // use some pattern matching to extract the values
  let UserId(id) = user_id 
  let UserName(name) = user_name
}

```

# chapter2_data_types/lesson5_option

# Option

`Option[Char]` is an enum that represents a `Char` value that may or may not be present. It is a common way to handle exceptional cases.

- `None` means the value is missing.
- `Some(e)` is a wrapper that contains the value `e`.

The `[Char]` part in the type is a type parameter, which means the value type in `Option` is `Char`. We can use `Option[String]`, `Option[Double]`, etc. We will cover generics later.

The type annotation `Option[A]` can be shortened to `A?`.

You can use `c1.is_empty()` to check if the value is missing and `c1.unwrap()` to get the value.



```mbt
fn first_char(s : String) -> Option[Char] {
  if s.length() == 0 {
    None
  } else {
    Some(s[0])
  }
}

fn main {
  let c1 : Char? = first_char("hello")
  let c2 : Option[Char] = first_char("")
  println("\{c1.is_empty()}, \{c1.unwrap()}")
  println("\{c2.is_empty()}, \{c2}")
}

```

# chapter2_data_types/lesson6_result

# Result

Similar to `Option[Char]`, the enum `Result[Char, String]` represents a `Char` value that may or may not be present. If not present, it can contain an error message of type `String`.

- `Err("error message")` means the value is missing, and the error message is provided.
- `Ok('h')` is a wrapper that contains the value `'h'`.

The processing of `Option` and `Result` in examples so far is verbose and prone to bugs. To handle `Option` and `Result` values safely and cleanly, you can use *pattern matching*. It's recommended to use *error handling* to process errors effectively. These two topics will be covered in a later chapter.



```mbt
fn first_char(s : String) -> Result[Char, String] {
  if s.length() == 0 {
    Err("empty string")
  } else {
    Ok(s[0])
  }
}

fn main {
  let c1  = first_char("hello")
  let c2  = first_char("")
  println("\{c1.is_ok()}, \{c1}, \{c1.unwrap()}")
  println("\{c2.is_err()}, \{c2}")
}

```

# chapter3_pattern_matching/lesson1_introduction

# Pattern Matching

We have seen pattern matching in the previous example.
It's a powerful feature in MoonBit that can be used in many places. It can help you test conditions conveniently and effectively, making your programs more precise and robust.

In this example, we give some basic use cases of pattern matching. Some other languages call it "destructuring" or "structured bindings", a way to extract values from a complex data structure.

"Destructuring" is just a subset of this feature.
In MoonBit, almost every type you can construct can have a form to "destruct", which we call a *pattern*.


```mbt
struct Point {
  x : Int
  y : Int
} derive(Show)

fn main {
  let tuple = (1, false, 3.14)
  let array = [1, 2, 3]
  let record = { x: 5, y: 6 }
  let (a, b, c) = tuple
  println("a:\{a}, b:\{b}, c:\{c}")
  let [d, e, f] = array
  println("d:\{d}, e:\{e}, f:\{f}")
  let { x, y } = record
  println("x:\{x}, y:\{y}")
}

```

# chapter3_pattern_matching/lesson2_let_and_match

# Pattern in let and match

There are two common places to use a pattern: `let` and `match`.

In this example, we define a `Resource` type that describes a file system.
The `Resource` can be a text file, an image, or a folder associated with more files.

## Pattern in let statement

In a `let` statement, the left side of `=` can be a pattern.
We know that `assets` is a folder so we just use `let Folder(top_level) = assets` to match it and extract the value into the immutable variable `top_level`.

You may notice that there is a partial match warning because the resource can also be `Image` or `TextFile`.
**Partial matches make the program more fragile: the pattern matching may fail in other cases and lead to the program aborting.**
Practically, the `match` expression is used more frequently than the `let` statement.

## Pattern in match expression

The `count` function traverses the input `res` recursively and returns the count of `Image` and `TextFile`, using a `match` expression.

Match expressions have *first match semantics*. They will try to find the first matching pattern sequentially from the first case to the last case and execute the corresponding matched expression. If no pattern matches, the program will abort.

The match expression has an `Int` return value because all the cases result in the same value type `Int`.

Patterns can be nested. If you don't care about the data associated with the enum constructor, you can use the *any pattern*, written as `_`, instead of introducing a new variable.
The underscore means that the value is discarded.


```mbt
enum Resource {
  TextFile(String)
  Image(String)
  Folder(Map[String, Resource])
}

let assets : Resource = Folder(
  {
    "readme.md": TextFile("hello world"),
    "image.jpg": Image("https://someurl1"),
    "folder1": Folder(
      {
        "src1.mbt": TextFile("some code1"),
        "src2.mbt": TextFile("some MoonBit code 2"),
      },
    ),
    "folder2": Folder(
      {
        "src3.mbt": TextFile("some code3"),
        "image2.jpg": Image("https://someurl2"),
      },
    ),
  },
)

fn main {
  let Folder(top_level) = assets
  println("we have items in the root folder:\n \{top_level.keys()}")
  println("resource count: \{count(assets)}")
}

fn count(res : Resource) -> Int {
  match res {
    Folder(map) => {
      let mut sum = 0
      for name, res in map {
        sum += count(res)
      }
      sum
    }
    TextFile(_) => 1
    Image(_) => 1
  }
}


```

# chapter3_pattern_matching/lesson3_constant_pattern

# Constant pattern

Almost all constants in MoonBit can be represented as a constant pattern.


```mbt
fn fibonacci(x : Int) -> Int {
  // assume x > 0
  match x {
    1 => 1
    2 => 2
    _ => fibonacci(x - 1) + fibonacci(x - 2)
  }
}

fn negate(x : Bool) -> Bool {
  match x {
    true => false
    false => true
  }
}

fn read(x : Char) -> Int? {
  match x {
    '1' => Some(1)
    '2' => Some(2)
    '3' => Some(3)
    _ => None
  }
}

fn contents(file : String) -> String? {
  match file {
    "README" => Some("# hello world")
    "hello.mbt" => Some("println(\"hello world\")")
    _ => None
  }
}

fn main {
  println("fib(5): \{fibonacci(5)}")
  println("negate(false): \{negate(false)}")
  println("read('2'): \{read('2')}, read('5'): \{read('5')}")
  println(contents("README"))
}

```

# chapter3_pattern_matching/lesson4_tuple_pattern

# Tuple pattern

Use a tuple pattern to match multiple conditions at once.

This example simulates *logical and* and *logical or* operations via pattern matching.

In this scenario, the overhead of creating the tuple in the condition will be optimized out by the compiler.




```mbt
fn logical_and(x : Bool, y : Bool) -> Bool {
  match (x, y) {
    (true, true) => true
    (false, _) => false
    (_, false) => false
  }
}

fn logical_or(x : Bool, y : Bool) -> Bool {
  match (x, y) {
    (true, _) => true
    (_, true) => true
    _ => false
  }
}

fn main {
  println("true and false: \{logical_and(true, false)}")
  println("true or false: \{logical_or(true, false)}")
}

```

# chapter3_pattern_matching/lesson5_alias_pattern

# Alias Pattern

Any pattern can be bound to an extra new name via an *alias pattern*. The syntax is `pattern as name`. In this example, we use this feature to preserve the original tuples while pattern matching them.






```mbt
fn main {
  let (a, (b, _) as tuple, _) as triple = (1, (true, 5), false)
  println("a: \{a}, b: \{b}")
  println("tuple: \{tuple}")
  println("triple: \{triple}")
}

```

# chapter3_pattern_matching/lesson6_array_pattern

# Array Pattern

An array pattern is a sequence of patterns enclosed in `[]` that matches an array.

You can use `..` to match the rest of the array at the start, end, or middle elements of the array.

In an array pattern, the `..` part can be bound to a new variable via an *alias pattern*. The type of that variable is `ArrayView`. The `sum` function uses this feature to calculate the sum of the array recursively.


```mbt
fn main {
  let array = [1, 2, 3, 4, 5, 6]
  let [a, b, ..] = array
  let [.., c, d] = array
  let [e,  ..,  f] = array
  println("a: \{a}, b: \{b}")
  println("c: \{c}, d: \{d}")
  println("e: \{e}, f: \{f}")
  println("sum of array: \{sum(array[:])}")
}

fn sum(array : ArrayView[Int]) -> Int {
  match array {
    [] => 0
    [x, .. as xs] => x + sum(xs)
  }
}

```

# chapter3_pattern_matching/lesson7_or_pattern

# Or Pattern

It's a little verbose if any two cases have common data and the same code to handle them. For example, here is an enum `RGB` and a function `get_green` to get the green value from it.

The `RGB` and `RGBA` cases can be combined as well. In an *or pattern*, the sub-patterns can introduce new variables, but they must be of the same type and have the same name in all sub-patterns. This restriction allows us to handle them uniformly.



```mbt
enum Color {
  Blue
  Red
  Green
  RGB(Int, Int, Int)
  RGBA(Int, Int, Int, Int)
} derive(Show)

fn get_green(color : Color) -> Int {
  match color {
    Blue | Red => 0
    Green => 255
    RGB(_, g, _) | RGBA(_, g, _, _) => g
  }
}

fn main {
  println("The green part of Red is \{get_green(Red)}")
  println("The green part of Green is \{get_green(Green)}")
  println("The green part of Blue is \{get_green(Blue)}")
  println("The green part of RGB(0,0,0) is \{get_green(RGB(0,0,0))}")
  println("The green part of RGBA(50,5,0,6) is \{get_green(RGBA(50,5,0,6))}")
}

```

# chapter3_pattern_matching/lesson8_range_pattern

# Range Pattern

For consecutive values, using the previously introduced *or-patterns* can be somewhat cumbersome. To address this issue, we can use *range patterns*. *Range patterns* can match values within a specified range.


Recall the syntax we learned in Chapter 1:

- `start..<end` range is inclusive of the start value and exclusive of the end value.
- `start..=end` range is inclusive of both the start and end values.


Range patterns support built-in integer-like types, such as `Byte`, `Int`, `UInt`, `Int64`, `UInt64`, and `Char`.



```mbt
fn score_to_grade(score : Int) -> String {
  match score {
    0..<60 => "F"
    60..<70 => "D"
    70..<80 => "C"
    80..<90 => "B"
    90..=100 => "A"
    _ => "Invalid score"
  }
}

fn classify_char(c : Char) -> String {
  match c {
    'A'..='Z' => "UpperCase"
    'a'..='z' => "LowerCase"
    '0'..='9' => "Digit"
    _ => "Special"
  }
}

fn is_scalar_value(codepoint : Int) -> Bool {
  match codepoint {
    0x0000..=0xD7FF | 0xE000..=0x10FFFF => true
    _ => false
  }
}

fn main {
  println(score_to_grade(50))
  println(score_to_grade(85))
  println(score_to_grade(95))
  println(classify_char('A'))
  println(classify_char('1'))
  println(classify_char('!'))
  println(is_scalar_value(0xD500))
}

```