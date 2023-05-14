#!/bin/sh

 sui client objects --json | jq "{id: .[].data.objectId , type: .[].data.type}"