

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