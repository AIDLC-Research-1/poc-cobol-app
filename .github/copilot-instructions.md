# Copilot instructions — poc-cobol-app

Stack: COBOL (GnuCOBOL dialect assumed), simulated batch/JCL. No real
mainframe in this environment.

## Conventions
- Programs live in `src/*.cbl`, one `PROGRAM-ID` per file, uppercase names.
- Shared data layouts go in `copybooks/*.cpy` and are pulled in via `COPY`.
- JCL stubs in `jcl/*.jcl` are documentation only — not executable here.

## Build / test
- Build: `manual-gate` — GnuCOBOL (`cobc`) is not installed in CI or this
  workspace. A human must compile/run locally and record results in the
  README or an issue comment.
- No automated tests exist; there is no COBOL test framework wired up.

## Agent boundaries
- Agents must NOT invent a working CI/CD pipeline that claims to compile or
  run COBOL — if `cobc` is unavailable, state `manual-gate` explicitly.
- Agents must NOT modify `jcl/**` to claim it is runnable in this environment.
- Agents must NOT merge PRs or trigger any deployment.

## Jira-triggered pipeline
A Jira issue creation dispatches `jira-pipeline.yaml`, which opens a
`stage:spec` issue assigned to Copilot. Each stage's merged PR
(`jira-stage-advance.yaml`) opens the next stage issue automatically:
spec -> impact -> dev -> qa -> security -> read-only release-readiness
verdict (build stays `manual-gate` throughout). Do not remove
`stage:*`/`jira:*` labels from issues/PRs — the chain relies on them. See
`scripts/jira-stage-issue.sh`.
