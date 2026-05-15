#!/usr/bin/env bash
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
--set controller.installLatestPlugins=false \
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
