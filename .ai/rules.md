# ai-bridge - 프로젝트 로컬 규칙

## 1. 개요
MacBook을 AI 추론 전용 워크스테이션으로, Linux 개발서버를 실제 코드/MCP/런타임 환경으로 분리하는 **AI Compute Separation Layer** 인프라 도구입니다.

## 2. 아키텍처 원칙
- **SSH-Native**: 모든 연결은 SSH 터널 기반. 추가 데몬이나 에이전트 설치 최소화.
- **제로 의존성**: 맥북 측에는 Ollama + SSH만. 서버 측에는 Docker + SSH만.
- **코드 비저장 원칙**: MacBook에 소스코드를 저장하지 않는다. 코드는 서버에만 존재.
- **보안 우선**: SSH 키 기반 인증만 허용. 패스워드 인증 비활성화.

## 3. 스크립트 표준
- 모든 쉘 스크립트는 `#!/usr/bin/env bash`로 시작
- `set -euo pipefail` 필수 적용
- ShellCheck 통과 필수
- 주석은 한국어로 작성

## 4. 파일 구조
- `install/` — 원커맨드 설치 스크립트
- `bridge/` — SSH 터널 관리 (핵심 런타임)
- `vscode/` — VSCode 자동 설정
- `launchd/` — macOS 데몬 정의
- `mcp/` — MCP 서버 설정 예제
- `docs/` — 아키텍처/보안/워크플로우 문서
