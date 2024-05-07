#!/usr/bin/env bash

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Filter program to generate ArgoCD namespace resource whitelist from a given Kubernetes YAML or Kustomize build output

YAML can be supplied as a file argument or via standard input. If no file is given, waits for stdin like a standard unix filter program

Outputs YAML for the namespaceResourceWhitelist section of argocd-project.yaml

A full argocd-project.yaml is already provided at the URL below with all the most common object permissions already populated via the output from this script against my production environment

    https://github.com/HariSekhon/Kubernetes-configs

Uses adjacent script kubernetes_resource_types.sh

Tested on ArgoCD 2.0.3
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<file.yaml> <file2.yaml> ...]"

help_usage "$@"

#min_args 1 "$@"

echo "  namespaceResourceWhitelist:"
"$srcdir/kubernetes_resource_types.sh" "$@" |
while read -r group kind; do
    # Cluster resources, ignore these
    if [[ "$kind" =~ Namespace|PriorityClass|StorageClass ]]; then
        continue
    fi
    group="${group%/*}"
    if [ "$group" = v1 ]; then
        group=""
    fi
    if [ "$group" = "" ]; then
        group="''"
    fi
    echo "  - group: $group"
    echo "    kind: $kind"
done
