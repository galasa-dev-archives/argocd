#!/bin/bash

set -e

if [ -z ${1+x} ]; then echo "source branch not provided"; exit 1; else echo "Source branch is $1"; fi
if [ -z ${2+x} ]; then echo "target branch not provided"; exit 1; else echo "Target branch is $2"; fi

targetBranch=$2

if [[ $1 == v* ]];
then
    fromRef="--tag $1"
else 
    fromRef="--branch $1"
fi

kubectl create namespace galasa-branch-$targetBranch

galasabld github branch copy --credentials githubcreds.yaml --repository gradle            $fromRef --to $targetBranch 
galasabld github branch copy --credentials githubcreds.yaml --repository maven             $fromRef --to $targetBranch 
galasabld github branch copy --credentials githubcreds.yaml --repository framework         $fromRef --to $targetBranch 
galasabld github branch copy --credentials githubcreds.yaml --repository extensions        $fromRef --to $targetBranch 
galasabld github branch copy --credentials githubcreds.yaml --repository managers          $fromRef --to $targetBranch 
galasabld github branch copy --credentials githubcreds.yaml --repository obr               $fromRef --to $targetBranch 
galasabld github branch copy --credentials githubcreds.yaml --repository docker            $fromRef --to $targetBranch 
galasabld github branch copy --credentials githubcreds.yaml --repository isolated          $fromRef --to $targetBranch 
galasabld github branch copy --credentials githubcreds.yaml --repository eclipse           $fromRef --to $targetBranch 
galasabld github branch copy --credentials githubcreds.yaml --repository tekton-build      $fromRef --to $targetBranch 
galasabld github branch copy --credentials githubcreds.yaml --repository argocd            $fromRef --to $targetBranch 
galasabld github branch copy --credentials githubcreds.yaml --repository integrationtests  $fromRef --to $targetBranch 
galasabld github branch copy --credentials githubcreds.yaml --repository simplatform       $fromRef --to $targetBranch

kubectl get secret gpgkey --namespace=galasa-tekton -o json | jq 'del(.metadata.namespace,.metadata.resourceVersion,.metadata.uid, .metadata.creationTimestamp, .metadata.selfLink)' | kubectl apply --namespace=galasa-branch-$targetBranch -f -
kubectl get secret gpggradle --namespace=galasa-tekton -o json | jq 'del(.metadata.namespace,.metadata.resourceVersion,.metadata.uid, .metadata.creationTimestamp, .metadata.selfLink)' | kubectl apply --namespace=galasa-branch-$targetBranch -f -
kubectl get secret mavengpg --namespace=galasa-tekton -o json | jq 'del(.metadata.namespace,.metadata.resourceVersion,.metadata.uid, .metadata.creationTimestamp, .metadata.selfLink)' | kubectl apply --namespace=galasa-branch-$targetBranch -f -
kubectl get secret harbor-user-pass --namespace=galasa-tekton -o json | jq 'del(.metadata.namespace,.metadata.resourceVersion,.metadata.uid, .metadata.creationTimestamp, .metadata.selfLink)' | kubectl apply --namespace=galasa-branch-$targetBranch -f -
kubectl get secret galasadev-cert --namespace=galasa-branch-prod -o json | jq 'del(.metadata.namespace,.metadata.resourceVersion,.metadata.uid, .metadata.creationTimestamp, .metadata.selfLink)' | kubectl apply --namespace=galasa-branch-$targetBranch -f -
kubectl get secret clone-github-creds --namespace=galasa-tekton -o json | jq 'del(.metadata.namespace,.metadata.resourceVersion,.metadata.uid, .metadata.creationTimestamp, .metadata.selfLink)' | kubectl apply --namespace=galasa-branch-$targetBranch -f -
kubectl get secret dockerext-user-pass --namespace=galasa-tekton -o json | jq 'del(.metadata.namespace,.metadata.resourceVersion,.metadata.uid, .metadata.creationTimestamp, .metadata.selfLink)' | kubectl apply --namespace=galasa-branch-$targetBranch -f -

argocd app create galasa-$targetBranch-tekton \
                  --project galasa \
                  --sync-policy auto \
                  --sync-option Prune=true \
                  --self-heal \
                  --repo https://github.com/galasa-dev/argocd \
                  --revision $targetBranch  \
                  --path tektonHelm \
                  --dest-server https://kubernetes.default.svc \
                  --dest-namespace galasa-branch-$targetBranch \
                  --helm-set branch=$targetBranch \
                  --helm-set managersBranch=$targetBranch
                  
argocd app create galasa-$targetBranch-repo \
                  --project galasa \
                  --sync-policy auto \
                  --sync-option Prune=true \
                  --repo https://github.com/galasa-dev/argocd \
                  --revision $targetBranch  \
                  --path repositoryHelm \
                  --dest-server https://kubernetes.default.svc \
                  --dest-namespace galasa-branch-$targetBranch \
                  --helm-set branch=$targetBranch 

echo "Complete"
