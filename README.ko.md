# 🌉 ai-bridge

[English README](./README.md)

> **MacBook은 AI 두뇌로.**
> **Linux 서버는 워크스페이스로.**

ai-bridge는 로컬 AI 추론 환경과 기업용 코드베이스를 물리적으로 분리하는 **AI 컴퓨트 지역성 분리(Compute Locality Separation) 아키텍처**입니다.

---

## 😩 문제점

현대의 AI 코딩 도구들(Roo Code, Cline, Continue 등)은 많은 리소스를 요구합니다:
- 로컬 GPU & 통합 메모리(Unified Memory)
- 로컬 모델 구동 (Ollama, MLX, vLLM)
- 벡터 데이터베이스 및 인덱싱
- 무거운 에이전트 런타임

하지만 전문 개발자로서 우리는 다음을 원합니다:
- **회사의 소스코드는 안전한 Linux 서버에 엄격하게 유지**할 것
- 격리되고 재현 가능한 작업 환경 구성 (Docker, Kubernetes)
- 무거운 런타임으로 배터리를 소모하지 않는 가벼운 랩탑 환경
- 철저하게 통제된 사내망 기기에서도 복잡한 AI 설정 없이 바로 사용

결국 우리는 둘 중 하나를 선택하도록 강요받습니다: 모든 것을 Mac에 몰아넣거나(보안 위반 및 시스템 리소스 부족), 모든 것을 원격 서버에 두거나(GPU 부재, 심각한 지연 시간 발생).

**`ai-bridge`는 이 문제를 깔끔하게 분리하여 해결합니다.**

---

## 🧠 핵심 철학: AI 컴퓨트 지역성 분리

이 프로젝트는 단순한 SSH 래퍼(wrapper)나 Ollama 설치 스크립트가 아닙니다. 하나의 아키텍처 제안입니다.

```text
MacBook  = AI 두뇌      (순수 추론 & UI 역할)
Linux    = 워크스페이스 (코드, 실행, MCP 역할)
```

**두뇌(Brain)**와 **손(Hands)**을 분리함으로써, 무거운 모델(Qwen2.5, DeepSeek 등)을 구동하기 위한 Apple Silicon의 방대한 통합 메모리 이점과, 실제 코드를 실행하고 컨테이너화하기 위한 안전하고 강력한 Linux 환경의 이점을 모두 얻을 수 있습니다.

---

## 🏗️ 실제 워크플로우

**1. MacBook (두뇌)**
- Ollama 또는 MLX 실행 (Apple Silicon 최적화)
- 로컬 모델 로드 (`Qwen2.5-Coder`, `DeepSeek-Coder`)
- UI 인터페이스 제공 (OpenWebUI 등)

**2. Ubuntu Server (손)**
- 회사의 소스코드 위치
- MCP (Model Context Protocol) 서버 구동
- Docker 및 애플리케이션 런타임 실행
- 데이터베이스 구동

**3. VSCode (브릿지)**
- MacBook에서 실행
- Ubuntu 서버로 Remote-SSH 접속
- Ubuntu에서 발생하는 AI 에이전트의 요청은 안전한 리버스 터널(Reverse Tunnel)을 통해 MacBook의 추론 엔진으로 자동 라우팅됨

---

## 🚀 5분 퀵스타트

단 5분 안에 "아하!" 하는 순간을 경험해 보세요.

### 1. 두뇌 환경 (MacBook)
```bash
git clone https://github.com/yoonCY/ai-bridge.git
cd ai-bridge
./install/mac-native/setup-client.sh
```

### 2. 손 환경 (Ubuntu 서버)
```bash
# 서버에 SSH로 접속한 뒤 실행:
git clone https://github.com/yoonCY/ai-bridge.git
cd ai-bridge
./install/mac-native/setup-server.sh
```

### 3. 브릿지 시작
```bash
# MacBook에서 실행
chmod +x ./ai-bridge
./ai-bridge up
```

### 4. 검증
```bash
# Ubuntu 서버에서 실행
curl http://localhost:11434/api/tags
# 💥 성공! 이제 원격 서버가 Mac의 GPU와 통신합니다.
```

