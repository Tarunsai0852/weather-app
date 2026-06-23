Read the Apache-style access log at `/app/access.log` and create `/app/report.json`.

Count each nonempty line in the input as one request. The client address is the first whitespace-separated field of each record. The request path is the second whitespace-separated value inside the quoted HTTP request, regardless of the HTTP method.

The task is successful only when all of the following criteria are satisfied:

1. `/app/report.json` exists and is a valid UTF-8 JSON object containing exactly these keys: `total_requests`, `unique_client_count`, `requests_by_client`, `requests_by_path`, `most_popular_path`, and `most_popular_path_requests`.

2. `total_requests` is a JSON integer equal to the number of nonempty records in `/app/access.log`.

3. `unique_client_count` is a JSON integer equal to the number of distinct client addresses in the first field of the records.

4. `requests_by_client` is a JSON object containing every client address, no additional addresses, and the correct JSON-integer request count for each client.

5. `requests_by_path` is a JSON object containing every HTTP request path, no additional paths, and the correct JSON-integer request count for each path.

6. `most_popular_path` is a JSON string containing the path with the highest request count.

7. `most_popular_path_requests` is a JSON integer equal to the request count of `most_popular_path`.

No other output files are required.

You have 120 seconds to complete this task. Do not cheat by using online solutions or hints specific to this task.
