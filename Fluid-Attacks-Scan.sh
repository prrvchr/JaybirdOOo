#!/bin/bash
docker run -v ~/github/JaybirdOOo:/src -v ./_fascan.yml:/fascan.yml fluidattacks/cli:latest skims scan /fascan.yml
#docker system prune -f
