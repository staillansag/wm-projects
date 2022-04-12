# Automated MSR Deployment demo

This project demonstrates the automated deployment of services developped locally using the SAG Designer to a cluster of MSR based microservices running in Kubernetes.

Here's what needs to be done to have it working on your side.

## Designer configuration

Develop the services using the Designer as usual. You will place these services in one or several packages that will be deployed in the MSR.

## GIT Configuration

What needs to be done: 
- push the local Integration Server packages (which you created using the Designer) to a remote git repository
- these packages are located in the installation directory of the Integration Server that is connected to the Designer

A procedure using the git command line tools is described here, but it's going to work with any git client.


Ensure git is installed in the local machine where the IS is running, for instance with this command: `git --version`

If git is not installed, go to https://git-scm.com/ and follow the documented installation procedure.

Create a remote git repository that will host the IS packages that will be deployed in the MSR.

Go to the directory where the IS packages are located.
In Linux this is usually going to be: `/opt/softwareag/IntegrationServer/instances/default`

You should see a packages directory there, where the packages we want to deploy in the MSR are located.

Configure a local git repository there, using the following command: `git init`

Still in the same local directory, copy the .gitignore file that is in the demo project. This will ensure you don't push unnecessary files to git.

Add each package you want to deploy in the MSR to the local git repository, using the `git add packages/<packageName>` command.

For instance if your package is named MSRDemo in the Designer, then the git command to execute is `git add packages/MSRDemo`

Commit your changes to the local git repository using the command `git commit -m "first commit"` (feel free to replace the "first commit" string with any relevant comment.)

Change the name of the current branch to main using the command `git branch -M main`

Connect the local repository to the remote one using this command: `git remote add origin <location of .git file>`

Finally, push the changes to the remote repository using `git push -u origin main`

It will ask you for a user name and password. If you use Github, note that you need to use a token instead of your Github password. To generate a token you can go to Settings / Developer Settings / Personal Access Tokens.


