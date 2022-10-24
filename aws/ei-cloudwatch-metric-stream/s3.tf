module "kinesis_backup_bucket" {
  source = "../private-s3-bucket"

  bucket_name = "${var.s3_bucket_name}-${random_string.this.result}"

  lifecycle_rule = [
    {
      id                                     = "all"
      enabled                                = true
      prefix                                 = null
      abort_incomplete_multipart_upload_days = 3
      tags                                   = {}
      expiration = [
        {
          days                         = 14
          date                         = null
          expired_object_delete_marker = false
        }
      ]
      transition                    = []
      noncurrent_version_expiration = []
      noncurrent_version_transition = []
    }
  ]
}
