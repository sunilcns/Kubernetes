--------------------------------------------------------------------------------
Learning :

kubectl logs product-service: 
        Application startup issue
        Port already in use
        Database issue
        Access denied for user
        Missing environment variable
        API_KEY not found
        Crash debugging
        OutOfMemoryError

apiVersion: v1 in yaml file 
        v1 is the core stable Kubernetes API version for Pods.


Kind:
        | Kind       | Purpose             |
        | ---------- | ------------------- |
        | Pod        | Single running unit |
        | Deployment | Manages pods        |
        | Service    | Exposes pods        |
        | ConfigMap  | Stores configs      |

kubectl exec -it product-service -- /bin/bash
        Kubernetes finds the pod and connects to its container.


Challenge 3 — The Disappearing Pod 🔥 (Most Important!)
kubectl delete pod product-service
kubectl get pods
        # No resources found in default namespace.
        A raw Pod has NO guardian watching over it.
        You create Pod → K8s runs it → You delete it → Gone forever
        This is EXACTLY why Deployments exist.

        Deployment = Pod + a ReplicaSet guardian watching 24/7
        ├── Pod crashes?     → ReplicaSet creates a new one instantly
        ├── Node dies?       → ReplicaSet moves pod to healthy node
        ├── You delete pod?  → ReplicaSet creates replacement immediately
        └── Scale to 5?      → ReplicaSet ensures exactly 5 always run




QoS Class: BestEffort ( in the yaml file )
kubectl get pod product-service -o yaml  -> runtime with yaml format 
A Pod gets BestEffort QoS when no CPU or memory requests/limits are defined. 
It has the lowest priority in Kubernetes and may be evicted first during resource pressure.

A Pod becomes BestEffort when you do NOT define:
CPU requests, CPU limits, Memory requests, Memory limits
| QoS Class      | Resource Configuration                                | Priority | Behavior                                                                 |
| -------------- | ----------------------------------------------------- | -------- | ------------------------------------------------------------------------ |
| **BestEffort** | No requests or limits defined                         | Lowest   | Uses resources only if available; evicted first during resource pressure |
| **Burstable**  | Requests and/or limits defined, but requests ≠ limits | Medium   | Gets minimum guaranteed resources but can use more if available          |
| **Guaranteed** | Requests = Limits for CPU and memory                  | Highest  | Fully guaranteed resources; evicted last and most stable for production  |


| Feature                | Behavior           |
| ---------------------- | ------------------ |
| Resource guarantee     | None               |
| CPU guarantee          | No                 |
| Memory guarantee       | No                 |
| Eviction priority      | First to be killed |
| Production suitability | Poor               |
If node memory becomes full:
Kubernetes may terminate BestEffort pods first

Burstable 
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "500m"
    memory: "256Mi"

Guaranteed
resources:
  requests:
    cpu: "500m"
    memory: "256Mi"
  limits:
    cpu: "500m"
    memory: "256Mi"

---------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------


ResourceQuota : ResourceQuota limits how much CPU, memory, and objects a namespace can consume.

# Set a quota on dev namespace
cat > dev-quota.yaml << 'EOF'
apiVersion: v1
kind: ResourceQuota
metadata:
  name: shopeasy-dev-quota
  namespace: shopeasy-dev
spec:
  hard:
    pods: "5"                    # max 5 pods in dev
    requests.cpu: "1"            # total CPU requests across all pods
    requests.memory: "512Mi"     # total memory requests
    limits.cpu: "2"
    limits.memory: "1Gi"
EOF

kubectl apply -f dev-quota.yaml

# Check quota usage
kubectl describe quota -n shopeasy-dev

# Try to exceed it — create 6 pods
for i in 1 2 3 4 5 6; do
  kubectl run test-pod-$i --image=nginx -n shopeasy-dev
done
# The 6th pod will be REJECTED with quota exceeded error!


Total CPU limits across namespace ≤ 2 CPU cores
Total guaranteed memory across all pods ≤ 512 MB
Total CPU requests cannot exceed 1 CPU core across ALL pods in namespace.

Namespace: shopeasy-dev
│
├── Max Pods → 5
├── Max CPU Requests → 1 core
├── Max Memory Requests → 512Mi
├── Max CPU Limits → 2 cores
└── Max Memory Limits → 1Gi

