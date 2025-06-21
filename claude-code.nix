{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_20,
}:

buildNpmPackage rec {
  pname = "claude-code";
  version = "latest"; # バージョンを固定したい場合は具体的なバージョン番号に変更

  # npmレジストリから直接取得する場合
  src = builtins.fetchTarball {
    url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
    # sha256は初回実行時にエラーメッセージから取得
    # sha256 = "...";
  };

  nodejs = nodejs_20;

  # npmDepsHashは初回実行時にエラーメッセージから取得
  # npmDepsHash = "...";

  meta = with lib; {
    description = "Claude Code - AI-powered command line tool";
    homepage = "https://docs.anthropic.com/en/docs/claude-code/overview";
    license = licenses.mit;
    maintainers = [ ];
  };
}
