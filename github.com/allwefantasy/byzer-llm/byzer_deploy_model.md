## 基于 Ray 的启动和管理模型

byzerllm 支持私有化模型或者SaaS模型的部署。

这里以 deepseek 官方API 为例：

```bash
easy-byzerllm deploy deepseek-chat --token xxxxx --alias deepseek_chat
```

或者跬基流动API:

```bash
easy-byzerllm deploy alibaba/Qwen1.5-110B-Chat --token xxxxx --alias qwen110b_chat
```

将上面的 API KEY 替换成你们自己的。

之后，你就可以在代码里使用  deepseek_chat 或者 qwen110b_chat  访问模型了。

可以使用

```
easy-byzerllm chat <模型别名> <query>
```

来和任何已经部署好的模型进行聊天。


### 硅基流动

```
byzerllm deploy --pretrained_model_type saas/openai \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--num_workers 1 \
--worker_concurrency 1000 \
--infer_params saas.base_url="https://api.siliconflow.cn/v1" saas.api_key=${MODEL_silcon_flow_TOKEN}  saas.model=deepseek-ai/deepseek-v2-chat \
--model deepseek_chat
```

将 saas.model 替换成硅基流动提供的模型名字，然后将 saas.api_key 替换成你自己的key.

### gpt4o

byzerllm deploy --pretrained_model_type saas/openai \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--num_workers 1 \
--worker_concurrency 1000 \
--infer_params saas.api_key=${MODEL_OPENAI_TOKEN} saas.model=gpt-4o \
--model gpt4o_chat

只需要填写 token, 其他的不需要调整。

### Azure gpt4o

byzerllm deploy --pretrained_model_type saas/azure_openai \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--num_workers 1 \
--worker_concurrency 10 \
--infer_params saas.api_type="azure" saas.azure_endpoint="https:/xxx.openai.azure.com/" saas.api_key="xxx" saas.api_version="2024-02-15-preview" saas.azure_deployment="gpt-4o-2024-05-13" saas.model=gpt-4o \
--model gpt4o_chat

主要修改的是 infer_params 里的参数。其他的不用调整。

值得注意的是：

1. saas.azure_endpoint 需要按需修改。
2. saas.azure_deployment="gpt-4o-2024-05-13"  是必须的，根据azure 提供的信息填写。

### Sonnet 3.5

byzerllm deploy --pretrained_model_type saas/claude \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--worker_concurrency 10 \
--num_workers 1 \
--infer_params saas.api_key=${MODEL_CLAUDE_TOEKN} saas.model=claude-3-5-sonnet-20240620 \
--model sonnet_3_5_chat

### AWS Sonnet 3.5

byzerllm deploy --pretrained_model_type saas/aws_bedrock \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--worker_concurrency 10 \
--num_workers 1 \
--infer_params saas.aws_access_key=xxxx saas.aws_secret_key=xxxx saas.region_name=xxxx saas.model_api_version=xxxx saas.model=xxxxx \
--model sonnet_3_5_chat

你可能还需要安装一个驱动：

pip install boto3 

主要修改的是 infer_params 里的参数。其他的不用调整。 

如果 saas.model_api_version 如果没有填写，并且 saas.model 是anthropic 开头的，那么该值默认为：bedrock-2023-05-31。 一般使用默认的即可。

下面是一个更完整的例子：

byzerllm deploy --pretrained_model_type saas/aws_bedrock --cpus_per_worker 0.001 --gpus_per_worker 0 --worker_concurrency 10 --num_workers 1 --infer_params saas.aws_access_key=xxx saas.aws_secret_key=xx saas.region_name=us-east-1 saas.model=anthropic.claude-3-5-sonnet-20240620-v1:0 --model sonnet_3_5_chat

### ollama或者oneapi 

