# order-service-with-init.yaml
apiVersion: v1
kind: Pod
metadata:
  name: order-service
  labels:
    app: order
    project: shopeasy
spec:
  initContainers:
    - name: wait-for-db          # Runs FIRST, must succeed before main starts
      image: busybox
      command: ["sh", "-c", "echo 'Checking DB connection...'; sleep 5; echo 'DB is ready!'"]

    - name: run-migrations        # Runs SECOND after wait-for-db completes
      image: busybox
      command: ["sh", "-c", "echo 'Running DB migrations...'; sleep 3; echo 'Migrations done!'"]

  containers:
    - name: order-service         # Starts ONLY after ALL init containers succeed
      image: nginx
      ports:
        - containerPort: 80



#Init containers execute in strict sequence before any regular container starts, dependency checks, waiting for services ,configuration preparation etc
# In this Pod, we have two init containers:
# 1. `wait-for-db`: Simulates waiting for a database to be ready (sleeps for 5 seconds).
# 2. `run-migrations`: Simulates running database migrations (sleeps for 3 seconds).  
# The main application container (`order-service`) will only start after both init 
# containers have completed successfully. If any init container fails, the Pod will 
# be restarted until all init containers succeed. This ensures that the main
# application has all its dependencies met before it starts running.
# | Container            | State                             |
# | -------------------- | --------------------------------- |
# | Init Container 1     | Stopped (terminated successfully) |
# | Init Container 2     | Running or restarting             |
# | Main nginx container | Waiting/Pending                   |
# So when init container is executed, it will be stopped after completion, and the next init container
# will start. The main nginx container will be in waiting state until all init containers have completed successfully.




