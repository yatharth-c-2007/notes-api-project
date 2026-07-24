terraform {
	required_providers {
		docker = {
			source = "kreuzwerker/docker"
			version = "~> 3.0"
			}
		kubernetes = {
                        source = "hashicorp/kubernetes"
                        version = "~> 2.23"
                }
	}
}

provider "docker" {}

resource  "docker_image" "app_image" {
	name = "notes-api:v1"
}

resource "docker_container" "app_container" {
	name = "notes-api-container-terraform"
	image = docker_image.app_image.image_id

	ports {
		internal = 3000
		external = 3000
	}
}

provider "kubernetes" {
	config_path    = "~/.kube/config"
}
resource "kubernetes_deployment" "notes-api" {
	metadata {
		name = "notes-api"
		namespace = "default"
		labels = {
			app = "notes-api"
		}
	}
	
	spec {
		replicas = 2

		selector {
			match_labels = {
				app = "notes-api"
			}
		}

		template {
			metadata {
				labels = {
					app = "notes-api"
				}
			}

			spec {
				container {
					name = "notes-api"
					image = "notes-api:v1"
					
					image_pull_policy = "Never"

					port {
						container_port = 3000
					}
				}
			}
		}
	}
}

resource "kubernetes_service" "notes-api" {
	metadata {
		name = "notes-api"
		namespace = "default"
		labels = {
			environment = "production"
		}
	}
	spec {
		selector = {
			app = "notes-api"
		}
	
	port {
		port = 3000
		target_port = 3000
	}

	type = "NodePort"
	}
}

