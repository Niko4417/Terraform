terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}
resource "aws_cloudfront_origin_access_identity" "cloudfront" {
  comment = "Access Identity for CloudFront to access private S3 bucket"
}
resource "aws_cloudfront_distribution" "cloudfront" {

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  tags = var.tags

  origin {
    domain_name = var.s3_bucket_domain_name
    origin_id   = "s3-${var.s3_bucket_name}"


    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${var.cloudfront_oai_id}"

    }
  }
  default_cache_behavior {
    allowed_methods = [ "GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "s3-${var.s3_bucket_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

}
