#!/usr/bin/env bash
# ai-bridge doctor

echo "🩺 ai-bridge Doctor"
echo "-------------------"

OS="$(uname -s)"
ARCH="$(uname -m)"

# 1. OS & Architecture Check
if [[ "$OS" == "Darwin" ]]; then
    if [[ "$ARCH" == "arm64" ]]; then
        echo "✅ OS: macOS Apple Silicon ($ARCH)"
    else
        echo "⚠️ OS: macOS Intel ($ARCH) - Native MLX performance may vary."
    fi
else
    echo "ℹ️ OS: $OS ($ARCH) - Expected if running on Workspace Server."
fi

# 2. Ollama Check
if command -v ollama >/dev/null 2>&1; then
    echo "✅ Ollama: Installed"
    if curl -s http://localhost:11434/api/tags >/dev/null 2>&1; then
        echo "✅ Ollama: Running and reachable"
    else
        echo "⚠️ Ollama: Installed but not reachable at localhost:11434"
    fi
else
    echo "❌ Ollama: Not found in PATH"
fi

# 3. Tunnel Check
if pgrep -f "ssh -N -R 11434:localhost:11434" >/dev/null 2>&1; then
    echo "✅ Bridge: Reverse tunnel is active"
else
    echo "⚠️ Bridge: Reverse tunnel is NOT active. Run './ai-bridge up' if on MacBook."
fi

echo "-------------------"
echo "Diagnosis complete."