byzerllm deploy  --pretrained_model_type saas/openai \
--cpus_per_worker 0.01 \
--gpus_per_worker 0 \
--num_workers 1 \
--worker_concurrency 10 \
--infer_params saas.api_key=token saas.model=llama3:70b-instruct-q4_0  saas.base_url="http://192.168.3.106:11434/v1/" \
--model ollama_llama3_chat

### 兼容 OpenAI 接口
或者支持标准 OpenAI 的模型，比如 kimi 部署方式如下：

byzerllm deploy --pretrained_model_type saas/official_openai \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--num_workers 1 \
--worker_concurrency 10 \
--infer_params saas.api_key=${MODEL_KIMI_TOKEN} saas.base_url="https://api.moonshot.cn/v1" saas.model=moonshot-v1-32k \
--model kimi_chat

### 阿里云 Qwen系列

阿里云上的模型 qwen:

byzerllm deploy --pretrained_model_type saas/qianwen \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--num_workers 1 \
--worker_concurrency 10 \
--infer_params saas.api_key=${MODEL_QIANWEN_TOKEN}  saas.model=qwen1.5-32b-chat \
--model qwen32b_chat

### 私有开源模型
或者部署一个私有/开源模型：

byzerllm deploy --pretrained_model_type custom/auto \
--infer_backend vllm \
--model_path /home/winubuntu/models/Qwen-1_8B-Chat \
--cpus_per_worker 0.001 \
--gpus_per_worker 1 \
--num_workers 1 \
--infer_params backend.max_model_len=28000 \
--model qwen_1_8b_chat

### emb模型：
比如Qwen系列：
byzerllm deploy --pretrained_model_type saas/qianwen \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--num_workers 2 \
--infer_params saas.api_key=${MODEL_QIANWEN_TOKEN}  saas.model=text-embedding-v2 \
--model qianwen_emb

### GPT系列：

byzerllm deploy --pretrained_model_type saas/openai \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--num_workers 1 \
--worker_concurrency 10 \
--infer_params saas.api_key=${MODEL_OPENAI_TOKEN} saas.model=text-embedding-3-small \
--model gpt_emb

### 私有 BGE 等：

!byzerllm deploy --pretrained_model_type custom/bge \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--worker_concurrency 10 \
--model_path /home/winubuntu/.auto-coder/storage/models/AI-ModelScope/bge-large-zh \
--infer_backend transformers \
--num_workers 1 \
--model emb

### 多模态部署

OpenAI 语音转文字模型：

byzerllm deploy --pretrained_model_type saas/openai \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--num_workers 1 \
--worker_concurrency 10 \
--infer_params saas.model=whisper-1 saas.api_key=${MODEL_OPENAI_TOKEN} \
--model voice2text

Open Whisper 语音转文字模型部署

byzerllm deploy --pretrained_model_type custom/whisper \
--infer_backend transformers \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--num_workers 1 \
--model_path <Whiper模型的地址>  \
--model voice2text
如果有GPU，记得 `--gpus_per_worker 0` 也设置为 1。CPU 还是比较慢的。

SenseVoice 语音转文字模型

byzerllm deploy --pretrained_model_type custom/sensevoice \
--infer_backend transformers \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--num_workers 1 \
--model_path <模型的地址>  \
--infer_params vad_model=fsmn-vad vad_kwargs.max_single_segment_time=30000
--model voice2text

注意： infer_params 是可选的。如果你通过  --gpus_per_workers 1  设置了 GPU ,那么 infer_params 参数可以追加一个  device=cuda:0 来使用 GPU。

### 火山引擎语言合成模型：

byzerllm deploy --pretrained_model_type saas/volcengine \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--num_workers 1 \
--infer_params saas.api_key=${MODEL_VOLCANO_TTS_TOKEN} saas.app_id=6503259792 saas.model=volcano_tts \
--model volcano_tts

### 微软语言合成模型：

