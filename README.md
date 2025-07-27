# 📦 Simple Extraction App Deployment – Minikube Infrastructure Guide

---

## 🔧 Objective
Deploy a Django-based Simple Extraction App on a Minikube Kubernetes cluster using Docker, with automated scripts for deployment and cleanup.

---

## 📁 Project Structure Overview

```bash
simple-extraction-demo/
├── Dockerfile
├── docker-compose.yml
├── manage.py
├── requirements.txt
├── static/
├── templates/
├── k8s/
│   ├── postgres-deployment.yaml
│   ├── postgres-service.yaml
│   ├── django-deployment.yaml
│   ├── django-service.yaml
│   ├── ingress.yaml
│   └── pvc.yaml
├── deploy.sh
├── cleanup.sh
└── README.md
```

## ⚙️ Prerequisites
- Docker
- Minikube
- kubectl
- GitHub Account

---

## 🏗️ Setup Steps

### 1. Clone Repository
```bash
git clone https://github.com/Srishti-Singh94/simple-extraction-demo.git
cd simple-extraction-demo
```

### 2. Start Minikube
```bash
minikube start --driver=docker
```

### 3. Enable Ingress Addon (Important for URL Access)
```bash
minikube addons enable ingress
```

### 4. Deploy the App
```bash
./deploy.sh
```
This script will apply all Kubernetes files in the correct order.

### 5. Access Application
```bash
minikube ip
```
Then, add the below entry in your `/etc/hosts` file (Linux/macOS) or `C:\Windows\System32\drivers\etc\hosts` (Windows):
```
<your-minikube-ip>  django-app.local
```
Now visit: [http://django-app.local](http://django-app.local)

### 6. Cleanup Resources
```bash
./cleanup.sh
```

### 7. Auto Git Push
```bash
./git-auto-push.sh
```
This automates `git add`, `commit`, and `push`. You can enter a message or use the default.

---

## 📘 File Purpose & Infra Impact

| File              | Purpose                        | Bonus Output / Benefit                         | Infra Impact                         |
|-------------------|--------------------------------|------------------------------------------------|--------------------------------------|
| `deploy.sh`       | Automate deployment            | Fast, repeatable setup                         | Creates all K8s resources            |
| `cleanup.sh`      | Automate cleanup               | Easy rollback, no leftovers                    | Deletes all resources                |
| `README.md`       | Documentation & guide          | Easy to follow, sharable, GitHub-ready         | No infra change                      |
| `*.yaml` (K8s)    | Infra definition                | Full infra as code (IaC)                       | Real infra lives here                |
| `git-auto-push.sh`| Git automation                 | Fast version control                           | No runtime change, helps developer   |

---

## 🧪 Troubleshooting

- App not opening?
  - Run `minikube ip` and verify correct entry in `/etc/hosts`
  - Check pod status: `kubectl get pods`
  - Check logs: `kubectl logs <pod-name>`

- Database issues?
  - Check PVC: `kubectl get pvc`
  - Verify secrets: `kubectl describe secret postgres-secret`

- Ingress not working?
  - Check ingress controller logs: `kubectl logs -n ingress-nginx <controller-pod>`

---

## 📞 Author
**Srishti Singh** – [GitHub Profile](https://github.com/Srishti-Singh94)

---
