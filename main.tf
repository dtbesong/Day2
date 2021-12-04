resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2_s3_role1"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy" "ec2_s3_role_policy" {
  name = "ec2_s3_role_policy"
  role = aws_iam_role.ec2_s3_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
      "Sid": "Stmt1637208605071",
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    },
    ]
  })
}

resource "aws_iam_instance_profile" "web_instance_profile" {
  name = "web_instance_profile"
  role = aws_iam_role.ec2_s3_role.name
}



resource "aws_instance" "web" {
  ami           = "ami-09d4a659cdd8677be"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.web_instance_profile.name
  key_name = "ireland"

  tags = {
    Name = "websever"
  }
}
