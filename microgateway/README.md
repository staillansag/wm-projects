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

