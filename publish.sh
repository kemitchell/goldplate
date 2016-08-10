#!/bin/bash
set -e
PUBLISHER=goldplate
read -p "Edition: " EDITION
read -s -p "Password: " PASSWORD
FORMS="https://api.commonform.org/forms"
for cform in sections/*.cform; do
  BASE=$(basename "$cform" ".cform")
  if [ "$BASE" = "amendments" ]; then
    continue
  fi
  DIGEST=$(commonform hash < "$cform")
  commonform render -f native < "$cform" | curl -X POST --user "$PUBLISHER:$PASSWORD" --data @- "$FORMS"
  echo "Shared $DIGEST"
  PUBLICATION="https://api.commonform.org/publishers/$PUBLISHER/projects/$BASE/publications/$EDITION"
  curl -v -X POST --user "$PUBLISHER:$PASSWORD" -H 'Content-Type: application/json' --data "{\"digest\":\"$DIGEST\"}" "$PUBLICATION"
  echo "Published goldplate $BASE $EDITION"
done
