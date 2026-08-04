#!/usr/bin/env python3
"""Read-only smoke test for the global routing and validation control plane."""

from __future__ import annotations

import json
import pathlib
import re
import shutil
import sys
from typing import Any

try:
    import yaml
except ModuleNotFoundError as exc:
    print("FAIL | dependency | PyYAML is required to validate agent-routing-rules.yaml")
    raise SystemExit(2) from exc


CODEX_ROOT = pathlib.Path(__file__).resolve().parents[3]
RULES_PATH = CODEX_ROOT / "skills" / "using-superpowers" / "agent-routing-rules.yaml"
ROUTER_PATH = CODEX_ROOT / "agents" / "workflow-router.toml"
MAP_PATH = CODEX_ROOT / "global-agent-map" / "global-agent-skill-relationship-map.json"
SKILL_PATH = CODEX_ROOT / "skills" / "validation-standards" / "SKILL.md"

CHECKS: list[tuple[str, bool, str]] = []


def check(name: str, passed: bool, detail: str = "") -> None:
    CHECKS.append((name, bool(passed), detail))


def load_yaml() -> dict[str, Any]:
    try:
        value = yaml.safe_load(RULES_PATH.read_text(encoding="utf-8"))
        check("YAML parse", isinstance(value, dict))
        return value
    except Exception as exc:  # pragma: no cover - failure reporting path
        check("YAML parse", False, repr(exc))
        return {}


def load_json() -> dict[str, Any]:
    try:
        value = json.loads(MAP_PATH.read_text(encoding="utf-8"))
        check("JSON parse", isinstance(value, dict))
        return value
    except Exception as exc:  # pragma: no cover - failure reporting path
        check("JSON parse", False, repr(exc))
        return {}


def validate_toml() -> None:
    raw = ROUTER_PATH.read_text(encoding="utf-8")
    parser = None
    try:
        import tomllib as parser  # type: ignore[no-redef]
    except ModuleNotFoundError:
        try:
            import tomli as parser  # type: ignore[import-not-found,no-redef]
        except ModuleNotFoundError:
            parser = None

    if parser is not None:
        try:
            parser.loads(raw)
            check("TOML parse", True, f"parser={parser.__name__}")
        except Exception as exc:  # pragma: no cover - failure reporting path
            check("TOML parse", False, repr(exc))
    else:
        triple_quotes = raw.count('"""')
        structural = (
            triple_quotes == 2
            and 'name = "workflow-router"' in raw
            and "developer_instructions =" in raw
        )
        check(
            "TOML structural fallback",
            structural,
            "parser unavailable; full TOML parse not performed",
        )

    check("router normalization instruction", "high_risk > multi_stage > standard > basic" in raw)


def normalize_tier(rules: dict[str, Any], signals: set[str]) -> str | None:
    config = rules.get("validation_tier_normalization", {})
    for tier in config.get("precedence", []):
        tier_signals = set(config.get("overrides", {}).get(tier, {}).get("when_any", []))
        if signals & tier_signals:
            return tier
    return None


def validate_policy(rules: dict[str, Any]) -> None:
    policy = rules.get("validation_policy", {})
    tiers = policy.get("tiers", {})
    expected_tiers = {"basic", "standard", "multi_stage", "high_risk"}
    check("four validation tiers", set(tiers) == expected_tiers, str(set(tiers)))
    for tier in expected_tiers:
        check(f"{tier} required gates", bool(tiers.get(tier, {}).get("required_gates")))
        check(f"{tier} required artifacts", bool(tiers.get(tier, {}).get("required_artifacts")))

    normalization = rules.get("validation_tier_normalization", {})
    check("normalization runs after routing", normalization.get("apply_after_route_selection") is True)
    check(
        "normalization precedence",
        normalization.get("precedence") == ["high_risk", "multi_stage", "standard", "basic"],
        str(normalization.get("precedence")),
    )
    for tier in expected_tiers:
        override = normalization.get("overrides", {}).get(tier, {})
        check(f"{tier} normalization signals", bool(override.get("when_any")))
        check(f"{tier} gate source", override.get("required_gates_from") == f"validation_policy.tiers.{tier}.required_gates")
        check(f"{tier} artifact source", override.get("required_artifacts_from") == f"validation_policy.tiers.{tier}.required_artifacts")

    cases = [
        ({"documentation"}, "basic"),
        ({"single-module-feature", "behavior-change"}, "standard"),
        ({"api-change", "behavior-change"}, "multi_stage"),
        ({"authorization", "behavior-change"}, "high_risk"),
        ({"authorization", "api-change", "behavior-change"}, "high_risk"),
    ]
    for signals, expected in cases:
        actual = normalize_tier(rules, signals)
        check(f"tier simulation: {','.join(sorted(signals))}", actual == expected, f"expected={expected} actual={actual}")


