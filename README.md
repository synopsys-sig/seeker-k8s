
## Deploy Seeker Server on Kubernetes

Deploy the Seeker server on Kubernetes by building and deploying the prepackaged Docker images.

**Prerequisites**  
* You have downloaded the Seeker installer for Linux, and have access to:
  * A Kubernetes cluster version 1.19 or higher
  * A Docker registry with push authorization
  * Helm version 2.x/3.x
* The installer file, for example, seeker-server-linux64-2022.6.0.sh, is copied to the ./images/installer/ folder

After you chose the *Kubernetes* deployment option in the installer, the Seeker Docker deployment package has been downloaded and extracted into the `seeker_docker` subfolder of the installation folder.

**Note:** You can customize any settings in the Dockerfiles, .yaml and .sh files.

To deploy the Seeker server on Kubernetes, perform the following steps:

### Build the Seeker Docker images.

Set the DOCKER_REGISTRY environment variable to your Docker registry host name, for example, my-registry.azurecr.io, and run the build script to build and publish all the images to your registry.
   ```
   cd images
   export DOCKER_REGISTRY=my-registry.azurecr.io
   ./build.sh
   ```

### Deploy the Seeker images to a Kubernetes cluster.

1. Navigate to the Seeker Helm chart folder:
   ```
   cd orchestrators/kubernetes/seeker
   ```
1. Create the Seeker Namespace:
   ```
   kubectl create ns seeker
   ```
1. Create a `secret.yaml` file to hold your database password. Use the following pattern, substituting the `dbpass` value with your password encoded with base64.
   ```
   apiVersion: v1
   kind: Secret
   metadata:
     name: seeker-dbpass
     namespace: seeker
   type: Opaque
   data:
     dbpass: dGVzdAo=   
   ```
   b. Deploy `secret.yaml`.
   ```
   kubectl apply -f secret.yaml
   ```

### Use the following installation options:

1. Install the Seeker chart (default).
   ```
   helm install --namespace seeker --set registry=${DOCKER_REGISTRY}  seeker .
   ```
1. Install with sizing restrictions.  
   Depending on your deployment size,  use the following command with the corresponding file name, for example, `medium.yaml`.
   ```
   helm install --namespace seeker --set registry=${DOCKER_REGISTRY} -f medium.yaml seeker .
   ```
   To choose the appropriate size, see Sizing Guidelines.
1. Install with a user-managed database:        
   ```
   helm install \
      --namespace seeker \
      --set registry=${DOCKER_REGISTRY} \
      --set seekerManagedDatabase.enabled=false \
      --set externalDatabaseHost=database-host \
      --set externalDatabasePort=5432 \
      --set externalDatabaseName=seeker-db \
      --set externalDatabaseUsername=seeker-user
      -f medium.yaml \
      seeker .
   ```

### Next Steps
The deployment might take a few minutes to complete. Once completed, verify its results.
```
kubectl get pods -n seeker
```
You should see an output similar to this:
```
NAME                               READY   STATUS    RESTARTS   AGE
seeker-nginx-d744bdf9d-jz2q6       1/1     Running   0          50s
seeker-postgres-7ccb44cdd7-6wqq5   1/1     Running   0          50s
seeker-sensor-5c474bf4f-dw2dr      1/1     Running   0          50s
seeker-server-67df999d68-m7zjt     1/1     Running   0          50s
```

**Note:**  
If you are using a single-node Kubernetes cluster, such as the one available when running Docker on a personal computer, the Seeker container exposes the 30080 (HTTP) and 30443 (HTTPS) ports of your cluster.

For multi-node Kubernetes clusters, configure your ingress controller to route external traffic to the Seeker service inside your cluster.
