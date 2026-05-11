#!/usr/bin/env bash
# Initialize VSCode configurations for ai-bridge
set -euo pipefail

TARGET_DIR=".vscode"
SETTINGS_FILE="${TARGET_DIR}/settings.json"

echo "🛠️ Initializing VSCode Remote Configuration for ai-bridge..."

mkdir -p "${TARGET_DIR}"

if [[ ! -f "${SETTINGS_FILE}" ]]; then
    echo "Creating new ${SETTINGS_FILE}..."
    cat <<EOF > "${SETTINGS_FILE}"
{
    "ollama.baseUrl": "http://localhost:11434"
}
EOF
else
    echo "Updating existing ${SETTINGS_FILE}..."
    # Simple naive injection
    if ! grep -q '"ollama.baseUrl"' "${SETTINGS_FILE}"; then
        sed -i -e '$ d' "${SETTINGS_FILE}" 2>/dev/null || true
        echo '    ,"ollama.baseUrl": "http://localhost:11434"' >> "${SETTINGS_FILE}"
        echo '}' >> "${SETTINGS_FILE}"
    else
        echo "✅ ollama.baseUrl is already configured."
    fi
fi

echo "✅ VSCode is now configured for AI Compute Locality Separation!"
