#!/bin/bash

set -e

argocd app delete galasa-release-tekton
argocd app delete galasa-release-repo

echo "Complete"
