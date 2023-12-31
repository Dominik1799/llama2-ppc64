# adversea-llama-server
This build will **probably** not work on any other architecture than ppc64.

This does NOT contain any LLAMA model, you have to download it and reference it using ENV variables (see step 6).

For the model itself, use a GGML 5_K_M quantized model (example llama-2-7b-chat.ggmlv3.q5_K_M.bin). This allows you to load the largest model on your GPU with the smallest amount of quality loss. (I dont know what that means but its supposed to be true)

models: https://huggingface.co/TheBloke

search for GGML only!

## How to build and run adversea llama server

1. git clone https://github.com/abetlen/llama-cpp-python.git
2. cd llama-cpp-python
3. git submodule init && git submodule update
   1. verify that there is a full llama-cpp-python/vendor/llama.cpp directory
4. copy the whole **custom_cuda** directory from this repo into llama-cpp-python/docker
5. **inside llama-cpp-python** run 
```
docker build -f docker/custom_cuda/Dockerfile . -t adversea_llama_server
```
The image will take around 20 mins to build, maybe more

6. Run the image: 
```
docker container run \
  --privileged \
  --rm \
  --runtime=nvidia \
  --gpus all \
  --name adversea_llama_server \
  -e USE_MLOCK=0 \
  -v /data/LLAMA2/ggml_models:/models \
  -p 80:8000 \
  -e MODEL=/models/llama-2-7b-chat.ggmlv3.q5_K_M.bin \
  -e N_GPU_LAYERS=100 \
  adversea_llama_server
```
Use N_GPU_LAYERS variable to determine how much VRAM we should be using. For example the 13B model of LLAMA 2 has only 43 layers and they all fit into our VRAM. That takes up around 8GB. In total, we have ~32GB. Try to maximize the VRAM usage but always keep under the maximum we have.

7. Go to http://HOSTNAME:80/docs to see the openAPI endpoints

