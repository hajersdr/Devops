pipeline {
    environment {
        repoUrl = 'https://github.com/hajersdr/Devops.git'
        branchName = 'main'
        registry = 'haj123er/hajer123'
 	  registryCredential = 'dockerhub'
    }
    agent any
    stages {
        stage('Clone source code from Git') {
            steps {
                echo "Cloning Project from GitHub; Branch : $branchName"
                cleanWs()
                git branch: "$branchName",
                url: "$repoUrl"
            }
        }
        stage('Compile code (Maven)') {
            steps {
                sh 'mvn clean compile -DskipTests'
            }
        }
        // stage('Run unit tests (Maven)') {
        //     steps {
        //         sh 'mvn test -Dtest=StockServiceTest'
        //     }
        // }
        stage('Run code quality test (SonarQube)') {
            steps {
                sh "mvn sonar:sonar \
  -Dsonar.projectKey=hajerproj \
  -Dsonar.host.url=http://192.168.33.10:9000 \
  -Dsonar.login=d4c0345a2b10a2ac248eebe74ba0a03bdcabc87b"
            }
        }
        stage('Package and deploy to Nexus') {
            steps {
                sh "mvn clean package -DskipTests deploy:deploy-file -DgroupId=tn.esprit -DartifactId=achat -Dversion=1.0 -DgeneratePom=true -Dpackaging=war -DrepositoryId=deploymentRepo -Durl=http://${hostIP}:8081/repository/maven-releases/ -Dfile=target/achat-1.0.jar"
            }
        }
        stage('Push image to DockerHub (Docker)') {
            steps {
                script {
                    dockerImage = docker.build registry + ":$BUILD_NUMBER"
                    docker.withRegistry('', registryCredential) {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Remove Unused docker image') {
            steps {
                sh "docker rmi $registry"
            }
        }
        stage('Run Spring app and MySQL images (Docker-compose)') {
            steps {
                sh 'docker-compose -f spring-mysql/docker-compose.yml down --remove-orphans'
                sh 'docker-compose -f spring-mysql/docker-compose.yml up -d'
            }
        }
    }
}
