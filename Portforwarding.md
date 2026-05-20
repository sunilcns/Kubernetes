Port forwarding maps a local port on your machine to a port on a remote service or pod. It lets you 
connect to an app running inside a cluster or remote host as if it were running locally.

kubectl run product-service --image=nginx  --labels="app=product,project=shopeasy"
    -> Pulls nginx image, Creates container, Starts nginx web server, Pod becomes Running

kubectl port-forward <resource> <local-port>:<container-port>
kubectl port-forward pod/product-service 8080:80
You are creating a tunnel:
Laptop localhost:8080
        │
        ▼
Kubernetes Pod port 80

Because nginx web server listens on: port 80

Why Port 8080 Locally?
in laptop 8080 is commonly used for testing. we can use 9090 but cannot replace pod port 80 with 90 or so. 

8080:80 means:
“Take traffic from my laptop port 8080 and send it to pod port 80.”


http://localhost:8080


| Usage                | Example               |
| -------------------- | --------------------- |
| Testing apps locally | Web apps              |
| Debugging            | Internal services     |
| Access dashboards    | Grafana/Kibana        |
| Database testing     | MySQL/Postgres        |
| API testing          | Backend microservices |


Very Important Difference
| Method       | Purpose                     |
| ------------ | --------------------------- |
| Service      | Permanent networking        |
| Port-forward | Temporary debugging/testing |

Real Production

In production, users usually access apps through:
        Services
        Ingress
        LoadBalancer
Port-forward is mainly:
        developer/debugging tool

Most web servers use:
| Service    | Default Port |
| ---------- | ------------ |
| nginx      | 80           |
| Apache     | 80           |
| HTTPS      | 443          |
| MySQL      | 3306         |
| PostgreSQL | 5432         |







