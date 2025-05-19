# 🌐 VPC Outputs
output "primary_vpc_id" {
  value = aws_vpc.primary.id
}

output "secondary_vpc_id" {
  value = aws_vpc.secondary.id
}

# 🪣 S3 Bucket Outputs
output "primary_s3_bucket" {
  value = aws_s3_bucket.primary_bucket.bucket
}

output "secondary_s3_bucket" {
  value = aws_s3_bucket.secondary_bucket.bucket
}

# 🛢️ RDS Outputs
output "rds_primary_endpoint" {
  value = aws_db_instance.primary.endpoint
}

output "rds_primary_identifier" {
  value = aws_db_instance.primary.id
}

# 🌍 RDS Replica Output (commented out until replica is deployed)
output "rds_replica_identifier" {
  value = aws_db_instance.replica.id
}
