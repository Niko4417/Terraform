output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.cloudfront.domain_name
}

output "oai_id" {
  value = aws_cloudfront_origin_access_identity.cloudfront.id
}