# msrjdbc project

This project illustrates the management of JDBC connectivity in the Microservice Runtime, including JDBC notifications.
We point to a remote SQL Server instance and use the local UM (IS_LOCAL_CONNECTION) for the JDBC notifications part.

## Build

Here are the dependencies:
- /packages/MSRJDBC
- /packages/WmJDBCAdapter (not part of the default MSR image)
- /packages/WmArt (JDBC dependency, also not part of the default MSR image)
- /lib/dd-cjdbc.jar (MS SQL JDBC driver, since this is a public jar file it's not in this Github repo, you can find this file in the /opt/softwareag/common/lib/ext folder of your IS installation)
- /projects/msrjdbc/config/msrjdbc.properties (configuration properties for the Microservice runtime)

Don't run this Docker build directly in the build folder, it will fail.
The packages and config folders have to be in the Docker build context, so you need to be at the root of the repository to run these builds:
```
docker build -t $dockerId/$ImageName:$ImageVersion -f ./projects/msrjdbc/build/Dockerfile .
```

Once you have build the image you can push it to your favorite Docker registry. For instance with Docker hub:
```
docker push $dockerId/$ImageName:$ImageVersion
```

Note: if you're not logged in to Docker hub then you need to issue the following command before the previous one:
```
docker login -u $dockerId
```
It's going to ask you for a password. Enter your Docker hub Access Token here, not your password (see https://hub.docker.com/settings/security to create a token.)

## Deployment