---

## 🔥 핵심 기능

### 🔄 자동 리버스 터널 데몬 (`ai-bridge up`)
단순히 `./ai-bridge up`을 입력하세요. 데몬이 나머지를 모두 처리합니다:
- 안전한 리버스 SSH 터널 생성
- 연결이 끊어질 경우 자동 재연결
- MacBook의 잠자기/깨우기(Sleep/Wake) 주기에 우아하게 대응
- 자동 상태 체크(Healthcheck) 수행

### 🛠️ VSCode 자동 설정 (`ai-bridge vscode init`)
더 이상 수동으로 설정할 필요가 없습니다. 다음 명령어를 실행하면:
```bash
./ai-bridge vscode init
```
현재 워크스페이스의 `.vscode/settings.json`에 `ollama.baseUrl` 등 AI 통신에 필요한 필수 설정이 자동 주입됩니다. 개발자는 설정 파일을 건드릴 필요 없이 즉시 코딩을 시작할 수 있습니다.

### 🩺 상태 진단 (`ai-bridge doctor`)
현재 시스템이 `ai-bridge` 아키텍처에 적합한지 헬스체크를 수행합니다.
```bash
./ai-bridge doctor
```
Apple Silicon (MLX), Ollama 구동 상태, 리버스 터널(Bridge) 활성화 여부를 즉시 진단합니다.

### 🤖 공식 에이전트 템플릿 지원
`templates/` 디렉토리 하위에 Roo Code, Cline, Continue.dev 등 인기 있는 AI 에이전트들을 위한 공식 프롬프트와 연결 설정 템플릿(`.clinerules`, `cline_mcp_settings.json` 등)을 제공합니다.

### 🌐 분산 MCP 아키텍처 (Distributed MCP)
단순한 1:1 연결을 넘어, `install/docker-compose/distributed-mcp.yml`을 통해 역할을 분리합니다:
- **MacBook**: 순수 AI 추론 (Inference Engine)
- **Linux A**: 코드 런타임 (VSCode 원격 접속)
- **Linux B**: MCP Gateway (Tools & Context Provider)
- **Linux C**: Vector Memory (Qdrant)

### 🔒 제로 트러스트(Zero Trust) & 최고 수준의 보안
**코드는 절대 MacBook에 저장되지 않습니다.**
- 랩탑은 씬 클라이언트(Thin Client) 역할만 수행합니다.
- 모든 AI 통신은 암호화된 SSH 터널을 통해 이루어집니다.
- 외부로 추가 포트를 개방하지 않습니다. 모든 것은 `localhost`에 바인딩됩니다.
- 프리랜서, 엔터프라이즈 개발자 및 보안을 중시하는 팀에 완벽하게 적합합니다.

### 🪟 Windows / Linux GPU 지원
Mac을 사용하지 않으시나요? 표준 NVIDIA 환경도 지원합니다.
통합된 vLLM/Ollama GPU 설정을 확인하려면 `install/docker-compose/` 디렉토리를 참조하세요.

---

## 📌 로드맵: 원격 AI-Native 아키텍처

이것은 원격 AI 네이티브 개발 아키텍처를 향한 시작에 불과합니다. 향후 다음 단계로 진화합니다.

- [x] **v0.1** — 핵심 분리 레이어 (Mac 추론 ↔ Linux 런타임)
- [x] **v0.2** — 유니버셜 지원 (MLX Native, Windows/Linux Docker-Compose)
- [ ] **v0.3** — `ai-bridge up` 데몬 완성 및 VSCode 원격 자동 설정(Auto Config Injection) 도입
- [ ] **v0.4** — Roo Code, Cline, Continue 등 공식 템플릿 지원
- [ ] **v1.0** — 분산 MCP 아키텍처 (런타임/도구/벡터 메모리 분리) 도입

---

## 🤝 기여 및 라이선스

이 아키텍처를 발전시키기 위한 PR과 Issue를 환영합니다.
MIT 라이선스가 적용됩니다.
