# SSH Remote Server Setup(WIP)

This project demonstrates how to set up a basic Linux server on AWS, configure it for SSH connections, and manage multiple SSH key pairs.

## Setup
### Manual Setup

#### 1. Provision a Remote Linux Server (AWS EC2)

1. Log in to [AWS Management Console](https://aws.amazon.com/console/).

2. Go to EC2 and launch a new instance:

    - Choose Amazon Linux 2023 (or latest stable version).

    - Select a free-tier eligible instance type (e.g., `t3.micro`).

    - Configure networking → allow inbound traffic on port 22 (SSH).

    - Download the default AWS key pair (`aws-key.pem`) or create your own.

    - Launch the instance.

3. Locate and copy your instance Public DNS in the EC2 dashboard.
#### 2. Connect to the Server with AWS Key
```bash
chmod 400 aws-key.pem
ssh -i aws-key.pem ec2-user@<server-DNS>
```
> **Note**: In the default AWS setting the the EC2 server user is `ec2-user`.

### Using Terraform
#### 1. Prerequisites
- [AWS account](https://aws.amazon.com/)
- AWS CLI configured with credentials (`aws configure`)
- Terraform installed (`terraform -v`)
- SSH installed locally

#### 2. Generate the main SSH Key
```bash
ssh-keygen -t rsa -f ~/.ssh/id_rsa.pub -C "terraform-key"
```
#### 3. Deploy with Terraform
```bash
terraform init
terraform apply -auto-approve
```
#### 4. Connect to the Server with the private key
```bash
ssh -i "~/.ssh/id_rsa" ec2-user@<server-DNS>
```

## Adding Multiple Key Pairs
### 1. Create Two New SSH Key Pairs

On your local machine:
```bash
ssh-keygen -t rsa -f ~/.ssh/key1 -C "key1"
ssh-keygen -t rsa -f ~/.ssh/key2 -C "key2"
```

This creates:
- `~/.ssh/key1` and `~/.ssh/key1.pub`
- `~/.ssh/key2` and `~/.ssh/key2.pub`
### 2. Add Public Keys to the Server

On the server (`user@<server-DNS>`):
```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
```

Append both public keys to authorized_keys:
```bash
echo "<contents-of-key1.pub>" >> ~/.ssh/authorized_keys
echo "<contents-of-key2.pub>" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```
### 3. Test SSH Connections with Both Keys

From your local machine:
```bash
ssh -i ~/.ssh/key1 ec2-user@<server-DNS>
ssh -i ~/.ssh/key2 ec2-user@<server-DNS>
```
Both should log you into the server successfully.

### 4. Configure ~/.ssh/config

To simplify connections, edit ~/.ssh/config on your local machine:
```bash
Host myserver-key1
    HostName <server-DNS>
    User ec2-user
    IdentityFile ~/.ssh/key1

Host myserver-key2
    HostName <server-DNS>
    User ec2-user
    IdentityFile ~/.ssh/key2
```

Now you can connect with:
```bash
ssh myserver-key1
ssh myserver-key2
```
