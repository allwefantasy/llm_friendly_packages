# MoonBit 项目：gmachine

项目路径：`next/sources/gmachine`

生成时间：2025-06-05 21:14:15

## 项目目录结构

```
gmachine/
├── src
│   ├── lazylist
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   ├── part1
│   │   ├── ast.mbt
│   │   ├── compile.mbt
│   │   ├── instruction.mbt
│   │   ├── lazy.mbt
│   │   ├── moon.pkg.json
│   │   ├── programs.mbt
│   │   ├── syntax.mbt
│   │   ├── top.mbt
│   │   └── vm.mbt
│   ├── part2
│   │   ├── ast.mbt
│   │   ├── compile.mbt
│   │   ├── instruction.mbt
│   │   ├── moon.pkg.json
│   │   ├── programs.mbt
│   │   ├── syntax.mbt
│   │   ├── top.mbt
│   │   └── vm.mbt
│   └── part3
│       ├── ast.mbt
│       ├── compile.mbt
│       ├── instruction.mbt
│       ├── moon.pkg.json
│       ├── programs.mbt
│       ├── syntax.mbt
│       ├── top.mbt
│       └── vm.mbt
├── .gitignore
├── LICENSE
├── moon.mod.json
└── README.md
```

## 文件统计

- 总文件数：30
- 文档文件：1 个
- 代码文件：28 个
- 文本文件：1 个

## 文档文件

### 文件：`README.md`

```markdown
# G-Machine
```

---

## 代码文件

### 文件：`moon.mod.json`

```json
{
  "name": "moonbit-community/gmachine",
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

### 文件：`src/lazylist/moon.pkg.json`

```json
{
  "warn-list": "-4"
}
```

---

### 文件：`src/lazylist/top.mbt`

```moonbit
///|
typealias  @list.T as List

///| start stream definition
///
enum Stream[T] {
  Empty
  Cons(T, () -> Stream[T])
}
// end stream definition

///| start list conversion
///
fn[T] Stream::from_list(l : List[T]) -> Self[T] {
  match l {
    Empty => Empty
    More(x, tail=xs) => Cons(x, fn() { Stream::from_list(xs) })
  }
}
// end list conversion

///| start map definition
///
fn[X, Y] map(self : Stream[X], f : (X) -> Y) -> Stream[Y] {
  match self {
    Empty => Empty
    Cons(x, xs) => Cons(f(x), fn() { xs().map(f) })
  }
}
// end map definition

///| start take definition
///
fn[T] take(self : Stream[T], n : Int) -> List[T] {
  if n == 0 {
    @list.empty()
  } else {
    match self {
      Empty => @list.empty()
      Cons(x, xs) => xs().take(n - 1).add(x)
    }
  }
}
// end take definition
```

---

### 文件：`src/part1/ast.mbt`

```moonbit
typealias List[E] = @immut/list.T[E]

// start expr_and_scdef definition
enum RawExpr[T] {
  Var(T)
  Num(Int)
  Constructor(tag~ : Int, arity~ : Int) // tag, arity
  App(RawExpr[T], RawExpr[T])
  Let(Bool, List[(T, RawExpr[T])], RawExpr[T]) // isRec, Defs, Body
  Case(RawExpr[T], List[(Int, List[T], RawExpr[T])])
} derive(Show)

struct ScDef[T] {
  name : String
  args : List[T]
  body : RawExpr[T]
} derive(Show)
// end expr_and_scdef definition

fn[T] is_atom(self : RawExpr[T]) -> Bool {
  match self {
    Var(_) => true
    Num(_) => true
    _ => false
  }
}

fn[T] ScDef::new(name : String, args : List[T], body : RawExpr[T]) -> ScDef[T] {
  { name, args, body }
}

// start prelude_defs definition
let prelude_defs : List[ScDef[String]] = {
  let args : (FixedArray[String]) -> List[String] = @immut/list.of
  let id = ScDef::new("I", args(["x"]), Var("x")) // id x = x
  let k = ScDef::new("K", args(["x", "y"]), Var("x")) // K x y = x
  let k1 = ScDef::new("K1", args(["x", "y"]), Var("y")) // K1 x y = y
  let s = ScDef::new(
    "S",
    args(["f", "g", "x"]),
    App(App(Var("f"), Var("x")), App(Var("g"), Var("x"))),
  ) // S f g x = f x (g x)
  let compose = ScDef::new(
    "compose",
    args(["f", "g", "x"]),
    App(Var("f"), App(Var("g"), Var("x"))),
  ) // compose f g x = f (g x)
  let twice = ScDef::new(
    "twice",
    args(["f"]),
    App(App(Var("compose"), Var("f")), Var("f")),
  ) // twice f = compose f f
  @immut/list.of([id, k, k1, s, compose, twice])
}
// end prelude_defs definition
```

---

### 文件：`src/part1/compile.mbt`

```moonbit
// start compile_sc definition
fn ScDef::compileSC(self : ScDef[String]) -> (String, Int, List[Instruction]) {
  let name = self.name
  let body = self.body
  let mut arity = 0
  fn gen_env(i : Int, args : List[String]) -> List[(String, Int)] {
    match args {
      Nil => {
        arity = i
        return Nil
      }
      Cons(s, ss) => Cons((s, i), gen_env(i + 1, ss))
    }
  }

  let env = gen_env(0, self.args)
  (name, arity, body.compileR(env, arity))
}
// end compile_sc definition

// start compile_r definition
fn RawExpr::compileR(
  self : RawExpr[String],
  env : List[(String, Int)],
  arity : Int
) -> List[Instruction] {
  if arity == 0 {
    self.compileC(env) + @immut/list.of([Update(arity), Unwind])
  } else {
    self.compileC(env) + @immut/list.of([Update(arity), Pop(arity), Unwind])
  }
}
// end compile_r definition

// start compile_c definition
fn RawExpr::compileC(
  self : RawExpr[String],
  env : List[(String, Int)]
) -> List[Instruction] {
  match self {
    Var(s) =>
      match env.lookup(s) {
        None => @immut/list.of([PushGlobal(s)])
        Some(n) => @immut/list.of([PushArg(n)])
      }
    Num(n) => @immut/list.of([PushInt(n)])
    App(e1, e2) =>
      e2.compileC(env) +
      e1.compileC(argOffset(1, env)) +
      @immut/list.of([MkApp])
    _ => abort("not support yet")
  }
}
// end compile_c definition

fn argOffset(n : Int, env : List[(String, Int)]) -> List[(String, Int)] {
  env.map(fn { (name, offset) => (name, offset + n) })
}
```

---

### 文件：`src/part1/instruction.mbt`

```moonbit
// start instr definition
enum Instruction {
  Unwind
  PushGlobal(String)
  PushInt(Int)
  PushArg(Int)
  MkApp
  Update(Int)
  Pop(Int)
} derive(Eq, Show)
// end instr definition
```

---

### 文件：`src/part1/lazy.mbt`

```moonbit
// start lazy definition
enum LazyData[T] {
  Waiting(() -> T)
  Done(T)
}

struct LazyRef[T] {
  mut data : LazyData[T]
}

fn[T] extract(self : LazyRef[T]) -> T {
  match self.data {
    Waiting(thunk) => {
      let value = thunk()
      self.data = Done(value) // in-place update
      value
    }
    Done(value) => value
  }
}

fn square(x : LazyRef[Int]) -> Int {
  x.extract() * x.extract()
}
// end lazy definition
```

---

### 文件：`src/part1/moon.pkg.json`

```json
{

    "warn-list": "-4-8-6"

}
```

---

### 文件：`src/part1/programs.mbt`

```moonbit
let programs : @hashmap.T[String, String] = {
  let programs = @hashmap.new(capacity=40)
  programs["square"] =
    #| (defn square[x] (mul x x))
  programs["fix"] =
    #| (defn fix[f] (letrec ([x (f x)]) x))
  programs["isNil"] =
    #| (defn isNil[x]
    #|   (case x [(Nil) 1] [(Cons n m) 0]))
  programs["tail"] =
    #| (defn tail[l] (case l [(Cons x xs) xs]))
  programs["fibs"] =
    // fibs = 0 : 1 : zipWith (+) fibs (tail fibs)
    #| (defn fibs[] (Cons 0 (Cons 1 (zipWith add fibs (tail fibs)))))
  programs["take"] =
    #| (defn take[n l]
    #|   (case l
    #|     [(Nil) Nil]
    #|     [(Cons x xs)
    #|        (if (le n 0) Nil (Cons x (take (sub n 1) xs)))]))
  programs["zipWith"] =
    #| (defn zipWith[op l1 l2]
    #|   (case l1
    #|     [(Nil) Nil]
    #|     [(Cons x xs)
    #|       (case l2
    #|         [(Nil) Nil]
    #|         [(Cons y ys) (Cons (op x y) (zipWith op xs ys))])]))
  programs["factorial"] =
    #| (defn factorial[n]
    #|   (if (eq n 0) 1 (mul n (factorial (sub n 1)))))
  programs["abs"] =
    #| (defn abs[n]
    #|   (if (lt n 0) (negate n) n))
  programs["length"] =
    #| (defn length[l]
    #|   (case l
    #|     [(Nil) 0]
    #|     [(Cons x xs) (add 1 (length xs))]))
  programs
}
```

---

### 文件：`src/part1/syntax.mbt`

```moonbit
enum Token {
  DefFn
  Let
  NIL
  CONS
  Case
  Letrec
  Open(Char) // { [ (
  Close(Char) // } ] )
  Id(String)
  Number(Int)
  EOF
} derive(Eq, Show)

fn between(this : Char, lw : Char, up : Char) -> Bool {
  this >= lw && this <= up
}

fn isDigit(this : Char) -> Bool {
  between(this, '0', '9')
}

fn isAlpha(this : Char) -> Bool {
  between(this, 'A', 'Z') || between(this, 'a', 'z')
}

fn isIdChar(this : Char) -> Bool {
  isAlpha(this) || isDigit(this) || this == '_' || this == '-'
}

fn isWhiteSpace(this : Char) -> Bool {
  this == ' ' || this == '\t' || this == '\n'
}

fn to_number(this : Char) -> Int {
  this.to_int() - 48
}

fn isOpen(this : Char) -> Bool {
  this == '(' || this == '[' || this == '{'
}

fn isClose(this : Char) -> Bool {
  this == ')' || this == ']' || this == '}'
}

struct Tokens {
  tokens : Array[Token]
  mut current : Int
} derive(Show)

fn Tokens::new(tokens : Array[Token]) -> Tokens {
  Tokens::{ tokens, current: 0 }
}

fn Tokens::peek(self : Tokens) -> Token {
  if self.current < self.tokens.length() {
    return self.tokens[self.current]
  } else {
    return EOF
  }
}

type! ParseError String

fn Tokens::next(self : Tokens, loc~ : SourceLoc = _) -> Unit {
  self.current = self.current + 1
  if self.current > self.tokens.length() {
    abort("Tokens::next(): \{loc}")
  }
}

fn Tokens::eat(self : Tokens, tok : Token, loc~ : SourceLoc = _) -> Unit!ParseError {
  let __tok = self.peek()
  // assert tok_ != EOF
  if __tok != tok {
    raise ParseError("\{loc} - Tokens::eat(): expect \{tok} but got \{__tok}")
  } else {
    self.next()
  }
}

