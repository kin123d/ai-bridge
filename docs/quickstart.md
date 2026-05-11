# ai-bridge 퀴 스타트

## 사전 요구사항

### MacBook
- macOS 12+ (M1/M2/M3/M4)
- Homebrew
- SSH 키 (또는 생성 가능)

### Ubuntu 서버
- Ubuntu 20.04+
- SSH 서버 (sshd)
- Docker (선택적)

## 설치 단계

### Step 1: MacBook 설정 (~3분)

```bash
git clone https://github.com/yoonCY/ai-bridge.git ~/ai-bridge
cd ~/ai-bridge
chmod +x install/mac-setup.sh bridge/*.sh scripts/*.sh
./install/mac-setup.sh
```

스크립트가 자동으로:
1. Ollama 설치
2. SSH 키 생성 및 배포
3. bridge.conf 생성
4. SSH config 설정

### Step 2: Ubuntu 설정 (~1분)

```bash
git clone https://github.com/yoonCY/ai-bridge.git ~/ai-bridge
cd ~/ai-bridge
chmod +x install/ubuntu-setup.sh
./install/ubuntu-setup.sh
```

### Step 3: 터널 연결 (~10초)

```bash
# MacBook에서
./bridge/tunnel.sh
```

### Step 4: 확인

```bash
# MacBook에서
./bridge/healthcheck.sh
```

모든 항목이 "ok"이면 성공!

### Step 5: VSCode 연결

1. VSCode에서 `F1` → `Remote-SSH: Connect to Host`
2. `ai-bridge-dev` 선택
3. 서버의 프로젝트 폴더 열기
4. Roo/Cline/Continue 확장에서 Ollama URL: `http://localhost:11434`

## 자동 시작 설정 (선택)

```bash
# MacBook에서 launchd 서비스 등록
cp launchd/com.ai-bridge.tunnel.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.ai-bridge.tunnel.plist
```

이제 MacBook 로그인 시 터널이 자동으로 시작됩니다.
