#!/usr/bin/env python3
"""gen_l1_redirects.py — 旧 /AllusionistWiki/l1/* URL を新 Wiki2 サイトへ転送するページを生成する。

argv1 = L1 内容ルート（v2 vault の `<clone>/wiki/l1`。vault ルートを渡すと prefix 二重化）。
argv2 = 出力先（既定 public/l1）。出力は `public/l1/<rel>.html` の meta refresh 実体で、
git 追跡により全デプロイで旧 URL を保持する（l1-redirect-stubs.yml が定期再生成・コミット）。
"""
import sys
from pathlib import Path

VAULT = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("/tmp/l1/wiki/l1")
OUT = Path(sys.argv[2]) if len(sys.argv) > 2 else Path("public/l1")
BASE = "https://allusionistwiki.github.io/AllusionistWiki2/L1/"

def slugify(s: str):
    s = s.replace("&", "and")
    import re
    s = re.sub(r"\s+", "-", s)
    return s

def page(target: str) -> str:
    return ('<!DOCTYPE html><meta http-equiv="Content-Type" content="text/html; charset=utf-8">\n'
            f'<meta http-equiv="refresh" content="0; url={target}">\n'
            "<title>移設済み</title>\n"
            f'<p>このページは <a href="{target}">アリュージョニスト Wiki 2</a> へ移設しました。</p>\n')

def main():
    pages = [p for p in VAULT.rglob("*.md")]
    n = 0
    for p in pages:
        rel = p.relative_to(VAULT)                      # e.g. claims/A_x.md
        target_rel = str(rel).replace("\\", "/")[:-3]   # claims/A_x
        if target_rel.endswith("/index"):
            target = BASE + slugify(target_rel[:-6]) + "/"
        else:
            target = BASE + slugify(target_rel)
        out = OUT / (str(rel).replace("\\", "/") + ".html")
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(page(target), encoding="utf-8")
        n += 1
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / "index.html").write_text(page(BASE), encoding="utf-8")
    print(f"l1 redirect pages: {n}")

if __name__ == "__main__":
    main()
