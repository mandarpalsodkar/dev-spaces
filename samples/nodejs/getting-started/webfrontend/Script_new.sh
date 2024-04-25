#!/bin/bash
set -x

CONFIG_MAP_NAME="configuration"  # ConfigMap name
CHART_DIRECTORY="webfrontend"    # Directory of your Helm chart

#key1=repository
#key2=port
key3=type
key4=enabled
#key5=maxReplicas

#value_1=$(kubectl get configmap "$CONFIG_MAP_NAME" -o=jsonpath="{.data.$key1}")
#value_2=$(kubectl get configmap "$CONFIG_MAP_NAME" -o=jsonpath="{.data.$key2}")
value_3=$(kubectl get configmap "$CONFIG_MAP_NAME" -o=jsonpath="{.data.$key3}")
value_4=$(kubectl get configmap "$CONFIG_MAP_NAME" -o=jsonpath="{.data.$key4}")
#value_5=$(kubectl get configmap "$CONFIG_MAP_NAME" -o=jsonpath="{.data.$key5}")

helm upgrade webfrontend webfrontend/ --values webfrontend/values.yaml --set-string service.$key3="$value_3" --set-string autoscaling.$key4="$value_4" 
#helm upgrade webfrontend webfrontend/ --values webfrontend/values.yaml --set-string image.$key1="$value_1" --set-string service.$key2="$value_2" --set-string service.$key3="$value_3" --set-string autoscaling.$key4="$value_4" --set-string autoscaling.$key5="$value_5"
