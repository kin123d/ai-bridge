# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
