
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High time spent on Elasticsearch queries
---

This incident type refers to an elevated time spent on processing queries in an Elasticsearch cluster. It could be an indication of potential resource bottlenecks or a need to optimize the queries. This incident requires investigation and resolution to prevent further issues and ensure a smooth functioning Elasticsearch cluster.

### Parameters
```shell
# Environment Variables

export INDEX_NAME="PLACEHOLDER"

export ELASTICSEARCH_HOST="PLACEHOLDER"

export QUERY_TO_CACHE="PLACEHOLDER"

export NODE_CPU_CORES="PLACEHOLDER"

export PATH_TO_ELASTICSEARCH_CONFIG_FILE="PLACEHOLDER"

export NODE_MEMORY_SIZE_IN_GB="PLACEHOLDER"

export ELASTICSEARCH_PORT="PLACEHOLDER"

```

## Debug

### Check Elasticsearch cluster health
```shell
curl -X GET ${ELASTICSEARCH_HOST}:9200/_cluster/health?pretty
```

### Check Elasticsearch indices
```shell
curl -X GET ${ELASTICSEARCH_HOST}:9200/_cat/indices?v
```

### Check Elasticsearch node stats
```shell
curl -X GET ${ELASTICSEARCH_HOST}:9200/_nodes/stats?pretty
```

### Check Elasticsearch search and query latency
```shell
curl -X GET ${ELASTICSEARCH_HOST}:9200/_nodes/stats/indices/search?pretty
```

### Check Elasticsearch search and query throughput
```shell
curl -X GET ${ELASTICSEARCH_HOST}:9200/_nodes/stats/indices/search?pretty
```

### Check Elasticsearch query performance
```shell
curl -XGET ${ELASTICSEARCH_HOST}:9200/_cat/indices/${INDEX_NAME}?v&s=query_total
```

### Check Elasticsearch query time
```shell
curl -XGET ${ELASTICSEARCH_HOST}:9200/_cat/indices/${INDEX_NAME}?v&s=query_time
```

### Insufficient resources allocated to Elasticsearch cluster.
```shell
bash

#!/bin/bash



# Check CPU usage

CPU_USAGE=$(top -b -n1 | grep "Cpu(s)" | awk '{print $2}' | awk -F. '{print $1}')

if [ "$CPU_USAGE" -gt ${90} ]; then

  echo "CPU usage is high, which could indicate insufficient resources."

fi



# Check memory usage

TOTAL_MEMORY=$(free -m | awk '/^Mem:/{print $2}')

USED_MEMORY=$(free -m | awk '/^Mem:/{print $3}')

FREE_MEMORY=$(free -m | awk '/^Mem:/{print $4}')

if [ "$FREE_MEMORY" -lt ${2048} ]; then

  echo "Free memory is low, which could indicate insufficient resources."

fi



# Check disk usage

DISK_USAGE=$(df -h | awk '$NF=="/"{printf "%s", $5}')

if [ "${DISK_USAGE%\%}" -gt ${90} ]; then

  echo "Disk usage is high, which could indicate insufficient resources."

fi



# Check Elasticsearch logs for errors

ELASTICSEARCH_LOG="/var/log/elasticsearch/elasticsearch.log"

if [ -f "$ELASTICSEARCH_LOG" ]; then

  ERROR_COUNT=$(grep -i "error" "$ELASTICSEARCH_LOG" | wc -l)

  if [ "$ERROR_COUNT" -gt 0 ]; then

    echo "Elasticsearch logs contain errors, which could indicate insufficient resources."

  fi

else

  echo "Elasticsearch log file not found."

fi


```

## Repair

### Enable query caching for frequently executed queries
```shell


#!/bin/bash



# Set the Elasticsearch host and port

ELASTICSEARCH_HOST=${ELASTICSEARCH_HOST}:9200




# Enable caching for the query

curl -XPUT "http://${ELASTICSEARCH_HOST}:9200:9200/_all/_settings" -H 'Content-Type: application/json' -d'

{

  "index.queries.cache.enabled": true,

  "index.queries.cache.everything": true,

  "index.queries.cache.max_size": "10%",

  "index.queries.cache.expire": "5m",

  "index.queries.cache.recycler.schedule": "5m",

  "index.queries.cache.recycler.page_size": "1m"

}

'



# Refresh the index to apply changes

curl -XPOST "http://${ELASTICSEARCH_HOST}:9200/_refresh"



echo "Caching enabled for query: ${QUERY}"


```

### Fine-tune the Elasticsearch cluster configuration settings.
```shell
bash

#!/bin/bash



# Define variables

ELASTICSEARCH_CONFIG_FILE=${PATH_TO_ELASTICSEARCH_CONFIG_FILE}

NODE_MEMORY=${NODE_MEMORY_SIZE_IN_GB}

NODE_CPU=${NODE_CPU_CORES}



# Increase heap size

sed -i 's/-Xms[[:digit:]]\+g/-Xms'"$NODE_MEMORY"'g/g' $ELASTICSEARCH_CONFIG_FILE

sed -i 's/-Xmx[[:digit:]]\+g/-Xmx'"$NODE_MEMORY"'g/g' $ELASTICSEARCH_CONFIG_FILE



# Set CPU cores

sed -i 's/-Xss[[:digit:]]\+k/-Xss'"$(($NODE_MEMORY * 1024))"'k/g' $ELASTICSEARCH_CONFIG_FILE

sed -i 's/-XX:ParallelGCThreads=[[:digit:]]\+/-XX:ParallelGCThreads='"$NODE_CPU"'/g' $ELASTICSEARCH_CONFIG_FILE



# Restart Elasticsearch service

systemctl restart elasticsearch.service


```