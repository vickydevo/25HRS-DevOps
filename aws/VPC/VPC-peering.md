# AWS VPC Peering Setup Guide (Same Region)



This guide provides the complete, sequential steps to create two distinct VPCs with internet connectivity (public subnets) and establish a VPC Peering connection between them in the same AWS region.

<img width="1500" height="480" alt="Image" src="https://github.com/user-attachments/assets/9bc3dd34-c3e2-4574-906e-89ec93580b48" />

**Crucial Prerequisite:** The CIDR blocks for both VPCs **must not overlap**.

## Configuration Summary

| Resource | VPC A (Requester) | VPC B (Accepter) |
| :--- | :--- | :--- |
| **VPC CIDR** | `10.1.0.0/16` | `10.2.0.0/16` |
| **Public Subnet** | `10.1.1.0/24` | `10.2.1.0/24` |
| **Private Subnet** | `10.1.2.0/24` | N/A (Optional but shown in creation) |
| **Route Table Target** | `10.2.0.0/16` -> Peering ID | `10.1.0.0/16` -> Peering ID |

---

## 🏗️ Part 1: VPC Infrastructure Build (VPC, Subnets, Internet Access)

### Step 1.1: Create VPCs

1.  **Create VPC A:**
    * **Name tag:** `VPC-A`
    * **IPv4 CIDR block:** `10.1.0.0/16`
2.  **Create VPC B:**
    * **Name tag:** `VPC-B`
    * **IPv4 CIDR block:** `10.2.0.0/16`

<img width="1403" height="631" alt="Image" src="https://github.com/user-attachments/assets/b6090f00-7cc3-486d-9c90-c3e90c8db3c8" />

### Step 1.2: Create Subnets

1.  **VPC A Subnets:** (Select **VPC-A** as the VPC ID)
    * Public: Name `VPC-A-Public-Subnet`, CIDR `10.1.1.0/24`
    * Private: Name `VPC-A-Private-Subnet`, CIDR `10.1.2.0/24`
2.  **VPC B Subnets:** (Select **VPC-B** as the VPC ID)
   <img width="1535" height="787" alt="Image" src="https://github.com/user-attachments/assets/c3290756-77ec-49e1-be72-e6079d77ce04" />

    * Public: Name `VPC-B-Public-Subnet`, CIDR `10.2.1.0/24`

### Step 1.3: Create and Attach Internet Gateways (IGWs)

An IGW is required for public subnets to communicate with the internet.

1.  **VPC A IGW:**
    * Create an IGW: **Name:** `VPC-A-IGW`.
    * Select the IGW, choose **Actions** > **Attach to VPC**, and select **VPC-A**.
2.  **VPC B IGW:**
    * Create an IGW: **Name:** `VPC-B-IGW`.
    * Select the IGW, choose **Actions** > **Attach to VPC**, and select **VPC-B**.
    <img width="1870" height="281" alt="Image" src="https://github.com/user-attachments/assets/00eee67c-af97-4f09-aaea-9ad05a029413" />

    <img width="1125" height="315" alt="Image" src="https://github.com/user-attachments/assets/f966bda9-1cbe-4c92-a541-db001d7f235d" />

### Step 1.4: Configure Public Subnet Routing

This configures the Route Tables (RTs) to direct internet-bound traffic (`0.0.0.0/0`) to the IGW.

1.  **VPC A Public RT:**
    * Create a custom RT: **Name:** `VPC-A-Public-RT`, **VPC:** `VPC-A`.
    * **Routes Tab:** Add route: **Destination** `0.0.0.0/0`, **Target** `VPC-A-IGW`.
    * **Subnet Associations:** Associate with `VPC-A-Public-Subnet`.
2.  **VPC B Public RT:**
    * Create a custom RT: **Name:** `VPC-B-Public-RT`, **VPC:** `VPC-B`.
    <img width="1827" height="473" alt="Image" src="https://github.com/user-attachments/assets/16fcaf23-6861-4d17-8651-d1e2724b40f2" />


    * **Routes Tab:** Add route: **Destination** `0.0.0.0/0`, **Target** `VPC-B-IGW`.
    <img width="1795" height="417" alt="Image" src="https://github.com/user-attachments/assets/36365718-2ec9-4d0a-a264-72aed07b1266" />

    * **Subnet Associations:** Associate with `VPC-B-Public-Subnet`.
    <img width="1797" height="647" alt="Image" src="https://github.com/user-attachments/assets/6b03fec0-5387-4795-8f43-5c94ff0adc57" />

    <img width="1772" height="492" alt="Image" src="https://github.com/user-attachments/assets/997077d2-9080-4209-887c-14bfbfe888c7" />

---

## 🔗 Part 2: Establish the VPC Peering Connection

### Step 2.1: Request the Peering Connection (VPC A Side)

1.  Navigate to **VPC** > **Peering Connections** > **Create Peering Connection**.
2.  **Name:** `A-to-B-Same-Region`
3.  **VPC ID (Requester):** Select **VPC-A**.
4.  **VPC ID (Accepter):** Select **VPC-B** (Ensure *My account* and *This Region* are selected).
5.  Click **Create Peering Connection**.

> The status will be **`pending-acceptance`**.

### Step 2.2: Accept the Peering Connection (VPC B Side)

1.  In the **Peering Connections** list, select the request.
2.  Choose **Actions** > **Accept Request**.
3.  Confirm the acceptance.

> The status will transition to **`Active`**. Note the **Peering Connection ID** (`pcx-xxxxxxxx`).



---

## 🛣️ Part 3: Update Route Tables for Peering

Both VPCs must be updated to route traffic destined for the other VPC's network through the Peering Connection.

### Step 3.1: Update VPC A Route Tables

Update every Route Table in VPC A that needs to communicate with VPC B (e.g., `VPC-A-Public-RT` and the RT for the private subnet).

1.  Select the **Route Table** in VPC A.
2.  Go to the **Routes** tab, click **Edit routes**, and **Add route**:
    * **Destination:** **VPC B's CIDR Block** (`10.2.0.0/16`).
    * **Target:** Select **Peering Connection** and choose the `pcx-xxxxxxxx` ID.
3.  Click **Save changes**.

### Step 3.2: Update VPC B Route Tables

1.  Select the **Route Table** in VPC B (e.g., `VPC-B-Public-RT`).
2.  Go to the **Routes** tab, click **Edit routes**, and **Add route**:
    * **Destination:** **VPC A's CIDR Block** (`10.1.0.0/16`).
    * **Target:** Select **Peering Connection** and choose the `pcx-xxxxxxxx` ID.
3.  Click **Save changes**.

---

## 🔒 Part 4: Configure Security Groups (Final Step)

Communication will still be blocked by Security Groups (SGs) unless explicitly allowed.

1.  **VPC A Security Group Rules:**
    * **Inbound (Ingress):** Add rules allowing necessary traffic (e.g., SSH, HTTP, ICMP) with **Source** set to **VPC B's CIDR Block** (`10.2.0.0/16`).
2.  **VPC B Security Group Rules:**
    * **Inbound (Ingress):** Add rules allowing necessary traffic (e.g., database port) with **Source** set to **VPC A's CIDR Block** (`10.1.0.0/16`).

> **Best Practice:** When possible, reference the specific **Security Group ID** of the peer instance/resource instead of the entire CIDR block for tighter security.