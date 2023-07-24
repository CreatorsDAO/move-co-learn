# 0x01 使用 Sui Objects

## 介绍

Sui Move 是一门完全以 object 为中心的编程语言。在Sui上交易的输入与输出都可以是对 objects 的操作。 我们之前就已经在[第一单元的第四课中](https://github.com/RandyPen/sui-move-intro-course-zh/blob/main/unit-one/lessons/4_定制类型与能力.md#定制类型与能力)简单接触过这个概念，Sui objects 是 Sui 存储中的基本单元，所有都会使用 `struct` 关键词开头。

看一个记录学生成绩报告单的例子:

```rust
struct Transcript {
    history: u8,
    math: u8,
    literature: u8,
}
```

上面定义的只是一个常规的 Move struct, 但还不是一个 Sui object. 要使一个定制的 Move 类型实例成为全局存储的 Sui object, 我们还需要添加 `key` 能力以及在 struct 定义时内部添加全局唯一的 `id: UID` 属性。

```rust
use sui::object::{UID};

struct TranscriptObject has key {
    id: UID,
    history: u8,
    math: u8,
    literature: u8,
}
```

## 创建一个 Sui Object

创建一个 Sui object 需要一个唯一ID, 我们可以根据当前 `TxContext` 中的信息，使用 `sui::object::new` 函数来创建一个新的 ID.

在 Sui 当中，每个 object 都必须拥有一个所有者，这个所有者可以是地址，别的 object, 或者就被所有人共享。在我们的例子中，我们想让新建的 `transcriptObject` 属于交易发起者。这可以先使用 `tx_context::sender` 函数获得当前 entry 函数调用者也就是交易发起者 sender 的地址，然后用 Sui framework 中的 `transfer` 函数转移所有权。

在下一节，我们会更深入探讨 object 的所有权。

```rust
use sui::object::{Self};
use sui::tx_context::{Self, TxContext};
use sui::transfer;

public entry fun create_transcript_object(history: u8, math: u8, literature: u8, ctx: &mut TxContext) {
  let transcriptObject = TranscriptObject {
    id: object::new(ctx),
    history,
    math,
    literature,
  };
  transfer::transfer(transcriptObject, tx_context::sender(ctx))
}
```

> *💡注意: Move 支持属性的punning简化，当属性名与绑定的变量名一致的时候，就可以省略属性值的传递。*

# 0x02 Sui Objects 所有权的类型

Sui 中的每个 object 都有所有者的属性来声明所有权。在 Sui Move 中总共有四种类型的所有权。

- 被拥有
  - 被一个地址拥有
  - 被另一个 object 拥有
- 共享
  - 不可变的共享
  - 可变的共享

## 被拥有的 Objects

前两种所有权类型都属于被拥有的 Objects. 在 Sui 中，和共享的 objects 处理方式不同，被拥有的 objects 不需要按全局排序。

### 被一个地址拥有

还是看之前成绩记录单 `transcript` 的例子，这种类型的所有权是很符合直觉的。就像下面这行代码示例那样，这个 object 在创建后被转移到了一个地址，那么该 object 就被该地址所有。

```rust
    transfer::transfer(transcriptObject, tx_context::sender(ctx)) // where tx_context::sender(ctx) is the recipient
```

这段代码中 `transcriptObject` 创建后被转移到了交易发起者的地址。

### 被另一个 object 拥有

要使一个 object 被另一个 object 拥有，可以使用 `dynamic_object_field`. 这个功能我们会在未来的章节中探讨。简单来说，当一个 object 被另一个 object 拥有时，我们可以将其称为 子object. 一个 子object 同样可以在全局存储中使用 object ID 进行查询。

## 共享的 Objects

### 不可变的共享 Objects（只读）

在 Sui 中确定的 objects 不能再被任何人改变，也因此可以被认为没有唯一的所有者，是共享的。在 Sui 中所有已发布的 packages 和 modules 都属于不可变的 objects.

要手动让一个 object 不可变，可以调用下面这个特殊函数:

```rust
    transfer::freeze_object(obj);
```

### 可变的共享 Objects（可读可写）

Sui 里头的共享 objects 可以被任何人读和改。和被拥有的 objects 不一样，共享的 object 交易需要通过共识层协议得到的全局顺序。

要创建一个共享的 object, 可以调用这个方法:

```rust
    transfer::share_object(obj);
```

一旦一个 object 成为了共享的，就会保持可变的状态。任何人都可以通过发起交易去改变这个 object.

# 0x03 参数传递与删除 Object

## 参数传递 (使用 `value`, `ref` 和 `mut ref`)

如果你已经熟悉 Rust 语言，你应该也会熟悉 Rust 的所有权概念。有几个拓展视频: [所有权规则、内存与分配](https://www.bilibili.com/video/BV1hp4y1k7SV?p=16), [所有权与函数](https://www.bilibili.com/video/BV1hp4y1k7SV?p=17), [引用与借用](https://www.bilibili.com/video/BV1hp4y1k7SV?p=18)。

与 Solidity 对比起来，move 语言的一个优点在于，你根据函数的接口就可以判断出这个函数调用会对你的资产做什么操作。看几个例子:

```rust
use sui::object::{Self};

// 你被许可获取分数但不能修改它
public fun view_score(transcriptObject: &TranscriptObject): u8{
    transcriptObject.literature
}

// 你被允许查看和编辑分数，但不能删除它
public entry fun update_score(transcriptObject: &mut TranscriptObject, score: u8){
    transcriptObject.literature = score
}

// 你被允许对分数做任何的操作，包括查看、编辑、删除整个 transcript
public entry fun delete_transcript(transcriptObject: TranscriptObject){
    let TranscriptObject {id, history: _, math: _, literature: _ } = transcriptObject;
    object::delete(id);
}
```

## 删除 Object 与 解包 Struct

上面 `delete_transcript` 方法的例子展现了如何在 Sui 上删除一个 object.

1. 要删除一个 object, 你首先要解包这个 object 并且获取它的 object ID. 解包的操作只能够在定义了这个 object 的 module 内进行。这是为了遵守 Move 的专用结构操作规则:

- struct 类型只能在定义了该 struct 的 module 内创建("打包") 或 销毁("解包")
- struct 的属性也只能在定义了该 struct 的 module 内获取

根据这些规则，如果你想要在定义了该 struct 的 module 之外调整你的 struct, 就需要为这些操作提供 public methods.

1. 在解包 struct 获取它的 ID 之后，可以通过调用 framework 里头的 `object::delete` 方法处理它的 object ID 来实现删除。

> *💡注意: 在上面示例中使用了下划线 `_` 来标注未使用的变量或参数，可以在传入后立即消耗掉它们。*

**这里能找到对应这里的处于开发进展中版本的代码: [WIP transcript.move](https://github.com/RandyPen/sui-move-intro-course-zh/blob/main/unit-two/example_projects/transcript/sources/transcript_1.move_wip)**

# 0x04 Other Links

[Chapter 1 - Object Basics](https://docs.sui.io/devnet/build/programming-with-objects/ch1-object-basics)

[Programming Objects Tutorial Series](https://docs.sui.io/devnet/build/programming-with-objects)

[sui-move-intro-course/1_working_wiith_sui_objects.md at main · sui-foundation/sui-move-intro-course](https://github.com/sui-foundation/sui-move-intro-course/blob/main/unit-two/lessons/1_working_wiith_sui_objects.md)

[sui-move-intro-course/2_ownership.md at main · sui-foundation/sui-move-intro-course](https://github.com/sui-foundation/sui-move-intro-course/blob/main/unit-two/lessons/2_ownership.md)

[sui-move-intro-course/3_parameter_passing_and_object_deletion.md at main · sui-foundation/sui-move-intro-course](https://github.com/sui-foundation/sui-move-intro-course/blob/main/unit-two/lessons/3_parameter_passing_and_object_deletion.md)

[sui-move-intro-course/4_object_wrapping.md at main · sui-foundation/sui-move-intro-course](https://github.com/sui-foundation/sui-move-intro-course/blob/main/unit-two/lessons/4_object_wrapping.md)

[sui-move-intro-course/5_object_wrapping_example.md at main · sui-foundation/sui-move-intro-course](https://github.com/sui-foundation/sui-move-intro-course/blob/main/unit-two/lessons/5_object_wrapping_example.md)

[Objects](https://docs.sui.io/devnet/learn/objects)

# 0x05 视频资料

[2-1 SUI Object_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1RY411v7YU?p=6&vd_source=0227d59b63069a45861538ee3d8ad2aa)

[2-2 所有权_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1RY411v7YU?p=7&vd_source=0227d59b63069a45861538ee3d8ad2aa)

[2-3 参数传递与删除object_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1RY411v7YU?p=8&vd_source=0227d59b63069a45861538ee3d8ad2aa)

[2-4 Object Wrapping_哔哩哔哩_bilibili](https://www.bilibili.com/video/BV1RY411v7YU?p=9&vd_source=0227d59b63069a45861538ee3d8ad2aa)