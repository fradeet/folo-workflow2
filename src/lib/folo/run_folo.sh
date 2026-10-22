run_folo() {
  local args=("$@")
  result=$(npx -y --silent --prefer-offline "folocli@${folo_cli_version}" "${args[@]}") || return 1
  if [[ ! $(jq -ber .ok <<< "$result") ]]; then
    error_message=$(jq -ber .error.message <<< "$result")
    echo "Request Folo Error: $error_message"
    return 1
  fi
  echo "$(jq -ber .data <<< "$result")"
}
