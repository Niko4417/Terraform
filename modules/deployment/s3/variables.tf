variable "bucket_name" {
  description = "Name of the S3 Bucket"
  type = string
}

variable "tags" {
  description = "Tags to apply to the S3 Bucket"
  type = map(string)
}

variable "index_doc" {
  description = "The index document to serve"
  type        = string
  default     = "index.html"
}

variable "error_doc" {
  description = "The error document to serve"
  type        = string
  default     = "error.html"
}