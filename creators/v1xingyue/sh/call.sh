#!/bin/bash

echo " call.sh <module_name> <fun_name> <arg1,arg2,arg3> " 

package_addr="0x0b85e50fa01ef4f412cf9233cd3a54a611a87dff12e7cca853ac74a66fef65b6"
module_name="$1"
fun_name="$2"

sui client call --gas-budget 200000000 \
    --package $package_addr \
    --module $module_name --function $fun_name --args "${@:3}"

