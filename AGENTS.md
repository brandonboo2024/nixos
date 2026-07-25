# Repository guidance

This checkout contains two independent Git repositories:

- `~/nixos` owns the NixOS flake, host modules, Home Manager modules, profiles,
  and wallpapers.
- `~/nixos/config` owns portable application configuration and helper scripts.
  The outer repository intentionally ignores this directory.

Always inspect `git status` in both repositories before and after a change.
Commit changes in the repository that owns each file. Do not stage the nested
repository as content of the outer repository.

## Structure

- Host-specific system configuration belongs under `hosts/`.
- Host-specific Home Manager overrides belong in `home/<Host>.nix`.
- Shared River packages and behavior belong in the River profiles.
- Mutable application configuration belongs in the nested `config/` checkout
  and is symlinked out of the Nix store by Home Manager.

Prometheus is the 3200x2000 Yoga. Do not change Hephaestus or Daedalus behavior
while making a Prometheus-specific adjustment.

River is active. Mango is retained for compositor experiments. Neovim is an
inactive migration reference. Zathura is kept even though sioyek is the
installed PDF reader. None of these are dead weight, and none may be removed
as incidental cleanup. Configuration in `config/` for a program that is not
currently installed is not by itself a reason to delete it.

Generated state is a different matter. Native-compilation and package caches
belong under `$XDG_DATA_HOME` / `$XDG_STATE_HOME`, never inside `config/`, and
may be removed once they are confirmed to be duplicates of the live location.

"Duplicate" means nothing outside the directory depends on it, not merely that
the bytes match. Before removing one, check that the copy meant to survive does
not reach back into it:

```sh
find <surviving-copy> -type l -lname '*<path-being-deleted>*'
```

`diff -rq` cannot answer this. When both copies contain symlinks with the same
absolute target, diff resolves each side to the same file and reports them
identical, which is exactly what a tree that depends on the doomed path looks
like. straight.el builds this way: `straight/build/` is symlinks into
`straight/repos/`, so a copied tree keeps pointing at the original.

If that check is skipped and the links are already broken, `straight/build/`
and `straight/build-cache.el` are wholly derived and can be regenerated from
`straight/repos/` by moving both aside and loading the config once.

## Validation

Run the smallest relevant checks while working. Before handing off Nix or Home
Manager changes, run:

```sh
nix flake check --no-build --offline
```

Also check shell syntax for edited scripts and parse every edited Emacs Lisp
file. Generated state, credentials, agent sessions, and authentication files
must remain untracked.

## Concurrent work

Use one write-capable agent per Git worktree. Additional agents sharing that
worktree must be read-only. Keep agent instructions and scripts independent of
a specific coding-agent vendor unless the behavior is inherently vendor-specific.
