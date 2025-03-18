resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"

  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "allow_tls"
  }
}
resource "aws_instance" "this" {
  ami                    = "ami-09c813fb71547fc4f"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
    # 20GB is not enough
     root_block_device {
    # volume_size = 50  # Set root volume size to 50GB
    # volume_type = "gp3"  # Use gp3 for better performance (optional)
  }
  user_data= file("docker.sh")
  tags = {
    Name    = "docker"
  }
  # connection {
  #   host = self.public_ip
  #   type ="ssh"
  #   user ="ec2-user"
  #   password="DevOps321"
  # }

  # provisioner "remote-exec" {
  #   # Bootstrap script called with private_ip of each node in the cluster
  #   inline = [
  #     "sudo ARCH=amd64",
  #     "sudo PLATFORM=$(uname -s)_$ARCH",

  #   "sudo  growpart /dev/nvme0n1 4" ,
  #   " sudo lvextend -l +50%FREE /dev/RootVG/rootVol" ,
  #   " sudo lvextend -l +50%FREE /dev/RootVG/varVol" ,
  #   " sudo xfs_growfs / ",
  #   " sudo xfs_growfs /var" ,

  #   "sudo dnf -y install dnf-plugins-core" ,
  #   "sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo" ,
  #   "sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y" ,
  #   "sudo systemctl start docker" ,
  #   "sudo systemctl enable docker" ,
  #   "sudo usermod -aG docker ec2-user",
  #   #kubectl installation
  #     "sudo curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl",
  #     "sido chmod +x ./kubectl",
  #     "sudo mv kubectl /usr/local/bin/kubectl",
  #      #eksct
  #     "sudo curl -sLO https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz" ,
  #     "sudo tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz",
  #     "sudo mv /tmp/eksctl /usr/local/bin" 

  #    ]
  # }
 
}
 output "docker_ip" {
  value       = aws_instance.this.public_ip
}