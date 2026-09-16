# How to inference Qwen3.8-Flash-Next on 12Gb VRAM.
This is an example of docker deployment of the latest MoE [Qwen](https://huggingface.co/Qwen/Qwen3.8-Flash-Next "Qwen") **(thank them a lot)** for agentic job, without any super-puper GPU, on common developer PC.
The performance is about **13 t/s**, but its not a quick handbook or autocomplete, its agentic job, it takes time, and it works! 

## Prerequisites
- Something like that PC: 
    - CPU - i7-14700;
    - RAM(important!) - **128Gb** *(at least not less than 100Gb)*;
    - GPU - **NVidia RTX A2000 12Gb** *(or better, sorry but NVidia and >12Gb VRAM is a must, or it will shurely fail on large context)*;
    - **250Gb+** of free space *(the quantized model is over 100Gb + Docker images)*.
- Linux OS *(I tested on Debian Trixie, but should work on others)*;
- [Docker installed](https://docs.docker.com/engine/install/debian/ "Install Docker Engine on Debian").

## Some structure info
- Dockerfile.LLM - I use [ik_llama.cpp](https://github.com/ikawrakow/ik_llama.cpp "ik_llama.cpp") **(thank them a lot)** for inference, its a port of famous [llama.cpp](https://github.com/ggml-org/llama.cpp "llama.cpp") **(thank them a lot)** but sometimes faster. Notice that llama.cpp and ik_llama.cpp are not the same, so parameters may significantly differ. Dockerfile is to build current version of ik_llama.cpp, target - llama-server;
- Dockerfile.OpenCode - Just latest [OpenCode](https://github.com/anomalyco/opencode "OpenCode") **(thank them a lot)** instance Dockerfile, nothing special;
- opencode.json - Opencode settings, notice that I set huge timeouts, sometimes it comes handy...
- docker-compose.yml - Docker compose file with 3 services:
    - download-weights - service to download [unsloth](https://huggingface.co/unsloth "unsloth") **(thank them a lot)** quantized weights from [Hugging Face](https://huggingface.co/unsloth/Qwen3.8-Flash-Next-GGUF/tree/main/UD-Q4_K_XL "Hugging Face") **(thank them a lot)** to ./models folder. I use UD-Q4_K_XL version, and its rather good;
    - llm-server - ik_llama.cpp llama-server with model params on port 8192;
    - opencode-server - just opencode server on port 4096.
- ./models - models folder;
- ./workspace - OpenCode job results.

## How to run it?
```bash
git clone https://github.com/artemablitsov/qwen38-flash-next-on-12-vram.git
cd qwen38-flash-next-on-12-vram
docker compose up
```
... wait for a few minutes untill OpenCode loads, and visit [OpenCode on localhost](http://localhost:4096 "Opencode on localhost").

**Its better to [download](https://huggingface.co/unsloth/Qwen3.8-Flash-Next-GGUF/tree/main/UD-Q4_K_XL "download") weights(~100Gb in 4 files) in advance, or wait until service download-weights download them automatically, it takes significant time.**

## Results
I tested this deployment on Doom-prompt, I dont know the author, but thank him a lot :)

Run the steps sequentially, if you run them all at once qwen can blow up :)
### Step 1. Builds an [DOOM](https://ru.wikipedia.org/wiki/Doom "Doom")-like game in js. This is the main procedure. Takes about an hour.
Act as an expert game developer. Create a complete, single-file retro 2.5D first-person shooter like DOOM (1993) using HTML, CSS, and modern JavaScript (Canvas or WebGL). Include basic first-person movement (WASD keys to move, mouse or arrow keys to rotate/look), flat floors and ceilings with distinct colors or simple textures, and solid vertical walls forming a small labyrinth room. Render a classic weapon sprite at the bottom center of the screen that bobs slightly when moving.
### Step 2. Not the must, but can improve code quality. Runs about 20 minutes.
Now, add shooting mechanics to the existing code. Pressing the spacebar or left mouse click should trigger a gun firing animation and sound effect (synthesized via Web Audio API if no external assets are loaded). Add a simple crosshair to the center of the screen and raycasting collision detection so bullets stop when hitting walls.
### Step 3. Again not the must, but... Runs about 20 minutes.
Finally, add simple enemy sprites that spawn in the room. Make these enemies track the player's position, move toward the player, and stop at a safe distance to 'attack'. Implement health counters for the player and the enemies, and allow the player's shots to damage and destroy the enemies. Keep the code clean and make no breaking changes to the existing rendering loop.
### Step 4. Profit.
Congratulations!
We've vibecoded a retro-style game. 

On this weak machine it took about 2 hours, but it works.

The performance is about **13 t/s**, but its not a quick handbook or autocomplete, its agentic job, it takes time, and it works! 

P.S. Full bwnchmark from http://localhost:8192/metrics
llamacpp:prompt_tokens_total 32105
llamacpp:prompt_seconds_total 299.496
llamacpp:tokens_predicted_total 86432
llamacpp:tokens_predicted_seconds_total 7599.46
llamacpp:prompt_tokens_seconds 107.197
llamacpp:predicted_tokens_seconds 11.3734
llamacpp:kv_cache_usage_ratio 0.897713
llamacpp:kv_cache_tokens 117665
llamacpp:requests_processing 0
llamacpp:requests_deferred 0

**Спасибо за внимание!**
