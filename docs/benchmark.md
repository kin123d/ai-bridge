# AI Bridge Benchmark

> [!NOTE]
> 본 문서는 **MacBook(Apple Silicon)** 기반의 로컬 추론 성능을 **Linux 개발 서버**에서 터널링하여 사용할 때의 성능 손실을 측정하고 비교합니다. 
> "AI Compute Separation Layer" 아키텍처가 실제 코딩 워크플로우에서 얼마나 효율적인지 증명하는 지표입니다.

## 📊 테스트 환경 구성

| 항목 | 사양 | 비고 |
| --- | --- | --- |
| **Brain (Inference)** | MacBook Pro M4 Max (128GB RAM) | Ollama / MLX 실행 |
| **Hands (Runtime)** | Ubuntu 22.04 LTS (Docker) | VSCode Server, Roo Code 실행 |
| **Network** | 로컬 Wi-Fi 6 (802.11ax) | 평균 지연속도 < 5ms |
| **Model** | Qwen2.5-Coder 32B (Q4_K_M) | 윈도우 사이즈 8k |

## 🚀 벤치마크 결과 (예시)

SSH 터널링(ai-bridge)을 통해 원격으로 요청할 때의 오버헤드는 **Token당 생성 속도(TPS)**에 거의 영향을 미치지 않으며, **최초 응답 시간(TTFT)**에만 네트워크 왕복 시간만큼의 미세한 지연이 발생합니다.

| 지표 | Mac 로컬 (Direct) | Linux 원격 (ai-bridge) | 차이 |
| --- | --- | --- | --- |
| **TTFT (Time to First Token)** | 0.85s | 0.89s | `+0.04s` (체감 불가) |
| **TPS (Tokens per Second)** | 42.5 t/s | 42.1 t/s | `-0.4 t/s` (오차 범위 내) |
| **API Call Latency (Ping)** | < 1ms | 4~6ms | 네트워크 환경에 따라 다름 |

> [!TIP]
> **결론:** AI Coding Agent(Roo, Cline)가 100~200줄의 코드를 쏟아낼 때, 체감되는 속도 저하는 **0%**에 가깝습니다. 오히려 무거운 코드 컴파일과 Docker 빌드가 Linux 서버에서 돌기 때문에, Mac의 리소스(배터리, 발열)는 추론에만 100% 집중할 수 있어 전체적인 개발 경험은 훨씬 쾌적해집니다.

## 🛠 성능 측정 방법

본인의 환경에서 직접 벤치마크를 실행해보고 싶다면 아래 명령어를 사용하세요.

```bash
# 1. Mac 로컬에서 직접 측정
curl -w "\nTime_Total: %{time_total}s\n" \
  -X POST http://localhost:11434/api/generate \
  -d '{"model": "qwen2.5-coder:32b", "prompt": "Write a python quicksort", "stream": false}'

# 2. Linux 서버에서 ai-bridge 터널을 통해 측정
curl -w "\nTime_Total: %{time_total}s\n" \
  -X POST http://localhost:11434/api/generate \
  -d '{"model": "qwen2.5-coder:32b", "prompt": "Write a python quicksort", "stream": false}'
```
