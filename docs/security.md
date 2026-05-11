# ai-bridge 보안 가이드

## 보안 모델 개요

ai-bridge는 **SSH-native 제로 트러스트** 보안 모델을 따릅니다.

## 핵심 원칙

### 1. 코드 비저장 (Code Never Lands)
- MacBook에 소스코드를 절대 저장하지 않음
- 코드는 Ubuntu 서버에만 존재
- MacBook은 순수하게 AI 추론만 담당

### 2. SSH 전용 통신
- 모든 통신은 SSH 터널 기반
- 추가 포트 개방 없음
- 터널 포트는 `localhost`에만 바인드

### 3. 키 기반 인증
- ED25519 SSH 키 전용
- 패스워드 인증 비활성화 권장
- 키는 `~/.ssh/ai-bridge`에 저장

## 점검표

- [ ] SSH 키 인증만 허용 (`PasswordAuthentication no`)
- [ ] 터널 포트 localhost 전용 바인드
- [ ] `bridge.conf`는 `.gitignore`에 포함
- [ ] SSH 키 파일은 절대 커밋하지 않음
- [ ] Ubuntu 서버 방화벽(ufw) 활성화
