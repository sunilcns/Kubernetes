Kubernetes Architecture Overview — Complete README
1. Introduction
Kubernetes (K8s) is an open-source container orchestration platform used to:
•	Deploy containers
•	Scale applications
•	Manage workloads
•	Handle failures automatically
•	Perform rolling updates
•	Maintain desired state
Kubernetes was originally developed by:
Google
and is now maintained by:
Cloud Native Computing Foundation (CNCF)
________________________________________
2. High-Level Kubernetes Architecture
Kubernetes architecture mainly consists of:
1. Control Plane (Master Components)
2. Worker Nodes
________________________________________
3. Overall Cluster Architecture Diagram


                    +--------------------------------+
                    |        kubectl / API Calls     |
                    +---------------+----------------+
                                    |
                                    v
                     +-------------------------------+
                     |        API SERVER             |
                     +-------------------------------+
                          |        |          |
                          |        |          |
                          v        v          v
                     +--------+ +--------+ +----------------+
                     | etcd   | |Scheduler| |Controller Mgr |
                     +--------+ +--------+ +----------------+


        =====================================================
                      Kubernetes Cluster Network
        =====================================================

                Worker Node 1                Worker Node 2
          +---------------------+      +---------------------+
          | kubelet             |      | kubelet             |
          | kube-proxy          |      | kube-proxy          |
          | container runtime   |      | container runtime   |
          |---------------------|      |---------------------|
          | Pod A               |      | Pod C               |
          | Pod B               |      | Pod D               |
          +---------------------+      +---------------------+
________________________________________
4. Control Plane Components (Master Components)
The Control Plane is the brain of Kubernetes.
It manages:
•	Scheduling
•	Desired state
•	Cluster decisions
•	Scaling
•	Recovery
•	Networking policies
Main components:
1.	API Server
2.	etcd
3.	Scheduler
4.	Controller Manager
5.	Cloud Controller Manager (optional)
________________________________________
5. Kubernetes API Server
Component:
kube-apiserver
The API Server is:
The central entry point of Kubernetes
All communication happens through API server.
Examples:
kubectl apply
kubectl get pods
kubectl delete pod
All these commands communicate with:
API Server
Responsibilities:
•	Validates requests
•	Authenticates users
•	Stores objects in etcd
•	Exposes Kubernetes REST API
•	Serves cluster state
________________________________________
6. etcd — Kubernetes Database
Component:
etcd
etcd is:
Distributed key-value database
Stores:
•	Pods
•	Deployments
•	ReplicaSets
•	Services
•	Secrets
•	ConfigMaps
•	Cluster configuration
•	Desired state
IMPORTANT:
If etcd is lost:
Cluster state is lost
That is why etcd backup is critical.
________________________________________
7. Scheduler
Component:
kube-scheduler
Purpose:
Assign pods to worker nodes
Scheduler decides:
Which node should run which pod
It checks:
•	CPU
•	Memory
•	Taints & tolerations
•	Node affinity
•	Resource availability
•	Policies
Example:
Pod created
→ Scheduler picks suitable node
→ Pod assigned to node
________________________________________
8. Controller Manager
Component:
kube-controller-manager
Runs multiple controllers.
Controllers continuously monitor:
Desired State vs Actual State
and try to reconcile differences.
________________________________________
Common Controllers
ReplicaSet Controller
Ensures required number of pods are running.
________________________________________
Deployment Controller
Handles:
•	rolling updates
•	rollback
•	ReplicaSet management
________________________________________
Node Controller
Monitors node health.
________________________________________
Job Controller
Handles batch jobs.
________________________________________
Endpoint Controller
Maintains service endpoints.
________________________________________
9. Worker Node Components
Worker nodes actually run applications.
Main components:
1.	kubelet
2.	kube-proxy
3.	Container Runtime
4.	Pods
________________________________________
10. kubelet
Component:
kubelet
Runs on every worker node.
Responsibilities:
•	Receives instructions from API server
•	Creates pods
•	Monitors containers
•	Reports node status
•	Ensures containers are healthy
Think of kubelet as:
Node Agent
________________________________________
11. Container Runtime
Examples:
•	Docker
•	containerd
•	CRI-O
Purpose:
Actually runs containers
Kubelet communicates with container runtime.
________________________________________
12. kube-proxy
Component:
kube-proxy
Handles:
•	Pod networking
•	Service networking
•	Traffic forwarding
•	Load balancing
It manages networking rules using:
•	iptables
•	IPVS
________________________________________
13. Pods
Pod is:
Smallest deployable unit in Kubernetes
A pod can contain:
•	One container
•	Multiple containers
Containers inside same pod share:
•	Network
•	Storage
•	localhost
________________________________________
14. Kubernetes Objects
Common Kubernetes resources:
Object	Purpose
Pod	Runs containers
ReplicaSet	Maintains pod count
Deployment	Manages application deployment
Service	Exposes applications
ConfigMap	Stores configuration
Secret	Stores sensitive data
Namespace	Logical isolation
Ingress	HTTP/HTTPS routing
StatefulSet	Stateful applications
DaemonSet	One pod per node
Job/CronJob	Batch processing
________________________________________
15. Deployment Architecture Flow
Example flow:
Developer writes YAML
        ↓
kubectl apply -f deployment.yaml
        ↓
API Server validates request
        ↓
Object stored in etcd
        ↓
Deployment Controller creates ReplicaSet
        ↓
ReplicaSet creates Pods
        ↓
Scheduler selects worker nodes
        ↓
