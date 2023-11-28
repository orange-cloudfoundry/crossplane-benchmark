# Crossplane Benchmark

Welcome to the repository where we share benchmarks and experiences with Crossplane implementations on various platforms. This repository contains benchmark tool and benchmark result to performs performance test on for the Crossplane product and several Upjet providers

## What is Crossplane?
Crossplane is an open-source Kubernetes add-on that enables the management of cloud infrastructure and services using Kubernetes APIs. It acts as a universal control plane, extending the Kubernetes API to provide a consistent interface for managing infrastructure resources across multiple cloud providers and on-premises environments.

Crossplane allows users to define and manage infrastructure and services, such as databases, storage volumes, virtual machines, or managed services like AWS RDS or Google Cloud Pub/Sub, using declarative YAML manifests. These manifests are defined using custom resource definitions (CRDs), which extend the Kubernetes API and define new resource types specific to the infrastructure or service being managed.

By leveraging the Kubernetes ecosystem and its strong declarative model, Crossplane enables infrastructure-as-code practices for managing cloud resources. It brings the benefits of Kubernetes, such as versioning, rollbacks, and reconciliation loops, to infrastructure management, providing a unified and consistent approach for managing infrastructure across multiple cloud providers.

## Benchmark Summary

### Crossplane Benchmark on GCP - 18/10/2023
- **Date:** 18/10/2023
- **Platform:** Google Cloud Platform (GCP), 
- **Version:** K8s: 1.27.3-gke.100, Crossplane: v1.13, [provider-gcp-dns](https://marketplace.upbound.io/providers/upbound/provider-gcp-dns/v0.37.0):v0.37.0
- **Objective:** Evaluate Crossplane's behaviors and performance on GCP infrastructure
- **Method:** Deployed multiple Crossplane components on a Kubernetes cluster managed by K3s to monitor resource provisioning and management.

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
