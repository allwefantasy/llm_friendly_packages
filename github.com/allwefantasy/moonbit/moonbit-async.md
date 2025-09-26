# MoonBit 异步编程完全指南

MoonBit 异步编程库提供了完整的异步 IO 功能和结构化并发支持。本指南以实用为导向，通过丰富的代码示例介绍异步编程的核心概念和最佳实践。

## 核心特性概览

- **结构化并发**: 任务组管理，自动错误传播和资源清理
- **协作式多任务**: 单线程模型，无需锁机制
- **全面的 IO 支持**: 文件系统、网络、进程、管道操作
- **HTTP/TLS 支持**: 完整的 Web 开发能力
- **任务取消**: 优雅的取消机制和超时控制

## 快速开始

### 安装配置

```bash
moon add moonbitlang/async@0.7.0
```

在 `moon.pkg.json` 中添加所需包：

```json
{
  "import": [
    "moonbitlang/async",
    "moonbitlang/async/socket", 
    "moonbitlang/async/fs",
    "moonbitlang/async/http",
    "moonbitlang/async/process"
  ]
}
```

### 基础异步程序结构

```moonbit
///|
async fn main {
  println("Hello, Async World!")
  @async.sleep(1000)  // 等待 1 秒
  println("Done!")
}
```

**关键变化**: 现在直接使用 `async fn main`，不再需要 `@async.with_event_loop` 包装。

## 异步操作基础

### 核心异步函数

```moonbit
///|
async fn basic_operations() -> Unit {
  // 休眠 - 让出执行权给其他任务
  @async.sleep(500)  // 500 毫秒
  
  // 暂停 - 主动让出执行权
  @async.pause()
  
  // 获取当前时间戳
  let now = @async.now()
  println("当前时间: \{now}")
}
```

### 超时控制

```moonbit
///|
async fn timeout_examples() -> Unit {
  // 超时后抛出错误
  try {
    @async.with_timeout(1000, fn() {
      @async.sleep(2000)  // 会超时
      "不会执行到这里"
    })
  } catch {
    @async.TimeoutError => println("操作超时")
  }
  
  // 超时后返回 None
  let result = @async.with_timeout_opt(1000, fn() {
    @async.sleep(500)
    "成功完成"
  })
  
  match result {
    Some(value) => println("结果: \{value}")
    None => println("操作超时")
  }
}
```

## 结构化并发与任务组

### 任务组基础

```moonbit
///|
async fn task_group_basics() -> Unit {
  @async.with_task_group(fn(group) {
    // 生成后台任务
    group.spawn_bg(fn() {
      @async.sleep(100)
      println("后台任务完成")
    })
    
    // 生成有返回值的任务
    let task = group.spawn(fn() {
      @async.sleep(200)
      42
    })
    
    let result = task.wait()
    println("任务结果: \{result}")
    
    "任务组返回值"
  }) |> println
}
```

### 任务选项控制

```moonbit
///|
async fn task_options() -> Unit {
  @async.with_task_group(fn(group) {
    // 允许失败的任务
    group.spawn_bg(allow_failure=true, fn() {
      @async.sleep(50)
      raise Failure("这个错误不会影响整个任务组")
    })
    
    // 不等待的任务 - 任务组结束时自动取消
    group.spawn_bg(no_wait=true, fn() {
      @async.sleep(10000)  // 很长的任务
      println("这行不会执行")
    })
    
    @async.sleep(100)
    println("任务组正常结束")
  })
}
```

### 错误传播示例

```moonbit
///|
async fn error_propagation() -> Unit {
  try {
    @async.with_task_group(fn(group) {
      group.spawn_bg(fn() {
        @async.sleep(100)
        println("任务 1 正常运行")
      })
      
      group.spawn_bg(fn() {
        @async.sleep(50)
        raise Failure("任务 2 失败")  // 这会导致整个任务组失败
      })
      
      @async.sleep(200)
      println("这行不会执行")
    })
  } catch {
    err => println("任务组失败: \{err}")
  }
}
```

