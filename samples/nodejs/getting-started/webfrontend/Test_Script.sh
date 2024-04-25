#!/bin/bash

set -x

CONFIG_MAP_NAME="configuration"  # ConfigMap name
CHART_DIRECTORY="webfrontend"    # Directory of your Helm chart

# Get the keys from the ConfigMap and remove double quotes
#keys=$(kubectl get configmap "$CONFIG_MAP_NAME" -o=jsonpath='{.data}' | tr -d '{}' | tr ',' '\n' | cut -d':' -f1 | sed 's/"//g')
keys=$(kubectl get configmap configuration -o=json | awk -F '[{},:]' '/"data":/{getline; gsub(/^ *"/, "", $1); gsub(/"$/, "", $1); print $1}')

# Iterate over each key
while IFS= read -r key; do
    # Get the value from the ConfigMap for the current key
    value=$(kubectl get configmap "$CONFIG_MAP_NAME" -o=jsonpath="{.data.$key}")

    # Update the values.yaml file if the key exists
    if grep -q "$key" "$CHART_DIRECTORY/values.yaml"; then
        sed -i "s/^ *$key:.*/  $key: \"$value\"/g" "$CHART_DIRECTORY/values.yaml"
    helm upgrade webfrontend webfrontend/ --values webfrontend/values.yaml --set-string image."$keys"="$value"
    fi
done <<< "$keys"

#helm upgrade webfrontend webfrontend/ --values webfrontend/values.yaml --set-string image."$keys"="$value"