
# MoonBit Core Standard Library Complete Guide

MoonBit Core is the standard library of the MoonBit language, providing core functionality and data structures commonly used in programming. This document follows the MoonBit project documentation format and comprehensively introduces the various modules of the Core library and their usage.

## Overview

The MoonBit Core standard library contains the following main functional modules:

- **Basic Types & Operations**: builtin, string, array, bytes, etc.
- **Data Structures**: hashmap, list, deque, queue, priority_queue, etc.
- **Mathematical Operations**: math, bigint, rational, etc.
- **Data Conversion**: json, strconv, encoding, etc.
- **Functional Programming**: option, result, iter, etc.
- **Concurrency & Async**: Support for structured concurrent programming
- **Utilities**: random, quickcheck, test, etc.

## Basic Types & Operations

### builtin - Built-in Types and Core Functionality

The builtin package provides MoonBit's core types, assertions, testing, and basic functionality.

#### Assertions and Testing

```moonbit
///|
test "basic assertions" {
  // Equality assertions
  assert_eq(1 + 1, 2)
  assert_eq("hello", "hello")

  // Boolean assertions
  assert_true(5 > 3)
  assert_false(2 > 5)

  // Inequality assertions
  assert_not_eq(1, 2)
  assert_not_eq("foo", "bar")
}
```

#### inspect Function for Testing and Debugging

```moonbit
///|
test "inspect usage" {
  let value = 42
  inspect(value, content="42")

  let list = [1, 2, 3]
  inspect(list, content="[1, 2, 3]")

  let result : Result[Int, String] = Ok(100)
  inspect(result, content="Ok(100)")
}
```

#### Result Type

The Result type represents operations that may succeed or fail:

```moonbit
///|
test "Result type usage" {
  // Create Result values
  let success : Result[Int, String] = Ok(42)
  let failure : Result[Int, String] = Err("error message")

  // Pattern matching
  match success {
    Ok(value) => inspect(value, content="42")
    Err(msg) => panic()
  }

  // Use map to transform success values
  let doubled = success.map(x => x * 2)
  inspect(doubled, content="Ok(84)")

  // Use unwrap_or to provide default value
  let value = failure.unwrap_or(0)
  inspect(value, content="0")
}
```

#### Option Type

The Option type represents values that may or may not exist:

```moonbit
///|
test "Option type usage" {
  // Create Option values
  let some_value : Option[Int] = Some(42)
  let none_value : Option[Int] = None

  // Pattern matching
  match some_value {
    Some(x) => inspect(x, content="42")
    None => panic()
  }

  // Use map to transform values
  let doubled = some_value.map(x => x * 2)
  inspect(doubled, content="Some(84)")

  // Use unwrap_or to provide default value
  let value = none_value.unwrap_or(0)
  inspect(value, content="0")
}
```

### string - String Operations

The string package provides rich string manipulation functionality.

#### Basic String Operations

```moonbit
///|
test "basic string operations" {
  let s = "Hello, MoonBit!"

  // Length and emptiness check
  inspect(s.length(), content="15")
  inspect(s.is_empty(), content="false")

  // Character access
  inspect(s[0], content="72") // ASCII value of 'H'
  inspect(s.get_char(0), content="Some('H')")

  // Substring
  let substr = s[0:5]
  inspect(substr, content="Hello")

  // Search
  inspect(s.contains("Moon"), content="true")
  inspect(s.index_of("Moon"), content="Some(7)")
}
```

#### String Conversion and Processing

```moonbit
///|
test "string conversion" {
  let s = "  Hello World  "

  // Trim whitespace
  inspect(s.trim(), content="Hello World")
  inspect(s.trim_start(), content="Hello World  ")
  inspect(s.trim_end(), content="  Hello World")

  // Case conversion
  inspect(s.to_upper(), content="  HELLO WORLD  ")
  inspect(s.to_lower(), content="  hello world  ")

  // Split
  let parts = "a,b,c".split(",")
  inspect(parts, content="[\"a\", \"b\", \"c\"]")

  // Replace
  let replaced = "hello world".replace("world", "MoonBit")
  inspect(replaced, content="hello MoonBit")
}
```

#### String Interpolation

```moonbit
///|
test "string interpolation" {
  let name = "MoonBit"
  let version = 1.0
  let message = "Hello \{name} v\{version}"
  inspect(message, content="Hello MoonBit v1.0")

  // Multi-line strings
  let multi_line =
    #|First line
    #|Second line
    #|Third line
    #|
  inspect(multi_line, content="First line\nSecond line\nThird line\n")
}
```

