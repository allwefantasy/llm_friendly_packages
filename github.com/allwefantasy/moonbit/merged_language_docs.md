# MoonBit 语言文档合集


## 文档：introduction

---

# Introduction

A MoonBit program consists of top-level definitions including:

- type definitions
- function definitions
- constant definitions and variable bindings
- `init` functions, `main` function and/or `test` blocks.

## Expressions and Statements

MoonBit distinguishes between statements and expressions. In a function body, only the last clause should be an expression, which serves as a return value. For example:

```{code-block} moonbit
:class: top-level
fn foo() -> Int {
  let x = 1
  x + 1
}

fn bar() -> Int {
  let x = 1
  //! x + 1
  x + 2
}
```

Expressions include:

- Value literals (e.g. Boolean values, numbers, characters, strings, arrays, tuples, structs)
- Arithmetical, logical, or comparison operations
- Accesses to array elements (e.g. `a[0]`), struct fields (e.g `r.x`), tuple components (e.g. `t.0`), etc.
- Variables and (capitalized) enum constructors
- Anonymous local function definitions
- `match`, `if`, `loop` expressions, etc.

Statements include:

- Named local function definitions
- Local variable bindings
- Assignments
- `return` statements
- Any expression whose return type is `Unit`, (e.g. `ignore`)

A code block can contain multiple statements and one expression, and the value of the expression is the value of the code block.

## Variable Binding

A variable can be declared as mutable or immutable using `let mut` or `let`, respectively. A mutable variable can be reassigned to a new value, while an immutable one cannot.

A constant can only be declared at top level and cannot be changed.

```{code-block} moonbit
:class: top-level
let zero = 0

const ZERO = 0

fn main {
  //! const ZERO = 0 
  let mut i = 10
  i = 20
  println(i + zero + ZERO)
}
```

```{note}
A top level variable binding 
- requires **explicit** type annotation (unless defined using literals such as string, byte or numbers)
- can't be mutable (use `Ref` instead)
```


## Naming conventions

Variables, functions should start with lowercase letters `a-z` and can contain letters, numbers, underscore, and other non-ascii unicode chars.
It is recommended to name them with snake_case.

Constants, types should start with uppercase letters `A-Z` and can contain letters, numbers, underscore, and other non-ascii unicode chars.
It is recommended to name them with PascalCase or SCREAMING_SNAKE_CASE.

## Program entrance

### `init` and `main`
There is a specialized function called `init` function. The `init` function is special:

1. It has no parameter list nor return type.
2. There can be multiple `init` functions in the same package.
3. An `init` function can't be explicitly called or referred to by other functions. 
Instead, all `init` functions will be implicitly called when initializing a package. Therefore, `init` functions should only consist of statements.

```{code-block} moonbit
:class: top-level
fn init {
  let x = 1
  println(x)
}
```

There is another specialized function called `main` function. The `main` function is the main entrance of the program, and it will be executed after the initialization stage.

Same as the `init` function, it has no parameter list nor return type.

```{code-block} moonbit
:class: top-level
fn main {
  let x = 2
  println(x)
}
```

The previous two code snippets will print the following at runtime:

```bash
1
2
```

Only packages that are `main` packages can define such `main` function. Check out [build system tutorial](/toolchain/moon/tutorial) for detail.

```{literalinclude} /sources/language/src/main/moon.pkg.json
:language: json
:caption: moon.pkg.json
```

### `test`

There's also a top-level structure called `test` block. A `test` block defines inline tests, such as:

```{literalinclude} /sources/language/src/test/top.mbt
:language: moonbit
:start-after: start test 1
:end-before: end test 1
```

The following contents will use `test` block and `main` function to demonstrate the execution result,
and we assume that all the `test` blocks pass unless stated otherwise.


---


## 文档：fundamentals

---

# Fundamentals

## Built-in Data Structures

### Unit

`Unit` is a built-in type in MoonBit that represents the absence of a meaningful value. It has only one value, written as `()`. `Unit` is similar to `void` in languages like C/C++/Java, but unlike `void`, it is a real type and can be used anywhere a type is expected.

The `Unit` type is commonly used as the return type for functions that perform some action but do not produce a meaningful result:

```{code-block} moonbit
:class: top-level
fn print_hello() -> Unit {
  println("Hello, world!")
}
```

Unlike some other languages, MoonBit treats `Unit` as a first-class type, allowing it to be used in generics, stored in data structures, and passed as function arguments.

### Boolean

MoonBit has a built-in boolean type, which has two values: `true` and `false`. The boolean type is used in conditional expressions and control structures.

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:dedent:
:start-after: start boolean 1
:end-before: end boolean 1
```

### Number

MoonBit have integer type and floating point type:

| type     | description                                       | example                    |
| -------- | ------------------------------------------------- | -------------------------- |
| `Int16`  | 16-bit signed integer                             | `(42 : Int16)`             |
| `Int`    | 32-bit signed integer                             | `42`                       |
| `Int64`  | 64-bit signed integer                             | `1000L`                    |
| `UInt16` | 16-bit unsigned integer                           | `(14 : UInt16)`            |
| `UInt`   | 32-bit unsigned integer                           | `14U`                      |
| `UInt64` | 64-bit unsigned integer                           | `14UL`                     |
| `Double` | 64-bit floating point, defined by IEEE754         | `3.14`                     |
| `Float`  | 32-bit floating point                             | `(3.14 : Float)`           |
| `BigInt` | represents numeric values larger than other types | `10000000000000000000000N` |

MoonBit also supports numeric literals, including decimal, binary, octal, and hexadecimal numbers.

To improve readability, you may place underscores in the middle of numeric literals such as `1_000_000`. Note that underscores can be placed anywhere within a number, not just every three digits.

- Decimal numbers can have underscore between the numbers. 

  By default, an int literal is signed 32-bit number. For unsigned numbers, a postfix `U` is needed; for 64-bit numbers, a postfix `L` is needed.

  ```{literalinclude} /sources/language/src/builtin/top.mbt
  :language: moonbit
  :dedent:
  :start-after: start number 1
  :end-before: end number 1
  ```

- A binary number has a leading zero followed by a letter "B", i.e. `0b`/`0B`.
  Note that the digits after `0b`/`0B` must be `0` or `1`.

  ```{literalinclude} /sources/language/src/builtin/top.mbt
  :language: moonbit
  :dedent:
  :start-after: start number 2
  :end-before: end number 2
  ```

- An octal number has a leading zero followed by a letter "O", i.e. `0o`/`0O`.
  Note that the digits after `0o`/`0O` must be in the range from `0` through `7`:

  ```{literalinclude} /sources/language/src/builtin/top.mbt
  :language: moonbit
  :dedent:
  :start-after: start number 3
  :end-before: end number 3
  ```

- A hexadecimal number has a leading zero followed by a letter "X", i.e. `0x`/`0X`.
  Note that the digits after the `0x`/`0X` must be in the range `0123456789ABCDEF`.

  ```{literalinclude} /sources/language/src/builtin/top.mbt
  :language: moonbit
  :dedent:
  :start-after: start number 4
  :end-before: end number 4
  ```

- A floating-point number literal is 64-bit floating-point number. To define a float, type annotation is needed.

  ```{literalinclude} /sources/language/src/builtin/top.mbt
  :language: moonbit
  :dedent:
  :start-after: start number 6
  :end-before: end number 6
  ```

  A 64-bit floating-point number can also be defined using hexadecimal format:

  ```{literalinclude} /sources/language/src/builtin/top.mbt
  :language: moonbit
  :dedent:
  :start-after: start number 7
  :end-before: end number 7
  ```

When the expected type is known, MoonBit can automatically overload literal, and there is no need to specify the type of number via letter postfix:

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:dedent:
:start-after: start number 5
:end-before: end number 5

```

```{seealso}
[Overloaded Literals](#overloaded-literals)
```

### String

`String` holds a sequence of UTF-16 code units. You can use double quotes to create a string, or use `#|` to write a multi-line string.

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:dedent:
:start-after: start string 1
:end-before: end string 1
```

```{literalinclude} /sources/language/src/builtin/__snapshot__/string_1
:caption: Output
```

In double quotes string, a backslash followed by certain special characters forms an escape sequence:

| escape sequences     | description                                          |
| -------------------- | ---------------------------------------------------- |
| `\n`, `\r`, `\t`, `\b` | New line, Carriage return, Horizontal tab, Backspace |
| `\\` | Backslash                                            |
| `\u5154` , `\u{1F600}` | Unicode escape sequence                              |

MoonBit supports string interpolation. It enables you to substitute variables within interpolated strings. This feature simplifies the process of constructing dynamic strings by directly embedding variable values into the text. Variables used for string interpolation must implement the [`Show` trait](/language/methods.md#builtin-traits).

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:dedent:
:start-after: start string 3
:end-before: end string 3
```

```{note}
The interpolated expression can not contain newline, `{}` or `"`.
```

Multi-line strings can be defined using the leading `#|` or `$|`, where the former will keep the raw string and the former will perform the escape and interpolation:

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:dedent:
:start-after: start string 4
:end-before: end string 4
```

```{literalinclude} /sources/language/src/builtin/__snapshot__/string_4
:caption: Output
```

When the expected type is `String` , the array literal syntax is overloaded to
construct the `String` by specifying each character in the string.

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:dedent:
:start-after: start string 5
:end-before: end string 5
```

```{seealso}
API: <https://mooncakes.io/docs/moonbitlang/core/string>

[Overloaded Literals](#overloaded-literals)
```

### Char

`Char` represents a Unicode code point.

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:dedent:
:start-after: start char 1
:end-before: end char 1
```

Char literals can be overloaded to type `Int` when the expected type is `Int`:

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:start-after: start char 2
:end-before: end char 2
```

```{seealso}
API: <https://mooncakes.io/docs/moonbitlang/core/char>

[Overloaded Literals](#overloaded-literals)

```

### Byte(s)

A byte literal in MoonBit is either a single ASCII character or a single escape, have the form of `b'...'`. Byte literals are of type `Byte`. For example:

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:start-after: start byte 1
:end-before: end byte 1
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/builtin/__snapshot__/byte_1
:caption: Output
```

A `Bytes` is an immutable sequence of bytes. Similar to byte, bytes literals have the form of `b"..."`. For example:

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:start-after: start byte 2
:end-before: end byte 2
```

The byte literal and bytes literal also support escape sequences, but different from those in string literals. The following table lists the supported escape sequences for byte and bytes literals:

| escape sequences     | description                                          |
| -------------------- | ---------------------------------------------------- |
| `\n`, `\r`, `\t`, `\b` | New line, Carriage return, Horizontal tab, Backspace |
| `\\` | Backslash                                            |
| `\x41` | Hexadecimal escape sequence                          |
| `\o102` | Octal escape sequence                                |


``````{note}
You can use `@buffer.T` to construct bytes by writing various types of data. For example:

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:start-after: start buffer 1
:end-before: end buffer 1
```

``````

When the expected type is `Bytes`, the `b` prefix can be omitted. Array literals can also be overloaded to construct a `Bytes` sequence by specifying each byte in the sequence.

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:start-after: start bytes 1
:end-before: end bytes 1
```

```{seealso}
API for `Byte`: <https://mooncakes.io/docs/moonbitlang/core/byte>  
API for `Bytes`: <https://mooncakes.io/docs/moonbitlang/core/bytes>  
API for `@buffer.T`: <https://mooncakes.io/docs/moonbitlang/core/buffer>

[Overloaded Literals](#overloaded-literals)
```

### Tuple

A tuple is a collection of finite values constructed using round brackets `()` with the elements separated by commas `,`. The order of elements matters; for example, `(1,true)` and `(true,1)` have different types. Here's an example:

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:start-after: start tuple 1
:end-before: end tuple 1
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/builtin/__snapshot__/tuple_1
:caption: Output
```

Tuples can be accessed via pattern matching or index:

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:start-after: start tuple 2
:end-before: end tuple 2
```

### Ref

A `Ref[T]` is a mutable reference containing a value `val` of type `T`.

