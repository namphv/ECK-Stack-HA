variable "project_id" {
  type        = string
  description = "GCP project ID of project to deploy this sample into"
  default     = "elasticsearch"
}

variable "region" {
  type        = string
  description = "GCP zone in which to deploy the GKE cluster"
  default     = "us-central1"
}
variable "drain_job_name" {
  type        = string
  description = "Name for the drain job, this also affects the K8S namespace"
  default     = "drain-job"
}

variable "machine_type" {
  type        = string
  description = "Machine type to use for nodes within the GKE node pools"
  default     = "t2-standard-2"
}

variable "es_name" {
  type        = string
  description = "elasticsearch cluster pods label, it will be use in ECK deployment"
  default     = "elasticsearch"
}
