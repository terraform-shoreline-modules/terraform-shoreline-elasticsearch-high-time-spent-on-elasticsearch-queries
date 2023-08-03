resource "shoreline_notebook" "high_time_spent_on_elasticsearch_queries" {
  name       = "high_time_spent_on_elasticsearch_queries"
  data       = file("${path.module}/data/high_time_spent_on_elasticsearch_queries.json")
  depends_on = [shoreline_action.invoke_check_resource_usage,shoreline_action.invoke_cache_enable,shoreline_action.invoke_heap_cpu_config]
}

resource "shoreline_file" "check_resource_usage" {
  name             = "check_resource_usage"
  input_file       = "${path.module}/data/check_resource_usage.sh"
  md5              = filemd5("${path.module}/data/check_resource_usage.sh")
  description      = "Insufficient resources allocated to Elasticsearch cluster."
  destination_path = "/agent/scripts/check_resource_usage.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "cache_enable" {
  name             = "cache_enable"
  input_file       = "${path.module}/data/cache_enable.sh"
  md5              = filemd5("${path.module}/data/cache_enable.sh")
  description      = "Enable query caching for frequently executed queries"
  destination_path = "/agent/scripts/cache_enable.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "heap_cpu_config" {
  name             = "heap_cpu_config"
  input_file       = "${path.module}/data/heap_cpu_config.sh"
  md5              = filemd5("${path.module}/data/heap_cpu_config.sh")
  description      = "Fine-tune the Elasticsearch cluster configuration settings."
  destination_path = "/agent/scripts/heap_cpu_config.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_resource_usage" {
  name        = "invoke_check_resource_usage"
  description = "Insufficient resources allocated to Elasticsearch cluster."
  command     = "`chmod +x /agent/scripts/check_resource_usage.sh && /agent/scripts/check_resource_usage.sh`"
  params      = []
  file_deps   = ["check_resource_usage"]
  enabled     = true
  depends_on  = [shoreline_file.check_resource_usage]
}

resource "shoreline_action" "invoke_cache_enable" {
  name        = "invoke_cache_enable"
  description = "Enable query caching for frequently executed queries"
  command     = "`chmod +x /agent/scripts/cache_enable.sh && /agent/scripts/cache_enable.sh`"
  params      = ["ELASTICSEARCH_HOST"]
  file_deps   = ["cache_enable"]
  enabled     = true
  depends_on  = [shoreline_file.cache_enable]
}

resource "shoreline_action" "invoke_heap_cpu_config" {
  name        = "invoke_heap_cpu_config"
  description = "Fine-tune the Elasticsearch cluster configuration settings."
  command     = "`chmod +x /agent/scripts/heap_cpu_config.sh && /agent/scripts/heap_cpu_config.sh`"
  params      = ["PATH_TO_ELASTICSEARCH_CONFIG_FILE","NODE_MEMORY_SIZE_IN_GB","NODE_CPU_CORES"]
  file_deps   = ["heap_cpu_config"]
  enabled     = true
  depends_on  = [shoreline_file.heap_cpu_config]
}

