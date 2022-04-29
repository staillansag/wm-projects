# Automated MSR Deployment demo

This project demonstrates the automated deployment of services developped locally using the SAG Designer to a cluster of MSR based microservices running in Kubernetes.

Here's what needs to be done to have it working on your side.

## Designer configuration

Develop the services using the Designer as usual. You will place these services in one or several packages that will be deployed in the MSR.

## GIT Configuration

### Objectives: 
- push the local Integration Server packages (which you created using the Designer) to a remote git repository (we will use Github)

### Assumptions:
- you have the git cli installed in the machine that hosts the integration server (any graphical git client could also be used, but the following instructions work with the cli)
- you have a Github account

### What needs to be done:
1.  Create a remote git repository that will host the IS packages that will be deployed in the MSR.
2.  Go to the directory where the IS packages are located. In Linux this is usually going to be: `/opt/softwareag/IntegrationServer/instances/default`
    You should see a `packages` directory there, where the packages we want to deploy in the MSR are located.
3.  Configure a local git repository there, using the following command: `git init`
4.  Still in the same local directory, copy the .gitignore file that is in the demo project. This will ensure you don't push unnecessary files to git.
5.  Add each package you want to deploy in the MSR to the local git repository, using the `git add packages/<packageName>` command.
    For instance if your package is named MSRDemo in the Designer, then the git command to execute is `git add packages/MSRDemo`
6.  Commit your changes to the local git repository using the command `git commit -m "first commit"` (feel free to replace the "first commit" string with any relevant comment.)
7.  Change the name of the current branch to main using the command `git branch -M main`
8.  Connect the local repository to the remote one using this command: `git remote add origin <url of .git file>`
9.  Finally, push the changes to the remote repository using `git push -u origin main`
    It will ask you for a user name and password. If you use Github, note that you need to use a token instead of your Github password. To generate a token you can go to Settings / Developer Settings / Personal Access Tokens.

## Build Configuration

See https://github.com/staillansag/wm-packages/blob/main/build/README.md

### Objectives: 
-   Set up the build environment
-   build a first Docker image that contains the MSR license file and the IS packages that were pushed to git
-   tag this image and push it to a Docker repository (we will use Docker hub here, but any Docker repsository could be used)

### Assumptions:
-   Docker is installed in the machine where you will perform the build (we will call it the build server.)
-   You have a Docker hub account

### What needs to be done:
1.  Create a directory somewhere in the build server
2.  Create a resources sub-folder and place your MSR license file in it (xml file)
3.  Create a source sub-folder and place yourself into this folder
4.  Clone the git repository where your pushed the packaged using this command: `git clone <url of .git file>`
5.  Move one level up (to the root of your build directory) and copy the Dockerfile that is in this project
6.  Run this command to build the Docker image: `docker build -t $dockerId/$serviceName:$serviceVersion` where
    - `$dockerId` is your ID in the Docker repository where you will subsequently push the image
    - `$serviceName` is the name of your microservice
    - `$serviceVersion` is the version of your microservice (for instance 1.0.0)
7.  Push the image to Docker hub: 
    - in the CLI, login to Docker hub using the `docker login` command. Remember that, just like git, docker hub expects you to provide a token by means of a password.
    - Enter the following command to push the image: `docker push $dockerId/$serviceName:$serviceVersion`
8.  TODO: push an alias of the image with serviceVersion = latest

## Deployment configuration

### Objectives: 
-   set up the Kubernetes cluster (we will use Azure Kubernetes Services here, but it works nearly the same with any other Kubernetes environment)
-   set up the Kubernetes deployment descriptors (the yaml files)
-   do a first deployment in our Kubernetes cluster
-   check that everything is working as it should

### Assumptions:
-   You have an Azure account
-   Azure CLI is installed in your machine (you can also use the Azure Cloud shell as an alternative)

### What needs to be done:
1.  Create the AKS cluster:
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
        
2.  Configure the AKS cluster (we reuse the same shell variables positionned in the previous section):
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
3.  Create the Kubernetes deployment descriptors. To help you, you can make a copy of the yaml files of this project and modify them as follows:
    1. 01-msrdemo-dep.yaml: this is the main deployment descriptor, used by K8S to manage the pods. We specify 3 instances with rolling updates here. You just need to replace all `msrdemo` mentions with the name of your microservice, the other settings will work fine.
    2. 02-msrdemo-svc.yaml: it specifies the service that's on top of the pods. Just replace all `msrdemo` mentions with the name of your microservice.
    3. 99-ingress.yaml: it specifies the ingress controller that exposes the service to the outside world (it's some sort of reverse proxy.) Just replace all `msrdemo` mentions with the name of your microservice.

4.  Load the deployment deployment descriptors in AKS using the kubectl utility
    1.  Ensure kubectl points to the correct cluster, by submitting this command: `az aks get-credentials --resource-group <resource_group> --name <cluster_name>`
    2.  In the folder where the 3 yaml files are located, issue this command: `kubectl apply -f .`
    3.  Wait for about a minute and check that the 3 pods are running using the following command: `kubectl get pods`
    4.  Check that the service is also running using `kubectl get svc`
    5.  Finally, check that the ingress controller is up and running using `kubectl get ingress`. You should see an external IP in the output of this command, use it to call the services deployed in the MSR. By default the ingress exposes these services on port 80.

## Towards continuous deployment
