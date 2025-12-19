Great! Since the status is **UP and green**, your Node Exporter is working perfectly. The reason you might have seen an "Error executing query" earlier with `node_memory_MemTotal_bytes` could be as simple as a typo or a specific label requirement in your setup.

Now that we know the connection is healthy, let's build the **Full Observability Readme** you asked for, specifically tailored to your **Spring Boot Chaos** project.

---

# 🚀 Chaos Engineering & Observability Cheat Sheet

**Environment:** Minikube + Prometheus + Spring Boot

**Focus:** Memory Leaks, CPU Spikes, Error Chaos

## 🛠️ 1. Node Infrastructure (Host Memory)

Since you are testing **Leak Chaos**, you need to see how the host Ubuntu machine reacts.

| Metric Goal | PromQL Query |
| --- | --- |
| **Total RAM (Host)** | `node_memory_MemTotal_bytes` |
| **Available RAM** | `node_memory_MemAvailable_bytes` |
| **Used RAM %** | `(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100` |
| **Memory Breakdown** | `node_memory_MemFree_bytes` (Free) / `node_memory_Cached_bytes` (Cache) |
| **Storage Capacity** | `kube_node_status_capacity{resource="memory"}` |

---

## 🏗️ 2. Cluster State (Kube-State-Metrics)

Use these to see if Kubernetes is trying to restart your app during the chaos.

| Metric Goal | PromQL Query |
| --- | --- |
| **Total Pod Count** | `count(kube_pod_info{namespace="monitoring"})` |
| **Pod Status** | `count by (phase) (kube_pod_status_phase)` |
| **Restart Spikes** | `increase(kube_pod_container_status_restarts_total[15m])` |
| **Node Capacity** | `kube_node_status_capacity{resource="cpu"}` |
| **Pending Pods** | `kube_pod_status_phase{phase="Pending"}` |

---

## 🔴 3. Error Chaos (API & App Failures)

When you trigger **Error Chaos** in Spring Boot, use these to measure the impact.

| Metric Goal | PromQL Query |
| --- | --- |
| **HTTP 500 Count** | `http_server_requests_seconds_count{status="500"}` |
| **Error Rate %** | `rate(http_server_requests_seconds_count{status=~"5.."}[5m]) / rate(http_server_requests_seconds_count[5m])` |
| **JVM Exceptions** | `sum by (exception) (rate(jvm_exceptions_total[5m]))` |
| **CrashLoop Count** | `count(kube_pod_container_status_waiting_reason{reason="CrashLoopBackOff"})` |
| **Failed Probes** | `kube_pod_container_status_ready == 0` |

---

## 💧 4. Memory Leak Chaos (JVM & Container)

When you trigger **Leak Chaos**, these queries will show the "staircase" growth of memory.

| Metric Goal | PromQL Query |
| --- | --- |
| **Container Memory** | `container_memory_working_set_bytes{container="your-app-name"}` |
| **JVM Heap Used** | `jvm_memory_used_bytes{area="heap"}` |
| **OOM-Kill Prediction** | `predict_linear(container_memory_working_set_bytes[1h], 3600)` |
| **Memory Limit %** | `(container_memory_working_set_bytes / kube_pod_container_resource_limits{resource="memory"}) * 100` |
| **OOM-Killed Event** | `kube_pod_container_status_terminated_reason{reason="OOMKilled"}` |

---

## ⚡ 5. CPU & HTTP Performance

Chaos testing often causes "High CPU" or "Slow Latency" before the app actually crashes.

| Metric Goal | PromQL Query |
| --- | --- |
| **CPU Usage (Cores)** | `rate(container_cpu_usage_seconds_total[5m])` |
| **CPU Throttling** | `rate(container_cpu_cfs_throttled_seconds_total[5m])` |
| **95th % Latency** | `histogram_quantile(0.95, sum(rate(http_server_requests_seconds_bucket[5m])) by (le))` |
| **Request Rate** | `rate(http_server_requests_seconds_count[1m])` |
| **Active Requests** | `http_server_requests_active_count` |

---

### 💡 Pro-Tip for your Project

If you want to see exactly how much memory your **Chaos/Leak** is consuming compared to the total container limit, use this specific calculation:

```promql
sum(container_memory_working_set_bytes{container!=""}) by (pod) / 
sum(kube_pod_container_resource_limits{resource="memory"}) by (pod)

```

If this reaches **1.0 (100%)**, Kubernetes will kill your pod immediately.

**Would you like me to help you set up a Grafana Alert that sends a notification when `predict_linear` suggests a crash is coming in 30 minutes?**