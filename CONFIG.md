# 配置指南 (Configuration Guide)

本文档详细说明如何配置 Open-AutoGLM（ModelScope API Fork）的各项设置。

---

## 目录

1. [获取 API Key](#获取-api-key)
2. [配置方式](#配置方式)
3. [环境变量说明](#环境变量说明)
4. [Windows 快速配置](#windows-快速配置)
5. [Linux/macOS 配置](#linuxmacos-配置)
6. [测试配置](#测试配置)
7. [常见问题](#常见问题)

---

## 获取 API Key

### 步骤 1: 注册魔搭平台账号

1. 访问 [魔搭社区](https://modelscope.cn/)
2. 点击右上角"登录/注册"
3. 使用手机号或邮箱完成注册

### 步骤 2: 获取 API Token

1. 登录后，点击右上角头像
2. 进入"个人中心" → "访问令牌"或"API Token"
3. 点击"生成新令牌"
4. 复制生成的 Token（格式类似：`ms-xxxxxxxxxxxxxxxxxxxxxxxx`）

### 步骤 3: 确认模型可用

1. 在魔搭平台搜索 `AutoGLM-Phone-9B`
2. 确认模型可用（或使用完整名称：`ZhipuAI/AutoGLM-Phone-9B`）

> **注意：** 魔搭平台的 API 服务可能有使用限制，请查看平台相关说明。

---

## 配置方式

有三种方式配置 API Key，按推荐优先级排序：

### 方式 1: 使用 `.env` 文件（推荐）

**优点：**
- 所有配置集中管理
- 不会被 git 提交（`.env` 在 `.gitignore` 中）
- 支持多个环境变量

**步骤：**

1. 复制模板文件：
```bash
cp .env.example .env
```

2. 编辑 `.env` 文件，填入你的配置：
```env
# ModelScope API 配置
PHONE_AGENT_BASE_URL=https://api-inference.modelscope.cn/v1
PHONE_AGENT_API_KEY=ms-YOUR_ACTUAL_API_KEY_HERE
PHONE_AGENT_MODEL=ZhipuAI/AutoGLM-Phone-9B

# 可选：ADB 设备配置
ADB_DEVICE_ID=your_device_id
```

3. 运行 Agent（会自动读取 `.env`）：
```bash
python main.py "打开微信"
```

### 方式 2: 使用启动脚本（Windows 推荐）

**优点：**
- 一键启动，无需每次输入命令
- 自动激活 conda 环境
- 自动检查 ADB 连接

**步骤：**

1. 复制模板文件：
```cmd
copy start_agent.example.bat start_agent.bat
```

2. 编辑 `start_agent.bat`，找到这一行：
```batch
set PHONE_AGENT_API_KEY=your_modelscope_api_key_here
```

替换为你的真实 API Key：
```batch
set PHONE_AGENT_API_KEY=ms-YOUR_ACTUAL_API_KEY_HERE
```

3. 双击 `start_agent.bat` 或在命令行运行：
```cmd
start_agent.bat
```

### 方式 3: 命令行参数

**优点：**
- 灵活，适合临时测试
- 可以快速切换不同配置

**缺点：**
- 每次都要输入完整命令
- API Key 会在命令历史中留下记录

**用法：**

```bash
python main.py \
    --base-url https://api-inference.modelscope.cn/v1 \
    --apikey ms-YOUR_API_KEY_HERE \
    --model ZhipuAI/AutoGLM-Phone-9B \
    "你的任务描述"
```

---

## 环境变量说明

| 环境变量 | 说明 | 默认值 | 是否必需 |
|---------|------|--------|---------|
| `PHONE_AGENT_BASE_URL` | 模型 API 地址 | `http://localhost:8000/v1` | 是 |
| `PHONE_AGENT_API_KEY` | 魔搭平台 API Token | `EMPTY` | 是 |
| `PHONE_AGENT_MODEL` | 模型名称 | `autoglm-phone-9b` | 是 |
| `PHONE_AGENT_MAX_STEPS` | 每个任务最大步数 | `100` | 否 |
| `PHONE_AGENT_DEVICE_ID` | ADB 设备 ID | (自动检测) | 否 |
| `PHONE_AGENT_LANG` | 提示词语言（cn/en） | `cn` | 否 |
| `PYTHONIOENCODING` | Python 编码（Windows） | `utf-8` | Windows 建议设置 |

### 配置示例

**.env 文件示例：**

```env
# 魔搭平台配置
PHONE_AGENT_BASE_URL=https://api-inference.modelscope.cn/v1
PHONE_AGENT_API_KEY=ms-7b1f75aa-0699-4de8-a2d1-a7b0f598a255
PHONE_AGENT_MODEL=ZhipuAI/AutoGLM-Phone-9B

# Agent 行为配置
PHONE_AGENT_MAX_STEPS=150
PHONE_AGENT_LANG=cn

# Windows 编码设置
PYTHONIOENCODING=utf-8

# ADB 设备（可选，不填则自动检测）
# PHONE_AGENT_DEVICE_ID=192.168.1.100:5555
```

---

## Windows 快速配置

### 完整配置流程

1. **创建启动脚本：**
```cmd
copy start_agent.example.bat start_agent.bat
```

2. **编辑配置（右键 → 编辑）：**
```batch
@echo off
chcp 65001 >nul

REM 激活 conda 环境
call conda activate autoglm

REM 设置你的 API Key
set PHONE_AGENT_BASE_URL=https://api-inference.modelscope.cn/v1
set PHONE_AGENT_API_KEY=ms-你的真实APIKey
set PHONE_AGENT_MODEL=ZhipuAI/AutoGLM-Phone-9B
set PYTHONIOENCODING=utf-8

REM 运行 Agent
python main.py %*
```

3. **测试连接：**
```cmd
start_agent.bat "打开设置"
```

---

## Linux/macOS 配置

### 使用 .env 文件

1. 创建配置文件：
```bash
cp .env.example .env
```

2. 编辑 `.env`：
```bash
nano .env  # 或使用 vim、code 等编辑器
```

3. 填入配置：
```env
PHONE_AGENT_BASE_URL=https://api-inference.modelscope.cn/v1
PHONE_AGENT_API_KEY=ms-你的APIKey
PHONE_AGENT_MODEL=ZhipuAI/AutoGLM-Phone-9B
```

4. 运行 Agent：
```bash
python main.py "打开微信"
```

### 使用 Shell 环境变量

添加到 `~/.bashrc` 或 `~/.zshrc`：

```bash
export PHONE_AGENT_BASE_URL="https://api-inference.modelscope.cn/v1"
export PHONE_AGENT_API_KEY="ms-你的APIKey"
export PHONE_AGENT_MODEL="ZhipuAI/AutoGLM-Phone-9B"
```

重新加载配置：
```bash
source ~/.bashrc  # 或 source ~/.zshrc
```

---

## 测试配置

### 测试 1: 验证 API 连接

运行测试脚本（会自动使用环境变量）：

```bash
python test_modelscope_api.py
```

**预期输出：**
```
正在连接魔搭平台 API...
发送测试请求...

模型回复：
你好！我是AutoGLM Phone Agent...

✅ API 连接测试成功！模型服务正常工作。
```

### 测试 2: 验证思考过程输出

```bash
python test_thinking.py
```

**预期输出：**
```
测试非流式返回是否能保留 <think> 标签...
发送请求...

原始响应内容:
============================================================
<think>当前在桌面，用户要求打开淘宝...</think>
<answer>do(action="Launch", app="淘宝")</answer>
============================================================

✅ 成功：响应包含 <think> 标签
```

### 测试 3: 简单任务测试

```bash
python main.py "打开设置"
```

**预期行为：**
- 手机自动打开"设置"应用
- 终端显示思考过程和执行动作
- 任务完成后显示 ✅ 标记

---

## 常见问题

### Q1: 提示 "未找到 API Key"

**现象：**
```
ValueError: 未找到 API Key！
请设置环境变量 PHONE_AGENT_API_KEY 或创建 .env 文件。
```

**解决方案：**
1. 检查是否创建了 `.env` 文件
2. 检查 `.env` 文件中 `PHONE_AGENT_API_KEY` 是否正确填写
3. Windows 用户检查 `start_agent.bat` 中的配置

### Q2: API 连接失败

**现象：**
```
Model request failed: Connection error
```

**解决方案：**
1. 检查网络连接是否正常
2. 确认 `PHONE_AGENT_BASE_URL` 拼写正确
3. 测试能否访问：`curl https://api-inference.modelscope.cn/v1`
4. 检查魔搭平台服务状态

### Q3: API Key 无效

**现象：**
```
401 Unauthorized
```

**解决方案：**
1. 重新登录魔搭平台检查 Token 是否过期
2. 重新生成新的 API Token
3. 确认复制的 Token 完整（包括 `ms-` 前缀）

### Q4: Windows 编码问题

**现象：**
```
UnicodeEncodeError: 'gbk' codec can't encode character
```

**解决方案：**
在 `start_agent.bat` 或 `.env` 中添加：
```batch
set PYTHONIOENCODING=utf-8
```

### Q5: conda 环境未激活

**现象：**
```
❌ 无法激活 conda 环境 autoglm
```

**解决方案：**
```bash
# 手动创建环境
conda create -n autoglm python=3.10
conda activate autoglm
pip install -r requirements.txt
```

---

## 高级配置

### 使用多个设备

指定设备 ID：

```bash
# 查看已连接设备
adb devices

# 使用特定设备
python main.py --device-id 192.168.1.100:5555 "打开微信"
```

### 自定义模型参数

在 Python 代码中：

```python
from phone_agent.model import ModelConfig

config = ModelConfig(
    base_url="https://api-inference.modelscope.cn/v1",
    api_key="ms-你的APIKey",
    model_name="ZhipuAI/AutoGLM-Phone-9B",
    max_tokens=3000,
    temperature=0.0,  # 降低随机性
    top_p=0.85,
    frequency_penalty=0.2,
)
```

### 切换语言（中文/英文）

```bash
# 使用英文提示词
python main.py --lang en "Open Chrome browser"

# 或设置环境变量
export PHONE_AGENT_LANG=en
```

---

## 安全建议

1. **不要将 API Key 提交到 git：**
   - `.env` 和 `start_agent.bat` 已在 `.gitignore` 中
   - 定期检查：`git status`

2. **定期更换 API Key：**
   - 在魔搭平台删除旧 Token
   - 生成新 Token 并更新配置

3. **不要在公开场合分享：**
   - 截图时隐藏 API Key
   - 日志文件可能包含敏感信息

4. **使用环境变量而非硬编码：**
   - ✅ `os.getenv('PHONE_AGENT_API_KEY')`
   - ❌ `api_key = "ms-xxxxx"`

---

## 相关文档

- [QUICK_START.md](QUICK_START.md) - 快速启动指南
- [README.md](README.md) - 项目文档
- [SECURITY.md](SECURITY.md) - 安全策略

---

如有问题，请提交 Issue 或查看原项目文档：
https://github.com/zai-org/Open-AutoGLM
