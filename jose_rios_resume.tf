provider "aws" {
  region  = "us-east-2"
  profile = "default" # change if you use another AWS CLI profile
}

resource "aws_s3_bucket" "resume" {
  bucket = "jose-rios-resume"
}
