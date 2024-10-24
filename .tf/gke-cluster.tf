# GKE cluster
resource "google_container_cluster" "cluster" {
  name     = "${var.project_id}-gke"
  location = var.region
  project  = var.project_id

  remove_default_node_pool = true
  node_locations  = ["us-central1-a", "us-central1-b", "us-central1-f"]

  depends_on = [
    google_project_service.project
  ]
}


# Spot pool
resource "google_container_node_pool" "spot_pool" {
  provider = google-beta

  name       = "spot-node-pool"
  location   = var.region
  project    = var.project_id
  cluster    = google_container_cluster.cluster.name
  node_count = 1
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env = var.project_id
    }

    # enabling usage of spot nodes for this pool
    spot = true

    machine_type = var.machine_type
    tags         = ["gke-spot-node"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

# On-demand pool
resource "google_container_node_pool" "on_demand_pool" {
  name       = "on-demand-node-pool"
  location   = var.region
  project    = var.project_id
  cluster    = google_container_cluster.cluster.name
  node_count = 0
  autoscaling {
    min_node_count = 0
    max_node_count = 3
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env = var.project_id
    }

    machine_type = var.machine_type
    tags         = ["gke-on-demand-node"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
    taint {
        effect = "PREFER_NO_SCHEDULE"
        key    = "type"
        value  = "on-demand"
        }

  }
}
