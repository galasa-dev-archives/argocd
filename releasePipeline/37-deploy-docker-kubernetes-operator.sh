#!/bin/bash

set -e

FROM=release

TO=x.xx.x

ibmcloud cr login




docker pull harbor-cicsk8s.hursley.ibm.com/galasadev/galasa-kubernetes-operator-amd64:$FROM



docker tag harbor-cicsk8s.hursley.ibm.com/galasadev/galasa-kubernetes-operator-amd64:$FROM                      \
           icr.io/galasadev/galasa-cli-amd64:$TO



docker tag harbor-cicsk8s.hursley.ibm.com/galasadev/galasa-kubernetes-operator-amd64:$FROM                       \
           icr.io/galasadev/galasa-cli-amd64:latest




docker push icr.io/galasadev/galasa-kubernetes-operator-amd64:$TO



docker push icr.io/galasadev/galasa-kubernetes-operator-amd64:latest
