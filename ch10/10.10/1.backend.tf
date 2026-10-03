# Terraform state를 GitLab 프로젝트의 state 저장소(HTTP backend)에 둔다.
# 주소와 인증은 파일에 적지 않고 TF_HTTP_* 환경변수로 넘긴다(부분 설정).
# 토큰이 이 파일이나 .terraform/ 아래에 남지 않게 하기 위해서다.
terraform {
  backend "http" {}
}
