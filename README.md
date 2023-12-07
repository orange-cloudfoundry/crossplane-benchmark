# Crossplane Benchmark

Welcome to the repository where we share benchmarks and experiences with Crossplane implementations on various platforms. This repository contains benchmark tool and benchmark result to performs performance test on for the Crossplane product and several Upjet providers

## What is Crossplane?
Crossplane is an open-source Kubernetes add-on that enables the management of cloud infrastructure and services using Kubernetes APIs. It acts as a universal control plane, extending the Kubernetes API to provide a consistent interface for managing infrastructure resources across multiple cloud providers and on-premises environments.

Crossplane allows users to define and manage infrastructure and services, such as databases, storage volumes, virtual machines, or managed services like AWS RDS or Google Cloud Pub/Sub, using declarative YAML manifests. These manifests are defined using custom resource definitions (CRDs), which extend the Kubernetes API and define new resource types specific to the infrastructure or service being managed.

By leveraging the Kubernetes ecosystem and its strong declarative model, Crossplane enables infrastructure-as-code practices for managing cloud resources. It brings the benefits of Kubernetes, such as versioning, rollbacks, and reconciliation loops, to infrastructure management, providing a unified and consistent approach for managing infrastructure across multiple cloud providers.

## Benchmark Summary

### [Crossplane Benchmark on GCP - 18/10/2023](benchmark_gcp_18-10-2023/)
- **Date:** 18/10/2023
- **Platform:** Google Cloud Platform (GCP), 
- **Version:** K8s: 1.27.3-gke.100, Crossplane: v1.13, [provider-gcp-dns](https://marketplace.upbound.io/providers/upbound/provider-gcp-dns/v0.37.0):v0.37.0
- **Objective:** Evaluate Crossplane's behaviors and performance on GCP infrastructure
- **Method:** Deployed multiple Crossplane components on a Kubernetes cluster managed by GKE to monitor resource provisioning and management.

*Issue created in conjunction with the benchmark:*
- ([upjet#304](https://github.com/crossplane/upjet/issues/304)) Upon provider pod crash/restart, MR deletion leaves orphaned external resources on cloud provider
- ([upjet#305](https://github.com/crossplane/upjet/issues/305)) Upjet leaks orphan external resources upon provider pod crash/restart
- ([provider-gcp#427](https://github.com/upbound/provider-gcp/issues/427)) Improve TTR and performance when large number of MRs

### [Crossplane Benchmark on GCP - 04/12/2023](benchmark_gcp_04-12-2023/)
- **Date:** 04/12/2023
- **Platform:** Google Cloud Platform (GCP), 
- **Version:** K8s: 1.27.3-gke.100, Crossplane: v1.14, [provider-gcp-dns](https://marketplace.upbound.io/providers/upbound/provider-gcp-dns):v0.39.0-69844
- **Objective:** Evaluate Crossplane's performance with new Upjet release v1.0.0
- **Method:** Deployed multiple Crossplane components on a Kubernetes cluster managed by GKE to monitor resource provisioning and management.

*Issue linked:*
- ([provider-gcp#427](https://github.com/upbound/provider-gcp/issues/427)) Improve TTR and performance when large number of MRs

### [Crossplane Benchmark for GCP DNS on K3s - 06/12/2023](benchmark_gcp_06-12-2023/)
- **Date:** 06/12/2023
- **Platform:** FE, 
- **Version:** K3s: v1.27.7+k3s2, Crossplane: v1.14, [provider-gcp-dns](https://marketplace.upbound.io/providers/upbound/provider-gcp-dns):v0.39.0-69844
- **Objective:** Evaluate Crossplane's performance with new Upjet release v1.0.0
- **Method:** Deployed multiple Crossplane components on a K3s cluster to monitor resource provisioning and management.

*Issue linked:*
- ([provider-gcp#427](https://github.com/upbound/provider-gcp/issues/427)) Improve TTR and performance when large number of MRs

## Repository Structure

Each benchmark is stored in a separate directory within this repository. For the GCP benchmark conducted on 18/10/2023, please navigate to the `benchmark_gcp_18-10-2023` directory.

## Accessing the Benchmark

To access the benchmark details, including configuration files, results, and observations, please follow these steps:

1. Clone this repository to your local machine.
2. Navigate to the `benchmark_gcp_18-10-2023` directory.
3. Review the `README.md` file for detailed instructions and insights.

## Contact

For any queries or discussions regarding the benchmarks, feel free to raise an issue in this repository or contact the maintainers directly.

Thank you for your interest in improving Crossplane's performance and reliability.
