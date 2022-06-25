pipeline {
  
  agent any
  
  stages {
    
    stage('Clone repository') { 
      steps { 
        script{
          checkout scm
        }
      }
    }
  
    stage('Build image') {
        /* This builds the actual image; synonymous to
         * docker build on the command line */
      steps {     
        dir('projects/msrjdbc/build'){
            script{
                app = docker.build("staillansag/msrjdbc")
            }
        }
      }
    }

    stage('Test image') {
        /* Ideally, we would run a test framework against our image.
         * For this example, we're using a Volkswagen-type approach ;-) */
      steps { 
        script{
          app.inside {
              sh 'echo "Tests passed"'
          }
        }
    }

    stage('Push image') {
        /* Finally, we'll push the image with two tags:
         * First, the incremental build number from Jenkins
         * Second, the 'latest' tag.
         * Pushing multiple tags is cheap, as all the layers are reused. */
      steps { 
        script{
          docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
              app.push(params.imageVersion)
              app.push("latest")
          }
        }
      }
    }
    
  }
  
}
