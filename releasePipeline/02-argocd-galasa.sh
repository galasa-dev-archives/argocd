#!/bin/bash

set -e

argocd app create galasa-release-tekton \
                  --project galasa \
                  --sync-policy auto \
                  --sync-option Prune=true \
                  --self-heal \
                  --repo https://github.com/galasa-dev/argocd \
                  --revision HEAD  \
                  --path tektonHelm \
                  --dest-server https://kubernetes.default.svc \
                  --dest-namespace galasa-branch-release \
                  --helm-set branch=release \
                  --helm-set managersBranch=release
                  
argocd app create galasa-release-repo \
                  --project galasa \
                  --sync-policy auto \
                  --repo https://github.com/galasa-dev/argocd \
                  --revision HEAD  \
                  --path repositoryHelm \
                  --dest-server https://kubernetes.default.svc \
                  --dest-namespace galasa-branch-release \
                  --helm-set branch=release 
