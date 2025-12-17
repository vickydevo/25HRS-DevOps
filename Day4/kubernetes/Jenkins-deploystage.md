This guide provides the complete, structured setup to deploy your Spring Boot app from a **Jenkins Server** to a **Remote Minikube Server** on AWS.

---

# Remote Kubernetes Deployment Guide

## 1. Minikube Server Setup (Host: `35.172.180.78`)

Run these steps on the server where Minikube is installed to allow external connections from Jenkins.

### A. AWS Security Group Configuration

In the AWS Console, ensure the following **Inbound Rules** are added to your Minikube EC2 instance:

* **Port 8443**: Source `3.215.23.46` (Jenkins IP) — For Kubernetes API.
* **Port 30001**: Source `Anywhere (0.0.0.0/0)` — For accessing your Web App.

### B. Network Bridging (The "Connection Refused" Fix)

Minikube listens on a local bridge by default. Use `socat` to redirect traffic from the EC2 Public/Private interface to the internal Minikube API.

```bash
# 1. Install networking tools
sudo apt-get update && sudo apt-get install socat -y

# 2. Disable local OS firewall (Temporary test)
sudo ufw disable

# 3. Create the bridge (Run in background)
# This maps external traffic on 8443 to the internal Minikube IP
sudo socat TCP-LISTEN:8443,fork,reuseaddr TCP:$(minikube ip):8443 &

```

### C. Generate Portable Kubeconfig

```bash
# Generate a config file with embedded certificates (Flattened)
kubectl config view --flatten > portable-config

```

---

## 2. Jenkins Server Setup (Host: `3.215.23.46`)

Configure Jenkins to communicate with the remote cluster.

### A. Install Kubectl

```bash
# Download and install the binary globally
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

```

### B. Add Credentials

1. **Secret File**: Copy the contents of `portable-config` from the Minikube server.
2. **Edit the IP**: Ensure the `server:` line uses the **Private IP** if in the same VPC, or **Public IP** if not.
* *Example:* `server: https://172.31.28.140:8443`


3. **ID**: Set this to `minikube-config`.

### C. Verify Connection

Run this from the Jenkins terminal. **Must return "Succeeded" before running pipeline.**

```bash
nc -zv <MINIKUBE_SERVER_IP> 8443

```

---

## 3. Jenkins Pipeline (`Jenkinsfile`)

This script builds your Docker image, pushes it to DockerHub, and deploys it to the remote Minikube cluster.

```groovy
pipeline {
    agent any
    tools {
        maven 'm3'
    }
    environment {
        DOCKER_IMAGE = 'spring-test' 
        DOCKER_TAG = '12-Nov'
    }
    stages {
        stage('SCM Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/vickydevo/springboot-test.git'
            }
        }
        stage('Build Artifact') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Docker Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker_cred', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh "docker build -t ${USER}/${DOCKER_IMAGE}:${DOCKER_TAG} ."
                    sh "echo ${PASS} | docker login -u ${USER} --password-stdin"
                    sh "docker push ${USER}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                }
            }
        }
        stage('K8s Deployment') {
            steps {
                withKubeConfig([credentialsId: 'minikube-config']) {
                    // Apply manifest with SSL bypass for cross-server communication
                    sh "/usr/local/bin/kubectl apply -f k8s/nodePort/spring_NodeP.yml --insecure-skip-tls-verify"
                    
                    // Verify rollout (Ensure name matches your YAML metadata)
                    sh "/usr/local/bin/kubectl rollout status deployment/springboot-deployment --insecure-skip-tls-verify"
                }
            }
        }
    }
}

```

---

## 4. Verification

1. **Pods**: On Minikube server, run `kubectl get pods` to see 3 replicas.
2. **App**: Browse to `http://35.172.180.78:30001`.

**Would you like me to help you create a systemd service for the `socat` command so it stays running even after the server reboots?**
