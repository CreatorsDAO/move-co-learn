#!/bin/bash

curl -d '
    {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "suix_queryEvents",
        "params": [
            {
                "MoveModule": {
                    "package": "0x920fc84021c7ad4622f4fcbde511b0344951b43dfa9cc639588e3d2bcefa6181",
                    "module": "allow_mint"
                }
            }
        ]
    }
' -H 'Content-Type: application/json' https://fullnode.devnet.sui.io:443