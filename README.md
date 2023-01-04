# Neovim config

## Copy build to cache

Copy runtime closure
```
$ nix build --json | jq -r '.[].outputs.out' | xargs -n1 nix copy --verbose --to 'ssh://nix@nix-cache-ssh.tools.kbee.xyz'
```

Copy flake inputs
```
$ nix flake archive --json | jq -r '.path,(.inputs|to_entries[].value.path)' | xargs -n1 nix copy --verbose --to 'ssh://nix@nix-cache-ssh.tools.kbee.xyz'
```
