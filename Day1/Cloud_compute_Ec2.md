# Cloud Compute EC2

## 1. What is Cloud Computing?
Cloud computing is the on-demand delivery of IT resources over the internet with pay-as-you-go pricing. Instead of buying, owning, and maintaining physical data centers and servers, you can access technology services such as compute power, storage, and networking on an as-needed basis from cloud vendors like AWS, Azure, GCP, and IBM Cloud.

## 2. Difference: Public, Private, and Hybrid Cloud
- **Public Cloud:** Services are delivered over the public internet and shared across multiple organizations. Examples: AWS, Azure, GCP.
- **Private Cloud:** Cloud infrastructure is dedicated to a single organization, offering greater control and security.
- **Hybrid Cloud:** Combines public and private clouds, allowing data and applications to be shared between them for greater flexibility and optimization.

## 3. Vocabulary and Terminology
- **Virtualization:** Creating virtual versions of hardware, storage, or network resources to efficiently utilize physical systems.
- **Virtual Machine (VM):** Software-based emulation of a physical computer, providing isolated environments for different tasks.
- **API (Application Programming Interface):** Rules and protocols for building and interacting with software applications.
- **Regions:** Geographic areas where cloud providers have data centers, enabling deployment closer to users.

** ![Image](https://github.com/user-attachments/assets/e580b02d-bf89-43b2-ac78-8c224a0be949) **

- **Availability Zone (AZ):** Physical locations within a region containing one or more data centers for redundancy and isolation.
- **Scalability:** Ability to handle increased workload by scaling up or out resources.
- **High Availability:** Design approach to minimize downtime and ensure continuous operation.
- **Disaster Recovery:** Strategies to recover from catastrophic events and restore critical systems.
- **Load Balancing:** Distributing network traffic across multiple servers to improve responsiveness and availability.

## 4. Different Segments: SaaS, PaaS, and IaaS

### SaaS (Software as a Service)
- **Definition:** Delivers software applications over the internet; users do not manage hardware or infrastructure.
- **Examples:** Google Workspace, Microsoft 365, Salesforce, Zoom
    - Amazon Chime: Online meetings and video conferencing
    - Amazon WorkDocs: Document storage and sharing
    - Amazon QuickSight: Business analytics and data visualization
- **Usage:** Access applications via web or API; provider manages maintenance, updates, and security.

### PaaS (Platform as a Service)
- **Definition:** Provides a platform for developers to build, run, and manage applications without managing infrastructure.
- **Examples:**
    - AWS Elastic Beanstalk: Application deployment and management
    - AWS Lambda: Serverless computing
    - Amazon RDS: Managed database service
- **Usage:** Developers focus on code; provider manages servers, storage, networking, etc.

### IaaS (Infrastructure as a Service)
- **Definition:** Offers virtualized computing resources like VMs, storage, and networking.
- **Examples:** AWS EC2, Azure Virtual Machines, Google Compute Engine
- **Usage:** Users control OS, storage, and applications; provider manages hardware.

#### Comparison 
- ***<img width="978" height="563" alt="Image" src="https://github.com/user-attachments/assets/9475b02c-74d9-4681-90f7-215a2da4758e" />***

- **SaaS:** Ready-to-use applications
- **PaaS:** Platform for building applications
- **IaaS:** Infrastructure for hosting applications

## 5. Launch EC2 Instance
### Steps to Launch an EC2 Instance

#### Step 1: Log in to AWS Management Console
1. Go to [AWS Console](https://aws.amazon.com/console/).
2. Log in with your AWS credentials.

---

#### Step 2: Open EC2 Dashboard
1. In the AWS Console, search for **EC2** in the search bar and select it.
2. Click **Launch Instance**.

---

#### Step 3: Configure the EC2 Instance
1. **Enter a Name:** Provide a name for your instance (e.g., `MyAmazonLinuxInstance`).
2. **Choose an Amazon Machine Image (AMI):**
    - Click **Browse AMIs** and search for **Amazon Linux**.
    - Select **Amazon Linux 2023 (HVM), SSD Volume Type (Free tier eligible)**.
3. **Choose an Instance Type:**
    - Select **t2.micro (Free tier eligible)**.
4. **Create or Select a Key Pair:**
    - Click **Create New Key Pair** (if you don’t have one).
    - Download the `.pem` file and store it securely.
5. **Configure Network Settings:**
    - Enable **SSH (port 22)** for your IP.
    - Add **HTTP (port 80)** if you plan to run a web server.
6. **Configure Storage:**
    - Keep the default **8 GiB** or increase as needed.

---

#### Step 4: Launch the Instance
1. Click **Launch Instance**.
2. Wait for the instance to initialize, then go to **Instances** and check the **Instance State** (should be `Running`).

---

#### Step 5: Connect to Your EC2 Instance
1. Select your instance.
2. Click **Connect** → **SSH Client**.
3. Copy the provided SSH command (e.g., `ssh -i "your-key.pem" ec2-user@your-instance-public-ip`).
4. Open a terminal and run the command to connect.

---
