// ch9.4 Jenkins — Security Scan stage (Lint 다음에 추가)
// ⚠️ 가드레일 원안의 gitleaks_$(uname -s)_x64 는 (1) 자산명이 gitleaks_<ver>_linux_<arch> 형식이고
//    (2) 본 강의 Jenkins agent가 arm64라서 x64 고정이면 실패 → 최신 태그 조회 + arch 감지로 수정.
stage('Security Scan') {
    steps {
        sh '''
            export PATH="$HOME/.local/bin:$PATH"
            uv sync --extra dev
            uv run pip-audit
            ARCH=$(uname -m); case "$ARCH" in aarch64|arm64) GL_ARCH=arm64;; *) GL_ARCH=x64;; esac
            GL_VER=$(curl -s https://api.github.com/repos/gitleaks/gitleaks/releases/latest | grep '"tag_name"' | cut -d'"' -f4 | sed 's/^v//')
            curl -sSfL "https://github.com/gitleaks/gitleaks/releases/download/v${GL_VER}/gitleaks_${GL_VER}_linux_${GL_ARCH}.tar.gz" | tar -xz -C /tmp gitleaks
            /tmp/gitleaks detect --source . --config .gitleaks.toml --no-git --verbose
        '''
    }
}
