#!/bin/bash
TOK=$(grep "^password=" "$HOME/AppData/Local/hermes/profiles/awiki2/cache/scratch/cred.txt" | head -1 | sed "s/^password=//" | tr -d "\r\n")
NEW=""
for k in 1 2 3 4 5; do
  NEW=$(curl -sL -H "Authorization: Bearer $TOK" "https://api.github.com/repos/allusionistwiki/AllusionistWiki/actions/workflows/deploy.yml/runs?per_page=2" | grep -o '"id": [0-9]*' | head -1 | cut -d' ' -f2)
  [ -n "$NEW" ] && [ "$NEW" != "39825108893" ] && break
  sleep 20
done
echo "WATCHING NEW RUN $NEW"
for i in $(seq 1 45); do
  s=$(curl -sL -H "Authorization: Bearer $TOK" "https://api.github.com/repos/allusionistwiki/AllusionistWiki/actions/runs/$NEW")
  conc=$(echo "$s" | grep -o '"conclusion": "[a-z_]*"' | head -1)
  st=$(echo "$s" | grep -o '"status": "[a-z_]*"' | head -1)
  echo "T$i: $st $conc"
  if echo "$conc" | grep -qE 'success|failure'; then
    echo "DEPLOY RUN $NEW FINAL: $conc"
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
