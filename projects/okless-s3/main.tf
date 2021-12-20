provider "aws" {
  region = "us-east-1"
  access_key = "AKIART3CEBF5BNZ4SI4A"
  secret_key = "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"
}

locals {
  bucket_name = "okless-assets"
  bucket_acl  = "public-read-write"
}

module "bucket" {
  source      = "../../modules/s3"
  bucket_name = "okless-assets"
  bucket_acl  = "public-read-write"
}
resource "aws_s3_bucket_object" "app" {
  bucket       = local.bucket_name
  key          = "app"
  acl          = local.bucket_acl
  source       = "app/app.zip"
  content_type = "application/zip"
  etag         = filemd5("app/app.zip")
}