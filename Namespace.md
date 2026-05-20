In Kubernetes, Namespaces act as virtual clusters within a physical Kubernetes cluster, enabling logical isolation and resource management for different teams or projects.

- Isolation and Uniqueness: Namespaces provide a scope for names, allowing resources (like Pods or Services) to share the same name as long as they reside in different namespaces.
- default: The landing zone for all user resources that are created without an explicitly defined namespace.
- kube-system: A highly restricted area reserved for objects created by the Kubernetes system itself, such as the API server and scheduler.
- kube-public: A readable-by-all namespace used for cluster-wide public information, such as cluster certificates or metadata needed before authentication.
- kube-node-lease: A dedicated space for "Lease" objects that help the cluster monitor node heartbeats and detect failures efficiently.



1. default Namespace
--------------------
This is the normal working namespace.
If you do not specify any namespace using -n, Kubernetes automatically uses default.

Example:
kubectl run nginx --image=nginx
    This pod goes into:
    default namespace
Purpose:
    dev, Testing, staging, frontend, backend, payments 
    Small applications
    Beginner learning
    Quick deployments


2. kube-system Namespace
--------------------------
This is the MOST IMPORTANT internal namespace. It contains Kubernetes core components.

| Component           | Purpose                  |
| ------------------- | ------------------------ |
| CoreDNS             | DNS inside cluster       |
| kube-proxy          | Networking               |
| metrics-server      | CPU/memory metrics       |
| ingress controllers | External traffic routing |


3. kube-public Namespace
------------------------
This namespace is readable by ALL users.
Even unauthenticated users may read some resources here.
Purpose
        Used for publicly accessible cluster information.
        Usually contains:
        cluster-info
        ConfigMaps or public metadata.
Real Usage
You normally do NOT deploy applications here.        

4. kube-node-lease Namespace
------------------------
This is related to node health monitoring.
Purpose
    Stores Lease objects for Kubernetes nodes.
    Each node periodically updates its lease to tell cluster:
    "I am alive"
    Why Important?
Helps Kubernetes quickly detect:
    Node failure
    Server crash
    Network disconnect

| Namespace       | Purpose                        | Used By     |
| --------------- | ------------------------------ | ----------- |
| default         | User applications              | Developers  |
| kube-system     | Kubernetes internal components | Kubernetes  |
| kube-public     | Public cluster information     | Tools/users |
| kube-node-lease | Node heartbeat tracking        | Kubernetes  |



What is a ConfigMap in Kubernetes?

A ConfigMap is used to store:
        configuration data
        environment variables
        application settings
        external configuration
separately from the application code/container image.


How Pods Use ConfigMaps
Pods can use ConfigMaps in 3 major ways:
| Method                 | Usage           |
| ---------------------- | --------------- |
| Environment Variables  | Most common     |
| Files inside container | Config files    |
| Command arguments      | Startup configs |



ConfigMap stores normal configuration, while Secret stores sensitive confidential data.

Application Pod
│
├── ConfigMap
│     ├── APP_MODE
│     └── LOG_LEVEL
│
└── Secret
      ├── DB_PASSWORD
      └── API_KEY


Configmap:
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config

data:
  APP_MODE: production
  LOG_LEVEL: debug

Secret example :
apiVersion: v1
kind: Secret
metadata:
  name: db-secret

type: Opaque

data:
  DB_PASSWORD: cGFzc3dvcmQxMjM=
-> cGFzc3dvcmQxMjM= is is Base64 encoded.and Base64 is NOT encryption.
      
