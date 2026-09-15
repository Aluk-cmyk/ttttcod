# 验收：保存、推送、冲突与 IP 改动

前提：按 README 上传原始 4 个文件；管理员已为这个 ChipCrab 项目配置 `ttttcod` 的 `main` 分支读写授权。

## 1. 建立起点

在「Git 仓库」检查远端。初次上传的内容应与仓库 `soc/` 一致，按页面提示确认共同版本。
若发现文件不一致，先看 Diff，不要盲目确认；保留双方内容再处理。

## 2. 从网页推送一次

在「项目文件」给 `ip_counter.sv` 末尾增加 `// web-change-1`，然后保存。

- 此时 GitHub 还不应变化。
- 回到「Git 仓库」，打开「提交并推送」，填写说明 `demo: update counter note`。
- 检查 Diff 只修改 `soc/ip_counter.sv`，然后明确确认推送。
- 看到推送成功后，去 GitHub 查看提交；刷新 ChipCrab，结果应仍保留。

## 3. 制造一个可理解的冲突

先把本地仓库快进到上一步网页推送的版本：

```sh
git pull --ff-only origin main
```

如果本地有未提交改动，先自行保存或提交；不要强制覆盖。

接下来在 `ip_gpio.sv` 同一行做两种不同修改：

1. **网页端**：将文件顶部的 `// GPIO IP: ...` 注释整行改为 `// GPIO IP: reviewed in ChipCrab.`，保存，但先不推送。
2. **本地端**：将 `soc/ip_gpio.sv` 的同一行改为 `// GPIO IP: reviewed locally.`，执行：

```sh
git add soc/ip_gpio.sv
git commit -m "demo: local GPIO review note"
git push origin main
```

3. 回网页检查远端，进入合并。应看到这行冲突，可选择一方或手动写成 `// GPIO IP: reviewed locally and in ChipCrab.`。
4. 确认保存合并结果。**这一步只保存 Workspace，不自动推送。**
5. 再次查看发布预览并确认推送；GitHub 的 `soc/ip_gpio.sv` 应显示最终选择。

这里只改注释，不故意破坏 RTL；推送只使用普通 Git，不使用 force。

## 4. IP 集成提醒（独立验收）

在同一 SoC 项目的「IP 集成」分别添加：

| IP 名称 | 监测文件 |
| --- | --- |
| Counter | `/workspace/ip_counter.sv` |
| GPIO | `/workspace/ip_gpio.sv` |

确认当前集成版本。然后只改 Counter 文件的一条注释并保存，刷新 IP 集成：Counter 应显示有改动，GPIO 不受影响。
查看 Diff 后确认集成；刷新后确认记录应保留。人工确认表示接受文件版本，不代表仿真或 SoC 签核通过。

## 5. 可选：运行仿真

Git 和 IP 文件变化验收不以仿真为前置条件。需要体验仿真时，在同一 SoC 项目对话发送：

> 使用当前已保存的 4 个 SystemVerilog 文件，对 soc_demo_tb 运行仿真，测试 ID 使用 soc_demo_tb。不要修改源码，报告真实执行结果，并生成波形。

若要求选择入口，指定原生 HDL、Top `soc_demo_tb`。应有 8 项自检通过；以真实日志为准，不能将工具调用完成当作测试通过。

## 完成标准

- 保存不推送，明确确认才推送；范围仅限 `soc/`。
- 冲突能在网页解决，双方改动不会被静默覆盖。
- IP 变化提醒仅影响所监测文件；人工确认历史可保留。
- 可选仿真有真实通过日志和波形。
