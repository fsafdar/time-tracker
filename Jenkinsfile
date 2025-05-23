pipeline {
    agent any

    environment {
        SONARQUBE_ENV = 'MySonarQube'           // Match Jenkins SonarQube server name
        IMAGE_NAME = 'yourdockerhub/cicd-project' // Replace with your Docker Hub username/repo
    }

    tools {
        sonarQubeScanner 'SonarScanner' // This must match the name in Jenkins → Global Tool Config
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/yourusername/your-repo.git' // Replace with your actual repo
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${SONARQUBE_ENV}") {
                    sh 'sonar-scanner'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:latest")
                }
            }
        }

        // Optional stage for pushing to Docker Hub
        // stage('Push Docker Image') {
        //     steps {
        //         withDockerRegistry([credentialsId: 'dockerhub', url: '']) {
        //             docker.image("${IMAGE_NAME}:latest").push()
        //         }
        //     }
        // }
    }
}

