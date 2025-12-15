@echo off
chcp 65001 >nul
echo ========================================
echo   Phone Agent - AutoGLM
echo   Using ModelScope API
echo ========================================
echo.

REM ============================================
REM 配置说明：
REM 1. 复制此文件为 start_agent.bat
REM 2. 将下方的 your_modelscope_api_key_here 替换为你的真实 API Key
REM 3. 访问 https://modelscope.cn/ 获取 API Key
REM ============================================

REM 激活 conda 环境
echo 激活 conda 环境 autoglm...
call conda activate autoglm
if errorlevel 1 (
    echo ❌ 无法激活 conda 环境 autoglm
    echo 请确保已经创建了该环境：conda create -n autoglm python=3.10
    pause
    exit /b 1
)
echo ✅ Conda 环境已激活
echo.

REM 设置环境变量
set PYTHONIOENCODING=utf-8
set PHONE_AGENT_BASE_URL=https://api-inference.modelscope.cn/v1
set PHONE_AGENT_API_KEY=your_modelscope_api_key_here
set PHONE_AGENT_MODEL=ZhipuAI/AutoGLM-Phone-9B

echo 检查 ADB 连接...
adb devices
echo.

echo 配置信息:
echo   API 地址: %PHONE_AGENT_BASE_URL%
echo   模型名称: %PHONE_AGENT_MODEL%
echo.

if "%~1"=="" (
    echo 启动交互模式...
    echo.
    python main.py --base-url %PHONE_AGENT_BASE_URL% --apikey %PHONE_AGENT_API_KEY% --model %PHONE_AGENT_MODEL%
) else (
    echo 执行任务: %*
    echo.
    python main.py --base-url %PHONE_AGENT_BASE_URL% --apikey %PHONE_AGENT_API_KEY% --model %PHONE_AGENT_MODEL% %*
)

pause