It can be constructed using `{ val : x }`, and can be accessed using `ref.val`. See [struct](#struct) for detailed explanation.

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:start-after: start ref 1
:end-before: end ref 1
```

```{seealso}
API: <https://mooncakes.io/docs/moonbitlang/core/ref>
```

### Option and Result

`Option` and `Result` are the most common types to represent a possible error or failure in MoonBit.

- `Option[T]` represents a possibly missing value of type `T`. It can be abbreviated as `T?`.
- `Result[T, E]` represents either a value of type `T` or an error of type `E`.

See [enum](#enum) for detailed explanation.

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:start-after: start option result 1
:end-before: end option result 1
```

```{seealso}
API for `Option`: <https://mooncakes.io/docs/moonbitlang/core/option>  
API for `Result`: <https://mooncakes.io/docs/moonbitlang/core/result>
```

### Array

An array is a finite sequence of values constructed using square brackets `[]`, with elements separated by commas `,`. For example:

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:dedent:
:start-after: start array 1
:end-before: end array 1
```

You can use `numbers[x]` to refer to the xth element. The index starts from zero.

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:dedent:
:start-after: start array 2
:end-before: end array 2
```

There are `Array[T]` and `FixedArray[T]`:

`Array[T]` can grow in size, while `FixedArray[T]` has a fixed size, thus it needs to be created with initial value.

``````{warning}
A common pitfall is creating `FixedArray` with the same initial value:

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:dedent:
:start-after: start array pitfall
:end-before: end array pitfall
```

This is because all the cells reference to the same object (the `FixedArray[Int]` in this case). One should use `FixedArray::makei()` instead which creates an object for each index.

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:dedent:
:start-after: start array pitfall solution
:end-before: end array pitfall solution
```
``````

When the expected type is known, MoonBit can automatically overload array, otherwise
`Array[T]` is created:

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:start-after: start array 3
:end-before: end array 3

```

```{seealso}
API: <https://mooncakes.io/docs/moonbitlang/core/array>

[Overloaded Literals](#overloaded-literals)
```

#### ArrayView

Analogous to `slice` in other languages, the view is a reference to a
specific segment of collections. You can use `data[start:end]` to create a
view of array `data`, referencing elements from `start` to `end` (exclusive).
Both `start` and `end` indices can be omitted.

```{literalinclude} /sources/language/src/operator/top.mbt
:language: moonbit
:start-after: start view 1
:end-before: end view 1
```

```{seealso}
API: <https://mooncakes.io/docs/moonbitlang/core/array>
```

### Map

MoonBit provides a hash map data structure that preserves insertion order called `Map` in its standard library.
`Map`s can be created via a convenient literal syntax:

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:start-after: start map 1
:end-before: end map 1
```

Currently keys in map literal syntax must be constant. `Map`s can also be destructed elegantly with pattern matching, see [Map Pattern](#map-pattern).

```{seealso}
API: <https://mooncakes.io/docs/moonbitlang/core/builtin#Map>

[Overloaded Literals](#overloaded-literals)
```

### Json 

MoonBit supports convenient json handling by overloading literals.
When the expected type of an expression is `Json`, number, string, array and map literals can be directly used to create json data:

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:start-after: start json 1
:end-before: end json 1
```

Json values can be pattern matched too, see [Json Pattern](#json-pattern).

```{seealso}
API: <https://mooncakes.io/docs/moonbitlang/core/json>

[Overloaded Literals](#overloaded-literals)
```

## Overloaded Literals

Overloaded literals allow you to use the same syntax to represent different types of values. 
For example, you can use `1` to represent `UInt` or `Double` depending on the expected type. If the expected type is not known, the literal will be interpreted as `Int` by default.

```{literalinclude} /sources/language/src/builtin/top.mbt
:language: moonbit
:start-after: start overloaded literal 1
:end-before: end overloaded literal 1
```

The overloaded literals can be composed. If array literal can be overloaded to `Bytes` , and number literal can be overloaded to `Byte` , then you can overload `[1,2,3]` to `Bytes` as well. Here is a table of overloaded literals in MoonBit:

| Overloaded literal             | Default type | Can be overloaded to                                                                      | 
| ------------------------------ | ------------ | ----------------------------------------------------------------------------------------- |
| `10`, `0xFF`, `0o377`, `10_000` | `Int` | `UInt`, `Int64`, `UInt64`, `Int16`, `UInt16`, `Byte`, `Double`, `Float`, `BigInt` |
| `"str"` | `String` | `Bytes` |
| `'c'` | `Char` | `Int` , `Byte` |
| `3.14` | `Double` | `Float` |
| `[a, b, c]` (where the types of literals a, b, and c are E) | `Array[E]` | `FixedArray[E]`, `String`  (if E is of type Char), `Bytes` (if E is of type Byte) |

There are also some similar overloading rules in pattern. For more details, see [Pattern Matching](#pattern-matching).

```{note}
Literal overloading is not the same as value conversion. To convert a variable to a different type, you can use methods prefixed with `to_`, such as `to_int()`, `to_double()`, etc.

```

### Escape Sequences in Overloaded Literals

Escape sequences can be used in overloaded `"..."` literals and `'...'` literals. The interpretation of escape sequences depends on the types they are overloaded to:

- Simple escape sequences

  Including `\n`, `\r`, `\t`, `\\`, and `\b`. These escape sequences are supported in any `"..."` or `'...'` literals. They are interpreted as their respective `Char` or `Byte` in `String` or `Bytes`.

- Byte escape sequences 

  The `\x41` and `\o102` escape sequences represent a Byte. These are supported in literals overloaded to `Bytes` and `Byte`. 

- Unicode escape sequences

  The `\u5154` and `\u{1F600}` escape sequences represent a `Char`. These are supported in literals of type `String` and `Char`.

## Functions

Functions take arguments and produce a result. In MoonBit, functions are first-class, which means that functions can be arguments or return values of other functions. MoonBit's naming convention requires that function names should not begin with uppercase letters (A-Z). Compare for constructors in the `enum` section below.

### Top-Level Functions

Functions can be defined as top-level or local. We can use the `fn` keyword to define a top-level function that sums three integers and returns the result, as follows:

```{literalinclude} /sources/language/src/functions/top.mbt
:language: moonbit
:start-after: start top-level functions
:end-before: end top-level functions
```

Note that the arguments and return value of top-level functions require **explicit** type annotations.

### Local Functions

Local functions can be named or anonymous. Type annotations can be omitted for local function definitions: they can be automatically inferred in most cases. For example:

```{literalinclude} /sources/language/src/functions/top.mbt
:language: moonbit
:start-after: start local functions 1
:end-before: end local functions 1
```

There's also a form called **matrix function** that make use of [pattern matching](#pattern-matching):

```{literalinclude} /sources/language/src/functions/top.mbt
:language: moonbit
:start-after: start local functions 3
:end-before: end local functions 3
```

Functions, whether named or anonymous, are _lexical closures_: any identifiers without a local binding must refer to bindings from a surrounding lexical scope. For example:

```{literalinclude} /sources/language/src/functions/top.mbt
:language: moonbit
:start-after: start local functions 2
:end-before: end local functions 2
```

### Function Applications

A function can be applied to a list of arguments in parentheses:

```moonbit
add3(1, 2, 7)
```

This works whether `add3` is a function defined with a name (as in the previous example), or a variable bound to a function value, as shown below:

```{literalinclude} /sources/language/src/functions/top.mbt
:language: moonbit
:start-after: start function application 1
:end-before: end function application 1
```

The expression `add3(1, 2, 7)` returns `10`. Any expression that evaluates to a function value is applicable:

```{literalinclude} /sources/language/src/functions/top.mbt
:language: moonbit
:dedent:
:start-after: start function application 2
:end-before: end function application 2
```

### Partial Applications

Partial application is a technique of applying a function to some of its arguments, resulting in a new function that takes the remaining arguments. In MoonBit, partial application is achieved by using the `_` operator in function application:

```{literalinclude} /sources/language/src/functions/top.mbt
:language: moonbit
:dedent:
:start-after: start partial application 1
:end-before: end partial application 1
```

The `_` operator represents the missing argument in parentheses. The partial application allows multiple `_` in the same parentheses.
For example, `Array::fold(_, _, init=5)` is equivalent to `fn(x, y) { Array::fold(x, y, init=5) }`.

The `_` operator can also be used in enum creation, dot style function calls and in the pipelines.

### Labelled arguments

**Top-level** functions can declare labelled argument with the syntax `label~ : Type`. `label` will also serve as parameter name inside function body:

```{literalinclude} /sources/language/src/functions/top.mbt
:language: moonbit
:start-after: start labelled arguments 1
:end-before: end labelled arguments 1
```

Labelled arguments can be supplied via the syntax `label=arg`. `label=label` can be abbreviated as `label~`:

```{literalinclude} /sources/language/src/functions/top.mbt
:language: moonbit
:start-after: start labelled arguments 2
:end-before: end labelled arguments 2
```

Labelled function can be supplied in any order. The evaluation order of arguments is the same as the order of parameters in function declaration.

### Optional arguments

A labelled argument can be made optional by supplying a default expression with the syntax `label~ : Type = default_expr`. If this argument is not supplied at call site, the default expression will be used:

```{literalinclude} /sources/language/src/functions/top.mbt
:language: moonbit
:start-after: start optional arguments 1
:end-before: end optional arguments 1
```

The default expression will be evaluated every time it is used. And the side effect in the default expression, if any, will also be triggered. For example:

```{literalinclude} /sources/language/src/functions/top.mbt
:language: moonbit
:start-after: start optional arguments 2
:end-before: end optional arguments 2
```

If you want to share the result of default expression between different function calls, you can lift the default expression to a toplevel `let` declaration:

```{literalinclude} /sources/language/src/functions/top.mbt
:language: moonbit
:start-after: start optional arguments 3
:end-before: end optional arguments 3
```

Default expression can depend on the value of previous arguments. For example:

```{literalinclude} /sources/language/src/functions/top.mbt
:language: moonbit
:start-after: start optional arguments 4
:end-before: end optional arguments 4
:emphasize-lines: 4
```

#### Automatically insert `Some` when supplying optional arguments

It is quite often optional arguments have type `T?` with `None` as default value.
In this case, passing the argument explicitly requires wrapping a `Some`,
which is ugly:

```{literalinclude} /sources/language/src/functions/top.mbt
:language: moonbit
:start-after: start optional arguments 5
:end-before: end optional arguments 5
```

Fortunately, MoonBit provides a special kind of optional arguments to solve this problem.
Optional arguments declared with `label? : T` has type `T?` and `None` as default value.
When supplying this kind of optional argument directly, MoonBit will automatically insert a `Some`:

```{literalinclude} /sources/language/src/functions/top.mbt
:language: moonbit
:start-after: start optional arguments 6
:end-before: end optional arguments 6
```

Sometimes, it is also useful to pass a value of type `T?` directly,
for example when forwarding optional argument.
MoonBit provides a syntax `label?=value` for this, with `label?` being an abbreviation of `label?=label`:

```{literalinclude} /sources/language/src/functions/top.mbt
:language: moonbit
:start-after: start optional arguments 7
:end-before: end optional arguments 7
```

### Autofill arguments

MoonBit supports filling specific types of arguments automatically at different call site, such as the source location of a function call.
To declare an autofill argument, simply declare an optional argument with `_` as default value.
Now if the argument is not explicitly supplied, MoonBit will automatically fill it at the call site.

Currently MoonBit supports two types of autofill arguments, `SourceLoc`, which is the source location of the whole function call,
and `ArgsLoc`, which is a array containing the source location of each argument, if any:

```{literalinclude} /sources/language/src/functions/top.mbt
:language: moonbit
:start-after: start autofill arguments
:end-before: end autofill arguments
```

Autofill arguments are very useful for writing debugging and testing utilities.

### Function alias
MoonBit allows calling functions with alternative names via function alias. Function alias can be declared as follows:

```{literalinclude} /sources/language/src/functions/top.mbt
:language: moonbit
:start-after: start function alias
:end-before: end function alias
```

Function alias can be used to import functions from other [packages](/language/packages.md).

You can also create public function alias with the syntax `pub fnalias`,
which is useful for re-exporting functions from another package.

## Control Structures

### Conditional Expressions

A conditional expression consists of a condition, a consequent, and an optional `else` clause or `else if` clause.

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:dedent:
:start-after: start conditional expressions 1
:end-before: end conditional expressions 1
```

The curly brackets around the consequent are required.

Note that a conditional expression always returns a value in MoonBit, and the return values of the consequent and the else clause must be of the same type. Here is an example:

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:dedent:
:start-after: start conditional expressions 3
:end-before: end conditional expressions 3
```

The `else` clause can only be omitted if the return value has type `Unit`.

### Match Expression

The `match` expression is similar to conditional expression, but it uses [pattern matching](#pattern-matching) to decide which consequent to evaluate and extracting variables at the same time.

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:dedent:
:start-after: start match 1
:end-before: end match 1
```

If a possible condition is omitted, the compiler will issue a warning, and the program will terminate if that case were reached.

### Guard Statement

The `guard` statement is used to check a specified invariant.
If the condition of the invariant is satisfied, the program continues executing
the subsequent statements and returns. If the condition is not satisfied (i.e., false),
the code in the `else` block is executed and its evaluation result is returned (the subsequent statements are skipped).

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:dedent:
:start-after: start guard 1
:end-before: end guard 1
```

#### Guard statement and is expression

The `let` statement can be used with [pattern matching](#pattern-matching). However, `let` statement can only handle one case. And using [is expression](#is-expression) with `guard` statement can solve this issue.

In the following example, `getProcessedText` assumes that the input `path` points to resources that are all plain text,
and it uses the `guard` statement to ensure this invariant while extracting the plain text resource.
Compared to using a `match` statement, the subsequent processing of `text` can have one less level of indentation.

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:start-after: start guard 2
:end-before: end guard 2
```

When the `else` part is omitted, the program terminates if the condition specified
in the `guard` statement is not true or cannot be matched.

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:dedent:
:start-after: start guard 3
:end-before: end guard 3
```

### While loop

In MoonBit, `while` loop can be used to execute a block of code repeatedly as long as a condition is true. The condition is evaluated before executing the block of code. The `while` loop is defined using the `while` keyword, followed by a condition and the loop body. The loop body is a sequence of statements. The loop body is executed as long as the condition is true.

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:start-after: start while loop 1
:end-before: end while loop 1
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/controls/__snapshot__/while_loop_1
:caption: Output
```

The loop body supports `break` and `continue`. Using `break` allows you to exit the current loop, while using `continue` skips the remaining part of the current iteration and proceeds to the next iteration.

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:start-after: start while loop 2
:end-before: end while loop 2
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/controls/__snapshot__/while_loop_2
:caption: Output
```

The `while` loop also supports an optional `else` clause. When the loop condition becomes false, the `else` clause will be executed, and then the loop will end.

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:start-after: start while loop 3
:end-before: end while loop 3
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/controls/__snapshot__/while_loop_3
:caption: Output
```

When there is an `else` clause, the `while` loop can also return a value. The return value is the evaluation result of the `else` clause. In this case, if you use `break` to exit the loop, you need to provide a return value after `break`, which should be of the same type as the return value of the `else` clause.

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:start-after: start while loop 4
:end-before: end while loop 4
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/controls/__snapshot__/while_loop_4
:caption: Output
```

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:start-after: start while loop 5
:end-before: end while loop 5
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/controls/__snapshot__/while_loop_5
:caption: Output
```

### For Loop

MoonBit also supports C-style For loops. The keyword `for` is followed by variable initialization clauses, loop conditions, and update clauses separated by semicolons. They do not need to be enclosed in parentheses.
For example, the code below creates a new variable binding `i`, which has a scope throughout the entire loop and is immutable. This makes it easier to write clear code and reason about it:

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:start-after: start for loop 1
:end-before: end for loop 1
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/controls/__snapshot__/for_loop_1
:caption: Output
```

The variable initialization clause can create multiple bindings:

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:dedent:
:start-after: start for loop 2
:end-before: end for loop 2
```

It should be noted that in the update clause, when there are multiple binding variables, the semantics are to update them simultaneously. In other words, in the example above, the update clause does not execute `i = i + 1`, `j = j + 1` sequentially, but rather increments `i` and `j` at the same time. Therefore, when reading the values of the binding variables in the update clause, you will always get the values updated in the previous iteration.

Variable initialization clauses, loop conditions, and update clauses are all optional. For example, the following two are infinite loops:

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:dedent:
:start-after: start for loop 3
:end-before: end for loop 3
```

The `for` loop also supports `continue`, `break`, and `else` clauses. Like the `while` loop, the `for` loop can also return a value using the `break` and `else` clauses.

The `continue` statement skips the remaining part of the current iteration of the `for` loop (including the update clause) and proceeds to the next iteration. The `continue` statement can also update the binding variables of the `for` loop, as long as it is followed by expressions that match the number of binding variables, separated by commas.

For example, the following program calculates the sum of even numbers from 1 to 6:

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:start-after: start for loop 4
:end-before: end for loop 4
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/controls/__snapshot__/for_loop_4
:caption: Output
```

### `for .. in` loop

MoonBit supports traversing elements of different data structures and sequences via the `for .. in` loop syntax:

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:dedent:
:start-after: start for loop 5
:end-before: end for loop 5
```

`for .. in` loop is translated to the use of `Iter` in MoonBit's standard library. Any type with a method `.iter() : Iter[T]` can be traversed using `for .. in`.
For more information of the `Iter` type, see [Iterator](#iterator) below.

`for .. in` loop also supports iterating through a sequence of integers, such as:

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:dedent:
:start-after: start for loop 10
:end-before: end for loop 10
```

In addition to sequences of a single value, MoonBit also supports traversing sequences of two values, such as `Map`, via the `Iter2` type in MoonBit's standard library.
Any type with method `.iter2() : Iter2[A, B]` can be traversed using `for .. in` with two loop variables:

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:dedent:
:start-after: start for loop 6
:end-before: end for loop 6
```

Another example of `for .. in` with two loop variables is traversing an array while keeping track of array index:

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:start-after: start for loop 7
:end-before: end for loop 7
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/controls/__snapshot__/for_loop_7
:caption: Output
```

Control flow operations such as `return`, `break` and error handling are supported in the body of `for .. in` loop:

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:start-after: start for loop 8
:end-before: end for loop 8
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/controls/__snapshot__/for_loop_8
:caption: Output
```

If a loop variable is unused, it can be ignored with `_`.

### Functional loop

Functional loop is a powerful feature in MoonBit that enables you to write loops in a functional style.

A functional loop consumes arguments and returns a value. It is defined using the `loop` keyword, followed by its arguments and the loop body. The loop body is a sequence of clauses, each of which consists of a pattern and an expression. The clause whose pattern matches the input will be executed, and the loop will return the value of the expression. If no pattern matches, the loop will panic. Use the `continue` keyword with arguments to start the next iteration of the loop. Use the `break` keyword with arguments to return a value from the loop. The `break` keyword can be omitted if the value is the last expression in the loop body.

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:start-after: start for loop 9
:end-before: end for loop 9
```

```{warning}
Currently in `loop exprs { ... }`, `exprs` is nonempty list, while `for { ... }` is accepted for infinite loop.
```

### Labelled Continue/Break

When a loop is labelled, it can be referenced from a `break` or `continue` from
within a nested loop. For example:

```{literalinclude} /sources/language/src/controls/top.mbt
:language: moonbit
:start-after: start loop label
:end-before: end loop label
```

## Iterator

An iterator is an object that traverse through a sequence while providing access
to its elements. Traditional OO languages like Java's `Iterator<T>` use `next()`
`hasNext()` to step through the iteration process, whereas functional languages
(JavaScript's `forEach`, Lisp's `mapcar`) provides a high-order function which
takes an operation and a sequence then consumes the sequence with that operation
being applied to the sequence. The former is called _external iterator_ (visible
to user) and the latter is called _internal iterator_ (invisible to user).

The built-in type `Iter[T]` is MoonBit's internal iterator implementation.
Almost all built-in sequential data structures have implemented `Iter`:

```{literalinclude} /sources/language/src/iter/top.mbt
:language: moonbit
:start-after: start iter 1
:end-before: end iter 1
```

Commonly used methods include:

- `each`: Iterates over each element in the iterator, applying some function to each element.
- `fold`: Folds the elements of the iterator using the given function, starting with the given initial value.
- `collect`: Collects the elements of the iterator into an array.

- `filter`: _lazy_ Filters the elements of the iterator based on a predicate function.
- `map`: _lazy_ Transforms the elements of the iterator using a mapping function.
- `concat`: _lazy_ Combines two iterators into one by appending the elements of the second iterator to the first.

Methods like `filter` `map` are very common on a sequence object e.g. Array.
But what makes `Iter` special is that any method that constructs a new `Iter` is
_lazy_ (i.e. iteration doesn't start on call because it's wrapped inside a
function), as a result of no allocation for intermediate value. That's what
makes `Iter` superior for traversing through sequence: no extra cost. MoonBit
encourages user to pass an `Iter` across functions instead of the sequence
object itself.

Pre-defined sequence structures like `Array` and its iterators should be
enough to use. But to take advantages of these methods when used with a custom
sequence with elements of type `S`, we will need to implement `Iter`, namely, a function that returns
an `Iter[S]`. Take `Bytes` as an example:

```{literalinclude} /sources/language/src/iter/top.mbt
:language: moonbit
:start-after: start iter 2
:end-before: end iter 2
```

Almost all `Iter` implementations are identical to that of `Bytes`, the only
main difference being the code block that actually does the iteration.

### Implementation details

The type `Iter[T]` is basically a type alias for `((T) -> IterResult) -> IterResult`,
a higher-order function that takes an operation and `IterResult` is an enum
object that tracks the state of current iteration which consists any of the 2
states:

- `IterEnd`: marking the end of an iteration
- `IterContinue`: marking the end of an iteration is yet to be reached, implying the iteration will still continue at this state.

To put it simply, `Iter[T]` takes a function `(T) -> IterResult` and use it to
transform `Iter[T]` itself to a new state of type `IterResult`. Whether that
state being `IterEnd` `IterContinue` depends on the function.

Iterator provides a unified way to iterate through data structures, and they
can be constructed at basically no cost: as long as `fn(yield)` doesn't
execute, the iteration process doesn't start.

Internally a `Iter::run()` is used to trigger the iteration. Chaining all sorts
of `Iter` methods might be visually pleasing, but do notice the heavy work
underneath the abstraction.

Thus, unlike an external iterator, once the iteration starts
there's no way to stop unless the end is reached. Methods such as `count()`
which counts the number of elements in a iterator looks like an `O(1)` operation
but actually has linear time complexity. Carefully use iterators or
performance issue might occur.

## Custom Data Types

There are two ways to create new data types: `struct` and `enum`.

### Struct

In MoonBit, structs are similar to tuples, but their fields are indexed by field names. A struct can be constructed using a struct literal, which is composed of a set of labeled values and delimited with curly brackets. The type of a struct literal can be automatically inferred if its fields exactly match the type definition. A field can be accessed using the dot syntax `s.f`. If a field is marked as mutable using the keyword `mut`, it can be assigned a new value.

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:start-after: start struct 1
:end-before: end struct 1
```

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:start-after: start struct 2
:end-before: end struct 2
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/data/__snapshot__/struct_1
:caption: Output
```

#### Constructing Struct with Shorthand

If you already have some variable like `name` and `email`, it's redundant to repeat those names when constructing a struct. You can use shorthand instead, it behaves exactly the same:

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:dedent:
:start-after: start struct 3
:end-before: end struct 3
```

If there's no other struct that has the same fields, it's redundant to add the struct's name when constructing it:

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:dedent:
:start-after: start struct 5
:end-before: end struct 5
```

#### Struct Update Syntax

It's useful to create a new struct based on an existing one, but with some fields updated.

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:start-after: start struct 4
:end-before: end struct 4
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/data/__snapshot__/struct_4
:caption: Output
```

### Enum

Enum types are similar to algebraic data types in functional languages. Users familiar with C/C++ may prefer calling it tagged union.

An enum can have a set of cases (constructors). Constructor names must start with capitalized letter. You can use these names to construct corresponding cases of an enum, or checking which branch an enum value belongs to in pattern matching:

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:start-after: start enum 1
:end-before: end enum 1
```

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:dedent:
:start-after: start enum 2
:end-before: end enum 2
```

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:start-after: start enum 3
:end-before: end enum 3
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/data/__snapshot__/enum_3
:caption: Output
```

Enum cases can also carry payload data. Here's an example of defining an integer list type using enum:

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:start-after: start enum 4
:end-before: end enum 4
```

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:dedent:
:start-after: start enum 5
:end-before: end enum 5
```

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:start-after: start enum 6
:end-before: end enum 6
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/data/__snapshot__/enum_6
:caption: Output
```

#### Constructor with labelled arguments

Enum constructors can have labelled argument:

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:start-after: start enum 7
:end-before: end enum 7
```

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:dedent:
:start-after: start enum 8
:end-before: end enum 8
```

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:start-after: start enum 9
:end-before: end enum 9
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/data/__snapshot__/enum_9
:caption: Output
```

It is also possible to access labelled arguments of constructors like accessing struct fields in pattern matching:

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:start-after: start enum 10
:end-before: end enum 10
```

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:start-after: start enum 11
:end-before: end enum 11
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/data/__snapshot__/enum_11
:caption: Output
```

#### Constructor with mutable fields

It is also possible to define mutable fields for constructor. This is especially useful for defining imperative data structures:

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:start-after: start enum 12
:end-before: end enum 12
```

### Newtype

MoonBit supports a special kind of enum called newtype:

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:start-after: start newtype 1
:end-before: end newtype 1
```

Newtypes are similar to enums with only one constructor (with the same name as the newtype itself). So, you can use the constructor to create values of newtype, or use pattern matching to extract the underlying representation of a newtype:

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:start-after: start newtype 2
:end-before: end newtype 2
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/data/__snapshot__/newtype_2
:caption: Output
```

Besides pattern matching, you can also use `._` to extract the internal representation of newtypes:

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:start-after: start newtype 3
:end-before: end newtype 3
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/data/__snapshot__/newtype_3
:caption: Output
```

### Type alias
MoonBit supports type alias via the syntax `typealias Name = TargetType`:

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:start-after: start typealias 1
:end-before: end typealias 1
```

Unlike all other kinds of type declaration above, type alias does not define a new type,
it is merely a type macro that behaves exactly the same as its definition.
So for example one cannot define new methods or implement traits for a type alias.

```{tip}
Type alias can be used to perform incremental code refactor.

For example, if you want to move a type `T` from `@pkgA` to `@pkgB`,
you can leave a type alias `typealias T = @pkgB.T` in `@pkgA`, and **incrementally** port uses of `@pkgA.T` to `@pkgB.T`.
The type alias can be removed after all uses of `@pkgA.T` is migrated to `@pkgB.T`.
```

### Local types

Moonbit supports declaring structs/enums/newtypes at the top of a toplevel
function, which are only visible within the current toplevel function. These
local types can use the generic parameters of the toplevel function but cannot
introduce additional generic parameters themselves. Local types can derive
methods using derive, but no additional methods can be defined manually. For 
example:

```{literalinclude} /sources/language/src/data/top.mbt
:language: moonbit
:start-after: start local-type 1
:end-before: end local-type 1
```

Currently, local types do not support being declared as error types. 

## Pattern Matching

Pattern matching allows us to match on specific pattern and bind data from data structures.

### Simple Patterns

We can pattern match expressions against

- literals, such as boolean values, numbers, chars, strings, etc
- constants
- structs
- enums
- arrays
- maps
- JSONs

and so on. We can define identifiers to bind the matched values so that they can be used later.

```{literalinclude} /sources/language/src/pattern/top.mbt
:language: moonbit
:dedent:
:start-after: start simple pattern 1
:end-before: end simple pattern 1
```

We can use `_` as wildcards for the values we don't care about, and use `..` to ignore remaining fields of struct or enum, or array (see [array pattern](#array-pattern)).

```{literalinclude} /sources/language/src/pattern/top.mbt
:language: moonbit
:dedent:
:start-after: start simple pattern 2
:end-before: end simple pattern 2
```

We can use `as` to give a name to some pattern, and we can use `|` to match several cases at once. A variable name can only be bound once in a single pattern, and the same set of variables should be bound on both sides of `|` patterns.

```{literalinclude} /sources/language/src/pattern/top.mbt
:language: moonbit
:dedent:
:start-after: start pattern 3
:end-before: end pattern 3
```

### Array Pattern

Array patterns can be used to match on the following types to obtain their
corresponding elements or views:

| Type                     | Element | View           |
|--------------------------|---------|----------------|
| Array[T], @array.View[T] | T       | @array.View[T] |
| Bytes, @bytes.View       | Byte    | @bytes.View    |
| String, @string.View     | Char    | @string.View   |
| FixedArray[T]            | T       | N/A            |

Array patterns have the following forms:

- `[]` : matching for empty array
- `[pa, pb, pc]` : matching for array of length three, and bind `pa`, `pb`, `pc`
  to the three elements
- `[pa, ..rest, pb]` : matching for array with at least two elements, and bind
  `pa` to the first element, `pb` to the last element, and `rest` to the
  remaining elements. the binder `rest` can be omitted if the rest of the
  elements are not needed. Arbitrary number of elements are allowed preceding
  and following the `..` part. Because `..` can match uncertain number of
  elements, it can appear at most once in an array pattern.

```{literalinclude} /sources/language/src/pattern/top.mbt
:language: moonbit
:start-after: start pattern 2
:end-before: end pattern 2
```

Array patterns provide a unicode-safe way to manipulate strings, meaning that it
respects the code unit boundaries. For example, we can check if a string is a
 palindrome:

```{literalinclude} /sources/language/src/pattern/top.mbt
:language: moonbit
:start-after: start array pattern 1
:end-before: end array pattern 1
```

When there are consecutive char or byte constants in an array pattern, the
pattern spread `..` operator can be used to combine them to make the code look
cleaner. Note that in this case the `..` followed by string or bytes constant
matches exact number of elements so its usage is not limited to once.

```{literalinclude} /sources/language/src/pattern/top.mbt
:language: moonbit
:start-after: start array pattern 2
:end-before: end array pattern 2
```

### Range Pattern
For builtin integer types and `Char`, MoonBit allows matching whether the value falls in a specific range.

Range patterns have the form `a..<b` or `a..=b`, where `..<` means the upper bound is exclusive, and `..=` means inclusive upper bound.
`a` and `b` can be one of:

- literal
- named constant declared with `const`
- `_`, meaning the pattern has no restriction on this side

Here are some examples:

```{literalinclude} /sources/language/src/pattern/top.mbt
:language: moonbit
:dedent:
:start-after: start pattern 4
:end-before: end pattern 4
```

### Map Pattern

MoonBit allows convenient matching on map-like data structures.
Inside a map pattern, the `key : value` syntax will match if `key` exists in the map, and match the value of `key` with pattern `value`.
The `key? : value` syntax will match no matter `key` exists or not, and `value` will be matched against `map[key]` (an optional).

```{literalinclude} /sources/language/src/pattern/top.mbt
:language: moonbit
:dedent:
:start-after: start pattern 5
:end-before: end pattern 5
```

- To match a data type `T` using map pattern, `T` must have a method `op_get(Self, K) -> Option[V]` for some type `K` and `V` (see [method and trait](./methods.md)).
- Currently, the key part of map pattern must be a literal or constant
- Map patterns are always open: the unmatched keys are silently ignored, and `..` needs to be added to identify this nature
- Map pattern will be compiled to efficient code: every key will be fetched at most once

### Json Pattern

When the matched value has type `Json`, literal patterns can be used directly, together with constructors:

```{literalinclude} /sources/language/src/pattern/top.mbt
:language: moonbit
:dedent:
:start-after: start pattern 6
:end-before: end pattern 6
```

### Guard condition

Each case in a pattern matching expression can have a guard condition. A guard
condition is a boolean expression that must be true for the case to be matched.
If the guard condition is false, the case is skipped and the next case is tried.
For example:
```{literalinclude} /sources/language/src/pattern/top.mbt
:language: moonbit
:dedent:
:start-after: start guard condition 1
:end-before: end guard condition 1
```

Note that the guard conditions will not be considered when checking if all
patterns are covered by the match expression. So you will see a warning of
partial match for the following case:

```{literalinclude} /sources/language/src/pattern/top.mbt
:language: moonbit
:dedent:
:start-after: start guard condition 2
:end-before: end guard condition 2
```

``````{warning}
It is not encouraged to call a function that mutates a part of the value being
matched inside a guard condition. When such case happens, the part being mutated
will not be re-evaluated in the subsequent patterns. Use it with caution.
``````

## Generics

Generics are supported in top-level function and data type definitions. Type parameters can be introduced within square brackets. We can rewrite the aforementioned data type `List` to add a type parameter `T` to obtain a generic version of lists. We can then define generic functions over lists like `map` and `reduce`.

```{literalinclude} /sources/language/src/generics/top.mbt
:language: moonbit
```

## Special Syntax

### Pipelines

MoonBit provides a convenient pipe syntax `x |> f(y)`, which can be used to chain regular function calls:

```{literalinclude} /sources/language/src/operator/top.mbt
:language: moonbit
:dedent:
:start-after: start operator 4
:end-before: end operator 4
```

The MoonBit code follows the *data-first* style, meaning the function places its "subject" as the first argument. 
Thus, the pipe operator inserts the left-hand side value into the first argument of the right-hand side function call by default. 
For example, `x |> f(y)` is equivalent to `f(x, y)`.

You can use the `_` operator to insert `x` into any argument of the function `f`, such as `x |> f(y, _)`, which is equivalent to `f(y, x)`. Labeled arguments are also supported.


### Cascade Operator

The cascade operator `..` is used to perform a series of mutable operations on
the same value consecutively. The syntax is as follows:

```{literalinclude} /sources/language/src/operator/top.mbt
:language: moonbit
:dedent:
:start-after: start operator 5
:end-before: end operator 5
```

- `x..f()..g()` is equivalent to `{ x.f(); x.g(); }`.
- `x..f().g()` is equivalent to `{ x.f(); x.g(); }`.


Consider the following scenario: for a `StringBuilder` type that has methods
like `write_string`, `write_char`, `write_object`, etc., we often need to perform
a series of operations on the same `StringBuilder` value:

```{literalinclude} /sources/language/src/operator/top.mbt
:language: moonbit
:dedent:
:start-after: start operator 6
:end-before: end operator 6
```

To avoid repetitive typing of `builder`, its methods are often designed to
return `self` itself, allowing operations to be chained using the `.` operator.
To distinguish between immutable and mutable operations, in MoonBit,
for all methods that return `Unit`, cascade operator can be used for
consecutive operations without the need to modify the return type of the methods.

```{literalinclude} /sources/language/src/operator/top.mbt
:language: moonbit
:dedent:
:start-after: start operator 7
:end-before: end operator 7
```

### is Expression

The `is` expression tests whether a value conforms to a specific pattern. It
returns a `Bool` value and can be used anywhere a boolean value is expected,
for example:

```{literalinclude} /sources/language/src/is/top.mbt
:language: moonbit
:dedent:
:start-after: start is 1
:end-before: end is 1
```

Pattern binders introduced by `is` expressions can be used in the following
contexts:

1. In boolean AND expressions (`&&`):
   binders introduced in the left-hand expression can be used in the right-hand
   expression

   ```{literalinclude} /sources/language/src/is/top.mbt
   :language: moonbit
   :dedent:
   :start-after: start is 2
   :end-before: end is 2
   ```

2. In the first branch of `if` expression: if the condition is a sequence of
   boolean expressions `e1 && e2 && ...`, the binders introduced by the `is`
   expression can be used in the branch where the condition evaluates to `true`.

   ```{literalinclude} /sources/language/src/is/top.mbt
   :language: moonbit
   :dedent:
   :start-after: start is 3
   :end-before: end is 3
   ```

3. In the following statements of a `guard` condition:

   ```{literalinclude} /sources/language/src/is/top.mbt
   :language: moonbit
   :dedent:
   :start-after: start is 4
   :end-before: end is 4
   ```

4. In the body of a `while` loop:

   ```{literalinclude} /sources/language/src/is/top.mbt
   :language: moonbit
   :dedent:
   :start-after: start is 5
   :end-before: end is 5
   ```

Note that `is` expression can only take a simple pattern. If you need to use
`as` to bind the pattern to a variable, you have to add parentheses. For
example:
```{literalinclude} /sources/language/src/is/top.mbt
:language: moonbit
:dedent:
:start-after: start is 6
:end-before: end is 6
```

### Spread Operator

MoonBit provides a spread operator to expand a sequence of elements when
constructing `Array`, `String`, and `Bytes` using the array literal syntax. To
expand such a sequence, it needs to be prefixed with `..`, and it must have
`iter()` method that yields the corresponding type of element.

For example, we can use the spread operator to construct an array:

```{literalinclude} /sources/language/src/operator/top.mbt
:language: moonbit
:dedent:
:start-after: start spread 1
:end-before: end spread 1
```

Similarly, we can use the spread operator to construct a string:

```{literalinclude} /sources/language/src/operator/top.mbt
:language: moonbit
:dedent:
:start-after: start spread 2
:end-before: end spread 2
```

The last example shows how the spread operator can be used to construct a bytes
sequence.

```{literalinclude} /sources/language/src/operator/top.mbt
:language: moonbit
:dedent:
:start-after: start spread 3
:end-before: end spread 3
```


### TODO syntax

The `todo` syntax (`...`) is a special construct used to mark sections of code that are not yet implemented or are placeholders for future functionality. For example:

```{literalinclude} /sources/language/src/misc/top.mbt
:language: moonbit
:start-after: start todo 1
:end-before: end todo 1
```


---


## 文档：methods

---

# Method and Trait

## Method system

MoonBit supports methods in a different way from traditional object-oriented languages. A method in MoonBit is just a toplevel function associated with a type constructor.
To define a method, prepend `SelfTypeName::` in front of the function name, such as `fn SelfTypeName::method_name(...)`, and the method belongs to `SelfTypeName`.

``````{warning}
Defining a method using the following syntax will be deprecated, where the name of the first parameter is `self`.

```{code-block} moonbit
:class: top-level
fn method_name(self : SelfType) { ... }
```

You should migrate to the new syntax, and add [method alias](#method-alias) to keep the behavior:

```{code-block} moonbit
:class: top-level
fn method_name(a : SelfType) { ... }
fnalias SelfType::method_name
```
``````

```{literalinclude} /sources/language/src/method2/top.mbt
:language: moonbit
:start-after: start method declaration example
:end-before: end method declaration example
```

To call a method, you can either invoke using qualified syntax `T::method_name(..)`, or using dot syntax where the first argument is the type of `T`:

```{literalinclude} /sources/language/src/method2/top.mbt
:language: moonbit
:dedent:
:start-after: start method call syntax example
:end-before: end method call syntax example
```

When the first parameter of a method is also the type it belongs to, methods can be called using dot syntax `x.method(...)`. MoonBit automatically finds the correct method based on the type of `x`, there is no need to write the type name and even the package name of the method:

```{literalinclude} /sources/language/src/method/top.mbt
:language: moonbit
:start-after: start method 1
:end-before: end method 1
```

```{literalinclude} /sources/language/src/method2/top.mbt
:language: moonbit
:caption: using package with alias list
:dedent:
:start-after: start dot syntax example
:end-before: end dot syntax example
```

Unlike regular functions, methods defined using the `TypeName::method_name` syntax support overloading:
different types can define methods of the same name, because each method lives in a different name space:

```{literalinclude} /sources/language/src/method/top.mbt
:language: moonbit
:dedent:
:start-after: start method overload example
:end-before: end method overload example
```

### Method alias

MoonBit allows calling methods with alternative names via alias.

The method alias will create a function with the corresponding name.

```{literalinclude} /sources/language/src/method/top.mbt
:language: moonbit
:start-after: start method alias
:end-before: end method alias
```

## Operator Overloading

MoonBit supports overloading infix operators of builtin operators via several builtin traits. For example:

```{literalinclude} /sources/language/src/operator/top.mbt
:language: moonbit
:start-after: start operator 1
:end-before: end operator 1
```

Other operators are overloaded via methods, for example `op_get` and `op_set`:

```{literalinclude} /sources/language/src/operator/top.mbt
:language: moonbit
:start-after: start operator 2
:end-before: end operator 2
```

```{literalinclude} /sources/language/src/operator/top.mbt
:language: moonbit
:start-after: start operator 3
:end-before: end operator 3
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/operator/__snapshot__/operator_3
:caption: Output
```

Currently, the following operators can be overloaded:

| Operator Name         | overloading mechanism |
| --------------------- | --------------------- |
| `+`                   | trait `Add`           |
| `-`                   | trait `Sub`           |
| `*`                   | trait `Mul`           |
| `/`                   | trait `Div`           |
| `%`                   | trait `Mod`           |
| `==`                  | trait `Eq`            |
| `<<`                  | trait `Shl`           |
| `>>`                  | trait `Shr`           |
| `-` (unary)           | trait `Neg`           |
| `_[_]` (get item)     | method `op_get`       |
| `_[_] = _` (set item) | method `op_set`       |
| `_[_:_]` (view)       | method `op_as_view`   |
| `&`                   | trait `BitAnd`        |
| `\|`                  | trait `BitOr`         |
| `^`                   | trait `BitXOr`        |

When overloading `op_get`/`op_set`/`op_as_view`, the method must have a correcnt signature:

- `op_get` should have signature `(Self, Index) -> Result`
- `op_set` should have signature `(Self, Index, Value) -> Result`
- `op_as_view` should have signature `(Self, start? : Index, end? : Index) -> Result`

By implementing `op_as_view` method, you can create a view for a user-defined type. Here is an example:

```{literalinclude} /sources/language/src/operator/top.mbt
:language: moonbit
:start-after: start view 2
:end-before: end view 2
```

## Trait system

MoonBit provides a trait system for overloading/ad-hoc polymorphism. Traits declare a list of operations, which must be supplied when a type wants to implement the trait. Traits can be declared as follows:

```{literalinclude} /sources/language/src/trait/top.mbt
:language: moonbit
:start-after: start trait 1
:end-before: end trait 1
```

In the body of a trait definition, a special type `Self` is used to refer to the type that implements the trait.

### Extending traits

A trait can depend on other traits, for example:

```{literalinclude} /sources/language/src/trait/top.mbt
:language: moonbit
:start-after: start super trait 1
:end-before: end super trait 1
```

### Implementing traits

To implement a trait, a type must explicitly provide all the methods required by the trait
using the syntax `impl Trait for Type with method_name(...) { ... }`. For example:

```{literalinclude} /sources/language/src/trait/top.mbt
:language: moonbit
:start-after: start trait 2
:end-before: end trait 2
```

Type annotation can be omitted for trait `impl`: MoonBit will automatically infer the type based on the signature of `Trait::method` and the self type.

The author of the trait can also define **default implementations** for some methods in the trait, for example:

```{literalinclude} /sources/language/src/trait/top.mbt
:language: moonbit
:start-after: start trait 3
:end-before: end trait 3
```

Implementers of trait `J` don't have to provide an implementation for `f_twice`: to implement `J`, only `f` is necessary.
They can always override the default implementation with an explicit `impl J for Type with f_twice`, if desired, though.

```{literalinclude} /sources/language/src/trait/top.mbt
:language: moonbit
:start-after: start trait 4
:end-before: end trait 4
```

To implement the sub trait, one will have to implement the super traits,
and the methods defined in the sub trait. For example:

```{literalinclude} /sources/language/src/trait/top.mbt
:language: moonbit
:start-after: start super trait 2
:end-before: end super trait 2
```

```{warning}
Currently, an empty trait is implemented automatically.
```

### Using traits

When declaring a generic function, the type parameters can be annotated with the traits they should implement, allowing the definition of constrained generic functions. For example:

```{literalinclude} /sources/language/src/trait/top.mbt
:language: moonbit
:start-after: start trait 5
:end-before: end trait 5
```

Without the `Eq` requirement, the expression `x == elem` in `contains` will result in a type error. Now, the function `contains` can be called with any type that implements `Eq`, for example:

```{literalinclude} /sources/language/src/trait/top.mbt
:language: moonbit
:start-after: start trait 6
:end-before: end trait 6
```

#### Invoke trait methods directly

Methods of a trait can be called directly via `Trait::method`. MoonBit will infer the type of `Self` and check if `Self` indeed implements `Trait`, for example:

```{literalinclude} /sources/language/src/trait/top.mbt
:language: moonbit
:start-after: start trait 7
:end-before: end trait 7
```

Trait implementations can also be invoked via dot syntax, with the following restrictions:

1. if a regular method is present, the regular method is always favored when using dot syntax
2. only trait implementations that are located in the package of the self type can be invoked via dot syntax
   - if there are multiple trait methods (from different traits) with the same name available, an ambiguity error is reported
3. if neither of the above two rules apply, trait `impl`s in current package will also be searched for dot syntax.
   This allows extending a foreign type locally.
   - these `impl`s can only be called via dot syntax locally, even if they are public.

The above rules ensures that MoonBit's dot syntax enjoys good property while being flexible.
For example, adding a new dependency never break existing code with dot syntax due to ambiguity.
These rules also make name resolution of MoonBit extremely simple:
the method called via dot syntax must always come from current package or the package of the type!

Here's an example of calling trait `impl` with dot syntax:

```{literalinclude} /sources/language/src/trait/top.mbt
:language: moonbit
:start-after: start trait 8
:end-before: end trait 8
```

### Trait alias

MoonBit allows using traits with alternative names via trait alias.

Trait alias can be declared as follows:

```{literalinclude} /sources/language/src/trait/top.mbt
:language: moonbit
:start-after: start trait alias
:end-before: end trait alias
```

## Trait objects

MoonBit supports runtime polymorphism via trait objects.
If `t` is of type `T`, which implements trait `I`,
one can pack the methods of `T` that implements `I`, together with `t`,
into a runtime object via `t as &I`.
When the expected type of an expression is known to be a trait object type, `as &I` can be omitted.
Trait object erases the concrete type of a value,
so objects created from different concrete types can be put in the same data structure and handled uniformly:

```{literalinclude} /sources/language/src/trait/top.mbt
:language: moonbit
:start-after: start trait object 1
:end-before: end trait object 1
```

Not all traits can be used to create objects.
"object-safe" traits' methods must satisfy the following conditions:

- `Self` must be the first parameter of a method
- There must be only one occurrence of `Self` in the type of the method (i.e. the first parameter)

Users can define new methods for trait objects, just like defining new methods for structs and enums:

```{literalinclude} /sources/language/src/trait/top.mbt
:language: moonbit
:start-after: start trait object 2
:end-before: end trait object 2
```

## Builtin traits

MoonBit provides the following useful builtin traits:

<!-- MANUAL CHECK https://github.com/moonbitlang/core/blob/80cf250d22a5d5eff4a2a1b9a6720026f2fe8e38/builtin/traits.mbt -->

```moonbit
trait Eq {
  op_equal(Self, Self) -> Bool
}

trait Compare : Eq {
  // `0` for equal, `-1` for smaller, `1` for greater
  compare(Self, Self) -> Int
}

trait Hash {
  hash_combine(Self, Hasher) -> Unit // to be implemented
  hash(Self) -> Int // has default implementation
}

trait Show {
  output(Self, Logger) -> Unit // to be implemented
  to_string(Self) -> String // has default implementation
}

trait Default {
  default() -> Self
}
```

### Deriving builtin traits

MoonBit can automatically derive implementations for some builtin traits:

```{literalinclude} /sources/language/src/trait/top.mbt
:language: moonbit
:start-after: start trait 9
:end-before: end trait 9
```

See [Deriving](./derive.md) for more information about deriving traits.


---


## 文档：error-handling

---

# Error handling

Error handling has always been at core of our language design. In the following
we'll be explaining how error handling is done in MoonBit. We assume you have
some prior knowledge of MoonBit, if not, please checkout
[A tour of MoonBit](../tutorial/tour.md).

## Error Types

In MoonBit, all the error values can be represented by the `Error` type, a
generalized error type.

However, an `Error` cannot be constructed directly. A concrete error type must
be defined, in the following forms:

```{literalinclude} /sources/language/src/error/top.mbt
:language: moonbit
:dedent:
:start-after: start error 1
:end-before: end error 1
```

The error types can be promoted to the `Error` type automatically, and pattern
matched back:

```{literalinclude} /sources/language/src/error/top.mbt
:language: moonbit
:start-after: start custom error conversion
:end-before: end custom error conversion
```

Since the type `Error` can include multiple error types, pattern matching on the
`Error` type must use the wildcard `_` to match all error types. For example,

```{literalinclude} /sources/language/src/error/top.mbt
:language: moonbit
:start-after: start error 6
:end-before: end error 6
```

The `Error` is meant to be used where no concrete error type is needed, or a
catch-all for all kinds of sub-errors is needed.

### Failure

A builtin error type is `Failure`.

There's a handly `fail` function, which is merely a constructor with a
pre-defined output template for showing both the error and the source location.
In practice, `fail` is always preferred over `Failure`.

```{code-block} moonbit
:class: top-level
pub fn fail[T](msg : String, loc~ : SourceLoc = _) -> T!Failure {
  raise Failure("FAILED: \{loc} \{msg}")
}
```

## Throwing Errors

The keyword `raise` is used to interrupt the function execution and return an
error.

The return type of a function can include an error type to indicate that the
function might return an error. For example, the following function `div` might
return an error of type `DivError`:

```{literalinclude} /sources/language/src/error/top.mbt
:language: moonbit
:dedent:
:start-after: start error 2
:end-before: end error 2
```

The `Error` can be used when the concrete error type is not important. For
convenience, you can annotate the function name or the return type with the
suffix `!` to indicate that the `Error` type is used. For example, the following
function signatures are equivalent:

```{literalinclude} /sources/language/src/error/top.mbt
:language: moonbit
:dedent:
:start-after: start error 3
:end-before: end error 3
```

For anonymous function and matrix function, you can annotate the keyword `fn`
with the `!` suffix to achieve that. For example,

```{literalinclude} /sources/language/src/error/top.mbt
:language: moonbit
:start-after: start error 4
:end-before: end error 4
```

For functions that are generic in the error type, you can use the `Error` bound
to do that. For example,

```{literalinclude} /sources/language/src/error/top.mbt
:language: moonbit
:start-after: start error 5
:end-before: end error 5
```

## Handling Errors

Applying the function normally will rethrow the error directly in case of an
error. You may append `!` after the function name. For example:

```{literalinclude} /sources/language/src/error/top.mbt
:language: moonbit
:start-after: start error 7
:end-before: end error 7
```

However, you may want to handle the errors.

### Try ... Catch

You can use `try` and `catch` to catch and handle errors, for example:

```{literalinclude} /sources/language/src/error/top.mbt
:language: moonbit
:start-after: start error 9
:end-before: end error 9
:prepend: "fn main {"
:append: "}"
```

```{literalinclude} /sources/language/src/error/__snapshot__/error_9
:caption: Output
```

Here, `try` is used to call a function that might throw an error, and `catch` is
used to match and handle the caught error. If no error is caught, the catch
block will not be executed and the `else` block will be executed instead.

The `else` block can be omitted if no action is needed when no error is caught.
For example:

```{literalinclude} /sources/language/src/error/top.mbt
:language: moonbit
:dedent:
:start-after: start error 10
:end-before: end error 10
```

When the body of `try` is a simple expression, the curly braces can be omitted.
For example:

```{literalinclude} /sources/language/src/error/top.mbt
:language: moonbit
:dedent:
:start-after: start error 11
:end-before: end error 11
```

### Transforming to Result

You can also catch the potential error and transform into a first-class value of the
[`Result`](/language/fundamentals.md#option-and-result) type, by:

- using `try?` before an expression that may throw error
- appending `?` after the function name

```{literalinclude} /sources/language/src/error/top.mbt
:language: moonbit
:start-after: start error 8
:end-before: end error 8
```

### Error Inference

Within a `try` block, several different kinds of errors can be raised. When that
happens, the compiler will use the type `Error` as the common error type.
Accordingly, the handler must use the wildcard `_` to make sure all errors are
caught. For example,

```{literalinclude} /sources/language/src/error/top.mbt
:language: moonbit
:dedent:
:start-after: start error 13
:end-before: end error 13
```

You can also use `catch!` to rethrow the uncaught errors for convenience. This
is useful when you only want to handle a specific error and rethrow others. For
example,

```{literalinclude} /sources/language/src/error/top.mbt
:language: moonbit
:dedent:
:start-after: start error 14
:end-before: end error 14
```


---


## 文档：packages

---

# Managing Projects with Packages

When developing projects at large scale, the project usually needs to be divided into smaller modular unit that depends on each other. 
More often, it involves using other people's work: most noticeably is the [core](https://github.com/moonbitlang/core), the standard library of MoonBit.

## Packages and modules

In MoonBit, the most important unit for code organization is a package, which consists of a number of source code files and a single `moon.pkg.json` configuration file.
A package can either be a `main` package, consisting a `main` function, or a package that serves as a library, identified by the [`is-main`](/toolchain/moon/package.md#is-main) field.

A project, corresponding to a module, consists of multiple packages and a single `moon.mod.json` configuration file.

A module is identified by the [`name`](/toolchain/moon/module.md#name) field, which usually consists to parts, seperated by `/`: `user-name/project-name`.
A package is identified by the relative path to the source root defined by the [`source`](/toolchain/moon/module.md#source-directory) field. The full identifier would be `user-name/project-name/path-to-pkg`.

When using things from another package, the dependency between modules should first be declared inside the `moon.mod.json` by the [`deps`](/toolchain/moon/module.md#deps) field.
The dependency between packages should then be declared in side the `moon.pkg.json` by the [`import`](/toolchain/moon/package.md#import) field.

(default-alias)=
The **default alias** of a package is the last part of the identifier split by `/`.
One can use `@pkg_alias` to access the imported entities, where `pkg_alias` is either the full identifier or the default alias.
A custom alias may also be defined with the [`import`](/toolchain/moon/package.md#import) field.

```{literalinclude} /sources/language/src/packages/pkgB/moon.pkg.json
:language: json
:caption: pkgB/moon.pkg.json
```

```{literalinclude} /sources/language/src/packages/pkgB/top.mbt
:language: moonbit
:caption: pkgB/top.mbt
```

### Internal Packages

You can define internal packages that are only available for certain packages.

Code in `a/b/c/internal/x/y/z` are only available to packages `a/b/c` and `a/b/c/**`.

## Access Control

MoonBit features a comprehensive access control system that governs which parts of your code are accessible from other packages. 
This system helps maintain encapsulation, information hiding, and clear API boundaries. 
The visibility modifiers apply to functions, variables, types, and traits, allowing fine-grained control over how your code can be used by others.

### Functions

By default, all function definitions and variable bindings are _invisible_ to other packages.
You can use the `pub` modifier before toplevel `let`/`fn` to make them public.

### Aliases

By default, all aliases, i.e. [function alias](/language/fundamentals.md#function-alias), 
[method alias](/language/methods.md#method-alias),
[type alias](/language/fundamentals.md#type-alias),
[trait alias](/language/methods.md#trait-alias), are _invisible_ to other packages.

You can use the `pub` modifier before the definition to make them public.

### Types

There are four different kinds of visibility for types in MoonBit:

- Private type: declared with `priv`, completely invisible to the outside world
- Abstract type: which is the default visibility for types. 

  Only the name of an abstract type is visible outside, the internal representation of the 
  type is hidden. Making abstract type by default is a design choice to encourage 
  encapsulation and information hiding.

- Readonly types, declared with `pub`. 
  
  The internal representation of readonly types are visible outside,
  but users can only read the values of these types from outside, construction and mutation are not allowed
  This also applies to newtype, when declared with only `pub`, its underlying data can only be accessed from outside,
  but user cannot create new values.

- Fully public types, declared with `pub(all)`. 

  The outside world can freely construct, read values of these types and modify them if possible.

In addition to the visibility of the type itself, the fields of a public `struct` can be annotated with `priv`,
which will hide the field from the outside world completely.
Note that `struct`s with private fields cannot be constructed directly outside,
but you can update the public fields using the functional struct update syntax.

Readonly types is a very useful feature, inspired by [private types](https://ocaml.org/manual/5.3/privatetypes.html) in OCaml. 
In short, values of `pub` types can be destructed by pattern matching and the dot syntax, but 
cannot be constructed or mutated in other packages. 

```{note}
There is no restriction within the same package where `pub` types are defined.
```
<!-- MANUAL CHECK -->

```moonbit
// Package A
pub struct RO {
  field: Int
}
test {
  let r = { field: 4 }       // OK
  let r = { ..r, field: 8 }  // OK
}

// Package B
fn println(r : RO) -> Unit {
  println("{ field: ")
  println(r.field)  // OK
  println(" }")
}
test {
  let r : RO = { field: 4 }  // ERROR: Cannot create values of the public read-only type RO!
  let r = { ..r, field: 8 }  // ERROR: Cannot mutate a public read-only field!
}
```

Access control in MoonBit adheres to the principle that a `pub` type, function, or variable cannot be defined in terms of a private type. This is because the private type may not be accessible everywhere that the `pub` entity is used. MoonBit incorporates sanity checks to prevent the occurrence of use cases that violate this principle.

<!-- MANUAL CHECK -->
```moonbit
pub(all) type T1
pub(all) type T2
priv type T3

pub(all) struct S {
  x: T1  // OK
  y: T2  // OK
  z: T3  // ERROR: public field has private type `T3`!
}

// ERROR: public function has private parameter type `T3`!
pub fn f1(_x: T3) -> T1 { ... }
// ERROR: public function has private return type `T3`!
pub fn f2(_x: T1) -> T3 { ... }
// OK
pub fn f3(_x: T1) -> T1 { ... }

pub let a: T3 = { ... } // ERROR: public variable has private type `T3`!
```

### Traits

There are four visibility for traits, just like `struct` and `enum`: private, abstract, readonly and fully public.
- Private traits are declared with `priv trait`, and they are completely invisible from outside.
- Abstract trait is the default visibility. Only the name of the trait is visible from outside, and the methods in the trait are not exposed.
- Readonly traits are declared with `pub trait`, their methods can be invoked from outside, but only the current package can add new implementation for readonly traits.
- Fully public traits are declared with `pub(open) trait`, they are open to new implementations outside current package, and their methods can be freely used.

Abstract and readonly traits are sealed, because only the package defining the trait can implement them.
Implementing a sealed (abstract or readonly) trait outside its package result in compiler error.

#### Trait Implementations

Implementations have independent visibility, just like functions. The type will not be considered having fulfillled the trait outside current package unless the implementation is `pub`.

To make the trait system coherent (i.e. there is a globally unique implementation for every `Type: Trait` pair),
and prevent third-party packages from modifying behavior of existing programs by accident,
MoonBit employs the following restrictions on who can define methods/implement traits for types:

- _only the package that defines a type can define methods for it_. So one cannot define new methods or override old methods for builtin and foreign types.
- _only the package of the type or the package of the trait can define an implementation_.
  For example, only `@pkg1` and `@pkg2` are allowed to write `impl @pkg1.Trait for @pkg2.Type`.

The second rule above allows one to add new functionality to a foreign type by defining a new trait and implementing it.
This makes MoonBit's trait & method system flexible while enjoying good coherence property.

```{warning}
Currently, an empty trait is implemented automatically.
```

Here's an example of abstract trait:

<!-- MANUAL CHECK -->
```{code-block} moonbit
:class: top-level
trait Number {
 op_add(Self, Self) -> Self
 op_sub(Self, Self) -> Self
}

fn[N : Number] add(x : N, y: N) -> N {
  Number::op_add(x, y)
}

fn[N : Number] sub(x : N, y: N) -> N {
  Number::op_sub(x, y)
}

impl Number for Int with op_add(x, y) { x + y }
impl Number for Int with op_sub(x, y) { x - y }

impl Number for Double with op_add(x, y) { x + y }
impl Number for Double with op_sub(x, y) { x - y }
```

From outside this package, users can only see the following:

```{code-block} moonbit
trait Number

fn[N : Number] op_add(x : N, y : N) -> N
fn[N : Number] op_sub(x : N, y : N) -> N

impl Number for Int
impl Number for Double
```

The author of `Number` can make use of the fact that only `Int` and `Double` can ever implement `Number`,
because new implementations are not allowed outside.

## Virtual Packages

```{warning}
Virtual package is an experimental feature. There may be bugs and undefined behaviors.
```

You can define virtual packages, which serves as an interface. They can be replaced by specific implementations at build time. Currently virtual packages can only contain plain functions.

Virtual packages can be useful when swapping different implementations while keeping the code untouched.

### Defining a virtual package

You need to declare it to be a virtual package and define its interface in a MoonBit interface file.

Within `moon.pkg.json`, you will need to add field [`virtual`](/toolchain/moon/package.md#declarations) :

```{literalinclude} /sources/language/src/packages/virtual/moon.pkg.json
:language: json
```

The `has-default` indicates whether the virtual package has a default implementation.

Within the package, you will need to add an interface file `package-name.mbti` where the `package-name` is the same as [the default alias](#default-alias):

```{literalinclude} /sources/language/src/packages/virtual/virtual.mbti
:language: moonbit
:caption: /src/packages/virtual/virtual.mbti
```

The first line of the interface file need to be `package "full-package-name"`. Then comes the declarations.
The `pub` keyword for [access control](#access-control) and the function parameter names should be omitted.

```{hint}
If you are uncertain about how to define the interface, you can create a normal package, define the functions you need using [TODO syntax](/language/fundamentals.md#todo-syntax), and use `moon info` to help you generate the interface.
```

### Implementing a virtual package

A virtual package can have a default implementation. By defining [`virtual.has-default`](/toolchain/moon/package.md#declarations) as `true`, you can implement the code as usual within the same package.

```{literalinclude} /sources/language/src/packages/virtual/top.mbt
:language: moonbit
:caption: /src/packages/virtual/top.mbt
```

A virtual package can also be implemented by a third party. By defining [`implements`](/toolchain/moon/package.md#implementations) as the target package's full name, the compiler can warn you about the missing implementations or the mismatched implementations.

```{literalinclude} /sources/language/src/packages/implement/moon.pkg.json
:language: json
```

```{literalinclude} /sources/language/src/packages/implement/top.mbt
:language: moonbit
:caption: /src/packages/implement/top.mbt
```

### Using a virtual package

To use a virtual package, it's the same as other packages: define [`import`](/toolchain/moon/package.md#import) field in the package where you want to use it.

### Overriding a virtual package

If a virtual package has a default implementation and that is your choice, there's no extra configurations.

Otherwise, you may define the [`overrides`](/toolchain/moon/package.md#overriding-implementations) field by providing an array of implementations that you would like to use.

```{literalinclude} /sources/language/src/packages/use_implement/moon.pkg.json
:language: json
:caption: /src/packages/use_implement/moon.pkg.json
```

You should reference the virtual package when using the entities.

```{literalinclude} /sources/language/src/packages/use_implement/top.mbt
:language: moonbit
:caption: /src/packages/use_implement/top.mbt
```


---


## 文档：tests

---

# Writing Tests

Tests are important for improving quality and maintainability of a program. They verify the behavior of a program and also serves as a specification to avoid regressions over time.

MoonBit comes with test support to make the writing easier and simpler.

## Test Blocks

MoonBit provides the test code block for writing inline test cases. For example:

```{literalinclude} /sources/language/src/test/top.mbt
:language: moonbit
:start-after: start test 1
:end-before: end test 1
```

A test code block is essentially a function that returns a `Unit` but may throws an [`Error`](/language/error-handling.md#error-types), or `Unit!Error` as one would see in its signature at the position of return type. It is called during the execution of `moon test` and outputs a test report through the build system. The `assert_eq` function is from the standard library; if the assertion fails, it prints an error message and terminates the test. The string `"test_name"` is used to identify the test case and is optional. 

If a test name starts with `"panic"`, it indicates that the expected behavior of the test is to trigger a panic, and the test will only pass if the panic is triggered. For example:

```{literalinclude} /sources/language/src/test/top.mbt
:language: moonbit
:start-after: start test 2
:end-before: end test 2
```

## Snapshot Tests

Writing tests can be tedious when specifying the expected values. Thus, MoonBit provides three kinds of snapshot tests.
All of which can be inserted or updated automatically using `moon test --update`.

### Snapshotting `Show`

We can use `inspect!(x, content="x")` to inspect anything that implements `Show` trait. 
As we mentioned before, `Show` is a builtin trait that can be derived, providing `to_string` that will print the content of the data structures. 
The labelled argument `content` can be omitted as `moon test --update` will insert it for you:

```{literalinclude} /sources/language/src/test/top.mbt
:language: moonbit
:start-after: start snapshot test 1
:end-before: end snapshot test 1
```

### Snapshotting `JSON`

The problem with the derived `Show` trait is that it does not perform pretty printing, resulting in extremely long output.

The solution is to use `@json.inspect!(x, content=x)`. The benefit is that the resulting content is a JSON structure, which can be more readable after being formatted.

```{literalinclude} /sources/language/src/test/top.mbt
:language: moonbit
:start-after: start snapshot test 2
:end-before: end snapshot test 2
```

One can also implement a custom `ToJson` to keep only the essential information.

### Snapshotting Anything

Still, sometimes we want to not only record one data structure but the output of a whole process.

A full snapshot test can be used to record anything using `@test.T::write` and `@test.T::writeln`:

```{literalinclude} /sources/language/src/test/top.mbt
:language: moonbit
:start-after: start snapshot test 3
:end-before: end snapshot test 3
```

This will create a file under `__snapshot__` of that package with the given filename:

```{literalinclude} /sources/language/src/test/__snapshot__/record_anything.txt
```

This can also be used for applications to test the generated output, whether it were creating an image, a video or some custom data.

Please note that `@test.T::snapshot` should be used at the end of a test block, as it always raises exception.

## BlackBox Tests and WhiteBox Tests

When developing libraries, it is important to verify if the user can use it correctly. For example, one may forget to make a type or a function public. That's why MoonBit provides BlackBox tests, allowing developers to have a grasp of how others are feeling.

- A test that has access to all the members in a package is called a WhiteBox tests as we can see everything. Such tests can be defined inline or defined in a file whose name ends with `_wbtest.mbt`.

- A test that has access only to the public members in a package is called a BlackBox tests. Such tests need to be defined in a file whose name ends with `_test.mbt`.

The WhiteBox test files (`_wbtest.mbt`) imports the packages defined in the `import` and `wbtest-import` sections of the package configuration (`moon.pkg.json`).

The BlackBox test files (`_test.mbt`) imports the current package and the packages defined in the `import` and `test-import` sections of the package configuration (`moon.pkg.json`).


---


## 文档：benchmarks

---

# Writing Benchmarks

Benchmarks are a way to measure the performance of your code. They can be used to compare different implementations or to track performance changes over time.

## Benchmarking with Test Blocks


The most simple way to benchmark a function is to use a test block with a 
`@bench.T` argument. It has a method `@bench.T::bench` that takes a function of type
`() -> Unit` and run it with a suitable number of iterations.
The measurements and statistical analysis will be conducted and passed to `moon`,
where they will be displayed in the console output.

```{literalinclude} /sources/language/src/benchmark/top.mbt
:language: moonbit
:start-after: start bench 1
:end-before: end bench 1
```

The output is as follows:

```
time (mean ± σ)         range (min … max) 
  21.67 µs ±   0.54 µs    21.28 µs …  23.14 µs  in 10 ×   4619 runs
```

The function is executed `10 × 4619` times.
The second number is automatically detected by benchmark utilities, which increase the number of iterations until the measurement time is long enough for accurate timing.
The first number can be adjusted by passing a named parameter `count` to the `@bench.T::bench` argument.

```{literalinclude} /sources/language/src/benchmark/top.mbt
:language: moonbit
:start-after: start bench 2
:end-before: end bench 2
```

`@bench.T::keep` is an important auxiliary function that prevents your calculation from being optimized away and skipped entirely.
If you are benchmarking a pure function, make sure to use this function to avoid potential optimizations.
However, there is still a possibility that the compiler might pre-calculate and replace the calculation with a constant.


## Batch Benchmarking

A common scenario of benchmarking is to compare two or more implementations of the same function.
In this case, you may want to bench them in a batch within a block for easy comparison.
The `name` parameter of the `@bench.T::bench` method can be used to identify the benchmark.

```{literalinclude} /sources/language/src/benchmark/top.mbt
:language: moonbit
:start-after: start bench 3
:end-before: end bench 3
```

Now you can evaluate which one is faster by looking at the output:

```
name      time (mean ± σ)         range (min … max) 
naive_fib   21.01 µs ±   0.21 µs    20.76 µs …  21.32 µs  in 10 ×   4632 runs
fast_fib     0.02 µs ±   0.00 µs     0.02 µs …   0.02 µs  in 10 × 100000 runs
```

## Raw Benchmark Statistics

Sometimes users may want to obtain raw benchmark statistics for further analysis.
There is a function `@bench.single_bench` that returns an abstract `Summary` type, which can be serialized into JSON format. The stability of the `Summary` type is not guaranteed to be stable.

In this case, users must ensure that the calculation is not optimized away.
There is no `keep` function available as a standalone function; it is a method of `@bench.T`.

```{literalinclude} /sources/language/src/benchmark/top.mbt
:language: moonbit
:start-after: start bench 4
:end-before: end bench 4
```

The output may look like this:

```json
6765
{
    "name": "fib",
    "sum": 217.22039973878972,
    "min": 21.62009230518067,
    "max": 21.87286402916848,
    "mean": 21.72203997387897,
    "median": 21.70412048323901,
    "var": 0.007197724461032505,
    "std_dev": 0.08483940394081341,
    "std_dev_pct": 0.39056830777787843,
    "median_abs_dev": 0.08189815918589166,
    "median_abs_dev_pct": 0.3773392211360855,
    "quartiles": [
        21.669052078798433,
        21.70412048323901,
        21.76141434479756
    ],
    "iqr": 0.09236226599912811,
    "batch_size": 4594,
    "runs": 10
}
```

Time units are in microseconds.


---


## 文档：docs

---

# Documentation

## Doc Comments

Doc comments are comments prefix with `///` in each line in the leading of toplevel structure like `fn`, `let`, `enum`, `struct` or `type`. The doc comments are written in markdown.

```{literalinclude} /sources/language/src/misc/top.mbt
:language: moonbit
:start-after: start doc string 1
:end-before: end doc string 1

```

## Attribute

Attributes are annotations placed before the top-level structure. They take the form `#attribute(...)`. 
An attribute occupies the entire line, and newlines are not allowed within it. 
Attributes do not normally affect the meaning of programs. Unused attributes will be reported as warnings.

### The Deprecated Attribute

The `#deprecated` attribute is used to mark a function, type, or trait as deprecated. 
MoonBit emits a warning when the deprecated function or type is used in other packages. 
You can customize the warning message by passing a string to the attribute.

For example:

```{literalinclude} /sources/language/src/attributes/top.mbt
:language: moonbit
:start-after: start deprecated
:end-before: end deprecated
  ```

### The Visibility Attribute

```{note}
This topic does not covered the access control. To lean more about `pub`, `pub(all)` and `priv`, see [Access Control](./packages.md#access-control).
```

The `#visibility` attribute is similar to the `#deprecated` attribute, but it is used to hint that a type will change its visibility in the future. 
For outside usages, if the usage will be invalidated by the visibility change in future, a warning will be emitted. 

```{literalinclude} /sources/language/src/attributes/top.mbt
:language: moonbit
:start-after: start visibility
:end-before: end visibility
```

The `#visibility` attribute takes two arguments: `change_to` and `message`.

- The `change_to` argument is a string that indicates the new visibility of the type. It can be either `"abstract"` or `"readonly"`.

  | `change_to` | Invalidated Usages |
  |-------------|--------------------|
  | `"readonly"`  | Creating an instance of the type or mutating the fields of the instance. |
  | `"abstract"`  | Creating an instance of the type, mutating the fields of the instance, pattern matching, or accessing fields by label. |

- The `message` argument is a string that provides additional information about the visibility change.

### The Internal Attribute

The `#internal` attribute is used to mark a function, type, or trait as internal. 
Any usage of the internal function or type in other modules will emit an alert warning.

```{code-block} moonbit
:class: top-level
#internal(unsafe, "This is an unsafe function")
fn unsafe_get[A](arr : Array[A]) -> A {
  ...
}
```

The internal attribute takes two arguments: `category` and `message`. 
`category` is a identifier that indicates the category of the alert, and `message` is a string that provides additional message for the alert.

The alert warnings can be turn off by setting the `alert-list` in `moon.pkg.json`.
For more detail, see [Alert](../toolchain/moon/package.md#alert-list).

### The Borrow Attribute

The `#borrow` attribute is used to indicate that a FFI takes ownership of its arguments. For more detail, see [FFI](./ffi.md#The-borrow-attribute).


---


## 文档：derive

---

# Deriving traits

MoonBit supports deriving a number of builtin traits automatically from the type definition.

To derive a trait `T`, it is required that all fields used in the type implements `T`.
For example, deriving `Show` for a struct `struct A { x: T1; y: T2 }` requires both `T1: Show` and `T2: Show`

## Show

`derive(Show)` will generate a pretty-printing method for the type.
The derived format is similar to how the type can be constructed in code.

```{literalinclude} /sources/language/src/derive/show.mbt
:language: moonbit
:start-after: start derive show struct
:end-before: end derive show struct
```

```{literalinclude} /sources/language/src/derive/show.mbt
:language: moonbit
:start-after: start derive show enum
:end-before: end derive show enum
```

## Eq and Compare

`derive(Eq)` and `derive(Compare)` will generate the corresponding method for testing equality and comparison.
Fields are compared in the same order as their definitions.
For enums, the order between cases ascends in the order of definition.

```{literalinclude} /sources/language/src/derive/eq_compare.mbt
:language: moonbit
:start-after: start derive eq_compare struct
:end-before: end derive eq_compare struct
```

```{literalinclude} /sources/language/src/derive/eq_compare.mbt
:language: moonbit
:start-after: start derive eq_compare enum
:end-before: end derive eq_compare enum
```

## Default

`derive(Default)` will generate a method that returns the default value of the type.

For structs, the default value is the struct with all fields set as their default value.

```{literalinclude} /sources/language/src/derive/default.mbt
:language: moonbit
:start-after: start derive default struct
:end-before: end derive default struct
```

For enums, the default value is the only case that has no parameters.

```{literalinclude} /sources/language/src/derive/default.mbt
:language: moonbit
:start-after: start derive default enum
:end-before: end derive default enum
```

Enums that has no cases or more than one cases without parameters cannot derive `Default`.

<!-- MANUAL CHECK  should not compile -->

```moonbit
enum CannotDerive1 {
    Case1(String)
    Case2(Int)
} derive(Default) // cannot find a constant constructor as default

enum CannotDerive2 {
    Case1
    Case2
} derive(Default) // Case1 and Case2 are both candidates as default constructor
```

## Hash

`derive(Hash)` will generate a hash implementation for the type.
This will allow the type to be used in places that expects a `Hash` implementation,
for example `HashMap`s and `HashSet`s.

```{literalinclude} /sources/language/src/derive/hash.mbt
:language: moonbit
:start-after: start derive hash struct
:end-before: end derive hash struct
```

## Arbitrary

`derive(Arbitrary)` will generate random values of the given type.

## FromJson and ToJson

`derive(FromJson)` and `derive(ToJson)` will generate methods that deserializes/serializes the given type from/to
JSON files correspondingly.

```{literalinclude} /sources/language/src/derive/json.mbt
:language: moonbit
:start-after: start json basic
:end-before: end json basic
```

Both derive directives accept a number of arguments to configure the exact behavior of serialization and deserialization.

```{warning}
The actual behavior of JSON serialization arguments is unstable.
```

```{literalinclude} /sources/language/src/derive/json.mbt
:language: moonbit
:start-after: start json args
:end-before: end json args
```

### Enum representations

Enums can be represented in JSON in a number of styles.
There are two aspects of the representation:

- **Tag position** determines where the name of the enum tag (i.e. case or constructor name) is stored.
- **Case representation** determines how to represent the payload of the enum.

Let's consider the following enum definition:

```moonbit
enum E {
    Uniform(Int)
    Axes(x~: Int, y~: Int)
}
```

For tag position, there are 4 variants:

- **Internally tagged** puts the tag alongside the payload values:

  `{ "$tag": "Uniform", "0": 1 }`, `{ "$tag": "Axes", "x": 2, "y": 3 }`

- **Externally tagged** puts the tag as the JSON object key outside the payload values:

  `{ "Uniform": { "0": 1 } }`, `{ "Axes": { "x": 2, "y": 3 } }`

- **Adjacently tagged** puts the tag payload in two adjacent keys in a JSON object:

  `{ "t": "Uniform", "c": { "0": 1 } }`, `{ "t": "Axes", "c": { "x": 2, "y": 3 } }`

- **Untagged** has no explicit tag identifying which case the data is:

  `{ "0": 1 }`, `{ "x": 2, "y": 3 }`.

  The JSON deserializer will try to deserialize each case in order and return the first one succeeding.

For case representation, there are 2 variants:

- **Object-like** representation serializes enum payloads into a JSON object,
  whose key is either the tag name or the string of the positional index within the struct.

  `{ "0": 1 }`, `{ "x": 2, "y": 3 }`

- **Tuple-like** representation serializes enum payloads into a tuple (jSON array),
  in the same order as the type declaration.
  Labels are omitted in tuple-like representations.

  `[1]`, `[2, 3]`

The two aspects can be combined freely, except one case:
_internally tagged_ enums cannot use _tuple-like_ representation.

### Container arguments

- `repr(...)` configures the representation of the container.
  This controls the tag position of enums.
  For structs, the tag is assumed to be the type of the type.

  There are 4 representations available for selection:

  - `repr(tag = "tag")` –
    Use internally tagged representation,
    with the tag's object key name as specified.
  - `repr(untagged)` –
    Use untagged representation.
  - `repr(ext_tagged)` –
    Use externally tagged representation.
  - `repr(tag = "tag", contents = "contents")` –
    Use adjacently tagged representation,
    with the tag and contents key names as specified.

  The default representation for struct is `repr(untagged)`.

  The default representation for enums is `repr(tag = "$tag")`

- `case_repr(...)` (enum only) configures the case representation of the container.
  This option is only available on enums.

  - `case_repr(struct)` –
    Use struct-like representation of enums.

  - `case_repr(tuple)` –
    Use tuple-like representation of enums.

- `rename_fields`, `rename_cases` (enum only), `rename_struct` (struct only), `rename_all`
  renames fields, case names, struct name and all names correspondingly,
  into a specific style.

  Available parameters are:

  - `lowercase`
  - `UPPERCASE`
  - `camelCase`
  - `PascalCase`
  - `snake_case`
  - `SCREAMING_SNAKE_CASE`
  - `kebab-case`
  - `SCREAMING-KEBAB-CASE`

  Example: `rename_fields = "PascalCase"`
  for a field named `my_long_field_name`
  results in `MyLongFieldName`.

  Renaming assumes the name of fields in `snake_case`
  and the name of structs/enum cases in `PascalCase`.

- `cases(...)` (enum only) controls the layout of enum cases.

  For example, for an enum

  ```moonbit
  enum E {
    A(...)
    B(...)
  }
  ```

  you are able to control each case using `cases(A(...), B(...))`.

  See [Case arguments](#case-arguments) below for details.

- `fields(...)` (struct only) controls the layout of struct fields.

  For example, for a struct

  ```moonbit
  struct S {
    x: Int
    y: Int
  }
  ```

  you are able to control each field using `fields(x(...), y(...))`

  See [Field arguments](#field-arguments) below for details.

### Case arguments

- `rename = "..."` renames this specific case,
  overriding existing container-wide rename directive if any.

- `fields(...)` controls the layout of the payload of this case.
  Note that renaming positional fields are not possible currently.

  See [Field arguments](#field-arguments) below for details.

### Field arguments

- `rename = "..."` renames this specific field,
  overriding existing container-wide rename directives if any.


---


## 文档：async-experimental

---

# Experimental async programming support

MoonBit is providing experimental support for async programming.
But the design and API is still highly unstable, and may receive big breaking change in the future.
This page documents the current design, and we highly appreciate any feedback or experiment with current design.

## Async function
Async functions are declared with the `async` keyword:

```{literalinclude} /sources/async/src/async.mbt
:language: moonbit
:start-after: start async function declaration
:end-before: end async function declaration
```

Since MoonBit is a statically typed language, the compiler will track its 
asyncness, so you can just call async functions like normal functions, the
MoonBit IDE will highlight the async function call with a different style.

```{literalinclude} /sources/async/src/async.mbt
:language: moonbit
:start-after: start async function call syntax
:end-before: end async function call syntax
```

Async functions can only be called in async functions. 

```{warning}
Currently, async functions 
have not be supported in the body of `for .. in` loops yet, this 
will be addressed in the future.
```

## Async primitives for suspension
MoonBit provides two core primitives for `%async.suspend` and `%async.run`:

```{literalinclude} /sources/async/src/async.mbt
:language: moonbit
:start-after: start async primitive
:end-before: end async primitive
```

There two primitives are not intended for direct use by end users.
However, since MoonBit's standard library for async programming is still under development,
currently users need to bind these two primitives manually to do async programming.

There are two ways of reading these primitives:

- The coroutine reading: `%async.run` spawn a new coroutine,
  and `%async.suspend` suspend current coroutine.
  The main difference with other languages here is:
  instead of yielding all the way to the caller of `%async.run`,
  resumption of the coroutine is handled by the callback passed to `%async.suspend`
- The delimited continuation reading: `%async.run` is the `reset` operator in
  delimited continuation, and `%async.suspend` is the `shift` operator in
  delimited continuation

Here's an example of how these two primitives work:

```{literalinclude} /sources/async/src/async.mbt
:language: moonbit
:start-after: start async example
:end-before: end async example
```

In `async_worker`, `suspend` will capture the rest of the current coroutine as two "continuation" functions, and pass them to a callback.
In the callback, calling `resume_ok` will resume execution at the point of `suspend!(...)`,
all the way until the `run_async` call that start this coroutine.
calling `resume_err` will also resume execution of current coroutine,
but it will make `suspend(...)` throw an error instead of returning normally.

Notice that `suspend` type may throw error, even if `suspend` itself never throw an error directly.
This design makes coroutines cancellable at every `suspend` call: just call the corresponding `resume_err` callback.

## Integrating with JS Promise/callback based API
Since MoonBit's standard async library is still under development,
so there is no ready-to-use implementation for event loop and IO operations yet.
So the easiest way to write some async program is to use MoonBit's Javascript backend,
and reuse the event loop and IO operations of Javascript.
Here's an example of integrating MoonBit's async programming support with JS's callback based API:

```{literalinclude} /sources/async/src/async.mbt
:language: moonbit
:start-after: start async timer example
:end-before: end async timer example
```

Integrating with JS Promise is easy too:
just pass `resume_ok` as the `resolve` callback and `resume_err` as the `reject` callback to a JS promise.


---
