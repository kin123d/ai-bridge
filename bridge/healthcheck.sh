#!/usr/bin/env bash
# =============================================================================
# ai-bridge: 헬스체크 스크립트
# 전체 브릿지 상태를 검증하고 JSON으로 결과를 출력합니다.
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF_FILE="${SCRIPT_DIR}/bridge.conf"

if [[ ! -f "${CONF_FILE}" ]]; then
  echo '{"status":"error","message":"bridge.conf not found"}'
  exit 1
fi
# shellcheck source=/dev/null
source "${CONF_FILE}"

# --- 각 항목 검증 ---
check_ollama_local() {
  if curl -sf "http://localhost:${OLLAMA_LOCAL_PORT:-11434}/api/tags" > /dev/null 2>&1; then
    echo "ok"
  else
    echo "fail"
  fi
}

check_tunnel_process() {
  if pgrep -f "ssh.*-R.*${OLLAMA_REMOTE_PORT:-11434}.*${BRIDGE_HOST}" > /dev/null 2>&1; then
    echo "ok"
  else
    echo "fail"
  fi
}

check_remote_ollama() {
  local ssh_key="${BRIDGE_SSH_KEY:-${HOME}/.ssh/ai-bridge}"
  ssh_key="${ssh_key/#\~/$HOME}"
  local ssh_opts=()
  if [[ -f "${ssh_key}" ]]; then
    ssh_opts+=(-i "${ssh_key}")
  fi

  if ssh -o ConnectTimeout=5 "${ssh_opts[@]}" \
    -p "${BRIDGE_PORT:-22}" \
    "${BRIDGE_USER}@${BRIDGE_HOST}" \
    "curl -sf http://localhost:${OLLAMA_REMOTE_PORT:-11434}/api/tags" > /dev/null 2>&1; then
    echo "ok"
  else
    echo "fail"
  fi
}

get_model_list() {
  curl -sf "http://localhost:${OLLAMA_LOCAL_PORT:-11434}/api/tags" 2>/dev/null \
    | python3 -c "import sys,json; data=json.load(sys.stdin); print(','.join(m['name'] for m in data.get('models',[]))  )" 2>/dev/null \
    || echo ""
}

# --- 결과 출력 ---
main() {
  local ollama_local tunnel_process remote_ollama models
  ollama_local="$(check_ollama_local)"
  tunnel_process="$(check_tunnel_process)"
  remote_ollama="$(check_remote_ollama)"
  models="$(get_model_list)"

  local overall="healthy"
  if [[ "${ollama_local}" != "ok" || "${tunnel_process}" != "ok" || "${remote_ollama}" != "ok" ]]; then
    overall="degraded"
  fi
  if [[ "${ollama_local}" == "fail" ]]; then
    overall="down"
  fi

  cat <<EOF
{
  "status": "${overall}",
  "timestamp": "$(date -u '+%Y-%m-%dT%H:%M:%SZ')",
  "checks": {
    "ollama_local": "${ollama_local}",
    "tunnel_process": "${tunnel_process}",
    "remote_ollama": "${remote_ollama}"
  },
  "server": "${BRIDGE_HOST}",
  "models": "${models}"
}
EOF
}

main "$@"