#### StringBuilder

```moonbit
///|
test "StringBuilder usage" {
  let sb = StringBuilder::new()
  sb.write_string("Hello")
  sb.write_char(' ')
  sb.write_string("World")

  let result = sb.to_string()
  inspect(result, content="Hello World")

  // Method chaining
  let sb2 = StringBuilder::new()
  sb2..write_string("A")..write_string("B")..write_string("C")
  inspect(sb2.to_string(), content="ABC")
}
```

### array - Array Operations

The array package provides operations for dynamic arrays (Array), fixed arrays (FixedArray), and array views (ArrayView).

#### Array Creation

```moonbit
///|
test "array creation" {
  // Using literals
  let arr1 = [1, 2, 3]
  inspect(arr1, content="[1, 2, 3]")

  // Creating with indices
  let arr2 = Array::makei(5, i => i * 2)
  inspect(arr2, content="[0, 2, 4, 6, 8]")

  // Creating from iterator
  let arr3 = Array::from_iter("hello".iter())
  inspect(arr3, content="['h', 'e', 'l', 'l', 'o']")

  // Repeated elements
  let arr4 = Array::make(3, "x")
  inspect(arr4, content="[\"x\", \"x\", \"x\"]")
}
```

#### Array Operations

```moonbit
///|
test "array operations" {
  let nums = [1, 2, 3, 4, 5]

  // Filtering and mapping
  let evens = nums.filter(x => x % 2 == 0)
  inspect(evens, content="[2, 4]")

  let doubled = nums.map(x => x * 2)
  inspect(doubled, content="[2, 4, 6, 8, 10]")

  // filter_map combined operation
  let neg_evens = nums.filter_map(x => if x % 2 == 0 { Some(-x) } else { None })
  inspect(neg_evens, content="[-2, -4]")

  // Folding operations
  let sum = nums.fold(init=0, (acc, x) => acc + x)
  inspect(sum, content="15")

  let product = nums.fold(init=1, (acc, x) => acc * x)
  inspect(product, content="120")
}
```

#### Array Search and Access

```moonbit
///|
test "array search" {
  let arr = [10, 20, 30, 40, 50]

  // Index access
  inspect(arr[0], content="10")
  inspect(arr.get(0), content="Some(10)")
  inspect(arr.get(10), content="None")

  // Find elements
  inspect(arr.contains(30), content="true")
  inspect(arr.index_of(30), content="Some(2)")

  // First and last
  inspect(arr.first(), content="Some(10)")
  inspect(arr.last(), content="Some(50)")

  // Find elements matching condition
  let found = arr.find(x => x > 25)
  inspect(found, content="Some(30)")
}
```

#### Array Sorting

```moonbit
///|
test "array sorting" {
  let arr = [3, 1, 4, 1, 5, 9, 2, 6]

  // Basic sorting - modifies original array
  let sorted1 = arr.copy()
  sorted1.sort()
  inspect(sorted1, content="[1, 1, 2, 3, 4, 5, 6, 9]")

  // Custom comparison sorting
  let strs = ["apple", "pie", "a"]
  let sorted2 = strs.copy()
  sorted2.sort_by((a, b) => a.length().compare(b.length()))
  inspect(sorted2, content="[\"a\", \"pie\", \"apple\"]")

  // Sort by key
  let pairs = [(2, "b"), (1, "a"), (3, "c")]
  let sorted3 = pairs.copy()
  sorted3.sort_by_key(p => p.0)
  inspect(sorted3, content="[(1, \"a\"), (2, \"b\"), (3, \"c\")]")
}
```

#### FixedArray Fixed Arrays

```moonbit
///|
test "FixedArray usage" {
  // Create fixed-size array
  let fixed = FixedArray::make(5, 0)
  fixed[0] = 10
  fixed[1] = 20

  inspect(fixed.length(), content="5")
  inspect(fixed[0], content="10")

  // Convert to dynamic array
  let dynamic = fixed.to_array()
  inspect(dynamic, content="[10, 20, 0, 0, 0]")
}
```

### bytes - Byte Array Operations

The bytes package provides byte array (Bytes) and byte view (BytesView) operations.

