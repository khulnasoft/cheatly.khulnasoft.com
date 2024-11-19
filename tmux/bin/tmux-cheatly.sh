#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if test -f "$CURRENT_DIR/cheatly.khulnasoft.com"; then
  CHEATLY="$CURRENT_DIR/cheatly.khulnasoft.com"
else
  curl -Ss https://cheatly.khulnasoft.com/:cheatly.khulnasoft.com > "$CURRENT_DIR/cheatly.khulnasoft.com"
  chmod +x "$CURRENT_DIR/cheatly.khulnasoft.com"
  CHEATLY="$CURRENT_DIR/cheatly.khulnasoft.com"
fi

if test -f "$CURRENT_DIR/list"; then
  LIST="$CURRENT_DIR/list"
else
  curl -Ss https://cheatly.khulnasoft.com/:list > "$CURRENT_DIR/list"
  LIST="$CURRENT_DIR/list"
fi

ITEM="$(cat $LIST | fzf --preview="bash $CHEATLY {}" )"

if [ "$ITEM" == "" ]; then
  exit 0
fi

read -e -p "Query for $ITEM: " QUERY

QUERY="$(printf $QUERY | sed 's/\ /+/g')"

bash $CHEATLY $ITEM $QUERY | $PAGER