fn tokenize(source : String) -> Tokens {
  let tokens : Array[Token] = Array::new(capacity=source.length() / 2)
  let mut current = 0
  let source = source.to_array()
  fn peek() -> Char {
    source[current]
  }

  fn next() -> Unit {
    current = current + 1
  }

  while current < source.length() {
    let ch = peek()
    if isWhiteSpace(ch) {
      next()
      continue
    } else if isDigit(ch) {
      let mut num = to_number(ch)
      next()
      while current < source.length() && isDigit(peek()) {
        num = num * 10 + to_number(peek())
        next()
      }
      tokens.push(Number(num))
      continue
    } else if isOpen(ch) {
      next()
      tokens.push(Open(ch))
      continue
    } else if isClose(ch) {
      next()
      tokens.push(Close(ch))
      continue
    } else if isAlpha(ch) {
      let identifier = @buffer.new(size_hint=42)
      identifier.write_char(ch)
      next()
      while current < source.length() && isIdChar(peek()) {
        identifier.write_char(peek())
        next()
      }
      let identifier = identifier.contents().to_unchecked_string()
      match identifier {
        "let" => tokens.push(Let)
        "letrec" => tokens.push(Letrec)
        "Nil" => tokens.push(NIL)
        "Cons" => tokens.push(CONS)
        "case" => tokens.push(Case)
        "defn" => tokens.push(DefFn)
        _ => tokens.push(Id(identifier))
      }
    } else {
      abort("error : invalid Character '\{ch}' in [\{current}]")
    }
  } else {
    return Tokens::new(tokens)
  }
}

test "tokenize" {
  inspect!(tokenize("").tokens, content="[]")
  inspect!(tokenize("12345678").tokens, content="[Number(12345678)]")
  inspect!(tokenize("1234 5678").tokens, content="[Number(1234), Number(5678)]")
  inspect!(
    tokenize("a0 a_0 a-0").tokens,
    content=
      #|[Id("a0"), Id("a_0"), Id("a-0")]
    ,
  )
  inspect!(
    tokenize("(Cons 0 (Cons 1 Nil))").tokens,
    content="[Open('('), CONS, Number(0), Open('('), CONS, Number(1), NIL, Close(')'), Close(')')]",
  )
}

fn Tokens::parse_num(self : Tokens) -> Int!ParseError {
  match self.peek() {
    Number(n) => {
      self.next()
      return n
    }
    other => raise ParseError("parse_num(): expect a number but got \{other}")
  }
}

fn Tokens::parse_var(self : Tokens) -> String!ParseError {
  match self.peek() {
    Id(s) => {
      self.next()
      return s
    }
    other => raise ParseError("parse_var(): expect a variable but got \{other}")
  }
}

fn Tokens::parse_cons(self : Tokens) -> RawExpr[String]!ParseError {
  match self.peek() {
    CONS => {
      self.next()
      let x = self.parse_expr!()
      let xs = self.parse_expr!()
      return App(App(Constructor(tag=1, arity=2), x), xs)
    }
    other => raise ParseError("parse_cons(): expect Cons but got \{other}")
  }
}

fn Tokens::parse_let(self : Tokens) -> RawExpr[String]!ParseError {
  self.eat!(Let)
  self.eat!(Open('('))
  let defs = self.parse_defs!()
  self.eat!(Close(')'))
  let exp = self.parse_expr!()
  Let(false, defs, exp)
}

fn Tokens::parse_letrec(self : Tokens) -> RawExpr[String]!ParseError {
  self.eat!(Letrec)
  self.eat!(Open('('))
  let defs = self.parse_defs!()
  self.eat!(Close(')'))
  let exp = self.parse_expr!()
  Let(true, defs, exp)
}

fn Tokens::parse_case(self : Tokens) -> RawExpr[String]!ParseError {
  self.eat!(Case)
  let exp = self.parse_expr!()
  let alts = self.parse_alts!()
  Case(exp, alts)
}

fn parse_alts(
  self : Tokens
) -> List[(Int, List[String], RawExpr[String])]!ParseError {
  let acc : List[(Int, List[String], RawExpr[String])] = Nil
  loop self.peek(), acc {
    Open('['), acc => {
      self.next()
      self.eat!(Open('('))
      let (tag, variables) = match self.peek() {
        NIL => {
          self.next()
          (0, List::Nil)
        }
        CONS => {
          self.next()
          let x = self.parse_var!()
          let xs = self.parse_var!()
          (1, @immut/list.of([x, xs]))
        }
        other =>
          raise ParseError("parse_alts(): expect NIL or CONS but got \{other}")
      }
      self.eat!(Close(')'))
      let exp = self.parse_expr!()
      let alt = (tag, variables, exp)
      self.eat!(Close(']'))
      continue self.peek(), Cons(alt, acc)
    }
    _, acc => acc.rev()
  }
}

fn Tokens::parse_defs(self : Tokens) -> List[(String, RawExpr[String])]!ParseError {
  let acc : List[(String, RawExpr[String])] = Nil
  loop self.peek(), acc {
    Open('['), acc => {
      self.next()
      let var = self.parse_var!()
      let value = self.parse_expr!()
      self.eat!(Close(']'))
      continue self.peek(), Cons((var, value), acc)
    }
    _, acc => acc.rev()
  }
}

fn Tokens::parse_apply(self : Tokens) -> RawExpr[String]!ParseError {
  let mut res = self.parse_expr!()
  while self.peek() != Close(')') {
    res = App(res, self.parse_expr!())
  }
  return res
}

fn Tokens::parse_expr(self : Tokens) -> RawExpr[String]!ParseError {
  match self.peek() {
    EOF =>
      raise ParseError(
        "parse_expr() : expect a token but got a empty token stream",
      )
    Number(n) => {
      self.next()
      Num(n)
    }
    Id(s) => {
      self.next()
      Var(s)
    }
    NIL => {
      self.next()
      Constructor(tag=0, arity=0)
    }
    Open('(') => {
      self.next()
      let exp = match self.peek() {
        Let => self.parse_let!()
        Letrec => self.parse_letrec!()
        Case => self.parse_case!()
        CONS => self.parse_cons!()
        Id(_) | Open('(') => self.parse_apply!()
        other =>
          raise ParseError("parse_expr(): cant parse \{other} behind a '('")
      }
      self.eat!(Close(')'))
      return exp
    }
    other => raise ParseError("parse_expr(): cant parse \{other}")
  }
}

fn Tokens::parse_sc(self : Tokens) -> ScDef[String]!ParseError {
  self.eat!(Open('('))
  self.eat!(DefFn)
  let fn_name = self.parse_var!()
  self.eat!(Open('['))
  let args = loop self.peek(), List::Nil {
    tok, acc =>
      if tok != Close(']') {
        let var = self.parse_var!()
        continue self.peek(), Cons(var, acc)
      } else {
        acc.rev()
      }
  }
  self.eat!(Close(']'))
  let body = self.parse_expr!()
  self.eat!(Close(')'))
  ScDef::{ name: fn_name, args, body }
}

test "parse scdef" {
  let test_ = fn!(s) { ignore(tokenize(s).parse_sc!()) }
  for p in programs {
    let (_, p) = p
    test_!(p)
  }
}
```

---

### 文件：`src/part1/top.mbt`

```moonbit
// start run definition
fn run(codes : List[String]) -> Node {
  fn parse_then_compile(code : String) -> (String, Int, List[Instruction]) {
    let tokens = tokenize(code)
    let code = try tokens.parse_sc!() catch {
      ParseError(s) => abort(s)
    } else {
      expr => expr
    }
    let code = code.compileSC()
    return code
  }

  let codes = codes.map(parse_then_compile) + prelude_defs.map(ScDef::compileSC)
  let (heap, globals) = build_initial_heap(codes)
  let initialState : GState = {
    heap,
    stack: Nil,
    code: @immut/list.of([PushGlobal("main"), Unwind]),
    globals,
    stats: 0,
  }
  GState::reify(initialState)
}
// end run definition

test "basic eval" {
  // S K K x => ((K x (K x)) => x
  let main = "(defn main[] (S K K 3))"
  inspect!(run(@immut/list.of([main])), content="NNum(3)")
  let main = "(defn main[] (K 0 1))"
  inspect!(run(@immut/list.of([main])), content="NNum(0)")
  let main = "(defn main[] (K1 0 1))"
  inspect!(run(@immut/list.of([main])), content="NNum(1)")
  let r = LazyRef::{ data: Waiting(fn() { 3 + 4 }) }
  inspect!(square(r), content="49")
}
```

---

### 文件：`src/part1/vm.mbt`

```moonbit
// start heap definition
// Use the 'type' keyword to encapsulate an address type.
type Addr Int derive(Eq, Show)

// Describe graph nodes with an enumeration type.
enum Node {
  NNum(Int)
  // The application node
  NApp(Addr, Addr)
  // To store the number of parameters and 
  // the corresponding sequence of instructions for a super combinator
  NGlobal(String, Int, List[Instruction])
  // The Indirection node. The key component of implementing lazy evaluation
  NInd(Addr)
} derive(Eq, Show)

struct GHeap {
  // The heap uses an array, 
  // and the space with None content in the array is available as free memory.
  mut object_count : Int
  memory : Array[Node?]
}

// Allocate heap space for nodes.
fn GHeap::alloc(self : GHeap, node : Node) -> Addr {
  let heap = self
  fn next(n : Int) -> Int {
    (n + 1) % heap.memory.length()
  }

  fn free(i : Int) -> Bool {
    match heap.memory[i] {
      None => true
      _ => false
    }
  }

  let mut i = heap.object_count
  while not(free(i)) {
    i = next(i)
  }
  heap.memory[i] = Some(node)
  heap.object_count = heap.object_count + 1
  return Addr(i)
}
// end heap definition

fn GHeap::op_get(self : GHeap, key : Addr) -> Node {
  let Addr(i) = key
  match self.memory[i] {
    Some(node) => node
    None => abort("GHeap::get(): index \{i} was empty")
  }
}

fn GHeap::op_set(self : GHeap, key : Addr, val : Node) -> Unit {
  self.memory[key._] = Some(val)
}

// start state definition
struct GState {
  mut stack : List[Addr]
  heap : GHeap
  globals : @hashmap.T[String, Addr]
  mut code : List[Instruction]
  mut stats : GStats
}

type GStats Int

fn GState::stat_incr(self : GState) -> Unit {
  self.stats = self.stats._ + 1
}

fn GState::put_stack(self : GState, addr : Addr) -> Unit {
  self.stack = Cons(addr, self.stack)
}

fn GState::put_code(self : GState, instrs : List[Instruction]) -> Unit {
  self.code = instrs + self.code
}

fn GState::pop1(self : GState) -> Addr {
  match self.stack {
    Cons(addr, reststack) => {
      self.stack = reststack
      addr
    }
    Nil => abort("pop1(): stack size smaller than 1")
  }
}

// e1 e2 ..... -> (e1, e2) ......
fn GState::pop2(self : GState) -> (Addr, Addr) {
  match self.stack {
    Cons(addr1, Cons(addr2, reststack)) => {
      self.stack = reststack
      (addr1, addr2)
    }
    _ => abort("pop2(): stack size smaller than 2")
  }
}
// end state definition

