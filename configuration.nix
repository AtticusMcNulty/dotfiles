# -----------------------------------------------------------------------------
# Configures everything that applies to the entire Mac instead of a single
# user. This includes Nix settings, macOS system defaults, and the Homebrew
# packages installed on the machine.
#
# User-specific configuration such as the shell, editor, and dotfiles lives in
# home.nix.
# -----------------------------------------------------------------------------

{ user, ... }:

{
  # Prevents nix-darwin from managing the Nix daemon because Determinate Nix already does.
  nix.enable = false;

  # Allows packages with unfree licenses to be installed.
  nixpkgs.config.allowUnfree = true;

  # Sets the CPU architecture this configuration targets.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Configures the primary macOS user this system belongs to.
  system.primaryUser = user;

  users.users.${user} = {
    home = "/Users/${user}";
  };

  # Tracks the nix-darwin configuration version. Only change this when following the nix-darwin upgrade guide.
  system.stateVersion = 6;

  # Configures macOS system preferences.
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";

      # Makes held keys repeat more quickly.
      KeyRepeat = 2;

      # Shortens the delay before key repeat starts.
      InitialKeyRepeat = 15;

      # Automatically hides the menu bar.
      _HIHideMenuBar = true;

      # Always shows file extensions in Finder.
      AppleShowAllExtensions = true;
    };

    # Automatically hides the Dock.
    dock.autohide = true;

    # Opens Finder folders in list view by default.
    finder.FXPreferredViewStyle = "Nlsv";

    # Prevents files from being placed on the desktop.
    finder.CreateDesktop = false;

    # Enables tap-to-click on the trackpad.
    trackpad.Clicking = true;
  };

  # Lets nix-darwin manage the Homebrew installation.
  nix-homebrew = {
    enable = true;
    inherit user;
  };

  # Configures the Homebrew packages installed on this machine.
  homebrew = {
    enable = true;

    # Removes Homebrew packages that are no longer declared below.
    onActivation.cleanup = "zap";

    # Updates Homebrew before applying changes.
    onActivation.autoUpdate = true;

    # Forces the activation step to continue when needed.
    onActivation.extraFlags = [ "--force" ];

    # Command-line packages installed with Homebrew.
    brews = [
      "herdr"
    ];

    # GUI applications installed with Homebrew.
    casks = [
      "wezterm"
      "claude-code"
    ];
  };
}