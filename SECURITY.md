# 安全策略 (Security Policy)

本文档说明如何安全地使用本项目，以及如何处理敏感信息。

---

## 🔐 敏感信息保护

### 绝对不要提交的文件

本项目使用 API 凭证才能正常工作。**以下文件包含敏感信息，绝对不能提交到 git 仓库：**

| 文件类型 | 示例 | 包含内容 |
|---------|------|---------|
| 环境配置文件 | `.env` | API Keys、设备 ID |
| 启动脚本 | `start_agent.bat` | 配置好的 API Key |
| 临时配置 | `config.bat`、`activate_env.bat` | 个人环境配置 |
| 测试脚本 | `test_*.py` | 可能包含测试用的 API Key |
| APK 文件 | `ADBKeyboard.apk` | 二进制文件 |

### 已配置的保护措施

本项目的 `.gitignore` 已包含以上文件模式，正常情况下不会被提交。但请务必：

```bash
# 提交前检查
git status

# 确认敏感文件不在待提交列表中
git diff --cached
```

---

## ⚙️ 安全配置实践

### 1. 使用配置模板

✅ **正确做法：**

```bash
# 1. 复制模板文件
cp .env.example .env
cp start_agent.example.bat start_agent.bat

# 2. 编辑副本，填入真实凭证
nano .env

# 3. 副本文件已在 .gitignore 中，不会被提交
```

❌ **错误做法：**

```bash
# 直接修改示例文件
nano .env.example  # 不要这样做！

# 硬编码到源代码
echo 'API_KEY = "ms-xxxxx"' >> phone_agent/config.py  # 危险！
```

### 2. 环境变量优于硬编码

✅ **推荐写法：**

```python
import os

api_key = os.getenv('PHONE_AGENT_API_KEY')
if not api_key:
    raise ValueError("未找到 API Key，请设置环境变量")
```

❌ **不安全写法：**

```python
# 永远不要这样做
api_key = "ms-7b1f75aa-0699-4de8-a2d1-a7b0f598a255"
```

### 3. 检查 git 历史

在首次提交前，确保历史记录中没有泄露凭证：

```bash
# 搜索可能的 API Key
git log -p | grep -i "api_key"
git log -p | grep -E "ms-[a-f0-9-]+"

# 如果发现泄露，建议重新初始化仓库
```

---

## 🛡️ API Key 管理

### 获取和存储

