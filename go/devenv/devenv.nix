{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # ── Environment ────────────────────────────────────────────────────────────
  env.GOFLAGS = "-tags=dev";

  # ── Packages ───────────────────────────────────────────────────────────────
  packages = with pkgs; [
    # Build
    just
    air
    esbuild

    # Go tooling (the difference between amateur and master)
    gopls
    golangci-lint
    gotools # goimports, etc.
    go-tools # staticcheck
    delve # debugger
    templ
  ];

  # ── Languages ──────────────────────────────────────────────────────────────
  languages.go = {
    enable = true;
    package = pkgs.go;
  };

  # ── Processes ──────────────────────────────────────────────────────────────
  processes = {
    dev.exec = "just dev";
  };

  # ── Scripts ────────────────────────────────────────────────────────────────
  scripts = {
    templ-gen.exec = "${lib.getExe pkgs.templ} generate --watch";
  };

  # ── Shell ──────────────────────────────────────────────────────────────────
  enterShell = ''
    echo "  Precipice Development Environment"
    echo "  devenv up   - start all processes"
    echo "  just dev    - live reload (air)"
    echo "  just build  - production build"
  '';

  # ── Tests ──────────────────────────────────────────────────────────────────
  enterTest = ''
    echo "Running Precipice tests"
    go version | grep --color=auto "${pkgs.go.version}"
    golangci-lint --version
  '';
}
