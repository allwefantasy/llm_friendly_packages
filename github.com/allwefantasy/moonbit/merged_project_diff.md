# MoonBit 项目：diff

项目路径：`next/sources/diff`

生成时间：2025-06-05 21:14:15

## 项目目录结构

```
diff/
├── .mooncakes
├── src
│   ├── part1
│   │   ├── bparray.mbt
│   │   ├── diff.mbt
│   │   ├── line.mbt
│   │   └── moon.pkg.json
│   ├── part2
│   │   ├── bparray.mbt
│   │   ├── diff.mbt
│   │   ├── edit.mbt
│   │   ├── line.mbt
│   │   └── moon.pkg.json
│   └── part3
│       ├── bparray.mbt
│       ├── diff.mbt
│       ├── edit.mbt
│       ├── line.mbt
│       └── moon.pkg.json
├── target
│   ├── wasm-gc
│   │   └── release
│   │       └── check
│   │           ├── part1
│   │           │   └── part1.mi
│   │           ├── part2
│   │           │   └── part2.mi
│   │           ├── part3
│   │           │   └── part3.mi
│   │           ├── .moon-lock
│   │           ├── check.moon_db
│   │           ├── check.output
│   │           └── moon.db
│   ├── .moon-lock
│   └── packages.json
├── .gitignore
├── LICENSE
├── moon.mod.json
└── README.md
```

## 文件统计

- 总文件数：17
- 文档文件：1 个
- 代码文件：15 个
- 文本文件：1 个

## 文档文件

### 文件：`README.md`

```markdown
# moonbit-community/diff
```

---

## 代码文件

### 文件：`moon.mod.json`

```json
{
  "name": "moonbit-community/diff",
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

### 文件：`src/part1/bparray.mbt`

```moonbit
///| start bparray definition
///
type BPArray[T] Array[T] // BiPolar Array

///|
fn[T] BPArray::make(capacity : Int, default : T) -> BPArray[T] {
  let arr = Array::make(capacity, default)
  BPArray(arr)
}

///|
fn copy(self : BPArray[Int]) -> BPArray[Int] {
  let BPArray(arr) = self
  let newarr = Array::make(arr.length(), 0)
  for i = 0; i < arr.length(); i = i + 1 {
    newarr[i] = arr[i]
  } else {
    BPArray(newarr)
  }
}

///|
fn[T] op_get(self : BPArray[T], idx : Int) -> T {
  let BPArray(arr) = self
  if idx < 0 {
    arr[arr.length() + idx]
  } else {
    arr[idx]
  }
}

///|
fn[T] op_set(self : BPArray[T], idx : Int, elem : T) -> Unit {
  let BPArray(arr) = self
  if idx < 0 {
    arr[arr.length() + idx] = elem
  } else {
    arr[idx] = elem
  }
}
// end bparray definition

///|
test "bparray" {
  let foo = BPArray::make(10, "foo")
  foo[9] = "bar"
  foo[8] = "baz"
  assert_eq(foo[-1], "bar")
  assert_eq(foo[-2], "baz")
}
```

---

### 文件：`src/part1/diff.mbt`

```moonbit
///| start shortest_edit definition
///
fn shortest_edit(old~ : Array[Line], new~ : Array[Line]) -> Int {
  let n = old.length()
  let m = new.length()
  let max = n + m
  let v = BPArray::make(2 * max + 1, 0)
  // v[1] = 0
  for d = 0; d < max + 1; d = d + 1 {
    for k = -d; k < d + 1; k = k + 2 {
      let mut x = 0
      let mut y = 0
      // if d == 0 {
      //   x = 0
      // }
      if k == -d || (k != d && v[k - 1] < v[k + 1]) {
        x = v[k + 1]
      } else {
        x = v[k - 1] + 1
      }
      y = x - k
      while x < n && y < m && old[x].text == new[y].text {
        // Skip all matching lines
        x = x + 1
        y = y + 1
      }
      v[k] = x
      if x >= n && y >= m {
        return d
      }
    }
  } else {
    abort("impossible")
  }
}
// end shortest_edit definition

