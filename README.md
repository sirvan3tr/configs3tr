# RSS-and-Configs
My macos config is `~/.zshrc`

# Books
## Software Engineering
### General
* Modern Software Engineering: Doing What Works to Build Better Software Faster

### Go
* Powerful Command-Line Applications in Go: Build Fast and Maintainable Tools
* Distributed Services with Go: Your Guide to Reliable, Scalable, and Maintainable Systems
* Writing A Compiler In Go
* Writing An Interpreter In Go
* Go Programming Language
* Network Programming with Go: Learn to Code Secure and Reliable Network Services from Scratch
* 

### Linux
* UNIX and Linux System Administration Handbook\

defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

## Key Repeat on MacOS

On macOS, the default key repeat behavior shows a character picker popup instead of repeating keys — which breaks Vim navigation (like holding `j` to move down).

**Fix: Disable press-and-hold for key repeat**

Run this in Terminal:

```bash
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
```

Then **log out and back in** (or restart) for it to take effect.

---

**Optional: Speed up key repeat rate**

You can also tune the repeat speed via System Settings → Keyboard, or via Terminal:

```bash
# Lower = faster repeat (minimum is 1)
defaults write NSGlobalDomain KeyRepeat -int 1

# Lower = shorter delay before repeat starts (minimum is 15)
defaults write NSGlobalDomain InitialKeyRepeat -int 15
```

---

**For VS Code / specific apps only** (instead of system-wide):

```bash
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
```

Replace `com.microsoft.VSCode` with the app's bundle ID for other apps.

---

**To revert** back to macOS default behavior:

```bash
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool true
```

The most impactful change for Vim users is the first command — after that, holding `h/j/k/l` will repeat as expected.

## Packages for the nvim config

```
brew install gh fzf stylua ruff code-minimap
npm install -g prettier eslint typescript-language-server
```

## CLI / Shell tools (macOS)

One-liner to install the lot:

```bash
brew install zoxide fzf ripgrep fd bat eza git-delta lazygit direnv \
             starship atuin tmux zellij neovim gh \
             fx lazydocker dive \
             kubectx helmfile \
             zsh-autosuggestions zsh-syntax-highlighting
```

See [`kubernetes.md`](./kubernetes.md) for a focused productivity guide on
`kubectl`, `k9s`, `helm`, `helmfile`, `kubectx`, `kubens`, `tilt`, etc.

Then run once to install fzf's zsh keybindings (creates `~/.fzf.zsh`):

```bash
$(brew --prefix)/opt/fzf/install
```

Then wire them into `~/.zshrc` (see the **`.zshrc` snippets** section below)
and configure delta in `~/.gitconfig` (see **git-delta config** below).

### Navigation

* **zoxide** — smarter `cd`, jumps to most-used dirs by frecency.
  - Use: `z yjs` jumps to `~/sites/yjs`. `zi` opens an interactive picker.
  - Replaces the old oh-my-zsh `z` plugin — remove `z` from `plugins=(...)` if you use zoxide.
* **fzf** — fuzzy finder, the single biggest terminal quality-of-life upgrade.
  - After install, run `$(brew --prefix)/opt/fzf/install` to enable keybindings.
  - `Ctrl-R` — fuzzy search shell history
  - `Ctrl-T` — fuzzy pick a file/path into the current command
  - `Alt-C` — fuzzy `cd` into a subdirectory
  - Pipe anywhere: `git branch | fzf`
* **broot** (optional) — interactive tree view with fuzzy jump. Run `br`.

### File listing / search

* **ripgrep** (`rg`) — fastest grep. `rg foo` recursively searches.
* **fd** — friendly `find`. `fd pattern` is all you usually need.
* **bat** — `cat` with syntax highlighting + git gutter. Alias `cat='bat -p'` for plain-ish output.
* **eza** — modern `ls`. Common aliases:
  ```bash
  alias ls='eza --git --icons'
  alias ll='eza -l --git --icons'
  alias lt='eza --tree --level=2 --icons'
  ```

### Git

* **lazygit** — full-screen git TUI. Run `lazygit` in any repo.
  - `Space` stage, `c` commit, `P` push, `p` pull, `R` rebase, `?` help.
* **git-delta** — pretty diff viewer. Enable in `~/.gitconfig`:
  ```ini
  [core]
      pager = delta
  [interactive]
      diffFilter = delta --color-only
  [delta]
      navigate = true
      line-numbers = true
      side-by-side = true
  ```
* **gh** — GitHub CLI. `gh pr create`, `gh pr checkout 123`, `gh repo clone user/repo`.

### Prompt / shell UX

* **starship** — fast cross-shell prompt showing git branch, node/python/go version, k8s context, etc. per directory.
  - Config: `~/.config/starship.toml`.
