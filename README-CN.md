# 大模型友好库

## 介绍 

当我们设计一个库的时候，一般是面向人的，这包括API设计和文档，都会是面向人。然而，虽则大模型的崛起，越来越多的业务软件会使用
大模型来开发，配合诸如 [auto-coder.chat](https://github.com/allwefantasy/auto-coder) 等编程工具可以获得极大的开发效率。

所以，大模型友好库是指，能够被大模型高效使用的库。大模型可以通过阅读该库的一个文档，即可快速上手使用该库。

该项目的目标是，库的作者或者使用者可以提交一个库的文档，之后 [auto-coder.chat](https://github.com/allwefantasy/auto-coder) 使用者就可以通过如下方式快速使用该库.

## 案例

byzer-llm 库是一个大模型友好库的案例，[byzer-llm](https://github.com/allwefantasy/byzer-llm),该项目包含了可以让用户快速的和大模型进行交互，并且提供了内置的向量/全文检索混合引擎。我们可以基于该库快速开发一个基于大模型的应用。

在 auto-coder.chat 中我们可以如下方式使用该库：

打开 IDE 的 terminal，输入如下命令：

```shell
auto-coder.chat
```

添加一个 byzer-llm 库：
```shell
/lib /add byzer-llm
```

现在，我们就可以使用大模型自动生成基于 byzer-llm 的代码了。

比如，我想开发一个翻译应用，我可以这样编程：

```shell
/coding 在 src/example1 中开发一个翻译 Rest 服务，使用 fastapi, 接口接受一段文本和一个目标语言，返回翻译后的文本。请使用 prompt 函数来实现,使用 deepseek_chat模型，并且添加一个使用 README.md.
```

你可以在 [./src/example1](./src/example1) 中找到这个例子的结果。

## 如何提交一个库

可以直接给该项目提交一个 PR , 添加一个markdown文件即可，文件的路径如下：

```
./github.com/作者名/库名/README.md
```

比如我提交了 byzer-llm 库的文档，那么路径就是：

```
./github.com/allwefantasy/byzer-llm/README.md
```

之后其他人就可以直接在 auto-coder.chat 中使用如下方式使用该库了：

```shell
/lib /add byzer-llm
```

