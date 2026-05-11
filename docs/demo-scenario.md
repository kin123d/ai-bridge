# AI Bridge Demo Scenario: 5 Minutes to "Aha!"

이 문서는 사용자가 `ai-bridge`의 가치를 가장 직관적으로 느낄 수 있도록 설계된 데모(영상, GIF, 튜토리얼) 시나리오입니다. 
핵심은 **"Ubuntu에서 코딩하지만, Mac의 GPU 자원을 마치 내 로컬(Ubuntu)에 있는 것처럼 쓴다"**는 감각을 전달하는 것입니다.

---

## 🎬 씬 1: 개발 환경 접속 및 한계 확인
1. 터미널 창을 열고 Linux 개발 서버(Ubuntu)에 SSH로 접속합니다.
   ```bash
   ssh dev@linux-server
   ```
2. Ubuntu에는 GPU가 없거나 구형임(예: `nvidia-smi`를 쳤으나 GPU가 없다고 나옴).
3. "이 서버에서 무거운 LLM 기반 에이전트(Roo/Cline)를 돌릴 수 있을까?" 하는 의문을 던집니다.

---

## 🎬 씬 2: ai-bridge Magic (연결)
1. Ubuntu 서버에서 단 한 줄의 명령어를 실행합니다.
   ```bash
   ai-bridge up
   ```
2. 터미널에 세련된 ASCII 로고와 함께 `✔ ai-bridge is up and running` 메시지가 뜹니다.
3. 정말 연결되었는지 즉시 확인합니다.
   ```bash
   curl http://localhost:11434/api/tags
   ```
   *(이 순간, Mac에서 실행 중인 `qwen2.5-coder:32b` 등의 모델 목록이 0.1초 만에 JSON으로 쏟아집니다.)*
   **💡 Aha Moment 1: "와, Mac의 LLM이 Ubuntu 로컬 호스트에 붙었네!"**

---

## 🎬 씬 3: Roo Code 원격 쾌감 (실제 사용)
1. `ai-bridge init roo` 를 입력합니다.
2. 현재 디렉토리에 `.roo/` 세팅이 자동 생성됩니다.
3. VSCode에서 이 Ubuntu 폴더를 Remote-SSH로 엽니다.
4. VSCode 확장 프로그램인 Roo Code를 열고 다음과 같이 프롬프트를 입력합니다.
   > *"현재 디렉토리 구조를 분석하고, Node.js 기반의 간단한 웹 서버 뼈대를 만들어줘."*
5. Roo Code가 즉시 분석을 시작하며 빠른 속도로 코드를 작성합니다.
   *(이 때 영상 하단에 PiP 모드로 Mac의 `btop`이나 `Activity Monitor` 화면을 띄워, 코딩은 Ubuntu에서 진행되지만 GPU VRAM과 연산은 Mac이 100% 부담하고 있는 모습을 교차해서 보여줍니다.)*
   **💡 Aha Moment 2: "무거운 추론은 Mac이 하고, 코딩과 서버 실행은 Linux가 완벽히 분리되어 돌아간다!"**

---

## 🎬 씬 4: 노트북 덮기 (Reconnect 안정성)
1. 데모 중 일부러 Mac의 Wi-Fi를 껐다가 다시 켭니다. (또는 슬립 모드로 진입)
2. Ubuntu 터미널에서 터널링 연결이 끊겼음을 감지하지만, `ai-bridge` 데몬이 자동으로 **"15초 후 재연결..."**을 시도하며 스스로 복구합니다.
3. 다시 `curl` 명령을 날리면 끊김 없이 동작합니다.

---

> [!IMPORTANT]  
> **README 활용 방안:**  
> 위 시나리오 중 **씬 2**와 **씬 3**을 짧은 15초짜리 GIF로 만들어 `README.md` 최상단에 배치하면, 복잡한 아키텍처 다이어그램보다 훨씬 강력한 설득력을 가질 수 있습니다.
