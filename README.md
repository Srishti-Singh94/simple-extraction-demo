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

---

## ✅ Step-by-Step: Deployment Automation using `deploy.sh` and `cleanup.sh`

### 🧾 Step 1: Why We Created `deploy.sh` and `cleanup.sh`

- `deploy.sh` banaya taaki pura Kubernetes deployment automate ho jaye — bar bar `kubectl apply` karne ki zarurat na pade.
- `cleanup.sh` banaya taaki purana deployment easily clean ho jaye (pods, services, PVCs sab delete ho jaye).

### 🛠 Step 2: Scripts Banaye and Unme QA Automation Logic Add Kiya

#### 📁 `deploy.sh` mein kya kya kiya:

1. Backup system lagaya (e.g., ZIP `k8s/` folder with timestamp)
2. YAML validate karne ka step add kiya (error aaya toh stop)
3. Har YAML file ko line-by-line apply kiya
4. Deployment ke baad sleep time diya (`sleep 10`) taaki services ready ho jaye
5. Final messages diye jaise: “App running at: http://<Minikube IP>:<NodePort>”

#### 🧹 `cleanup.sh` mein kya kiya:

1. `kubectl delete` se sab YAMLs ko reverse order mein delete kiya
2. Delay (sleep 5) diya taaki sab clean ho jaye
3. Confirmation print kiya: “✅ All Kubernetes resources have been deleted.”

### 🔒 Step 3: Scripts Ko Executable Banaya

```bash
chmod +x deploy.sh
chmod +x cleanup.sh
```

👉 Iss step se aap directly `./deploy.sh` run kar sakte ho — no need for `bash deploy.sh` again and again.

### 🧪 Step 4: Validation, Error Handling and Improvements

- ✅ Script ne YAML validation kiya (agar Kubernetes cluster off tha, error bhi bataya clearly)
- ✅ Backup create hua before any deployment, so safe hai rollback ke liye
- ✅ Easy error tracking: Deployment logs `deploy-<timestamp>.log` mein save hote hain
- ✅ Human-readable messages: deployment progress step-by-step print hota hai

### 📦 Final Result Kya Mila?

- Pura Kubernetes deployment automate ho gaya
- Manual `kubectl` commands se chutkaara mila
- Time-saving and presentation-friendly bana (1-click deploy and cleanup)
- Reusable, sharable scripts ban gaye jo GitHub me rakh sakte ho
- Scripts are readable and professional — real-world production ready!

---

## 🚀 Deployment Commands

```bash
# Step 1: Start Minikube if not running
minikube start

# Step 2: Enable Ingress (if using ingress.yaml)
minikube addons enable ingress

# Step 3: Run the deploy script
deploy.sh

# Step 4: Verify
kubectl get all

# Step 5: Get URL
minikube service django-service --url
```

---

## 🧹 Cleanup

```bash
./cleanup.sh
```

---

## 🔚 Done!
You now have a clean, automated, and professional deployment process for your Django Kubernetes app.
