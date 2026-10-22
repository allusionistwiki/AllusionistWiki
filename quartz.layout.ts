import { PageLayout, SharedLayout } from "./quartz/cfg"
import * as Component from "./quartz/components"
import type { FileTrieNode } from "./quartz/util/fileTrie"
import CreatedModifiedMeta from "./quartz/components/CreatedModifiedMeta"
import GitHubLinks from "./quartz/components/GitHubLinks"

// Wiki1 のサイドバー（Explorer）には L1 層へのリンクを出さない:
// L1 は /AllusionistWiki/l1/ 下位層であり、本文の入口索引からのみ辿る（v2 側に正規の入口がある）
const explorerWithoutL1 = Component.Explorer({
  filterFn: (node: FileTrieNode) => node.slugSegment !== "tags" && node.slugSegment !== "l1",
})

// components shared across all pages
export const sharedPageComponents: SharedLayout = {
  head: Component.Head(),
  header: [],
  afterBody: [],
  footer: Component.Footer({
    links: {
      "Obsidian vault（ソース）": "https://github.com/allusionistwiki/AllusionistWiki_obsidian",
      "Quartz プロジェクト": "https://github.com/allusionistwiki/AllusionistWiki",
    },
  }),
}

// components for pages that display a single page (e.g. a single note)
export const defaultContentPageLayout: PageLayout = {
  beforeBody: [
    Component.ConditionalRender({
      component: Component.Breadcrumbs(),
      condition: (page) => page.fileData.slug !== "index",
    }),
    Component.ArticleTitle(),
    CreatedModifiedMeta(),
    Component.TagList(),
  ],
  left: [
    Component.PageTitle(),
    Component.MobileOnly(Component.Spacer()),
    Component.Flex({
      components: [
        {
          Component: Component.Search(),
          grow: true,
        },
        { Component: Component.Darkmode() },
        { Component: Component.ReaderMode() },
      ],
    }),
    explorerWithoutL1,
  ],
  right: [
    Component.Graph(),
    Component.DesktopOnly(Component.TableOfContents()),
    GitHubLinks(),
    Component.Backlinks(),
  ],
}

// components for pages that display lists of pages  (e.g. tags or folders)
export const defaultListPageLayout: PageLayout = {
  beforeBody: [Component.Breadcrumbs(), Component.ArticleTitle(), CreatedModifiedMeta()],
  left: [
    Component.PageTitle(),
    Component.MobileOnly(Component.Spacer()),
    Component.Flex({
      components: [
        {
          Component: Component.Search(),
          grow: true,
        },
        { Component: Component.Darkmode() },
      ],
    }),
    explorerWithoutL1,
  ],
  right: [],
}
