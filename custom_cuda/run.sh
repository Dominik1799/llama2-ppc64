#!/bin/bash

source /app/my_venv/bin/activate
make build.cuda
LLAMA_CUBLAS=1 uvicorn --factory llama_cpp.server.app:create_app --host $HOST --port $PORT
