# Build Configuration

## Objectives: 
-   Set up the build environment
-   build a first Docker image that contains the MSR license file and the IS packages that were pushed to git
-   tag this image and push it to a Docker repository (we will use Docker hub here, but any Docker repsository could be used)

## Assumptions:
-   Docker is installed in the machine where you will perform the build (we will call it the build server.)
-   You have a Docker hub account

## What needs to be done:
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