///|
test "shortest_edit" {
  let old = lines("aaa\naaa\naaa")
  let new = lines("bbb\nbbb\nbbb")
  inspect(shortest_edit(old~, new~), content="6")
  let old = lines("A\nB\nC\nA\nB\nB\nA")
  let new = lines("C\nB\nA\nB\nA\nC")
  inspect(shortest_edit(old~, new~), content="5")
}
```

---

### 文件：`src/part1/line.mbt`

```moonbit
///| start line definition
///
struct Line {
  number : Int // Line number
  text : String // Does not include newline
} derive(Show, ToJson)

///|
fn Line::new(number : Int, text : String) -> Line {
  Line::{ number, text }
}
// end line definition

///| start lines definition
///
fn lines(str : String) -> Array[Line] {
  let lines = Array::new(capacity=50)
  let mut line_number = 0
  for line in str.split("\n") {
    line_number = line_number + 1
    lines.push(Line::new(line_number, line.to_string()))
  } else {
    return lines
  }
}
// end lines definition

///|
test "lines" {
  @json.inspect(
    lines(""),
    content=
      [{"number":1,"text":""}]
    ,
  )
  @json.inspect(
    lines("\n"),
    content=
      [{"number":1,"text":""},{"number":2,"text":""}]
    ,
  )
  @json.inspect(
    lines("aaa"),
    content=
      [{"number":1,"text":"aaa"}]
    ,
  )
  @json.inspect(
    lines("aaa\nbbb"),
    content=
      [{"number":1,"text":"aaa"},{"number":2,"text":"bbb"}]
    ,
  )
}
```

---

### 文件：`src/part1/moon.pkg.json`

```json
{
    "warn-list": "-4"
}
```

---

### 文件：`src/part2/bparray.mbt`

```moonbit
///|
type BPArray[T] Array[T] // BiPolar Array

///|
fn[T] BPArray::make(capacity : Int, default : T) -> BPArray[T] {
  let arr = Array::make(capacity, default)
  BPArray(arr)
}

///|
fn copy(self : BPArray[Int]) -> BPArray[Int] {
  let BPArray(arr) = self
  let newarr = Array::make(arr.length(), 0)
  for i = 0; i < arr.length(); i = i + 1 {
    newarr[i] = arr[i]
  } else {
    BPArray(newarr)
  }
}

///|
fn[T] op_get(self : BPArray[T], idx : Int) -> T {
  let BPArray(arr) = self
  if idx < 0 {
    arr[arr.length() + idx]
  } else {
    arr[idx]
  }
}

///|
fn[T] op_set(self : BPArray[T], idx : Int, elem : T) -> Unit {
  let BPArray(arr) = self
  if idx < 0 {
    arr[arr.length() + idx] = elem
  } else {
    arr[idx] = elem
  }
}

///|
test "bparray" {
  let foo = BPArray::make(10, "foo")
  foo[9] = "bar"
  foo[8] = "baz"
  assert_eq(foo[-1], "bar")
  assert_eq(foo[-2], "baz")
}
```

---

### 文件：`src/part2/diff.mbt`

```moonbit
///| start shortest_edit definition
///
fn shortest_edit(
  old~ : Array[Line],
  new~ : Array[Line]
) -> Array[(BPArray[Int], Int)] {
  let n = old.length()
  let m = new.length()
  let max = n + m
  let v = BPArray::make(2 * max + 1, 0)
  let trace = []
  fn push(v : BPArray[Int], d : Int) -> Unit {
    trace.push((v, d))
  }
  // v[1] = 0
  for d = 0; d < max + 1; d = d + 1 {
    push(v.copy(), d)
    for k = -d; k < d + 1; k = k + 2 {
      let mut x = 0
      let mut y = 0
      // if d == 0 {
      //   x = 0
      // }
      if k == -d || (k != d && v[k - 1] < v[k + 1]) {
        x = v[k + 1]
      } else {
        x = v[k - 1] + 1
      }
      y = x - k
      while x < n && y < m && old[x].text == new[y].text {
        x = x + 1
        y = y + 1
      }
      v[k] = x
      if x >= n && y >= m {
        return trace
      }
    }
  } else {
    abort("impossible")
  }
}
// end shortest_edit definition

