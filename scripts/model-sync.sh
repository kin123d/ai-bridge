#!/usr/bin/env bash
# ai-bridge: 모델 목록 동기화 유틸리티
# MacBook의 Ollama 모델 목록을 서버에서 확인합니다.
set -euo pipefail

PORT="${1:-11434}"

echo "🧠 ai-bridge 모델 동기화 상태"
echo "================================"

if ! curl -sf "http://localhost:${PORT}/api/tags" > /dev/null 2>&1; then
  echo "❌ Ollama가 localhost:${PORT}에서 응답하지 않습니다."
  exit 1
fi

echo ""
echo "사용 가능한 모델:"
curl -sf "http://localhost:${PORT}/api/tags" | python3 -c "
import sys, json
data = json.load(sys.stdin)
models = data.get('models', [])
if not models:
    print('  (모델 없음)')
else:
    for m in models:
        size_gb = m.get('size', 0) / (1024**3)
        print(f'  - {m["name"]:30s} ({size_gb:.1f} GB)')
    print(f'\n총 {len(models)}개 모델')
"
echo "================================"
