"""Run with python3 tests/setup.py; all changes stay in a temporary XDG directory."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile

source = Path(__file__).resolve().parents[1]
with tempfile.TemporaryDirectory(prefix="nvim setup ") as temporary:
    root = Path(temporary)
    repo = root / "repo"
    repo.mkdir()
    shutil.copy2(source / "setup.sh", repo / "setup.sh")
    config = root / "config"
    env = dict(os.environ, XDG_CONFIG_HOME=str(config))

    def install():
        return subprocess.run(
            ["sh", str(repo / "setup.sh")], env=env,
            text=True, capture_output=True, check=True,
        ).stdout

    install()
    target = config / "nvim"
    assert target.is_symlink() and target.resolve() == repo
    assert "already linked" in install()
    assert not list(config.glob("nvim.backup.*")), "repeat install made a backup"

    target.unlink()
    target.mkdir()
    (target / "init.vim").write_text("set number\n")
    install()
    backups = list(config.glob("nvim.backup.*/nvim/init.vim"))
    assert len(backups) == 1 and backups[0].read_text() == "set number\n"
    assert target.is_symlink() and target.resolve() == repo

print("Neovim installer XDG path, backup and idempotency OK")
