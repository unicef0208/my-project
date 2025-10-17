pipeline {
    agent any

    environment {
        // Jenkins Credentials에 등록했던 ID
        DOCKER_HUB_CREDS = credentials('dockerhub-creds')
        HELM_REPO_CREDS  = credentials('github-pat')

        // 본인 Docker Hub 사용자 이름과 앱 이름으로 변경
        DOCKER_IMAGE_NAME = "unicef0208/my-app" 

        // 본인 Helm 차트 저장소 주소로 변경
        HELM_REPO_URL     = "https://github.com/unicef0208/my-helm-charts.git"
    }

    stages {
        stage('Build & Push Docker Image') {
            steps {
                script {
                    def imageTag = "${env.BUILD_NUMBER}"
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${imageTag} ."

                    // Docker Hub 로그인 및 푸시
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_HUB_PASSWORD', usernameVariable: 'DOCKER_HUB_USERNAME')]) {
                        sh "docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD}"
                        sh "docker push ${DOCKER_IMAGE_NAME}:${imageTag}"
                    }
                }
            }
        }

        stage('Update Helm Chart') {
            steps {
                script {
                    def imageTag = "${env.BUILD_NUMBER}"

                    // Helm 차트 저장소 클론
                    withCredentials([usernamePassword(credentialsId: 'github-pat', passwordVariable: 'GIT_TOKEN', usernameVariable: 'GIT_USERNAME')]) {
                        sh 'git clone https://${GIT_USERNAME}:${GIT_TOKEN}@github.com/unicef0208/my-helm-charts.git'
                    }

                    // values.yaml 파일 수정 및 푸시
                    dir('my-helm-charts') {
                        // Helm 차트 폴더 이름이 다르다면 수정해야 합니다. (예: my-helm-charts/my-app-chart)
                        sh "yq e '.image.tag = \"${imageTag}\"' -i values.yaml" 

                        sh "git config --global user.email 'jenkins@example.com'"
                        sh "git config --global user.name 'Jenkins'"
                        sh "git add values.yaml"
                        sh "git commit -m 'Update image tag to ${imageTag} by Jenkins build #${env.BUILD_NUMBER}'"
                        sh "git push origin main"
                    }
                }
            }
        }
    }
}
