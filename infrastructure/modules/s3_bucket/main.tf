resource "aws_s3_bucket" "mel_avatar" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name

  }
}
