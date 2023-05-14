#!/bin/sh

gas_id=$(sui client gas --json | jq -r ".[0].id.id")
echo "gas_id : $gas_id " 
sui client publish ./ --gas-budget 200000000 --gas $gas_id
