# Verification Evidence

These results were produced by executing the exact fixed `solution/solve.sh`, `tests/test_output.py`, and `tests/test.sh` locally with the Harbor paths `/app`, `/tests`, and `/logs/verifier`.

Native Harbor and Docker were not installed in the evidence environment, so these are equivalent local verifier runs rather than fabricated `harbor run` logs.

## Oracle case

`reward.txt`:

```text
1
```

`ctrf.json` summary:

```json
{
  "tests": 7,
  "passed": 7,
  "failed": 0,
  "pending": 0,
  "skipped": 0,
  "other": 0
}
```

## NOP case

`reward.txt`:

```text
0
```

`ctrf.json` summary:

```json
{
  "tests": 7,
  "passed": 0,
  "failed": 7,
  "pending": 0,
  "skipped": 0,
  "other": 0
}
```

## Intentionally bugged solution

The bugged entrypoint wrote `total_requests` as `5` instead of `6`:

```sh
#!/bin/sh
set -eu

cat > /app/report.json <<'JSON'
{
  "total_requests": 5,
  "unique_client_count": 3,
  "requests_by_client": {
    "10.0.0.5": 2,
    "192.168.0.1": 2,
    "192.168.0.2": 2
  },
  "requests_by_path": {
    "/about.html": 2,
    "/api/login": 1,
    "/index.html": 3
  },
  "most_popular_path": "/index.html",
  "most_popular_path_requests": 3
}
JSON
```

Bugged `reward.txt`:

```text
0
```

Bugged `ctrf.json` summary:

```json
{
  "tests": 7,
  "passed": 6,
  "failed": 1,
  "pending": 0,
  "skipped": 0,
  "other": 0
}
```

Failure excerpt:

```text
FAILED tests/test_output.py::test_total_requests - assert 5 == 6
========================= 1 failed, 6 passed =========================
```
