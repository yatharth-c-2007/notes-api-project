terraform {
	required_providers {
		docker = {
			source = "kreuzwerker/docker"
			version = "~> 3.0"
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
