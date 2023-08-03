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