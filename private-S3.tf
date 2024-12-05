# Define the S3 bucket
resource "aws_s3_bucket" "private_bucket" {
  bucket = "finalproject-group4-s3" # Replace with a unique bucket name

  tags = {
    Name        = "My Private S3 Bucket"
    Environment = "PrivateS3"
  }
}

# Define the bucket ACL separately
resource "aws_s3_bucket_acl" "private_bucket_acl" {
  bucket = aws_s3_bucket.private_bucket.id
  acl    = "private"
}

# Configure a bucket policy to enforce private access
resource "aws_s3_bucket_policy" "private_bucket_policy" {
  bucket = aws_s3_bucket.private_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource  = [
          "${aws_s3_bucket.private_bucket.arn}/*",
          "${aws_s3_bucket.private_bucket.arn}"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false" # Deny requests that don't use HTTPS
          }
        }
      }
    ]
  })
}

# Outputs
output "bucket_name" {
  value = aws_s3_bucket.private_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.private_bucket.arn
}
