# webMethods projects

This Github repository contains a few webMethods Integration Server and Microservice Runtime projects.

## Repository structure

### config

Points to the config directory of my integration server installation (usually /opt/softwareag/IntegrationServer/instances/default/config)
I only commit and push files that are necessary for a MSR deployment here (for instance definitions of Universal Messaging connection aliases.)

### packages

Points to the packages directory of my integration server installation (usually /opt/softwareag/IntegrationServer/instances/default/config)
It contains the packages I created in the Designer, plus a few other Wm* packages that are needed for a MSR deployment (for instance the WmART and WmJDBCAdapter which are needed for JDBC connectivity.)


### projects

Contains assets for configuring, building and deploying projects.
There's one sub-folder for project, with the same sub-structure:

#### config

Contains the application properties.

#### build

Contains the assets to build the solution (for instance a Dockerfile)

#### deployment

Contains the assets to deploy the solution (for instance Kubernetes deployment descriptors.)

## Important notes

Don't run Docker builds directly in the projects' build folder, it will fail.
The packages and config folders have to be in the Docker build context, so you need to be at the root of the repository to run these builds. Here's an example:
```
docker build -t $dockerId/$ImageName:$ImageVersion -f ./projects/msrjdbc/build/Dockerfile .
```
