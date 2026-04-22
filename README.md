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
