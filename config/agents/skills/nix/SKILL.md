---
name: nix
description: |
  Nix commands and package management guide.
  Use when:
  - Running nix build, nix run
  - Adding custom packages
  - Using nurl for hash acquisition
---

<purpose>
Guide Nix commands, package management, and hash acquisition workflows.
</purpose>

<rules priority="critical">
  <rule>Always use `--no-link` option with `nix build` to prevent `./result` symlink creation</rule>
  <rule>See CONTRIBUTING.md section 1.4.2 for adding new custom packages</rule>
  <rule>Add `doCheck = false;` if tests fail during package build</rule>
</rules>

<patterns>
  <pattern name="nix-build">
    <description>Building Nix packages</description>
    <example>
nix build .#rumdl --no-link
    </example>
  </pattern>

  <pattern name="nix-run">
    <description>Running packages registered in packages</description>
    <example>
nix run .#pike -- scan -d ./terraform
    </example>
  </pattern>

  <pattern name="adding-custom-packages">
    <description>Hash acquisition flow for new custom packages</description>
    <steps>
      1. Get `hash` using nurl: `nurl https://github.com/&lt;owner&gt;/&lt;repo&gt; &lt;tag&gt;`
      2. Get `vendorHash`/`cargoHash` via build error (`got:` line)
    </steps>
  </pattern>

  <pattern name="nurl">
    <description>Generate Nix fetcher calls from repository URLs</description>
    <example>
nurl https://github.com/rvben/rumdl v0.0.206
    </example>
    <output_usage>
Output can be used directly in fetchFromGitHub:

```nix
fetchFromGitHub {
  owner = "rvben";
  repo = "rumdl";
  rev = "v0.0.206";
  hash = "sha256-XXX...";
}
```
    </output_usage>
    <note>For cargoHash/vendorHash, use build error method (nurl does not support these)</note>
  </pattern>
</patterns>

<constraints>
  <must>Use `--no-link` with all `nix build` commands</must>
  <avoid>Running `nix build` without `--no-link` (creates unwanted `./result` symlink)</avoid>
</constraints>
