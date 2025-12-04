resource "aws_s3_bucket" "example" {
  bucket = "my-example-bucket-${random_id.suffix.hex}"
}

resource "random_id" "suffix" {
  byte_length = 4
}