```moonbit
///|
test "Bytes operations" {
  // Create byte arrays
  let b1 : Bytes = b"hello"
  let b2 : Bytes = [0x48, 0x65, 0x6c, 0x6c, 0x6f] // "Hello"

  // Byte access
  inspect(b1[0], content="104") // 'h'
  inspect(b1.length(), content="5")

  // Conversion
  let s = String::from_bytes(b1)
  inspect(s, content="hello")

  // Byte view
  let view = b1[1:4] // "ell"
  inspect(view.length(), content="3")
}
```

## Data Structures

### hashmap - Hash Map

hashmap provides a mutable hash map based on Robin Hood hash table.

#### Basic Operations

```moonbit
///|
test "HashMap basic operations" {
  let map : @hashmap.HashMap[String, Int] = @hashmap.new()

  // Set and get
  map.set("apple", 5)
  map.set("banana", 3)
  map.set("orange", 8)

  inspect(map.get("apple"), content="Some(5)")
  inspect(map.get("grape"), content="None")
  inspect(map.get_or_default("grape", 0), content="0")

  // Check existence
  inspect(map.contains("banana"), content="true")
  inspect(map.contains("grape"), content="false")

  // Size
  inspect(map.length(), content="3")
  inspect(map.is_empty(), content="false")
}
```

#### Advanced Operations

```moonbit
///|
test "HashMap advanced operations" {
  let map = @hashmap.of([("a", 1), ("b", 2), ("c", 3)])

  // Remove
  map.remove("b")
  inspect(map.contains("b"), content="false")

  // Iteration
  let keys = []
  let values = []
  map.each(fn(k, v) {
    keys.push(k)
    values.push(v)
  })

  // Convert to array
  let pairs = map.to_array()
  inspect(pairs.length(), content="2")

  // Clear
  map.clear()
  inspect(map.is_empty(), content="true")
}
```

### list - Linked List

The list package provides immutable linked list data structure.

```moonbit
///|
test "List operations" {
  // Create linked list
  let list1 = @list.of([1, 2, 3, 4, 5])
  let list2 = @list.Cons(0, list1) // Prepend element

  // Basic operations
  inspect(list1.length(), content="5")
  inspect(list1.head(), content="Some(1)")
  inspect(list1.tail().unwrap().head(), content="Some(2)")

  // Functional operations
  let doubled = list1.map(x => x * 2)
  inspect(doubled.to_array(), content="[2, 4, 6, 8, 10]")

  let evens = list1.filter(x => x % 2 == 0)
  inspect(evens.to_array(), content="[2, 4]")

  let sum = list1.fold(init=0, (acc, x) => acc + x)
  inspect(sum, content="15")
}
```

### deque - Double-ended Queue

```moonbit
///|
test "Deque operations" {
  let dq = @deque.new()

  // Front operations
  dq.push_front(2)
  dq.push_front(1)

  // Back operations
  dq.push_back(3)
  dq.push_back(4)

  inspect(dq.length(), content="4")
  inspect(dq.front(), content="Some(1)")
  inspect(dq.back(), content="Some(4)")

  // Pop operations
  inspect(dq.pop_front(), content="Some(1)")
  inspect(dq.pop_back(), content="Some(4)")
  inspect(dq.length(), content="2")
}
```

### queue - Queue

```moonbit
///|
test "Queue operations" {
  let q = @queue.new()

  // Enqueue
  q.push(1)
  q.push(2)
  q.push(3)

  inspect(q.length(), content="3")
  inspect(q.peek(), content="Some(1)")

  // Dequeue
  inspect(q.pop(), content="Some(1)")
  inspect(q.pop(), content="Some(2)")
  inspect(q.length(), content="1")
}
```

### priority_queue - Priority Queue

```moonbit
///|
test "PriorityQueue operations" {
  let pq = @priority_queue.new()

  // Insert elements (default max heap)
  pq.push(3)
  pq.push(1)
  pq.push(4)
  pq.push(2)

  inspect(pq.length(), content="4")
  inspect(pq.peek(), content="Some(4)") // Maximum value

  // Pop elements
  inspect(pq.pop(), content="Some(4)")
  inspect(pq.pop(), content="Some(3)")
  inspect(pq.length(), content="2")
}
```

### set - Set and sorted_set - Sorted Set

