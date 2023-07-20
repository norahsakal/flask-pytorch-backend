pipeline {
  agent any
  
  stages {
    stage('Install Minikube and Docker') {
      steps {
        sh 'curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64'
        sh 'sudo install minikube-linux-amd64 /usr/local/bin/minikube'
        sh 'minikube start'
      }
    }
    
    stage('Clone Git repository') {
      steps {
        git 'https://github.com/norahsakal/flask-pytorch-backend'
      }
    }
    
    stage('Containerize and Push to Docker Hub') {
      steps {
        //create local private registry in minikube env
        sh "eval $(minikube docker-env)"
        sh "docker run -d -p 5000:5000 --restart=always --name my-registry registry:2"

        //build and push docker images to private registry 
        dir('flask-pytorch-backend') {
          sh 'docker build -t backend-image:v1 -f backend/Dockerfile .'
          sh 'docker push backend-image:v1'

          sh 'docker build -t frontend-image:v1 -f frontend/Dockerfile .'
          sh 'docker push frontend-image:v1'
        }

        //verification
        sh "minikube image list"
      }
    }

    stage('Deploy helm charts'){
        dir('flask-pytorch-backend') {
            sh "helm install frontend ./helm/frontend-chart"
            sh "helm install backend ./helm/backend-chart"
        }
    }
}
post{
    cleanup{
        deleteDir
    }
}
