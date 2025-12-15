
pod alway crashes
 kubectl run crashing-pod --image=busybox --restart=Always -- /bin/false


minikube ssh
curl <ip-node-exporter>:port/metrics | grep containers | grep init container
   then 
promQL query in prometheus dashboard
-------------------------------------

kube_pod_container_status_restarts_total{pod="crashing-pod", container="crashing-pod"}

 query promql

 kube_configmap_created{namespace="kube-system"}

 Cluster State	Number of available Deployment replicas.	kube_deployment_status_replicas_available{namespace="<namespace>", deployment="<deployment-name>"}
Pods in the Pending phase (e.g., stuck scheduling/pulling).	kube_pod_status_phase{phase="Pending", namespace="<namespace>"}
Time since a resource (like a ConfigMap) was created.	kube_configmap_created{namespace="<namespace>"}
Container Restarts	Rate of container restarts over the last 5 minutes. (A rising value indicates instability.)	increase(kube_pod_container_status_restarts_total{namespace="<namespace>", container="<container-name>"}[5m])
Pods terminated due to Out of Memory (OOMKilled).	kube_pod_container_status_last_terminated_reason{reason="OOMKilled", namespace="<namespace>"}
Container Readiness	Status of the container's readiness probe (1 = Ready, 0 = Not Ready).	kube_pod_container_status_ready{namespace="<namespace>", container="<container-name>"}
Initialization	Info about Init Containers. (Confirming they exist and their state.)	kube_pod_init_container_info{namespace="<namespace>", container="<init-container-name>"}
Resource Limits	Memory limit requested for a specific container.	kube_pod_container_resource_limits{namespace="<namespace>", resource="memory"}
CPU request for a specific container.	kube_pod_container_resource_requests{namespace="<namespace>", resource="cpu"}

There isn't a single, dedicated Kube-State-Metrics (KSM) PromQL query that returns "no space to pull image." The actual lack of space happens on the Minikube Node's filesystem, which is monitored by Node Exporter, not KSM.Here are the essential queries from both KSM (for the symptom) and Node Exporter (for the cause) to diagnose this issue.🔎 Diagnosing "No Space" with PromQL1. Kube-State-Metrics (KSM) - Finding the SymptomUse KSM to find the Pods that are stuck in the failing state (ImagePullBackOff).QueryPurposekube_pod_container_status_restarts_totalMonitor restarts. Look for high or increasing restart counts, indicating continuous failure to start (e.g., due to a pull issue).kube_pod_container_status_waiting_reason{reason="ImagePullBackOff"}Identify the exact reason. Finds containers stuck because they couldn't pull the image. This confirms the symptom seen in kubectl get pods.2. Node Exporter - Finding the Root Cause (Lack of Space)The "no space" error originates from the physical machine's disk. Node Exporter is required to monitor this.QueryPurposenode_filesystem_avail_bytes{mountpoint="/var/lib/docker"}Check Docker space. This checks the available bytes on the filesystem where Docker stores images. If this is near zero, it confirms the "no space" error.100 * (1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}) )