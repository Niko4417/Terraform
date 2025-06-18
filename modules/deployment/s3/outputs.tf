output "bucket_website_url" {
  description = "Public URL of the S3 Bucket"
  value       = aws_s3_bucket.s3.website_endpoint
}