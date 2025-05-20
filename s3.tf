resource "aws_s3_bucket" "primary_bucket" {
  bucket = "multi-region-dr-primary"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

resource "aws_s3_bucket" "secondary_bucket" {
  bucket = "multi-region-dr-secondary"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

resource "aws_s3_bucket_versioning" "primary_versioning" {
  bucket = aws_s3_bucket.primary_bucket.id

  versioning_configuration {
    status = "Enabled"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

resource "aws_s3_bucket_versioning" "secondary_versioning" {
  bucket = aws_s3_bucket.secondary_bucket.id

  versioning_configuration {
    status = "Enabled"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  bucket = aws_s3_bucket.primary_bucket.id
  role   = aws_iam_role.s3_replication_role.arn

  rule {
    id     = "replication-rule"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.secondary_bucket.arn
      storage_class = "STANDARD"
    }
  }

  depends_on = [
    aws_s3_bucket.primary_bucket,
    aws_s3_bucket.secondary_bucket,
    aws_s3_bucket_versioning.primary_versioning,
    aws_s3_bucket_versioning.secondary_versioning
  ]

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}
