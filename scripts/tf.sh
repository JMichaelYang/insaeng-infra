#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<USAGE
usage: scripts/tf.sh <stack> <init|plan|apply|lock> [args]

  <stack>  a path under stacks/, e.g. foundation/oci or network
USAGE
  exit 2
}

[[ $# -ge 2 ]] || usage
stack=${1%/}
cmd=$2
shift 2

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

case "$stack" in
  "" | /* | *..*) echo "tf.sh: invalid stack: $stack" >&2; usage ;;
esac
if ! compgen -G "$root/stacks/$stack/*.tf" >/dev/null; then
  echo "tf.sh: unknown stack: $stack" >&2
  usage
fi

case "$cmd" in
  init | plan | apply | lock) ;;
  *) echo "tf.sh: unknown command: $cmd" >&2; usage ;;
esac

set -a
# shellcheck source=../common.env
source "$root/common.env"
set +a

if [[ "${GITHUB_ACTIONS:-}" == "true" ]]; then
  auth_args=(-backend-config=auth=ResourcePrincipal)
  export TF_VAR_oci_auth=ResourcePrincipal
else
  auth_args=(-backend-config=auth=SecurityToken -backend-config=config_file_profile=insaeng)
  export TF_VAR_oci_auth=SecurityToken TF_VAR_oci_profile=insaeng
fi

case "$stack" in
  foundation/*) backend="$root/backend/foundation.hcl" ;;
  *) backend="$root/backend/ci.hcl" ;;
esac

tf=(terraform "-chdir=$root/stacks/$stack")

case "$cmd" in
  init) exec "${tf[@]}" init "-backend-config=$backend" "${auth_args[@]}" "$@" ;;
  plan | apply) exec "${tf[@]}" "$cmd" "$@" ;;
  lock) exec "${tf[@]}" providers lock -platform=linux_amd64 -platform=darwin_arm64 "$@" ;;
esac
