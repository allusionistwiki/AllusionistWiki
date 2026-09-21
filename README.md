# 幻想再帰のアリュージョニスト Wiki（Web公開版）

[![Deploy](https://github.com/allusionistwiki/AllusionistWiki/actions/workflows/deploy.yml/badge.svg)](https://github.com/allusionistwiki/AllusionistWiki/actions)

**公開サイト: https://allusionistwiki.github.io/AllusionistWiki/**

「ネットミームから現代思想まで引喩が散りばめたオカルトパンク」——本作の多層アナロジー（引喩・神話参照・展開の相似/相違）を典拠付きで体系化する分析WikiのWeb公開版。[Quartz](https://quartz.jzhao.xyz/) でObsidian vaultから静的サイトとしてビルドしています。

## 構成（2リポジトリ方式）

| リポジトリ | 役割 |
|---|---|
| [`AllusionistWiki_obsidian`](https://github.com/allusionistwiki/AllusionistWiki_obsidian) | Obsidian vault本体（ソース・オブ・トゥルース）。`wiki/` がQuartzのcontentになる |
| `AllusionistWiki`（本リポジトリ） | Quartzプロジェクト＋GitHub Pagesデプロイ設定。vaultの内容はCIが取得してビルドする |

## デプロイフロー

1. vault側（Obsidianリポジトリ）にpush → または毎時スケジュール発火
2. CIが `AllusionistWiki_obsidian` の `wiki/` を `content/` として取得
3. `npx quartz build` で静的サイト生成
4. GitHub Pages にデプロイ（vaultのSHAが変わらなければスキップ）

> vault側から即時再ビルドをトリガーしたい場合は、Quartzリポジトリの Actions → Deploy → Run workflow を手動実行すればよい。

## ローカルでビルド・プレビュー

```bash
# vault の wiki/ を content/ にコピー（またはシンボリックリンク）
git clone https://github.com/allusionistwiki/AllusionistWiki_obsidian.git /tmp/vault
mkdir -p content && cp -r /tmp/vault/wiki/. content/

npm ci
npx quartz build --serve   # http://localhost:8080 でプレビュー
```

## 設定

- `quartz.config.ts` — タイトル・ロケール（ja-JP）・baseUrl・テーマ
- `quartz.layout.ts` — レイアウト（検索・グラフ・backlinks・TOC）
- `.github/workflows/deploy.yml` — GitHub Pagesデプロイ

## License

本リポジトリは CC0 1.0 Universal（パブリックドメイン）で公開します。
ただし**商用利用は不可**。原作「幻想再帰のアリュージョニスト」の著作権は原作者に帰属します。
