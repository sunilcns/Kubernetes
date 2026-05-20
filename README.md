Quick Commands:

minikube start        # start your cluster
minikube stop         # stop when done for the day
minikube status       # health check
minikube dashboard    # visual UI in browser (useful!)
kubectl get nodes     # confirm cluster is alive

- Apply it to your cluster
    kubectl apply -f product-pod.yaml

- Watch it come alive
    kubectl get pods
    kubectl get pods -w

- Get full details
    kubectl describe pod product-service

- Check logs (like docker logs)
    kubectl logs product-service

- Exec into it (like docker exec)
    kubectl exec -it product-service -- /bin/bash
    # inside the pod, run: curl localhost && exit

- current runtime state and yaml definition  of the pod named product-service
  It shows the  desired state and actual state
    kubectl get pod product-service -o yaml  -> runtime with yaml format 
    kubectl get pod product-service -o json  -> runtime with json format 
    kubectl get pod product-service -o wide  -> Extended table 
    kubectl get pod product-service -o name -> give only name 
    This also gives runtime crash details, ip address, which image is running , env variables 
    inspect runtime config, analyze crashes

- Quick commands in script to get the runtime values 
    restart count -> To check if the pod is restarting freq
    kubectl get pod product-service -o jsonpath='{.status.containerStatuses[*].restartCount}'
    
    to get pod ip 
    kubectl get pod product-service -o jsonpath='{.status.hostIP}'

    to check container readiness 
    kubectl get pod product-service -o jsonpath='{.status.containerStatuses[*].ready}'

    to get image :
    kubectl get pod product-service -o jsonpath='{.spec.containers[*].image}'


- What Node is it Running On?
    kubectl get pod product-service -o wide
        In minikube:         Only 1 node (minikube itself) → all pods land here
        In real AWS EKS production:
        Node = EC2 instance (e.g., m5.large)






    

kubectl get pod product-service -o jsonpath='{.status.podIP}'


kubectl get pods                    → What is the STATUS?
kubectl describe pod <name>         → WHY (check Events section)
kubectl logs <name>                 → What did the app print?
kubectl logs <name> --previous      → Logs from CRASHED container
kubectl exec -it <name> -- sh       → Get inside and investigate

Common statuses and causes:
├── ImagePullBackOff  → Wrong image name/tag or private registry
├── CrashLoopBackOff  → App crashes on startup (check logs!)
├── Pending           → No node has enough CPU/Memory
├── OOMKilled         → Exceeded memory limit
└── Error             → Container exited with non-zero code

kubectl scale deployment product-deployment --replicas=3


List pods	kubectl get pods
List pods in namespace	kubectl get pods -n dev
Detailed pod info	kubectl get pods -o wide
Describe pod	kubectl describe pod <pod-name>
View pod logs	kubectl logs <pod-name>
Follow live logs	kubectl logs -f <pod-name>
Enter pod shell	kubectl exec -it <pod-name> -- /bin/bash
Create pod quickly	kubectl run nginx --image=nginx
Delete pod	kubectl delete pod <pod-name>
Create deployment	kubectl create deployment nginx --image=nginx
List deployments	kubectl get deployments
Scale deployment	kubectl scale deployment nginx --replicas=3
Delete deployment	kubectl delete deployment nginx
Apply YAML file	kubectl apply -f app.yaml
Delete YAML resources	kubectl delete -f app.yaml
List services	kubectl get svc
Create namespace	kubectl create namespace dev
List namespaces	kubectl get ns
Get all resources	kubectl get all
Get all resources in namespace	kubectl get all -n dev
Show labels	kubectl get pods --show-labels
Filter by label	kubectl get pods -l app=web
Check events	kubectl get events
Generate YAML	kubectl run nginx --image=nginx --dry-run=client -o yaml
See ConfigMaps	kubectl get cm
See Secrets	kubectl get secrets
Switch default namespace	kubectl config set-context --current --namespace=dev

<img width="1031" height="649" alt="image" src="https://github.com/user-attachments/assets/ed8f9451-8b50-4cf5-8520-5488b3586665" />



