#!/bin/bash
set -e

echo "=============================="
echo " LTX 2.3 AUTO-PROVISIONER"
echo "=============================="

# ── 1. UPDATE COMFYUI ─────────────────────────────────────
echo "[1/5] Updating ComfyUI..."
cd /workspace/ComfyUI
git fetch --all -q
git checkout master -q
git pull origin master -q
pip install -r requirements.txt --break-system-packages -q

# ── 2. CUSTOM NODES ───────────────────────────────────────
echo "[2/5] Installing custom nodes..."
CN=/workspace/ComfyUI/custom_nodes
cd $CN

cup() {
  if [ ! -d "$1" ]; then
    echo "  + $1"
    git clone --depth=1 "$2" "$1" -q
  else
    echo "  ~ $1"
    git -C "$1" pull origin HEAD -q 2>/dev/null || true
  fi
}

cup "comfyui_controlnet_aux"      "https://github.com/Fannovel16/comfyui_controlnet_aux"
cup "ComfyUI-LTXVideo"            "https://github.com/Lightricks/ComfyUI-LTXVideo"
cup "ComfyUI-LTXVideo-Director"   "https://github.com/Lightricks/ComfyUI-LTXVideo-Director"
cup "ComfyUI-Impact-Pack"         "https://github.com/ltdrdata/ComfyUI-Impact-Pack"
cup "rgthree-comfy"               "https://github.com/rgthree/rgthree-comfy"
cup "ComfyUI-Custom-Scripts"      "https://github.com/pythongosssss/ComfyUI-Custom-Scripts"
cup "ComfyUI_LayerStyle"          "https://github.com/chflame163/ComfyUI_LayerStyle"
cup "ComfyUI-KJNodes"             "https://github.com/kijai/ComfyUI-KJNodes"
cup "ComfyUI-Easy-Use"            "https://github.com/yolain/ComfyUI-Easy-Use"
cup "ComfyUI-VideoHelperSuite"    "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite"
cup "ComfyUI-Frame-Interpolation" "https://github.com/Fannovel16/ComfyUI-Frame-Interpolation"
cup "cg-use-everywhere"           "https://github.com/chrisgoringe/cg-use-everywhere"
cup "Nvidia_RTX_Nodes_ComfyUI"    "https://github.com/Nvidia/Nvidia_RTX_Nodes_ComfyUI"
cup "CRT-Nodes"                   "https://github.com/crystian/ComfyUI-Crystools"
cup "WhatDreamsCost-ComfyUI"      "https://github.com/WhatDreamsCost/ComfyUI-WhatDreamsCost"
cup "TTS-Audio-Suite"             "https://github.com/FoxaFoxus/TTS-Audio-Suite"
cup "ComfyUI-PromptRelay"         "https://github.com/PolyMindAI/ComfyUI-PromptRelay"
cup "ComfyUI-MelBandRoFormer"     "https://github.com/kijai/ComfyUI-MelBandRoFormer"
cup "comfyui-resolution-master"   "https://github.com/bmad4ever/comfyui-resolution-master"
cup "ComfyUI-FancyTimerNode"      "https://github.com/Fannovel16/ComfyUI-FancyTimerNode"

