# MSR demo with microgateway

The MSR based microservices can be secured using the SAG Microgateway.
We will describe here a Kubernetes deployment with the MSR microservice as a side-car of the microgateway:
- Each pod has two containers:
    - one is the microgateway
    - the other is the MSR microservice itself 
- A Kubernetes service provides a unique entry point for the pods.
- Finally on ingress controller exposes the service to the outside world

![Kubernetes deployment structure](https://github.com/staillansag/wm-packages/blob/main/microgateway/K8S_SideCarDeployment.png)