// start push_int definition
fn GState::push_int(self : GState, num : Int) -> Unit {
  let addr = self.heap.alloc(NNum(num))
  self.put_stack(addr)
}
// end push_int definition

// start push_global definition
fn GState::push_global(self : GState, name : String) -> Unit {
  guard self.globals.get(name) is Some(addr) else {
    abort("push_global(): cant find supercombinator \{name}")
  }
  self.put_stack(addr)
}
// end push_global definition

// start push_arg definition
fn GState::push_arg(self : GState, offset : Int) -> Unit {
  let appaddr = self.stack.unsafe_nth(offset + 1)
  let arg = match self.heap[appaddr] {
    NApp(_, arg) => arg
    otherwise =>
      abort(
        "pusharg: stack offset \{offset} address \{appaddr} node \{otherwise}",
      )
  }
  self.put_stack(arg)
}
// end push_arg definition

// start mk_apply definition
fn GState::mk_apply(self : GState) -> Unit {
  let (a1, a2) = self.pop2()
  let appaddr = self.heap.alloc(NApp(a1, a2))
  self.put_stack(appaddr)
}
// end mk_apply definition

// start update definition
fn GState::update(self : GState, n : Int) -> Unit {
  let addr = self.pop1()
  let dst = self.stack.unsafe_nth(n)
  self.heap[dst] = NInd(addr)
}
// end update definition

// start unwind definition
fn GState::unwind(self : GState) -> Unit {
  let addr = self.pop1()
  match self.heap[addr] {
    NNum(_) => self.put_stack(addr)
    NApp(a1, _) => {
      self.put_stack(addr)
      self.put_stack(a1)
      self.put_code(Cons(Unwind, Nil))
    }
    NGlobal(_, n, c) =>
      if self.stack.length() < n {
        abort("Unwinding with too few arguments")
      } else {
        self.put_stack(addr)
        self.put_code(c)
      }
    NInd(a) => {
      self.put_stack(a)
      self.put_code(Cons(Unwind, Nil))
    }
  }
}
// end unwind definition

// start build_ih definition
fn build_initial_heap(
  scdefs : List[(String, Int, List[Instruction])]
) -> (GHeap, @hashmap.T[String, Addr]) {
  let heap = { object_count: 0, memory: Array::make(10000, None) }
  let globals = @hashmap.new(capacity=50)
  loop scdefs {
    Nil => ()
    Cons((name, arity, instrs), rest) => {
      let addr = heap.alloc(NGlobal(name, arity, instrs))
      globals[name] = addr
      continue rest
    }
  }
  return (heap, globals)
}
// end build_ih definition

// start step definition
fn GState::step(self : GState) -> Bool {
  match self.code {
    Nil => return false
    Cons(i, rest) => {
      self.code = rest
      self.stat_incr()
      match i {
        PushGlobal(f) => self.push_global(f)
        PushInt(n) => self.push_int(n)
        PushArg(n) => self.push_arg(n)
        MkApp => self.mk_apply()
        Unwind => self.unwind()
        Update(n) => self.update(n)
        Pop(n) => self.stack = self.stack.drop(n)
      }
      return true
    }
  }
}
// end step definition

// start reify definition
fn GState::reify(self : GState) -> Node {
  if self.step() {
    self.reify()
  } else {
    let stack = self.stack
    match stack {
      Cons(addr, Nil) => {
        let res = self.heap[addr]
        return res
      }
      _ => abort("wrong stack \{stack}")
    }
  }
}
// end reify definition
```

---

### 文件：`src/part2/ast.mbt`

```moonbit
typealias List[E] = @immut/list.T[E]

enum RawExpr[T] {
  Var(T)
  Num(Int)
  Constructor(tag~ : Int, arity~ : Int) // tag, arity
  App(RawExpr[T], RawExpr[T])
  Let(Bool, List[(T, RawExpr[T])], RawExpr[T]) // isRec, Defs, Body
  Case(RawExpr[T], List[(Int, List[T], RawExpr[T])])
} derive(Show)

struct ScDef[T] {
  name : String
  args : List[T]
  body : RawExpr[T]
} derive(Show)

fn[T] is_atom(self : RawExpr[T]) -> Bool {
  match self {
    Var(_) => true
    Num(_) => true
    _ => false
  }
}

fn[T] ScDef::new(name : String, args : List[T], body : RawExpr[T]) -> ScDef[T] {
  { name, args, body }
}

let prelude_defs : List[ScDef[String]] = {
  let args : (FixedArray[String]) -> List[String] = @immut/list.of
  let id = ScDef::new("I", args(["x"]), Var("x")) // id x = x
  let k = ScDef::new("K", args(["x", "y"]), Var("x")) // K x y = x
  let k1 = ScDef::new("K1", args(["x", "y"]), Var("y")) // K1 x y = y
  let s = ScDef::new(
    "S",
    args(["f", "g", "x"]),
    App(App(Var("f"), Var("x")), App(Var("g"), Var("x"))),
  ) // S f g x = f x (g x)
  let compose = ScDef::new(
    "compose",
    args(["f", "g", "x"]),
    App(Var("f"), App(Var("g"), Var("x"))),
  ) // compose f g x = f (g x)
  let twice = ScDef::new(
    "twice",
    args(["f"]),
    App(App(Var("compose"), Var("f")), Var("f")),
  ) // twice f = compose f f
  @immut/list.of([id, k, k1, s, compose, twice])
}
```

---

### 文件：`src/part2/compile.mbt`

```moonbit
fn ScDef::compileSC(self : ScDef[String]) -> (String, Int, List[Instruction]) {
  let name = self.name
  let body = self.body
  let mut arity = 0
  fn gen_env(i : Int, args : List[String]) -> List[(String, Int)] {
    match args {
      Nil => {
        arity = i
        return Nil
      }
      Cons(s, ss) => Cons((s, i), gen_env(i + 1, ss))
    }
  }

  let env = gen_env(0, self.args)
  (name, arity, body.compileR(env, arity))
}

fn RawExpr::compileR(
  self : RawExpr[String],
  env : List[(String, Int)],
  arity : Int
) -> List[Instruction] {
  if arity == 0 {
    self.compileC(env) + @immut/list.of([Update(arity), Unwind])
  } else {
    self.compileC(env) + @immut/list.of([Update(arity), Pop(arity), Unwind])
  }
}

fn RawExpr::compileC(
  self : RawExpr[String],
  env : List[(String, Int)]
) -> List[Instruction] {
  match self {
    Var(s) =>
      match env.lookup(s) {
        None => @immut/list.of([PushGlobal(s)])
        Some(n) => @immut/list.of([Push(n)])
      }
    Num(n) => @immut/list.of([PushInt(n)])
    App(e1, e2) =>
      e2.compileC(env) +
      e1.compileC(argOffset(1, env)) +
      @immut/list.of([MkApp])
    Let(rec, defs, e) =>
      if rec {
        compileLetrec(RawExpr::compileC, defs, e, env)
      } else {
        compileLet(RawExpr::compileC, defs, e, env)
      }
    _ => abort("not support yet")
  }
}

fn argOffset(n : Int, env : List[(String, Int)]) -> List[(String, Int)] {
  env.map(fn { (name, offset) => (name, offset + n) })
}

// start compile_let definition
fn compileLet(
  comp : (RawExpr[String], List[(String, Int)]) -> List[Instruction],
  defs : List[(String, RawExpr[String])],
  expr : RawExpr[String],
  env : List[(String, Int)]
) -> List[Instruction] {
  let (env, codes) = loop env, List::Nil, defs {
    env, acc, Nil => (env, acc)
    env, acc, Cons((name, expr), rest) => {
      let code = expr.compileC(env)
      let env = List::Cons((name, 0), argOffset(1, env))
      continue env, acc + code, rest
    }
  }
  codes + comp(expr, env) + @immut/list.of([Slide(defs.length())])
}
// end compile_let definition

// start compile_letrec definition
fn compileLetrec(
  comp : (RawExpr[String], List[(String, Int)]) -> List[Instruction],
  defs : List[(String, RawExpr[String])],
  expr : RawExpr[String],
  env : List[(String, Int)]
) -> List[Instruction] {
  let mut env = env
  loop defs {
    Nil => ()
    Cons((name, _), rest) => {
      env = Cons((name, 0), argOffset(1, env))
      continue rest
    }
  }
  let n = defs.length()
  fn compileDefs(
    defs : List[(String, RawExpr[String])],
    offset : Int
  ) -> List[Instruction] {
    match defs {
      Nil => comp(expr, env) + @immut/list.of([Slide(n)])
      Cons((_, expr), rest) =>
        expr.compileC(env) +
        Cons(Update(offset), compileDefs(rest, offset - 1))
    }
  }

  Cons(Alloc(n), compileDefs(defs, n - 1))
}
// end compile_letrec definition

