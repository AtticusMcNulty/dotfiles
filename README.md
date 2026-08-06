# Usage

This repository manages my entire development environment. The same configuration can be applied to a brand new Mac or an existing one, and any future changes are made by editing this repository.

## Setting up a new or existing Mac

Clone the repository:

```sh
git clone https://github.com/AtticusMcNulty/dotfiles.git
cd dotfiles
```

Before applying anything:

- Verify the username in `flake.nix` (or let `bootstrap.sh` update it).
- Change the CPU architecture in `configuration.nix` if you're using an Intel Mac.
- Review the Homebrew packages if you already have software installed.

Run the bootstrap script:

```sh
./bootstrap.sh
```

The bootstrap script:

1. Installs Determinate Nix (if needed).
2. Creates the `~/.dotfiles` symlink.
3. Verifies the configured username.
4. Applies the complete configuration.

When it finishes, your machine is configured with the settings defined in this repository.

---

## Daily workflow

This repository becomes the source of truth for your development environment.

### Change a configuration file

Edit any file in this repository.

For example:

- `configuration.nix` – macOS settings and Homebrew packages
- `home.nix` – shell, packages, symlinks, and user configuration
- `home/.config/nvim/` – Neovim configuration
- `home/.config/wezterm/` – WezTerm configuration

### Apply system changes

If you changed any Nix configuration (packages, macOS settings, Homebrew, shell configuration, etc.), run:

```sh
./rebuild.sh
```

This rebuilds and reapplies the configuration.

### Editing symlinked configuration files

Many application configuration files are symlinked directly into your home directory.

For example:

- `home/.config/nvim`
- `home/.config/wezterm`
- `home/.claude`
- `home/.pi`

Editing these files immediately edits the live configuration because Home Manager links them instead of copying them.

Most changes to these files do **not** require running `./rebuild.sh`.

Restart or reload the application if needed (for example, restart WezTerm or reload Neovim).

---

## Validating changes

To verify the configuration builds without applying it:

```sh
nix flake check --no-build
nix build .#darwinConfigurations.mac.system --dry-run
```

---

## Updating dependencies

To update the pinned versions in `flake.lock`:

```sh
nix flake update
```

Then apply the updated configuration:

```sh
./rebuild.sh
```

---

## Development workflow

This is the workflow I use while developing.

### 1. Open the project

Launch WezTerm and change to the project directory.

```sh
cd ~/path/to/project
```

### 2. Start Herdr

Launch Herdr.

```sh
herdr
```

Herdr becomes the workspace manager for the session.

Useful shortcuts:

| Shortcut                                                              | Action             |
| --------------------------------------------------------------------- | ------------------ |
| <kbd>Ctrl+B</kbd> <kbd>H</kbd>/<kbd>J</kbd>/<kbd>K</kbd>/<kbd>L</kbd> | Move between panes |
| <kbd>Ctrl+B</kbd> <kbd>"</kbd>                                        | Split horizontally |
| <kbd>Ctrl+B</kbd> <kbd>%</kbd>                                        | Split vertically   |
| <kbd>Ctrl+B</kbd> <kbd>C</kbd>                                        | New tab            |
| <kbd>Ctrl+B</kbd> <kbd>&</kbd>                                        | Close tab          |
| <kbd>Ctrl+B</kbd> <kbd>W</kbd>                                        | Workspace picker   |
| <kbd>Ctrl+B</kbd> <kbd>G</kbd>                                        | Go to workspace    |
| <kbd>Ctrl+B</kbd> <kbd>Y</kbd>                                        | Enter copy mode    |

A typical layout might be:

- Pane 1: Neovim
- Pane 2: Build or test commands
- Pane 3: Git
- Pane 4: AI agent

---

### 3. Open Neovim

```sh
nvim .
```

Useful shortcuts:

| Shortcut          | Action                   |
| ----------------- | ------------------------ |
| <kbd>Esc</kbd>    | Save the current file    |
| <kbd>Ctrl+A</kbd> | Select the entire buffer |

---

### 4. Use AI agents

Launch the configured coding assistants from any terminal.

```sh
cc
```

Starts Claude Code.

```sh
co
```

Starts Codex.

If Pi is installed, it automatically uses the repository-managed themes, extensions, and settings.

---

### 5. Build and test

Run your project's normal commands from another Herdr pane while continuing to edit in Neovim.

Examples:

```sh
pytest
```

```sh
npm test
```

```sh
cargo test
```

```sh
go test ./...
```

---

### 6. Commit your work

Use Git directly:

```sh
git add .
git commit -m "Describe the change"
git push
```

or open LazyGit:

```sh
lazygit
```

---

## Updating this environment

When you want to change the environment itself:

- `configuration.nix` — macOS settings and Homebrew packages
- `home.nix` — shell, packages, prompts, and symlinks
- `home/.config/nvim` — Neovim
- `home/.config/wezterm` — WezTerm
- `home/.config/herdr` — Herdr
- `home/.pi` — Pi themes, extensions, and settings

If you change a Nix configuration file (`configuration.nix`, `home.nix`, `flake.nix`):

```sh
./rebuild.sh
```

If you change a symlinked application configuration (such as Neovim, WezTerm, or Herdr), the file is already live because Home Manager links directly to the copy in this repository. Simply restart or reload the application if needed.

I like this better because it reads like an actual workflow instead of a feature list: **open terminal → start workspace → edit → use AI → build/test → commit**. It also naturally introduces the shortcuts exactly where they're used.