* **atuin** — SQLite-backed shell history with fuzzy search, optional sync.
  - Rebinds `Ctrl-R` to its own UI (overrides fzf's Ctrl-R if both enabled — pick one or bind atuin elsewhere).
* **direnv** — auto-loads `.envrc` per project, unloads when you leave. Great for AWS profiles, node versions, API keys.
  - Usage: `echo 'export FOO=bar' > .envrc && direnv allow`.
* **zsh-autosuggestions** — greyed-out inline suggestion from history. `→` or `End` to accept.
* **zsh-syntax-highlighting** — colours commands as you type (red = invalid, green = valid).

### Terminal multiplexing

* **tmux** — keep sessions alive across terminal closes; split panes.
  - Default prefix: `Ctrl-b`. `prefix "` split horizontal, `prefix %` split vertical, `prefix d` detach, `tmux a` attach.
* **zellij** — modern tmux alternative with on-screen key hints.
  - Prefix: `Ctrl-p` (pane) / `Ctrl-t` (tab). Run `zellij` to start.

### Editor

* **neovim** (`nvim`) — already used for the nvim config in this repo.
* Set it as default editor in `.zshrc`: `export EDITOR='nvim'`.

### Data / JSON

* **fx** — interactive JSON explorer. Pipe any JSON in, navigate, search, transform with JavaScript.
  - Usage: `curl -s api.github.com/users/torvalds | fx`, `kubectl get pods -o json | fx`
  - Inside the UI:
    - `↑`/`↓` or `j`/`k` — move, `←`/`→` or `h`/`l` — collapse/expand
    - `e` / `E` — expand / collapse all
    - `/` — search (regex), `n`/`N` — next/prev match
    - `.` — open filter bar, type JS: `.items.map(x => x.metadata.name)`
    - `yp` — yank path to clipboard, `yv` — yank value, `y` — yank current
    - `?` — help, `q` — quit
  - Non-interactive (pipeline): `cat pkg.json | fx .dependencies | fx 'Object.keys(x)'`
  - Rule of thumb: **explore with fx, extract with jq** in scripts.

### Kubernetes / Helm

See [`kubernetes.md`](./kubernetes.md) for full keybindings and workflows.

* **kubectx** — switch kubeconfig contexts (clusters). Also ships `kubens`.
  - `kubectx` — interactive picker, `kubectx prod` — switch, `kubectx -` — previous
* **kubens** — switch the default namespace for the current context.
  - `kubens` — picker, `kubens kube-system` — switch, `kubens -` — previous
* **helmfile** — declarative layer on top of Helm; manage many releases in one `helmfile.yaml`.
  - `helmfile diff` — preview, `helmfile sync` — apply, `helmfile destroy` — tear down
  - Requires `helm-diff` plugin: `helm plugin install https://github.com/databus23/helm-diff`

### Docker / containers

* **lazydocker** — Docker TUI (same author as lazygit). Run `lazydocker` anywhere.
  - `Tab` / `[` `]` — switch panels, `?` — help
  - On a container: `d` stop, `r` restart, `s` start, `Enter` view logs, `E` exec shell
  - `x` — open menu for the current panel (bulk prune, remove stopped, etc.)
* **dive** — inspect Docker image layers to find bloat / leaks.
  - Usage: `dive my-image:latest`, or `dive build -t my-image .` to inspect during build
  - `Tab` — switch between layers pane and file tree
  - `Ctrl-Space` — collapse/expand all in file tree
  - `Ctrl-F` — filter files, `Ctrl-A` — toggle added, `Ctrl-M` — modified, `Ctrl-R` — removed
  - Bottom bar shows **efficiency score** and wasted space per layer.

## `.zshrc` snippets

Remove `z` from the oh-my-zsh `plugins=(...)` array (zoxide replaces it):

```zsh
plugins=(
    git
    # z  <-- using zoxide instead
    docker
    docker-compose
    kubectl
    npm
    pip
    brew
)
```

Aliases (add after oh-my-zsh is sourced):

```zsh
# Modern CLI replacements
alias ls='eza --git --icons'
alias ll='eza -l --git --icons'
alias la='eza -la --git --icons'
alias lt='eza --tree --level=2 --icons'
alias cat='bat -p'
alias lg='lazygit'
```

Integrations + plugins (keep at the **bottom** of `.zshrc`, in this order — syntax-highlighting must load last):

```zsh
# Shell integrations
eval "$(zoxide init zsh)"        # smarter cd: use `z <dir>` or `zi`
eval "$(direnv hook zsh)"        # auto-load .envrc per project
eval "$(starship init zsh)"      # fast prompt (overrides ZSH_THEME)
eval "$(atuin init zsh --disable-up-arrow)"  # shell history (rebinds Ctrl-R)

# fzf keybindings: Ctrl-T (files), Alt-C (cd), Ctrl-R (history, overridden by atuin)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# zsh plugins (keep at bottom — syntax-highlighting must load last)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
```

**Heads-up:** `atuin` and `fzf` both want `Ctrl-R`. With the order above, **atuin wins**.
If you prefer fzf's history picker, init atuin with `--disable-ctrl-r` instead:

```zsh
eval "$(atuin init zsh --disable-up-arrow --disable-ctrl-r)"
```

## git-delta config

Add to `~/.gitconfig`:

```ini
[core]
    pager = delta

[interactive]
    diffFilter = delta --color-only

[delta]
    navigate = true       # n / N to move between diff sections
    line-numbers = true
    side-by-side = true
    light = false         # set true if using a light terminal theme

[merge]
    conflictStyle = zdiff3
```

## Quick cheatsheet

| Task | Command |
|---|---|
| Jump to a frequent dir | `z <partial-name>` |
| Fuzzy-search history | `Ctrl-R` |
| Fuzzy-insert file path | `Ctrl-T` |
| Fuzzy `cd` | `Alt-C` |
| Search code in repo | `rg pattern` |
| Find file by name | `fd pattern` |
| Nice diff | `git diff` (with delta configured) |
| Git TUI | `lazygit` (alias `lg`) |
| View file with colour | `bat file` |
| Detached session | `tmux a` / `zellij attach` |
| Explore JSON interactively | `… \| fx` |
| Docker TUI | `lazydocker` |
| Inspect image layers/size | `dive <image>` |
| Switch k8s context / namespace | `kubectx` / `kubens` |
| Declarative Helm releases | `helmfile diff` / `helmfile sync` |