byzerllm deploy --pretrained_model_type saas/azure \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--num_workers 1 \
--infer_params saas.api_key=${MODEL_AZURE_TTS_TOKEN} saas.service_region=eastus \
--model azure_tts

### OpenAI 语言合成模型：
byzerllm deploy --pretrained_model_type saas/openai \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--num_workers 1 \
--infer_params saas.api_key=${MODEL_OPENAI_TOKEN} saas.model=tts-1 \
--model openai_tts

### OpenAi 图片生成模型：

byzerllm deploy --pretrained_model_type saas/openai \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--num_workers 1 \
--infer_params saas.api_key=${MODEL_OPENAI_TOKEN} saas.model=dall-e-3 \
--model openai_image_gen

### 千问VL模型

byzerllm deploy --pretrained_model_type saas/qianwen_vl \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--num_workers 1 \
--worker_concurrency 10 \
--infer_params saas.api_key=${MODEL_2_QIANWEN_TOKEN}  saas.model=qwen-vl-max \
--model qianwen_vl_max_chat

### 01万物VL模型：

byzerllm deploy  --pretrained_model_type saas/openai  \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--num_workers 1 \
--worker_concurrency 10 \
--infer_params saas.api_key=${MODEL_YI_TOKEN} saas.model=yi-vision saas.base_url=https://api.lingyiwanwu.com/v1 \
--model yi_vl_chat

### CPU部署私有开源模型

byzerllm deploy --pretrained_model_type custom/auto \
--infer_backend llama_cpp \
--cpus_per_worker 0.001 \
--gpus_per_worker 0 \
--num_workers 1 \
--infer_params verbose=true num_gpu_layers=0 \
--model_path /Users/allwefantasy/Downloads/Meta-Llama-3-8B-Instruct-Q4_K_M.gguf \
--model llama_3_chat

现在我们来仔细看看上面的参数。

### 参数解析

--model

给当前部署的实例起一个名字，这个名字是唯一的，用于区分不同的模型。你可以理解为模型是一个模板，启动后的一个模型就是一个实例。比如同样一个 SaaS模型，我可以启动多个实例。每个实例里可以包含多个worker实例。

--pretrained_model_type

定义规则如下：

1. 如果是SaaS模型，这个参数是 saas/xxxxx。 如果你的 SaaS 模型（或者公司已经通过别的工具部署的模型），并且兼容 openai 协议，那么你可以使用 saas/openai，否则其他的就要根据官方文档的罗列来写。 参考这里： https://github.com/allwefantasy/byzer-llm?tab=readme-ov-file#SaaS-Models

    下面是一个兼容 openai 协议的例子,比如 moonshot 的模型：

byzerllm deploy --pretrained_model_type saas/official_openai \
    --cpus_per_worker 0.001 \
    --gpus_per_worker 0 \
    --num_workers 2 \
    --infer_params saas.api_key=${MODEL_KIMI_TOKEN} saas.base_url="https://api.moonshot.cn/v1" saas.model=moonshot-v1-32k \
    --model kimi_chat    

  还有比如如果你使用 ollama 部署的模型，就可以这样部署：

byzerllm deploy  --pretrained_model_type saas/openai \
    --cpus_per_worker 0.01 \
    --gpus_per_worker 0 \
    --num_workers 2 \
    --infer_params saas.api_key=token saas.model=llama3:70b-instruct-q4_0  saas.base_url="http://192.168.3.106:11434/v1/" \
    --model ollama_llama3_chat
 
2. 如果是私有模型，这个参数是是由 --infer_backend 参数来决定的。 如果你的模型可以使用 vllm/llama_cpp 部署，那么 --pretrained_model_type 是一个固定值 custom/auto。 如果你是用 transformers 部署，那么这个参数是 transformers 的模型名称, 具体名称目前也可以参考 https://github.com/allwefantasy/byzer-llm。 通常只有多模态，向量模型才需要使用 transformers 部署，我们大部分都有例子，如果没有的，那么也可以设置为 custom/auto 进行尝试。

