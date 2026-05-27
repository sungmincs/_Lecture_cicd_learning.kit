#!/usr/bin/env bash

# Jenkins PVC가 마운트할 NFS 디렉토리를 미리 생성
# csi-driver-nfs가 자동 생성에 실패하는 경우를 방지 (재설치 시에도 안전)
mkdir -p /nfs_shared/dynamic-vol/default/jenkins
jkopt1="--sessionTimeout=1440"
jkopt2="--sessionEviction=86400"
jvopt1="-Duser.timezone=Asia/Seoul"
jvopt2="-Dcasc.jenkins.config=https://raw.githubusercontent.com/sungmincs/_Lecture_cicd_learning.kit/main/ch4/4.5/jenkins-config.yaml"
jvopt3="-Dhudson.model.DownloadService.noSignatureCheck=true"
helm upgrade --install jenkins edu/jenkins \
--set controller.admin.password=admin \
--set controller.image.tag="2.541.3-lts-jdk17" \
--set controller.initContainerEnv[0].name="JENKINS_UC" \
--set controller.initContainerEnv[0].value="https://raw.githubusercontent.com/sungmincs/_Lecture_cicd_learning.kit/main/ch4/4.5/update-center.json" \
--set "controller.installPlugins[0]=kubernetes:4214.vf10083a_42e70" \
--set "controller.installPlugins[1]=workflow-aggregator:596.v8c21c963d92d" \
--set "controller.installPlugins[2]=git:5.2.2" \
--set "controller.installPlugins[3]=configuration-as-code:2077.v41f1011a_5110" \
--set "controller.installPlugins[4]=docker-workflow:634.vedc7242b_eda_7" \
--set controller.jenkinsOpts="$jkopt1 $jkopt2" \
--set controller.javaOpts="$jvopt1 $jvopt2 $jvopt3" \
--set controller.nodeSelector."kubernetes\.io/hostname"=cp-k8s \
--set controller.runAsUser=1000 \
--set controller.runAsGroup=1000 \
--set controller.serviceType=ClusterIP \
--set controller.tolerations[0].key=node-role.kubernetes.io/control-plane \
--set controller.tolerations[0].effect=NoSchedule \
--set controller.tolerations[0].operator=Exists \
--set persistence.enabled=true

# HTTPRoute: jenkins.myk8s.local → jenkins:8080 (NGINX Gateway Fabric)
kubectl apply -f /root/_Lecture_cicd_learning.kit/ch4/4.5/jenkins-httproute.yaml

# Jenkins Pod Running 대기
kubectl rollout status statefulset/jenkins --timeout=300s

# docker socket + binary 마운트 추가
# Helm chart의 controller.volumes/volumeMounts는 chart 전용 형식이라 hostPath에 적용되지 않으므로 직접 patch
kubectl patch statefulset jenkins --type='json' -p='[
  {"op": "add", "path": "/spec/template/spec/volumes/-", "value": {"name": "docker-socket", "hostPath": {"path": "/var/run/docker.sock", "type": "Socket"}}},
  {"op": "add", "path": "/spec/template/spec/volumes/-", "value": {"name": "docker-binary", "hostPath": {"path": "/usr/bin/docker", "type": "File"}}},
  {"op": "add", "path": "/spec/template/spec/volumes/-", "value": {"name": "docker-buildx", "hostPath": {"path": "/usr/libexec/docker/cli-plugins/docker-buildx", "type": "File"}}},
  {"op": "add", "path": "/spec/template/spec/containers/0/volumeMounts/-", "value": {"name": "docker-socket", "mountPath": "/var/run/docker.sock"}},
  {"op": "add", "path": "/spec/template/spec/containers/0/volumeMounts/-", "value": {"name": "docker-binary", "mountPath": "/usr/bin/docker"}},
  {"op": "add", "path": "/spec/template/spec/containers/0/volumeMounts/-", "value": {"name": "docker-buildx", "mountPath": "/usr/libexec/docker/cli-plugins/docker-buildx"}}
]'

# Pod 재시작 후 Running 대기
kubectl rollout status statefulset/jenkins --timeout=300s

# docker.sock 권한 변경 (Jenkins Pod UID 1000이 docker group에 속하지 않아 직접 접근 허용)
chmod 666 /var/run/docker.sock
