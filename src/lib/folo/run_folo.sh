run_folo() {
  local result error_message
  result=$(npx -y --silent --prefer-offline "folocli@${folo_cli_version}" "$@" 2>&1)

  if ! jq -e '.ok == true' <<< "$result" >/dev/null; then
    printf '%s\n' "$result" >&2
    error_message=$(jq -br '.error.message' <<< "$result" 2>/dev/null)
    printf '%s\n' "${error_message:-}"
    return 1
  fi
  jq -br '.data' <<< "$result"
}
