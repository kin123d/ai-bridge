# ai-bridge 개발 워크플로우

## 일상적인 개발 흐름

### 1. 아침: MacBook 켜기
- launchd가 자동으로 Ollama + SSH 터널 시작
- 또는 수동: `./bridge/reconnect.sh`

### 2. 코드 작업
```
VSCode → Remote-SSH → ai-bridge-dev → 서버 코드 수정
```

### 3. AI 사용
- Roo/Cline이 `localhost:11434`로 AI 요청
- 자동으로 MacBook Ollama로 라우팅
- 코드는 서버에만 존재

### 4. 상태 확인
```bash
./bridge/healthcheck.sh
```

## 트러블슈팅

### 터널이 끊어짐
```bash
# 1. 상태 확인
./bridge/healthcheck.sh

# 2. 수동 재연결
./bridge/tunnel.sh

# 3. 자동 재연결 모드
./bridge/reconnect.sh
```

### Ollama가 응답 없음
```bash
# MacBook에서
ollama serve  # Ollama 재시작
ollama list   # 모델 확인
```

### 모델 추가
```bash
# MacBook에서
ollama pull deepseek-coder-v2
ollama pull codestral
```

터널이 연결된 상태에서는 서버에서도 즉시 사용 가능.
