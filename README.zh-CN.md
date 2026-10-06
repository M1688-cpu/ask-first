<p align="center"><img src="media/cover.png" alt="ask-first cover" width="800"></p>

# ask-first

[English](README.md) | 简体中文 | [日本語](README.ja.md) | [Français](README.fr.md) | [Deutsch](README.de.md) | [Español](README.es.md) | [Português](README.pt.md)

两个先问再动手的 agent skill。

`clarify-first` 一次只问一个问题，直到任务具体到可以直接开工，然后先给你一份书面任务简报，你确认之后才开始干活。`knock-first` 在 agent 接管桌面做测试之前，先确认你是否在电脑前、先征得你的同意，测试一结束就通知你电脑已归还。

这两个问题在用户眼里是一回事：agent 猜了一个方向就动手，结果猜错了。先问一句，比返工便宜。

## 安装

[skills CLI](https://skills.sh) 会自动识别宿主，覆盖 Claude Code、Codex、Cursor、Gemini CLI、GitHub Copilot、opencode、Amp 以及它支持的其他宿主：

```bash
npx skills add M1688-cpu/ask-first -g
```

也可以运行本仓库自带的安装脚本，它会检测你机器上装了哪些 agent，逐个复制进去（`--all` 装满全部支持的 agent，`--list` 仅预览，`--remove` 卸载）：

```bash
git clone https://github.com/M1688-cpu/ask-first.git
bash ask-first/install.sh
```

Claude Code 还可以按插件方式安装：

```text
/plugin marketplace add M1688-cpu/ask-first
/plugin install ask-first@ask-first
```

手动复制的话，各家 agent 读取的目录如下：

| Agent | Skills 目录 |
| --- | --- |
| Claude Code | `~/.claude/skills` |
| Codex | `~/.codex/skills` |
| Cursor | `~/.cursor/skills` |
| Gemini CLI | `~/.gemini/skills` |
| opencode | `~/.config/opencode/skill` |
| Amp | `~/.amp/skills` |
| OpenClaw | `~/.openclaw/skills` |
| ZCode | `~/.zcode/skills` |
| 任何读取开放格式的 agent | `~/.agents/skills` |

安装后，skill 会在条件匹配时自动触发，也可以按名字手动调用。

## clarify-first

面对模糊的需求，会猜的 agent 会满怀信心地做错东西。这个 skill 让它先问。

触发条件：需求里的目标、范围、交付物或关键决策存在多种读法。清晰、小巧、机械式的请求直接放行，agent 只用一句话复述自己的理解。

访谈流程：

1. 一次只问一个问题，每题 2-4 个选项并附推荐答案，多数时候点一下就够。
2. 追问来自你的回答，访谈因此不断收敛，而不是照着清单机械走完。
3. 代码库、文档、网络上能查到的东西一概不问你。只有意图、品味、约束这类只有你能定的事才问。
4. 大约 7 个问题是上限；超过这个数，说明 agent 问错了方向。
5. 把握达到 95% 时写出任务简报：目标、范围内、范围外、交付物、假设。你批准后才开始。

```text
你：    给我的网站加深色模式
agent： 哪些部分？整站，还是先做阅读页？
        （推荐：先做阅读页，80% 的阅读时间都在那里）
你：    阅读页
agent： 跟随系统外观设置，还是加一个自己的开关？
        （推荐：跟随系统，少维护一个控件）
你：    跟随系统
agent： 简报：阅读页深色配色、跟随系统外观、管理后台不动、色板变量放进
        theme.css。开始？[开始 / 改一改]
```

## knock-first

会动鼠标会打字的测试，可能撞上正在用电脑的人。测试挂掉还是轻的；误删编辑、点错按钮才严重。这个 skill 让 agent 先检测、先问、再执行、完事归还。

触发时机：任何接管桌面的操作之前，包括截屏、启动刚编译好的应用、模拟输入、为测试调整窗口大小。

完整循环：

1. 检测：脚本读取键鼠空闲时长、前台应用、是否有会议或媒体应用在播放，判断你是否在电脑前。键盘不动但在看视频的人，也算在场。
2. 请求：一个对话框说明检测结果、即将执行的操作清单、预计时长。选项：开始、本次会话内不再问、先不要。许可只存在于当前对话，绝不写入任何地方。
3. 执行：严格只做清单里的事。清单之外的动作，回来再问一次。
4. 归还：发一条带声音的 macOS 通知，附聊天内的结果摘要，你第一时间知道电脑还给你了。

```text
agent： 你正在用 Xcode（空闲 40 秒）。我需要接管桌面约 3 分钟：打开编译好
        的应用、调到 1280x800、截 3 张屏、输入一次搜索。可以吗？
        [可以 / 本次会话别再问 / 先不要]
你：    可以
        …… 测试执行 ……
agent： 已发通知："测试完成：3 张截图已保存。"
        聊天内：搜索崩溃没有复现，截图在 artifacts/。电脑还给你了。
```

## 文件

```text
skills/clarify-first/SKILL.md        访谈 skill
skills/knock-first/SKILL.md          桌面许可 skill
skills/knock-first/scripts/          活动检测与通知脚本（macOS）
install.sh                           检测已安装的 agent 并逐个安装
.claude-plugin/                      Claude Code 插件清单
media/cover.html                     封面图源文件
```

## 环境要求

`clarify-first` 在任何能提问的 agent 上都能用；没有提问对话框的宿主会退化为聊天内提问。`knock-first` 的脚本使用 macOS 接口（`ioreg`、`lsappinfo`、`osascript`）；其他平台上检测结果恒为「在场」，agent 每次都会询问。截屏需要给运行 agent 的终端授予屏幕录制权限。

## 许可

MIT
