provider "aws" {
  region = "us-east-1"
  access_key = "XXXXS"
  secret_key = "XXXX"
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

module "lam_api" {
  source        = "../../modules/lambda_api_gateway"
  api_gw_desc   = "API GW for myFunction"
  api_gw_name   = "HelloWorldFunctionGW"
  authorization = "NONE"
  filename      = "app.zip"
  function_name = "HelloWorldFunction"
  runtime       = "python3.8"
  handler       = "ex1_hello.lambda_handler"
  http_method   = "ANY"
}
