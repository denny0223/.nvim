"""Run with python3 tests/setup.py; uses local Git repos in a temporary HOME."""
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
    for name in ("setup.sh", "init.lua"):
        shutil.copy2(source / name, repo / name)
    config = root / "config"
    home = root / "home"
    home.mkdir()
    env = dict(os.environ, HOME=str(home), XDG_CONFIG_HOME=str(config),
               NVIMRC_REPO=str(repo), GIT_CONFIG_GLOBAL=os.devnull,
               GIT_CONFIG_NOSYSTEM="1")
    env.pop("NVIMRC_DIR", None)

    def install(piped=False, check=True):
        return subprocess.run(
            ["sh"] if piped else ["sh", str(repo / "setup.sh")], env=env, cwd=root,
            input=(repo / "setup.sh").read_text() if piped else None,
            text=True, capture_output=True, check=check,
        )

    install()
    target = config / "nvim"
    assert target.is_symlink() and target.resolve() == repo
    assert "already linked" in install().stdout
    assert not list(config.glob("nvim.backup.*")), "repeat install made a backup"

    target.unlink()
    target.mkdir()
    (target / "init.vim").write_text("set number\n")
    install()
    backups = list(config.glob("nvim.backup.*/nvim/init.vim"))
    assert len(backups) == 1 and backups[0].read_text() == "set number\n"
    assert target.is_symlink() and target.resolve() == repo

    def git(*args):
        subprocess.run(
            ["git", "-C", str(repo), "-c", "user.name=Installer test",
             "-c", "user.email=installer@example.invalid", "-c", "commit.gpgsign=false",
             *args], env=env, check=True, capture_output=True, text=True,
        )

    git("init", "--initial-branch=main")
    git("add", ".")
    git("commit", "-m", "Initial configuration")
    del env["XDG_CONFIG_HOME"]
    clone = home / ".nvim"
    target = home / ".config/nvim"
    target.mkdir(parents=True)
    (target / "init.vim").write_text("set ruler\n")
    install(piped=True)
    assert (clone / ".git").is_dir()
    assert target.is_symlink() and target.resolve() == clone
    backups = list(target.parent.glob("nvim.backup.*/nvim/init.vim"))
    assert len(backups) == 1 and backups[0].read_text() == "set ruler\n"

    (repo / "init.lua").write_text("-- Updated configuration\n")
    git("commit", "-am", "Update configuration")
    assert "already linked" in install(piped=True).stdout
    assert (clone / "init.lua").read_text() == "-- Updated configuration\n"
    assert list(target.parent.glob("nvim.backup.*/nvim/init.vim")) == backups

    shutil.rmtree(clone)
    clone.mkdir()
    (clone / "init.lua").write_text("-- Existing personal configuration\n")
    result = install(piped=True, check=False)
    assert result.returncode != 0 and "not a git checkout" in result.stderr
    assert (clone / "init.lua").read_text() == "-- Existing personal configuration\n"
    shutil.rmtree(clone)
    clone.symlink_to(home / "missing")
    result = install(piped=True, check=False)
    assert result.returncode != 0 and "not a git checkout" in result.stderr
    assert clone.is_symlink()

    env["NVIMRC_DIR"] = "custom checkout"
    env["XDG_CONFIG_HOME"] = str(root / "custom config")
    install(piped=True)
    assert (root / "custom config/nvim").resolve() == root / "custom checkout"
    assert (root / "custom checkout/init.lua").read_text() == "-- Updated configuration\n"

print("Neovim local and piped installation, update, backup and idempotency OK")
