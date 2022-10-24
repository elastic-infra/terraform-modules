variable "include_namespaces" {
  type        = list(string)
  description = "List of inclusive metric filters. See also https://docs.aws.amazon.com/ja_jp/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html"
  default     = ["AWS/ELB", "AWS/RDS"]
}

variable "ei_http_endpoint" {
  type        = string
  description = "The HTTP endpoint URL to which Kinesis Firehose sends data"
  default     = "https://cw-metric-stream.elastic-infra.com/v1"
}

variable "ei_access_key" {
  type        = string
  description = "Access key for EI HTTP endpoint"
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of S3 bucket for Kinesis backup configuration"
  default     = "cw-metric-stream-backup"
}

variable "kinesis_s3_buffer_size" {
  type        = number
  description = "Buffer incoming data to the specified size, in MBs, before delivering it to S3."
  default     = 5
}

variable "kinesis_s3_buffer_interval" {
  type        = number
  description = "Buffer incoming data for the specified period of time, in seconds, before delivering it to S3."
  default     = 300
}

variable "kinesis_http_buffer_size" {
  type        = number
  description = "Buffer incoming data to the specified size, in MBs, before delivering it to HTTP endpoint."
  default     = 5
}

variable "kinesis_http_buffer_interval" {
  type        = number
  description = "Buffer incoming data for the specified period of time, in seconds, before delivering it to HTTP endpoint."
  default     = 60
}

variable "kinesis_retry_duration" {
  type        = number
  description = "Total amount of seconds Firehose spends on retries."
  default     = 7200
}
