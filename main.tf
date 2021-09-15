data "aiven_account" "main" {
  name = var.account_name
}

resource "aiven_kafka" "cluster" {
  project                 = var.project_name
  cloud_name              = var.cloud_name
  plan                    = var.plan
  service_name            = var.service_name
  maintenance_window_dow  = var.maintenance_window_dow
  maintenance_window_time = var.maintenance_window_time

  kafka_user_config {
    kafka_version = var.user_config_version
    ip_filter     = var.user_config_ip_filter

    kafka {
      group_max_session_timeout_ms    = var.user_config_kafka_group_max_session_timeout_ms
      log_retention_bytes             = var.user_config_kafka_log_retention_bytes
      auto_create_topics_enable       = var.user_config_kafka_auto_create_topics_enable
      message_max_bytes               = var.user_config_kafka_message_max_bytes
      offsets_retention_minutes       = var.user_config_kafka_offsets_retention_minutes
      compression_type                = var.user_config_kafka_compression_type
      log_cleaner_min_cleanable_ratio = var.user_config_kafka_log_cleaner_min_cleanable_ratio
    }

    kafka_rest_config {
      producer_linger_ms = var.user_config_rest_producer_linger_ms
      producer_acks      = var.user_config_rest_producer_acks
    }

    kafka_authentication_methods {
      sasl        = var.user_config_auth_sasl
      certificate = var.user_config_auth_certificate
    }
  }
}

resource "aiven_kafka_topic" "topic" {
  for_each = { for t in var.topics : t.name => t }

  project                = var.project_name
  service_name           = aiven_kafka.cluster.service_name
  topic_name             = each.value.name
  partitions             = each.value.partitions
  replication            = each.value.replication
  termination_protection = each.value.enable_termination_protection

  config {
    cleanup_policy                 = each.value.config_cleanup_policy
    flush_ms                       = each.value.config_flush_ms
    unclean_leader_election_enable = each.value.config_unclean_leader_election_enable
  }

  timeouts {
    create = each.value.timeout_create
    read   = each.value.timeout_read
  }
}

resource "aiven_service_user" "user" {
  for_each = toset([for v in var.users : v.name])

  project      = var.project_name
  service_name = aiven_kafka.cluster.service_name
  username     = each.value
}

resource "aiven_kafka_acl" "acl" {
  for_each = { for v in var.users : v.name => v.permission }

  project      = var.project_name
  service_name = aiven_kafka.cluster.service_name
  topic        = "*"
  permission   = each.value
  username     = each.key
}
