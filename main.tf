terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.67.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name_prefix  = "windows-test"
  public_key = tls_private_key.example.public_key_openssh
}


resource "aws_iam_role" "test_role" {
  name_prefix = "test-ssm-ec2"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = "test-ssm-ec2"
  }
}

resource "aws_iam_instance_profile" "test_profile" {
  name_prefix = "test-ssm-ec2"
  role = "${aws_iam_role.test_role.id}"
}

resource "aws_iam_policy_attachment" "test_attach1" {
  name       = "test-attachment"
  roles      = [aws_iam_role.test_role.id]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy_attachment" "test_attach2" {
  name       = "test-attachment"
  roles      = [aws_iam_role.test_role.id]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

data "aws_ami" "windows" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-ContainersLatest-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["801119661308"]
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.windows.id
  instance_type = "t3.xlarge"
  key_name      = aws_key_pair.generated_key.key_name
  iam_instance_profile = aws_iam_instance_profile.test_profile.name
  get_password_data = true
  associate_public_ip_address = true
  user_data = base64encode(file("./userdata.ps1"))
}

output "User" {
   value = [
     "Administrator"
   ]
 }

output "Password" {
   value = [
     rsadecrypt(aws_instance.ec2.password_data, tls_private_key.example.private_key_pem)
   ]
   sensitive = true
 }

 output "InstanceId" {
   value = [
     aws_instance.ec2.id
   ]
 }