#!/usr/bin/env bash
# =============================================================================
# ai-bridge: 자동 재연결 데몬
# SSH 터널이 끊어지면 지수 백오프로 자동 재연결합니다.
# autossh가 있으면 사용하고, 없으면 순수 bash 루프로 동작합니다.
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF_FILE="${SCRIPT_DIR}/bridge.conf"

if [[ ! -f "${CONF_FILE}" ]]; then
  echo "❌ bridge.conf를 찾을 수 없습니다."
  exit 1
fi
# shellcheck source=/dev/null
source "${CONF_FILE}"

mkdir -p "${LOG_DIR:-${HOME}/.ai-bridge/logs}"
LOG_FILE="${LOG_DIR:-${HOME}/.ai-bridge/logs}/reconnect.log"

log() {
  local level="$1"; shift
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [${level}] $*" | tee -a "${LOG_FILE}"
}

# --- autossh 모드 ---
run_autossh() {
  log "INFO" "autossh 모드로 실행"
  local ssh_key="${BRIDGE_SSH_KEY:-${HOME}/.ssh/ai-bridge}"
  ssh_key="${ssh_key/#\~/$HOME}"

  local ssh_opts="-o ServerAliveInterval=${SERVER_ALIVE_INTERVAL:-15}"
  ssh_opts+=" -o ServerAliveCountMax=${SERVER_ALIVE_MAX:-3}"
  ssh_opts+=" -o ExitOnForwardFailure=yes"
  ssh_opts+=" -o StrictHostKeyChecking=accept-new"
  if [[ -f "${ssh_key}" ]]; then
    ssh_opts+=" -i ${ssh_key}"
  fi

  export AUTOSSH_GATETIME=0
  export AUTOSSH_POLL=30
  export AUTOSSH_LOGFILE="${LOG_FILE}"

  exec autossh -M 0 -fN \
    ${ssh_opts} \
    -R "${OLLAMA_REMOTE_PORT:-11434}:localhost:${OLLAMA_LOCAL_PORT:-11434}" \
    -p "${BRIDGE_PORT:-22}" \
    "${BRIDGE_USER}@${BRIDGE_HOST}"
}

# --- 순수 bash 루프 모드 ---
run_bash_loop() {
  log "INFO" "bash 루프 모드로 실행 (autossh 없음)"
  local interval="${RECONNECT_INTERVAL:-5}"
  local max_interval="${RECONNECT_MAX_INTERVAL:-300}"
  local current_wait="${interval}"

  while true; do
    log "INFO" "터널 연결 시도..."

    if "${SCRIPT_DIR}/tunnel.sh"; then
      current_wait="${interval}"  # 성공 시 백오프 리셋
      log "INFO" "터널 활성. 상태 모니터링 중..."

      # 터널 프로세스가 살아있는지 감시
      while pgrep -f "ssh.*-R.*${OLLAMA_REMOTE_PORT:-11434}.*${BRIDGE_HOST}" > /dev/null 2>&1; do
        sleep "${SERVER_ALIVE_INTERVAL:-15}"
      done

      log "WARN" "터널 프로세스 종료 감지"
    else
      log "ERROR" "터널 연결 실패"
    fi

    log "INFO" "${current_wait}초 후 재연결..."
    sleep "${current_wait}"

    # 지수 백오프
    current_wait=$((current_wait * 2))
    if (( current_wait > max_interval )); then
      current_wait="${max_interval}"
    fi
  done
}

# --- 메인 ---
main() {
  log "INFO" "=== ai-bridge 재연결 데몬 시작 ==="

  # Ollama 실행 대기
  local retries=0
  while ! curl -sf "http://localhost:${OLLAMA_LOCAL_PORT:-11434}/api/tags" > /dev/null 2>&1; do
    retries=$((retries + 1))
    if (( retries > 30 )); then
      log "ERROR" "Ollama가 시작되지 않습니다. 종료."
      exit 1
    fi
    log "INFO" "Ollama 시작 대기 중... (${retries}/30)"
    sleep 2
  done

  if command -v autossh &>/dev/null; then
    run_autossh
  else
    run_bash_loop
  fi
}

main "$@"