## 文件系统操作

### 文件读写

```moonbit
///|
async fn file_operations() -> Unit {
  // 创建并写入文件
  {
    let file = @fs.create("test.txt", permission=0o644)
    defer file.close()
    file.write("Hello, World!\n第二行内容")
  }
  
  // 读取文件
  {
    let file = @fs.open("test.txt", mode=ReadOnly)
    defer file.close()
    
    let content = file.read_all()
    println("文件内容: \{content}")
    println("文件大小: \{file.size()} 字节")
  }
  
  // 删除文件
  @fs.remove("test.txt")
}
```

### 高级文件操作

```moonbit
///|
async fn advanced_file_ops() -> Unit {
  let file = @fs.open("data.txt", mode=ReadWrite, create=0o644, truncate=true)
  defer file.close()
  
  // 写入数据
  file.write("Line 1\nLine 2\nLine 3\n")
  
  // 移动文件指针
  file.seek(0, mode=FromStart)
  
  // 分块读取
  let buf = FixedArray::make(1024, b'0')
  while file.read(buf) is n && n > 0 {
    let data = buf[:n]
    println("读取 \{n} 字节")
  }
}
```

### 目录操作

```moonbit
///|
async fn directory_operations() -> Unit {
  let dir_file = @fs.open(".", mode=ReadOnly)
  let dir = dir_file.as_dir()
  defer dir.close()
  
  let files = dir.read_all()
  files.sort()
  
  for file in files {
    println("文件: \{file}")
  }
}
```

## 网络编程

### TCP 回显服务器

```moonbit
///|
async fn tcp_echo_server() -> Unit {
  @async.with_task_group(fn(root) {
    let server = @socket.TCPServer::new(@socket.Addr::parse("127.0.0.1:8080"))
    defer server.close()
    
    println("TCP 服务器启动在端口 8080")
    
    for {
      let (conn, addr) = server.accept()
      println("新连接来自: \{addr}")
      
      root.spawn_bg(allow_failure=true, fn() {
        defer {
          conn.close()
          println("连接已关闭")
        }
        
        // 回显所有数据
        conn.write_reader(conn)
      })
    }
  })
}
```

### TCP 客户端

```moonbit
///|
async fn tcp_client() -> Unit {
  let conn = @socket.TCP::new()
  defer conn.close()
  
  conn.connect(@socket.Addr::parse("127.0.0.1:8080"))
  
  // 发送数据
  conn.write("Hello, Server!\n")
  
  // 读取响应
  let buf = FixedArray::make(1024, b'0')
  let n = conn.read(buf)
  let response = buf[:n]
  println("服务器响应: \{response}")
}
```

### UDP 示例

```moonbit
///|
async fn udp_example() -> Unit {
  let sock = @socket.UDP::new()
  defer sock.close()
  
  sock.bind(@socket.Addr::parse("0.0.0.0:9090"))
  
  // 发送数据
  sock.send_to("UDP 消息", @socket.Addr::parse("127.0.0.1:9091"))
  
  // 接收数据
  let buf = FixedArray::make(1024, b'0')
  let (n, from_addr) = sock.recv_from(buf)
  let data = buf[:n]
  println("收到来自 \{from_addr} 的数据: \{data}")
}
```

## HTTP 编程

### HTTP 文件服务器

