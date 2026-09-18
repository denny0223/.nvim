"""Install plugins and check settings in a temporary HOME; requires network access."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

source = Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix="nvim install ") as temporary:
    home = Path(temporary)
    repo = home / ".nvim"
    shutil.copytree(source, repo, ignore=shutil.ignore_patterns(".git", "__pycache__"))
    env = dict(os.environ, HOME=str(home), NVIM_APPNAME="nvim")
    for kind in ("CONFIG", "DATA", "STATE", "CACHE"):
        env[f"XDG_{kind}_HOME"] = str(home / kind.lower())
    env["NVIM_LOG_FILE"] = str(home / "nvim.log")
    subprocess.run(["sh", str(repo / "setup.sh")], env=env, check=True)
    subprocess.run(
        ["nvim", "--headless", "-n", "-i", "NONE", "+PlugInstall --sync",
         "+lua print(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\\n'))", "+qa!"],
        env=env, check=True, timeout=300,
    )
    subprocess.run(
        [str(home / "data/nvim/plugged/fzf/bin/fzf"), "--version"], env=env, check=True,
    )
    subprocess.run(
        ["nvim", "--headless", "-n", "-i", "NONE", "-u", str(repo / "init.lua"),
         "-l", str(repo / "tests/settings.lua")],
        env=env, check=True, timeout=60,
    )

print("Neovim installation and settings in a clean HOME OK")
