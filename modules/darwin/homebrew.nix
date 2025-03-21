{ ... }: {
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    global.brewfile = true;

    taps = [
      "ejoffe/tap"
      "hashicorp/tap"
      "argoproj/tap"
      "withgraphite/tap"
      "railwaycat/emacsmacport"
    ];
    brews = [
      "ejoffe/tap/spr"
      "withgraphite/tap/graphite"

      # Work
      ## Utilities
      "aws-vault"
      "lazydocker"
      "hashicorp/tap/terraform"
      "grpcurl"
      "bazelisk"
      "earthly"

      ## Kubernetes
      "argoproj/tap/kubectl-argo-rollouts"

      # Personal
      "webp"
      "flyctl"
    ];
    casks = [
      "docker"
      "github"
      "google-chrome"
      "keepassxc"
      "obsidian"
      "visual-studio-code"
      "zed"
    ];
    masApps = {
      "Bitwarden" = 1352778147;
      "WireGuard" = 1451685025;
      "Todoist" = 585829637;
    };
  };
}
