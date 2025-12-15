# Phone Agent 快速启动指南

> **⚠️ 首次使用必读**
>
> 本项目使用魔搭平台 API，你需要：
> 1. 访问 [魔搭平台](https://modelscope.cn/) 获取你自己的 API Key
> 2. 按照下方"配置信息"章节设置你的 API Key
> 3. **不要使用示例中的 API Key - 它仅作占位符用途**

## 当前部署状态

✅ Conda 虚拟环境已创建 (autoglm)
✅ 项目依赖已安装
✅ ADB 设备已连接 (800c5958)
✅ 魔搭平台 API 已配置并测试成功
✅ ADB Keyboard 已安装并启用
✅ 所有功能已正常工作
✅ 已添加任务中断功能（按 'q' 键）

---

## 🛑 如何中断正在执行的任务

### 方式1：按 'q' 键（新功能！）
- 在任务执行过程中，随时按 `q` 键即可优雅地中断任务
- 系统会显示 "⏸️ 任务已被用户中断"
- 任务会立即停止，返回交互模式

### 方式2：Ctrl + C
- 强制中断（如果 'q' 键不响应）
- 会退出整个程序

### 方式3：输入 quit
- 在任务输入提示符处输入 `quit`、`exit` 或 `q`
- 退出交互模式

---

## 使用方式

### 方式1：使用启动脚本（推荐）

**交互模式：**
```cmd
start_agent.bat
```

**单次任务：**
```cmd
start_agent.bat "打开微信"
```

### 方式2：直接运行 Python

```cmd
python main.py --base-url https://api-inference.modelscope.cn/v1 --apikey YOUR_API_KEY_HERE --model ZhipuAI/AutoGLM-Phone-9B "你的任务"
```

---

## 配置信息

> **🔐 安全提示：** 请使用你自己的 API Key！
>
> 1. 复制 `start_agent.example.bat` 为 `start_agent.bat`
> 2. 编辑 `start_agent.bat`，将 `your_modelscope_api_key_here` 替换为你的真实 API Key
> 3. `start_agent.bat` 已在 `.gitignore` 中，不会被提交到 git

| 项目 | 值 |
|------|-----|
| API 地址 | https://api-inference.modelscope.cn/v1 |
| 模型名称 | ZhipuAI/AutoGLM-Phone-9B |
| API Key | 请使用你自己的 API Key（从魔搭平台获取） |
| ADB 设备 | 使用 `adb devices` 查看你的设备 ID |

---

## 使用示例

### 示例1：打开应用并搜索
```cmd
start_agent.bat "打开小红书搜索美食"
```

### 示例2：发送消息
```cmd
start_agent.bat "打开微信，给文件传输助手发送消息：测试成功"
```

### 示例3：购物
```cmd
start_agent.bat "打开淘宝搜索无线耳机"
```

---

## 支持的应用

查看所有支持的应用：
```cmd
python main.py --list-apps
```

包括：微信、QQ、淘宝、京东、拼多多、小红书、抖音、美团、饿了么、bilibili 等 50+ 款应用

---

## 常见问题

### Q: 设备未找到
**解决：**
```cmd
adb kill-server
adb start-server
adb devices
```

### Q: 能打开应用但无法点击
**解决：** 在手机 `设置 → 开发者选项` 中同时开启：
- USB 调试
- USB 调试（安全设置）

### Q: 文本输入不工作
**解决：** 确保已安装并启用 ADB Keyboard

### Q: Windows 编码问题
**解决：** 启动脚本已自动设置 UTF-8 编码

---

## 注意事项

1. **保持手机连接**：使用 USB 数据线连接（支持数据传输）
2. **不要锁屏**：操作过程中保持手机屏幕常亮
3. **网络连接**：确保电脑能访问魔搭平台 API
4. **敏感操作**：涉及支付、密码时会自动请求人工接管
5. **仅供学习**：请遵守使用条款，不得用于非法用途

---

## 下一步

1. ⚠️ **立即安装 ADB Keyboard**（见上方说明）
2. 运行测试任务验证功能：
   ```cmd
   start_agent.bat "打开设置"
   ```
3. 尝试更复杂的任务

---

祝使用愉快！
