#!/bin/bash

# Step 0: Set the base model name
image_name="DeepSeek-Janus-Pro-7B"
namespace="gguf"
repo_name="https://huggingface.co/mradermacher/Janus-Pro-7B-LM-GGUF"

# # run once only
# # It takes 10+ hours
# git clone ${repo_name}
# cd Janus-Pro-7B-LM-GGUF
# git lfs install
# git lfs pull

# Step 1: Loop through each .gguf file in the current directory
# make sure you have pushed public key (~/.ollama/id_ed25519.pub) to your ollama account
for gguf_file in *.gguf; do
    # Extract the quantization level from the filename
    # Assuming the format is "Janus-Pro-7B-LM.Q4_K_M.gguf"
    # The quantization level starts at the last dot before ".gguf"
    quant_level="${gguf_file%.*}"  # Remove the ".gguf" extension
    quant_level="${quant_level##*.}"  # Extract the part after the last dot

    # Step 2: Create a new Modelfile with the appropriate name
    modelfile_name="Modelfile.$quant_level"
    echo "FROM ./$gguf_file" > "$modelfile_name"

    # Step 3: Create a new image with ollama
    ollama create "${namespace}/${image_name}:$quant_level" -f "$modelfile_name"

    # Step 4: Print the ollama push command
    ollama push ${namespace}/${image_name}:$quant_level
done
