# ☁️ AWS Resource Viewer - Flask App

## Overview

This project is a **Flask web application** that connects to your AWS account and displays key AWS resources in a simple HTML table.  
It leverages **Boto3** to fetch information about EC2 instances, VPCs, subnets, Load Balancers, and AMIs.  
The app is fully containerized using **Docker** for easy deployment and portability.

---

## 🎯 Project Objectives

- Connect to AWS using programmatic access (Access Key + Secret)
- Fetch and display details of EC2, VPCs, Subnets, ELBs, and AMIs
- Provide a simple, interactive web interface via Flask
- Fully containerized for cross-platform usage
- Easy to extend for other AWS resources

---

## 📁 Project Structure

```
aws-resource-viewer/
├── Dockerfile # Dockerfile for containerization
├── requirements.txt # Python dependencies
├── app.py # Flask app main script
└── static/
└── docker.svg # Example image displayed in the app
```

---

## 🧰 Technologies Used

- Python 3.11
- Flask
- Boto3 (AWS SDK for Python)
- Docker
- HTML/CSS for the front-end display

---

## 🚀 Setup Instructions

### 1. Set AWS Credentials

Before running the app, set your AWS credentials as environment variables:

**Linux / macOS**
```bash
export AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY"
export AWS_DEFAULT_REGION="YOUR_DEFAULT_REGION"


### 2. Docker Setup
Dockerfile

dockerfile
Copy code
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt
COPY . .
EXPOSE 5001
CMD ["python", "app.py"]
3. Build and Run Docker Container
Build the Docker Image

bash
Copy code
docker build -t myawsapp .
Run the Container

bash
Copy code
docker run -it --name awscontainer \
  -p 5001:5001 \
  -e AWS_ACCESS_KEY_ID="YOUR_ACCESS_KEY_ID" \
  -e AWS_SECRET_ACCESS_KEY="YOUR_SECRET_ACCESS_KEY" \
  -e AWS_DEFAULT_REGION="YOUR_DEFAULT_REGION" \
  myawsapp
Access the app at http://localhost:5001

🖥️ Features
✅ EC2 Instances
Instance ID

Name tag

State (running, stopped)

Type (t2.micro, etc.)

Public IP

✅ VPCs
VPC ID

CIDR Block

✅ Subnets
Subnet ID

VPC ID

CIDR Block

Availability Zone

✅ Load Balancers
Name

DNS Name

✅ AMIs
AMI ID

Name

