# Crossplane Benchmark on GCP - 18/10/2023

## Architecture deployed via Crossplane

![benchmark-architecture-1 drawio](https://github.com/orange-cloudfoundry/crossplane-benchmark/assets/23292338/1417b41b-6139-46a6-8f44-e86d12dd79ae)

Managed objects are RecordSet from a private ManagedZone.
- **Date:** 18/10/2023
- **Platform:** Google Cloud Platform (GCP), 
- **Version:** K8s: 1.27.3-gke.100, Crossplane: v1.13, [provider-gcp-dns](https://marketplace.upbound.io/providers/upbound/provider-gcp-dns/v0.37.0):v0.37.0
- **Compute Machine type**: e2-highcpu-16 (16vCPU/16Go)
- **Objective:** Evaluate Crossplane's behaviors and performance on GCP infrastructure
- **Method:** Deployed multiple Crossplane components on a Kubernetes cluster managed by K3s to monitor resource provisioning and management.
## Installation
Add *Helm* repository and install Crossplane:
```bash
$ helm repo add crossplane-stable https://charts.crossplane.io/stable
$ helm repo update
$ helm install crossplane crossplane-stable/crossplane --namespace crossplane-system --create-namespace
```

Update your credentials in the file:
- *install/gcp-provider/gcp-credentials.json*

Apply the Crossplane configuration to install the GCP and FE provider:
```bash
$ kubectl apply -k install/
```

Create the network requirements (VPC and flow):
```bash
$ kubectl apply -k network/
```

Finally deploy the instance ressource (DNS ManagedZone):
```bash
$ kubectl apply -k ressource/
```

## Infrastructure deployment

Kubernetes cluster can be deployed using GKE service in GCP:
```bash
$ ./cluster-gke.sh PROJECT_GCP_ID
```

## List of points of attention
- Due to the number of object in the GCP provider. The provider have been cut into multiple sub-provider. Here we are installing the Compute, DNS and Storage providers.
> *[...] The more CRDs you have on a cluster the more resources it will consume and this can result in a performance penalty* [...] https://blog.upbound.io/new-provider-families

- As with the [FE provider](https://marketplace.upbound.io/providers/frangipaneteam/provider-flexibleengine/), in GCP, objects of type Subnet cannot be modified (decrease a CIDR). It means that the provider is blocked until you delete manually the ressource. **Because the provider doesn't know the dependency between object, it is impossible for it to delete all object. And so, there is no option to force replacement**.

- The reconciliation loop takes approximately 10 min in the GCP provider. This can be modified with the alpha feature: *--poll=1m*

- With the GCP provider we can import external ressource. But the alpha feature need to be manually enable: *--enable-management-policies*

- When deleting a huge number of GCP ressources, some ressources are not deleted from the GCP console. But there have been correctly deleted from the Kubernetes cluster. This means that certain resources are no longer managed by Crossplane.
**This issue happen with Recordset resources and Bucket resources.** This can potentially involve all objects deployed through Upjet.

- Creation of more than 1000+ ressources can take multiple hour. Very expensive in terms of CPU usage. **One Terraform process is started for each API ressource request.** Because of the reconciliation loop we can't predict how long it will take to deploy the ressources.

- The provider GCP use the Upjet implementation. When deploying thousands of managed objects, the provider quickly consumes all the available CPU time. In the benchmark, the provider does not consume more than 10 vCPUs, even if more are available. Each request or reconciliation launches a new Terraform process. **The provider's performance is degraded and this has a major impact on the number of API calls the provider can make.**

## Benchmark procedure

Deploy a huge number of component to stress test the GCP provider:
```bash
$ benchmark/creation.sh
$ kubectl apply -f benchmark/out/
$
$ kubectl delete -f benchmark/out/
```

## Benchmark details

### Run N°1: 4000 RecordSets: Create then Delete

> Deployment of 4000 RecordSet. This took 1 hour 30 minutes blocked at 60% (10 vCPU) CPU usage. The provider doesn't consume more CPU even if 6 other vCPU is available. The K8s cluster have no request/limit set. 15 API requests to GCP per seconds. The Crossplane provider is running one terraform apply for each components.
> 
> After the deployment completion, CPU consumption is still 60% CPU usage for 6 API call/s.  The provider can't get round all the resources in less than a minute. It takes 20 minutes to go round all the resources.
> ![image](https://github.com/orange-cloudfoundry/crossplane-benchmark/assets/23292338/75b04ece-ab9c-4b9c-8031-bd4f03c7e496)
> *Top diagram: CPU usage of the worker node. Botton diagram: Number of API calls reveiced by GCP for the DNS API endpoints*

### Run N°2: 9500 RecordSets: Only create

> Deployment of 9500 RecordSet. 4 hours to complete. Permanent 60% CPU usage 6 API call/s. After the deployment completion, CPU consumption is still 60%. The provider can't get round all the resources in less than a minute. **It takes 20 minutes to go round all the resources.**
> ![image](https://github.com/orange-cloudfoundry/crossplane-benchmark/assets/23292338/27343bda-9ff1-41c1-98ef-07def17bdbf0)

### Run N°3: Increasing poll, max-reconcile-rate and sync

> Increased poll, sync and max-reconcile-rate by 10. Poll set from 10m to 1m. Sync set from 1h to 10m. Max-reconcile-rate from 10 to 100. **This speedup GCP patch but decreased reconcile creation.** Deployment rate drop to 100 Recordsets/hour. The provider still using 10vCPU, but less CPU time is dedicated for the creations reconciliations.
>
> ![image](https://github.com/orange-cloudfoundry/crossplane-benchmark/assets/23292338/1b6527f9-351d-4322-8f21-67a628204c20)

### Run N°4: 4000 RecordSets: Create, shutdown then Delete

> Creating 4000 RecordSets. Wait for the object to be in ready state. Resize cluster to 0 worker node, then back to 1 worker node. **After requesting deletion of all RecordSets some of then are been deleted from Kubernetes, but not from GCP console!**
> ![image](https://github.com/orange-cloudfoundry/crossplane-benchmark/assets/23292338/42433450-a619-4d5b-ac5c-007f6dd4376f)
>
> Object *recordset.dns.gcp.upbound.io/benchmarksix10* is missing the Terraform deletion log. Object *recordset.dns.gcp.upbound.io/benchmarksix11* is correctly deleted.
>
> ![image](https://github.com/orange-cloudfoundry/crossplane-benchmark/assets/23292338/86e26452-ea08-48c1-abb5-fb1688d8c785)
> Log details (exported from GCP Logs Explorer): 
> - [benchmarksix10.csv](benchmark_gcp_18-10-2023/benchmark/result/benchmarksix10.csv), [benchmarksix10.json](benchmark_gcp_18-10-2023/benchmark/result/benchmarksix10.json)
> - [benchmarksix11.csv](benchmark_gcp_18-10-2023/benchmark/result/benchmarksix11.csv), [benchmarksix11.json](benchmark_gcp_18-10-2023/benchmark/result/benchmarksix11.json)

### Run N°5: 4000 RecordSets: Service interruption during ressource creation 

> Start deploying the 4000 RecordSet and shutdown gracefully the single node.
> 
> ![image](https://github.com/orange-cloudfoundry/crossplane-benchmark/assets/23292338/0d7ee8f4-d681-42d0-a577-fe0ffd8a8b2c)
> After provider restart resource already created, try in loop to create the ressource. In order to discover the ressource already created we need to enable debug in the provider option to have deployment information. **No fault recovery management.**
>
> ![image](https://github.com/orange-cloudfoundry/crossplane-benchmark/assets/23292338/83184a99-4719-45b3-84ee-bc1eebcf88bb)
> 
> Log details (exported from GCP Logs Explorer): 
> - [benchmarkeight339.csv](benchmark_gcp_18-10-2023/benchmark/result/benchmarkeight339.csv), [benchmarkeight339.json](benchmark_gcp_18-10-2023/benchmark/result/benchmarkeight339.json)



### Run N°6: 2000 Buckets

> Wait for deploy of 2000 Bucket at (1 rq/s), and then delete the bucket. Here the provider is limited to 5vCPU CPU limit:
> >
> ![image](https://github.com/orange-cloudfoundry/crossplane-benchmark/assets/23292338/7cd1e4bc-92ae-4117-842b-32bafe8dae96)
> CPU is increasing gradually after the end of creation (here the CPU limit is 5). **Same behavior as the run n°4: Bucket deleted from K8s but not from GCP.** In the log we can see the delete request is not receive by GCP.
> - Not deleted in GCP: [bucketbenchone1929.csv](benchmark_gcp_18-10-2023/benchmark/result/bucketbenchone1929.csv), [bucketbenchone1929.json](benchmark_gcp_18-10-2023/benchmark/result/bucketbenchone1929.json)
> - Correctly deleted in GCP and K8s: [bucketbenchone1928.csv](benchmark_gcp_18-10-2023/benchmark/result/bucketbenchone1928.csv), [bucketbenchone1928.json](benchmark_gcp_18-10-2023/benchmark/result/bucketbenchone1928.json)