///| start backtrack_fst definition
///
fn backtrack(
  new~ : Array[Line],
  old~ : Array[Line],
  trace : Array[(BPArray[Int], Int)]
) -> Array[Edit] {
  let mut x = old.length()
  let mut y = new.length()
  let edits = Array::new(capacity=trace.length())
  // end backtrack_fst definition
  // start backtrack_snd definition
  for i = trace.length() - 1; i >= 0; i = i - 1 {
    let (v, d) = trace[i]
    let k = x - y
    let prev_k = if k == -d || (k != d && v[k - 1] < v[k + 1]) {
      k + 1
    } else {
      k - 1
    }
    let prev_x = v[prev_k]
    let prev_y = prev_x - prev_k
    while x > prev_x && y > prev_y {
      x = x - 1
      y = y - 1
      edits.push(Equal(old=old[x], new=new[y]))
    }
    if d > 0 {
      if x == prev_x {
        edits.push(Insert(new=new[prev_y]))
      } else if y == prev_y {
        edits.push(Delete(old=old[prev_x]))
      }
      x = prev_x
      y = prev_y
    }
  }
  // end backtrack_snd definition
  return edits
}

///| start diff definition
///
fn diff(old~ : Array[Line], new~ : Array[Line]) -> Array[Edit] {
  let trace = shortest_edit(old~, new~)
  backtrack(old~, new~, trace)
}
// end diff definition

///|
test "myers diff" {
  let old = lines("A\nB\nC\nA\nB\nB\nA")
  let new = lines("C\nB\nA\nB\nA\nC")
  inspect(
    pprint_diff(diff(old~, new~)),
    content=
      #|-    1         A
      #|-    2         B
      #|     3    1    C
      #|+         2    B
      #|     4    3    A
      #|     5    4    B
      #|-    6         B
      #|     7    5    A
      #|+         6    C
      #|
    ,
  )
}
```

---

### 文件：`src/part2/edit.mbt`

```moonbit
///| start edit definition
///
enum Edit {
  Insert(new~ : Line)
  Delete(old~ : Line)
  Equal(old~ : Line, new~ : Line) // old, new
} derive(Show)
// end edit definition

///| start pprint definition
///
let line_width = 4

///|
fn pad_right(s : String, width : Int) -> String {
  String::make(width - s.length(), ' ') + s
}

///|
fn pprint_edit(edit : Edit) -> String {
  match edit {
    Insert(_) as edit => {
      let tag = "+"
      let old_line = pad_right("", line_width)
      let new_line = pad_right(edit.new.number.to_string(), line_width)
      let text = edit.new.text
      "\{tag} \{old_line} \{new_line}    \{text}"
    }
    Delete(_) as edit => {
      let tag = "-"
      let old_line = pad_right(edit.old.number.to_string(), line_width)
      let new_line = pad_right("", line_width)
      let text = edit.old.text
      "\{tag} \{old_line} \{new_line}    \{text}"
    }
    Equal(_) as edit => {
      let tag = " "
      let old_line = pad_right(edit.old.number.to_string(), line_width)
      let new_line = pad_right(edit.new.number.to_string(), line_width)
      let text = edit.old.text
      "\{tag} \{old_line} \{new_line}    \{text}"
    }
  }
}

///|
fn pprint_diff(diff : Array[Edit]) -> String {
  let buf = @buffer.new(size_hint=100)
  for i = diff.length(); i > 0; i = i - 1 {
    buf.write_string(pprint_edit(diff[i - 1]))
    buf.write_char('\n')
  } else {
    buf.contents().to_unchecked_string()
  }
}
// end pprint definition
```

---

### 文件：`src/part2/line.mbt`

```moonbit
///|
struct Line {
  number : Int // Line number
  text : String // Does not include newline
} derive(Show, ToJson)

