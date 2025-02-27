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

# Moonbit Toolchain and Tutorial Documentation

## Next - Toolchain

### Index

# Toolchains

Here are some manuals that may help you use the toolchains of the programming language:

- [MoonBit's Build System](./moon/index.md): full manual of `moon` build system.
- VSCode extension
- ...

[Download this section in Markdown](path:/download/toolchain/summary.md)

```{toctree}
:maxdepth: 2
:caption: Contents:
moon/index

### Commands

# Command-Line Help for `moon`

This document contains the help content for the `moon` command-line program.

**Command Overview:**

* [`moon`↴](#moon)
* [`moon new`↴](#moon-new)
* [`moon build`↴](#moon-build)
* [`moon check`↴](#moon-check)
* [`moon run`↴](#moon-run)
* [`moon test`↴](#moon-test)
* [`moon clean`↴](#moon-clean)
* [`moon fmt`↴](#moon-fmt)
* [`moon doc`↴](#moon-doc)
* [`moon info`↴](#moon-info)
* [`moon add`↴](#moon-add)
* [`moon remove`↴](#moon-remove)
* [`moon install`↴](#moon-install)
* [`moon tree`↴](#moon-tree)
* [`moon login`↴](#moon-login)
* [`moon register`↴](#moon-register)
* [`moon publish`↴](#moon-publish)
* [`moon package`↴](#moon-package)
* [`moon update`↴](#moon-update)
* [`moon coverage`↴](#moon-coverage)
* [`moon coverage report`↴](#moon-coverage-report)
* [`moon coverage clean`↴](#moon-coverage-clean)
* [`moon generate-build-matrix`↴](#moon-generate-build-matrix)
* [`moon upgrade`↴](#moon-upgrade)
* [`moon shell-completion`↴](#moon-shell-completion)
* [`moon version`↴](#moon-version)

## `moon`

**Usage:** `moon <COMMAND>`

**Subcommands:**

* `new` — Create a new MoonBit module
* `build` — Build the current package
* `check` — Check the current package, but don't build object files
* `run` — Run a main package
* `test` — Test the current package
* `clean` — Remove the target directory
* `fmt` — Format source code
* `doc` — Generate documentation
* `info` — Generate public interface (`.mbti`) files for all packages in the module
* `add` — Add a dependency
* `remove` — Remove a dependency
* `install` — Install dependencies
* `tree` — Display the dependency tree
* `login` — Log in to your account
* `register` — Register an account at mooncakes.io
* `publish` — Publish the current module
* `package` — Package the current module
* `update` — Update the package registry index
* `coverage` — Code coverage utilities
* `generate-build-matrix` — Generate build matrix for benchmarking (legacy feature)
* `upgrade` — Upgrade toolchains
* `shell-completion` — Generate shell completion for bash/elvish/fish/pwsh/zsh to stdout
* `version` — Print version information and exit



## `moon new`

Create a new MoonBit module

**Usage:** `moon new [OPTIONS] [PACKAGE_NAME]`

**Arguments:**

* `<PACKAGE_NAME>` — The name of the package

**Options:**

* `--lib` — Create a library package instead of an executable
* `--path <PATH>` — Output path of the package
* `--user <USER>` — The user name of the package
* `--name <NAME>` — The name part of the package
* `--license <LICENSE>` — The license of the package

  Default value: `Apache-2.0`
* `--no-license` — Do not set a license for the package



## `moon build`

Build the current package

**Usage:** `moon build [OPTIONS]`

**Options:**

* `--std` — Enable the standard library (default)
* `--nostd` — Disable the standard library
* `-g`, `--debug` — Emit debug information
* `--release` — Compile in release mode
* `--strip` — Enable stripping debug information
* `--no-strip` — Disable stripping debug information
* `--target <TARGET>` — Select output target

  Possible values: `wasm`, `wasm-gc`, `js`, `native`, `all`

* `--serial` — Handle the selected targets sequentially
* `--enable-coverage` — Enable coverage instrumentation
* `--sort-input` — Sort input files
* `--output-wat` — Output WAT instead of WASM
* `-d`, `--deny-warn` — Treat all warnings as errors
* `--no-render` — Don't render diagnostics from moonc (don't pass '-error-format json' to moonc)
* `--warn-list <WARN_LIST>` — Warn list config
* `--alert-list <ALERT_LIST>` — Alert list config
* `--frozen` — Do not sync dependencies, assuming local dependencies are up-to-date
* `-w`, `--watch` — Monitor the file system and automatically build artifacts



## `moon check`

Check the current package, but don't build object files

**Usage:** `moon check [OPTIONS] [PACKAGE_PATH]`

**Arguments:**

* `<PACKAGE_PATH>` — The package(and it's deps) to check

**Options:**

* `--std` — Enable the standard library (default)
* `--nostd` — Disable the standard library
* `-g`, `--debug` — Emit debug information
* `--release` — Compile in release mode
* `--strip` — Enable stripping debug information
* `--no-strip` — Disable stripping debug information
* `--target <TARGET>` — Select output target

  Possible values: `wasm`, `wasm-gc`, `js`, `native`, `all`

* `--serial` — Handle the selected targets sequentially
* `--enable-coverage` — Enable coverage instrumentation
* `--sort-input` — Sort input files
* `--output-wat` — Output WAT instead of WASM
* `-d`, `--deny-warn` — Treat all warnings as errors
* `--no-render` — Don't render diagnostics from moonc (don't pass '-error-format json' to moonc)
* `--warn-list <WARN_LIST>` — Warn list config
* `--alert-list <ALERT_LIST>` — Alert list config
* `--output-json` — Output in json format
* `--frozen` — Do not sync dependencies, assuming local dependencies are up-to-date
* `-w`, `--watch` — Monitor the file system and automatically check files
* `--patch-file <PATCH_FILE>` — The patch file to check, Only valid when checking specified package
* `--no-mi` — Whether to skip the mi generation, Only valid when checking specified package



## `moon run`

Run a main package

**Usage:** `moon run [OPTIONS] <PACKAGE_OR_MBT_FILE> [ARGS]...`

**Arguments:**

* `<PACKAGE_OR_MBT_FILE>` — The package or .mbt file to run
* `<ARGS>` — The arguments provided to the program to be run

**Options:**

* `--std` — Enable the standard library (default)
* `--nostd` — Disable the standard library
* `-g`, `--debug` — Emit debug information
* `--release` — Compile in release mode
* `--strip` — Enable stripping debug information
* `--no-strip` — Disable stripping debug information
* `--target <TARGET>` — Select output target

  Possible values: `wasm`, `wasm-gc`, `js`, `native`, `all`

* `--serial` — Handle the selected targets sequentially
* `--enable-coverage` — Enable coverage instrumentation
* `--sort-input` — Sort input files
* `--output-wat` — Output WAT instead of WASM
* `-d`, `--deny-warn` — Treat all warnings as errors
* `--no-render` — Don't render diagnostics from moonc (don't pass '-error-format json' to moonc)
* `--warn-list <WARN_LIST>` — Warn list config
* `--alert-list <ALERT_LIST>` — Alert list config
* `--frozen` — Do not sync dependencies, assuming local dependencies are up-to-date
* `--build-only` — Only build, do not run the code



## `moon test`

Test the current package

**Usage:** `moon test [OPTIONS]`

**Options:**

* `--std` — Enable the standard library (default)
* `--nostd` — Disable the standard library
* `-g`, `--debug` — Emit debug information
* `--release` — Compile in release mode
* `--strip` — Enable stripping debug information
* `--no-strip` — Disable stripping debug information
* `--target <TARGET>` — Select output target

  Possible values: `wasm`, `wasm-gc`, `js`, `native`, `all`

* `--serial` — Handle the selected targets sequentially
* `--enable-coverage` — Enable coverage instrumentation
* `--sort-input` — Sort input files
* `--output-wat` — Output WAT instead of WASM
* `-d`, `--deny-warn` — Treat all warnings as errors
* `--no-render` — Don't render diagnostics from moonc (don't pass '-error-format json' to moonc)
* `--warn-list <WARN_LIST>` — Warn list config
* `--alert-list <ALERT_LIST>` — Alert list config
* `-p`, `--package <PACKAGE>` — Run test in the specified package
* `-f`, `--file <FILE>` — Run test in the specified file. Only valid when `--package` is also specified
* `-i`, `--index <INDEX>` — Run only the index-th test in the file. Only valid when `--file` is also specified
* `-u`, `--update` — Update the test snapshot
* `-l`, `--limit <LIMIT>` — Limit of expect test update passes to run, in order to avoid infinite loops

  Default value: `256`
* `--frozen` — Do not sync dependencies, assuming local dependencies are up-to-date
* `--build-only` — Only build, do not run the tests
* `--no-parallelize` — Run the tests in a target backend sequentially
* `--test-failure-json` — Print failure message in JSON format
* `--patch-file <PATCH_FILE>` — Path to the patch file
* `--doc` — Run doc test



## `moon clean`

Remove the target directory

**Usage:** `moon clean`



## `moon fmt`

Format source code

**Usage:** `moon fmt [OPTIONS] [ARGS]...`

**Arguments:**

* `<ARGS>`

**Options:**

* `--check` — Check only and don't change the source code
* `--sort-input` — Sort input files
* `--block-style <BLOCK_STYLE>` — Add separator between each segments

  Possible values: `false`, `true`




## `moon doc`

Generate documentation

**Usage:** `moon doc [OPTIONS]`

**Options:**

* `--serve` — Start a web server to serve the documentation
* `-b`, `--bind <BIND>` — The address of the server

  Default value: `127.0.0.1`
* `-p`, `--port <PORT>` — The port of the server

  Default value: `3000`
* `--frozen` — Do not sync dependencies, assuming local dependencies are up-to-date



## `moon info`

Generate public interface (`.mbti`) files for all packages in the module

**Usage:** `moon info [OPTIONS]`

**Options:**

* `--frozen` — Do not sync dependencies, assuming local dependencies are up-to-date
* `--no-alias` — Do not use alias to shorten package names in the output



## `moon add`

Add a dependency

**Usage:** `moon add [OPTIONS] <PACKAGE_PATH>`

**Arguments:**

* `<PACKAGE_PATH>` — The package path to add

**Options:**

* `--bin` — Whether to add the dependency as a binary



## `moon remove`

Remove a dependency

**Usage:** `moon remove <PACKAGE_PATH>`

**Arguments:**

* `<PACKAGE_PATH>` — The package path to remove



## `moon install`

Install dependencies

**Usage:** `moon install`



## `moon tree`

Display the dependency tree

**Usage:** `moon tree`



## `moon login`

Log in to your account

**Usage:** `moon login`



## `moon register`

Register an account at mooncakes.io

**Usage:** `moon register`



## `moon publish`

Publish the current module

**Usage:** `moon publish [OPTIONS]`

**Options:**

* `--frozen` — Do not sync dependencies, assuming local dependencies are up-to-date



## `moon package`

Package the current module

**Usage:** `moon package [OPTIONS]`

**Options:**

* `--frozen` — Do not sync dependencies, assuming local dependencies are up-to-date
* `--list`



## `moon update`

Update the package registry index

**Usage:** `moon update`



## `moon coverage`

Code coverage utilities

**Usage:** `moon coverage <COMMAND>`

**Subcommands:**

* `report` — Generate code coverage report
* `clean` — Clean up coverage artifacts



## `moon coverage report`

Generate code coverage report

**Usage:** `moon coverage report [args]... [COMMAND]`

**Arguments:**

* `<args>` — Arguments to pass to the coverage utility

**Options:**

* `-h`, `--help` — Show help for the coverage utility



## `moon coverage clean`

Clean up coverage artifacts

**Usage:** `moon coverage clean`



## `moon generate-build-matrix`

Generate build matrix for benchmarking (legacy feature)

**Usage:** `moon generate-build-matrix [OPTIONS] --output-dir <OUT_DIR>`

**Options:**

* `-n <NUMBER>` — Set all of `drow`, `dcol`, `mrow`, `mcol` to the same value
* `--drow <DIR_ROWS>` — Number of directory rows
* `--dcol <DIR_COLS>` — Number of directory columns
* `--mrow <MOD_ROWS>` — Number of module rows
* `--mcol <MOD_COLS>` — Number of module columns
* `-o`, `--output-dir <OUT_DIR>` — The output directory



## `moon upgrade`

Upgrade toolchains

**Usage:** `moon upgrade [OPTIONS]`

**Options:**

* `-f`, `--force` — Force upgrade



## `moon shell-completion`

Generate shell completion for bash/elvish/fish/pwsh/zsh to stdout

**Usage:** `moon shell-completion [OPTIONS]`


Discussion:
Enable tab completion for Bash, Elvish, Fish, Zsh, or PowerShell
The script is output on `stdout`, allowing one to re-direct the
output to the file of their choosing. Where you place the file
will depend on which shell, and which operating system you are
using. Your particular configuration may also determine where
these scripts need to be placed.

The completion scripts won't update itself, so you may need to
periodically run this command to get the latest completions.
Or you may put `eval "$(moon shell-completion --shell <SHELL>)"`
in your shell's rc file to always load newest completions on startup.
Although it's considered not as efficient as having the completions
script installed.

Here are some common set ups for the three supported shells under
Unix and similar operating systems (such as GNU/Linux).

Bash:

Completion files are commonly stored in `/etc/bash_completion.d/` for
system-wide commands, but can be stored in
`~/.local/share/bash-completion/completions` for user-specific commands.
Run the command:

    $ mkdir -p ~/.local/share/bash-completion/completions
    $ moon shell-completion --shell bash >> ~/.local/share/bash-completion/completions/moon

This installs the completion script. You may have to log out and
log back in to your shell session for the changes to take effect.

Bash (macOS/Homebrew):

Homebrew stores bash completion files within the Homebrew directory.
With the `bash-completion` brew formula installed, run the command:

    $ mkdir -p $(brew --prefix)/etc/bash_completion.d
    $ moon shell-completion --shell bash > $(brew --prefix)/etc/bash_completion.d/moon.bash-completion

Fish:

Fish completion files are commonly stored in
`$HOME/.config/fish/completions`. Run the command:

    $ mkdir -p ~/.config/fish/completions
    $ moon shell-completion --shell fish > ~/.config/fish/completions/moon.fish

This installs the completion script. You may have to log out and
log back in to your shell session for the changes to take effect.

Elvish:

Elvish completions are commonly stored in a single `completers` module.
A typical module search path is `~/.config/elvish/lib`, and
running the command:

    $ moon shell-completion --shell elvish >> ~/.config/elvish/lib/completers.elv

will install the completions script. Note that use `>>` (append) 
instead of `>` (overwrite) to prevent overwriting the existing completions 
for other commands. Then prepend your rc.elv with:

    `use completers`

to load the `completers` module and enable completions.

Zsh:

ZSH completions are commonly stored in any directory listed in
your `$fpath` variable. To use these completions, you must either
add the generated script to one of those directories, or add your
own to this list.

Adding a custom directory is often the safest bet if you are
unsure of which directory to use. First create the directory; for
this example we'll create a hidden directory inside our `$HOME`
directory:

    $ mkdir ~/.zfunc

Then add the following lines to your `.zshrc` just before
`compinit`:

    fpath+=~/.zfunc

Now you can install the completions script using the following
command:

    $ moon shell-completion --shell zsh > ~/.zfunc/_moon

You must then open a new zsh session, or simply run

    $ . ~/.zshrc

for the new completions to take effect.

Custom locations:

Alternatively, you could save these files to the place of your
choosing, such as a custom directory inside your $HOME. Doing so
will require you to add the proper directives, such as `source`ing
inside your login script. Consult your shells documentation for
how to add such directives.

PowerShell:

The powershell completion scripts require PowerShell v5.0+ (which
comes with Windows 10, but can be downloaded separately for windows 7
or 8.1).

First, check if a profile has already been set

    PS C:\> Test-Path $profile

If the above command returns `False` run the following

    PS C:\> New-Item -path $profile -type file -force

Now open the file provided by `$profile` (if you used the
`New-Item` command it will be
`${env:USERPROFILE}\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1`

Next, we either save the completions file into our profile, or
into a separate file and source it inside our profile. To save the
completions into our profile simply use

    PS C:\> moon shell-completion --shell powershell >>
    ${env:USERPROFILE}\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

This discussion is taken from `rustup completions` command with some changes.


**Options:**

* `--shell <SHELL>` — The shell to generate completion for

  Default value: `<your shell>`

  Possible values: `bash`, `elvish`, `fish`, `powershell`, `zsh`




## `moon version`

Print version information and exit

**Usage:** `moon version [OPTIONS]`

**Options:**

* `--all` — Print all version information
* `--json` — Print version information in JSON format
* `--no-path` — Do not print the path



<hr/>

<small><i>
    This document was generated automatically by
    <a href="https://crates.io/crates/clap-markdown"><code>clap-markdown</code></a>.
</i></small>

### Coverage

# Measuring code coverage

We have included tooling for you to measure the code coverage of test and program runs.
The measurement is currently based on branch coverage.
In other words, it measures whether each program branch were executed,
and how many times if they were.

## Running code coverage in tests

To enable coverage instrumentation in tests,
you need to pass the `--enable-coverage` argument to `moon test`.

```
$ moon test --enable-coverage
...
Total tests: 3077, passed: 3077, failed: 0.
```

This will recompile the project
if they weren't previously compiled with coverage enabled.
The execution process will look the same,
but new coverage result files will be generated under the `target` directory.

```
$ ls target/wasm-gc/debug/test/ -w1
array
...
moonbit_coverage_1735628238436873.txt
moonbit_coverage_1735628238436883.txt
...
moonbit_coverage_1735628238514678.txt
option/
...
```

These files contain the information for the toolchain to determine
which parts of the program were executed,
and which parts weren't.

## Visualizing the coverage results

To visualize the result of coverage instrumentation,
you'll need to use the `moon coverage report` subcommand.

The subcommand can export the coverage in a number of formats,
controlled by the `-f` flag:

- Text summary: `summary`
- OCaml Bisect format: `bisect` (default)
- Coveralls JSON format: `coveralls`
- Cobertura XML format: `cobertura`
- HTML pages: `html`

### Text summary

`moon coverage report -f summary` exports the coverage data into stdout,
printing the covered points and total coverage point count for each file.

```
$ moon coverage report -f summary
array/array.mbt: 21/22
array/array_nonjs.mbt: 3/3
array/blit.mbt: 3/3
array/deprecated.mbt: 0/0
array/fixedarray.mbt: 115/115
array/fixedarray_sort.mbt: 110/116
array/fixedarray_sort_by.mbt: 58/61
array/slice.mbt: 6/6
array/sort.mbt: 70/70
array/sort_by.mbt: 56/61
...
```

### OCaml Bisect format

This is the default format to export, if `-f` is not specified.

`moon coverage report -f bisect` exports the coverage data into
a file `bisect.coverage` which can be read by [OCaml Bisect][bisect] tool.

[bisect]: https://github.com/aantron/bisect_ppx

### Coveralls JSON format

`moon coverage report -f coveralls` exports the coverage data into Coverall's JSON format.
This format is line-based, and can be read by both Coveralls and CodeCov.
You can find its specification [here](https://docs.coveralls.io/api-introduction#json-format-web-data).

```
$ moon coverage report -f coveralls
$ cat coveralls.json
{
    "source_files": [
        {
            "name": "builtin/console.mbt",
            "source_digest": "1c24532e12ac5bdf34b7618c9f38bd82",
            "coverage": [null,null,...,null,null]
        },
        {
            "name": "immut/array/array.mbt",
            "source_digest": "bcf1fb1d2f143ebf4423565d5a57e84f",
            "coverage": [null,null,null,...
```

You can directly send this coverage report to Coveralls or CodeCov using the `--send-to` argument.
The following is an example of using it in GitHub Actions:

```
moon coverage report \
    -f coveralls \
    -o codecov_report.json \
    --service-name github \
    --service-job-id "$GITHUB_RUN_NUMBER" \
    --service-pull-request "${{ github.event.number }}" \
    --send-to coveralls

env:
    COVERALLS_REPO_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

More information can be found in `moon coverage report --help`.

### Cobertura XML format

`moon coverage report -f cobertura` exports the coverage data into a format that can be read by [Cobertura](https://cobertura.github.io/cobertura/).

### HTML

`moon coverage report -f html` export the coverage data into a series of human-readable HTML files.
The default export location is the folder named `_coverage`.

The `index.html` in the folder shows a list of all source files,
as well as the coverage percentage in them:

![Index of the HTML](/imgs/coverage_html_index.png)

Clicking on each file shows the coverage detail within each file.
Each coverage point (start of branch)
is represented by a highlighted character in the source code:
Red means the point is not covered among all runs,
and green means the point is covered in at least one run.

Each line is also highlighted by the coverage information,
with the same color coding.
Additionally,
yellow lines are those which has partial coverage:
some points in the line are covered, while others aren't.

Some lines will not have any highlight.
This does not mean the line has not been executed at all,
just the line is not a start of a branch.
Such a line shares the coverage of closest covered the line before it.

![Detailed coverage data](/imgs/coverage_html_page.png)

## Skipping coverage

Adding the pragma `/// @coverage.skip` skips all coverage operations within the function.
Additionally, all deprecated functions will not be covered.


### Index

# Moon Build System

```{toctree}
:maxdepth: 2
:caption: Contents:
tutorial
package-manage-tour
commands
module
package
coverage
```


### Module

# Module Configuration

moon uses the `moon.mod.json` file to identify and describe a module. For full JSON schema, please check [moon's repository](https://github.com/moonbitlang/moon/blob/main/crates/moonbuild/template/mod.schema.json).

## Name

The `name` field is used to specify the name of the module, and it is required.

```json
{
  "name": "example",
  // ...
}
```

The module name can contain letters, numbers, `_`, `-`, and `/`.

For modules published to [mooncakes.io](https://mooncakes.io), the module name must begin with the username. For example:

```json
{
  "name": "moonbitlang/core",
  // ...
}
```

## Version

The `version` field is used to specify the version of the module.

This field is optional. For modules published to [mooncakes.io](https://mooncakes.io), the version number must follow the [Semantic Versioning 2.0.0](https://semver.org/spec/v2.0.0.html) specification.

```json
{
  "name": "example",
  "version": "0.1.0",
  // ...
}
```

## Deps

The `deps` field is used to specify the dependencies of the module.

It is automatically managed by commands like `moon add` and `moon remove`.

```json
{
  "name": "username/hello",
  "deps": {
    "moonbitlang/x": "0.4.6"
  }
}
```

## README

The `readme` field is used to specify the path to the module's README file.

## Repository

The `repository` field is used to specify the URL of the module's repository.

## License

The `license` field is used to specify the license of the module. The license type must comply with the [SPDX License List](https://spdx.org/licenses/).

```json
{
  "license": "MIT"
}
```

## Keywords

The `keywords` field is used to specify the keywords for the module.

```json
{
  "keywords": ["example", "test"]
}
```

## Description

The `description` field is used to specify the description of the module.

```json
{
  "description": "This is a description of the module."
}
```

## Source directory

The `source` field is used to specify the source directory of the module.

It must be a subdirectory of the directory where the `moon.mod.json` file is located and must be a relative path.

When creating a module using the `moon new` command, a `src` directory will be automatically generated, and the default value of the `source` field will be `src`.

```json
{
  "source": "src"
}
```

When the `source` field does not exist, or its value is `null` or an empty string `""`, it is equivalent to setting `"source": "."`. This means that the source directory is the same as the directory where the `moon.mod.json` file is located.

```json
{
  "source": null
}
{
  "source": ""
}
{
  "source": "."
}
```

## Warning List

This is used to disable specific preset compiler warning numbers.

For example, in the following configuration, `-2` disables the warning number 2 (Unused variable).

```json
{
  "warn-list": "-2",
}
```

You can use `moonc build-package -warn-help` to see the list of preset compiler warning numbers.

```
$ moonc -v                      
v0.1.20240914+b541585d3

$ moonc build-package -warn-help
Available warnings: 
  1 Unused function.
  2 Unused variable.
  3 Unused type declaration.
  4 Redundant case in a pattern matching (unused match case).
  5 Unused function argument.
  6 Unused constructor.
  7 Unused module declaration.
  8 Unused struct field.
 10 Unused generic type variable.
 11 Partial pattern matching.
 12 Unreachable code.
 13 Unresolved type variable.
 14 Lowercase type name.
 15 Unused mutability.
 16 Parser inconsistency.
 18 Useless loop expression.
 19 Top-level declaration is not left aligned.
 20 Invalid pragma
 21 Some arguments of constructor are omitted in pattern.
 22 Ambiguous block.
 23 Useless try expression.
 24 Useless error type.
 26 Useless catch all.
  A all warnings
```

## Alert List

Disable user preset alerts.

```json
{
  "alert-list": "-alert_1-alert_2"
}
```

### Package Manage Tour

# MoonBit's Package Manager Tutorial

## Overview

MoonBit's build system seamlessly integrates package management and documentation generation tools, allowing users to easily fetch dependencies from mooncakes.io, access module documentation, and publish new modules.

[mooncakes.io](https://mooncakes.io/) is a centralized package management platform. Each module has a corresponding configuration file `moon.mod.json`, which is the smallest unit for publishing. Under the module's path, there can be multiple packages, each corresponding to a `moon.pkg.json` configuration file. The `.mbt` files at the same level as `moon.pkg.json` belong to this package.

Before getting started, make sure you have installed [moon](https://www.moonbitlang.com/download/).

## Setup mooncakes.io account

```{note}
If you don't need to publishing, you can skip this step.
```

If you don't have an account on mooncakes.io, run `moon register` and follow the guide. If you have previously registered an account, you can use `moon login` to log in.

When you see the following message, it means you have successfully logged in:

```
API token saved to ~/.moon/credentials.json
```

## Update index

Use `moon update` to update the mooncakes.io index.

![moon update cli](/imgs/moon-update.png)

## Setup MoonBit project

Open an existing project or create a new project via `moon new`:

![moon new](/imgs/moon-new.png)

## Add dependencies

You can browse all available modules on mooncakes.io. Use `moon add` to add the dependencies you need, or manually edit the `deps` field in `moon.mod.json`.

For example, to add the latest version of the `Yoorkin/example/list` module:

![add deps](/imgs/add-deps.png)

## Import packages from module

Modify the configuration file `moon.pkg.json` and declare the packages that need to be imported in the `import` field.

For example, in the image below, the `hello/main/moon.pkg.json` file is modified to declare the import of `Yoorkin/example/list` in the `main` package. Now, you can call the functions of the third-party package in the `main` package using `@list`.

![import package](/imgs/import.png)

You can also give an alias to the imported package:

```json
{
    "is_main": true,
    "import": [
        { "path": "Yoorkin/example/list", "alias": "ls" }
    ]
}
```

Read the documentation of this module on mooncakes.io, we can use its `of_array` and `reverse` functions to implement a new function `reverse_array`.

![reverse array](/imgs/reverse-array.png)

## Remove dependencies

You can remove dependencies via `moon remove <module name>`.

## Publish your module

If you are ready to share your module, use `moon publish` to push a module to
mooncakes.io. There are some important considerations to keep in mind before publishing:

### Semantic versioning convention

MoonBit's package management follows the convention of [Semantic Versioning](https://semver.org/). Each module must define a version number in the format `MAJOR.MINOR.PATCH`. With each push, the module must increment the:

- MAJOR version when you make incompatible API changes
- MINOR version when you add functionality in a backward compatible manner
- PATCH version when you make backward compatible bug fixes

Additional labels for pre-release and build metadata are available as extensions to the `MAJOR.MINOR.PATCH` format.

moon implements the [minimal version selection](https://research.swtch.com/vgo-mvs), which automatically handles and installs dependencies based on the module's semantic versioning information. Minimal version selection assumes that each module declares its own dependency requirements and follows semantic versioning convention, aiming to make the user's dependency graph as close as possible to the author's development-time dependencies.

### Readme & metadata

Metadata in `moon.mod.json` and `README.md` will be shown in mooncakes.io.

Metadata consist of the following sections:

- `license`: license of this module, it following the [SPDX](https://spdx.dev/about/overview/) convention
- `keywords`: keywords of this module
- `repository`: URL of the package source repository
- `description`: short description to this module
- `homepage`: URL of the module homepage

### Moondoc

mooncakes.io will generate documentation for each modules automatically.

The leading `///` comments of each toplevel will be recognized as documentation.
You can write markdown inside.

```moonbit
/// Get the largest element of a non-empty `Array`.
///
/// # Example
///
/// ```
/// maximum([1,2,3,4,5,6]) = 6
/// ```
///
/// # Panics
///
/// Panics if the `xs` is empty.
///
pub fn maximum[T : Compare](xs : Array[T]) -> T {
  // TODO ...
}
```

You can also use `moon doc --serve` to generate and view documentation in local.


### Package

# Package Configuration

moon uses the `moon.pkg.json` file to identify and describe a package. For full JSON schema, please check [moon's repository](https://github.com/moonbitlang/moon/blob/main/crates/moonbuild/template/pkg.schema.json).

## Name

The package name is not configurable; it is determined by the directory name of the package.

## is-main

The `is-main` field is used to specify whether a package needs to be linked into an executable file.

The output of the linking process depends on the backend. When this field is set to `true`:

- For the Wasm and `wasm-gc` backends, a standalone WebAssembly module will be generated.
- For the `js` backend, a standalone JavaScript file will be generated.

## Importing dependencies

### import

The `import` field is used to specify other packages that a package depends on.

For example, the following imports `moonbitlang/quickcheck` and `moonbitlang/x/encoding`, 
aliasing the latter to `lib` and importing the function `encode` from the latter.
User can write `@lib.encode` instead of `encode`.

```json
{
  "import": [
    "moonbitlang/quickcheck",
    { "path" : "moonbitlang/x/encoding", "alias": "lib", "value": ["encode"] }
  ]
}
```

### test-import

The `test-import` field is used to specify other packages that the black-box test package of this package depends on,
with the same format as `import`.

The `test-import` field is used to specify whether the public definitions from the package being tested should be imported (`true`) by default.

### wbtest-import

The `wbtest-import` field is used to specify other packages that the white-box test package of this package depends on,
with the same format as `import`.

## Conditional Compilation

The smallest unit of conditional compilation is a file.

In a conditional compilation expression, three logical operators are supported: `and`, `or`, and `not`, where the `or` operator can be omitted.

For example, `["or", "wasm", "wasm-gc"]` can be simplified to `["wasm", "wasm-gc"]`.

Conditions in the expression can be categorized into backends and optimization levels:

- **Backend conditions**: `"wasm"`, `"wasm-gc"`, and `"js"`
- **Optimization level conditions**: `"debug"` and `"release"`

Conditional expressions support nesting.

If a file is not listed in `"targets"`, it will be compiled under all conditions by default.

Example:

```json
{
  "targets": {
    "only_js.mbt": ["js"],
    "only_wasm.mbt": ["wasm"],
    "only_wasm_gc.mbt": ["wasm-gc"],
    "all_wasm.mbt": ["wasm", "wasm-gc"],
    "not_js.mbt": ["not", "js"],
    "only_debug.mbt": ["debug"],
    "js_and_release.mbt": ["and", ["js"], ["release"]],
    "js_only_test.mbt": ["js"],
    "js_or_wasm.mbt": ["js", "wasm"],
    "wasm_release_or_js_debug.mbt": ["or", ["and", "wasm", "release"], ["and", "js", "debug"]]
  }
}
```

## Link Options

By default, moon only links packages where `is-main` is set to `true`. If you need to link other packages, you can specify this with the `link` option.

The `link` option is used to specify link options, and its value can be either a boolean or an object.

- When the `link` value is `true`, it indicates that the package should be linked. The output will vary depending on the backend specified during the build.

  ```json
  {
    "link": true
  }
  ```

- When the `link` value is an object, it indicates that the package should be linked, and you can specify link options. For detailed configuration, please refer to the subpage for the corresponding backend.

### Wasm Backend Link Options

#### Common Options

- The `exports` option is used to specify the function names exported by the Wasm backend.

  For example, in the following configuration, the `hello` function from the current package is exported as the `hello` function in the Wasm module, and the `foo` function is exported as the `bar` function in the Wasm module. In the Wasm host, the `hello` and `bar` functions can be called to invoke the `hello` and `foo` functions from the current package.

  ```json
  {
    "link": {
      "wasm": {
        "exports": [
          "hello",
          "foo:bar"
        ]
      },
      "wasm-gc": {
        "exports": [
          "hello",
          "foo:bar"
        ]
      }
    }
  }
  ```

- The `import-memory` option is used to specify the linear memory imported by the Wasm module.

  For example, the following configuration specifies that the linear memory imported by the Wasm module is the `memory` variable from the `env` module.

  ```json
  {
    "link": {
      "wasm": {
        "import-memory": {
          "module": "env",
          "name": "memory"
        }
      },
      "wasm-gc": {
        "import-memory": {
          "module": "env",
          "name": "memory"
        }
      }
    }
  }
  ```

- The `export-memory-name` option is used to specify the name of the linear memory exported by the Wasm module.

  ```json
  {
    "link": {
      "wasm": {
        "export-memory-name": "memory"
      },
      "wasm-gc": {
        "export-memory-name": "memory"
      }
    }
  }
  ```

#### Wasm Linear Backend Link Options

- The `heap-start-address` option is used to specify the starting address of the linear memory that can be used when compiling to the Wasm backend.

  For example, the following configuration sets the starting address of the linear memory to 1024.

  ```json
  {
    "link": {
      "wasm": {
        "heap-start-address": 1024
      }
    }
  }
  ```

#### Wasm GC Backend Link Options

- The `use-js-string-builtin` option is used to specify whether the [JS String Builtin Proposal](https://github.com/WebAssembly/js-string-builtins/blob/main/proposals/js-string-builtins/Overview.md) should be enabled when compiling to the Wasm GC backend. 
  It will make the `String` in MoonBit equivalent to the `String` in JavaScript host runtime.

  For example, the following configuration enables the JS String Builtin.

  ```json
  {
    "link": {
      "wasm-gc": {
        "use-js-builtin-string": true
      }
    }
  }
  ```

- The `imported-string-constants` option is used to specify the imported string namespace used by the JS String Builtin Proposal, which is "_" by default.
  It should meet the configuration in the JS host runtime.

  For example, the following configuration and JS initialization configures the imported string namespace.

  ```json
  {
    "link": {
      "wasm-gc": {
        "use-js-builtin-string": true,
        "imported-string-constants": "_"
      }
    }
  }
  ```

  ```javascript
  const { instance } = await WebAssembly.instantiate(bytes, {}, { importedStringConstants: "strings" });
  ```

### JS Backend Link Options

- The `exports` option is used to specify the function names to export in the JavaScript module.

  For example, in the following configuration, the `hello` function from the current package is exported as the `hello` function in the JavaScript module. In the JavaScript host, the `hello` function can be called to invoke the `hello` function from the current package.

  ```json
  {
    "link": {
      "js": {
        "exports": [
          "hello"
        ]
      }
    }
  }
  ```

- The `format` option is used to specify the output format of the JavaScript module.

  The currently supported formats are:
  - `esm`
  - `cjs`
  - `iife`

  For example, the following configuration sets the output format of the current package to ES Module.

  ```json
  {
    "link": {
      "js": {
        "format": "esm"
      }
    }
  }
  ```

## Pre-build

The `"pre-build"` field is used to specify pre-build commands, which will be executed before build commands such as `moon check|build|test`.

`"pre-build"` is an array, where each element is an object containing `input`, `output`, and `command` fields. The `input` and `output` fields can be strings or arrays of strings, while the `command` field is a string. In the `command`, you can use any shell commands, as well as the `$input` and `$output` variables, which represent the input and output files, respectively. If these fields are arrays, they will be joined with spaces by default.

Currently, there is a built-in special command `:embed`, which converts files into MoonBit source code. The `--text` parameter is used to embed text files, and `--binary` is used for binary files. `--text` is the default and can be omitted. The `--name` parameter is used to specify the generated variable name, with `resource` being the default. The command is executed in the directory where the `moon.pkg.json` file is located.

```json
{
  "pre-build": [
    {
      "input": "a.txt",
      "output": "a.mbt",
      "command": ":embed -i $input -o $output"
    }
  ]
}
```

If the content of `a.txt` in the current package directory is:
```
hello,
world
```

After running `moon build`, the following `a.mbt` file will be generated in the directory where the `moon.pkg.json` is located:

```
let resource : String =
  #|hello,
  #|world
  #|
```

## Warning List

This is used to disable specific preset compiler warning numbers.

For example, in the following configuration, `-2` disables the warning number 2 (Unused variable).

```json
{
  "warn-list": "-2",
}
```

You can use `moonc build-package -warn-help` to see the list of preset compiler warning numbers.

```
$ moonc -v                      
v0.1.20240914+b541585d3

$ moonc build-package -warn-help
Available warnings: 
  1 Unused function.
  2 Unused variable.
  3 Unused type declaration.
  4 Redundant case in a pattern matching (unused match case).
  5 Unused function argument.
  6 Unused constructor.
  7 Unused module declaration.
  8 Unused struct field.
 10 Unused generic type variable.
 11 Partial pattern matching.
 12 Unreachable code.
 13 Unresolved type variable.
 14 Lowercase type name.
 15 Unused mutability.
 16 Parser inconsistency.
 18 Useless loop expression.
 19 Top-level declaration is not left aligned.
 20 Invalid pragma
 21 Some arguments of constructor are omitted in pattern.
 22 Ambiguous block.
 23 Useless try expression.
 24 Useless error type.
 26 Useless catch all.
  A all warnings
```

## Alert List

Disable user preset alerts.

```json
{
  "alert-list": "-alert_1-alert_2"
}
```

### Tutorial

# MoonBit's Build System Tutorial

Moon is the build system for the MoonBit language, currently based on the [n2](https://github.com/evmar/n2) project. Moon supports parallel and incremental builds. Additionally, moon also supports managing and building third-party packages on [mooncakes.io](https://mooncakes.io/)

## Prerequisites

Before you begin with this tutorial, make sure you have installed the following:

1. **MoonBit CLI Tools**: Download it from the <https://www.moonbitlang.com/download/>. This command line tool is needed for creating and managing MoonBit projects.

    Use `moon help` to view the usage instructions.

    ```bash
    $ moon help
    ...
    ```

2. **MoonBit Language** plugin in Visual Studio Code: You can install it from the VS Code marketplace. This plugin provides a rich development environment for MoonBit, including functionalities like syntax highlighting, code completion, and more.

Once you have these prerequisites fulfilled, let's start by creating a new MoonBit module.

## Creating a New Module

To create a new module, enter the `moon new` command in the terminal, and you will see the module creation wizard. By using all the default values, you can create a new module named `username/hello` in the `my-project` directory.

```bash
$ moon new
Enter the path to create the project (. for current directory): my-project
Select the create mode: exec
Enter your username: username
Enter your project name: hello
Enter your license: Apache-2.0
Created my-project
```

> If you want use all default values, you can use `moon new my-project` to create a new module named `username/hello` in the `my-project` directory.

## Understanding the Module Directory Structure

After creating the new module, your directory structure should resemble the following:

```bash
my-project
├── LICENSE
├── README.md
├── moon.mod.json
└── src
    ├── lib
    │   ├── hello.mbt
    │   ├── hello_test.mbt
    │   └── moon.pkg.json
    └── main
        ├── main.mbt
        └── moon.pkg.json
```

Here's a brief explanation of the directory structure:

- `moon.mod.json` is used to identify a directory as a MoonBit module. It contains the module's metadata, such as the module name, version, etc. `source` specifies the source directory of the module. The default value is `src`.

  ```json
  {
    "name": "username/hello",
    "version": "0.1.0",
    "readme": "README.md",
    "repository": "",
    "license": "Apache-2.0",
    "keywords": [],
    "description": "",
    "source": "src"
  }
  ```

- `lib` and `main` directories: These are the packages within the module. Each package can contain multiple `.mbt` files, which are the source code files for the MoonBit language. However, regardless of how many `.mbt` files a package has, they all share a common `moon.pkg.json` file. `lib/*_test.mbt` are separate test files in the `lib` package, these files are for blackbox test, so private members of the `lib` package cannot be accessed directly.

- `moon.pkg.json` is package descriptor. It defines the properties of the package, such as whether it is the main package and the packages it imports.

  - `main/moon.pkg.json`:

    ```json
    {
      "is_main": true,
      "import": [
        "username/hello/lib"
      ]
    }
    ```

  Here, `"is_main: true"` declares that the package needs to be linked by the build system into a wasm file.

  - `lib/moon.pkg.json`:

    ```json
    {}
    ```

  This file is empty. Its purpose is simply to inform the build system that this folder is a package.

## Working with Packages

Our `username/hello` module contains two packages: `username/hello/lib` and `username/hello/main`.

The `username/hello/lib` package contains `hello.mbt` and `hello_test.mbt` files:

  `hello.mbt`

  ```moonbit
  pub fn hello() -> String {
      "Hello, world!"
  }
  ```

  `hello_test.mbt`

  ```moonbit
  test "hello" {
    if @lib.hello() != "Hello, world!" {
      fail!("@lib.hello() != \"Hello, world!\"")
    }
  }
  ```

The `username/hello/main` package contains a `main.mbt` file:

  ```moonbit
  fn main {
    println(@lib.hello())
  }
  ```

To execute the program, specify the file system's path to the `username/hello/main` package in the `moon run` command:

```bash
$ moon run ./src/main
Hello, world!
```

You can also omit `./`

```bash
$ moon run src/main
Hello, world!
```

You can test using the `moon test` command:

```bash
$ moon test
Total tests: 1, passed: 1, failed: 0.
```

## Package Importing

In the MoonBit's build system, a module's name is used to reference its internal packages.
To import the `username/hello/lib` package in `src/main/main.mbt`, you need to specify it in `src/main/moon.pkg.json`:

```json
{
  "is_main": true,
  "import": [
    "username/hello/lib"
  ]
}
```

Here, `username/hello/lib` specifies importing the `username/hello/lib` package from the `username/hello` module, so you can use `@lib.hello()` in `main/main.mbt`.

Note that the package name imported in `src/main/moon.pkg.json` is `username/hello/lib`, and `@lib` is used to refer to this package in `src/main/main.mbt`. The import here actually generates a default alias for the package name `username/hello/lib`. In the following sections, you will learn how to customize the alias for a package.

## Creating and Using a New Package

First, create a new directory named `fib` under `lib`:

```bash
mkdir src/lib/fib
```

Now, you can create new files under `src/lib/fib`:

`a.mbt`:

```moonbit
pub fn fib(n : Int) -> Int {
  match n {
    0 => 0
    1 => 1
    _ => fib(n - 1) + fib(n - 2)
  }
}
```

`b.mbt`:

```moonbit
pub fn fib2(num : Int) -> Int {
  fn aux(n, acc1, acc2) {
    match n {
      0 => acc1
      1 => acc2
      _ => aux(n - 1, acc2, acc1 + acc2)
    }
  }

  aux(num, 0, 1)
}
```

`moon.pkg.json`:

```json
{}
```

After creating these files, your directory structure should look like this:

```bash
my-project
├── LICENSE
├── README.md
├── moon.mod.json
└── src
    ├── lib
    │   ├── fib
    │   │   ├── a.mbt
    │   │   ├── b.mbt
    │   │   └── moon.pkg.json
    │   ├── hello.mbt
    │   ├── hello_test.mbt
    │   └── moon.pkg.json
    └── main
        ├── main.mbt
        └── moon.pkg.json
```

In the `src/main/moon.pkg.json` file, import the `username/hello/lib/fib` package and customize its alias to `my_awesome_fibonacci`:

```json
{
  "is_main": true,
  "import": [
    "username/hello/lib",
    {
      "path": "username/hello/lib/fib",
      "alias": "my_awesome_fibonacci"
    }
  ]
}
```

This line imports the `fib` package, which is part of the `lib` package in the `hello` module. After doing this, you can use the `fib` package in `main/main.mbt`. Replace the file content of `main/main.mbt` to:

```moonbit
fn main {
  let a = @my_awesome_fibonacci.fib(10)
  let b = @my_awesome_fibonacci.fib2(11)
  println("fib(10) = \{a}, fib(11) = \{b}")

  println(@lib.hello())
}
```

To execute your program, specify the path to the `main` package:

```bash
$ moon run ./src/main
fib(10) = 55, fib(11) = 89
Hello, world!
```

## Adding Tests

Let's add some tests to verify our fib implementation. Add the following content in `src/lib/fib/a.mbt`:

`src/lib/fib/a.mbt`

```moonbit
test {
  assert_eq!(fib(1), 1)
  assert_eq!(fib(2), 1)
  assert_eq!(fib(3), 2)
  assert_eq!(fib(4), 3)
  assert_eq!(fib(5), 5)
}
```

This code tests the first five terms of the Fibonacci sequence. `test { ... }` defines an inline test block. The code inside an inline test block is executed in test mode.

Inline test blocks are discarded in non-test compilation modes (`moon build` and `moon run`), so they won't cause the generated code size to bloat.

## Stand-alone test files for blackbox tests

Besides inline tests, MoonBit also supports stand-alone test files. Source files ending in `_test.mbt` are considered test files for blackbox tests. For example, inside the `src/lib/fib` directory, create a file named `fib_test.mbt` and paste the following code:

`src/lib/fib/fib_test.mbt`

```moonbit
test {
  assert_eq!(@fib.fib(1), 1)
  assert_eq!(@fib.fib2(2), 1)
  assert_eq!(@fib.fib(3), 2)
  assert_eq!(@fib.fib2(4), 3)
  assert_eq!(@fib.fib(5), 5)
}
```

Notice that the test code uses `@fib` to refer to the `username/hello/lib/fib` package. The build system automatically creates a new package for blackbox tests by using the files that end with `_test.mbt`. This new package will import the current package automatically, allowing you to use `@lib` in the test code.

Finally, use the `moon test` command, which scans the entire project, identifies, and runs all inline tests as well as files ending with `_test.mbt`. If everything is normal, you will see:

```bash
$ moon test
Total tests: 3, passed: 3, failed: 0.
$ moon test -v
test username/hello/lib/hello_test.mbt::hello ok
test username/hello/lib/fib/a.mbt::0 ok
test username/hello/lib/fib/fib_test.mbt::0 ok
Total tests: 3, passed: 3, failed: 0.
```

## Next - Tutorial

### Index

# Tutorial

Here are some tutorials that may help you learn the programming language:

- [An interactive tour with language basics](https://tour.moonbitlang.com)
- [Tour for Beginners](./tour.md)

[Download this section in Markdown](path:/download/tutorial/summary.md)

```{toctree}
:hidden:
tour

### Tour

# A Tour of MoonBit for Beginners

This guide is intended for newcomers, and it's not meant to be a 5-minute quick
tour. This article tries to be a succinct yet easy to understand guide for those
who haven't programmed in a way that MoonBit enables them to, that is, in a more
modern, functional way.

See [the General Introduction](../language/index.md) if you want to straight
delve into the language.

## Installation

**The extension**

Currently, MoonBit development support is through the VS Code extension.
Navigate to
[VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=moonbit.moonbit-lang)
to download MoonBit language support.

**The toolchain**

> (Recommended) If you've installed the extension above, the runtime can be
> directly installed by running 'Install moonbit toolchain' in the action menu
> and you may skip this part:
> ![runtime-installation](/imgs/runtime-installation.png)

We also provide an installation script: Linux & macOS users can install via

```bash
curl -fsSL https://cli.moonbitlang.com/install/unix.sh | bash
```

For Windows users, PowerShell is used:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser; irm https://cli.moonbitlang.com/install/powershell.ps1 | iex
```

This automatically installs MoonBit in `$HOME/.moon` and adds it to your `PATH`.

If you encounter `moon` not found after installation, try restarting your
terminal or VS Code to let the environment variable take effect.

Do notice that MoonBit is not production-ready at the moment, it's under active
development. To update MoonBit, just run the commands above again.

Running `moon help` gives us a bunch of subcommands. But right now the only
commands we need are `build`, `run`, and `new`.

To create a project (or module, more formally), run `moon new`. You will be
greeted with a creation wizard.

If you choose to create an `exec` mode project, you will get:

```
my-project
├── LICENSE
├── moon.mod.json
├── README.md
└── src
    ├── lib
    │   ├── hello.mbt
    │   ├── hello_test.mbt
    │   └── moon.pkg.json
    └── main
        ├── main.mbt
        └── moon.pkg.json
```

which contains a `main` lib containing a `fn main` that serves as the entrance
of the program. Try running `moon run src/main`.

If you choose to create a `lib` mode project, you will get:

```
my-project
├── LICENSE
├── moon.mod.json
├── README.md
└── src
    ├── lib
    │   ├── hello.mbt
    │   ├── hello_test.mbt
    │   └── moon.pkg.json
    ├── moon.pkg.json
    └── top.mbt
```

In this tutorial, we will work with the `lib` mode project, and we assume the
project name is `examine`.

## Example: Finding those who passed

In this example, we will try to find out, given the scores of some students, how
many of them have passed the test?

To do so, we will start with defining our data types, identify our functions,
and write our tests. Then we will implement our functions.

Unless specified, the following will be defined under the file `src/top.mbt`.

### Data types

The [basic data types](/language/fundamentals.md#built-in-data-structures) in MoonBit includes the following:

- `Unit`
- `Bool`
- `Int`, `UInt`, `Int64`, `UInt64`, `Byte`, ...
- `Float`, `Double`
- `Char`, `String`, ...
- `Array[T]`, ...
- Tuples, and still others

To represent a record containing a student ID and a score using a primitive
type, we can use a 2-tuple containing a student ID (of type `String`) and a
score (of type `Double`) as `(String, Double)`. However this is not very
intuitive as we can't identify with other possible data types, such as a record
containing a student ID and the height of the student.

So we choose to declare our own data type using [struct](/language/fundamentals.md#struct):

```{code-block} moonbit
:class: top-level
struct Student {
  id : String
  score : Double
}
```

One can either pass or fail an exam, so the judgement result can be defined
using [enum](/language/fundamentals.md#enum):

```{code-block} moonbit
:class: top-level
enum ExamResult {
  Pass
  Fail
}
```

### Functions

[Function](/language/fundamentals.md#functions) is a piece of code that takes some inputs and produces a result.

In our example, we need to judge whether a student have passed an exam:

```{code-block} moonbit
:class: top-level
fn is_qualified(student : Student, criteria: Double) -> ExamResult {
  ...
}
```

This function takes an input `student` of type `Student` that we've just defined, an input `criteria` of type `Double` as the criteria may be different for each courses or different in each country, and returns an `ExamResult`. 

The `...` syntax allows us to leave functions unimplemented for now.

We also need need to find out how many students have passed an exam:

```{code-block} moonbit
:class: top-level
fn count_qualified_students(
  students : Array[Student],
  is_qualified : (Student) -> ExamResult
) -> Int {
  ...
}
```

In MoonBit, functions are first-classed, meaning that we can bind a function to a variable, pass a function as parameter or receiving a function as a result.
This function takes an array of students' records and another function that will judge whether a student have passed an exam.

### Writing tests

We can define inline tests to define the expected behavior of the functions. This is also helpful to make sure that there'll be no regressions when we refactor the program.

```{code-block} moonbit
:class: top-level
test "is qualified" {
  assert_eq!(is_qualified(Student::{ id : "0", score : 50.0 }, 60.0), Fail)
  assert_eq!(is_qualified(Student::{ id : "1", score : 60.0 }, 60.0), Pass)
  assert_eq!(is_qualified(Student::{ id : "2", score : 13.0 }, 7.0), Pass)
}
```

We will get an error messaging, reminding us that `Show` and `Eq` are not implemented for `ExamResult`. 

`Show` and `Eq` are **traits**. A trait in MoonBit defines some common operations that a type should be able to perform.

For example, `Eq` defines that there should be a way to compare two values of the same type with a function called `op_equal`:

```{code-block} moonbit
:class: top-level
trait Eq {
  op_equal(Self, Self) -> Bool
}
```

and `Show` defines that there should be a way to either convert a value of a type into `String` or write it using a `Logger`:

```{code-block} moonbit
:class: top-level
trait Show {
  output(Self, &Logger) -> Unit
  to_string(Self) -> String
}
```

And the `assert_eq` uses them to constraint the passed parameters so that it can compare the two values and print them when they are not equal:

```{code-block} moonbit
:class: top-level
fn assert_eq![A : Eq + Show](value : A, other : A) -> Unit {
  ...
}
```

We need to implement `Eq` and `Show` for our `ExamResult`. There are two ways to do so.

1. By defining an explicit implementation:

    ```{code-block} moonbit
    :class: top-level
    impl Eq for ExamResult with op_equal(self, other) {
      match (self, other) {
        (Pass, Pass) | (Fail, Fail) => true
        _ => false
      }
    }
    ```

    Here we use [pattern matching](/language/fundamentals.md#pattern-matching) to check the cases of the `ExamResult`.

2. Other is by [deriving](/language/derive.md) since `Eq` and `Show` are [builtin traits](/language/methods.md#builtin-traits) and the output for `ExamResult` is quite straightforward:

    ```{code-block} moonbit
    :class: top-level
    enum ExamResult {
      Pass
      Fail
    } derive(Show)
    ```

Now that we've implemented the traits, we can continue with our test implementations:

```{code-block} moonbit
:class: top-level
test "count qualified students" {
  let students = [
    { id: "0", score: 10.0 },
    { id: "1", score: 50.0 },
    { id: "2", score: 61.0 },
  ]
  let criteria1 = fn(student) { is_qualified(student, 10) }
  let criteria2 = fn(student) { is_qualified(student, 50) }
  assert_eq!(count_qualified_students(students, criteria1), 3)
  assert_eq!(count_qualified_students(students, criteria2), 2)
}

```

Here we use [lambda expressions](/language/fundamentals.md#local-functions) to reuse the previously defined `is_qualified` to create different criteria.

We can run `moon test` to see whether the tests succeed or not.

### Implementing the functions

For the `is_qualified` function, it is as easy as a simple comparison:

```{code-block} moonbit
:class: top-level
fn is_qualified(student : Student, criteria : Double) -> ExamResult {
  if student.score >= criteria {
    Pass
  } else {
    Fail
  }
}
```

In MoonBit, the result of the last expression is the return value of the function, and the result of each branch is the value of the `if` expression.

For the `count_qualified_students` function, we need to iterate through the array to check if each student has passed or not.

A naive version is by using a mutable value and a [`for` loop](/language/fundamentals.md#for-loop):

```{code-block} moonbit
:class: top-level
fn count_qualified_students(
  students : Array[Student],
  is_qualified : (Student) -> ExamResult
) -> Int {
  let mut count = 0
  for i = 0; i < students.length(); i = i + 1 {
    if is_qualified(students[i]) == Pass {
      count += 1
    }
  }
  count
}
```

However, this is neither efficient (due to the border check) nor intuitive, so we can replace the `for` loop with a [`for .. in` loop](/language/fundamentals.md#for--in-loop):

```{code-block} moonbit
:class: top-level
fn count_qualified_students(
  students : Array[Student],
  is_qualified : (Student) -> ExamResult
) -> Int {
  let mut count = 0
  for student in students {
    if is_qualified(student) == Pass { count += 1}
  }
  count
}
```

Still another way is use the functions defined for [iterator](/language/fundamentals.md#iterator):

```{code-block} moonbit
:class: top-level
fn count_qualified_students(
  students : Array[Student],
  is_qualified : (Student) -> ExamResult
) -> Int {
  students.iter().filter(fn(student) { is_qualified(student) == Pass }).count()
}
```

Now the tests defined before should pass.

## Making the library available

Congratulation on your first MoonBit library!

You can now share it with other developers so that they don't need to repeat what you have done.

But before that, you have some other things to do.

### Adjusting the visibility

To see how other people may use our program, MoonBit provides a mechanism called ["black box test"](/language/tests.md#blackbox-tests-and-whitebox-tests).

Let's move the `test` block we defined above into a new file `src/top_test.mbt`.

Oops! Now there are errors complaining that:
- `is_qualified` and `count_qualified_students` are unbound
- `Fail` and `Pass` are undefined
- `Student` is not a record type and the field `id` is not found, etc.

All these come from the problem of visibility. By default, a function defined is not visible for other part of the program outside the current package (bound by the current folder).
And by default, a type is viewed as an abstract type, i.e. we know only that there exists a type `Student` and a type `ExamResult`. By using the black box test, you can make sure that
everything you'd like others to have is indeed decorated with the intended visibility.

In order for others to use the functions, we need to add `pub` before the `fn` to make the function public.

In order for others to construct the types and read the content, we need to add `pub(all)` before the `struct` and `enum` to make the types public.

We also need to slightly modify the test of `count qualified students` to add type annotation:

```{code-block} moonbit
:class: top-level
test "count qualified students" {
  let students: Array[@examine.Student] = [
    { id: "0", score: 10.0 },
    { id: "1", score: 50.0 },
    { id: "2", score: 61.0 },
  ]
  let criteria1 = fn(student) { @examine.is_qualified(student, 10) }
  let criteria2 = fn(student) { @examine.is_qualified(student, 50) }
  assert_eq!(@examine.count_qualified_students(students, criteria1), 3)
  assert_eq!(@examine.count_qualified_students(students, criteria2), 2)
}
```

Note that we access the type and the functions with `@examine`, the name of your package. This is how others use your package, but you can omit them in the black box tests.

And now, the compilation should work and the tests should pass again.

### Publishing the library

Now that you've ready, you can publish this project to [mooncakes.io](https://mooncakes.io),
the module registry of MoonBit. You can find other interesting projects there
too.

1. Execute `moon login` and follow the instruction to create your account with
   an existing GitHub account.
2. Modify the project name in `moon.mod.json` to
   `<your github account name>/<project name>`. Run `moon check` to see if
   there's any other affected places in `moon.pkg.json`.
3. Execute `moon publish` and your done. Your project will be available for
   others to use.

By default, the project will be shared under [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0.html), 
which is a permissive license allowing everyone to use. You can also use other licenses, such as the [MulanPSL 2.0](https://license.coscl.org.cn/MulanPSL2),
by changing the field `license` in `moon.mod.json` and the content of `LICENSE`.

### Closing

At this point, we've learned about the very basic and most not-so-trivial
features of MoonBit, yet MoonBit is a feature-rich, multi-paradigm programming
language. Visit [language tours](https://tour.moonbitlang.com) for more information in grammar and basic types,
and other documents to get a better hold of MoonBit.