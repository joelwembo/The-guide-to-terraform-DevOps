#!/usr/bin/env bash

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Boots Prometheus in Docker with the given configuration (default: \$PWD/prometheus.yml)
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[ up | down | ui ] [<prometheus.yml>]"

help_usage "$@"

#min_args 1 "$@"

export COMPOSE_PROJECT_NAME="bash-tools"
export COMPOSE_FILE="$srcdir/../docker-compose/prometheus.yml"
export PROMETHEUS_URL="http://localhost:9090"
export PROMETHEUS_CONFIG="${2:-$srcdir/../setup/prometheus.yml}"

if ! type docker-compose &>/dev/null; then
    "$srcdir/../install/install_docker_compose.sh"
fi

action="${1:-up}"
shift || :

if [ "$action" = up ]; then
    timestamp "Booting Prometheus:"
    docker-compose up -d "$@"
    echo >&2
    when_url_content "$PROMETHEUS_URL" '(?i:prometheus)'
    echo >&2
    exec "${BASH_SOURCE[0]}" ui
elif [ "$action" = restart ]; then
    docker-compose down
    echo >&2
    exec "${BASH_SOURCE[0]}" up
elif [ "$action" = ui ]; then
    echo "Prometheus URL:  $PROMETHEUS_URL"
    echo
    if is_mac; then
        open "$PROMETHEUS_URL"
    fi
    exit 0
else
    docker-compose "$action" "$@"
    echo >&2
    exit 0
fi