```moonbit
///|
async fn serve_file(
  conn : @http.ServerConnection,
  file : @fs.File,
  path~ : String,
) -> Unit {
  let content_type = match path {
    [.., .. ".html"] => "text/html"
    [.., .. ".css"] => "text/css"
    [.., .. ".js"] => "text/javascript"
    [.., .. ".png"] => "image/png"
    [.., .. ".jpg"] => "image/jpeg"
    _ => "application/octet-stream"
  }
  
  conn
  ..send_response(200, "OK", extra_headers={ "Content-Type": content_type })
  ..write_reader(file)
  ..end_response()
}

///|
async fn serve_directory(
  conn : @http.ServerConnection,
  dir : @fs.Directory,
  path~ : String,
) -> Unit {
  let files = dir.read_all()
  files.sort()
  
  conn
  ..send_response(200, "OK", extra_headers={ "Content-Type": "text/html" })
  ..write("<!DOCTYPE html><html><body>")
  ..write_string("<h1>目录: \{path}</h1>\n")
  ..write("<ul>")
  
  for file in files {
    let sep = if path.ends_with("/") { "" } else { "/" }
    conn.write_string("<li><a href=\"\{path}\{sep}\{file}\">\{file}</a></li>\n")
  }
  
  conn..write("</ul></body></html>")..end_response()
}

///|
async fn http_file_server() -> Unit {
  let base_path = "."
  let server = @socket.TCPServer::new(@socket.Addr::parse("0.0.0.0:8000"))
  defer server.close()
  
  println("HTTP 文件服务器启动在端口 8000")
  
  @async.with_task_group(fn(ctx) {
    for {
      let (tcp_conn, addr) = server.accept()
      let conn = @http.ServerConnection::new(tcp_conn)
      println("新连接来自: \{addr}")
      
      ctx.spawn_bg(allow_failure=true, fn() {
        defer conn.close()
        
        for {
          let request = conn.read_request()
          
          match request.meth {
            Get => {
              let file = @fs.open(base_path + request.path, mode=ReadOnly) catch {
                _ => {
                  conn
                  ..send_response(404, "Not Found", extra_headers={ "Content-Type": "text/html" })
                  ..write("<h1>404 - 文件未找到</h1>")
                  ..end_response()
                  continue
                }
              }
              defer file.close()
              
              if file.kind() is Directory {
                serve_directory(conn, file.as_dir(), path=request.path)
              } else {
                serve_file(conn, file, path=request.path)
              }
            }
            _ => {
              conn
              ..send_response(405, "Method Not Allowed")
              ..end_response()
            }
          }
        }
      })
    }
  })
}
```

### HTTP 客户端请求

```moonbit
///|
async fn http_client_example() -> Unit {
  // GET 请求
  let (response, body) = @http.get("https://httpbin.org/get")
  println("状态码: \{response.code}")
  println("响应体: \{body}")
  
  // POST 请求
  let post_data = "{ \"key\": \"value\" }"
  let (response, body) = @http.post(
    "https://httpbin.org/post",
    post_data,
    headers=[
      @http.Header("Content-Type", "application/json"),
      @http.Header("User-Agent", "MoonBit-HTTP/1.0")
    ]
  )
  println("POST 响应: \{response.code}")
}
```

## 进程管理

### 基础进程操作

```moonbit
///|
async fn process_operations() -> Unit {
  // 运行简单命令
  let exit_code = @process.run("ls", ["-la"])
  println("命令退出码: \{exit_code}")
  
  // 带环境变量的命令
  @process.run(
    "env",
    [],
    extra_env={ "MY_VAR": "my_value" },
    inherit_env=true
  ) |> ignore
}
```

### 进程间通信

```moonbit
///|
async fn process_communication() -> Unit {
  @async.with_task_group(fn(group) {
    let (read_from_process, write_to_process) = @process.read_from_process()
    defer read_from_process.close()
    
    // 启动进程
    group.spawn_bg(fn() {
      @process.run("grep", ["async"], stdout=write_to_process)
      |> ignore
    })
    
    // 向进程发送数据并读取结果
    group.spawn_bg(fn() {
      write_to_process.write("async programming\nsync programming\nasync example\n")
      write_to_process.close()
    })
    
    // 读取进程输出
    let buf = FixedArray::make(1024, b'0')
    while read_from_process.read(buf) is n && n > 0 {
      let output = buf[:n]
      println("进程输出: \{output}")
    }
  })
}
```