///|
fn Line::new(number : Int, text : String) -> Line {
  Line::{ number, text }
}

///|
fn lines(str : String) -> Array[Line] {
  let lines = Array::new(capacity=50)
  let mut line_number = 0
  for line in str.split("\n") {
    line_number = line_number + 1
    lines.push(Line::new(line_number, line.to_string()))
  } else {
    return lines
  }
}

///|
test "lines" {
  @json.inspect(
    lines(""),
    content=
      [{"number":1,"text":""}]
    ,
  )
  @json.inspect(
    lines("\n"),
    content=
      [{"number":1,"text":""},{"number":2,"text":""}]
    ,
  )
  @json.inspect(
    lines("aaa"),
    content=
      [{"number":1,"text":"aaa"}]
    ,
  )
  @json.inspect(
    lines("aaa\nbbb"),
    content=
      [{"number":1,"text":"aaa"},{"number":2,"text":"bbb"}]
    ,
  )
}
```

---

### 文件：`src/part2/moon.pkg.json`

```json
{
    "warn-list": "-4"
}
```

---

### 文件：`src/part3/bparray.mbt`

```moonbit
///|
type BPArray[T] Array[T] // BiPolar Array

///|
fn[T] BPArray::make(capacity : Int, default : T) -> BPArray[T] {
  let arr = Array::make(capacity, default)
  BPArray(arr)
}

///|
fn BPArray::copy(self : Self[Int]) -> Self[Int] {
  let BPArray(arr) = self
  let newarr = Array::make(arr.length(), 0)
  for i = 0; i < arr.length(); i = i + 1 {
    newarr[i] = arr[i]
  } else {
    BPArray(newarr)
  }
}

///|
fn[T] BPArray::op_get(self : Self[T], idx : Int) -> T {
  let BPArray(arr) = self
  if idx < 0 {
    arr[arr.length() + idx]
  } else {
    arr[idx]
  }
}

///|
fn[T] BPArray::op_set(self : Self[T], idx : Int, elem : T) -> Unit {
  let BPArray(arr) = self
  if idx < 0 {
    arr[arr.length() + idx] = elem
  } else {
    arr[idx] = elem
  }
}

///|
test "bparray" {
  let foo = BPArray::make(10, "foo")
  foo[9] = "bar"
  foo[8] = "baz"
  assert_eq(foo[-1], "bar")
  assert_eq(foo[-2], "baz")
}
```

---

### 文件：`src/part3/diff.mbt`

```moonbit
///| start box definition
///
struct Box {
  left : Int
  right : Int
  top : Int
  bottom : Int
} derive(Show)

///|
struct Snake {
  start : (Int, Int)
  end : (Int, Int)
} derive(Show)

///|
fn Box::width(self : Self) -> Int {
  self.right - self.left
}

///|
fn Box::height(self : Self) -> Int {
  self.bottom - self.top
}

///|
fn Box::size(self : Self) -> Int {
  self.width() + self.height()
}

///|
fn Box::delta(self : Self) -> Int {
  self.width() - self.height()
}

// end box definition
///|
fn is_odd(n : Int) -> Bool {
  (n & 1) == 1
}

///|
fn is_even(n : Int) -> Bool {
  (n & 1) == 0
}

// start search definition
///|
fn Box::forward(
  self : Self,
  forward~ : BPArray[Int],
  backward~ : BPArray[Int],
  depth : Int,
  old~ : Array[Line],
  new~ : Array[Line]
) -> Snake? {
  for k = depth; k >= -depth; k = k - 2 {
    let c = k - self.delta()
    let mut x = 0
    let mut px = 0
    if k == -depth || (k != depth && forward[k - 1] < forward[k + 1]) {
      x = forward[k + 1]
      px = x
    } else {
      px = forward[k - 1]
      x = px + 1
    }
    let mut y = self.top + (x - self.left) - k
    let py = if depth == 0 || x != px { y } else { y - 1 }
    while x < self.right && y < self.bottom && old[x].text == new[y].text {
      x = x + 1
      y = y + 1
    }
    forward[k] = x
    if is_odd(self.delta()) &&
      (c >= -(depth - 1) && c <= depth - 1) &&
      y >= backward[c] {
      return Some(Snake::{ start: (px, py), end: (x, y) })
    }
  }
  return None
}