--infer_backend

目前支持 vllm/transformers/deepspeed/llama_cpp 四个值。 其中 deepspeed 因为效果不好，基本不用。推荐vllm/llama_cpp 两个。

--infer_params

对于 SaaS 模型，所有的参数都以 saas. 开头，基本兼容 OpenAI 参数。 例如 saas.api_key, saas.model,saas.base_url 等等。
对于所有私有模型，如果使用 vllm 部署，则都以 backend. 开头。 具体的参数则需要参考 vllm 的文档。 对于llama_cpp 部署，则直接配置 llama_cpp相关的参数即可，具体的参数则需要参考 llama_cpp 的文档。

vllm 常见参数：

1. backend.gpu_memory_utilization GPU显存占用比例 默认0.9
2. backend.max_model_len 模型最大长度 会根据模型自动调整。 但是如果你的显存不够模型默认值，需要自己调整。
3. backend.enforce_eager 是否开启eager模式(cuda graph, 会额外占用一些显存来提数) 默认True
4. backend.trust_remote_code 有的时候加载某些模型需要开启这个参数。 默认False

llama_cpp 常见参数：

1. n_gpu_layers 用于控制模型GPU加载模型的层数。默认为 0,表示不使用GPU。尽可能使用GPU，则设置为 -1, 否则设置一个合理的值。（你可以比如从100这个值开始试）
2. verbose 是否开启详细日志。默认为True。

--model_path

--model_path 是私有模型独有的参数， 通常是一个目录，里面包含了模型的权重文件，配置文件等等。

--num_workers

--num_workers 是指定部署实例的数量。 以backend  vllm 为例，默认一个worker就是一个vllm实例，支持并发推理，所以通常可以设置为1。 如果是SaaS模型，则一个 worker 只支持一个并发，你可以根据你的需求设置合理数目的 worker 数量。

byzerllm 默认使用 LRU 策略来进行worker请求的分配。

--cpus_per_worker

--cpus_per_worker 是指定每个部署实例的CPU核数。 如果是SaaS模型通常是一个很小的值，比如0.001。


--gpus_per_worker

--gpus_per_worker 是指定每个部署实例的GPU核数。 如果是SaaS模型通常是0。

### 监控部署状态

你可以通过 byzerllm stat 来查看当前部署的模型的状态。

比如：

byzerllm stat --model gpt3_5_chat

输出：

Command Line Arguments:
--------------------------------------------------
command             : stat
ray_address         : auto
model               : gpt3_5_chat
file                : None
--------------------------------------------------
2024-05-06 14:48:17,206 INFO worker.py:1564 -- Connecting to existing Ray cluster at address: 127.0.0.1:6379...
2024-05-06 14:48:17,222 INFO worker.py:1740 -- Connected to Ray cluster. View the dashboard at 127.0.0.1:8265
{
    "total_workers": 3,
    "busy_workers": 0,
    "idle_workers": 3,
    "load_balance_strategy": "lru",
    "total_requests": [
        33,
        33,
        32
    ],
    "state": [
        1,
        1,
        1
    ],
    "worker_max_concurrency": 1,
    "workers_last_work_time": [
        "631.7133535240428s",
        "631.7022202090011s",
        "637.2349605050404s"
    ]
}

解释下上面的输出：

1. total_workers: 模型gpt3_5_chat的实际部署的worker实例数量
2. busy_workers: 正在忙碌的worker实例数量
3. idle_workers: 当前空闲的worker实例数量
4. load_balance_strategy: 目前实例之间的负载均衡策略
5. total_requests: 每个worker实例的累计的请求数量
6. worker_max_concurrency: 每个worker实例的最大并发数
7. state: 每个worker实例当前空闲的并发数（正在运行的并发=worker_max_concurrency-当前state的值）
8. workers_last_work_time: 每个worker实例最后一次被调用的截止到现在的时间
