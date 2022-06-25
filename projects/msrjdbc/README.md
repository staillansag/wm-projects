# msrjdbc project

This project illustrates various aspects of dealing with the Microservice Runtime (MSR):
- External configuration, including the use of K8S secrets for the MSR license file and the database password
- JDBC connectivity, including polling notifications
- Asynchronous messaging
- Exposition of a REST API
- Deployment to Azure Kubernetes Service
- Automation of this deloyment using Jenkins

## Overview

In a nutshell, this project replicates data from a source table into a target table.
- Data can be inserted into the source table using a REST API method: POST /msrjdbcAPI/sources
- There's a variant which inserts data in the source table asynchronously: POST /msrjdbcAPI/sources/message
- Data from the source table are exposed by a REST API: GET /msrjdbcAPI/sources
- Data is replicated from the source table into the source table by means of JDBC polling notifications, which trigger a replication flow service
- Data from the target table are exposed by a REST API: GET /msrjdbcAPI/targets
- There are also REST API methods to delete the content of the source and target tables: DELETE /msrjdbcAPI/sources and DELETE /msrjdbcAPI/targets

We use a local UM here, but with little adaptations it would also work with a standard (external) UM cluster.

## Build

Here are the dependencies:
- /packages/MSRJDBC
- /packages/WmJDBCAdapter (not part of the default MSR image)
- /packages/WmArt (JDBC dependency, also not part of the default MSR image)
- /lib/dd-cjdbc.jar (MS SQL JDBC driver)
- /projects/msrjdbc/config/msrjdbc.properties (configuration properties for the Microservice runtime)

Note: the MSR license file isn't included in the built image. It will be injected in the container during the deployment in Kubernetes.

Don't run this Docker build directly in the build folder, it will fail.
The packages and config folders have to be in the Docker build context, so you need to be at the root of the repository to run these builds:
```
docker build -t $dockerId/$imageName:$imageVersion -f ./projects/msrjdbc/build/Dockerfile .
```

Once you have build the image you can push it to your favorite Docker registry. For instance with Docker hub:
```
docker push $dockerId/$imageName:$imageVersion
```

Note: if you're not logged in to Docker hub then you need to issue the following command before the previous one:
```
docker login -u $dockerId
```
It's going to ask you for a password. Enter your Docker hub Access Token here, not your password (see https://hub.docker.com/settings/security to create a token.)

## Deployment

The Kubernetes deployment descriptors should work in any K8S cluster (Minikube, AKS, EKS, GKE.)
Once you've connected kubectl to your cluster you can use the kubectl apply command to perform the deployment.

### 00_msrjdbc_secrets.yaml

This descriptor contains the database password, encoded in base 64.
To encode your password in base 64 use this command:
```
echo -n "<<password>>" | base64 --wrap 0
```
You can then update the yaml file with the base 64 value.

### 00_licenses_secrets.yaml

This descriptor contains the product licenses.
You first need to encode the content of your MSR license file using:
```
cat <<location of license file>> | base64 --wrap 0
```
You can then update the yaml file with the base 64 value.

### 01_msrjdbc_dep.yaml

This file specifies the deployment of the pods.
Several environment variables are passed to the container:



You can adjust the number of replicas to your liking, as well as the resource specs (the limits I have allocated here are quite large, MSR containers should be able to run with a lower amount of CPU and RAM.)

### 02_msrjdbc_svc.yaml

This file specifies the service that exposes the pods traffic.
It's a Load balancer service that exposes a public IP and the port 5555 through which the underlying MSRs can be reached.
For the sake of simplicity we use plain HTTP here.

## Tests

To insert a record into the source table:
```
url --location --request POST 'http://$k8sServiceIP:5555/msrjdbcAPI/sources/' \
--header 'accept: application/json' \
--header 'Authorization: Basic QWRtaW5pc3RyYXRvcjptYW5hZ2U=' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode 'value=test'
```

Note: we've kept the default MSR credentials here: Administrator/manage