kubelet creates containers
        ↓
Application becomes available
________________________________________
16. Desired State Concept
Kubernetes works on:
Desired State Reconciliation
Example:
Desired:
3 pods
Actual:
2 pods
Controller automatically creates missing pod.
This continuous reconciliation is the core of Kubernetes.
________________________________________
17. Declarative vs Imperative
Declarative (Preferred)
Define desired state using YAML.
Example:
kubectl apply -f app.yaml
________________________________________
Imperative
Direct commands.
Examples:
kubectl run
kubectl edit
kubectl delete
kubectl scale
________________________________________
18. Kubernetes Networking Basics
Every pod gets:
Unique IP address
Pods communicate directly.
Services provide:
•	Stable IP
•	DNS name
•	Load balancing
________________________________________
19. Service Types
ClusterIP
Internal communication.
________________________________________
NodePort
Exposes service on node port.
________________________________________
LoadBalancer
Uses cloud load balancer.
________________________________________
ExternalName
Maps to external DNS.
________________________________________
20. Ingress
Ingress provides:
•	HTTP routing
•	HTTPS termination
•	Domain-based routing
•	Path-based routing
Example:
app.example.com → frontend service
api.example.com → backend service
________________________________________
21. Namespaces
Namespaces provide:
Logical isolation inside cluster
Examples:
•	dev
•	qa
•	prod
________________________________________
22. ConfigMaps and Secrets
ConfigMap
Stores non-sensitive configuration.
Example:
•	URLs
•	Feature flags
•	Environment configs
________________________________________
Secret
Stores sensitive data.
Example:
•	Passwords
•	Tokens
•	Certificates
________________________________________
23. StatefulSet
Used for stateful applications.
Examples:
•	MySQL
•	PostgreSQL
•	Kafka
•	MongoDB
Provides:
•	Stable hostname
•	Persistent identity
•	Ordered deployment
________________________________________
24. DaemonSet
Ensures:
One pod runs on every node
Examples:
•	Monitoring agents
•	Log collectors
•	Security agents
________________________________________
25. Job and CronJob
Job
Runs task once.
________________________________________
CronJob
Runs task on schedule.
Like Linux cron.
________________________________________
26. High Availability in Kubernetes
Production clusters usually have:
•	Multiple control plane nodes
•	Multiple worker nodes
•	Replicated etcd
•	Load balancer
This prevents single point of failure.
________________________________________
27. Kubernetes Security
Important security components:
•	RBAC
•	Network Policies
•	Pod Security
•	Secrets
•	TLS certificates
•	Service Accounts
________________________________________
28. Kubernetes Storage
Storage concepts:
Component	Purpose
Volume	Pod storage
PersistentVolume	Cluster storage
PersistentVolumeClaim	Storage request
StorageClass	Dynamic provisioning
________________________________________
29. Real Production Workflow
Typical DevOps workflow:
Developer commits YAML to Git
        ↓
CI/CD Pipeline triggers
        ↓
Docker image built
        ↓
Image pushed to registry
        ↓
kubectl apply or Helm deploy
        ↓
Kubernetes updates application
________________________________________
30. Why Kubernetes Became Popular
Benefits:
•	Auto healing
•	Auto scaling
•	High availability
•	Rolling updates
•	Container orchestration
•	Efficient resource usage
•	Portability
•	Declarative infrastructure
•	Cloud-native ecosystem
________________________________________
31. Common Kubernetes Tools
Tool	Purpose
kubectl	Kubernetes CLI
Helm	Package manager
ArgoCD	GitOps deployment
Prometheus	Monitoring
Grafana	Visualization
Istio	Service mesh
Jenkins	CI/CD
Docker	Container runtime
________________________________________
32. Most Important Kubernetes Concepts
Kubernetes is:
A Distributed Desired-State Orchestration System
You define:
Desired State
Kubernetes continuously works to make:
Actual State == Desired State
________________________________________
33. Kubernetes Learning Roadmap
Suggested order:
1.	Containers & Docker
2.	Pods
3.	ReplicaSet
4.	Deployment
5.	Services
6.	ConfigMaps & Secrets
7.	Volumes
8.	Ingress
9.	StatefulSet
10.	Helm
11.	Monitoring
12.	Security
13.	CI/CD
14.	GitOps
15.	Advanced Scheduling
________________________________________
34. Frequently Used Commands
Cluster Info
kubectl cluster-info
________________________________________
Get Nodes
kubectl get nodes
________________________________________
Get Pods
kubectl get pods
________________________________________
Get All Resources
kubectl get all
________________________________________
Describe Pod
kubectl describe pod <pod-name>
________________________________________
View Logs
kubectl logs <pod-name>
________________________________________
Execute Inside Pod
kubectl exec -it <pod-name> -- /bin/bash
________________________________________
Apply YAML
kubectl apply -f app.yaml
________________________________________
Delete Resource
kubectl delete -f app.yaml
________________________________________
35. Final Summary
Kubernetes architecture consists of:
Control Plane
Responsible for:
•	cluster management
•	scheduling
•	desired state
•	orchestration
Main components:
•	API Server
•	etcd
•	Scheduler
•	Controller Manager
________________________________________
Worker Nodes
Responsible for:
•	running containers
•	networking
•	pod execution
Main components:
•	kubelet
•	kube-proxy
•	container runtime
•	pods
________________________________________
Kubernetes continuously maintains:
Actual State == Desired State
This reconciliation model is the foundation of Kubernetes.
