# poc-cobol-app

Sample COBOL programs for the AI-SDLC POC. **This is a simulation — there is
no real mainframe access in this environment.**

## Contents
- `src/POLCALC.cbl` — computes policy payout from premium + risk %.
- `src/PREMVAL.cbl` — validates a premium is within an accepted band.
- `src/RPTGEN.cbl` — emits a simple text report line for a policy.
- `src/CLAIMCHK.cbl` — flags whether a claim amount exceeds the policy payout.
- `copybooks/POLICYREC.cpy` — shared policy record layout, `COPY`'d by all four programs.
- `jcl/POLCALCJ.jcl` — batch JCL stub showing intended job structure. **Not
  executable here** — no JES/mainframe emulator present; documented for
  format reference only.

## Build/run reality
- No real mainframe or z/OS emulator is available in this workspace.
- Attempted build: [GnuCOBOL](https://gnucobol.sourceforge.io/) (`cobc`) —
  **not installed** in this environment (`Get-Command cobc` found nothing).
- Build status: **`manual-gate`** — a maintainer with GnuCOBOL installed
  must run the commands below and record results; CI does not compile COBOL
  in this repo.

### If GnuCOBOL is available
```sh
cobc -x -o polcalc src/POLCALC.cbl
cobc -x -o premval src/PREMVAL.cbl
cobc -x -o rptgen  src/RPTGEN.cbl
cobc -x -o claimchk src/CLAIMCHK.cbl
./polcalc
./premval
./rptgen
./claimchk
```
(`-I copybooks` is not required here since programs use a plain `COPY`
statement resolved via `cobc`'s default copybook search path; pass
`-I copybooks` explicitly if `cobc` can't find `POLICYREC.cpy`.)

## Agent capability note
Expect Copilot coding agents to be able to read/reason about `.cbl` syntax
but to have materially weaker ability to compile, run, or verify COBOL
changes end-to-end compared to the Java repo, since there is no local
toolchain or CI step exercising the compiler. This gap is itself a recorded
finding of the POC (see `POC-RESULTS.md` at the workspace root).

## Copilot agents
- `.github/copilot-instructions.md` — stack conventions and agent boundaries.
- `.github/workflows/copilot-setup-steps.yml` — best-effort GnuCOBOL install
  for Copilot's cloud coding agent (falls back to manual-gate).
- Org-level agent personas (`ba-spec`, `architect-impact`, `developer`,
  `qa-test`, `security-review`, `release-readiness`) live in
  [AIDLC-Research-1/.github-private](https://github.com/AIDLC-Research-1/.github-private)
  and are visible org-wide in Copilot Chat.

## Jira-triggered pipeline
A Jira issue creation event (via Jira Automation → `repository_dispatch`)
kicks off a 5-stage chain, each stage a Copilot-assigned issue whose merged
PR (human-approved — branch protection requires 1 review) triggers the next:

```
spec -> impact -> dev -> qa -> security -> release-readiness (read-only verdict)
```

- `.github/workflows/jira-pipeline.yaml` — entry point (stage 1: spec).
- `.github/workflows/jira-stage-advance.yaml` — chains stages 2-5 on PR merge.
- `.github/workflows/jira-pr-label-sync.yaml` — copies `stage:*`/`jira:*`
  labels from a stage issue onto the PR Copilot opens for it.
- The stage logic itself is a **reusable workflow** hosted in
  `AIDLC-Research-1/.github-private` (shared with `poc-java-app`), called
  with `manual_gate: "true"` here so `dev`/`qa` stage prompts and the final
  verdict correctly state the build stays manual-gate.

No stage in this chain can merge or deploy on its own; every PR requires a
human approval.

