# MoonBit 项目：segment-tree

项目路径：`next/sources/segment-tree`

生成时间：2025-06-05 21:14:15

## 项目目录结构

```
segment-tree/
├── .mooncakes
├── src
│   ├── part1
│   │   ├── moon.pkg.json
│   │   └── top.mbt
│   └── part2
│       ├── moon.pkg.json
│       └── top.mbt
├── target
│   ├── wasm-gc
│   │   └── release
│   │       └── check
│   │           ├── part1
│   │           │   └── part1.mi
│   │           ├── part2
│   │           │   └── part2.mi
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

- 总文件数：7
- 文档文件：1 个
- 代码文件：5 个
- 文本文件：1 个

## 文档文件

### 文件：`README.md`

```markdown
# Segment Tree

Check `tutorial/example/segment-tree`.
```

---

## 代码文件

### 文件：`moon.mod.json`

```json
{
  "name": "moonbit-community/segment-tree",
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

### 文件：`src/part1/moon.pkg.json`

```json
{
    "warn-list": "-4"
}
```

---

### 文件：`src/part1/top.mbt`

```moonbit
// start node definition
enum Node {
  Nil
  Node(Int, Node, Node)
}
// end node definition

impl ToJson for Node with to_json(self) {
  match self {
    Nil => "Nil"
    Node(value, left, right) => {
      let left_json = left.to_json()
      let right_json = right.to_json()
      [Json::number(value.to_double()), left_json, right_json]
    }
  }
}

// start op_add definition
impl Add for Node with op_add(self : Node, v : Node) -> Node {
  match (self, v) {
    (Node(left, _, _), Node(right, _, _)) => Node(left + right, self, v)
    (Node(_), Nil) => self
    (Nil, Node(_)) => v
    (Nil, Nil) => Nil
  }
}
// end op_add definition

// start build definition
fn build(data : ArrayView[Int]) -> Node {
  if data.length() == 1 {
    Node(data[0], Nil, Nil)
  } else {
    let mid = (data.length() + 1) >> 1
    build(data[0:mid]) + build(data[mid:])
  }
}
// end build definition

// start build test
test {
  let tree = build([1, 2, 3, 4, 5][:])
  @json.inspect!(tree, content=[
    15,
    [6, [3, [1, "Nil", "Nil"], [2, "Nil", "Nil"]], [3, "Nil", "Nil"]],
    [9, [4, "Nil", "Nil"], [5, "Nil", "Nil"]],
  ])
}
// end build test

// start query definition
let empty_node : Node = Node(0, Nil, Nil)

fn query(self : Node, l : Int, r : Int, query_l : Int, query_r : Int) -> Node {
  if query_l > r || l > query_r {
    empty_node
  } else if query_l <= l && query_r >= r {
    self
  } else {
    guard self is Node(_, left, right)
    let mid = (l + r) >> 1
    left.query(l, mid, query_l, query_r) +
    right.query(mid + 1, r, query_l, query_r)
  }
}
// end query definition

// start query test

test {
  let tree = build([1, 2, 3, 4, 5][:])
  let sum = match tree.query(1, 5, 1, 3) {
    Node(sum, _, _) => sum
    _ => fail!("Expected Node")
  }
  inspect!(sum, content="6")
}
// end query test
```

---

### 文件：`src/part2/moon.pkg.json`

```json
{
    "warn-list": "-4"
}
```

---

### 文件：`src/part2/top.mbt`

```moonbit
// start data definition
enum Data {
  Data(sum~ : Int, len~ : Int)
}

enum LazyTag {
  Nil
  Tag(Int)
}

enum Node {
  Nil
  Node(data~ : Data, tag~ : LazyTag, left~ : Node, right~ : Node)
}
// end data definition

impl ToJson for Data with to_json(data) {
  let Data(sum~, len~) = data
  [Json::number(sum.to_double()), Json::number(len.to_double())]
}

impl ToJson for LazyTag with to_json(tag) {
  match tag {
    Nil => "Nil"
    Tag(value) => Json::number(value.to_double())
  }
}

impl ToJson for Node with to_json(node) {
  match node {
    Nil => "Nil"
    Node(data~, tag~, left~, right~) => {
      let data_json = data.to_json()
      let tag_json = tag.to_json()
      let left_json = left.to_json()
      let right_json = right.to_json()
      {
        "data": data_json,
        "tag": tag_json,
        "left": left_json,
        "right": right_json,
      }
    }
  }
}

// start op_add definition
impl Add for Data with op_add(self : Data, v : Data) -> Data {
  match (self, v) {
    (Data(sum=a, len=len_a), Data(sum=b, len=len_b)) =>
      Data(sum=a + b, len=len_a + len_b)
  }
}

impl Add for Node with op_add(self : Node, v : Node) -> Node {
  match (self, v) {
    (Node(data=l, ..), Node(data=r, ..)) =>
      Node(data=l + r, tag=Nil, left=self, right=v)
    (Node(_), Nil) => self
    (Nil, Node(_)) => v
    (Nil, Nil) => Nil
  }
}
// end op_add definition

// start lazytag definition
impl Add for LazyTag with op_add(self : LazyTag, v : LazyTag) -> LazyTag {
  match (self, v) {
    (Tag(a), Tag(b)) => Tag(a + b)
    (Nil, t) | (t, Nil) => t
  }
}

fn apply(self : Node, v : LazyTag) -> Node {
  match (self, v) {
    (Node(data=Data(sum=a, len=length), tag~, left~, right~), Tag(v) as new_tag) =>
      Node(
        data=Data(sum=a + v * length, len=length),
        tag=tag + new_tag,
        left~,
        right~,
      )
    (_, Nil) => self
    (Nil, _) => Nil
  }
}
// end lazytag definition

// start build definition
fn build(data : ArrayView[Int]) -> Node {
  if data.length() == 1 {
    Node(data=Data(sum=data[0], len=1), tag=Nil, left=Nil, right=Nil)
  } else {
    let mid = (data.length() + 1) >> 1
    build(data[0:mid]) + build(data[mid:])
  }
}
// end build definition

// start modify definition
fn modify(
  self : Node,
  l : Int,
  r : Int,
  modify_l : Int,
  modify_r : Int,
  tag : LazyTag
) -> Node {
  if modify_l > r || l > modify_r {
    self
  } else if modify_l <= l && modify_r >= r {
    self.apply(tag)
  } else {
    guard self is Node(left~, right~, ..)
    let mid = (l + r) >> 1
    left.modify(l, mid, modify_l, modify_r, tag) +
    right.modify(mid + 1, r, modify_l, modify_r, tag)
  }
}
// end modify definition

// start query definition
let empty_node : Node = Node(
  data=Data(sum=0, len=0),
  tag=Nil,
  left=Nil,
  right=Nil,
)

fn query(self : Node, l : Int, r : Int, query_l : Int, query_r : Int) -> Node {
  if query_l > r || l > query_r {
    empty_node
  } else if query_l <= l && query_r >= r {
    self
  } else {
    guard self is Node(tag~, left~, right~, ..)
    let mid = (l + r) >> 1
    left.apply(tag).query(l, mid, query_l, query_r) +
    right.apply(tag).query(mid + 1, r, query_l, query_r)
  }
}
// end query definition

test {
  let tree = build([1, 2, 3, 4, 5][:])
  @json.inspect!(tree.modify(1, 5, 1, 3, Tag(1)).query(1, 5, 1, 3), content={
    "data": [9, 3],
    "tag": "Nil",
    "left": {
      "data": [9, 3],
      "tag": 1,
      "left": {
        "data": [3, 2],
        "tag": "Nil",
        "left": { "data": [1, 1], "tag": "Nil", "left": "Nil", "right": "Nil" },
        "right": { "data": [2, 1], "tag": "Nil", "left": "Nil", "right": "Nil" },
      },
      "right": { "data": [3, 1], "tag": "Nil", "left": "Nil", "right": "Nil" },
    },
    "right": { "data": [0, 0], "tag": "Nil", "left": "Nil", "right": "Nil" },
  })
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
