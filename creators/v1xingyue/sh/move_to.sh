#!/bin/sh 

echo "move_to.sh object(arg1) to  address(arg2) "
sui client transfer --to $2 --object-id $1 --gas-budget 3000000