///|
fn Box::backward(
  self : Self,
  forward~ : BPArray[Int],
  backward~ : BPArray[Int],
  depth : Int,
  old~ : Array[Line],
  new~ : Array[Line]
) -> Snake? {
  for c = depth; c >= -depth; c = c - 2 {
    let k = c + self.delta()
    let mut y = 0
    let mut py = 0
    if c == -depth || (c != depth && backward[c - 1] > backward[c + 1]) {
      y = backward[c + 1]
      py = y
    } else {
      py = backward[c - 1]
      y = py - 1
    }
    let mut x = self.left + (y - self.top) + k
    let px = if depth == 0 || y != py { x } else { x + 1 }
    while x > self.left && y > self.top && old[x - 1].text == new[y - 1].text {
      x = x - 1
      y = y - 1
    }
    backward[c] = y
    if is_even(self.delta()) && (k >= -depth && k <= depth) && x <= forward[k] {
      return Some(Snake::{ start: (x, y), end: (px, py) })
    }
  }
  return None
}
// end search definition

// start midpoint definition
///|
fn Box::midpoint(self : Self, old~ : Array[Line], new~ : Array[Line]) -> Snake? {
  if self.size() == 0 {
    return None
  }
  let max = {
    let half = self.size() / 2
    if is_odd(self.size()) {
      half + 1
    } else {
      half
    }
  }
  let vf = BPArray::make(2 * max + 1, 0)
  vf[1] = self.left
  let vb = BPArray::make(2 * max + 1, 0)
  vb[1] = self.bottom
  for d = 0; d < max + 1; d = d + 1 {
    match self.forward(forward=vf, backward=vb, d, old~, new~) {
      None =>
        match self.backward(forward=vf, backward=vb, d, old~, new~) {
          None => continue
          res => return res
        }
      res => return res
    }
  } else {
    None
  }
}
// end midpoint definition

///| start findpath definition
///
fn Box::find_path(
  box : Self,
  old~ : Array[Line],
  new~ : Array[Line]
) -> Iter[(Int, Int)]? {
  guard box.midpoint(old~, new~) is Some(snake) else { None }
  let start = snake.start
  let end = snake.end
  let headbox = Box::{
    left: box.left,
    top: box.top,
    right: start.0,
    bottom: start.1,
  }
  let tailbox = Box::{
    left: end.0,
    top: end.1,
    right: box.right,
    bottom: box.bottom,
  }
  let head = headbox.find_path(old~, new~).or(Iter::singleton(start))
  let tail = tailbox.find_path(old~, new~).or(Iter::singleton(end))
  Some(head.concat(tail))
}
// end findpath definition

///|
fn linear_diff(old~ : Array[Line], new~ : Array[Line]) -> Array[Edit]? {
  let initial_box = Box::{
    left: 0,
    top: 0,
    right: old.length(),
    bottom: new.length(),
  }
  guard initial_box.find_path(old~, new~) is Some(path) else { None }
  // path length >= 2
  let xy = path.take(1).collect()[0] // (0, 0)
  let mut x1 = xy.0
  let mut y1 = xy.1
  let edits = Array::new(capacity=old.length() + new.length())
  path
  .drop(1)
  .each(fn(xy) {
    let x2 = xy.0
    let y2 = xy.1
    while x1 < x2 && y1 < y2 && old[x1].text == new[y1].text {
      edits.push(Equal(old=old[x1], new=new[y1]))
      x1 = x1 + 1
      y1 = y1 + 1
    }
    if x2 - x1 < y2 - y1 {
      edits.push(Insert(new=new[y1]))
      y1 += 1
    }
    if x2 - x1 > y2 - y1 {
      edits.push(Delete(old=old[x1]))
      x1 += 1
    }
    while x1 < x2 && y1 < y2 && old[x1].text == new[y1].text {
      edits.push(Equal(old=old[x1], new=new[y1]))
      x1 = x1 + 1
      y1 = y1 + 1
    }
    x1 = x2
    y1 = y2
  })
  return Some(edits)
}

