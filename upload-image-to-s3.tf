# Upload an image to the S3 bucket
resource "aws_s3_bucket_object" "upload_image" {
  bucket = aws_s3_bucket.private_bucket.bucket
  key    = "images/my-image-s3.jpeg" # Path and name of the file in the bucket
  source = "/home/ec2-user/environment/my-image-s3.jpeg" # Path to your local image file
  etag   = filemd5("/home/ec2-user/environment/my-image-s3.jpeg") # Ensures consistency of the file

  tags = {
    UploadedBy = "Terraform"
  }
}
