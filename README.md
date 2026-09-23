# poc-cobol-app

Sample COBOL programs for the AI-SDLC POC. **This is a simulation — there is
no real mainframe access in this environment.**

## Contents
- `src/POLCALC.cbl` — computes policy payout from premium + risk %.
- `src/PREMVAL.cbl` — validates a premium is within an accepted band.
- `src/RPTGEN.cbl` — emits a simple text report line for a policy.
- `copybooks/POLICYREC.cpy` — shared policy record layout, `COPY`'d by all three programs.
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
./polcalc
./premval
./rptgen
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
