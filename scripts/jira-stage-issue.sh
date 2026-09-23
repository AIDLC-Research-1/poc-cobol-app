#!/usr/bin/env bash
# Opens the next Jira-pipeline stage issue and assigns it to Copilot's cloud
# coding agent. Called by jira-pipeline.yaml (first stage) and
# jira-stage-advance.yaml (subsequent stages) — not meant for interactive use.
#
# NOTE: this logic also exists in AIDLC-Research-1/.github-private as
# workflow_call reusable workflows, intended to be the single source of
# truth. Cross-repo resolution of those reusable workflows failed at
# runtime ("workflow was not found") despite correct repo/org Actions
# access settings — kept as a local copy here so the pipeline actually
# runs. Revisit de-duplication once the platform issue is understood.
set -euo pipefail

STAGE="${1:?usage: jira-stage-issue.sh <stage> <jira_key> <summary> <requirement_file> [<prior_pr_number>]}"
JIRA_KEY="${2:?missing jira key}"
SUMMARY="${3:?missing summary}"
REQUIREMENT_FILE="${4:?missing requirement file}"
PRIOR_PR="${5:-}"

REQUIREMENT="$(cat "$REQUIREMENT_FILE")"
PRIOR_REF=""
if [ -n "$PRIOR_PR" ]; then
  PRIOR_REF="Prior stage artefact: PR #${PRIOR_PR} (read it before acting)."
fi

case "$STAGE" in
  spec)
    TITLE="[${JIRA_KEY}] spec: ${SUMMARY}"
    BODY="Role: ba-spec. Turn this Jira requirement into a spec with
acceptance criteria under specs/${JIRA_KEY}.md only. Do not modify source,
tests, or docs/design.

Jira issue: ${JIRA_KEY}
Summary: ${SUMMARY}

${REQUIREMENT}"
    ;;
  impact)
    TITLE="[${JIRA_KEY}] impact analysis: ${SUMMARY}"
    BODY="Role: architect-impact. ${PRIOR_REF}
Read specs/${JIRA_KEY}.md (from the prior PR) and write an impact
analysis + design doc under docs/design/${JIRA_KEY}.md only. Do not modify
specs/, source, or tests."
    ;;
  dev)
    TITLE="[${JIRA_KEY}] implement: ${SUMMARY}"
    BODY="Role: developer. ${PRIOR_REF}
Implement docs/design/${JIRA_KEY}.md against specs/${JIRA_KEY}.md's
acceptance criteria. Read/write src/** only. This repo's build is
manual-gate (no GnuCOBOL in CI) — do not fabricate a build/run result;
state manual-gate explicitly in the PR description. Do not edit specs/ or
docs/design/ content, do not touch attestations/, do not modify CI/CD
workflows."
    ;;
  qa)
    TITLE="[${JIRA_KEY}] test coverage: ${SUMMARY}"
    BODY="Role: qa-test. ${PRIOR_REF}
There is no automated COBOL test framework in this repo. Derive a manual
test procedure (sample inputs/expected outputs) from specs/${JIRA_KEY}.md
and document it under specs/${JIRA_KEY}-test-plan.md only — do not modify
production source, and do not claim tests were executed if GnuCOBOL is
unavailable (manual-gate)."
    ;;
  security)
    TITLE="[${JIRA_KEY}] security review: ${SUMMARY}"
    BODY="Role: security-review. ${PRIOR_REF}
Scan the change introduced across the prior stage PRs for this Jira issue
and record findings under attestations/${JIRA_KEY}-security-review.md
only. Read-only otherwise — do not modify source, tests, specs, or
design docs. Do not approve or merge any PR."
    ;;
  *)
    echo "unknown stage: ${STAGE}" >&2
    exit 1
    ;;
esac

printf '%s' "$BODY" > /tmp/stage-issue-body.md

gh label create "jira:${JIRA_KEY}" --color "ededed" --force >/dev/null
gh label create "stage:${STAGE}" --color "1d76db" --force >/dev/null

gh issue create \
  --title "$TITLE" \
  --body-file /tmp/stage-issue-body.md \
  --label "jira:${JIRA_KEY}" \
  --label "stage:${STAGE}" \
  --assignee "@copilot"
