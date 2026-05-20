kubectl apply -f product-pod.yaml


1. kubectl reads YAML → validates it locally
2. kubectl Converts YAML to JSON
2. kubectl sends HTTP POST to API Server
   POST https://<cluster>/api/v1/namespaces/default/pods
3. API Server authenticates (are you allowed to create pods?)
4. API Server validates the manifest (correct fields?)
5. API Server writes to etcd (persistent cluster state)
6. Scheduler watches etcd → sees unscheduled pod
7. Scheduler picks best node → writes nodeName to pod spec in etcd
8. Kubelet on that node watches etcd → sees pod assigned to it
9. Kubelet tells Docker/containerd → pull image, start container
10. Kubelet updates pod status → Running
11. kubectl get pods → reads from API Server → shows Running



What is etcd?
A distributed key-value database. Stores entire cluster state:
        pods
        deployments
        services
        secrets
        namespaces
    Everything.

Kubernetes Scheduler continuously watches API server. it sees New pod without node assignment
Scheduler chooses best node based on: CPU, Memory etc
    
