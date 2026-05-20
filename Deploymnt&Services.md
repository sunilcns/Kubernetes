
Kubernetes: Deployment & Services
https://reeshabh-choudhary.medium.com/kubernetes-deployment-services-ceb96d048db9


1. Deployment
A Deployment's job is:
  create Pods
  maintain desired replicas
  restart failed Pods
  rolling updates
  scaling

2. Service
Service solves this networking problem.
A Service provides:
  stable IP
  stable DNS name
  load balancing

  | Deployment             | Service                  |
| ---------------------- | ------------------------ |
| Manages Pods           | Connects to Pods         |
| Handles scaling        | Handles networking       |
| Creates containers     | Routes traffic           |
| Ensures app is running | Ensures app is reachable |





<img width="848" height="563" alt="image" src="https://github.com/user-attachments/assets/0bbc03d6-de50-41fe-bd23-26a8b7dd6060" />
