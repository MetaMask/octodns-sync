#!/bin/bash
# Add pull request comment

# Requires these, provided in action.yml:
# - ADD_PR_COMMENT (skip unless "Yes")
# - PR_COMMENT_TOKEN (fail if empty)
# - COMMENTS_URL (skip if empty)
# - Current working directory is in the config repo

_planfile="${GITHUB_WORKSPACE}/octodns-sync.plan"

if [ "${ADD_PR_COMMENT}" = "Yes" ]; then
  if [ -z "${PR_COMMENT_TOKEN}" ]; then
    echo "FAIL: \$PR_COMMENT_TOKEN is not set."
    exit 1
  fi
  echo "INFO: \$ADD_PR_COMMENT is 'Yes' and \$PR_COMMENT_TOKEN is set."
else
  echo "SKIP: \$ADD_PR_COMMENT is not 'Yes'."
  exit 0
fi

if [ -z "${COMMENTS_URL}" ]; then
  echo "SKIP: \$COMMENTS_URL is not set."
  echo "Was this workflow run triggered from a pull request?"
  exit 0
fi

# Construct the comment body
_sha="$(git log -1 --format='%h')"
_header="## octoDNS Plan for ${_sha}"
_footer="Automatically generated by octodns-sync"
_body="${_header}

$(cat "${_planfile}")

${_footer}"
  # Post the comment
  # TODO: Rewrite post to use gh rather than python3
  _url="${COMMENTS_URL}" \
  _user="octodns-sync" \
  _token="${PR_COMMENT_TOKEN}" \
  _body="${_body}" \
  python3 scripts/make-request.py