# ── 3. PYTHON DEPS ────────────────────────────────────────
echo "[3/5] Installing Python dependencies..."
for req in $CN/*/requirements.txt; do
  pip install -r "$req" --break-system-packages -q 2>/dev/null || true
done

# ── 4. MODELS ─────────────────────────────────────────────
echo "[4/5] Downloading models..."

DM=/workspace/ComfyUI/models/diffusion_models
TE=/workspace/ComfyUI/models/text_encoders
VAE=/workspace/ComfyUI/models/vae
LORA=/workspace/ComfyUI/models/loras
LU=/workspace/ComfyUI/models/latent_upscale_models
RIFE=/workspace/ComfyUI/models/rife
POSE=/workspace/ComfyUI/models/dw-pose

mkdir -p $DM $TE $VAE "$LORA/LTX2.3" "$LORA/LTX2" $LU $RIFE $POSE

dl() {
  if [ ! -f "$1" ]; then
    echo "  Downloading: $(basename $1)"
    wget -q --show-progress -O "$1" "$2" || echo "  FAILED: $2"
  else
    echo "  Exists: $(basename $1)"
  fi
}

# Main model - LTX 2.3 FP8 distilled
dl "$DM/ltx-2.3-22b-distilled-1.1_transformer_only_fp8_scaled.safetensors" \
   "https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/diffusion_models/ltx-2.3-22b-distilled-1.1_transformer_only_fp8_scaled.safetensors"

# 10Eros V1.2 NSFW model
dl "$DM/ltx2310eros_v12.safetensors" \
   "https://huggingface.co/TenStrip/LTX2.3-10Eros/resolve/main/10Eros_v1.2_fp8mixed_learned.safetensors"

# Text encoders
dl "$TE/gemma_3_12B_it_fp8_scaled.safetensors" \
   "https://huggingface.co/Comfy-Org/ltx-2/resolve/main/split_files/text_encoders/gemma_3_12B_it_fp8_scaled.safetensors"

dl "$TE/ltx-2.3_text_projection_bf16.safetensors" \
   "https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/text_encoders/ltx-2.3_text_projection_bf16.safetensors"

# VAE
dl "$VAE/LTX23_video_vae_bf16.safetensors" \
   "https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_video_vae_bf16.safetensors"

dl "$VAE/LTX23_audio_vae_bf16.safetensors" \
   "https://huggingface.co/Kijai/LTX2.3_comfy/resolve/main/vae/LTX23_audio_vae_bf16.safetensors"

# Latent upscaler
dl "$LU/ltx-2.3-spatial-upscaler-x2-1.1.safetensors" \
   "https://huggingface.co/Lightricks/LTX-2.3/resolve/main/ltx-2.3-spatial-upscaler-x2-1.1.safetensors"

# LoRAs
dl "$LORA/LTX2.3/ltx-2.3-22b-distilled-lora-1.1_fro90_ceil72_condsafe.safetensors" \
   "https://huggingface.co/TenStrip/LTX2.3_Distilled_Lora_1.1_Experiments/resolve/main/ltx-2.3-22b-distilled-lora-1.1_fro90_ceil72_condsafe.safetensors"

dl "$LORA/LTX2.3/LTX-2_3-ID-LoRA-CelebVHQ-3K.safetensors" \
   "https://huggingface.co/Comfy-Org/ltx-2.3/resolve/main/split_files/loras/ltx-2.3-id-lora-celebvhq-3k.safetensors"

dl "$LORA/LTX2.3/ltx-2.3-22b-ic-lora-union-control-ref0.5.safetensors" \
   "https://huggingface.co/Lightricks/LTX-2.3-22b-IC-LoRA-Union-Control/resolve/main/ltx-2.3-22b-ic-lora-union-control-ref0.5.safetensors"

dl "$LORA/LTX2/ltx-2-19b-ic-lora-detailer.safetensors" \
   "https://huggingface.co/Lightricks/LTX-2-19b-IC-LoRA-Detailer/resolve/main/ltx-2-19b-ic-lora-detailer.safetensors"

# Audio separator
dl "$DM/MelBandRoformer_fp16.safetensors" \
   "https://huggingface.co/Kijai/MelBandRoFormer_comfy/resolve/main/MelBandRoformer_fp16.safetensors"

# RIFE frame interpolation
dl "$RIFE/rife49.pth" \
   "https://huggingface.co/AlexWortega/RIFE/resolve/main/rife49.pth"

# DW-Pose for ControlNet DWPreprocessor
dl "$POSE/dw-ll_ucoco_384_bs5.torchscript.pt" \
   "https://huggingface.co/Kijai/DWPose-SAM/resolve/main/dw-ll_ucoco_384_bs5.torchscript.pt"

# ── 5. LAUNCH ─────────────────────────────────────────────
echo "[5/5] Launching ComfyUI..."
cd /workspace/ComfyUI
python main.py \
  --listen 0.0.0.0 \
  --port 8188 \
  --highvram \
  --gpu-only \
  --fast \
  --disable-smart-memory
