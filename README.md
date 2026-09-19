# 哲学研究笔记

这是一个可以直接打开的 Obsidian 笔记库，内容来自原有 Logseq 哲学笔记。

在 Obsidian 中选择「打开本地仓库」，选中本仓库的根目录，然后打开 [首页](首页.md)。

- [原阅读目录](目录.md)：保留原来的阅读顺序。
- [康德研究工作台](研究工作台.md)：概念索引、文献和阅读问题。
- [使用指南](使用指南.md)：插件用法、模板和引文记录。
- [迁移说明](迁移说明.md)：转换范围和待补页面。

## 插件

本机已安装 Dataview、PDF++、Citations 和 Quiet Outline，并写入启用列表。
主题选用 Minimal，配合 Minimal Theme Settings 的 Flexoki 配色；正文使用 Noto Sans SC 黑体，字号 18，行距 1.8。
首次打开若 Obsidian 显示信任提示，请确认这是自己的笔记库并允许已安装插件运行。

插件与主题代码不进入 Git，版本、下载来源和 SHA-256 保存在 `.obsidian/plugins.lock.json` 与 `.obsidian/themes.lock.json`。
在另一台 Windows 电脑克隆后，在仓库根目录运行以下命令安装相同版本，再打开 Obsidian：

```powershell
pwsh -File ./scripts/Install-Plugins.ps1
```

此脚本同时恢复主题。也可以在 Obsidian 设置中分别安装上述研究插件、Minimal Theme Settings 配套插件，以及 Minimal 主题。

## 内容与同步

笔记保存在 `笔记/`，新建文件也默认进入此目录；研究模板在 `模板/`。
`文献/` 放文献笔记，`附件/` 放 PDF 等附件，`日记/` 放阅读日记。

本仓库以一个全新根提交开始，不再保留旧网页的提交链。原 Logseq 源目录保持不变。
白板按要求不迁移；Logseq 的备份、回收站和界面设置不属于正文笔记。

仓库用于笔记存储。`vercel.json` 已禁止所有分支的 Git 自动部署，GitHub Actions 已关闭。
Vercel 后台的 Git 关联已手动解除，详情见 [迁移说明](迁移说明.md)。
