```
Task 
Dengan mendaftar akun free tier AWS/GCP/Azure, buatlah Infrastructre dengan terraform menggunakan registry yang sudah ada. dengan beberapa aturan berikut
Buatlah 2 buah server dengan OS ubuntu 24 dan debian 11 (Untuk spec menyesuaikan)
 - attach vpc ke dalam server tersebut
 - attach ip static ke vm yang telah kalian buat
 - pasang firewall ke dalam server kalian dengan rule {allow all ip(0.0.0.0/0)}
 - buatlah 2 block storage di dalam terraform kalian, lalu attach block storage tersebut ke dalam server yang ingin kalian buat. (pasang 1 ke server ubuntu dan 1 di server debian)
 - test ssh ke server
 - Buat terraform code kalian serapi mungkin
 - simpan script kalian ke dalam github dengan format tree sebagai berikut:
  Automation  
  |  
  | Terraform
  └─|  └── gcp
          │ └── main.tf
          │ └── providers.tf
          │ └── etc
          ├── aws
          │ └── main.tf
          │ └── providers.tf
          │ └── etc
          ├── azure
          │ └── main.tf
          │ └── providers.tf
          │ └── etc

```

# Install Terraform

Sebelum memulai task kita kali ini, kita diwajibkan untuk melakukan instalasi terraform terlebih dahulu di lokal kita. 

```
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

```

