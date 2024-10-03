# Monitoring

## Grafana dashboards

![image](https://github.com/user-attachments/assets/0894d545-406a-42d0-9995-93451900d4b2)

![image](https://github.com/user-attachments/assets/131b0ae2-ac5d-4fa4-9dfa-8194ec402a63)

![image](https://github.com/user-attachments/assets/be01e23c-9281-4189-a456-ed0f7b9ad537)

## Description

*monitoring* directory contains **Grafana dashboard** and custom [kube-state-metrics](https://github.com/kubernetes/kube-state-metrics) configuration for Prometheus.

The dashboard is using Operator metrics to collect statistics on controllers performance and usage. Most of the used metrics come from [Kubebuilder](https://book.kubebuilder.io/reference/metrics-reference).

- *grafana-crossplane-dashboard.json* : Grafane dashboard for performance and usage per controller.
- *grafana-crossplane-monitoring.json* : Monitoring dashboard to follow Claim usage and status. Helpful to create alerts.
   - Require custom *kube-stae-metrics* configuration. On your Kubernetes cluster, you need to extract CRDs status of Claims. **This cannot be done automatically**, *kube-state-metrocs* is here to extract this informations. Configuration is available in `monitoring/kube-state-metrics/customresourcestate-metrics.yaml`. Each custom Claims should have their own configuration.

## Installation

### Prerequisites

* Enable metrics on Crossplane: https://docs.crossplane.io/v1.17/guides/metrics/
* Enable metrics on your Crossplane provider (and PodMonitor): `monitoring/podmonitor.yaml`

### Deployment

Deploy *kube-state-metrics* with custom configuration on your Kubernetes cluster.

1. Customize configuration:
```bash
$ vi kube-state-metrics/customresourcestate-metrics.yaml
```
2. Add `list` and `watch` permission to *apiGroups* Kubernetes role:
```bash
$ vi kube-state-metrics/cluster-role.yaml
```
3. Deploy the custom *kube-state-metrics*:
```bash
$ kubectl apply -k kube-state-metrics/
```