```moonbit
///|
test "Set operations" {
  let set1 = @set.of([1, 2, 3, 4])
  let set2 = @set.of([3, 4, 5, 6])

  // Basic operations
  inspect(set1.contains(3), content="true")
  inspect(set1.size(), content="4")

  // Set operations
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
test "SortedSet operations" {
  let sorted_set = @sorted_set.new()
  sorted_set.insert(3)
  sorted_set.insert(1)
  sorted_set.insert(4)
  sorted_set.insert(2)

  // Ordered iteration
  let values = []
  sorted_set.each(fn(x) { values.push(x) })
  inspect(values, content="[1, 2, 3, 4]")

  // Range query
  let range = sorted_set.range(2, 4)
  inspect(range.to_array(), content="[2, 3]")
}
```

## Mathematical Operations

### math - Mathematical Functions

The math package provides common mathematical functions.

#### Basic Mathematical Functions

```moonbit
///|
test "basic mathematical functions" {
  // Mathematical constants
  inspect(@math.PI, content="3.141592653589793")

  // Rounding functions
  inspect(@math.round(3.7), content="4")
  inspect(@math.ceil(3.2), content="4")
  inspect(@math.floor(3.7), content="3")
  inspect(@math.trunc(-3.7), content="-3")

  // Absolute value and sign
  inspect(@math.abs(-5.0), content="5")
  inspect(@math.sign(-3.0), content="-1")
  inspect(@math.sign(0.0), content="0")
  inspect(@math.sign(3.0), content="1")
}
```

#### Exponential and Logarithmic Functions

```moonbit
///|
test "exponential and logarithmic functions" {
  // Exponential functions
  inspect(@math.exp(1.0), content="2.718281828459045")
  inspect(@math.exp2(3.0), content="8")
  inspect(@math.expm1(1.0), content="1.718281828459045")

  // Logarithmic functions
  inspect(@math.ln(@math.E), content="1")
  inspect(@math.log2(8.0), content="3")
  inspect(@math.log10(100.0), content="2")
  inspect(@math.ln_1p(0.0), content="0")
}
```

#### Trigonometric Functions

```moonbit
///|
test "trigonometric functions" {
  // Basic trigonometric functions
  inspect(@math.sin(@math.PI / 2.0), content="1")
  inspect(@math.cos(0.0), content="1")
  inspect(@math.tan(@math.PI / 4.0), content="0.9999999999999999")

  // Inverse trigonometric functions
  inspect(@math.asin(1.0), content="1.5707963267948966")
  inspect(@math.acos(1.0), content="0")
  inspect(@math.atan(1.0), content="0.7853981633974483")

  // Hyperbolic functions
  inspect(@math.sinh(0.0), content="0")
  inspect(@math.cosh(0.0), content="1")
  inspect(@math.tanh(0.0), content="0")
}
```

#### Power and Root Functions

```moonbit
///|
test "power and root functions" {
  // Power operations
  inspect(@math.pow(2.0, 3.0), content="8")
  inspect(@math.pow(9.0, 0.5), content="3")

  // Square root
  inspect(@math.sqrt(16.0), content="4")
  inspect(@math.sqrt(2.0), content="1.4142135623730951")

  // Cube root
  inspect(@math.cbrt(8.0), content="2")
  inspect(@math.cbrt(27.0), content="3")

  // Square
  inspect(@math.square(5.0), content="25")
}
```

### bigint - Big Integer

```moonbit
///|
test "BigInt operations" {
  // Create big integers
  let a = @bigint.from_string("123456789012345678901234567890")
  let b = @bigint.from_int(999999999)

  // Basic operations
  let sum = a + b
  let product = a * b

  // Comparison
  inspect(a > b, content="true")
  inspect(a.compare(b), content="1")

  // Conversion
  inspect(b.to_string(), content="999999999")
  inspect(@bigint.from_int(42).to_int(), content="Some(42)")
}
```

### rational - Rational Numbers

```moonbit
///|
test "Rational operations" {
  // Create rational numbers
  let r1 = @rational.new(3, 4)    // 3/4
  let r2 = @rational.new(1, 2)    // 1/2

  // Operations
  let sum = r1 + r2               // 3/4 + 1/2 = 5/4
  let product = r1 * r2           // 3/4 * 1/2 = 3/8

  // Conversion
  inspect(r1.to_double(), content="0.75")
  inspect(sum.to_string(), content="5/4")

  // Reduction
  let r3 = @rational.new(6, 8)    // 6/8 = 3/4
  inspect(r3.to_string(), content="3/4")
}
```

