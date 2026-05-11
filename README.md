# 🌉 ai-bridge

> **Run AI locally on your MacBook.**
> **Keep your code and MCP servers on Linux.**

A split AI workspace for developers:
**MacBook for inference, Linux for development.**

---

## 🎯 문제 정의

AI 코딩 시대에 개발자들이 겠는 구조적 딜레마:

| | 회사/Linux 서버 | MacBook (M시리즈) |
|---|---|---|
| ✅ 강점 | 소스코드, MCP, Docker, DB, Runtime | 로컬 LLM, Ollama, GPU/NPU |
| ❌ 약점 | GPU 없음, Ollama 설치 어려움 | 회사코드 저장 부담, 보안 이슈 |

**해결책**: 역할을 물리적으로 분리한다.

```
MacBook  = AI Brain     (추론 전용)
Linux    = Workspace    (코드/실행 전용)
```

---

## 🏗️ 아키텍처

```
┌────────────────────┐
│    MacBook           │
│                      │
│  • Ollama Server      │
│  • Qwen / DeepSeek    │
│  • AI Inference       │
└─────────┬──────────┘
          │ SSH Reverse Tunnel
          │ (:11434 → :11434)
┌─────────▼──────────┐
│  Ubuntu Dev Server   │
│                      │
│  • Source Code        │
│  • MCP Servers        │
│  • Docker / Runtime   │
│  • DB (Postgres)      │
└────────────────────┘
```

**개발자 흐름:**
1. 맥북에서 VSCode 실행
2. Remote-SSH로 Ubuntu 서버 접속
3. 코드는 서버에만 존재 (맥북에 clone 안 함)
4. AI 추론은 SSH 터널을 통해 맥북 Ollama 사용

---

## 🚀 퀴 스타트 (5분)

### 1. MacBook 설정

```bash
git clone https://github.com/yoonCY/ai-bridge.git
cd ai-bridge
chmod +x install/mac-setup.sh
./install/mac-setup.sh
```

### 2. Ubuntu 서버 설정

```bash
# 서버에서 실행
git clone https://github.com/yoonCY/ai-bridge.git
cd ai-bridge
chmod +x install/ubuntu-setup.sh
./install/ubuntu-setup.sh
```

### 3. 터널 시작

```bash
# MacBook에서
./bridge/tunnel.sh

# 또는 자동 재연결 모드
./bridge/reconnect.sh
```

### 4. 상태 확인

```bash
./bridge/healthcheck.sh
```

예상 출력:
```json
{
  "status": "healthy",
  "checks": {
    "ollama_local": "ok",
    "tunnel_process": "ok",
    "remote_ollama": "ok"
  },
  "models": "qwen3:8b,deepseek-coder-v2:latest"
}
```

### 5. VSCode에서 사용

```
F1 → Remote-SSH: Connect to Host → ai-bridge-dev
```

서버의 Roo/Cline/Continue 확장이 `localhost:11434`로 AI 요청 → SSH 터널 → MacBook Ollama

---

## 📁 프로젝트 구조

```
ai-bridge/
├── install/          # 원커맨드 설치 스크립트
│   ├── mac-setup.sh
│   └── ubuntu-setup.sh
├── bridge/           # SSH 터널 관리 (핵심 런타임)
│   ├── tunnel.sh
│   ├── reconnect.sh
│   ├── healthcheck.sh
│   └── bridge.conf.example
├── vscode/           # VSCode 자동 설정
├── launchd/          # macOS 데몬
├── mcp/              # MCP 서버 설정 예제
├── scripts/          # 유틸리티
└── docs/             # 상세 문서
```

---

## 🔒 보안 모델

- **SSH-native**: 모든 통신은 SSH 터널 기반. 추가 포트 개방 없음.
- **코드 비저장**: MacBook에 소스코드 저장 없음. 코드는 서버에만.
- **키 인증 전용**: 패스워드 인증 비활성화 권장.
- **로컬만 바인드**: 터널 포트는 `localhost`에만 바인드.

---

## 📌 로드맵

- [x] **v0.1** — 단일 Mac ↔ 단일 Linux 브릿지 (SSH 터널 + Ollama + VSCode)
- [ ] **v0.2** — Multi-model routing, 성능 메트릭 대시보드
- [ ] **v0.3** — Multi-Mac inference routing, Agent scheduling
- [ ] **v1.0** — Distributed MCP, Shared embeddings, Team AI Bridge

---

## 🤝 컨트리빌션

PR과 Issue를 환영합니다. 자세한 내용은 [docs/](./docs/) 참고.

## 📄 라이선스

MIT License
