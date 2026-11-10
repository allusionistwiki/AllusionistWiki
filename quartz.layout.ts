import { PageLayout, SharedLayout } from "./quartz/cfg"
import * as Component from "./quartz/components"
import CreatedModifiedMeta from "./quartz/components/CreatedModifiedMeta"
import GitHubLinks from "./quartz/components/GitHubLinks"

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
    Component.Explorer({
      // モバイル（iOS）対策: 初期畳み＋タップ開封は最上位節のみ（数千ノード DOM 防止）
      folderDefaultState: "collapsed",
      folderClickBehavior: "collapse",
      mapFn: (node: any) => {
        if (node.children.length > 40) {
          node.collapsed = true
          node.children = []
        }
        return node
      },
    }),
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
    Component.Explorer({
      // モバイル（iOS）対策: 初期畳み＋タップ開封は最上位節のみ（数千ノード DOM 防止）
      folderDefaultState: "collapsed",
      folderClickBehavior: "collapse",
      mapFn: (node: any) => {
        if (node.children.length > 40) {
          node.collapsed = true
          node.children = []
        }
        return node
      },
    }),
  ],
  right: [],
}
