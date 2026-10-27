#!/bin/bash
TOK=$(grep '^password=' "$HOME/AppData/Local/hermes/profiles/awiki2/cache/scratch/cred.txt" | head -1 | sed 's/^password=//' | tr -d '\r\n')
V2SHA=cde0552d1d803fe398ddd6a39eddd5283f767330
echo "V2 cde0552 status:"
curl -sL -H "Authorization: Bearer $TOK" "https://api.github.com/repos/allusionistwiki/AllusionistWiki2/commits/$V2SHA/check-runs?per_page=100" | grep -E '"(name|status|conclusion)"' | head -20
echo "V2 latest runs:"
curl -sL -H "Authorization: Bearer $TOK" "https://api.github.com/repos/allusionistwiki/AllusionistWiki2/actions/runs?per_page=3" | grep -E '"(head_sha|status|conclusion)"' | head -9
echo "=== live CSS/INDEX poll (v1 + v2) ==="
d1=""; d2=""
for i in $(seq 1 40); do
  c1=$(curl -sL "https://allusionistwiki.github.io/AllusionistWiki/index.css?cb=$RANDOM")
  c2=$(curl -sL "https://allusionistwiki.github.io/AllusionistWiki2/index.css?cb=$RANDOM")
  if echo "$c1" | grep -q "overflow: clip"; then d1=1; fi
  if echo "$c2" | grep -q "overflow: clip"; then d2=1; fi
  [ -n "$d1" ] && [ -n "$d2" ] && { echo "BOTH CSS UPDATED"; break; }
  sleep 60
done
echo "CSS POLL DONE v1=$d1 v2=$d2"
echo "live v1 contentIndex l1:"
curl -sL "https://allusionistwiki.github.io/AllusionistWiki/static/contentIndex.json?cb=$RANDOM" -o ci5.json && python -c "import json;d=json.load(open('ci5.json',encoding='utf-8'));print(len(d),len([k for k in d if k=='l1' or k.startswith('l1/')]))"
echo "ALLCHECKS DONE"
