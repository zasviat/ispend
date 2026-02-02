#!/usr/bin/env bash
set -e

NAMESPACE="ispend"
DIR="k8s_manifests"
SECRET_NAME="app-secret"

deploy() {
  echo "🕸 Deploying iSpend in kubernetes cluster"
  echo

  echo "👉 Creating namespace"
  kubectl apply -f "${DIR}/namespace.yaml"
  echo

  echo "👉Creating secret from .env.docker file"
  kubectl create secret generic ${SECRET_NAME} \
  --from-env-file=.env.docker \
  --namespace ${NAMESPACE} \
  --dry-run=client -o yaml | kubectl apply -f -
  echo

  FILES=(
    postgresql.yaml
    backend.yaml
  )

  for file in "${FILES[@]}"; do
    echo "👉 Applying $file"
    kubectl apply -f "${DIR}/${file}"
    echo
  done

  echo "✅ Deployment complete"
  echo
  echo "🚀 To access backend service, run:"
  echo "kubectl port-forward service/backend 8000:8000"
}

destroy() {
  echo "💣 Destroying resources in namespace: $NAMESPACE"
  echo

  for file in "${FILES[@]}"; do
    echo "🚀 Deleting $file"
    kubectl delete -f "${DIR}/${file}" --ignore-not-found
  done


  echo "💀 Deleting secret ${SECRET_NAME}"
  kubectl delete secret ${SECRET_NAME} \
  --namespace ${NAMESPACE} \
  --ignore-not-found
  echo

  echo "💀 Deleting namespace ${NAMESPACE}"
  kubectl delete -f "${DIR}/namespace.yaml" --ignore-not-found
  echo

  echo "🧹 Cleanup complete"
  echo
  echo "🚀 To verify, run:"
  echo "kubectl get all --namespace ${NAMESPACE}"
}


usage() {
  echo "Usage: $0 {deploy|destroy}"
  exit 1
}


case "$1" in
  deploy)
    deploy
    ;;
  destroy)
    destroy
    ;;
  *)
    usage
    ;;
esac
