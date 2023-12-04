# Crossplane Benchmark on GCP - 04/12/2023

## Architecture deployed via Crossplane

Managed objects are RecordSet from a private ManagedZone.
- **Date:** 04/12/2023
- **Platform:** Google Cloud Platform (GCP), 
- **Version:** K8s: 1.27.3-gke.100, Crossplane: v1.14, [provider-gcp-dns](https://marketplace.upbound.io/providers/upbound/provider-gcp-dns):v0.39.0-69844
- **Compute Machine type**: e2-highcpu-16 (16vCPU/16Go)
- **Objective:** Evaluate Crossplane's performance with new Upjet release v1.0.0
- **Method:** Deployed multiple Crossplane components on a Kubernetes cluster managed by GKE to monitor resource provisioning and management.

## Infrastructure deployment

Kubernetes cluster can be deployed using GKE service in GCP:
```bash
$ ./cluster-gke.sh PROJECT_GCP_ID
```

## Installation
Add *Helm* repository and install Crossplane:
```bash
$ helm repo add crossplane-stable https://charts.crossplane.io/stable
$ helm repo update
$ helm install crossplane crossplane-stable/crossplane --namespace crossplane-system --create-namespace
```

Update your credentials in the file:
- *install/fe-provider/credential.json*
- *install/gcp-provider/gcp-credentials.json*

Apply the Crossplane configuration to install the GCP and FE provider:
```bash
$ kubectl apply -k install/
```

Finally deploy the instance ressource (VMs):
```bash
$ kubectl apply -k ressource/
```

## Benchmark

Benchmark have been started for multiple number of deployment object:
- 40000 Keypairs: *benchmark/results/kubeburner-gcp-upjet-1.0.0.out*

```bash
$ kube-burner init -c benchmark/kubeburner.yml --timeout 100h 2>&1 | tee kubeburner.out
```

## Benchmark details

### Run N°1: 40 000 RecordSets

> Deployment of 40 000 recordset, the GCP API cannot follow the number of requests perform to the GCP DNS API. The provider receive 429 return status. 
> 
> ![kubeburner-gcp-upjet-1 0 0-api](https://github.com/orange-cloudfoundry/crossplane-benchmark/assets/23292338/f3cb2e6f-d5df-4ff1-9ac1-8cbbd392a552)
>
> The API server managed by GKE cluster cannot manage this number of component. Maybe this is link to the number of API calls made, or APi server performance. Every gap in the graph is the API server becoming unavailable.
>
> ![kubeburner-gcp-upjet-1 0 0-api-server](https://github.com/orange-cloudfoundry/crossplane-benchmark/assets/23292338/e8633bb2-3103-4db4-9417-bb5c1b6e30d2)
> 
