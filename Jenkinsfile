pipeline {
    agent any
     tools {
      git "newgit"
   }
    stages{
       stage('checkout') {
        stepsi {
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'git', url: 'https://github.com/sunilvirat/node.git']]])
        }
                }

        stage('Build Docker Image'){
            steps{
                sh "docker build . -t venkatasunil/nodeapp:${BUILD_NUMBER}"
            }
        }
    stage('Publish image'){
      steps{
          withCredentials([string(credentialsId: 'docker_pwd', variable: 'dockerhub_pwd')]) {
          sh "docker login -u venkatasunil -p ${dockerhub_pwd}"
          sh "docker push venkatasunil/nodeapp:${BUILD_NUMBER}"
              }
          }    
        }
    stage('update Image Version'){
      
      steps {
          
    sh label: '', script: '''sed -i s/latest/$BUILD_NUMBER/ dockerstack.yaml'''
       }
    }
   stage('deploy'){
    steps{
       sshagent(['dockeswarmnode']){
           sh "scp -o StricthostKeyChecking=no dockerstack.yaml dockerswarm@172.31.33.211:/home/dockerswarm"
       sh label: '', script: 'sh sudo docker service create dockerstack.yaml assignment'
                    }
      }
   }
    }
}