def validate_stage_contracts(rules: dict[str, Any]) -> None:
    contracts = rules.get("stage_contracts", {})
    check("stage adapter", contracts.get("adapter") == "validation-standards")
    for stage in ("sdd", "ddd", "bdd"):
        contract = contracts.get(stage, {})
        check(f"{stage} contract exists", bool(contract))
        check(f"{stage} pass criteria", len(contract.get("pass_criteria", [])) >= 3)
        check(f"{stage} failure action", bool(contract.get("failure_action")))


def validate_supply_chain(rules: dict[str, Any]) -> None:
    supply = rules.get("supply_chain_policy", {})
    check("supply-chain decision", supply.get("decision") == "allow-core-only-with-standard-oss-notices")
    expected_controls = {
        "pin-version-or-commit",
        "no-latest",
        "preserve-license-and-notice-files",
        "review-transitive-dependencies-and-sbom",
        "disable-openspec-telemetry-before-use",
        "review-spec-kit-shell-workflows-before-execution",
        "run-skill-gatekeeper-before-third-party-skill-or-extension-intake",
    }
    actual_controls = set(supply.get("mandatory_controls", []))
    check("supply-chain controls", expected_controls <= actual_controls, str(sorted(expected_controls - actual_controls)))

    for command in ("specify", "openspec"):
        check(f"{command} not installed", shutil.which(command) is None)

    pattern = re.compile(r"^(openspec|spec-kit|cucumber|context-mapper|archunit)", re.IGNORECASE)
    candidate_dirs = [
        path.name
        for path in (CODEX_ROOT / "skills").iterdir()
        if path.is_dir() and pattern.match(path.name)
    ]
    check("no candidate OSS skills installed", not candidate_dirs, str(candidate_dirs))


def validate_route_graph(rules: dict[str, Any]) -> None:
    nodes = rules.get("workflow_nodes", [])
    routes = rules.get("route_rules", [])
    node_ids = [node.get("id") for node in nodes]
    route_ids = [route.get("id") for route in routes]
    check("workflow node IDs unique", len(node_ids) == len(set(node_ids)))
    check("route IDs unique", len(route_ids) == len(set(route_ids)))

    node_map = {node.get("id"): node for node in nodes}
    for node_id, node in node_map.items():
        allowed = node.get("allowed_agents", [])
        check(f"node {node_id} has owners", bool(allowed))
        check(f"node {node_id} owners unique", len(allowed) == len(set(allowed)))

    mismatches: list[str] = []
    for route in routes:
        route_id = route.get("id")
        selected = route.get("select", {})
        node_id = selected.get("workflow_node")
        check(f"route {route_id} node exists", node_id in node_map, str(node_id))
        if node_id not in node_map:
            continue
        allowed = set(node_map[node_id].get("allowed_agents", []))
        primary = selected.get("primary")
        support = selected.get("support", [])
        check(f"route {route_id} one primary", isinstance(primary, str) and bool(primary))
        check(f"route {route_id} support budget", isinstance(support, list) and len(support) <= 2)
        if primary not in allowed:
            mismatches.append(f"{route_id}: primary={primary} node={node_id}")
        for owner in support:
            if owner not in allowed:
                mismatches.append(f"{route_id}: support={owner} node={node_id}")

    check("route-to-node allowlist", not mismatches, "; ".join(mismatches))
    categories = rules.get("global_categories", {})
    categorized = any(
        "validation-standards" in values
        for values in categories.values()
        if isinstance(values, list)
    )
    check("validation adapter categorized", categorized)


def validate_map(manifest: dict[str, Any]) -> None:
    layers = manifest.get("routing_layers", {})
    for key in (
        "validation_policy",
        "validation_tier_normalization",
        "stage_contracts",
        "supply_chain_policy",
    ):
        check(f"map routing layer: {key}", bool(layers.get(key)))
    check(
        "map validation family",
        "validation-standards" in manifest.get("agent_families", {}).get("architect-deep", []),
    )


def validate_skill() -> None:
    text = SKILL_PATH.read_text(encoding="utf-8")
    for section in (
        "## SDD contract",
        "## DDD contract",
        "## BDD contract",
        "## Evidence and recovery",
        "## Risk-tier normalization",
        "## Supply-chain controls",
        "## Self-check",
    ):
        check(f"skill section: {section[3:]}", section in text)


def main() -> int:
    for path in (RULES_PATH, ROUTER_PATH, MAP_PATH, SKILL_PATH):
        check(f"file exists: {path.name}", path.is_file(), str(path))

    rules = load_yaml()
    manifest = load_json()
    validate_toml()
    validate_policy(rules)
    validate_stage_contracts(rules)
    validate_supply_chain(rules)
    validate_route_graph(rules)
    validate_map(manifest)
    validate_skill()

    failed = [entry for entry in CHECKS if not entry[1]]
    for name, passed, detail in CHECKS:
        suffix = f" | {detail}" if detail else ""
        print(f"{'PASS' if passed else 'FAIL'} | {name}{suffix}")
    print(f"SUMMARY | total={len(CHECKS)} passed={len(CHECKS) - len(failed)} failed={len(failed)}")
    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
