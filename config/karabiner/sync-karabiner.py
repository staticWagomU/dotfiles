#!/usr/bin/env python3

import json
import sys
from pathlib import Path


CAPS_RULE = {
    "description": "Change caps_lock to hyper, escape if alone",
    "manipulators": [
        {
            "from": {
                "key_code": "caps_lock",
                "modifiers": {
                    "optional": ["any"],
                },
            },
            "to": [
                {
                    "key_code": "left_shift",
                    "modifiers": [
                        "left_command",
                        "left_control",
                        "left_option",
                    ],
                }
            ],
            "to_if_alone": [
                {
                    "key_code": "escape",
                }
            ],
            "type": "basic",
        }
    ],
}

RAYCAST_RULE = {
    "description": "Hyper+Up to cycle window size using Raycast",
    "manipulators": [
        {
            "type": "basic",
            "from": {
                "key_code": "up_arrow",
                "modifiers": {
                    "mandatory": [
                        "left_command",
                        "left_control",
                        "left_option",
                        "left_shift",
                    ],
                    "optional": ["caps_lock"],
                },
            },
            "conditions": [
                {
                    "name": "var_window_cycle",
                    "type": "variable_if",
                    "value": 1,
                }
            ],
            "to": [
                {
                    "shell_command": (
                        "open -g "
                        "raycast://extensions/raycast/window-management/"
                        "reasonable-size"
                    ),
                }
            ],
            "to_after_key_up": [
                {
                    "set_variable": {
                        "name": "var_window_cycle",
                        "value": 2,
                    }
                }
            ],
        },
        {
            "type": "basic",
            "from": {
                "key_code": "up_arrow",
                "modifiers": {
                    "mandatory": [
                        "left_command",
                        "left_control",
                        "left_option",
                        "left_shift",
                    ],
                    "optional": ["caps_lock"],
                },
            },
            "conditions": [
                {
                    "name": "var_window_cycle",
                    "type": "variable_if",
                    "value": 2,
                }
            ],
            "to": [
                {
                    "shell_command": (
                        "open -g "
                        "raycast://extensions/raycast/window-management/"
                        "almost-maximize"
                    ),
                }
            ],
            "to_after_key_up": [
                {
                    "set_variable": {
                        "name": "var_window_cycle",
                        "value": 0,
                    }
                }
            ],
        },
        {
            "type": "basic",
            "from": {
                "key_code": "up_arrow",
                "modifiers": {
                    "mandatory": [
                        "left_command",
                        "left_control",
                        "left_option",
                        "left_shift",
                    ],
                    "optional": ["caps_lock"],
                },
            },
            "to": [
                {
                    "shell_command": (
                        "open -g "
                        "raycast://extensions/raycast/window-management/"
                        "maximize"
                    ),
                }
            ],
            "to_after_key_up": [
                {
                    "set_variable": {
                        "name": "var_window_cycle",
                        "value": 1,
                    }
                }
            ],
        },
    ],
}

RULES = [CAPS_RULE, RAYCAST_RULE]
MANAGED_DESCRIPTIONS = {
    "Change caps_lock to command+control+option+shift.",
    CAPS_RULE["description"],
    RAYCAST_RULE["description"],
}


def select_profile(config):
    profiles = config.get("profiles") or []
    if not profiles:
        raise RuntimeError("No Karabiner profiles found.")

    for profile in profiles:
        if profile.get("selected"):
            return profile

    return profiles[0]


def sync_rules(rules):
    preserved = [rule for rule in rules if not is_managed_rule(rule)]
    return preserved + RULES


def is_managed_rule(rule):
    if rule.get("description") in MANAGED_DESCRIPTIONS:
        return True

    for manipulator in rule.get("manipulators", []):
        if manipulator.get("description") in MANAGED_DESCRIPTIONS:
            return True

    return False


def main():
    if len(sys.argv) != 2:
        raise SystemExit("usage: sync-karabiner.py <karabiner.json>")

    path = Path(sys.argv[1]).expanduser()
    config = json.loads(path.read_text())

    profile = select_profile(config)
    complex_modifications = profile.setdefault("complex_modifications", {})
    current_rules = complex_modifications.get("rules") or []
    complex_modifications["rules"] = sync_rules(current_rules)

    path.write_text(json.dumps(config, indent=2, ensure_ascii=True) + "\n")
    print(f"Updated Karabiner profile: {profile.get('name', '<unnamed>')}")


if __name__ == "__main__":
    main()
