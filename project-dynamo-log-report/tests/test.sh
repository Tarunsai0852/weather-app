#!/bin/sh
set +e

mkdir -p /logs/verifier
pytest /tests/test_output.py -rA --junitxml=/logs/verifier/junit.xml
pytest_status=$?

if [ "$pytest_status" -eq 0 ]; then
    reward=1
else
    reward=0
fi

printf '%s\n' "$reward" > /logs/verifier/reward.txt

python3 - <<'PY'
import json
import xml.etree.ElementTree as ET
from pathlib import Path

junit_path = Path("/logs/verifier/junit.xml")
tests = []

if junit_path.exists():
    root = ET.parse(junit_path).getroot()
    suites = [root] if root.tag == "testsuite" else list(root.findall("testsuite"))

    for suite in suites:
        for case in suite.findall("testcase"):
            status = "passed"
            message = ""
            failure = case.find("failure")
            error = case.find("error")
            skipped = case.find("skipped")

            if failure is not None:
                status = "failed"
                message = failure.get("message", "") or failure.text or ""
            elif error is not None:
                status = "failed"
                message = error.get("message", "") or error.text or ""
            elif skipped is not None:
                status = "skipped"
                message = skipped.get("message", "") or skipped.text or ""

            tests.append({
                "name": case.get("name", ""),
                "suite": case.get("classname", ""),
                "status": status,
                "duration": float(case.get("time", "0") or 0),
                "message": message,
            })

passed = sum(test["status"] == "passed" for test in tests)
failed = sum(test["status"] == "failed" for test in tests)
skipped = sum(test["status"] == "skipped" for test in tests)

ctrf = {
    "results": {
        "tool": {"name": "pytest"},
        "summary": {
            "tests": len(tests),
            "passed": passed,
            "failed": failed,
            "pending": 0,
            "skipped": skipped,
            "other": 0,
        },
        "tests": tests,
    }
}

Path("/logs/verifier/ctrf.json").write_text(
    json.dumps(ctrf, indent=2) + "\n",
    encoding="utf-8",
)
PY

exit 0
