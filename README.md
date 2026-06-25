
# LTX-Setup for RunPod

Automated startup script for deploying and maintaining LTX-Video environments on RunPod using a lightweight startup command that bypasses RunPod's 4000-character Start Command limit.

---

# Overview

RunPod limits the Start Command field to approximately 4000 characters. Complex setup scripts for ComfyUI, LTX Video models, custom nodes, and dependency installation often exceed this limit.

This repository solves that problem by storing the full initialization script in GitHub and having RunPod download and execute it during startup.

Instead of maintaining a huge startup command inside RunPod, you only need:

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/YOUR_USERNAME/ltx-setup/main/setup.sh)"
```

Replace:

```text
YOUR_USERNAME
```

with your GitHub username.

---

# Advantages

## Bypass RunPod Character Limits

The startup command remains under 200 characters regardless of how large your setup script becomes.

## Easy Maintenance

Update your GitHub script whenever you:

* Add new models
* Install new custom nodes
* Change dependencies
* Update ComfyUI configuration
* Add optimization settings

No changes are required in RunPod.

## Version Control

GitHub tracks all modifications, allowing:

* Rollbacks
* Change history
* Collaboration
* Backup of deployment scripts

## Automatic Updates

Every new pod startup automatically pulls the latest script from GitHub.

---

# Requirements

## GitHub Account

You need a GitHub account.

Create one at:

https://github.com

---

## RunPod Account

You need:

* Active RunPod account
* GPU pod template
* Internet access enabled for the pod

---

## Basic Knowledge

Recommended familiarity with:

* GitHub repositories
* RunPod templates
* Linux shell commands
* ComfyUI setup

---

# Repository Setup

## Step 1: Create Repository

1. Sign in to GitHub
2. Click New Repository
3. Repository name:

```text
ltx-setup
```

4. Visibility:

```text
Public
```

5. Click:

```text
Create Repository
```

---

## Step 2: Add setup.sh

Create:

```text
setup.sh
```

Upload your full startup script.

Commit changes.

---

## Step 3: Get Raw URL

Open:

```text
setup.sh
```

Click:

```text
Raw
```

Copy URL.

Example:

```text
https://raw.githubusercontent.com/johndoe/ltx-setup/main/setup.sh
```

---

# RunPod Configuration

## Start Command

Paste:

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/YOUR_USERNAME/ltx-setup/main/setup.sh)"
```

Replace:

```text
YOUR_USERNAME
```

with your GitHub username.

---

# Environment Variables

Create the following variables:

| Variable            | Value |
| ------------------- | ----- |
| MODEL_VERSION       | 2.3   |
| SKIP_COMFYUI_UPDATE | false |
| NSFW                | true  |

---

# Recommended Storage

## Minimum Configuration

Suitable for testing.

| Resource           | Size   |
| ------------------ | ------ |
| Container Disk     | 20 GB  |
| Persistent Storage | 100 GB |

---

## Recommended Configuration

Suitable for regular use.

| Resource           | Size   |
| ------------------ | ------ |
| Container Disk     | 20 GB  |
| Persistent Storage | 150 GB |

---

## Heavy Usage Configuration

Recommended if storing many models.

| Resource           | Size       |
| ------------------ | ---------- |
| Container Disk     | 30–50 GB   |
| Persistent Storage | 300–500 GB |

---

# GPU Recommendations

## Budget Option

### NVIDIA RTX 3090

VRAM:

```text
24 GB
```

Suitable for:

* Testing
* Basic workflows
* Lower resolution generations

---

## Best Value

### NVIDIA RTX 4090

VRAM:

```text
24 GB
```

Suitable for:

* LTX Video
* ComfyUI
* Fast inference

Recommended for most users.

---

## Professional Option

### NVIDIA A5000

VRAM:

```text
24 GB
```

Suitable for:

* Stable workloads
* Production environments

---

## High-End Option

### NVIDIA A6000

VRAM:

```text
48 GB
```

Suitable for:

* Large video models
* Multiple workflows
* Heavy custom node usage

---

## Enterprise Option

### NVIDIA H100

VRAM:

```text
80 GB
```

Suitable for:

* Maximum performance
* Large-scale deployments
* Multiple concurrent generations

---

# Recommended GPU Selection

## Cost Efficient

```text
RTX 4090
```

Best balance of:

* Price
* Availability
* Performance

---

## Large Model Workflows

```text
A6000 48GB
```

Recommended when:

* Running multiple models
* Using large checkpoints
* Heavy video generation

---

## Maximum Performance

```text
H100 80GB
```

For professional production environments.

---

# Suggested Directory Structure

```text
ltx-setup/
│
├── README.md
├── setup.sh
├── models/
├── custom_nodes/
├── configs/
└── scripts/
```

---

# Example setup.sh Responsibilities

Your script may:

* Update ComfyUI
* Install custom nodes
* Download models
* Install Python packages
* Configure environment variables
* Create folders
* Apply optimizations
* Start services automatically

---

# Updating Your Deployment

Whenever you need changes:

1. Edit setup.sh
2. Commit changes to GitHub
3. Launch a new RunPod pod

The new pod automatically pulls the latest version.

No RunPod template modifications are required.

---

# Troubleshooting

## Script Does Not Run

Verify:

```bash
wget
```

is installed.

Check:

```bash
https://raw.githubusercontent.com/USERNAME/ltx-setup/main/setup.sh
```

opens successfully.

---

## Permission Errors

Add:

```bash
chmod +x setup.sh
```

inside the script if required.

---

## Models Missing

Verify:

* Download URLs are valid
* Storage volume is mounted
* Download paths are correct

---

## Pod Restarts Repeatedly

Check:

```bash
bash -x setup.sh
```

for debugging.

Review:

* Syntax errors
* Missing dependencies
* Invalid URLs

---

# Security Considerations

Because the startup script executes automatically:

* Only use repositories you control.
* Keep repository access secure.
* Review changes before committing.
* Avoid storing secrets directly in setup.sh.
* Use RunPod environment variables for credentials.

---

# Backup Strategy

Recommended:

* GitHub repository for scripts
* Persistent storage for models
* Separate backup of custom nodes

This minimizes setup time when recreating pods.

---

# Recommended Starter Configuration

For most LTX Video users:

GPU:

```text
RTX 4090
```

Container Disk:

```text
20 GB
```

Persistent Storage:

```text
150 GB
```

Environment Variables:

```text
MODEL_VERSION=2.3
SKIP_COMFYUI_UPDATE=false
NSFW=true
```

Start Command:

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/YOUR_USERNAME/ltx-setup/main/setup.sh)"
```

This configuration provides the best balance of cost, storage, and performance for typical LTX Video and ComfyUI workflows.
