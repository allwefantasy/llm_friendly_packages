
# LLM-Friendly Libraries

## Introduction

When designing a library, we generally focus on human users, including API design and documentation. However, with the rise of large language models (LLMs), more and more business software is being developed using LLMs, coupled with programming tools such as [auto-coder.chat](https://github.com/allwefantasy/auto-coder) to achieve significant development efficiency.

Therefore, an LLM-friendly library refers to a library that can be efficiently used by large language models. LLMs can quickly learn to use the library by reading a single document.

The goal of this project is to allow library authors or users to submit documentation for a library, after which [auto-coder.chat](https://github.com/allwefantasy/auto-coder) users can quickly use the library in the following way.

## Example

The byzer-llm library is an example of an LLM-friendly library, [byzer-llm](https://github.com/allwefantasy/byzer-llm). This project includes features that allow users to quickly interact with large language models and provides a built-in hybrid vector/full-text search engine. We can rapidly develop an LLM-based application using this library.

In auto-coder.chat, we can use this library as follows:

Open the IDE's terminal and enter the following command:

```shell
auto-coder.chat
```

Add the byzer-llm library:
```shell
/lib /add byzer-llm
```

Now, we can use LLMs to automatically generate code based on byzer-llm.

For example, if I want to develop a translation application, I can program like this:

```shell
/coding Develop a translation REST service in src/example1 using fastapi. The interface should accept a text and a target language, and return the translated text. Please use the prompt function for implementation, use the deepseek_chat model, and add a README.md.
```

You can find the result of this example in [./src/example1](./src/example1).

Here is a more complex example： [让大模型使用 byzerllm 从 0 实现RAG应用](https://uelng8wukz.feishu.cn/wiki/KlHVwCilDi7y3LkSRblcAfqynpM)

## How to Submit a Library

You can directly submit a PR to this project, just add a markdown file. The file path should be as follows:

```
./github.com/author_name/library_name/README.md
```

For example, if I submit the documentation for the byzer-llm library, the path would be:

```
./github.com/allwefantasy/byzer-llm/README.md
```

After that, others can directly use the library in auto-coder.chat in the following way:

```shell
/lib /add byzer-llm
```