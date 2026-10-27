#!/bin/bash
TOK=$(grep '^password=' "$HOME/AppData/Local/hermes/profiles/awiki2/cache/scratch/cred.txt" | head -1 | sed 's/^password=//' | tr -d '\r\n')
for i in $(seq 1 30); do
  s=$(curl -sL -H "Authorization: Bearer $TOK" "https://api.github.com/repos/allusionistwiki/AllusionistWiki/actions/runs/39825108893" | grep -E '"(status|conclusion)"' | head -2)
  if echo "$s" | grep -q '"conclusion"'; then
    echo "DEPLOY RUN FINAL: $s"
    break
  fi
  sleep 60
done
echo "=== verify live contentIndex ==="
for j in $(seq 1 20); do
  CB=$RANDOM
  curl -sL "https://allusionistwiki.github.io/AllusionistWiki/static/contentIndex.json?cb=$CB" -o ci_v.json 2>/dev/null
  n=$(python -c "import json;d=json.load(open('ci_v.json',encoding='utf-8'));print(len(d),len([k for k in d if k=='l1' or k.startswith('l1/')]))" 2>/dev/null)
  echo "index total/l1: $n"
  if [ -n "$n" ] && echo "$n" | grep -q " 0$"; then echo "L1 EXCLUDED FROM INDEX"; break; fi
  sleep 60
done
echo "FINAL CHECK DONE"
