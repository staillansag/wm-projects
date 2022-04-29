# Deployment

##  Objectives: 
-   set up the Kubernetes cluster (we will use Azure Kubernetes Services here, but it works nearly the same with any other Kubernetes environment)
-   set up the Kubernetes deployment descriptors (the yaml files)
-   do a first deployment in our Kubernetes cluster
-   check that everything is working as it should

##  Assumptions:
-   You have an Azure account
-   Azure CLI is installed in your machine (you can also use the Azure Cloud shell as an alternative)

##  Create the AKS cluster:
1.  Position a few shell variables:
    ```
    location=westeurope         #Use "az account list-locations -o table" to list the available Azure locations
    resourceGroup=aks_group
    clusterName=msrdemoaks      #This name must be globally unique
    clusterNodeCount=1          #Number of worker nodes in the cluster (1 is sufficient for a demo, to save costs)
    vmSize=Standard_B2ms        #VM with 2 cores and 8 Gb RAM (the more expensive Standard_B4ms can also be used with 4 cores / 16 Gb RAM)
    ```
2.  Create a resource group: 
    ```
    az group create --location $location --name $resourceGroup
    ```
3.  Create the cluster: 
    ```
    az aks create --resource-group $resourceGroup --name $clusterName --location $location --node-count $clusterNodeCount --node-vm-size $vmSize
    ```

    Note: to save costs, the AKS server can be stopped when it's no longer needed using this command `az aks stop --resource-group $resourceGroup --name $clusterName` and restarted later using `az aks start --resource-group $resourceGroup --name $clusterName`
        
##  Configure the AKS cluster 
    
(we reuse the same shell variables positionned in the previous section)

1.  Enable the AKS HTTP Application routing addon, which will be in charge of the Ingress part (behind the scenes it installs an nginx ingress controller):
    ```
    az aks enable-addons --resource-group $resourceGroup --name $clusterName --addons http_application_routing
    ```
2.  Check the deployment of the nginx ingress using this command:
    ```
    kubectl get svc -n kube-system
    ```
    The output should be similar to the following:
    ```
    NAME                                           TYPE           CLUSTER-IP    EXTERNAL-IP      PORT(S)                      AGE
    addon-http-application-routing-nginx-ingress   LoadBalancer   10.0.29.88    52.157.228.200   80:31126/TCP,443:32386/TCP   72m
    kube-dns                                       ClusterIP      10.0.0.10     <none>           53/UDP,53/TCP                3d16h
    metrics-server                                 ClusterIP      10.0.113.30   <none>           443/TCP                      3d16h
    ```
    
##  Create the Kubernetes deployment descriptors. 

To help you, you can make a copy of [the yaml files of this project](https://github.com/staillansag/wm-packages/tree/main/deployment) and modify them as follows:
1. 01-msrdemo-dep.yaml: this is the main deployment descriptor, used by K8S to manage the pods. We specify 3 instances with rolling updates here. You just need to replace all `msrdemo` mentions with the name of your microservice, the other settings will work fine.
2. 02-msrdemo-svc.yaml: it specifies the service that's on top of the pods. Just replace all `msrdemo` mentions with the name of your microservice.
3. 99-ingress.yaml: it specifies the ingress controller that exposes the service to the outside world (it's some sort of reverse proxy.) Just replace all `msrdemo` mentions with the name of your microservice.

##  Load the deployment deployment descriptors in AKS using the kubectl utility
1.  Ensure kubectl points to the correct cluster, by submitting this command: 
    ```
    az aks get-credentials --resource-group $resourceGroup --name $clusterName
    ```
3.  In the folder where the 3 yaml files are located, issue this command: 
    ```
    kubectl apply -f .
    ```
5.  Wait for about a minute and check that the 3 pods are running using the following command: 
    ```
    kubectl get pods
    ```
    It should return something of the sort:
    ```
    NAME                                                      READY   STATUS    RESTARTS   AGE
    msrdemo-56cf6fd577-95m6k                                  1/1     Running   0          9s
    msrdemo-56cf6fd577-rjkbg                                  1/1     Running   0          9s
    msrdemo-56cf6fd577-x2nqf                                  1/1     Running   0          9s
    ```
7.  Check that the service is also running using 
    ```
    kubectl get svc
    ```
    It should return something of the sort:
    ```
    NAME                                               TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)                      AGE
    kubernetes                                         ClusterIP      10.0.0.1       <none>           443/TCP                      3d17h
    msrdemo                                            ClusterIP      10.0.224.20    <none>           80/TCP                       13s
    ```
9.  Finally, check that the ingress controller is up and running using 
    ```
    kubectl get ingress
    ```
    It should return something of the sort:
    ```
    NAME              CLASS    HOSTS   ADDRESS          PORTS   AGE
    msrdemo-ingress   <none>   *       52.157.228.200   80      57s
    ```

    You can use the IP address expose by this command to call the service. By default the ingress exposes these services on port 80.

    Note: it can take a couple of minutes for the IP address to be allocated to the Ingress, if you see an empty address field then wait and rerun the same command.
        
##  Call the service
You can for instance issue the following curl command.
Here we pass it the default IS admin user / password, and we have also positionned a `ipAddress` variable that contains the IP address of the ingress.
```
curl -u Administrator:manage --header 'Accept: application/json' http://$ipAddress/api/contacts/1
```
    
