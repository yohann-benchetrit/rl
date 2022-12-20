#!/usr/bin/env bash

set -e

eval "$(./conda/Scripts/conda.exe 'shell.bash' 'hook')"
conda activate ./env

export PYTORCH_TEST_WITH_SLOW='1'

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "$this_dir/set_cuda_envs.sh"

python -m torch.utils.collect_env
# Avoid error: "fatal: unsafe repository"
git config --global --add safe.directory '*'
root_dir="$(git rev-parse --show-toplevel)"
export MKL_THREADING_LAYER=GNU
export CKPT_BACKEND=torch

#MUJOCO_GL=glfw pytest --cov=torchrl --junitxml=test-results/junit.xml -v --durations 20
MUJOCO_GL=egl coverage run -m pytest --instafail -v --durations 20
coverage xml -i
