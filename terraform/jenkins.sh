#!/bin/bash
set -x

# Java 21, Git, Docker
dnf install -y fontconfig java-21-amazon-corretto-devel git docker

# Jenkins (LTS repository)
curl -fsSL -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/rpm-stable/jenkins.repo
dnf install -y jenkins

# Maven 3.9.9
curl -fsSL -o /tmp/maven.tar.gz https://archive.apache.org/dist/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz
tar -xzf /tmp/maven.tar.gz -C /opt
ln -s /opt/apache-maven-3.9.9/bin/mvn /usr/bin/mvn

# Start services and let Jenkins use Docker
systemctl enable --now docker
usermod -aG docker jenkins
systemctl enable --now jenkins
