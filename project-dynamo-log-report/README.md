# Project Dynamo: Access Log Report

This folder contains the complete corrected Harbor task.

Run:

```bash
harbor run -p . -a oracle
harbor run -p . --agent nop
```

Expected rewards:

- Oracle: `1`
- NOP: `0`

The environment image contains only the pinned Python runtime and `/app/access.log`. It does not contain the solution or verifier.

`evidence/README.md` contains the verifier results from equivalent local execution of the exact oracle, NOP, and intentionally bugged cases. Native Harbor was unavailable in the execution environment used to prepare the evidence, so the Harbor commands must still be run before final submission.
