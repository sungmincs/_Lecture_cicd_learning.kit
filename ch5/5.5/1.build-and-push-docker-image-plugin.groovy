def fullSHA
def shortSHA
def branch
def commitMessage

def sendSlackMessage(statusMessage, commitMessage, shortSHA, fullSHA) {
    echo "Your pipeline has been ${statusMessage}"
    echo "Commit Message: ${commitMessage}"
    echo "Tags: ${shortSHA}, ${fullSHA}"
}

pipeline {
    agent any
    environment {
        DOCKER_REPOSITORY = 'sungminl/worklog-backend'
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
    }
    stages {
        stage('Init Variables') {
            steps {
                script {
                    fullSHA = sh(script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
                    shortSHA = fullSHA[0..8]
                    branch = env.BRANCH_NAME
                    commitMessage = sh(script: "git log -1 --format='*%s* by _%an_'", returnStdout: true)
                }
            }
        }
        stage('Run Test') {
            agent {
                docker {
                    image 'python:3.12.3-slim-bookworm'
                }
            }
            steps {
                script {
                    echo "let's run a test for ${shortSHA} in ${branch}"
                    echo "running test for ${fullSHA}"
                    sh 'pip install poetry'
                    echo 'Test Passed!'
                }
            }
        }
        stage('Build and Push Image') {
            steps {
                script {
                    echo "Let's build the image for ${shortSHA} in ${branch}"
                    echo "The change commit message to build is '${commitMessage}'"

                    def app = docker.build("${DOCKER_REPOSITORY}:${shortSHA}")

                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        app.push("${shortSHA}")
                        app.push("${fullSHA}")
                    }

                    echo 'build successful and published image with the following tags:'
                    echo "Tags: ${shortSHA}, ${fullSHA}"
                }
            }
        }
        stage('Deploy Image') {
            steps {
                echo "Let's deploy the image"
                echo "Deploying our image ${fullSHA} to the cluster"
            }
        }
    }
    post {
        always {
            echo 'Job finished. Sending slack notifications ..'
        }
        success {
            echo 'Build Success, Notifying to slack..'
            sendSlackMessage('completed', commitMessage, shortSHA, fullSHA)
        }
        failure {
            echo 'Build Failed, Notifying to slack..'
            sendSlackMessage('failed', commitMessage, shortSHA, fullSHA)
        }
        aborted {
            echo 'Build Aborted, Notifying to slack..'
            sendSlackMessage('aborted', commitMessage, shortSHA, fullSHA)
        }
    }
}
