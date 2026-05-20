
https://www.geeksforgeeks.org/devops/kubernetes-labels-selectors/

Challenge 7 — Labels & Selectors (The Glue of Kubernetes)
# Create 3 pods with different labels
kubectl run frontend  --image=nginx --labels="app=frontend,tier=web,project=shopeasy"
kubectl run product   --image=nginx --labels="app=product,tier=api,project=shopeasy"
kubectl run order     --image=nginx --labels="app=order,tier=api,project=shopeasy"

# Now filter with labels — this is how Services route traffic
kubectl get pods -l app=product
kubectl get pods -l tier=api
kubectl get pods -l project=shopeasy
kubectl get pods -l tier=api,project=shopeasy    # AND condition
kubectl get pods --show-labels                    # See all labels


Labels are key/value pairs that you attach to Kubernetes objects like Pods, Deployments, and Services. They are the primary way to organize your resources. Common examples of labels include:



What are Labels?
Labels are key/value pairs attached to Kubernetes objects.
They are used for identifying, grouping, and selecting objects.
Labels are arbitrary and flexible, for example:
        app: product
        project: ShopEasy
        tier: frontend
        env: staging
Where Labels are used
        Pods
        Services
        Deployments
        ReplicaSets
        ConfigMaps, Secrets, and many other resources
Example:
        metadata:
        labels:
            app: product
            project: ShopEasy


What are Selectors?
Selectors let you choose objects based on their labels.
They are used by controllers and services to target the right Pods.
Common selectors include:
        matchLabels
        matchExpressions

Example:
        selector:
        matchLabels:
            app: product


How they work together
A Pod gets labels.
A Service or Deployment uses a selector to find Pods with matching labels.
This lets Kubernetes wire resources together without hard-coding names.


1. Equality-Based Selection Find all Pods in the development environment.
$ kubectl get pods -l environment=development

Find all Pods that are part of the backend tier.
$ kubectl get pods -l tier=backend

You can also combine selectors with a comma. Find the Pod that is both backend and production.
$ kubectl get pods -l 'tier=backend,environment=production'

2. Set-Based Selection Find all Pods in either the development or staging environment.
$ kubectl get pods -l 'environment in (development,staging)'

Find all Pods that do not have the tier label set to frontend.
$ kubectl get pods -l 'tier notin (frontend)'

Find all Pods that have an app label, regardless of its value (the exists operator).
$ kubectl get pods -l 'app'
