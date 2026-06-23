#!/usr/bin/env python3
import json
import re
from collections import Counter
from pathlib import Path

INPUT_PATH = Path("/app/access.log")
OUTPUT_PATH = Path("/app/report.json")
REQUEST_RE = re.compile(r'"[A-Z]+\s+(\S+)\s+HTTP/\d+(?:\.\d+)?"')


def parse_access_log(path: Path) -> tuple[int, Counter[str], Counter[str]]:
    total_requests = 0
    requests_by_client: Counter[str] = Counter()
    requests_by_path: Counter[str] = Counter()

    with path.open("r", encoding="utf-8") as log_file:
        for line_number, raw_line in enumerate(log_file, start=1):
            line = raw_line.strip()
            if not line:
                continue

            fields = line.split()
            if not fields:
                raise ValueError(f"Missing client address on line {line_number}")

            request_match = REQUEST_RE.search(line)
            if request_match is None:
                raise ValueError(f"Malformed HTTP request on line {line_number}")

            total_requests += 1
            requests_by_client[fields[0]] += 1
            requests_by_path[request_match.group(1)] += 1

    if total_requests == 0:
        raise ValueError("The access log contains no request records")

    return total_requests, requests_by_client, requests_by_path


def main() -> None:
    total_requests, client_counts, path_counts = parse_access_log(INPUT_PATH)
    most_popular_path, most_popular_count = min(
        path_counts.items(),
        key=lambda item: (-item[1], item[0]),
    )

    report = {
        "total_requests": total_requests,
        "unique_client_count": len(client_counts),
        "requests_by_client": dict(sorted(client_counts.items())),
        "requests_by_path": dict(sorted(path_counts.items())),
        "most_popular_path": most_popular_path,
        "most_popular_path_requests": most_popular_count,
    }

    OUTPUT_PATH.write_text(
        json.dumps(report, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()
