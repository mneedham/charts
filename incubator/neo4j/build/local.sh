#!/bin/bash

minikube start --memory 8096
helm init
kubectl rollout status -w deployment/tiller-deploy --namespace=kube-system

helm install --set NumberOfReadReplicas=0,ServiceType="NodePort" --name neo-helm --wait incubator/neo4j
# helm install --name neo-helm --set Image="markhneedham/neo4j-channels",ImageTag="firsttry" --wait incubator/neo4j

helm test neo-helm
helm delete neo-helm --purge
minikube delete