## 高级特性

### 重试机制

```moonbit
///|
async fn retry_examples() -> Unit {
  // 立即重试
  let result1 = @async.retry(Immediate, max_retry=3, fn() {
    if @async.now() % 2 == 0 {
      raise Failure("随机失败")
    }
    "成功"
  })
  
  // 固定延迟重试
  let result2 = @async.retry(FixedDelay(1000), max_retry=5, fn() {
    println("尝试网络请求...")
    // 模拟网络请求
    @async.sleep(100)
    "网络请求成功"
  })
  
  // 指数退避重试
  let result3 = @async.retry(
    ExponentialDelay(initial=100, factor=2.0, maximum=5000),
    max_retry=10,
    fn() {
      println("尝试连接服务...")
      @async.sleep(50)
      "连接成功"
    }
  )
}
```

### 防止取消保护

```moonbit
///|
async fn critical_operations() -> Unit {
  @async.with_timeout(100, fn() {
    @async.protect_from_cancel(fn() {
      // 这个操作不会被取消中断
      println("开始关键操作...")
      @async.sleep(200)  // 即使超时也会完成
      println("关键操作完成")
    })
  }) catch {
    @async.TimeoutError => println("操作超时，但关键部分已完成")
  }
}
```

### 任务组清理

```moonbit
///|
async fn task_group_cleanup() -> Unit {
  @async.with_task_group(fn(group) {
    // 添加清理函数
    group.add_defer(fn() {
      println("执行清理操作")
      // 清理资源
    })
    
    group.spawn_bg(fn() {
      @async.sleep(100)
      raise Failure("任务失败")  // 触发清理
    })
    
    @async.sleep(200)
  }) catch {
    err => println("任务组失败，清理已执行: \{err}")
  }
}
```

## 实用工具与模式

### 命令行参数处理

```moonbit
///|
async fn main {
  let args = @env.args()
  match args {
    [] | [_] => {
      println("用法: program <命令> [参数...]")
      println("命令: server, client, test")
    }
    [_, "server", port] => {
      let port_num = port.to_int() catch { _ => 8080 }
      start_server(port_num)
    }
    [_, "client", host, port] => {
      connect_client(host, port.to_int().unwrap())
    }
    [_, "test"] => {
      run_tests()
    }
    _ => println("未知命令")
  }
}
```

### Cat 工具实现

```moonbit
///|
async fn cat_implementation() -> Unit {
  let args = @env.args()
  match args {
    [] | [_] => {
      // 从标准输入读取
      @pipe.stdout.write_reader(@pipe.stdin)
    }
    [_, .. files] => {
      for file in files {
        if file == "-" {
          @pipe.stdout.write_reader(@pipe.stdin)
        } else {
          let file_handle = @fs.open(file, mode=ReadOnly)
          defer file_handle.close()
          @pipe.stdout.write_reader(file_handle)
        }
      }
    }
  }
}
```

### 异步队列通信

```moonbit
///|
async fn queue_communication() -> Unit {
  @async.with_task_group(fn(group) {
    let queue = @async.Queue::new()
    
    // 生产者任务
    group.spawn_bg(fn() {
      for i in 0..10 {
        queue.put("消息 \{i}")
        @async.sleep(100)
      }
      queue.close()
    })
    
    // 消费者任务
    group.spawn_bg(fn() {
      while queue.get() is Some(msg) {
        println("收到: \{msg}")
      }
      println("队列已关闭")
    })
  })
}
```

## 性能优化与最佳实践

### 1. 资源管理
```moonbit
///|
async fn resource_management() -> Unit {
  // 总是使用 defer 确保资源释放
  let file = @fs.open("data.txt", mode=ReadOnly)
  defer file.close()
  
  let conn = @socket.TCP::new()
  defer conn.close()
  
  // 使用文件和连接...
}
```

