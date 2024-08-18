@Library("jenkins-shared-library") _
pipeline {
    agent any
    tools {
        maven '3.9.8'
    }
    parameters {
        booleanParam(name: 'dockerBuild', defaultValue: false, description: 'Build Docker Image?')
        booleanParam(name: 'dockerhubPush', defaultValue: false, description: 'Push Image to DockerHub?')
        booleanParam(name: 'deploy', defaultValue: true, description: 'Deploy?')
    }

    environment {
        IMAGE_NAME = 'tutopediabackend'
        IMAGE_VERSION = 'latest'

        DOCKERHUB_DOMAIN = "ruwel123"
        DOCKERHUB_CREDENTIALS = credentials('DockerHubServiceConnection')
    }
    stages {
        stage("Tut-O-Pedia_Docker_Backend: SETUP") {
            steps {
                sh '''
                  mvn -v
                  mvn help:evaluate -Dexpression=settings.localRepository
                  export MAVEN_VERSION=3.9.8
                '''
            }
        }

        stage("Tut-O-Pedia_Docker_Backend: MAVEN BUILD") {
            steps {
                sh 'mvn clean install'
            }
        }

        stage("Tut-O-Pedia_Docker_Backend: DOCKER IMAGE BUILD") {
            when {
                expression {
                    params.dockerBuild
                }
            }
            steps {
                sh 'docker build . -t $DOCKERHUB_DOMAIN/$IMAGE_NAME:$IMAGE_VERSION'
            }
        }

        stage("Tut-O-Pedia_Docker_Backend: PUSH TO DOCKERHUB") {
            when {
                expression {
                    params.dockerhubPush
                }
            }
            steps {
                sh '''
                  docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW
                  docker push $DOCKERHUB_DOMAIN/$IMAGE_NAME:$IMAGE_VERSION
                '''
            }
        }

        stage("Tut-O-Pedia_Docker_Backend: DEPLOY") {
            when {
                expression {
                    params.deploy
                }
            }
            steps {
                echo "DEPOYING..."
                build 'Tut-O-Pedia_Docker_Deploy'
            }
        }
    }

    post {
        always {
            mailTo(to: "rwdevops123@gmail.com", attachLog: true)
        }
    }
}
