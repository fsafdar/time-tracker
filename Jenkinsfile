pipeline {
  agent any

  environment {
    DOCKER_IMAGE = 'fsafdar10/nginx-demo:latest'
    DOCKER_COMPOSE_FILE = 'docker-compose.yml'
  }

  stages {
    stage('Clone Repository') {
      steps {
        git credentialsId: 'github-credentials', url: 'https://github.com/fsafdar/time-tracker.git'
      }
    }

    stage('SonarQube Code Analysis') {
      steps {
        withSonarQubeEnv('LocalSonarQube') {
          sh '''
            echo "🔁 Waiting for SonarQube to be ready..."
            for i in {1..30}; do
              if curl -s http://sonarqube:9000/api/system/health | grep -q '"status":"UP"'; then
                echo "✅ SonarQube is ready!"
                break
              fi
              echo "SonarQube is starting... waiting 5 seconds"
              sleep 5
            done
            sonar-scanner
          '''
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        sh '''
          echo "🔨 Building Docker image..."
          docker build -t $DOCKER_IMAGE .
        '''
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "📦 Logging into Docker Hub..."
            echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
            echo "🚀 Pushing Docker image to Docker Hub..."
            docker push $DOCKER_IMAGE
          '''
        }
      }
    }

    stage('Deploy with Docker Compose') {
      steps {
        sh '''
          echo "📦 Deploying with Docker Compose..."
          docker compose -f $DOCKER_COMPOSE_FILE up -d
        '''
      }
    }
  }

  post {
    failure {
      echo '🚨 Pipeline failed!'
    }
    success {
      echo '✅ Pipeline completed successfully!'
    }
  }
}