1. **获取 API Key：**
   - 访问 [魔搭平台](https://modelscope.cn/)
   - 个人中心 → 访问令牌
   - 生成并复制 Token

2. **安全存储：**
   ```bash
   # 方式 1: 存储在 .env 文件中
   echo "PHONE_AGENT_API_KEY=ms-你的Token" >> .env

   # 方式 2: 临时设置（当前会话有效）
   export PHONE_AGENT_API_KEY="ms-你的Token"

   # 方式 3: 永久设置（添加到 ~/.bashrc 或 ~/.zshrc）
   echo 'export PHONE_AGENT_API_KEY="ms-你的Token"' >> ~/.bashrc
   ```

### 轮换和撤销

**定期更换 API Key：**

1. 登录魔搭平台
2. 删除旧的 Token
3. 生成新的 Token
4. 更新本地配置文件

**建议频率：**
- 每 3-6 个月更换一次
- 怀疑泄露时立即更换
- 项目公开前必须更换

### 权限最小化

- 仅授予必要的 API 权限
- 不要使用管理员级别的 Token
- 为不同项目使用不同的 Token

---

## 🚨 泄露应对流程

如果不小心将 API Key 提交到了 git：

### 立即行动

1. **撤销泄露的 API Key：**
   ```bash
   # 立即登录魔搭平台删除该 Token
   ```

2. **生成新的 API Key：**
   ```bash
   # 在魔搭平台生成新 Token
   # 更新本地 .env 文件
   ```

3. **清理 git 历史（如果已推送到 GitHub）：**

   **方案 A：重置仓库（最简单）**
   ```bash
   # 删除 .git 目录
   rm -rf .git

   # 重新初始化
   git init
   git add .
   git commit -m "Initial commit"

   # 强制推送（会覆盖远程仓库）
   git push -f origin main
   ```

   **方案 B：使用 BFG 清理工具**
   ```bash
   # 安装 BFG Repo-Cleaner
   # https://rtyley.github.io/bfg-repo-cleaner/

   # 清理包含 API Key 的提交
   bfg --replace-text passwords.txt

   # 强制推送
   git push --force
   ```

### 预防措施

**提交前自查：**

```bash
# 创建 pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash

# 检查是否包含 API Key 模式
if git diff --cached | grep -E "ms-[a-f0-9-]{30,}"; then
    echo "❌ 错误：检测到可能的 API Key！"
    echo "请检查提交内容，移除敏感信息后重试。"
    exit 1
fi
EOF

chmod +x .git/hooks/pre-commit
```

---

## 📋 安全检查清单

在推送到 GitHub 之前，请确认：

- [ ] 所有 API Key 已从源代码中移除
- [ ] `.env` 文件已在 `.gitignore` 中
- [ ] `start_agent.bat` 已在 `.gitignore` 中
- [ ] 测试文件使用环境变量而非硬编码
- [ ] `.env.example` 仅包含占位符（`your_api_key_here`）
- [ ] `start_agent.example.bat` 仅包含占位符
- [ ] 运行 `git status` 确认敏感文件未被跟踪
- [ ] 检查 `git log -p` 确认历史记录干净
- [ ] README 和文档中的示例使用占位符
- [ ] 本地 `.env` 和 `start_agent.bat` 配置正确且能正常工作

### 自动检查脚本

```bash
#!/bin/bash
# verify_security.sh - 安全检查脚本

echo "🔍 开始安全检查..."

# 检查 .gitignore
if ! grep -q ".env" .gitignore; then
    echo "❌ .gitignore 缺少 .env"
    exit 1
fi

# 检查是否有被跟踪的敏感文件
if git ls-files | grep -E "^\.env$|^start_agent\.bat$"; then
    echo "❌ 发现被 git 跟踪的敏感文件！"
    exit 1
fi

# 检查示例文件是否包含真实 API Key
if grep -E "ms-[a-f0-9-]{30,}" .env.example 2>/dev/null; then
    echo "❌ .env.example 包含真实 API Key！"
    exit 1
fi

echo "✅ 安全检查通过"
```

运行检查：
```bash
chmod +x verify_security.sh
./verify_security.sh
```

---

## 🌐 开源前的最终确认

### 第一次开源发布

如果这是你第一次将项目推送到 GitHub：

1. **本地测试：**
   ```bash
   # 确保使用模板配置能正常工作
   cp .env.example .env.test
   # 编辑 .env.test 填入真实 API Key
   # 测试运行
   # 删除测试文件
   ```

2. **检查所有文件：**
   ```bash
   # 查看将要提交的文件
   git add .
   git status

   # 逐个检查
   git diff --cached | less
   ```

3. **创建远程仓库：**
   ```bash
   # 在 GitHub 创建新仓库
   git remote add origin https://github.com/你的用户名/仓库名.git
   git branch -M main
   git push -u origin main
   ```

### 持续维护

每次提交前：

```bash
# 1. 检查状态
git status

# 2. 确认没有敏感文件
ls -la | grep -E "\.env$|start_agent\.bat$"

# 3. 查看将要提交的内容
git diff

# 4. 安全提交
git add 文件名  # 不要用 git add .
git commit -m "描述"
git push
```

---

## 📞 安全问题报告

### 发现安全漏洞？

如果你在本项目中发现安全问题（如泄露的凭证、安全配置错误等），请通过以下方式报告：

**请勿公开披露，而是：**

1. **邮件联系：** [你的邮箱地址]
2. **提供信息：**
   - 问题描述
   - 影响范围
   - 复现步骤
   - 建议修复方案（如有）

我们会在 48 小时内响应，并在修复后公开致谢。

### 负责任的披露流程

1. 报告者私下通知维护者
2. 维护者确认问题
3. 开发并测试修复方案
4. 发布安全补丁
5. 公开披露（给予报告者适当时间）

---

## 🔗 相关资源

- [配置指南](CONFIG.md) - 如何安全配置 API Key
- [快速启动](QUICK_START.md) - 部署步骤
- [.gitignore 最佳实践](https://github.com/github/gitignore)
- [环境变量安全](https://12factor.net/config)

---

## 📜 许可证

本项目继承原项目的 Apache 2.0 许可证。

原项目：https://github.com/zai-org/Open-AutoGLM

---

**记住：安全是一个持续的过程，而不是一次性的任务。**

定期审查你的配置，保持警惕，保护好你的凭证。