///|
test "myers diff" {
  let old = lines("A\nB\nC\nA\nB\nB\nA")
  let new = lines("C\nB\nA\nB\nA\nC")
  let r = linear_diff(old~, new~).unwrap()
  inspect(
    pprint_diff(r),
    content=
      #|-    1         A
      #|-    2         B
      #|     3    1    C
      #|-    4         A
      #|     5    2    B
      #|+         3    A
      #|     6    4    B
      #|     7    5    A
      #|+         6    C
      #|
    ,
  )
}
```

---

### 文件：`src/part3/edit.mbt`

```moonbit
///|
enum Edit {
  Insert(new~ : Line)
  Delete(old~ : Line)
  Equal(old~ : Line, new~ : Line) // old, new
} derive(Show)

///| start pprint definition
///
let line_width = 4

///|
fn pad_right(s : String, width : Int) -> String {
  String::make(width - s.length(), ' ') + s
}

///|
fn pprint_edit(edit : Edit) -> String {
  match edit {
    Insert(_) as edit => {
      let tag = "+"
      let old_line = pad_right("", line_width)
      let new_line = pad_right(edit.new.number.to_string(), line_width)
      let text = edit.new.text
      "\{tag} \{old_line} \{new_line}    \{text}"
    }
    Delete(_) as edit => {
      let tag = "-"
      let old_line = pad_right(edit.old.number.to_string(), line_width)
      let new_line = pad_right("", line_width)
      let text = edit.old.text
      "\{tag} \{old_line} \{new_line}    \{text}"
    }
    Equal(_) as edit => {
      let tag = " "
      let old_line = pad_right(edit.old.number.to_string(), line_width)
      let new_line = pad_right(edit.new.number.to_string(), line_width)
      let text = edit.old.text
      "\{tag} \{old_line} \{new_line}    \{text}"
    }
  }
}

///|
fn pprint_diff(diff : Array[Edit]) -> String {
  let buf = @buffer.new(size_hint=100)
  for i = 0; i < diff.length(); i = i + 1 {
    buf.write_string(pprint_edit(diff[i]))
    buf.write_char('\n')
  } else {
    buf.contents().to_unchecked_string()
  }
}
// end pprint definition
```

---

### 文件：`src/part3/line.mbt`

```moonbit
///|
struct Line {
  number : Int // Line number
  text : String // Does not include newline
} derive(Show, ToJson)

///|
fn Line::new(number : Int, text : String) -> Self {
  Line::{ number, text }
}

///|
fn lines(str : String) -> Array[Line] {
  let lines = Array::new(capacity=50)
  let mut line_number = 0
  for line in str.split("\n") {
    line_number = line_number + 1
    lines.push(Line::new(line_number, line.to_string()))
  } else {
    return lines
  }
}

///|
test "lines" {
  @json.inspect(
    lines(""),
    content=
      [{"number":1,"text":""}]
    ,
  )
  @json.inspect(
    lines("\n"),
    content=
      [{"number":1,"text":""},{"number":2,"text":""}]
    ,
  )
  @json.inspect(
    lines("aaa"),
    content=
      [{"number":1,"text":"aaa"}]
    ,
  )
  @json.inspect(
    lines("aaa\nbbb"),
    content=
      [{"number":1,"text":"aaa"},{"number":2,"text":"bbb"}]
    ,
  )
}
```

---

### 文件：`src/part3/moon.pkg.json`

```json
{
    "warn-list": "-4"
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
