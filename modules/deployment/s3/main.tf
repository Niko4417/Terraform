terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}
resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "s3" {
  bucket = "${lower(var.bucket_name)}-${random_id.suffix.hex}"
  tags   = var.tags
}

resource "aws_s3_bucket_website_configuration" "s3" {
  bucket = aws_s3_bucket.s3.id

  index_document {
    suffix = var.index_doc
  }
  error_document {

    key = var.error_doc
  }
}

resource "aws_s3_bucket_public_access_block" "unblock" {
  bucket                  = aws_s3_bucket.s3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "cloudfront" {
  bucket = aws_s3_bucket.s3.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontRead",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${var.cloudfront_oai_id}"
        },
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.s3.arn}/*"
      }
    ]
  })
}