![image](https://github.com/user-attachments/assets/9a847368-97b8-409b-a0c9-ea6ca1ff4dd9)


Untuk implementasi tugas terraform kali ini kita wajib untuk punya account aws/google/azure dengan free tier didalamnya. Saya memakai aws untuk implementasi terraform.

![image](https://github.com/user-attachments/assets/1207f5b1-8cc1-43af-b1a5-b7e509cdc1b5)

## Mengonfigurasi AWS CLI

Command aws configure digunakan untuk mengonfigurasi AWS CLI agar dapat berinteraksi dengan akun AWS. Ini menyimpan informasi yang diperlukan tentang aws kita.

![image](https://github.com/user-attachments/assets/449a0115-754e-4242-a137-be38af07e394)

Setelah menjalankan perintah ini, Anda akan diminta untuk memasukkan beberapa informasi:

- AWS Access Key ID: Masukkan ID kunci akses Anda.
- AWS Secret Access Key: Masukkan kunci akses rahasia Anda.
- Default region name: Masukkan wilayah default (misalnya, us-east-1).
- Default output format: Masukkan format output default (misalnya, json, text, atau table).

## Struktur Direktori

![image](https://github.com/user-attachments/assets/8a5a2eac-13fe-474d-b59c-b8360c812791)

## providers.tf
File `providers.tf` digunakan untuk mengonfigurasi provider yang akan digunakan dalam proyek Terraform kita. Provider adalah plugin yang memungkinkan Terraform berinteraksi dengan layanan cloud dan API lainnya.
Karena saya memakai aws, maka saya akan menggunakan provider aws dari hashicorp

![image](https://github.com/user-attachments/assets/dcb9b061-46f5-4e2f-8db4-f3274693841e)

```terraform
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}
```

## variables.tf

File `variables.tf` digunakan untuk mendefinisikan variabel yang dapat digunakan dalam file konfigurasi Terraform lainnya. Variabel ini memungkinkan kita untuk mengonfigurasi value yang berbeda tanpa mengubah kode.

```terraform
variable "aws_region" {
  description = "The AWS region to deploy in"
  type        = string
  default     = "ap-southeast-1"
}

# variable "ami_id" {
#   description = "The AMI ID to use for the instance (Ubuntu 20)"
#   type        = string
#   default     = "ami-02ade692eafd8fc35" 
# }

variable "instance_type" {
  description = "The type of instance to use"
  type        = string
  default     = "t2.micro"
}

variable "ubuntu_ami_id" {
  description = "The AMI ID for Ubuntu 22"
  type        = string
  default     = "ami-03fa85deedfcac80b" 
}

variable "debian_ami_id" {
  description = "The AMI ID for Debian 11"
  type        = string
  default     = "ami-0ef9a2b1f4659b52a" 
}

# variable "vpc_id" {
#   description = "The ID of the VPC"
#   type        = string
#   default     = "vpc-0ee7cd531952dc591"
# }

variable "subnet_id" {
  description = "The ID of the subnet where instances will be launched"
  type        = string
  default     = "subnet-0981463b3709fe87a"
}

variable "block_storage_size" {
  description = "Size of the block storage in GiB"
  type        = number
  default     = 10
}

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
  default     = "cicd"
}

variable "security_group_id" {
  description = "The ID of the security group"
  type        = string
  default     = "sg-095769e3ec967367f"
}

```

Dalam file variable.tf saya menyimpan beberapa variable yang nantinya digunakan dalam main.tf. Variabel-variabel di atas memberikan fleksibilitas untuk kita mengonfigurasi berbagai aspek EC2 instance yang akan dibuat di AWS.


## main.tf 

main.tf adalah file utama yang berisi resources yang ingin kita buat menggunakan Terraform. Ini adalah tempat di mana kita mendefinisikan infrastruktur yang kita buat dimana nantinya akan dikelola oleh Terraform.

```terraform
provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "ubuntu" {
  ami           = var.ubuntu_ami_id
  instance_type = var.instance_type
  key_name      = var.key_name 
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  subnet_id = var.subnet_id

  tags = {
    Name = "Ubuntu-Server"
  }
}

resource "aws_instance" "debian" {
  ami           = var.debian_ami_id
  instance_type = var.instance_type
  key_name      = var.key_name 
  vpc_security_group_ids = [aws_security_group.allow_all.id]
  subnet_id     = var.subnet_id

  tags = {
    Name = "Debian-Server"
  }
}

resource "aws_eip" "ubuntu_eip" {
  instance = aws_instance.ubuntu.id
}

resource "aws_eip" "debian_eip" {
  instance = aws_instance.debian.id
}

data "aws_availability_zones" "available" {}

resource "aws_ebs_volume" "ubuntu_storage" {
  count             = 1
  availability_zone = element(data.aws_availability_zones.available.names, 0) 
  size              = var.block_storage_size
}

resource "aws_ebs_volume" "debian_storage" {
  count             = 1
  availability_zone = element(data.aws_availability_zones.available.names, 0) 
  size              = var.block_storage_size
}

resource "aws_volume_attachment" "ubuntu_attach" {
  count       = 1
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ubuntu_storage[0].id
  instance_id = aws_instance.ubuntu.id
}

resource "aws_volume_attachment" "debian_attach" {
  count       = 1
  device_name = "/dev/sdi"
  volume_id   = aws_ebs_volume.debian_storage[0].id
  instance_id = aws_instance.debian.id
}

# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_subnet" "main" {
#   # vpc_id            = var.vpc_id
#   cidr_block        = "172.31.48.0/20"
#   availability_zone = "${var.aws_region}a"
# }

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  # vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" // ALLOW ALL BANG
    cidr_blocks  = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" // ALLOW ALL BANG
    cidr_blocks  = ["0.0.0.0/0"]
  }
}

```

## Penjelasan file main.tf

- Resource instance
  - Membuat instans EC2 menggunakan ID AMI untuk Ubuntu/Debian yang diambil dari variabel ubuntu_ami_id & debian_ami_id jenis instace dari variable instance_type, nama kunci SSH dari var key_name, dan security group yang mengizinkan semua traffic. Instace ini diluncurkan di subnet yang ditentukan oleh subnet_id.
    
    ![image](https://github.com/user-attachments/assets/63e7bb4c-2bcb-4826-8c32-11d08e099b85)

- Resource Elastic IP
  - EIP: Membuat alamat IP elastis dan mengaitkannya dengan instance Ubuntu/Debian yang baru dibuat.
    
    ![image](https://github.com/user-attachments/assets/826afbb6-40a2-417f-a377-68465af27d8c)

    
- Resource EBS(Elastic Block Storage)
  - Membuat satu volume EBS yang terletak di availability zone pertama yang ditemukan. Ukuran volume diambil dari variabel block_storage_size.

    ![image](https://github.com/user-attachments/assets/6467eb8f-713f-43be-9814-e853b9b96b85)


- Resource volume attachment
  - Attach volume EBS yang dibuat sebelumnya ke instace Ubuntu/Debian pada device yang ditentukan oleh kita

    ![image](https://github.com/user-attachments/assets/6ac28267-8763-4be5-b680-239c53c8d980)

 
- Resource aws security group
  - Membuat grup keamanan yang mengizinkan semua network traffic masuk dan keluar. Ini berarti semua port dan protokol diperbolehkan dari dan ke semua alamat IP.

    ![image](https://github.com/user-attachments/assets/632dde26-bfed-4ef6-8a3b-6f7541e67c24)


Untuk resource VPC dan Subnet saya command terlebih dahulu, karena di AWS Free Tier tidak mencakup resources tersebut.

![image](https://github.com/user-attachments/assets/2609885a-b769-41ed-9d4a-f275015531c5)


# Terraform Command
Setelah semua konfigurasi kita setup kita bisa menjalankan perintah terraform untuk membuat infrastructure. Pertama kita lakukan terraform init, supaya kita menginisialisasi provider nya terlebih dahulu dalam case ini aws.

```
# Inisialisasi Terraform
terraform init

# Memvalidasi Script Terraform
terraform validate

# Check plan atau konfigurasi didalam untuk memastikan
terraform plan

# Running semua planning state
terraform apply

# Mematikan semua service jika sudah selesai dan tidak terpakai
terraform destroy

```
## 1. Inisialisasi direktori yang berisi file konfigurasi Terraform

![image](https://github.com/user-attachments/assets/d7f9e868-fc55-4184-91f9-7c27f4a4e70e)

## 2. Lakukan validate untuk memvalidasi konfigurasi dalam direktori kita

![image](https://github.com/user-attachments/assets/33ad9cdd-8706-456f-beda-939f5c33a832)

## 3. Jalankan Terraform Plan untuk membuat "blueprint" dari infrastruktur yang akan dibuat atau diubah berdasarkan file konfigurasi.

Contoh terraform plan

![image](https://github.com/user-attachments/assets/e5d20b9c-fa39-4f78-bdaa-81e95be6bfc5)

Karena sebelumnya saya sudah membuat infrastructure maka hasilnya akan seperti ini jika tidak ada perubahan dalam file konfigurasi kita

![image](https://github.com/user-attachments/assets/062ef9bf-4934-4f76-a201-29494e621bff)

## 4. Jalankan terraform apply untuk menerapkan semua perubahan yang didefinisikan dalam file konfigurasi Terraform ke infrastruktur yang sesungguhnya.

![image](https://github.com/user-attachments/assets/9be4a44b-58c8-4a53-87ac-f50b48f947a0)

## 5. Jika sudah kita bisa melihat di dashboard EC2 aws, kalau instance sudah terbuat sesuai dengan konfigurasi terraform.

![image](https://github.com/user-attachments/assets/95cd4bd5-857d-4bba-8ee1-133e12bca75f)

## 6. Kita bisa menjalankan terraform destroy untuk menghancurkan atau menghapus semua infrastruktur yang sudah dibuat oleh Terraform.

![image](https://github.com/user-attachments/assets/274190f7-0b28-4cff-9648-58641c10e1b5)
