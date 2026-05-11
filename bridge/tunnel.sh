#!/usr/bin/env bash
# =============================================================================
# ai-bridge: SSH 리버스 터널 실행 스크립트
# MacBook의 Ollama 포트를 원격 Linux 서버로 터널링합니다.
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF_FILE="${SCRIPT_DIR}/bridge.conf"

# --- 설정 파일 로드 ---
if [[ ! -f "${CONF_FILE}" ]]; then
  echo "❌ bridge.conf를 찾을 수 없습니다."
  echo "  cp bridge.conf.example bridge.conf 후 설정을 입력하세요."
  exit 1
fi
# shellcheck source=/dev/null
source "${CONF_FILE}"

# --- 로그 함수 ---
mkdir -p "${LOG_DIR:-${HOME}/.ai-bridge/logs}"
LOG_FILE="${LOG_DIR:-${HOME}/.ai-bridge/logs}/tunnel.log"

log() {
  local level="$1"; shift
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [${level}] $*" | tee -a "${LOG_FILE}"
}

# --- 사전 조건 검증 ---
check_prereqs() {
  # Ollama 실행 중인지 확인
  if ! curl -sf "http://localhost:${OLLAMA_LOCAL_PORT:-11434}/api/tags" > /dev/null 2>&1; then
    log "ERROR" "Ollama가 localhost:${OLLAMA_LOCAL_PORT:-11434}에서 응답하지 않습니다."
    log "ERROR" "'ollama serve'를 먼저 실행하세요."
    exit 1
  fi
  log "INFO" "✅ Ollama 로컬 서버 정상 확인"

  # SSH 키 확인
  local ssh_key="${BRIDGE_SSH_KEY:-${HOME}/.ssh/ai-bridge}"
  ssh_key="${ssh_key/#\~/$HOME}"
  if [[ ! -f "${ssh_key}" ]]; then
    log "WARN" "SSH 키 ${ssh_key}가 없습니다. 기본 키를 사용합니다."
  fi
}

# --- 기존 터널 종료 ---
kill_existing() {
  local pids
  pids=$(pgrep -f "ssh.*-R.*${OLLAMA_REMOTE_PORT:-11434}.*${BRIDGE_HOST}" 2>/dev/null || true)
  if [[ -n "${pids}" ]]; then
    log "INFO" "기존 터널 프로세스 종료: ${pids}"
    echo "${pids}" | xargs kill 2>/dev/null || true
    sleep 1
  fi
}

# --- 터널 실행 ---
start_tunnel() {
  local ssh_key="${BRIDGE_SSH_KEY:-${HOME}/.ssh/ai-bridge}"
  ssh_key="${ssh_key/#\~/$HOME}"

  local ssh_opts=(
    -fN
    -o "ServerAliveInterval=${SERVER_ALIVE_INTERVAL:-15}"
    -o "ServerAliveCountMax=${SERVER_ALIVE_MAX:-3}"
    -o "ExitOnForwardFailure=yes"
    -o "StrictHostKeyChecking=accept-new"
    -R "${OLLAMA_REMOTE_PORT:-11434}:localhost:${OLLAMA_LOCAL_PORT:-11434}"
  )

  # SSH 키가 존재하면 사용
  if [[ -f "${ssh_key}" ]]; then
    ssh_opts+=(-i "${ssh_key}")
  fi

  # 추가 포트 포워딩
  if [[ -n "${EXTRA_FORWARDS:-}" ]]; then
    IFS=',' read -ra forwards <<< "${EXTRA_FORWARDS}"
    for fw in "${forwards[@]}"; do
      local local_p remote_p
      local_p="$(echo "${fw}" | cut -d: -f1)"
      remote_p="$(echo "${fw}" | cut -d: -f2)"
      ssh_opts+=(-R "${remote_p}:localhost:${local_p}")
    done
  fi

  log "INFO" "터널 시작: localhost:${OLLAMA_LOCAL_PORT:-11434} → ${BRIDGE_HOST}:${OLLAMA_REMOTE_PORT:-11434}"

  ssh "${ssh_opts[@]}" \
    -p "${BRIDGE_PORT:-22}" \
    "${BRIDGE_USER}@${BRIDGE_HOST}"

  log "INFO" "✅ SSH 리버스 터널 연결 완료"
}

# --- 메인 ---
main() {
  log "INFO" "=== ai-bridge 터널 시작 ==="
  check_prereqs
  kill_existing
  start_tunnel
  log "INFO" "=== ai-bridge 터널 활성화 ==="
}

main "$@"
