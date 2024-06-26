#!/usr/bin/env bash
jkopt1="--sessionTimeout=1440"
jkopt2="--sessionEviction=86400"
jvopt1="-Duser.timezone=Asia/Seoul"
jvopt2="-Dcasc.jenkins.config=https://raw.githubusercontent.com/sungmincs/_Lecture_cicd_learning.kit/sungmin/wip/ch4/4.4.1/jenkins-config.yaml"
jvopt3="-Dhudson.model.DownloadService.noSignatureCheck=true"
helm upgrade --install jenkins edu/jenkins \
--set controller.admin.password=admin \
--set controller.image.tag="2.452.1-lts-jdk17" \
--set controller.initContainerEnv[0].name="JENKINS_UC" \
--set controller.initContainerEnv[0].value="https://raw.githubusercontent.com/sungmincs/_Lecture_cicd_learning.kit/sungmin/wip/ch4/4.4.1/update-center.json" \
--set controller.ingress.enabled="true" \
--set controller.ingress.ingressClassName="nginx" \
--set controller.ingress.hostName="jenkins.myk8s.local" \
--set controller.ingress.apiVersion="networking.k8s.io/v1" \
--set controller.installLatestPlugins=true \
--set controller.jenkinsOpts="$jkopt1 $jkopt2" \
--set controller.javaOpts="$jvopt1 $jvopt2 $jvopt3" \
--set controller.nodeSelector."kubernetes\.io/hostname"=cp-k8s \
--set controller.runAsUser=1000 \
--set controller.runAsGroup=1000 \
--set controller.serviceType=NodePort \
--set controller.nodePort=32123 \
--set controller.tolerations[0].key=node-role.kubernetes.io/control-plane \
--set controller.tolerations[0].effect=NoSchedule \
--set controller.tolerations[0].operator=Exists \
--set persistence.enabled=true