### 2. 错误处理策略
```moonbit
///|
async fn error_handling_patterns() -> Unit {
  @async.with_task_group(fn(group) {
    // 关键任务 - 失败时整个任务组失败
    group.spawn_bg(fn() {
      critical_operation()
    })
    
    // 可选任务 - 失败不影响其他任务
    group.spawn_bg(allow_failure=true, fn() {
      optional_operation()
    })
    
    // 后台任务 - 任务组结束时自动取消
    group.spawn_bg(no_wait=true, fn() {
      background_monitoring()
    })
  })
}
```

### 3. 并发控制
```moonbit
///|
async fn concurrency_patterns() -> Unit {
  // 限制并发数量
  @async.with_task_group(fn(group) {
    let semaphore = @async.Queue::new()
    
    // 初始化信号量
    for _ in 0..5 {
      semaphore.put(())
    }
    
    for i in 0..20 {
      group.spawn_bg(fn() {
        let _permit = semaphore.get()  // 获取许可
        defer semaphore.put(())        // 释放许可
        
        // 执行有限并发的任务
        expensive_operation(i)
      })
    }
  })
}
```

### 4. 长时间计算的暂停
```moonbit
///|
async fn long_computation() -> Unit {
  for i in 0..1000000 {
    // 执行计算
    heavy_calculation(i)
    
    // 定期让出执行权
    if i % 1000 == 0 {
      @async.pause()
    }
  }
}
```

## 常见陷阱与注意事项

### 1. 避免阻塞操作
```moonbit
// ❌ 错误 - 阻塞整个程序
fn blocking_operation() {
  // 长时间的同步计算或阻塞 IO
}

// ✅ 正确 - 使用异步操作
async fn non_blocking_operation() {
  // 使用 @async.sleep, @fs.*, @socket.* 等异步 API
  @async.pause()  // 主动让出执行权
}
```

### 2. 正确的错误传播
```moonbit
// ❌ 错误 - 忽略错误
async fn bad_error_handling() {
  risky_operation() catch { _ => () }  // 静默忽略错误
}

// ✅ 正确 - 适当处理错误
async fn good_error_handling() {
  risky_operation() catch {
    err => {
      log_error(err)
      // 根据需要重新抛出或处理
      raise err
    }
  }
}
```

### 3. 任务生命周期管理
```moonbit
// ❌ 错误 - 可能的资源泄漏
async fn bad_task_management() {
  let task = group.spawn(fn() { long_running_task() })
  // 忘记等待任务完成
}

// ✅ 正确 - 明确的生命周期
async fn good_task_management() {
  @async.with_task_group(fn(group) {
    group.spawn_bg(fn() { long_running_task() })
    // 任务组确保所有任务完成
  })
}
```

## 调试与测试

### 日志记录
```moonbit
///|
async fn logging_example() -> Unit {
  @pipe.stderr.write("开始处理请求\n")
  
  try {
    process_request()
  } catch {
    err => {
      @pipe.stderr.write("处理失败: \{err}\n")
      raise err
    }
  }
  
  @pipe.stderr.write("请求处理完成\n")
}
```

### 性能测量
```moonbit
///|
async fn performance_measurement() -> Unit {
  let start = @async.now()
  
  expensive_operation()
  
  let duration = @async.now() - start
  println("操作耗时: \{duration} 毫秒")
}
```

## 总结

MoonBit 异步编程库通过结构化并发提供了强大而安全的异步编程能力：

- **简单**: 直接使用 `async fn main`，无需复杂的事件循环设置
- **安全**: 结构化并发确保无资源泄漏和错误传播
- **高效**: 协作式多任务模型，无锁编程
- **完整**: 涵盖文件、网络、HTTP、进程等所有 IO 需求

掌握任务组的使用模式和错误处理机制是成功使用该库的关键。通过合理的任务分解和资源管理，可以构建出高性能、可维护的异步应用程序。
