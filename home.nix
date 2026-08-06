# -----------------------------------------------------------------------------
# Configures everything that belongs to my user account through Home Manager.
# This includes the command-line tools I install, shell configuration, prompt,
# environment variables, and symlinks that connect the files in this repository
# to their live locations under ~/.config and other application directories.
#
# This is the user-level configuration. System-wide macOS settings and
# Homebrew packages live in configuration.nix instead.
# -----------------------------------------------------------------------------

# Function argument header for this file.
{ config, pkgs, user, ... }:

let
  # Define the absolute path to the dotfiles repository as a temporary variable to use in the code block below.
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in
{
  # Stores the Home Manager settings for this user account.
  # Home Manager provides a basic system for managing a user environment.
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";

  # Installs user-level packages through Nix.
  home.packages = with pkgs; [
    # Command-line tools I use regularly.
    ripgrep   # Fast recursive search.
    fd        # Faster, simpler alternative to find.
    fzf       # Interactive fuzzy finder.
    jq        # Process and query JSON.
    lazygit   # Terminal UI for streamlined Git workflows
    neovim    # Extensible, keyboard-driven code editor.

    # Makes the Hack Nerd Font available to applications.
    nerd-fonts.hack
  ];

  # Enables Fontconfig so applications can find installed fonts.
  fonts.fontconfig.enable = true;

  # Makes Neovim the default editor for tools that use $EDITOR.
  home.sessionVariables.EDITOR = "nvim";

  programs.zsh = {
    # Configures the Zsh shell.
    enable = true;

    # Suggests commands from shell history as you type.
    autosuggestion.enable = true;

    # Highlights commands as they're typed to help spot mistakes.
    syntaxHighlighting.enable = true;

    # Runs additional Zsh configuration after startup.
    initContent = ''
      # Press Ctrl+F to accept the current autosuggestion.
      bindkey '^f' autosuggest-accept
    '';

    # Defines shortcuts for frequently used commands.
    shellAliases = {
      ".." = "cd ..";

      # Shortcuts for using git.
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";

      # Shortcuts for launching AI coding assistants.
      cc = "claude --dangerously-skip-permissions";
      co = "codex --full-auto";
    };
  };

  programs.starship = {
    # Configures the shell prompt.
    enable = true;

    settings = {
      # Keeps the prompt on a single line until a command is run.
      add_newline = false;

      # Shows only the prompt sections I want.
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";

      # Changes the prompt symbol based on whether the previous command succeeded.
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };

      # Shows how long commands took to run.
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  # Creates symlinks from ~/.config directly to this Git repository.
  # Edits made here take effect in those files instantly without 
  # requiring a rebuild.

  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";

  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";

  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";

  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

  # Links mutable Pi agent data (themes, extensions, settings) for live updates.

  home.file.".pi/agent/themes".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/themes";

  home.file.".pi/agent/extensions".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/extensions";

  home.file.".pi/agent/models.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/models.json";

  home.file.".pi/agent/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/settings.json";

  # Unifies instructions for Claude, Codex, and Opencode by pointing them 
  # to the same AGENTS.md file.

  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";

  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";

  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}