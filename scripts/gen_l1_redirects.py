#!/usr/bin/env python3
"""gen_l1_redirects.py — 旧 /AllusionistWiki/l1/* URL を新 Wiki2 サイトへ転送するスタブを生成する。

CI（deploy.yml）で /tmp/l1（L1 vault）を clone した後に実行する。
vault の wiki/**/*.md に対応する content/l1/<relpath> を
meta refresh + 手動リンク付きスタブ md で生成する（旧 URL の外部被リンク保全）。
"""
import sys
from pathlib import Path

VAULT = Path("/tmp/l1/wiki")
OUT = Path("content/l1")
BASE = "https://allusionistwiki.github.io/AllusionistWiki2/l1/"

def slugify(s: str) -> str:
    s = s.replace("&", "and")
    import re
    s = re.sub(r"\s+", "-", s)
    return s

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
        out = OUT / rel
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(
            "---\ntitle: 移設済み（AllusionistWiki2 へ）\n---\n\n"
            f'<meta http-equiv="refresh" content="0; url={target}">\n\n'
            f"この L1 ページは **アリュージョニスト Wiki 2** へ移設しました。"
            f"移動しない場合は [こちら]({target}) を開いてください。\n",
            encoding="utf-8",
        )
        n += 1
    OUT.mkdir(parents=True, exist_ok=True)
    (OUT / "index.md").write_text(
        "---\ntitle: L1 層（移設済み）\n---\n\n"
        f'<meta http-equiv="refresh" content="0; url={BASE}">\n\n'
        f"この L1 層は [アリュージョニスト Wiki 2]({BASE}) へ移設しました。\n",
        encoding="utf-8",
    )
    print(f"l1 redirect stubs: {n}")

if __name__ == "__main__":
    main()
