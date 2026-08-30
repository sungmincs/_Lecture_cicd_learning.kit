// ch9.3 Jenkins — Lint stage (기존 Jenkinsfile의 Test stage 앞에 추가)
// agent는 ch8.5와 동일한 k8s pod(docker.sock) 사용. uv는 curl로 설치.
stage('Lint') {
    steps {
        sh '''
            curl -LsSf https://astral.sh/uv/0.11.18/install.sh | sh
            export PATH="$HOME/.local/bin:$PATH"
            uv sync --extra dev
            uv run ruff check src/
        '''
    }
}
// ⚠️ export PATH="$HOME/.local/bin:$PATH" 누락 시 uv: command not found 발생
