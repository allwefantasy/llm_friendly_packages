# ReactJS + TailwindCSS + Typescript 项目特别说明

## typescript 类型

生成的代码要严格满足 typescript 类型定义,需要注意的代码避免 Parameter 'xxxx' implicitly has an 'any' type 之类的问题。

下面是一些具体的示例：

```typescript
<input className={`text-sm truncate bg-transparent outline-none w-full ${
		activeTerminal === terminal.id ? 'text-white' : 'text-gray-400'
	}`}
	value={terminal.name}
	onDoubleClick={(e) => e.target.select()}
	onChange={(e) => renameTerminal(terminal.id, e.target.value)}
	onBlur={(e) => {
		if (!e.target.value.trim()) {
		renameTerminal(terminal.id, `Terminal ${terminal.id}`);
		}
	}}
	/>
```

上面的不符合 typescript 类型定义，因为 e 么有申明类型， e.target 也没有申明类型。最后会导致
typescript 编译器提示没有 select 方法。

正确的写法应该是：

```typescript
<input className={`text-sm truncate bg-transparent outline-none w-full ${
	activeTerminal === terminal.id ? 'text-white' : 'text-gray-400'
	}`}
	value={terminal.name}
	onDoubleClick={(e) => (e.target as HTMLInputElement).select()}
	onChange={(e) => renameTerminal(terminal.id, (e.target as HTMLInputElement).value)}
	onBlur={(e) => {
	if (!(e.target as HTMLInputElement).value.trim()) {
		renameTerminal(terminal.id, `Terminal ${terminal.id}`);
	}
	}}
/>
```

可以看到 e.target 被申明为 HTMLInputElement 类型，从而满足 typescript 类型定义。


## JSX 标签闭合问题

当输出 SEARCH/REPLACE 模式时，请务必确保代码合并后，标签是闭合的。



