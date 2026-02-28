resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "app" {
  bucket = "${var.project_name}-storage-${random_id.suffix.hex}"
}