# Aiven Kafka module

Creates a Kafka cluster with provided topics.
Optionally creates users with different roles in the cluster.

## Example

```hcl
locals {
  topics = [
    {
      name                                  = "topic-1"
      partitions                            = 5
      replication                           = 3
      enable_termination_protection         = false
      config_cleanup_policy                 = "compact,delete"
      config_flush_ms                       = 10
      config_unclean_leader_election_enable = true
      timeout_create                        = "5m"
      timeout_read                          = "5m"
    }
  ]
  users = [
    {
      name       = "user-1"
      permission = "readwrite"
    }
  ]
}

module "aiven-kafka" {
  source = "github.com/dapperlabs-platform/terraform-aiven-kafka?ref=tag"

  account_name            = "account-name"
  project_name            = "project-name"
  team_name               = "project-engineering"
  cloud_name              = "google-us-west2"
  service_name            = "project-us-west2"
  plan                    = "startup-2"
  maintenance_window_dow  = "monday"
  maintenance_window_time = "08:00:00"

  # user config
  user_config_version                               = "2.8"
  user_config_ip_filter                             = ["0.0.0.0/0"]
  user_config_kafka_group_max_session_timeout_ms    = 150000
  user_config_kafka_log_retention_bytes             = 1000000000 #1GiB
  user_config_kafka_auto_create_topics_enable       = false
  user_config_kafka_message_max_bytes               = 5000000
  user_config_kafka_offsets_retention_minutes       = 525750
  user_config_kafka_compression_type                = "uncompressed"
  user_config_kafka_log_cleaner_min_cleanable_ratio = 0.4

  # rest config
  user_config_rest_producer_linger_ms = 5
  user_config_rest_producer_acks      = "all"

  # auth
  user_config_auth_certificate = true
  user_config_auth_sasl        = true

  # topics
  topics = local.topics

  # users
  users = local.users
}

```

## Variables

| name                                              | description                                                                                                           |     type     | required | default |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | :----------: | :------: | :-----: |
| account_name                                      | Name of the Aiven account the cluster will be deployed to                                                             |    string    |   yes    |         |
| project_name                                      | Identifies the project the service belongs to                                                                         |    string    |   yes    |         |
| cloud_name                                        | Defines where the cloud provider and region where the service is hosted in                                            |    string    |   yes    |         |
| service_name                                      | pecifies the name of the service                                                                                      |    string    |   yes    |         |
| plan                                              | Defines what kind of computing resources are allocated for the service.                                               |    string    |   yes    |         |
| maintenance_window_dow                            | Day of week when maintenance operations should be performed. On monday, tuesday, wednesday, etc                       |    string    |          |         |
| maintenance_window_time                           | Time of day when maintenance operations should be performed. UTC time in HH:mm:ss format                              |    string    |          |         |
| user_config_version                               | Kafka major version                                                                                                   |    string    |          |         |
| user_config_ip_filter                             | Allow incoming connections from CIDR address block                                                                    | list(string) |          |   []    |
| user_config_kafka_group_max_session_timeout_ms    | The maximum allowed session timeout for registered consumers                                                          |    number    |          |         |
| user_config_kafka_log_retention_bytes             | The maximum size of the log before deleting messages                                                                  |    number    |          |         |
| user_config_kafka_auto_create_topics_enable       | Enable auto creation of topics                                                                                        |     bool     |          |         |
| user_config_kafka_message_max_bytes               | The maximum size of message that the server can receive                                                               |    number    |          |         |
| user_config_kafka_offsets_retention_minutes       | Log retention window in minutes for offsets topic                                                                     |    number    |          |         |
| user_config_kafka_compression_type                | Specify the final compression type for a given topic                                                                  |    string    |          |         |
| user_config_kafka_log_cleaner_min_cleanable_ratio | Controls log compactor frequency                                                                                      |    number    |          |         |
| user_config_rest_producer_linger_ms               | Wait for up to the given delay to allow batching records together                                                     |    number    |          |         |
| user_config_rest_producer_acks                    | The number of acknowledgments the producer requires the leader to have received before considering a request complete |    string    |          |         |
| user_config_auth_sasl                             | Enable SASL authentication                                                                                            |     bool     |          |         |
| user_config_auth_certificate                      | Enable certificate/SSL authentication                                                                                 |     bool     |          |         |
| topics                                            | List of kafka topic objects                                                                                           | list(topic)  |          |   []    |
| users                                             | List of user objects with name and permission to be granted on all topics                                             |  list(user)  |          |   []    |

## Outputs

| name         | description                             | sensitive |
| ------------ | --------------------------------------- | :-------: |
| service_uri  | URI for connecting to the Kafka service |           |
| service_host | Kafka hostname                          |           |
| service_port | Kafka port                              |           |