## Data Conversion

### json - JSON Processing

The json package provides complete JSON processing functionality.

#### JSON Parsing and Generation

```moonbit
///|
test "JSON parsing and generation" {
  // Validate JSON
  inspect(@json.valid("{\"key\": 42}"), content="true")
  inspect(@json.valid("invalid"), content="false")

  // Parse JSON
  let json = @json.parse("{\"name\": \"MoonBit\", \"version\": 1.0}")

  // Pretty print
  let pretty = json.stringify(indent=2)
  inspect(
    pretty,
    content="{\\n  \"name\": \"MoonBit\",\\n  \"version\": 1\\n}"
  )
}
```

#### JSON Data Access

```moonbit
///|
test "JSON data access" {
  let json = @json.parse(
    "{\"string\":\"hello\",\"number\":42,\"array\":[1,2,3],\"bool\":true}"
  )

  // Access string
  let string_val = json.value("string").unwrap().as_string()
  inspect(string_val, content="Some(\"hello\")")

  // Access number
  let number_val = json.value("number").unwrap().as_number()
  inspect(number_val, content="Some(42)")

  // Access array
  let array_val = json.value("array").unwrap().as_array()
  inspect(array_val.unwrap().length(), content="3")

  // Access boolean
  let bool_val = json.value("bool").unwrap().as_bool()
  inspect(bool_val, content="Some(true)")

  // Handle missing keys
  inspect(json.value("missing"), content="None")
}
```

#### JSON Array Operations

```moonbit
///|
test "JSON array operations" {
  let array = @json.parse("[1, 2, 3, 4, 5]")

  // Access by index
  let first = array.item(0)
  inspect(first.unwrap().as_number(), content="Some(1)")

  // Out of bounds access
  let out_of_bounds = array.item(10)
  inspect(out_of_bounds, content="None")

  // Array length
  let length = array.as_array().unwrap().length()
  inspect(length, content="5")
}
```

#### Type-safe JSON Conversion

