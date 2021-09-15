output "service_uri" {
  description = "URI for connecting to the Kafka service"
  value       = aiven_kafka.cluster
}

output "service_host" {
  description = "Kafka hostname"
  value       = aiven_kafka.cluster.service_host
}

output "service_port" {
  description = "Kafka port"
  value       = aiven_kafka.cluster.service_port
}

output "access_cert" {
  description = "Kafka instance access certificate"
  value       = aiven_kafka.cluster.kafka[0].access_cert
}

output "access_key" {
  description = "Kafka instance access private key"
  value       = aiven_kafka.cluster.kafka[0].access_key
}
