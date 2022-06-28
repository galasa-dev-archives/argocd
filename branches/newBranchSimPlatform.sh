#!/bin/bash

set -e

if [ -z ${1+x} ]; then echo "target branch not provided"; exit 1; else echo "Target branch is $1"; fi

targetBranch=$1

argocd app create simplatform-$targetBranch-repo \
                  --project galasa \
                  --sync-policy auto \
                  --sync-option Prune=true \
                  --self-heal \
                  --repo https://github.com/galasa-dev/simplatform \
                  --revision $targetBranch  \
                  --path argocd/repositoryHelm \
                  --dest-server https://kubernetes.default.svc \
                  --dest-namespace galasa-branch-$targetBranch \
                  --helm-set branch=$targetBranch 

echo "Complete"
