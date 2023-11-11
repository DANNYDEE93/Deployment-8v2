pipeline {
    agent {
        label 'awsDeploy'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('kevingonzalez7997-dockerhub')
    }

    stages {
        stage('Test Backend') {
            steps {
                sh '''#!/bin/bash
                    python3.9 -m venv test
                    source Deployment-8v2/backend/test3/bin/activate
                    pip install pip --upgrade
                    pip install -r requirements.txt
                    pip install mysqlclient
                    pip install pytest
                    python manage.py test
                '''
            }
            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }

        stage('Build Backend') {
            steps {
                sh 'docker build -t kevingonzalez7997/backv1 backend/dockerfile'
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                sh 'docker push kevingonzalez7997/backv1'
            }
        }

        stage('Test Frontend') {
            steps {
                dir('frontend') {
                    sh "npm install"
                    sh "npm run test"
                    sh "npm run build"
                }
            }
            post {
                always {
                    junit 'test-reports/results.xml'
                }
            }
        }

        stage('Build Frontend') {
            steps {
                dir('frontend') {
                    sh 'docker build -t kevingonzalez7997/frontv1 frontend/dockerfile'
                    sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                    sh 'docker push kevingonzalez7997/frontv1'
                }
            }
        }

        stage('Init Terraform') {
            agent {
                label 'awsDeploy2'
            }
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY', variable: 'aws_access_key'),
                    string(credentialsId: 'AWS_SECRET_KEY', variable: 'aws_secret_key')
                ]) {
                    dir('intTerraform') {
                        sh 'terraform init'
                        sh 'terraform plan -out plan.tfplan -var="aws_access_key=$aws_access_key" -var="aws_secret_key=$aws_secret_key"'
                        sh 'terraform apply plan.tfplan'
                    }
                }
            }
        }
    }
}
