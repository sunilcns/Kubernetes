Incoming request → Service (order-service)
                        │
              selector: app=order-service
                        │
          ┌─────────────┴──────────────┐
          │                            │
    track=stable                  track=canary
    (3 pods, nginx:1.25)          (1 pod, nginx:1.26)
          │                            │
    75% of traffic               25% of traffic



    Keep v1.25 running for most customers (75%)
Send only 25% of customers to v1.26 (the "canary")

Watch for 24 hours:
  ├── No errors?    → Gradually shift more traffic to v1.26
  └── Errors found? → Kill v1.26 instantly, 75% never affected

This is what Netflix, Amazon, Google all do.

Why Canary :
Coal miners sent a canary bird into mines first.
If canary died → dangerous gas present → miners stay out.
If canary survived → safe for everyone to enter.

v1.26 = your canary
25% of users = the "test miners"
75% on v1.25 = safely waiting

<img width="752" height="551" alt="image" src="https://github.com/user-attachments/assets/d5ad9c12-ebdd-424d-9ef9-07ba41543d9e" />


<img width="1135" height="618" alt="image" src="https://github.com/user-attachments/assets/727ab87d-db81-4b24-8f2c-b293b04cc82e" />


<img width="1206" height="571" alt="image" src="https://github.com/user-attachments/assets/119e8704-1de0-484c-920a-7913eb3a0961" />


<img width="785" height="446" alt="image" src="https://github.com/user-attachments/assets/c66523b9-1bf6-40f0-8ae6-fa652faf74ae" />



<img width="741" height="477" alt="image" src="https://github.com/user-attachments/assets/87147d8b-5e41-4148-a8a1-b91c5dfca640" />

apiVersion: v1
└── Services live in core "v1" group (same as Pods)

kind: Service
└── Creates a stable network endpoint + load balancer
└── Gives a DNS name: order-service.shopeasy-dev.svc.cluster.local
└── Other pods call: http://order-service (K8s resolves automatically)

metadata.name: order-service
└── This becomes the DNS name inside the cluster
└── frontend pod calls: http://order-service/api/orders
└── Never changes, even as pods die and get new IPs

selector:
  app: order-service
└── Find ALL pods with this label (both stable AND canary)
└── Does NOT have "track" label → intentionally finds both
└── Result: routes to all 4 pods (3 stable + 1 canary)

ports:
  port: 80        ← the port Service listens on (what callers use)
  targetPort: 80  ← the port on the pod to forward to
  
  Other pods call: http://order-service:80
  Service forwards to: pod-ip:80
  
  These can be different:
  port: 8080, targetPort: 80
  → callers use 8080, pods run on 80

  The YAML file has 3 completely separate sections
divided by "---"

Each "---" = a brand new independent Kubernetes resource.



# shopeasy-canary.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: order-service-stable
  namespace: shopeasy-dev          # ✅ Fix 2: namespace added
  labels:
    app: shopeasy
    track: stable
spec:
  replicas: 3
  selector:
    matchLabels:
      app: order-service           # ✅ Fix 1: cleaner shared label
      track: stable
  template:
    metadata:
      labels:
        app: order-service         # ✅ Fix 1: matches selector
        track: stable
        version: "v1.25"
        project: shopeasy
    spec:
      containers:
      - name: order-service
        image: nginx:1.25
        ports:
        - containerPort: 80
        resources:                 # ✅ Fix 3: limits added
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: order-service-canary
  namespace: shopeasy-dev          # ✅ Fix 2
  labels:
    app: shopeasy
    track: canary
spec:
  replicas: 1
  selector:
    matchLabels:
      app: order-service           # ✅ Fix 1: same shared label
      track: canary
  template:
    metadata:
      labels:
        app: order-service         # ✅ Fix 1
        track: canary
        version: "v1.26"
        project: shopeasy
    spec:
      containers:
      - name: order-service
        image: nginx:1.26
        ports:
        - containerPort: 80
        resources:                 # ✅ Fix 3
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
---
apiVersion: v1
kind: Service
metadata:
  name: order-service
  namespace: shopeasy-dev          # ✅ Fix 2
spec:
  selector:
    app: order-service             # ✅ Fix 1: intentional, clean
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80


[canary_deploy.yaml](https://github.com/user-attachments/files/28110785/canary_deploy.yaml)






