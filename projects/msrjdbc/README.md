# msrjdbc project

This project illustrates the management of JDBC connectivity in the Microservice Runtime, including JDBC notifications.
We point to a remote SQL Server instance and use the local UM (IS_LOCAL_CONNECTION) for the JDBC notifications part.

The MSR exposes a very simple REST API that inserts a record in a source table msrjdbc_source (classical JDBC connectivity): 
```
POST /msrjdbcAPI/sources/
```
A JDBC Insert notification is configured onto the source table. It creates a new UM message with each insert and this message is sent to a local UM queue.
A UM trigger listens to this queue and replicates the source table record into a target table msrjdbc_target

## Build

Here are the dependencies:
- /packages/MSRJDBC
- /packages/WmJDBCAdapter (not part of the default MSR image)
- /packages/WmArt (JDBC dependency, also not part of the default MSR image)
- /lib/dd-cjdbc.jar (MS SQL JDBC driver, since this is a public jar file it's not in this Github repo, you can find this file in the /opt/softwareag/common/lib/ext folder of your IS installation)
- /config/msr.xml (MSR license file, since this is a confidential file it's not in the Github repo, you need to place your license file into the /config folder and name it msr.xml before the build
- /projects/msrjdbc/config/msrjdbc.properties (configuration properties for the Microservice runtime)

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
Once you've connected lubectl to your cluster you can use the kubectl apply command to perform the deployment (but you'll have to edit the deployment descriptors before doing so.)

### 01_msrjdbc_dep.yaml

This file specifies the deployment of the pods.
You need to change the image name to point to the one you've pushed to Docker hub.
You can also adjust the number of replicas to your liking, as well as the resource specs (the limits I have allocated here are quite large, MSR containers should be able to run with a lower amount of CPU and RAM.)

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