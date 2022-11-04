#!/bin/bash
mkdir -p data/{1..9}
find data/* -type d -exec touch "{}/dat" \;
