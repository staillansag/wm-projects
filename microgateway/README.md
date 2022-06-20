# MSR demo with microgateway

The MSR based microservices can be secured using the SAG Microgateway.
We will describe here a Kubernetes deployment with the microgateway as a side car of the MSR microservice:
- Each pod has two containers:
    - one is the microgateway
    - the other is the MSR microservice itself 
- A Kubernetes service provides a unique entry point for the pods.
- Finally on ingress controller exposes the service to the outside world

![Kubernetes deployment structure](https://github.com/staillansag/wm-packages/blob/main/microgateway/K8S_SideCarDeployment.png)

Here are the steps to have this deployment working.

## API Gateway configuration

TODO

## Microgateway image build

For convenience we will work in the microgateway install directory (the one where the microgateway.sh file is located.)

### Generate a custom settings yaml file

We create a msrdemo-mcgw-config.yaml file that contains:
-   Information to connect to the API gateway and retrieve assets
-   The microgateway listening port
-   The aliases (which contain information such as backend urls, authentication information, ...)

### Generate the Dockerfile

We can use the microgateway.sh utility to generate this file:
```
./microgateway.sh createDockerFile -c msrdemo-mcgw-config.yaml -docker_file DockerFileMSRDemoMCGW -dod .
```

It creates a DockerFileMSRDemoMCGW file as well as a tmp-docker folder.

### Build the docker image and push it to Docker hub

We can issue a simple Docker build command here, passing it the location of the Docker file we previously generated:
```
docker build -t $dockerId/$mcgwImageName:$mcgwImageVersion -f DockerFileMSRDemoMCGW .
```

We can then push the image to Docker hub (after logging in, if necessary):
```
docker push $dockerId/$mcgwImageName:$mcgwImageVersion
```

## MSR microservice build

See the main README.md page of this github project.
The addition of the microgateway does not impact the way the MSR microservice image is built.

## Deployment

### Preparation of the Kubernetes cluster

See [Create the AKS cluster](https://github.com/staillansag/wm-packages/blob/main/DEPLOYMENT.md#create-the-aks-cluster) and [Configure the AKS cluster](https://github.com/staillansag/wm-packages/blob/main/DEPLOYMENT.md#configure-the-aks-cluster)

### Generation of the Kubernetes deployment descriptors

We can use the microservices.sh to generate a yaml deployment file: 
```
./microgateway.sh createKubernetesFile 
    --docker_image $dockerId/$mcgwImageName:$mcgwImageVersion \
    --pod_name msrdemo-sidecar \
    --sidecar_docker_image $dockerId/$msrImageName:$msrImageVersion \
    --sidecar_pod_name msrdemo-service \
    --output msrdemo-mcgw-deployment.yml \
    -gw $apiGatewayUrl \
    -gwu $apiGatewayUser \
    -rep $nbReplica
```

However the generated file needs to be modified before it can be used:
-   A Kubernetes secret needs to be created, which holds the API gateway password
-   A reference to this secret must be added
-   The service gateway url must be removed
-   The service port must be changed from 0 to 9090
-   the service nodePort must be removed

As an alternative to the generated yaml file you can use the [set of yaml deployment descriptors provided in this projet](https://github.com/staillansag/wm-packages/tree/main/microgateway/deployment).

####   00-msrdemo-secrets.yaml

This descriptor is used to create a secret which stores the password of the ID Administrator user.
The password must be encoded in base64. You can use the following command:
```
echo -n 'replace with your password' | base64
```

####    01-msrdemo-dep.yaml

This descriptor specifies the pods.
Compared to the standalone MSR deployment, we have here 2 containers per pod: one is the microgateway, the other is the MSR based microservice

####    02-msrdemo-svc.yaml

This descriptor specifies the service that fronts the pods.
Compared to the standalone MSR deployment, we point here to the microgateway port (9090) instead of the MSR port (5555.)
All calls to the pods must therefore go through the microgateway.

####    99-ingress.yaml

This descriptor specifies the ingress controller that exposes the service to the outside world.
In the the standalone MSR deployment we used exactly the same file.


### Load the deployment deployment descriptors in AKS using the kubectl utility

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
    msrdemo-mcgw-557ccf8f9f-f4pfr                             2/2     Running   0          2m38s
    msrdemo-mcgw-557ccf8f9f-xqsv7                             2/2     Running   0          2m38s
    ```
7.  Check that the service is also running using 
    ```
    kubectl get svc
    ```
    It should return something of the sort:
    ```
    NAME                                               TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)                      AGE
    kubernetes                                         ClusterIP      10.0.0.1       <none>           443/TCP                      3d19h
    msrdemo-mcgw                                       ClusterIP      10.0.12.227    <none>           80/TCP                       4m18s
    ```
9.  Finally, check that the ingress controller is up and running using 
    ```
    kubectl get ingress
    ```
    It should return something of the sort:
    ```
    NAME              CLASS    HOSTS   ADDRESS          PORTS   AGE
    msrdemo-ingress   <none>   *       52.157.228.200   80      4m53s
    ```

    You can use the IP address expose by this command to call the service. By default the ingress exposes these services on port 80.

    Note: it can take a couple of minutes for the IP address to be allocated to the Ingress, if you see an empty address field then wait and rerun the same command.
        
##  Call the service
You can for instance issue the following curl command.
Here we pass it the default IS admin user / password, and we have also positionned a `ipAddress` variable that contains the IP address of the ingress, as well as an `apiKey` variable that contains the API key of the application created in the API gateway.
```
curl http://$ipAddress/gateway/ContactsAPI/1.0/contacts/1 --header 'Accept: application/json' --header "x-gateway-apikey: $apiKey"
```
