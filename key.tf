### SSh key creation

#Set Algorithm parameters

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create the key

resource "aws_key_pair" "firewall" {
  key_name   = "firewall"
  public_key = tls_private_key.key.public_key_openssh
}

# Give key as code output

output "private_key" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
 
}
