provider "aws" {
  region                  = "ap-south-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

resource "aws_instance" "amazon" {
  ami           = "ami-026669ec456129a70"
  instance_type = "t2.micro"
  subnet_id     = "subnet-077c171a364ecbbbe"
  key_name      = "test"
  tags = {
    Name = "HelloTerraform"
  }
}