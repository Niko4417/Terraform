terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

resource "aws_s3_bucket" "s3" {
  bucket = var.bucket_name
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

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.s3.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource = [
          "${aws_s3_bucket.s3.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "unblock" {
  bucket                  = aws_s3_bucket.s3.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}