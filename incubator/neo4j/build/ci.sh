#!/bin/bash

export GOOGLE_APPLICATION_CREDENTIALS="${HOME}/gcloud-service-key.json"
export PROJECT_ID="neo4j-k8s"
export CLOUDSDK_COMPUTE_ZONE="europe-west1-b"

gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json

gcloud container clusters create ${CLUSTER_NAME} \
 --project "neo4j-k8s" \
 --zone "europe-west1-b" \
 --machine-type "n1-standard-1" \
 --image-type "GCI" \
 --disk-size "100" \
 --scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
 --num-nodes "3" \
 --network "default"

gcloud config set project $PROJECT_ID
gcloud --quiet config set container/cluster $CLUSTER_NAME
gcloud config set compute/zone ${CLOUDSDK_COMPUTE_ZONE}
gcloud --quiet container clusters get-credentials $CLUSTER_NAME

helm init
kubectl rollout status -w deployment/tiller-deploy --namespace=kube-system
helm install incubator/neo4j --name neo-helm --wait
helm test neo-helm
helm delete neo-helm --purge
