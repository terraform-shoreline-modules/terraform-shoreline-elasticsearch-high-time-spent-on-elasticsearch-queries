terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "high_time_spent_on_elasticsearch_queries" {
  source    = "./modules/high_time_spent_on_elasticsearch_queries"

  providers = {
    shoreline = shoreline
  }
}