
## Deploy Seeker Server on Kubernetes

Deploy the Seeker server on Kubernetes using the [Iron Bank](https://ironbank.dso.mil/repomap/products) registry.

**Prerequisites**  
  * A Kubernetes cluster version 1.19 or higher
  * Helm version 2.x/3.x

To deploy the Seeker server on Kubernetes, perform the following steps:

### Deploy the Seeker images to a Kubernetes cluster.

1. Clone the Seeker helm chart:
   ```
   git clone https://github.com/synopsys-sig/seeker-k8s
   cd seeker-k8s
   ```
1. Create the Seeker Namespace:
   ```
   kubectl create ns seeker
   ```
### Use the following installation options:

1. Create a secret that will hold your database password.
   a. Create a `secret.yaml`. Use the following pattern, substituting the `dbpass` value with your password encoded with base64.
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
   kubectl -n seeker apply -f secret.yaml
   ```
1. Create a docker registry sercret to pull the Seeker images from ironbank:
   ```
   kubectl -n seeker create secret docker-registry regcred \
      --docker-server=registry1.dso.mil/ironbank \
      --docker-username=user \
      --docker-password=password
   ```
1. Install the Seeker chart (default).
   ```
   helm install --namespace seeker --set imagePullSecrets=regcred --set externalDatabasePasswordSecret=seeker-dbpass seeker ./seeker
   ```
1. Install with sizing restrictions.  
   Depending on your deployment size,  use the following command with the corresponding file name, for example, `medium.yaml`.
   ```
   helm install --namespace seeker --set imagePullSecrets=regcred --set externalDatabasePasswordSecret=seeker-dbpass -f medium.yaml seeker ./seeker
   ```
   To choose the appropriate size, see Sizing Guidelines.
1. Install with a user-managed database:
   ```
   helm install \
      --namespace seeker \
      --set imagePullSecrets=regcred \
      --set seekerManagedDatabase.enabled=false \
      --set externalDatabaseHost=database-host \
      --set externalDatabasePort=5432 \
      --set externalDatabaseName=seeker-db \
      --set externalDatabaseUsername=seeker-user \
      --set externalDatabasePasswordSecret=seeker-dbpass \
      -f medium.yaml \
      seeker ./seeker
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
