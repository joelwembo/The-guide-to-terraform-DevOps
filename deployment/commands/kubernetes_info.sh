#!/usr/bin/env bash

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/utils.sh"

# shellcheck disable=SC1090,SC1091
. "$srcdir/lib/kubernetes.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Lists Kubernetes info and deployed resources across all namespaces in the current cluster / kube context

Can optionally specify a different kubernetes context to switch to (will switch back to original context on any exit except kill -9)

Lists:

- cluster-info
- master component statuses
- nodes
- namespaces
- deployments, replicasets, replication controllers, statefulsets, daemonsets, horizontal pod autoscalers
- services, ingresses
- jobs, cronjobs
- storage classes, persistent volumes, persistent volume claims
- service accounts, resource quotas, network policies, pod security policies
- container images running
- container images running counts descending
- pods  # might be too much detail if you have high replica counts, so done last, comment if you're sure nobody has deployed pods outside deployments
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="[<kubernetes_context>]"

help_usage "$@"

kube_config_isolate

current_context="$(kubectl config current-context)"

if [ $# -gt 0 ]; then
    context="$1"
    # want interpolation now
    # shellcheck disable=SC2064
    trap "echo; kubectl config use-context '$current_context'" EXIT
    # kubectl declares this just fine
    #echo "switching to kubernetes context '$context'"
    kubectl config use-context "$context"
    echo
fi

echo "kubectl context: $(kubectl config current-context)"
echo
kubectl cluster-info
echo
kubectl get componentstatuses
echo
kubectl get nodes -o wide
echo
kubectl get namespaces
echo
kubectl get --all-namespaces deployments,replicasets,replicationcontrollers,statefulsets,daemonsets,horizontalpodautoscalers
echo
kubectl get --all-namespaces services,ingresses
echo
echo
kubectl get --all-namespaces jobs,cronjobs
echo
echo
kubectl get --all-namespaces storageclasses,persistentvolumes,persistentvolumeclaims
echo
echo
kubectl get --all-namespaces serviceaccounts,resourcequotas,networkpolicies,podsecuritypolicies
echo
echo
echo "# Running container images:"
echo
"$srcdir/kubectl_images.sh"
echo
echo
echo "# Running container image counts:"
echo
"$srcdir/kubectl_image_counts.sh"
echo
echo
# pods might be too numerous with high replica counts and low value info, but there is always a chance that people launched pods without deployments, you can comment it out if you're confident that isn't the case
kubectl get --all-namespaces pods
