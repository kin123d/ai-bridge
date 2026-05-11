#!/usr/bin/env bash
# Initialize AI Agent presets for the current workspace

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "${SCRIPT_DIR}")"
TEMPLATES_DIR="${PROJECT_ROOT}/templates"

AGENT="${1:-}"

BOLD="\033[1m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
CYAN="\033[36m"
RESET="\033[0m"

if [[ -z "${AGENT}" ]]; then
    echo -e "${RED}✖ Error: Agent name required.${RESET}"
    echo -e "Usage: ${BOLD}ai-bridge init <agent>${RESET}"
    echo -e "Available agents: ${CYAN}roo${RESET}, ${CYAN}cline${RESET}, ${CYAN}continue${RESET}"
    exit 1
fi

case "${AGENT}" in
    roo|roo-code)
        echo -e "${CYAN}▶ Initializing Roo Code preset...${RESET}"
        TARGET_DIR=".roo"
        TEMPLATE_SRC="${TEMPLATES_DIR}/roo-code"
        ;;
    cline)
        echo -e "${CYAN}▶ Initializing Cline preset...${RESET}"
        TARGET_DIR=".cline"
        TEMPLATE_SRC="${TEMPLATES_DIR}/cline"
        ;;
    continue)
        echo -e "${CYAN}▶ Initializing Continue preset...${RESET}"
        TARGET_DIR=".continue"
        TEMPLATE_SRC="${TEMPLATES_DIR}/continue"
        ;;
    *)
        echo -e "${RED}✖ Unknown agent: ${AGENT}${RESET}"
        exit 1
        ;;
esac

if [[ ! -d "${TEMPLATE_SRC}" ]]; then
    echo -e "${RED}✖ Template directory not found: ${TEMPLATE_SRC}${RESET}"
    exit 1
fi

if [[ -d "${TARGET_DIR}" ]]; then
    echo -e "${YELLOW}⚠ Directory ${TARGET_DIR} already exists. Skipping creation to prevent overwrite.${RESET}"
else
    echo -e "Copying templates from ${TEMPLATE_SRC} to ./${TARGET_DIR}/ ..."
    cp -r "${TEMPLATE_SRC}" "./${TARGET_DIR}"
    echo -e "${GREEN}✔ ${AGENT} configuration initialized successfully!${RESET}"
    echo -e "  You can now customize ${BOLD}./${TARGET_DIR}${RESET} for this project."
fi
