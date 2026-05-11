# ai-bridge 아키텍처 문서

## 핵심 컨셈

**AI Compute Separation Layer** — AI 추론과 개발 환경을 물리적으로 분리하는 아키텍처.

## 컨포넌트 구성

### MacBook (AI Brain)
| 컨포넌트 | 역할 | 포트 |
|---|---|---|
| Ollama | LLM 서빙 엔진 | 11434 |
| SSH Tunnel Daemon | 리버스 터널 유지 | - |
| Healthcheck | 상태 모니터링 | - |

### Ubuntu Server (Workspace)
| 컨포넌트 | 역할 | 포트 |
|---|---|---|
| SSH Server | 터널 수신/Remote-SSH | 22 |
| Ollama Proxy | 터널링된 엔드포인트 | 11434 (터널) |
| MCP Servers | AI 도구 연동 | - |
| Docker | 컨테이너 런타임 | - |
| PostgreSQL/Redis | 데이터베이스 | 5432/6379 |

## 네트워크 흐름

```
개발자 (VSCode)
    │
    ├── Remote-SSH ──────────→ Ubuntu Server
    │   (코드 편집/실행)            │
    │                             │
    └── AI 요청 (Roo/Cline)        │
        │                         │
        └─→ localhost:11434       │
            │                     │
            └─→ SSH Reverse Tunnel
                │
                └─→ MacBook Ollama (:11434)
```

## SSH 리버스 터널 상세

```bash
# MacBook에서 실행:
ssh -fN \
  -o ServerAliveInterval=30 \
  -o ServerAliveCountMax=3 \
  -o ExitOnForwardFailure=yes \
  -R 11434:localhost:11434 \
  dev@ubuntu-server
```

**동작 원리:**
1. MacBook이 Ubuntu 서버로 SSH 연결
2. `-R 11434:localhost:11434` → 서버의 11434 포트를 MacBook의 11434로 포워딩
3. 서버에서 `curl localhost:11434` → MacBook Ollama로 전달
4. AI 도구(Roo/Cline)가 서버의 localhost:11434로 요청 → 자동으로 MacBook으로 라우팅

## 재연결 전략

1. **autossh 모드** (우선): 설치되어 있으면 자동 사용
2. **Bash 루프 모드** (폴백): 지수 백오프로 재연결 (5s → 10s → 20s → ... → max 300s)
3. **launchd** (영구): macOS 로그인 시 자동 시작
