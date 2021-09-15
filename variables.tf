variable "account_name" {
  description = "Name of the Aiven account the cluster will be deployed to"
  type        = string
}

variable "project_name" {
  description = "Identifies the project the service belongs to"
  type        = string
}

variable "cloud_name" {
  description = "Defines where the cloud provider and region where the service is hosted in"
  type        = string
}

variable "service_name" {
  description = "Specifies the name of the service"
  type        = string
}

variable "plan" {
  description = "Defines what kind of computing resources are allocated for the service."
  type        = string
}

variable "maintenance_window_dow" {
  description = "Day of week when maintenance operations should be performed. On monday, tuesday, wednesday, etc"
  type        = string
  default     = null
}

variable "maintenance_window_time" {
  description = "Time of day when maintenance operations should be performed. UTC time in HH:mm:ss format."
  type        = string
  default     = null
}

variable "user_config_version" {
  description = "Kafka major version"
  type        = string
  default     = ""
}

variable "user_config_ip_filter" {
  description = "Allow incoming connections from CIDR address block"
  type        = list(string)
  default     = []
}

variable "user_config_kafka_group_max_session_timeout_ms" {
  description = "The maximum allowed session timeout for registered consumers."
  type        = number
  default     = null
}

variable "user_config_kafka_log_retention_bytes" {
  description = "The maximum size of the log before deleting messages"
  type        = number
  default     = null
}

variable "user_config_kafka_auto_create_topics_enable" {
  description = "Enable auto creation of topics"
  type        = string
  default     = false
}

variable "user_config_kafka_message_max_bytes" {
  description = "The maximum size of message that the server can receive"
  type        = number
  default     = null
}

variable "user_config_kafka_offsets_retention_minutes" {
  description = "Log retention window in minutes for offsets topic"
  type        = number
  default     = null
}

variable "user_config_kafka_compression_type" {
  description = "Specify the final compression type for a given topic"
  type        = string
  default     = null
}

variable "user_config_kafka_log_cleaner_min_cleanable_ratio" {
  description = "Controls log compactor frequency"
  type        = number
  default     = null
}

variable "user_config_rest_producer_linger_ms" {
  description = "Wait for up to the given delay to allow batching records together"
  type        = number
  default     = null
}

variable "user_config_rest_producer_acks" {
  description = "The number of acknowledgments the producer requires the leader to have received before considering a request complete"
  type        = string
  default     = null
}

variable "user_config_auth_sasl" {
  description = "Enable SASL authentication"
  type        = bool
  default     = null
}

variable "user_config_auth_certificate" {
  description = "Enable certificate/SSL authentication"
  type        = bool
  default     = null
}

variable "topics" {
  description = "List of kafka topic objects"
  type = list(object({
    name                                  = string
    partitions                            = number
    replication                           = number
    enable_termination_protection         = bool
    config_cleanup_policy                 = string
    config_flush_ms                       = string
    config_unclean_leader_election_enable = string
    timeout_create                        = string
    timeout_read                          = string
  }))
}

variable "users" {
  description = "List of user objects with name and permission to be granted on all topics"
  type = list(object({
    name       = string
    permission = string
  }))
  default = []
}
