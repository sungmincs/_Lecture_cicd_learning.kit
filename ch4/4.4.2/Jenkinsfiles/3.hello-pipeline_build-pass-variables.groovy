def fullSHA
def shortSHA
def branch

pipeline {
    agent any
    stages{
        stage('Init Variables')
            steps {
                full_sha = sh (script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
                short_sha = full_sha[0..8]
                branch = env.BRANCH_NAME
            }
        stage('Run Test') {
            steps {
                echo "Let's run a test"
            }
        }
        stage('Build Image') {
            try {
                echo "Let's build the image"
                exit 1
            }
            catch (exc) {
                echo "Oops, something went wrong with this build.."
                throw
            }
        }
        stage('Deploy Image') {
            steps {
                echo "Let's deploy the image"
            }
        }
    }
}
