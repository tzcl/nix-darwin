{ ... }: {
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    global.brewfile = true;

    taps = [
      "ejoffe/tap"
      "derailed/k9s"
      "hashicorp/tap"
      "argoproj/tap"
      "withgraphite/tap"
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
      "kubectl"
      "minikube"
      "derailed/k9s/k9s"
      "argoproj/tap/kubectl-argo-rollouts"

      # Personal
      "webp"
    ];
    casks =
      [ "docker" "github" "google-chrome" "logseq" "visual-studio-code" "zed" ];
    masApps = {
      "Bitwarden" = 1352778147;
      "WireGuard" = 1451685025;
      "Todoist" = 585829637;
    };
  };
}
