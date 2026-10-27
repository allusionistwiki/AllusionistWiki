#!/bin/bash
TOK=$(grep '^password=' "$HOME/AppData/Local/hermes/profiles/awiki2/cache/scratch/cred.txt" | head -1 | sed 's/^password=//' | tr -d '\r\n')
V1SHA=9aa2ebdddd18fc7d28845d289b7266ed703265aa
for i in $(seq 1 45); do
  s1=$(curl -sL -H "Authorization: Bearer $TOK" "https://api.github.com/repos/allusionistwiki/AllusionistWiki/commits/$V1SHA/check-runs?per_page=100" | grep -E '"(status|conclusion)"' | sort | uniq -c)
  if ! echo "$s1" | grep -q '"status": "queued"\|"status": "in_progress"\|"status": "waiting"'; then
    echo "V1 CI COMPLETED"; echo "$s1"
    break
  fi
  sleep 60
done
echo "=== polling live site ==="
for j in $(seq 1 30); do
  curl -sL "https://allusionistwiki.github.io/AllusionistWiki/static/contentIndex.json?cb=$RANDOM" -o ci_new.json 2>/dev/null
  if grep -q "episodes/index" ci_new.json 2>/dev/null; then
    n=$(python -c "import json;d=json.load(open('ci_new.json',encoding='utf-8'));print(len(d),len([k for k in d if k=='l1' or k.startswith('l1/')]))" 2>/dev/null)
    echo "contentIndex total/l1: $n"
    if [ -n "$n" ] && echo "$n" | grep -q " 0$"; then echo "L1 EXCLUDED FROM INDEX"; break; fi
  fi
  sleep 60
done
echo "DONE CHECK"
