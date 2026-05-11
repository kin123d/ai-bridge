# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Global CLI Installer (`install/global.sh`)**: Easily symlink the `ai-bridge` command globally (e.g., `/usr/local/bin`).
- **Agent Initialization (`ai-bridge init [agent]`)**: Auto-inject AI agent configuration templates (Roo, Cline, Continue) into the current workspace.
- **Benchmark & Demo Docs**: Added `docs/benchmark.md` and `docs/demo-scenario.md` to prove zero-latency concepts and demonstrate "Aha!" moments.
- **VSCode Auto Setup (`ai-bridge vscode init`)**: Automatically injects `"ollama.baseUrl"` into `.vscode/settings.json`.
- **Health Diagnostics (`ai-bridge doctor`)**: Instantly verifies Apple Silicon (MLX), Ollama status, and Reverse Tunnel connectivity.
- **Distributed MCP Architecture**: Added `install/docker-compose/distributed-mcp.yml` to define isolated containers for Vector Memory (Qdrant), MCP Gateway, and Workspace.

### Changed
- **Operational UX Enhancement**: Upgraded `ai-bridge` core script into a stylish CLI with ANSI colors, ASCII logos, and robust command aliases (e.g., `down` for `stop`).
- **Ultra-Fast Reconnect**: Optimized `bridge/tunnel.sh` and `bridge/reconnect.sh` with a 15-second `ServerAliveInterval` and exponential backoff to instantly recover from sleep/network drops.
- **Smart Setup Prompts**: Modified `install/mac-native/setup-client.sh` to automatically read existing `bridge.conf` values and use them as defaults, preventing the need to re-enter IP/Port/User credentials on subsequent runs.
- Fixed a minor typo in `install/mac-native/setup-server.sh`.
- **Korean README**: Added `README.ko.md` for Korean developers.

## [0.2.0] - 2026-05-11

### Added
- **AI Compute Locality Separation Architecture**: Completely rebranded README with emotional hook and core philosophy.
- **Universal Installer**: Separated `install/mac-native` and `install/docker-compose`.
- **MLX Support**: Interactive option in `setup-client.sh` to use MLX on Apple Silicon.
- **Docker Compose**: Ready-to-use NVIDIA GPU configurations for Ollama and vLLM on Windows/Linux.
- **CLI Wrapper**: Added `./ai-bridge` root command for `up`, `status`, and `stop` lifecycle management.
- **macOS Daemon**: Added `com.ai-bridge.mlx.plist` example for background MLX execution.

### Changed
- Refactored `install/mac-setup.sh` to `install/mac-native/setup-client.sh`.
- Refactored `install/ubuntu-setup.sh` to `install/mac-native/setup-server.sh`.
- Restructured `README.md` to highlight "Real Workflow" and "Zero Trust Security".

### Removed
- Deprecated hardcoded single-platform installer scripts in root `install/` directory.