```moonbit
///|
struct Person {
  name : String
  age : Int
  email : Option[String]
} derive(ToJson, FromJson)

test "type-safe JSON conversion" {
  let person = Person::{ name: "Alice", age: 30, email: Some("alice@example.com") }

  // Convert to JSON
  let json = person.to_json()
  let json_string = json.stringify()

  // Convert back from JSON
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

### strconv - String Conversion

The strconv package implements conversions between basic data types and strings.

#### Parsing Functions

```moonbit
///|
test "string parsing" {
  // Parse boolean
  let b = @strconv.parse_bool("true")
  inspect(b, content="true")

  // Parse integer
  let i1 = @strconv.parse_int("1234567")
  inspect(i1, content="1234567")

  // Parse with specified base
  let i2 = @strconv.parse_int("101", base=2)
  inspect(i2, content="5")

  let i3 = @strconv.parse_int("FF", base=16)
  inspect(i3, content="255")

  // Parse floating point
  let d = @strconv.parse_double("123.4567")
  inspect(d, content="123.4567")
}
```

#### Generic Parsing Functions

```moonbit
///|
test "generic parsing" {
  // Generic parsing using FromStr trait
  let a : Int = @strconv.parse("123")
  inspect(a, content="123")

  let b : Bool = @strconv.parse("false")
  inspect(b, content="false")

  let c : Double = @strconv.parse("3.14159")
  inspect(c, content="3.14159")
}
```

#### Formatting Output

```moonbit
///|
test "formatting output" {
  // Integer formatting
  inspect(@strconv.format_int(255, base=16), content="ff")
  inspect(@strconv.format_int(255, base=2), content="11111111")

  // Floating point formatting
  inspect(@strconv.format_double(3.14159, precision=2), content="3.14")
  inspect(@strconv.format_double(1234.5, scientific=true), content="1.2345e+03")
}
```

### encoding/utf8 - UTF-8 Encoding

```moonbit
///|
test "UTF-8 encoding and decoding" {
  let text = "Hello, World! 🌍"

  // Encode to byte array
  let bytes = @encoding/utf8.encode(text)
  inspect(bytes.length(), content="16")

  // Decode back to string
  let decoded = @encoding/utf8.decode(bytes)
  inspect(decoded, content="Hello, World! 🌍")

  // Validate UTF-8
  inspect(@encoding/utf8.valid(bytes), content="true")

  // Handle invalid bytes
  let invalid_bytes = b"\xFF\xFE"
  match @encoding/utf8.decode(invalid_bytes) {
    Ok(_) => panic()
    Err(_) => inspect("decoding failed", content="decoding failed")
  }
}
```

## Functional Programming

### iter - Iterators

Iterators provide powerful tools for functional programming.

#### Basic Iterator Operations

```moonbit
///|
test "basic iterator operations" {
  let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

  // Chain operations
  let result = numbers
    .iter()
    .filter(x => x % 2 == 0)    // Even numbers
    .map(x => x * x)            // Square
    .take(3)                    // Take first 3
    .collect()

  inspect(result, content="[4, 16, 36]")

  // Fold operations
  let sum = numbers.iter().fold(init=0, (acc, x) => acc + x)
  inspect(sum, content="55")

  // Find operations
  let found = numbers.iter().find(x => x > 7)
  inspect(found, content="Some(8)")
}
```

#### Advanced Iterator Operations

```moonbit
///|
test "advanced iterator operations" {
  let words = ["apple", "banana", "cherry", "date"]

  // Enumerate
  let enumerated = words.iter().enumerate().collect()
  inspect(enumerated, content="[(0, \"apple\"), (1, \"banana\"), (2, \"cherry\"), (3, \"date\")]")

  // Group by
  let grouped = words.iter().group_by(w => w.length()).collect()
  // Group by length

  // Zip
  let numbers = [1, 2, 3, 4]
  let zipped = words.iter().zip(numbers.iter()).collect()
  inspect(zipped, content="[(\"apple\", 1), (\"banana\", 2), (\"cherry\", 3), (\"date\", 4)]")
}
```

#### Infinite Iterators

```moonbit
///|
test "infinite iterators" {
  // Generate Fibonacci sequence
  let fib = @iter.unfold((0, 1), fn((a, b)) {
    Some((a, (b, a + b)))
  })

  let first_10_fib = fib.take(10).collect()
  inspect(first_10_fib, content="[0, 1, 1, 2, 3, 5, 8, 13, 21, 34]")

  // Repeat elements
  let repeated = @iter.repeat(42).take(5).collect()
  inspect(repeated, content="[42, 42, 42, 42, 42]")

  // Range
  let range = @iter.range(1, 6).collect()
  inspect(range, content="[1, 2, 3, 4, 5]")
}
```

## Utilities

### random - Random Number Generation

```moonbit
///|
test "random number generation" {
  let rng = @random.new()

  // Generate random integer
  let random_int = rng.int()
  let bounded_int = rng.int_range(1, 100) // 1-99

  // Generate random floating point
  let random_double = rng.double() // 0.0-1.0
  let bounded_double = rng.double_range(0.0, 10.0)

  // Generate random boolean
  let random_bool = rng.bool()

  // Random choice from array
  let choices = ["red", "green", "blue"]
  let random_choice = rng.choose(choices)

  // Shuffle array
  let numbers = [1, 2, 3, 4, 5]
  rng.shuffle(numbers)
  // numbers is now randomly shuffled
}
```

### ref - Reference Types

```moonbit
///|
test "reference types" {
  // Create mutable reference
  let counter = @ref.new(0)

  // Read value
  inspect(counter.val, content="0")

  // Modify value
  counter.val = 42
  inspect(counter.val, content="42")

  // Atomic operations
  let old_value = counter.swap(100)
  inspect(old_value, content="42")
  inspect(counter.val, content="100")

  // Compare and swap
  let success = counter.compare_and_swap(100, 200)
  inspect(success, content="true")
  inspect(counter.val, content="200")
}
```

### quickcheck - Property Testing

```moonbit
///|
test "property testing" {
  // Test list reversal property
  @quickcheck.test(
    "reverse twice equals original",
    fn(list : Array[Int]) {
      let reversed_twice = list.copy()
      reversed_twice.reverse()
      reversed_twice.reverse()
      reversed_twice == list
    }
  )

  // Test addition commutativity
  @quickcheck.test(
    "addition is commutative",
    fn(a : Int, b : Int) {
      a + b == b + a
    }
  )

  // Test string length
  @quickcheck.test(
    "string concatenation length",
    fn(s1 : String, s2 : String) {
      (s1 + s2).length() == s1.length() + s2.length()
    }
  )
}
```

## Numeric Types

### Integer Types

MoonBit Core provides multiple integer types:

```moonbit
///|
test "integer types" {
  // Basic integer types
  let i : Int = 42
  let u : UInt = 42U

  // 64-bit integers
  let i64 : Int64 = 42L
  let u64 : UInt64 = 42UL

  // 16-bit integers
  let i16 : Int16 = 42S
  let u16 : UInt16 = 42US

  // Byte type
  let b : Byte = b'A'

  // Type conversion
  inspect(i.to_int64(), content="42L")
  inspect(i64.to_int(), content="42")
  inspect(b.to_int(), content="65")
}
```

### Floating Point Types

```moonbit
///|
test "floating point types" {
  let f : Float = 3.14
  let d : Double = 3.14159265359

  // Special values
  inspect(Double::infinity(), content="inf")
  inspect(Double::neg_infinity(), content="-inf")
  inspect(Double::nan().is_nan(), content="true")

  // Precision comparison
  let a = 0.1 + 0.2
  let b = 0.3
  inspect(@math.abs(a - b) < 1e-10, content="true")
}
```

## Error Handling and Debugging

### Error Handling Patterns

```moonbit
///|
suberror MyError {
  InvalidInput(String)
  NetworkError(Int)
  ParseError
}