// start prim definition
let compiled_primitives : List[(String, Int, List[Instruction])] = @immut/list.of([
    // Arith
    (
      "add",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Add,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    (
      "sub",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Sub,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    (
      "mul",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Mul,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    (
      "div",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Div,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    // Compare
    (
      "eq",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Eq,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    (
      "neq",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Ne,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    (
      "ge",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Ge,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    (
      "gt",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Gt,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    (
      "le",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Le,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    (
      "lt",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Lt,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    // MISC
    (
      "negate",
      1,
      @immut/list.of([Push(0), Eval, Neg, Update(1), Pop(1), Unwind]),
    ),
    (
      "if",
      3,
      @immut/list.of([
        Push(0),
        Eval,
        Cond(@immut/list.of([Push(1)]), @immut/list.of([Push(2)])),
        Update(3),
        Pop(3),
        Unwind,
      ]),
    ),
  ],
)
// end prim definition
```

---

### 文件：`src/part2/instruction.mbt`

```moonbit
// start instr definition
enum Instruction {
  Unwind
  PushGlobal(String)
  PushInt(Int)
  Push(Int)
  MkApp
  Slide(Int)
  Update(Int)
  Pop(Int)
  Alloc(Int)
  Eval
  Add
  Sub
  Mul
  Div
  Neg
  Eq // ==
  Ne // !=
  Lt // <
  Le // <=
  Gt // >
  Ge // >=
  Cond(List[Instruction], List[Instruction])
} derive(Eq, Show)
// end instr definition
```

---

### 文件：`src/part2/moon.pkg.json`

```json
{
    "warn-list": "-4-8"
}
```

---

### 文件：`src/part2/programs.mbt`

```moonbit
let programs : @hashmap.T[String, String] = {
  let programs = @hashmap.new(capacity=40)
  programs["square"] =
    #| (defn square[x] (mul x x))
  programs["fix"] =
    #| (defn fix[f] (letrec ([x (f x)]) x))
  programs["isNil"] =
    #| (defn isNil[x]
    #|   (case x [(Nil) 1] [(Cons n m) 0]))
  programs["tail"] =
    #| (defn tail[l] (case l [(Cons x xs) xs]))
  programs["fibs"] =
    // fibs = 0 : 1 : zipWith (+) fibs (tail fibs)
    #| (defn fibs[] (Cons 0 (Cons 1 (zipWith add fibs (tail fibs)))))
  programs["take"] =
    #| (defn take[n l]
    #|   (case l
    #|     [(Nil) Nil]
    #|     [(Cons x xs)
    #|        (if (le n 0) Nil (Cons x (take (sub n 1) xs)))]))
  programs["zipWith"] =
    #| (defn zipWith[op l1 l2]
    #|   (case l1
    #|     [(Nil) Nil]
    #|     [(Cons x xs)
    #|       (case l2
    #|         [(Nil) Nil]
    #|         [(Cons y ys) (Cons (op x y) (zipWith op xs ys))])]))
  programs["factorial"] =
    #| (defn factorial[n]
    #|   (if (eq n 0) 1 (mul n (factorial (sub n 1)))))
  programs["abs"] =
    #| (defn abs[n]
    #|   (if (lt n 0) (negate n) n))
  programs["length"] =
    #| (defn length[l]
    #|   (case l
    #|     [(Nil) 0]
    #|     [(Cons x xs) (add 1 (length xs))]))
  programs
}
```

---

### 文件：`src/part2/syntax.mbt`

```moonbit
enum Token {
  DefFn
  Let
  NIL
  CONS
  Case
  Letrec
  Open(Char) // { [ (
  Close(Char) // } ] )
  Id(String)
  Number(Int)
  EOF
} derive(Eq, Show)

fn between(this : Char, lw : Char, up : Char) -> Bool {
  this >= lw && this <= up
}

fn isDigit(this : Char) -> Bool {
  between(this, '0', '9')
}

fn isAlpha(this : Char) -> Bool {
  between(this, 'A', 'Z') || between(this, 'a', 'z')
}

fn isIdChar(this : Char) -> Bool {
  isAlpha(this) || isDigit(this) || this == '_' || this == '-'
}

fn isWhiteSpace(this : Char) -> Bool {
  this == ' ' || this == '\t' || this == '\n'
}

fn to_number(this : Char) -> Int {
  this.to_int() - 48
}

fn isOpen(this : Char) -> Bool {
  this == '(' || this == '[' || this == '{'
}

fn isClose(this : Char) -> Bool {
  this == ')' || this == ']' || this == '}'
}

struct Tokens {
  tokens : Array[Token]
  mut current : Int
} derive(Show)

fn Tokens::new(tokens : Array[Token]) -> Tokens {
  Tokens::{ tokens, current: 0 }
}

fn Tokens::peek(self : Tokens) -> Token {
  if self.current < self.tokens.length() {
    return self.tokens[self.current]
  } else {
    return EOF
  }
}

type! ParseError String

fn Tokens::next(self : Tokens, loc~ : SourceLoc = _) -> Unit {
  self.current = self.current + 1
  if self.current > self.tokens.length() {
    abort("Tokens::next(): \{loc}")
  }
}

fn Tokens::eat(self : Tokens, tok : Token, loc~ : SourceLoc = _) -> Unit!ParseError {
  let __tok = self.peek()
  // assert tok_ != EOF
  if __tok != tok {
    raise ParseError("\{loc} - Tokens::eat(): expect \{tok} but got \{__tok}")
  } else {
    self.next()
  }
}

fn tokenize(source : String) -> Tokens {
  let tokens : Array[Token] = Array::new(capacity=source.length() / 2)
  let mut current = 0
  let source = source.to_array()
  fn peek() -> Char {
    source[current]
  }

  fn next() -> Unit {
    current = current + 1
  }

  while current < source.length() {
    let ch = peek()
    if isWhiteSpace(ch) {
      next()
      continue
    } else if isDigit(ch) {
      let mut num = to_number(ch)
      next()
      while current < source.length() && isDigit(peek()) {
        num = num * 10 + to_number(peek())
        next()
      }
      tokens.push(Number(num))
      continue
    } else if isOpen(ch) {
      next()
      tokens.push(Open(ch))
      continue
    } else if isClose(ch) {
      next()
      tokens.push(Close(ch))
      continue
    } else if isAlpha(ch) {
      let identifier = @buffer.new(size_hint=42)
      identifier.write_char(ch)
      next()
      while current < source.length() && isIdChar(peek()) {
        identifier.write_char(peek())
        next()
      }
      let identifier = identifier.contents().to_unchecked_string()
      match identifier {
        "let" => tokens.push(Let)
        "letrec" => tokens.push(Letrec)
        "Nil" => tokens.push(NIL)
        "Cons" => tokens.push(CONS)
        "case" => tokens.push(Case)
        "defn" => tokens.push(DefFn)
        _ => tokens.push(Id(identifier))
      }
    } else {
      abort("error : invalid Character '\{ch}' in [\{current}]")
    }
  } else {
    return Tokens::new(tokens)
  }
}

test "tokenize" {
  inspect!(tokenize("").tokens, content="[]")
  inspect!(tokenize("12345678").tokens, content="[Number(12345678)]")
  inspect!(tokenize("1234 5678").tokens, content="[Number(1234), Number(5678)]")
  inspect!(
    tokenize("a0 a_0 a-0").tokens,
    content=
      #|[Id("a0"), Id("a_0"), Id("a-0")]
    ,
  )
  inspect!(
    tokenize("(Cons 0 (Cons 1 Nil))").tokens,
    content="[Open('('), CONS, Number(0), Open('('), CONS, Number(1), NIL, Close(')'), Close(')')]",
  )
}

fn Tokens::parse_num(self : Tokens) -> Int!ParseError {
  match self.peek() {
    Number(n) => {
      self.next()
      return n
    }
    other => raise ParseError("parse_num(): expect a number but got \{other}")
  }
}

fn Tokens::parse_var(self : Tokens) -> String!ParseError {
  match self.peek() {
    Id(s) => {
      self.next()
      return s
    }
    other => raise ParseError("parse_var(): expect a variable but got \{other}")
  }
}

fn Tokens::parse_cons(self : Tokens) -> RawExpr[String]!ParseError {
  match self.peek() {
    CONS => {
      self.next()
      let x = self.parse_expr!()
      let xs = self.parse_expr!()
      return App(App(Constructor(tag=1, arity=2), x), xs)
    }
    other => raise ParseError("parse_cons(): expect Cons but got \{other}")
  }
}

fn Tokens::parse_let(self : Tokens) -> RawExpr[String]!ParseError {
  self.eat!(Let)
  self.eat!(Open('('))
  let defs = self.parse_defs!()
  self.eat!(Close(')'))
  let exp = self.parse_expr!()
  Let(false, defs, exp)
}

fn Tokens::parse_letrec(self : Tokens) -> RawExpr[String]!ParseError {
  self.eat!(Letrec)
  self.eat!(Open('('))
  let defs = self.parse_defs!()
  self.eat!(Close(')'))
  let exp = self.parse_expr!()
  Let(true, defs, exp)
}

fn Tokens::parse_case(self : Tokens) -> RawExpr[String]!ParseError {
  self.eat!(Case)
  let exp = self.parse_expr!()
  let alts = self.parse_alts!()
  Case(exp, alts)
}

fn parse_alts(
  self : Tokens
) -> List[(Int, List[String], RawExpr[String])]!ParseError {
  let acc : List[(Int, List[String], RawExpr[String])] = Nil
  loop self.peek(), acc {
    Open('['), acc => {
      self.next()
      self.eat!(Open('('))
      let (tag, variables) = match self.peek() {
        NIL => {
          self.next()
          (0, List::Nil)
        }
        CONS => {
          self.next()
          let x = self.parse_var!()
          let xs = self.parse_var!()
          (1, @immut/list.of([x, xs]))
        }
        other =>
          raise ParseError("parse_alts(): expect NIL or CONS but got \{other}")
      }
      self.eat!(Close(')'))
      let exp = self.parse_expr!()
      let alt = (tag, variables, exp)
      self.eat!(Close(']'))
      continue self.peek(), Cons(alt, acc)
    }
    _, acc => acc.rev()
  }
}

fn Tokens::parse_defs(self : Tokens) -> List[(String, RawExpr[String])]!ParseError {
  let acc : List[(String, RawExpr[String])] = Nil
  loop self.peek(), acc {
    Open('['), acc => {
      self.next()
      let var = self.parse_var!()
      let value = self.parse_expr!()
      self.eat!(Close(']'))
      continue self.peek(), Cons((var, value), acc)
    }
    _, acc => acc.rev()
  }
}

fn Tokens::parse_apply(self : Tokens) -> RawExpr[String]!ParseError {
  let mut res = self.parse_expr!()
  while self.peek() != Close(')') {
    res = App(res, self.parse_expr!())
  }
  return res
}

fn Tokens::parse_expr(self : Tokens) -> RawExpr[String]!ParseError {
  match self.peek() {
    EOF =>
      raise ParseError(
        "parse_expr() : expect a token but got a empty token stream",
      )
    Number(n) => {
      self.next()
      Num(n)
    }
    Id(s) => {
      self.next()
      Var(s)
    }
    NIL => {
      self.next()
      Constructor(tag=0, arity=0)
    }
    Open('(') => {
      self.next()
      let exp = match self.peek() {
        Let => self.parse_let!()
        Letrec => self.parse_letrec!()
        Case => self.parse_case!()
        CONS => self.parse_cons!()
        Id(_) | Open('(') => self.parse_apply!()
        other =>
          raise ParseError("parse_expr(): cant parse \{other} behind a '('")
      }
      self.eat!(Close(')'))
      return exp
    }
    other => raise ParseError("parse_expr(): cant parse \{other}")
  }
}

fn Tokens::parse_sc(self : Tokens) -> ScDef[String]!ParseError {
  self.eat!(Open('('))
  self.eat!(DefFn)
  let fn_name = self.parse_var!()
  self.eat!(Open('['))
  let args = loop self.peek(), List::Nil {
    tok, acc =>
      if tok != Close(']') {
        let var = self.parse_var!()
        continue self.peek(), Cons(var, acc)
      } else {
        acc.rev()
      }
  }
  self.eat!(Close(']'))
  let body = self.parse_expr!()
  self.eat!(Close(')'))
  ScDef::{ name: fn_name, args, body }
}

test "parse scdef" {
  let test_ = fn!(s) { ignore(tokenize(s).parse_sc!()) }
  for p in programs {
    let (_, p) = p
    test_!(p)
  }
}
```

---

### 文件：`src/part2/top.mbt`

```moonbit
fn run(codes : List[String]) -> Node {
  fn parse_then_compile(code : String) -> (String, Int, List[Instruction]) {
    let tokens = tokenize(code)
    let code = try tokens.parse_sc!() catch {
      ParseError(s) => abort(s)
    } else {
      expr => expr
    }
    let code = code.compileSC()
    return code
  }

  let codes = codes.map(parse_then_compile) + prelude_defs.map(ScDef::compileSC)
  let codes = compiled_primitives + codes
  let (heap, globals) = build_initial_heap(codes)
  // start init definition
  let initialState : GState = {
    heap,
    stack: Nil,
    code: @immut/list.of([PushGlobal("main"), Eval]),
    globals,
    stats: 0,
    dump: Nil,
  }
  // end init definition
  GState::reify(initialState)
}

test "basic eval" {
  let main = "(defn main[] (let ([add1 (add 1)]) (add1 1)))"
  inspect!(run(@immut/list.of([main])), content="NNum(2)")
  let main = "(defn main[] (let ([x 4] [y 5]) (sub x y)))"
  inspect!(run(@immut/list.of([main])), content="NNum(-1)")
}
```

---

### 文件：`src/part2/vm.mbt`

```moonbit
// Use the 'type' keyword to encapsulate an address type.
type Addr Int derive(Eq, Show)

// Describe graph nodes with an enumeration type.
enum Node {
  NNum(Int)
  // The application node
  NApp(Addr, Addr)
  // To store the number of parameters and 
  // the corresponding sequence of instructions for a super combinator
  NGlobal(String, Int, List[Instruction])
  // The Indirection node，The key component of implementing lazy evaluation
  NInd(Addr)
} derive(Eq, Show)

struct GHeap {
  // The heap uses an array, 
  // and the space with None content in the array is available as free memory.
  mut object_count : Int
  memory : Array[Node?]
}

// Allocate heap space for nodes.
fn GHeap::alloc(self : GHeap, node : Node) -> Addr {
  let heap = self
  fn next(n : Int) -> Int {
    (n + 1) % heap.memory.length()
  }

  fn free(i : Int) -> Bool {
    match heap.memory[i] {
      None => true
      _ => false
    }
  }

  let mut i = heap.object_count
  while not(free(i)) {
    i = next(i)
  }
  heap.memory[i] = Some(node)
  heap.object_count = heap.object_count + 1
  return Addr(i)
}

fn GHeap::op_get(self : GHeap, key : Addr) -> Node {
  let Addr(i) = key
  match self.memory[i] {
    Some(node) => node
    None => abort("GHeap::get(): index \{i} was empty")
  }
}

fn GHeap::op_set(self : GHeap, key : Addr, val : Node) -> Unit {
  self.memory[key._] = Some(val)
}

struct GState {
  mut stack : List[Addr]
  heap : GHeap
  globals : @hashmap.T[String, Addr]
  mut dump : List[(List[Instruction], List[Addr])]
  mut code : List[Instruction]
  mut stats : GStats
}

type GStats Int

fn GState::stat_incr(self : GState) -> Unit {
  self.stats = self.stats._ + 1
}

fn GState::put_stack(self : GState, addr : Addr) -> Unit {
  self.stack = Cons(addr, self.stack)
}

fn GState::put_dump(
  self : GState,
  codes : List[Instruction],
  stack : List[Addr]
) -> Unit {
  self.dump = Cons((codes, stack), self.dump)
}

fn GState::put_code(self : GState, instrs : List[Instruction]) -> Unit {
  self.code = instrs + self.code
}

fn GState::pop1(self : GState) -> Addr {
  match self.stack {
    Cons(addr, reststack) => {
      self.stack = reststack
      addr
    }
    Nil => abort("pop1(): stack size smaller than 1")
  }
}

// e1 e2 ..... -> (e1, e2) ......
fn GState::pop2(self : GState) -> (Addr, Addr) {
  match self.stack {
    Cons(addr1, Cons(addr2, reststack)) => {
      self.stack = reststack
      (addr1, addr2)
    }
    _ => abort("pop2(): stack size smaller than 2")
  }
}

fn GState::push_int(self : GState, num : Int) -> Unit {
  let addr = self.heap.alloc(NNum(num))
  self.put_stack(addr)
}

fn GState::push_global(self : GState, name : String) -> Unit {
  guard self.globals.get(name) is Some(addr) else {
    abort("push_global(): cant find supercombinator \{name}")
  }
  self.put_stack(addr)
}

// start push definition
fn GState::push(self : GState, offset : Int) -> Unit {
  // Push(n) a0 : . . . : an : s
  //     =>  an : a0 : . . . : an : s
  let addr = self.stack.unsafe_nth(offset)
  self.put_stack(addr)
}
// end push definition

// start slide definition
fn GState::slide(self : GState, n : Int) -> Unit {
  let addr = self.pop1()
  self.stack = Cons(addr, self.stack.drop(n))
}
// end slide definition

// start rearrange definition
fn GState::rearrange(self : GState, n : Int) -> Unit {
  let appnodes = self.stack.take(n)
  let args = appnodes.map(fn(addr) {
    guard self.heap[addr] is NApp(_, arg)
    arg
  })
  self.stack = args + appnodes.drop(n - 1)
}
// end rearrange definition

fn GState::mk_apply(self : GState) -> Unit {
  let (a1, a2) = self.pop2()
  let appaddr = self.heap.alloc(NApp(a1, a2))
  self.put_stack(appaddr)
}

fn GState::update(self : GState, n : Int) -> Unit {
  let addr = self.pop1()
  let dst = self.stack.unsafe_nth(n)
  self.heap[dst] = NInd(addr)
}

// start unwind definition
fn GState::unwind(self : GState) -> Unit {
  let addr = self.pop1()
  match self.heap[addr] {
    NNum(_) =>
      match self.dump {
        Nil => self.put_stack(addr)
        Cons((instrs, stack), rest_dump) => {
          self.stack = stack
          self.put_stack(addr)
          self.dump = rest_dump
          self.code = instrs
        }
      }
    NApp(a1, _) => {
      self.put_stack(addr)
      self.put_stack(a1)
      self.put_code(@immut/list.of([Unwind]))
    }
    NGlobal(_, n, c) =>
      if self.stack.length() < n {
        abort("Unwinding with too few arguments")
      } else {
        if n != 0 {
          self.rearrange(n)
        } else {
          self.put_stack(addr)
        }
        self.put_code(c)
      }
    NInd(a) => {
      self.put_stack(a)
      self.put_code(@immut/list.of([Unwind]))
    }
  }
}
// end unwind definition

// start alloc definition
fn GState::alloc_nodes(self : GState, n : Int) -> Unit {
  let dummynode : Node = NInd(Addr(-1))
  for i = 0; i < n; i = i + 1 {
    let addr = self.heap.alloc(dummynode)
    self.put_stack(addr)
  }
}
// end alloc definition

// start eval definition
fn GState::eval(self : GState) -> Unit {
  let addr = self.pop1()
  self.put_dump(self.code, self.stack)
  self.stack = @immut/list.of([addr])
  self.code = @immut/list.of([Unwind])
}
// end eval definition

// start cond definition
fn GState::condition(
  self : GState,
  i1 : List[Instruction],
  i2 : List[Instruction]
) -> Unit {
  let addr = self.pop1()
  match self.heap[addr] {
    NNum(0) =>
      // false
      self.code = i2 + self.code
    NNum(1) =>
      // true
      self.code = i1 + self.code
    otherwise => abort("cond : \{addr} = \{otherwise}")
  }
}
// end cond definition

// start op definition
fn GState::negate(self : GState) -> Unit {
  let addr = self.pop1()
  match self.heap[addr] {
    NNum(n) => {
      let addr = self.heap.alloc(NNum(-n))
      self.put_stack(addr)
    }
    otherwise =>
      abort("negate: wrong kind of node \{otherwise}, address \{addr}")
  }
}

fn GState::lift_arith2(self : GState, op : (Int, Int) -> Int) -> Unit {
  let (a1, a2) = self.pop2()
  match (self.heap[a1], self.heap[a2]) {
    (NNum(n1), NNum(n2)) => {
      let newnode = Node::NNum(op(n1, n2))
      let addr = self.heap.alloc(newnode)
      self.put_stack(addr)
    }
    (node1, node2) => abort("liftArith2: \{a1} = \{node1} \{a2} = \{node2}")
  }
}

fn GState::lift_cmp2(self : GState, op : (Int, Int) -> Bool) -> Unit {
  let (a1, a2) = self.pop2()
  match (self.heap[a1], self.heap[a2]) {
    (NNum(n1), NNum(n2)) => {
      let flag = op(n1, n2)
      let newnode = if flag { Node::NNum(1) } else { Node::NNum(0) }
      let addr = self.heap.alloc(newnode)
      self.put_stack(addr)
    }
    (node1, node2) => abort("liftCmp2: \{a1} = \{node1} \{a2} = \{node2}")
  }
}
// end op definition

fn build_initial_heap(
  scdefs : List[(String, Int, List[Instruction])]
) -> (GHeap, @hashmap.T[String, Addr]) {
  let heap = { object_count: 0, memory: Array::make(10000, None) }
  let globals = @hashmap.new(capacity=50)
  loop scdefs {
    Nil => ()
    Cons((name, arity, instrs), rest) => {
      let addr = heap.alloc(NGlobal(name, arity, instrs))
      globals[name] = addr
      continue rest
    }
  }
  return (heap, globals)
}

fn GState::step(self : GState) -> Bool {
  match self.code {
    Nil => return false
    Cons(i, rest) => {
      self.code = rest
      self.stat_incr()
      match i {
        PushGlobal(f) => self.push_global(f)
        PushInt(n) => self.push_int(n)
        Push(n) => self.push(n)
        MkApp => self.mk_apply()
        Unwind => self.unwind()
        Update(n) => self.update(n)
        Pop(n) => self.stack = self.stack.drop(n)
        Alloc(n) => self.alloc_nodes(n)
        Eval => self.eval()
        Slide(n) => self.slide(n)
        Add => self.lift_arith2(fn(x, y) { x + y })
        Sub => self.lift_arith2(fn(x, y) { x - y })
        Mul => self.lift_arith2(fn(x, y) { x * y })
        Div => self.lift_arith2(fn(x, y) { x / y })
        Neg => self.negate()
        Eq => self.lift_cmp2(fn(x, y) { x == y })
        Ne => self.lift_cmp2(fn(x, y) { x != y })
        Lt => self.lift_cmp2(fn(x, y) { x < y })
        Le => self.lift_cmp2(fn(x, y) { x <= y })
        Gt => self.lift_cmp2(fn(x, y) { x > y })
        Ge => self.lift_cmp2(fn(x, y) { x >= y })
        Cond(i1, i2) => self.condition(i1, i2)
      }
      return true
    }
  }
}

fn GState::reify(self : GState) -> Node {
  if self.step() {
    self.reify()
  } else {
    let stack = self.stack
    match stack {
      Cons(addr, Nil) => {
        let res = self.heap[addr]
        return res
      }
      _ => abort("wrong stack \{stack}")
    }
  }
}
```

---

### 文件：`src/part3/ast.mbt`

```moonbit
typealias List[E] = @immut/list.T[E]

enum RawExpr[T] {
  Var(T)
  Num(Int)
  Constructor(tag~ : Int, arity~ : Int) // tag, arity
  App(RawExpr[T], RawExpr[T])
  Let(Bool, List[(T, RawExpr[T])], RawExpr[T]) // isRec, Defs, Body
  Case(RawExpr[T], List[(Int, List[T], RawExpr[T])])
} derive(Show)

struct ScDef[T] {
  name : String
  args : List[T]
  body : RawExpr[T]
} derive(Show)

fn[T] is_atom(self : RawExpr[T]) -> Bool {
  match self {
    Var(_) => true
    Num(_) => true
    _ => false
  }
}

fn[T] ScDef::new(name : String, args : List[T], body : RawExpr[T]) -> ScDef[T] {
  { name, args, body }
}

let prelude_defs : List[ScDef[String]] = {
  let args : (FixedArray[String]) -> List[String] = @immut/list.of
  let id = ScDef::new("I", args(["x"]), Var("x")) // id x = x
  let k = ScDef::new("K", args(["x", "y"]), Var("x")) // K x y = x
  let k1 = ScDef::new("K1", args(["x", "y"]), Var("y")) // K1 x y = y
  let s = ScDef::new(
    "S",
    args(["f", "g", "x"]),
    App(App(Var("f"), Var("x")), App(Var("g"), Var("x"))),
  ) // S f g x = f x (g x)
  let compose = ScDef::new(
    "compose",
    args(["f", "g", "x"]),
    App(Var("f"), App(Var("g"), Var("x"))),
  ) // compose f g x = f (g x)
  let twice = ScDef::new(
    "twice",
    args(["f"]),
    App(App(Var("compose"), Var("f")), Var("f")),
  ) // twice f = compose f f
  @immut/list.of([id, k, k1, s, compose, twice])
}
```

---

### 文件：`src/part3/compile.mbt`

```moonbit
fn ScDef::compileSC(self : ScDef[String]) -> (String, Int, List[Instruction]) {
  let name = self.name
  let body = self.body
  let mut arity = 0
  fn gen_env(i : Int, args : List[String]) -> List[(String, Int)] {
    match args {
      Nil => {
        arity = i
        return Nil
      }
      Cons(s, ss) => Cons((s, i), gen_env(i + 1, ss))
    }
  }

  let env = gen_env(0, self.args)
  (name, arity, body.compileR(env, arity))
}

fn RawExpr::compileR(
  self : RawExpr[String],
  env : List[(String, Int)],
  arity : Int
) -> List[Instruction] {
  if arity == 0 {
    self.compileE(env) + @immut/list.of([Update(arity), Unwind])
  } else {
    self.compileE(env) + @immut/list.of([Update(arity), Pop(arity), Unwind])
  }
}

fn RawExpr::compileC(
  self : RawExpr[String],
  env : List[(String, Int)]
) -> List[Instruction] {
  match self {
    Var(s) =>
      match env.lookup(s) {
        None => @immut/list.of([PushGlobal(s)])
        Some(n) => @immut/list.of([Push(n)])
      }
    Num(n) => @immut/list.of([PushInt(n)])
    // start c_constr definition
    App(App(Constructor(tag=1, arity=2), x), xs) =>
      // Cons(x, xs)
      xs.compileC(env) +
      x.compileC(argOffset(1, env)) +
      @immut/list.of([Pack(1, 2)])
    // Nil
    Constructor(tag=0, arity=0) => @immut/list.of([Pack(0, 0)])
    // end c_constr definition
    App(e1, e2) =>
      e2.compileC(env) +
      e1.compileC(argOffset(1, env)) +
      @immut/list.of([MkApp])
    Let(rec, defs, e) =>
      if rec {
        compileLetrec(RawExpr::compileC, defs, e, env)
      } else {
        compileLet(RawExpr::compileC, defs, e, env)
      }
    _ => abort("not support yet")
  }
}

fn RawExpr::compileE(
  self : RawExpr[String],
  env : List[(String, Int)]
) -> List[Instruction] {
  match self {
    // start num definition
    Num(n) => @immut/list.of([PushInt(n)])
    // end num definition
    // start let definition
    Let(rec, defs, e) =>
      if rec {
        compileLetrec(RawExpr::compileE, defs, e, env)
      } else {
        compileLet(RawExpr::compileE, defs, e, env)
      }
    // end let definition
    // start if_and_neg definition
    App(App(App(Var("if"), b), e1), e2) => {
      let condition = b.compileE(env)
      let branch1 = e1.compileE(env)
      let branch2 = e2.compileE(env)
      condition + @immut/list.of([Cond(branch1, branch2)])
    }
    App(Var("negate"), e) => e.compileE(env) + @immut/list.of([Neg])
    // end if_and_neg definition
    // start binop definition
    App(App(Var(op), e0), e1) =>
      match builtinOpS.get(op) {
        None => self.compileC(env) + @immut/list.of([Eval])
        Some(instr) => {
          let code1 = e1.compileE(env)
          let code0 = e0.compileE(argOffset(1, env))
          code1 + code0 + @immut/list.of([instr])
        }
      }
    // end binop definition
    // start e_constr_case definition
    Case(e, alts) =>
      e.compileE(env) + @immut/list.of([CaseJump(compileAlts(alts, env))])
    Constructor(tag=0, arity=0) =>
      // Nil
      @immut/list.of([Pack(0, 0)])
    App(App(Constructor(tag=1, arity=2), x), xs) =>
      // Cons(x, xs)
      xs.compileC(env) +
      x.compileC(argOffset(1, env)) +
      @immut/list.of([Pack(1, 2)])
    // end e_constr_case definition
    // start default definition
    _ => self.compileC(env) + @immut/list.of([Eval])
    // end default definition
  }
}

fn compileAlts(
  alts : List[(Int, List[String], RawExpr[String])],
  env : List[(String, Int)]
) -> List[(Int, List[Instruction])] {
  fn buildenv(variables : List[String], off : Int) -> List[(String, Int)] {
    match variables {
      Nil => Nil
      Cons(v, vs) => Cons((v, off), buildenv(vs, off + 1))
    }
  }

  fn go(
    alts : List[(Int, List[String], RawExpr[String])]
  ) -> List[(Int, List[Instruction])] {
    match alts {
      Nil => Nil
      Cons(alt, rest) => {
        let (tag, variables, body) = alt
        let offset = variables.length()
        let env = buildenv(variables, 0) + argOffset(offset, env)
        let code = @immut/list.of([Split]) +
          body.compileE(env) +
          @immut/list.of([Slide(offset)])
        Cons((tag, code), go(rest))
      }
    }
  }

  go(alts)
}

fn argOffset(n : Int, env : List[(String, Int)]) -> List[(String, Int)] {
  env.map(fn { (name, offset) => (name, offset + n) })
}

fn compileLet(
  comp : (RawExpr[String], List[(String, Int)]) -> List[Instruction],
  defs : List[(String, RawExpr[String])],
  expr : RawExpr[String],
  env : List[(String, Int)]
) -> List[Instruction] {
  let (env, codes) = loop env, List::Nil, defs {
    env, acc, Nil => (env, acc)
    env, acc, Cons((name, expr), rest) => {
      let code = expr.compileC(env)
      let env = List::Cons((name, 0), argOffset(1, env))
      continue env, acc + code, rest
    }
  }
  codes + comp(expr, env) + @immut/list.of([Slide(defs.length())])
}

fn compileLetrec(
  comp : (RawExpr[String], List[(String, Int)]) -> List[Instruction],
  defs : List[(String, RawExpr[String])],
  expr : RawExpr[String],
  env : List[(String, Int)]
) -> List[Instruction] {
  let mut env = env
  loop defs {
    Nil => ()
    Cons((name, _), rest) => {
      env = Cons((name, 0), argOffset(1, env))
      continue rest
    }
  }
  let n = defs.length()
  fn compileDefs(
    defs : List[(String, RawExpr[String])],
    offset : Int
  ) -> List[Instruction] {
    match defs {
      Nil => comp(expr, env) + @immut/list.of([Slide(n)])
      Cons((_, expr), rest) =>
        expr.compileC(env) + Cons(Update(offset), compileDefs(rest, offset - 1))
    }
  }

  Cons(Alloc(n), compileDefs(defs, n - 1))
}

let compiled_primitives : List[(String, Int, List[Instruction])] = @immut/list.of([
    // Arith
    (
      "add",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Add,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    (
      "sub",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Sub,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    (
      "mul",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Mul,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    (
      "div",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Div,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    // Compare
    (
      "eq",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Eq,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    (
      "neq",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Ne,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    (
      "ge",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Ge,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    (
      "gt",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Gt,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    (
      "le",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Le,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    (
      "lt",
      2,
      @immut/list.of([
        Push(1),
        Eval,
        Push(1),
        Eval,
        Lt,
        Update(2),
        Pop(2),
        Unwind,
      ]),
    ),
    // MISC
    (
      "negate",
      1,
      @immut/list.of([Push(0), Eval, Neg, Update(1), Pop(1), Unwind]),
    ),
    (
      "if",
      3,
      @immut/list.of([
        Push(0),
        Eval,
        Cond(@immut/list.of([Push(1)]), @immut/list.of([Push(2)])),
        Update(3),
        Pop(3),
        Unwind,
      ]),
    ),
  ],
)

// start builtin definition
let builtinOpS : @hashmap.T[String, Instruction] = {
  let table = @hashmap.new(capacity=50)
  table["add"] = Add
  table["mul"] = Mul
  table["sub"] = Sub
  table["div"] = Div
  table["eq"] = Eq
  table["neq"] = Ne
  table["ge"] = Ge
  table["gt"] = Gt
  table["le"] = Le
  table["lt"] = Lt
  table
}
// end builtin definition
```

---

### 文件：`src/part3/instruction.mbt`

```moonbit
// start instr definition
enum Instruction {
  Unwind
  PushGlobal(String)
  PushInt(Int)
  Push(Int)
  MkApp
  Slide(Int)
  Update(Int)
  Pop(Int)
  Alloc(Int)
  Eval
  Add
  Sub
  Mul
  Div
  Neg
  Eq // ==
  Ne // !=
  Lt // <
  Le // <=
  Gt // >
  Ge // >=
  Cond(List[Instruction], List[Instruction])
  Pack(Int, Int) // tag, arity
  CaseJump(List[(Int, List[Instruction])])
  Split
  Print
} derive(Eq, Show)
// end instr definition
```

---

### 文件：`src/part3/moon.pkg.json`

```json
{
    "warn-list": "-4"
}
```

---

### 文件：`src/part3/programs.mbt`

```moonbit
let programs : @hashmap.T[String, String] = {
  let programs = @hashmap.new(capacity=40)
  programs["square"] =
    #| (defn square[x] (mul x x))
  programs["fix"] =
    #| (defn fix[f] (letrec ([x (f x)]) x))
  programs["isNil"] =
    #| (defn isNil[x]
    #|   (case x [(Nil) 1] [(Cons n m) 0]))
  programs["tail"] =
    #| (defn tail[l] (case l [(Cons x xs) xs]))
  programs["fibs"] =
    // fibs = 0 : 1 : zipWith (+) fibs (tail fibs)
    #| (defn fibs[] (Cons 0 (Cons 1 (zipWith add fibs (tail fibs)))))
  programs["take"] =
    #| (defn take[n l]
    #|   (case l
    #|     [(Nil) Nil]
    #|     [(Cons x xs)
    #|        (if (le n 0) Nil (Cons x (take (sub n 1) xs)))]))
  programs["zipWith"] =
    #| (defn zipWith[op l1 l2]
    #|   (case l1
    #|     [(Nil) Nil]
    #|     [(Cons x xs)
    #|       (case l2
    #|         [(Nil) Nil]
    #|         [(Cons y ys) (Cons (op x y) (zipWith op xs ys))])]))
  programs["factorial"] =
    #| (defn factorial[n]
    #|   (if (eq n 0) 1 (mul n (factorial (sub n 1)))))
  programs["abs"] =
    #| (defn abs[n]
    #|   (if (lt n 0) (negate n) n))
  programs["length"] =
    #| (defn length[l]
    #|   (case l
    #|     [(Nil) 0]
    #|     [(Cons x xs) (add 1 (length xs))]))
  programs
}
```

---

### 文件：`src/part3/syntax.mbt`

```moonbit
enum Token {
  DefFn
  Let
  NIL
  CONS
  Case
  Letrec
  Open(Char) // { [ (
  Close(Char) // } ] )
  Id(String)
  Number(Int)
  EOF
} derive(Eq, Show)

fn between(this : Char, lw : Char, up : Char) -> Bool {
  this >= lw && this <= up
}

fn isDigit(this : Char) -> Bool {
  between(this, '0', '9')
}

fn isAlpha(this : Char) -> Bool {
  between(this, 'A', 'Z') || between(this, 'a', 'z')
}

fn isIdChar(this : Char) -> Bool {
  isAlpha(this) || isDigit(this) || this == '_' || this == '-'
}

fn isWhiteSpace(this : Char) -> Bool {
  this == ' ' || this == '\t' || this == '\n'
}

fn to_number(this : Char) -> Int {
  this.to_int() - 48
}

fn isOpen(this : Char) -> Bool {
  this == '(' || this == '[' || this == '{'
}

fn isClose(this : Char) -> Bool {
  this == ')' || this == ']' || this == '}'
}

struct Tokens {
  tokens : Array[Token]
  mut current : Int
} derive(Show)

fn Tokens::new(tokens : Array[Token]) -> Tokens {
  Tokens::{ tokens, current: 0 }
}

fn Tokens::peek(self : Tokens) -> Token {
  if self.current < self.tokens.length() {
    return self.tokens[self.current]
  } else {
    return EOF
  }
}

type! ParseError String

fn Tokens::next(self : Tokens, loc~ : SourceLoc = _) -> Unit {
  self.current = self.current + 1
  if self.current > self.tokens.length() {
    abort("Tokens::next(): \{loc}")
  }
}

fn Tokens::eat(self : Tokens, tok : Token, loc~ : SourceLoc = _) -> Unit!ParseError {
  let __tok = self.peek()
  // assert tok_ != EOF
  if __tok != tok {
    raise ParseError("\{loc} - Tokens::eat(): expect \{tok} but got \{__tok}")
  } else {
    self.next()
  }
}

fn tokenize(source : String) -> Tokens {
  let tokens : Array[Token] = Array::new(capacity=source.length() / 2)
  let mut current = 0
  let source = source.to_array()
  fn peek() -> Char {
    source[current]
  }

  fn next() -> Unit {
    current = current + 1
  }

  while current < source.length() {
    let ch = peek()
    if isWhiteSpace(ch) {
      next()
      continue
    } else if isDigit(ch) {
      let mut num = to_number(ch)
      next()
      while current < source.length() && isDigit(peek()) {
        num = num * 10 + to_number(peek())
        next()
      }
      tokens.push(Number(num))
      continue
    } else if isOpen(ch) {
      next()
      tokens.push(Open(ch))
      continue
    } else if isClose(ch) {
      next()
      tokens.push(Close(ch))
      continue
    } else if isAlpha(ch) {
      let identifier = @buffer.new(size_hint=42)
      identifier.write_char(ch)
      next()
      while current < source.length() && isIdChar(peek()) {
        identifier.write_char(peek())
        next()
      }
      let identifier = identifier.contents().to_unchecked_string()
      match identifier {
        "let" => tokens.push(Let)
        "letrec" => tokens.push(Letrec)
        "Nil" => tokens.push(NIL)
        "Cons" => tokens.push(CONS)
        "case" => tokens.push(Case)
        "defn" => tokens.push(DefFn)
        _ => tokens.push(Id(identifier))
      }
    } else {
      abort("error : invalid Character '\{ch}' in [\{current}]")
    }
  } else {
    return Tokens::new(tokens)
  }
}

test "tokenize" {
  inspect!(tokenize("").tokens, content="[]")
  inspect!(tokenize("12345678").tokens, content="[Number(12345678)]")
  inspect!(tokenize("1234 5678").tokens, content="[Number(1234), Number(5678)]")
  inspect!(
    tokenize("a0 a_0 a-0").tokens,
    content=
      #|[Id("a0"), Id("a_0"), Id("a-0")]
    ,
  )
  inspect!(
    tokenize("(Cons 0 (Cons 1 Nil))").tokens,
    content="[Open('('), CONS, Number(0), Open('('), CONS, Number(1), NIL, Close(')'), Close(')')]",
  )
}

fn Tokens::parse_num(self : Tokens) -> Int!ParseError {
  match self.peek() {
    Number(n) => {
      self.next()
      return n
    }
    other => raise ParseError("parse_num(): expect a number but got \{other}")
  }
}

fn Tokens::parse_var(self : Tokens) -> String!ParseError {
  match self.peek() {
    Id(s) => {
      self.next()
      return s
    }
    other => raise ParseError("parse_var(): expect a variable but got \{other}")
  }
}

fn Tokens::parse_cons(self : Tokens) -> RawExpr[String]!ParseError {
  match self.peek() {
    CONS => {
      self.next()
      let x = self.parse_expr!()
      let xs = self.parse_expr!()
      return App(App(Constructor(tag=1, arity=2), x), xs)
    }
    other => raise ParseError("parse_cons(): expect Cons but got \{other}")
  }
}

fn Tokens::parse_let(self : Tokens) -> RawExpr[String]!ParseError {
  self.eat!(Let)
  self.eat!(Open('('))
  let defs = self.parse_defs!()
  self.eat!(Close(')'))
  let exp = self.parse_expr!()
  Let(false, defs, exp)
}

fn Tokens::parse_letrec(self : Tokens) -> RawExpr[String]!ParseError {
  self.eat!(Letrec)
  self.eat!(Open('('))
  let defs = self.parse_defs!()
  self.eat!(Close(')'))
  let exp = self.parse_expr!()
  Let(true, defs, exp)
}

fn Tokens::parse_case(self : Tokens) -> RawExpr[String]!ParseError {
  self.eat!(Case)
  let exp = self.parse_expr!()
  let alts = self.parse_alts!()
  Case(exp, alts)
}

fn parse_alts(
  self : Tokens
) -> List[(Int, List[String], RawExpr[String])]!ParseError {
  let acc : List[(Int, List[String], RawExpr[String])] = Nil
  loop self.peek(), acc {
    Open('['), acc => {
      self.next()
      self.eat!(Open('('))
      let (tag, variables) = match self.peek() {
        NIL => {
          self.next()
          (0, List::Nil)
        }
        CONS => {
          self.next()
          let x = self.parse_var!()
          let xs = self.parse_var!()
          (1, @immut/list.of([x, xs]))
        }
        other =>
          raise ParseError("parse_alts(): expect NIL or CONS but got \{other}")
      }
      self.eat!(Close(')'))
      let exp = self.parse_expr!()
      let alt = (tag, variables, exp)
      self.eat!(Close(']'))
      continue self.peek(), Cons(alt, acc)
    }
    _, acc => acc.rev()
  }
}

fn Tokens::parse_defs(self : Tokens) -> List[(String, RawExpr[String])]!ParseError {
  let acc : List[(String, RawExpr[String])] = Nil
  loop self.peek(), acc {
    Open('['), acc => {
      self.next()
      let var = self.parse_var!()
      let value = self.parse_expr!()
      self.eat!(Close(']'))
      continue self.peek(), Cons((var, value), acc)
    }
    _, acc => acc.rev()
  }
}

fn Tokens::parse_apply(self : Tokens) -> RawExpr[String]!ParseError {
  let mut res = self.parse_expr!()
  while self.peek() != Close(')') {
    res = App(res, self.parse_expr!())
  }
  return res
}

fn Tokens::parse_expr(self : Tokens) -> RawExpr[String]!ParseError {
  match self.peek() {
    EOF =>
      raise ParseError(
        "parse_expr() : expect a token but got a empty token stream",
      )
    Number(n) => {
      self.next()
      Num(n)
    }
    Id(s) => {
      self.next()
      Var(s)
    }
    NIL => {
      self.next()
      Constructor(tag=0, arity=0)
    }
    Open('(') => {
      self.next()
      let exp = match self.peek() {
        Let => self.parse_let!()
        Letrec => self.parse_letrec!()
        Case => self.parse_case!()
        CONS => self.parse_cons!()
        Id(_) | Open('(') => self.parse_apply!()
        other =>
          raise ParseError("parse_expr(): cant parse \{other} behind a '('")
      }
      self.eat!(Close(')'))
      return exp
    }
    other => raise ParseError("parse_expr(): cant parse \{other}")
  }
}

fn Tokens::parse_sc(self : Tokens) -> ScDef[String]!ParseError {
  self.eat!(Open('('))
  self.eat!(DefFn)
  let fn_name = self.parse_var!()
  self.eat!(Open('['))
  let args = loop self.peek(), List::Nil {
    tok, acc =>
      if tok != Close(']') {
        let var = self.parse_var!()
        continue self.peek(), Cons(var, acc)
      } else {
        acc.rev()
      }
  }
  self.eat!(Close(']'))
  let body = self.parse_expr!()
  self.eat!(Close(')'))
  ScDef::{ name: fn_name, args, body }
}

test "parse scdef" {
  let test_ = fn!(s) { ignore(tokenize(s).parse_sc!()) }
  for p in programs {
    let (_, p) = p
    test_!(p)
  }
}
```

---

### 文件：`src/part3/top.mbt`

```moonbit
fn run(codes : List[String]) -> String {
  fn parse_then_compile(code : String) -> (String, Int, List[Instruction]) {
    let tokens = tokenize(code)
    let code = try tokens.parse_sc!() catch {
      ParseError(s) => abort(s)
    } else {
      expr => expr
    }
    let code = code.compileSC()
    return code
  }

  let codes = codes.map(parse_then_compile) + prelude_defs.map(ScDef::compileSC)
  let codes = compiled_primitives + codes
  let (heap, globals) = build_initial_heap(codes)
  // start init definition
  let initialState : GState = {
    output: @buffer.new(size_hint=60),
    heap,
    stack: Nil,
    code: @immut/list.of([PushGlobal("main"), Eval, Print]),
    globals,
    stats: 0,
    dump: Nil,
  }
  // end init definition
  GState::reify(initialState)
}

test "basic eval" {
  let basic = []
  for kv in programs.iter() {
    let (_, v) = kv
    basic.push(v)
  }
  let basic = @immut/list.from_array(basic)
  let main = "(defn main[] (take 20 fibs))"
  inspect!(
    run(Cons(main, basic)),
    content="0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181 Nil",
  )
}
```

---

### 文件：`src/part3/vm.mbt`

```moonbit
// Use the 'type' keyword to encapsulate an address type.
type Addr Int derive(Eq, Show)

// Describe graph nodes with an enumeration type.
enum Node {
  NNum(Int)
  // The application node
  NApp(Addr, Addr)
  // To store the number of parameters and 
  // the corresponding sequence of instructions for a super combinator
  NGlobal(String, Int, List[Instruction])
  // The Indirection node，The key component of implementing lazy evaluation
  NInd(Addr)
  NConstr(Int, List[Addr])
} derive(Eq, Show)

struct GHeap {
  // The heap uses an array, 
  // and the space with None content in the array is available as free memory.
  mut object_count : Int
  memory : Array[Node?]
}

// Allocate heap space for nodes.
fn GHeap::alloc(self : GHeap, node : Node) -> Addr {
  let heap = self
  fn next(n : Int) -> Int {
    (n + 1) % heap.memory.length()
  }

  fn free(i : Int) -> Bool {
    match heap.memory[i] {
      None => true
      _ => false
    }
  }

  let mut i = heap.object_count
  while not(free(i)) {
    i = next(i)
  }
  heap.memory[i] = Some(node)
  heap.object_count = heap.object_count + 1
  return Addr(i)
}

fn GHeap::op_get(self : GHeap, key : Addr) -> Node {
  let Addr(i) = key
  match self.memory[i] {
    Some(node) => node
    None => abort("GHeap::get(): index \{i} was empty")
  }
}

fn GHeap::op_set(self : GHeap, key : Addr, val : Node) -> Unit {
  self.memory[key._] = Some(val)
}

struct GState {
  output : @buffer.T
  mut stack : List[Addr]
  heap : GHeap
  globals : @hashmap.T[String, Addr]
  mut dump : List[(List[Instruction], List[Addr])]
  mut code : List[Instruction]
  mut stats : GStats
}

type GStats Int

fn GState::stat_incr(self : GState) -> Unit {
  self.stats = self.stats._ + 1
}

fn GState::put_stack(self : GState, addr : Addr) -> Unit {
  self.stack = Cons(addr, self.stack)
}

fn GState::put_dump(
  self : GState,
  codes : List[Instruction],
  stack : List[Addr]
) -> Unit {
  self.dump = Cons((codes, stack), self.dump)
}

fn GState::put_code(self : GState, instrs : List[Instruction]) -> Unit {
  self.code = instrs + self.code
}

fn GState::pop1(self : GState) -> Addr {
  match self.stack {
    Cons(addr, reststack) => {
      self.stack = reststack
      addr
    }
    Nil => abort("pop1(): stack size smaller than 1")
  }
}

// e1 e2 ..... -> (e1, e2) ......
fn GState::pop2(self : GState) -> (Addr, Addr) {
  match self.stack {
    Cons(addr1, Cons(addr2, reststack)) => {
      self.stack = reststack
      (addr1, addr2)
    }
    _ => abort("pop2(): stack size smaller than 2")
  }
}

fn GState::push_int(self : GState, num : Int) -> Unit {
  let addr = self.heap.alloc(NNum(num))
  self.put_stack(addr)
}

fn GState::push_global(self : GState, name : String) -> Unit {
  guard self.globals.get(name) is Some(addr) else {
    abort("push_global(): cant find supercombinator \{name}")
  }
  self.put_stack(addr)
}

fn GState::push(self : GState, offset : Int) -> Unit {
  // Push(n) a0 : . . . : an : s
  //     =>  an : a0 : . . . : an : s
  let addr = self.stack.unsafe_nth(offset)
  self.put_stack(addr)
}

fn GState::slide(self : GState, n : Int) -> Unit {
  let addr = self.pop1()
  self.stack = Cons(addr, self.stack.drop(n))
}

fn GState::rearrange(self : GState, n : Int) -> Unit {
  let appnodes = self.stack.take(n)
  let args = appnodes.map(fn(addr) {
    guard self.heap[addr] is NApp(_, arg)
    arg
  })
  self.stack = args + appnodes.drop(n - 1)
}

fn GState::mk_apply(self : GState) -> Unit {
  let (a1, a2) = self.pop2()
  let appaddr = self.heap.alloc(NApp(a1, a2))
  self.put_stack(appaddr)
}

fn GState::update(self : GState, n : Int) -> Unit {
  let addr = self.pop1()
  let dst = self.stack.unsafe_nth(n)
  self.heap[dst] = NInd(addr)
}

fn GState::unwind(self : GState) -> Unit {
  let addr = self.pop1()
  match self.heap[addr] {
    NNum(_) =>
      match self.dump {
        Nil => self.put_stack(addr)
        Cons((instrs, stack), rest_dump) => {
          self.stack = stack
          self.put_stack(addr)
          self.dump = rest_dump
          self.code = instrs
        }
      }
    NApp(a1, _) => {
      self.put_stack(addr)
      self.put_stack(a1)
      self.put_code(@immut/list.of([Unwind]))
    }
    // start unwind_g definition
    NGlobal(_, n, c) => {
      let k = self.stack.length()
      if k < n {
        match self.dump {
          Nil => abort("Unwinding with too few arguments")
          Cons((i, s), rest) => {
            // a1 : ...... : ak
            // ||
            // ak : s
            self.stack = self.stack.drop(k - 1) + s
            self.dump = rest
            self.code = i
          }
        }
      } else {
        if n != 0 {
          self.rearrange(n)
        } else {
          self.put_stack(addr)
        }
        self.put_code(c)
      }
    }
    // end unwind_g definition
    NInd(a) => {
      self.put_stack(a)
      self.put_code(@immut/list.of([Unwind]))
    }
    NConstr(_, _) =>
      match self.dump {
        Nil => abort("Unwinding with too few arguments")
        Cons((i, s), rest) => {
          self.dump = rest
          self.stack = s
          self.code = i
          self.put_stack(addr)
        }
      }
  }
}

fn GState::alloc_nodes(self : GState, n : Int) -> Unit {
  let dummynode : Node = NInd(Addr(-1))
  for i = 0; i < n; i = i + 1 {
    let addr = self.heap.alloc(dummynode)
    self.put_stack(addr)
  }
}

fn GState::eval(self : GState) -> Unit {
  let addr = self.pop1()
  self.put_dump(self.code, self.stack)
  self.stack = @immut/list.of([addr])
  self.code = @immut/list.of([Unwind])
}

fn GState::condition(
  self : GState,
  i1 : List[Instruction],
  i2 : List[Instruction]
) -> Unit {
  let addr = self.pop1()
  match self.heap[addr] {
    NNum(0) =>
      // false
      self.code = i2 + self.code
    NNum(1) =>
      // true
      self.code = i1 + self.code
    otherwise => abort("cond : \{addr} = \{otherwise}")
  }
}

fn GState::negate(self : GState) -> Unit {
  let addr = self.pop1()
  match self.heap[addr] {
    NNum(n) => {
      let addr = self.heap.alloc(NNum(-n))
      self.put_stack(addr)
    }
    otherwise =>
      abort("negate: wrong kind of node \{otherwise}, address \{addr}")
  }
}

fn GState::lift_arith2(self : GState, op : (Int, Int) -> Int) -> Unit {
  let (a1, a2) = self.pop2()
  match (self.heap[a1], self.heap[a2]) {
    (NNum(n1), NNum(n2)) => {
      let newnode = Node::NNum(op(n1, n2))
      let addr = self.heap.alloc(newnode)
      self.put_stack(addr)
    }
    (node1, node2) => abort("liftArith2: \{a1} = \{node1} \{a2} = \{node2}")
  }
}

fn GState::lift_cmp2(self : GState, op : (Int, Int) -> Bool) -> Unit {
  let (a1, a2) = self.pop2()
  match (self.heap[a1], self.heap[a2]) {
    (NNum(n1), NNum(n2)) => {
      let flag = op(n1, n2)
      let newnode = if flag { Node::NNum(1) } else { Node::NNum(0) }
      let addr = self.heap.alloc(newnode)
      self.put_stack(addr)
    }
    (node1, node2) => abort("liftCmp2: \{a1} = \{node1} \{a2} = \{node2}")
  }
}

// start split_pack definition
fn GState::pack(self : GState, t : Int, n : Int) -> Unit {
  let addrs = self.stack.take(n)
  self.stack = self.stack.drop(n)
  let addr = self.heap.alloc(NConstr(t, addrs))
  self.put_stack(addr)
}

fn GState::split(self : GState) -> Unit {
  let addr = self.pop1()
  match self.heap[addr] {
    NConstr(_, addrs) =>
      // n == addrs.length()
      self.stack = addrs + self.stack
    _ => panic()
  }
}
// end split_pack definition

// start casejump definition
fn GState::casejump(self : GState, table : List[(Int, List[Instruction])]) -> Unit {
  let addr = self.pop1()
  match self.heap[addr] {
    NConstr(t, _) =>
      match table.lookup(t) {
        None => abort("casejump")
        Some(instrs) => {
          self.code = instrs + self.code
          self.put_stack(addr)
        }
      }
    otherwise => abort("casejump(): addr = \{addr} node = \{otherwise}")
  }
}
// end casejump definition

// start gprint definition
fn GState::gprint(self : GState) -> Unit {
  let addr = self.pop1()
  match self.heap[addr] {
    NNum(n) => {
      self.output.write_string(n.to_string())
      self.output.write_char(' ')
    }
    NConstr(0, Nil) => self.output.write_string("Nil")
    NConstr(1, Cons(addr1, Cons(addr2, Nil))) => {
      self.code = @immut/list.of([Instruction::Eval, Print, Eval, Print]) +
        self.code
      self.put_stack(addr2)
      self.put_stack(addr1)
    }
    _ => panic()
  }
}
// end gprint definition

fn build_initial_heap(
  scdefs : List[(String, Int, List[Instruction])]
) -> (GHeap, @hashmap.T[String, Addr]) {
  let heap = { object_count: 0, memory: Array::make(10000, None) }
  let globals = @hashmap.new(capacity=50)
  loop scdefs {
    Nil => ()
    Cons((name, arity, instrs), rest) => {
      let addr = heap.alloc(NGlobal(name, arity, instrs))
      globals[name] = addr
      continue rest
    }
  }
  return (heap, globals)
}

fn GState::step(self : GState) -> Bool {
  match self.code {
    Nil => return false
    Cons(i, rest) => {
      self.code = rest
      self.stat_incr()
      match i {
        PushGlobal(f) => self.push_global(f)
        PushInt(n) => self.push_int(n)
        Push(n) => self.push(n)
        MkApp => self.mk_apply()
        Unwind => self.unwind()
        Update(n) => self.update(n)
        Pop(n) => self.stack = self.stack.drop(n)
        Alloc(n) => self.alloc_nodes(n)
        Eval => self.eval()
        Slide(n) => self.slide(n)
        Add => self.lift_arith2(fn(x, y) { x + y })
        Sub => self.lift_arith2(fn(x, y) { x - y })
        Mul => self.lift_arith2(fn(x, y) { x * y })
        Div => self.lift_arith2(fn(x, y) { x / y })
        Neg => self.negate()
        Eq => self.lift_cmp2(fn(x, y) { x == y })
        Ne => self.lift_cmp2(fn(x, y) { x != y })
        Lt => self.lift_cmp2(fn(x, y) { x < y })
        Le => self.lift_cmp2(fn(x, y) { x <= y })
        Gt => self.lift_cmp2(fn(x, y) { x > y })
        Ge => self.lift_cmp2(fn(x, y) { x >= y })
        Cond(i1, i2) => self.condition(i1, i2)
        Pack(tag, arity) => self.pack(tag, arity)
        CaseJump(alts) => self.casejump(alts)
        Split => self.split()
        Print => self.gprint()
      }
      return true
    }
  }
}

fn GState::reify(self : GState) -> String {
  if self.step() {
    self.reify()
  } else {
    self.output.contents().to_unchecked_string()
  }
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
