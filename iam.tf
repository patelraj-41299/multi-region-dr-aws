resource "aws_iam_role" "s3_replication_role" {
  name = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "s3.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

resource "aws_iam_policy" "s3_replication_policy" {
  name = "s3-replication-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:ReplicateObject",
          "s3:ReplicateDelete"
        ],
        Resource = "*"
      }
    ]
  })

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

resource "aws_iam_role_policy_attachment" "replication_policy_attachment" {
  role       = aws_iam_role.s3_replication_role.name
  policy_arn = aws_iam_policy.s3_replication_policy.arn

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}