fn risky_operation(input : String) -> String raise MyError {
  if input.is_empty() {
    raise MyError::InvalidInput("input cannot be empty")
  }
  if input.contains("error") {
    raise MyError::ParseError
  }
  "processing successful: " + input
}

test "error handling" {
  // Use try? to convert to Result
  let result1 = try? risky_operation("hello")
  inspect(result1, content="Ok(\"processing successful: hello\")")

  let result2 = try? risky_operation("")
  match result2 {
    Ok(_) => panic()
    Err(MyError::InvalidInput(msg)) => inspect(msg, content="input cannot be empty")
    Err(_) => panic()
  }

  // Use try-catch to handle
  let result3 = risky_operation("error") catch {
    MyError::ParseError => "parse error"
    MyError::InvalidInput(msg) => "input error: " + msg
    MyError::NetworkError(code) => "network error: " + code.to_string()
  }
  inspect(result3, content="parse error")
}
```

### Debugging and Logging

```moonbit
///|
test "debugging tools" {
  let data = [1, 2, 3, 4, 5]

  // Use inspect for debugging
  inspect(data, content="[1, 2, 3, 4, 5]")

  // Use @json.inspect for complex structures
  let complex_data = {
    "name": "MoonBit",
    "version": 1.0,
    "features": ["fast", "safe", "simple"]
  }
  @json.inspect(complex_data, content="{\"name\": \"MoonBit\", \"version\": 1, \"features\": [\"fast\", \"safe\", \"simple\"]}")

  // Conditional debugging
  let debug = true
  if debug {
    println("debug info: data length is \{data.length()}")
  }
}
```

## Performance Optimization and Best Practices

### Memory Management

```moonbit
///|
test "memory optimization" {
  // Use StringBuilder instead of string concatenation
  let sb = StringBuilder::new()
  for i in 0..<1000 {
    sb.write_string("item \{i}\n")
  }
  let result = sb.to_string()

  // Use ArrayView to avoid copying
  let large_array = Array::makei(10000, i => i)
  let view = large_array[100:200] // No data copy

  // Pre-allocate capacity
  let optimized_array = Array::with_capacity(1000)
  for i in 0..<1000 {
    optimized_array.push(i)
  }
}
```

### Functional Programming Optimization

```moonbit
///|
test "functional optimization" {
  let data = Array::makei(10000, i => i)

  // Use iterator chain operations (lazy evaluation)
  let result = data
    .iter()
    .filter(x => x % 2 == 0)
    .map(x => x * x)
    .take(100)
    .collect()

  // Avoid intermediate collections
  let sum = data
    .iter()
    .filter(x => x % 3 == 0)
    .fold(init=0, (acc, x) => acc + x)

  inspect(result.length(), content="100")
}
```

### Concurrent Programming Patterns

```moonbit
///|
test "concurrent patterns" {
  // Use Ref for thread-safe state management
  let shared_counter = @ref.new(0)

  // Atomic operations
  let old_value = shared_counter.swap(10)
  let success = shared_counter.compare_and_swap(10, 20)

  // Use queue for task distribution
  let task_queue = @queue.new()
  task_queue.push("task1")
  task_queue.push("task2")

  while not(task_queue.is_empty()) {
    match task_queue.pop() {
      Some(task) => println("processing task: \{task}")
      None => break
    }
  }
}
```

## Testing and Quality Assurance

### Unit Testing Patterns

```moonbit
///|
fn factorial(n : Int) -> Int {
  if n <= 1 { 1 } else { n * factorial(n - 1) }
}

