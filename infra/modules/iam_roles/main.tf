# ecs ec2 role
resource "aws_iam_role" "ecs-ec2-role" {
  name = "ecs-ec2-role-test"

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
}

resource "aws_iam_instance_profile" "ecs-ec2-role" {
  name = "ecs-ec2-role-test"
  role = aws_iam_role.ecs-ec2-role.name
}

resource "aws_iam_role_policy" "ecs-ec2-role-policy" {
  name = "ecs-ec2-role-policy-test"
  role = aws_iam_role.ecs-ec2-role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ecs:CreateCluster",
              "ecs:DeregisterContainerInstance",
              "ecs:DiscoverPollEndpoint",
              "ecs:Poll",
              "ecs:RegisterContainerInstance",
              "ecs:StartTelemetrySession",
              "ecs:Submit*",
              "ecs:StartTask",
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
EOF
}

# ecs service role
resource "aws_iam_role" "ecs-service-role" {
  name = "ecs-service-role-test"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-service-attach" {
  role       = aws_iam_role.ecs-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

## service IAM
#
#data "aws_iam_policy_document" "ecs-service-policy" {
#    statement {
#        actions = ["sts:AssumeRole"]
#
#        principals {
#            type        = "Service"
#            identifiers = ["ecs.amazonaws.com"]
#        }
#    }
#}
#
#resource "aws_iam_role" "ecs-service-role" {
#    name                = "ecs-service-role"
#    path                = "/"
#    assume_role_policy  = data.aws_iam_policy_document.ecs-service-policy.json
#}
#
#resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
#    role       = aws_iam_role.ecs-service-role.name
#    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
#}
#
## instance IAM
#
#data "aws_iam_policy_document" "ecs-instance-policy" {
#    statement {
#        actions = ["sts:AssumeRole"]
#
#        principals {
#            type        = "Service"
#            identifiers = ["ec2.amazonaws.com"]
#        }
#    }
#}
#
#resource "aws_iam_role" "ecs-instance-role" {
#    name                = "ecs-instance-role"
#    path                = "/"
#    assume_role_policy  = data.aws_iam_policy_document.ecs-instance-policy.json
#}
#
#resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
#    role       = aws_iam_role.ecs-instance-role.name
#    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
#}
#
#resource "aws_iam_instance_profile" "ecs-instance-profile" {
#    name = "ecs-instance-profile"
#    path = "/"
#    role = aws_iam_role.ecs-instance-role.id
#    provisioner "local-exec" {
#      command = "sleep 10"
#    }
#}
#
