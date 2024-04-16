pipeline {
    agent any
    tools{
       maven 'Maven-3.9'
    }

    stages {
        stage('Build Maven') {
            steps{
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/techroy/DockerExample']]])
                bat "mvn clean install"
            }
        }

          stage('Build docker image'){
            steps{
                script{
                    bat 'docker build -t techramroy/docker-jenkins-integration-example .'
                }
            }
        }
        stage('Push image to Hub'){
            steps{
                script{

                   bat 'docker push techramroy/docker-jenkins-integration-example'
                }
            }
        }


    }
}
