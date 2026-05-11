# 🌉 ai-bridge

[한국어 README](./README.ko.md)
> **Your MacBook is the AI brain.**
> **Your Linux server stays the workspace.**

ai-bridge is an **AI compute locality separation architecture** that physically decouples your local AI inference from your corporate codebase.

---

## 😩 The Problem

Modern AI coding tools (Roo Code, Cline, Continue) are incredibly hungry. They demand:
- Local GPUs & Unified Memory
- Local models (Ollama, MLX, vLLM)
- Vector databases & Indexing
- Heavy agent runtimes

But as a professional developer, you also want:
- **Company source code to stay strictly on secure Linux servers**
- Isolated & reproducible work environments (Docker, k8s)
- A lightweight laptop that doesn't drain its battery on heavy runtimes
- Zero complex AI setup on locked-down corporate machines

You are often forced to choose: put everything on your Mac (violating security and bloating your system), or put everything on the remote server (lacking GPU, suffering painful latency).

**`ai-bridge` splits the problem cleanly.**

---

## 🧠 Core Philosophy: AI Compute Locality Separation

This project is not just an SSH wrapper or a simple Ollama installer. It is an architecture.

```text
MacBook  = AI Brain     (Pure Inference & UI)
Linux    = Workspace    (Code, Execution, MCP)
```

By separating the **Brain** and the **Hands**, you get the best of both worlds: the massive Unified Memory of Apple Silicon for running heavy models (like Qwen2.5 or DeepSeek), and the robust, secure, containerized environment of Linux for executing the actual code.

---

## 🏗️ Real Workflow

**1. MacBook (The Brain)**
- Runs Ollama or MLX (Apple Silicon optimized)
- Loads Models locally (`Qwen2.5-Coder`, `DeepSeek-Coder`)
- UI Interfaces (OpenWebUI, etc.)

**2. Ubuntu Server (The Hands)**
- Company source code
- MCP (Model Context Protocol) servers
- Docker & Application Runtimes
- Database

**3. VSCode (The Bridge)**
- Runs on your MacBook
- Remote-SSH into Ubuntu Server
- AI Agent requests on Ubuntu are automatically routed back to your MacBook's inference engine via a secure Reverse Tunnel.

---

## 🚀 5-Minute Quick Start

Experience the "Aha!" moment in under 5 minutes.

### 1. The Brain (MacBook)
```bash
git clone https://github.com/yoonCY/ai-bridge.git
cd ai-bridge
./install/mac-native/setup-client.sh
```

### 2. The Hands (Ubuntu Server)
```bash
# SSH into your server, then:
git clone https://github.com/yoonCY/ai-bridge.git
cd ai-bridge
./install/mac-native/setup-server.sh
```

### 3. Start the Bridge
```bash
# On your MacBook
chmod +x ./ai-bridge
./ai-bridge up
```

### 4. Verify
```bash
# On your Ubuntu Server
curl http://localhost:11434/api/tags
# 💥 Success! Your remote server is now talking to your Mac's GPU.
```

---

## 🔥 Key Features

### 🔄 Auto Reverse Tunnel Daemon (`ai-bridge up`)
Just type `./ai-bridge up`. The daemon handles the rest:
- Creates a secure reverse SSH tunnel
- Auto-reconnects if the connection drops
- Handles MacBook Sleep/Wake cycles gracefully
- Performs automatic healthchecks

### 🛠️ VSCode Auto Setup (`ai-bridge vscode init`)
No more manual configuration. By running:
```bash
./ai-bridge vscode init
```
ai-bridge automatically injects settings like `"ollama.baseUrl": "http://localhost:11434"` into your workspace's `.vscode/settings.json`. Developers can start coding immediately without touching config files.

### 🩺 Health Diagnostics (`ai-bridge doctor`)
Ensure your system meets the ai-bridge architecture requirements:
```bash
./ai-bridge doctor
```
Instantly verify Apple Silicon (MLX), Ollama status, and Reverse Tunnel connectivity.

### 🤖 Official Agent Templates
Find official, optimized prompts and configuration templates (`.clinerules`, `cline_mcp_settings.json`, etc.) for popular AI agents like Roo Code, Cline, and Continue.dev within the `templates/` directory.

### 🌐 Distributed MCP Architecture
Scale beyond a single server with the included `install/docker-compose/distributed-mcp.yml`:
- **MacBook**: Pure Inference Engine
- **Linux A**: Workspace / Runtime (VSCode Remote)
- **Linux B**: MCP Gateway (Tools & Context Provider)
- **Linux C**: Vector Memory (Qdrant)

### 🔒 Zero Trust & Maximum Security
**Code never lives on the MacBook.**
- Your laptop remains a thin client.
- All AI communication happens over an encrypted SSH tunnel.
- No extra ports are opened to the outside world; everything binds to `localhost`.
- Perfect for freelancers, enterprise developers, and security-conscious teams.

### 🪟 Windows / Linux GPU Support
Not on a Mac? We support standard NVIDIA environments too.
Check out `install/docker-compose/` for our unified vLLM/Ollama GPU configurations.

---

## 📌 Roadmap: Remote AI-Native Architecture

This is just the beginning of the Remote AI-native development architecture.

- [x] **v0.1** — Core Separation Layer (Mac Inference ↔ Linux Runtime)
- [x] **v0.2** — Universal Support (MLX Native, Windows/Linux Docker-Compose)
- [ ] **v0.3** — `ai-bridge up` daemon completion & VSCode Auto Config Injection
- [ ] **v0.4** — Official templates for Roo Code, Cline, and Continue
- [ ] **v1.0** — Distributed MCP architecture & Shared Vector Memory

---

## 🤝 Contribution & License

We welcome PRs and Issues to push this architecture forward. 
MIT License.
