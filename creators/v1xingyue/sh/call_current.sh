#!/bin/bash

echo " call.sh <module_name> <fun_name> <arg1,arg2,arg3> " 

package_addr=$(jq '.objectChanges[] | select(.type == "published")' publish.json | jq -r ".packageId")
module_name="$1"
fun_name="$2"

sui client call --gas-budget 200000000 \
    --package $package_addr \
    --module $module_name --function $fun_name --args "${@:3}"

