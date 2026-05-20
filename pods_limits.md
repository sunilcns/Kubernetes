# product-with-limits.yaml
apiVersion: v1
kind: Pod
metadata:
  name: product-with-limits
  labels:
    app: product
    project: shopeasy
spec:
  containers:
    - name: product
      image: nginx
      ports:
        - containerPort: 80
      resources:
        requests:              # Minimum guaranteed resources
          memory: "64Mi"
          cpu: "250m"          # 250 millicores = 0.25 CPU core
        limits:                # Maximum allowed resources
          memory: "128Mi"
          cpu: "500m"


# REQUESTS (Scheduler uses this):
# └── "Reserve at least 64Mi RAM and 0.25 CPU for me on a node"
#     K8s scheduler won't place pod on node with less free than this

# LIMITS (Kubelet enforces this):
# └── "Never let this container exceed 128Mi RAM or 0.5 CPU"
    
# What happens if exceeded?
# ├── CPU limit hit    → Container gets THROTTLED (slowed down)
# └── Memory limit hit → Container gets KILLED (OOMKilled) 😱

# Real production disaster story:
#   Dev sets no limits → one buggy pod eats all node memory
#   → ALL pods on that node crash → entire service down
#   → This is why limits are MANDATORY in production

#What is OOMKilled (exit code 137)?
#The OOMKilled status in Kubernetes, flagged by exit code 137,
# signifies that the Linux Kernel has halted a container because it has surpassed its allocated memory limit.
#When a container exceeds its memory limit, the Linux Kernel's Out-Of-Memory (OOM) Killer intervenes to free up memory by 
#terminating processes. In Kubernetes, if a container is terminated due to OOM, it is marked as OOMKilled, and the exit code 137 indicates that the process was killed by the OOM Killer. This status serves as an alert 
#to developers and operators that the container's memory usage needs to be reviewed and adjusted to prevent future occurrences.