test "factorial function test" {
  // Boundary condition tests
  inspect(factorial(0), content="1")
  inspect(factorial(1), content="1")

  // Normal case tests
  inspect(factorial(5), content="120")
  inspect(factorial(10), content="3628800")

  // Performance test
  let start_time = @time.now()
  let _ = factorial(20)
  let end_time = @time.now()
  let duration = end_time - start_time
  assert_true(duration < 1000) // Should complete within 1 second
}
```

### Integration Testing

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

test "calculator integration test" {
  let calc = Calculator::new()

  // Test chain operations
  calc.add(10.0)
  calc.multiply(2.0)
  calc.add(5.0)

  inspect(calc.get_result(), content="25")

  // Test reset
  calc.value = 0.0
  calc.add(1.0)
  inspect(calc.get_result(), content="1")
}
```

## Common Use Cases and Patterns

### Configuration Management

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

test "configuration management" {
  let config_json = "{\"host\": \"localhost\", \"port\": 8080, \"debug\": true, \"max_connections\": 100}"

  let config = load_config(config_json)
  inspect(config.host, content="localhost")
  inspect(config.port, content="8080")
  inspect(config.debug, content="true")
  inspect(config.max_connections, content="100")
}
```

### Data Processing Pipeline

```moonbit
///|
struct User {
  id : Int
  name : String
  age : Int
  active : Bool
} derive(Show)

test "data processing pipeline" {
  let users = [
    { id: 1, name: "Alice", age: 25, active: true },
    { id: 2, name: "Bob", age: 30, active: false },
    { id: 3, name: "Charlie", age: 35, active: true },
    { id: 4, name: "Diana", age: 28, active: true }
  ]

  // Data processing pipeline
  let active_adults = users
    .iter()
    .filter(user => user.active)
    .filter(user => user.age >= 25)
    .map(user => user.name)
    .collect()

  inspect(active_adults, content="[\"Alice\", \"Charlie\", \"Diana\"]")

  // Statistics
  let avg_age = users
    .iter()
    .filter(user => user.active)
    .map(user => user.age)
    .fold(init=0, (sum, age) => sum + age) /
    users.iter().filter(user => user.active).count()

  inspect(avg_age, content="29")
}
```

### Cache Implementation

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
    // Simple LRU strategy: remove first element
    let first_key = self.data.to_array()[0].0
    self.data.remove(first_key)
  }
  self.data.set(key, value)
}

test "cache implementation" {
  let cache = Cache::new(2)

  cache.put("key1", "value1")
  cache.put("key2", "value2")

  inspect(cache.get("key1"), content="Some(\"value1\")")
  inspect(cache.get("key2"), content="Some(\"value2\")")

  // Exceed capacity
  cache.put("key3", "value3")
  inspect(cache.data.length(), content="2")
}
```

## Summary

The MoonBit Core standard library provides a rich and complete set of functionality covering all aspects needed for modern programming languages:

### Core Advantages

1. **Type Safety**: Strong type system ensures program correctness
2. **Functional Programming**: Support for immutable data structures and functional programming patterns
3. **Performance Optimization**: Efficient data structure and algorithm implementations
4. **Error Handling**: Complete error handling mechanisms with structured exceptions
5. **Testing Support**: Built-in testing framework and property testing tools

### Best Practices

1. **Prefer immutable data structures**, use mutable versions only when needed
2. **Utilize iterator chain operations** for data processing
3. **Use Result and Option types** for error handling
4. **Write comprehensive tests**, including unit tests and property tests
5. **Use type inference reasonably**, provide type annotations when needed

### Learning Path

1. Start with basic types (String, Array, Option, Result)
2. Master data structure usage (HashMap, List, Set)
3. Learn functional programming patterns (Iterator, higher-order functions)
4. Understand JSON processing and data conversion
5. Dive into mathematical computation and advanced data structures
6. Master error handling and testing techniques

MoonBit Core provides developers with all the tools needed to build high-quality, high-performance applications. By properly using these features, you can write concise, safe, and efficient MoonBit programs.

