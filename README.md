<div align="center">
    <h1> <a href="https://arxiv.org/abs/2602.09464">AlgoVeri: An Aligned Benchmark for Verified Code Generation on Classical Algorithms</a></h1>
</div>

<div align="center">

[![Hugging Face](https://img.shields.io/badge/-HuggingFace-3B4252?logo=huggingface)](https://huggingface.co/datasets/zzzzzhy/algoveri)
[![arXiv](https://img.shields.io/badge/arXiv-2602.09464-b31b1b.svg?style=flat)](https://arxiv.org/abs/2602.09464)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Email me](https://img.shields.io/badge/Contact-6fcf97?logo=gmail)](mailto:thomaszhao1998@gmail.com)

</div>

## 1. Introduction

We introduce AlgoVeri, a benchmark that evaluates vericoding of $77$ classical algorithms in Dafny, Verus, and Lean. By enforcing identical functional contracts, AlgoVeri reveals critical capability gaps in current models. While frontier models achieve tractable success in Dafny ($40.3$\% for Gemini-3 Flash), where high-level abstractions and SMT automation simplify the workflow, performance collapses under the systems-level memory constraints of Verus ($24.7$\%) and the explicit proof construction required by Lean (7.8\%). Beyond aggregate metrics, we uncover a sharp divergence in test-time compute dynamics: Gemini-3 effectively utilizes iterative repair to boost performance (e.g., tripling pass rates in Dafny), whereas GPT-OSS saturates early. Finally, our error analysis shows that language design affects the refinement trajectory: while Dafny allows models to focus on logical correctness, Verus and Lean trap models in persistent syntactic and semantic barriers.

<div>
  <img width="90%" src=assets/algoveri-teaser-img.png>
</div>

## 2. Environment Setup

### Version for different verifiers

We use the following specific verifiers:
* Dafny: 4.11
* Verus: 0.2025.01.13.da1c777
* Lean: 4.25.0-rc2

### Install verifiers

In this codebase, we use apptainer (docker without root access) to control the environments, and the following instructions are designed for apptainer. Please switch to the docker commands if you use docker.

Create a common folder that stores all the images, all the used compilers, etc

```bash
mkdir -p apptainer_imgs
cd apptainer_imgs
```

2. Build verifier images (scripts in `scripts/apptainer_setup/`):

```bash
bash ../scripts/apptainer_setup/dafny.sh
bash ../scripts/apptainer_setup/verus.sh
bash ../scripts/apptainer_setup/lean.sh
```

Refer to VERIFIER_README.md for more details if you encounter environment errors.

**Configuration**
- Copy and edit a config template (adjust paths and credentials):

```bash
# Edit config/config.yaml to set workspace paths and image locations
cp test/config_test.yaml config/config.yaml
```

**Testing verifiers (quick checks)**
Run the Python verifier tests (after configuring `config/config.yaml`):

```bash
python -m test.test_dafny_verify.py
python -m test.test_lean_verify.py
python -m test.test_verus_verify.py
```

These tests exercise the verifier harnesses and confirm that the verifier images are reachable from your environment.

**Note**

If you face difficulty installing the exact Mathlib version, you can indeed use your own version or use without Mathbib (for test, comment out the Mathlib import in test/test_lean_verify.py). AlgoVeri benchmark should be very robust to Mathlib version.

**Quick Start — run the verification tests**

For most users the simplest way to run the dataset verification harnesses is to use the provided Python test modules. After configuring `config/config.yaml`, run the verifier checks directly:

```bash
python -m test.test_dafny_verify.py
python -m test.test_lean_verify.py
python -m test.test_verus_verify.py
```

These runners exercise the verifier harnesses for the corresponding languages and are the recommended entry point for reproducing experiments or testing your environment.

# Run AlgoVeri Benchmark

The AlgoVeri benchmark is stored in `algoveri_data` folder.

We provide initial starting scripts to run our AlgoVeri benchmark in `scripts/runs_example_scripts`. The scripts to run API models, including Gemini-3.0 Flash, GPT-5 mini, GPT-5.3-Codex, are relatively straightforward. After setting up the API keys in comment line, run

```bash
bash scripts/runs_example_scripts/run_task_gemini.sh
bash scripts/runs_example_scripts/run_task_gpt-5-mini.sh
bash scripts/runs_example_scripts/run_task_gpt-5-3-codex.sh
```

You can change the hyperparameters (including the language being used) in the scripts.

To test open-source models using VLLM, we provide skeleton codes in other bash files (for SLURM environments).

```bash
bash scripts/runs_example_scripts/run_task_devstral_123b_instruct_with_server.sh
bash scripts/runs_example_scripts/run_task_gpt_oss_120b_with_server.sh
bash scripts/runs_example_scripts/run_task_qwen3_235b_instruct_with_server.sh
bash scripts/runs_example_scripts/run_task_qwen3_next_80b_a3b_thinking_with_server.sh
```

To successfully run these codes, you should change the paths to fit your own system to successfully serve the model using VLLM. The general logic is to set up the VLLM server and then call the API.

# License
- This project is licensed under the Apache 2.0 License. See LICENSE for details.

# Contact
- For questions about the dataset and benchmark, open an issue on GitHub or email.

# Citation

If you find our work useful, please consider star this project and cite.

```bibtex
@article{zhao2026algoveri,
  title={AlgoVeri: An Aligned Benchmark for Verified Code Generation on Classical Algorithms},
  author={Zhao, Haoyu and Yang, Ziran and Li, Jiawei and He, Deyuan and Li, Zenan and Jin, Chi and Veeravalli, Venugopal V and Gupta, Aarti and Arora, Sanjeev},
  journal={arXiv preprint arXiv:2602.09464},
  year={2026}
}
```

