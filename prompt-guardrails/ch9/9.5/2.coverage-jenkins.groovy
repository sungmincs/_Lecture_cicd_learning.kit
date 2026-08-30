// ch9.5 Jenkins — Test stage에 커버리지 임계값 80% 적용
stage('Test') {
    steps {
        sh '''
            curl -LsSf https://astral.sh/uv/0.11.18/install.sh | sh
            export PATH="$HOME/.local/bin:$PATH"
            uv sync --extra dev
            TESTING=true uv run coverage run --source ./src/worklog -m pytest --disable-warnings -v
            uv run coverage report --fail-under=80
        '''
    }
}
