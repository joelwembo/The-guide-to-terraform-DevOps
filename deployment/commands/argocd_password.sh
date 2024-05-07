#!/usr/bin/env bash

# Gets the ArgoCD initial admin password from the environment or Kubernetes secret

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
#srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -n "${ARGOCD_PASSWORD:-}" ]; then
    echo "using \$ARGOCD_PASSWORD from environment" >&2
elif kubectl get secret -n argocd argocd-initial-admin-secret &>/dev/null; then
    ARGOCD_PASSWORD="$(kubectl -n argocd get secret -n argocd argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 --decode)"
fi

if [ -z "${ARGOCD_PASSWORD:-}" ]; then
    echo "ERROR: failed to determine ARGOCD_PASSWORD from environment or kubernetes" >&2
    exit 1
fi

# if sourced, export ARGOCD_PASSWORD, if subshell, echo it
#if [[ "$_" != "$0" ]]; then
    export ARGOCD_PASSWORD
#else
    echo -n "$ARGOCD_PASSWORD"  # no newline so we can pipe straight to pbcopy / xclip or similar
#fi
