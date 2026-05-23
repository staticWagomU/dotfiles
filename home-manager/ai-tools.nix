{
  pkgs,
  inputs,
  system,
  ...
}:
let
  nurPkgs = inputs.nur-packages.packages.${system};
  llmAgentsPkgs = inputs.llm-agents.packages.${system};

  opencode = import ./ai-tools/opencode {
    inherit pkgs nurPkgs llmAgentsPkgs;
    mcp-servers-nix = inputs.mcp-servers-nix;
  };
in
{
  imports = [
    # programs.serena オプションを定義するローカルモジュール
    ./ai-tools/serena
    # opencode 本体（programs.opencode は home-manager 標準モジュール）
    opencode
  ];
}
