#!/bin/sh
echo Add the project ID as argument: ${1}
gcloud compute networks create kubernetes-vpc --project=${1} --subnet-mode=custom --mtu=1460 --bgp-routing-mode=regional
gcloud compute networks subnets create kubernetes-node --project=${1} --range=10.0.0.0/16 --stack-type=IPV4_ONLY --network=kubernetes-vpc --region=europe-west1
gcloud container --project "${1}" clusters create-auto "autopilot-crossplane" \
                 --region "europe-west1" \
                 --release-channel "regular" \
                 --enable-private-nodes \
                 --network "projects/${1}/global/networks/crossplane" \
                 --subnetwork "projects/${1}/regions/europe-west1/subnetworks/crossplane-gke" \
                 --cluster-ipv4-cidr "/17"