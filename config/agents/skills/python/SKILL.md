---
name: python
description: |
  Python environment and execution guide.
  Use when:
  - Running Python scripts
  - Working with uv, poetry, venv
---

<purpose>
Guide Python environment setup and script execution using uv, poetry, or venv.
</purpose>

<rules priority="critical">
  <rule>NEVER add shebang lines (`#!/usr/bin/env python3`)</rule>
  <rule>NEVER set execute permission on Python files</rule>
  <rule>Always execute with explicit `python` command</rule>
</rules>

<patterns>
  <pattern name="uv-lock-exists">
    <description>When uv.lock exists, use `uv` to execute Python commands</description>
    <example>
uv run dbt debug --profiles-dir ~/.dbt --no-use-colors
    </example>
  </pattern>

  <pattern name="poetry-lock-exists">
    <description>When poetry.lock exists, create virtual environment with `uv`</description>
    <reference>https://i9wa4.github.io/blog/2025-06-08-create-uv-venv-with-poetry-pyproject-toml.html</reference>
  </pattern>

  <pattern name="no-uv-lock">
    <description>When uv.lock does not exist, activate venv manually</description>
    <steps>
      1. Activate the virtual environment: `source .venv/bin/activate`
      2. Execute Python commands: `dbt debug --profiles-dir ~/.dbt --no-use-colors`
    </steps>
  </pattern>
</patterns>

<constraints>
  <must>Use explicit `python` command for execution</must>
  <avoid>Adding shebang lines to Python files</avoid>
  <avoid>Setting execute permissions on Python files</avoid>
</constraints>
