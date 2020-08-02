pipeline {
    agent any
     tools {
      git "newgit"
   }
    stages{
       stage('checkout') {
        steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'git', url: 'https://github.com/sunilvirat/node.git']]])
        }
                }

        stage('Build Docker Image'){
            steps{
                sh "sudo docker build . -t venkatasunil/nodeapp:$BUILD_NUMBER"
            }
        }
    stage('Publish image'){
      steps{
          withCredentials([string(credentialsId: 'docker_pwd', variable: 'dockerhub_pwd')]) {
          sh "sudo docker login -u venkatasunil -p $dockerhub_pwd"
          sh "sudo docker push venkatasunil/nodeapp:$BUILD_NUMBER"
              }
          }    
        }
    stage('update Image Version'){
      
      steps {
     sh label: '', script: '''sed -i s/latest/$BUILD_NUMBER/ dockerservice-create.sh'''
    sh label: '', script: '''sed -i s/latest/$BUILD_NUMBER/ dockerservice-update.sh'''
       }
    }
   stage('deploy'){
    steps{
        sh "chmod +x dockerservice-create.sh"
        sh "chmod +x dockerservice-update.sh"
       sshagent(['dockeswarmnode']){
           sh "scp -o StricthostKeyChecking=no dockerservice-create.sh dockerservice-update.sh dockerswarm@172.31.33.211:/home/dockerswarm"
           script{
             try{
            sh "ssh dockerswarm@172.31.33.211 /home/dockerswarm/dockerservice-create.sh"
                }catch(error){
             sh "ssh dockerswarm@172.31.33.211 /home/dockerswarm/dockerservice-update.sh"
                             }
            
                  }
                                    }
          }
                    }
    }
        post {
        always {
            sh label: '', script: '''sudo docker rmi venkatasunil/nodeapp:$BUILD_NUMBER
sudo docker rmi venkatasunil/nodeapp:$BUILD_NUMBER
sudo docker rmi node:carbon
'''
                    }
            }
    }
