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