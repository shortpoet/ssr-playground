#!/usr/bin/env bash

org='shortpoet'
repo='tf-web'

# Get workflow IDs with status "disabled_manually"
mapfile -t workflow_ids < <(gh api repos/$org/$repo/actions/workflows --jq '.workflows[] | select(.["state"] | contains("disabled_manually")) | .id')

for workflow_id in "${workflow_ids[@]}"
do
  echo "Listing runs for the workflow ID $workflow_id"
  mapfile -t run_ids < <(gh api "repos/$org/$repo/actions/workflows/$workflow_id/runs" --paginate --jq '.workflow_runs[].id')
  for run_id in "${run_ids[@]}"
  do
    echo "Deleting Run ID $run_id"
    gh api "repos/$org/$repo/actions/runs/$run_id" -X DELETE >/dev/null
  done
done
