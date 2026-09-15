<!-- E2E shared line: merged web + teammate -->
<!-- E2E remote-only pull: 2026-09-15 -->

<!-- ChipCrab E2E 2026-09-15: local save and preview only; no remote push. -->
# ttttcod — ChipCrab Git / SoC 验收 Demo测试

一个独立的 SystemVerilog 示例仓库，用于体验「保存项目 → 查看 Git 改动 → 确认推送」，以及 IP 文件变化提醒。与 ChipCrab 产品源码完全分开。

## 工程内容

```text
soc/
  ip_counter.sv   8 位计数器 IP
  ip_gpio.sv      8 位 GPIO 输出寄存器 IP
  soc_top.sv      集成两个 IP 的 SoC 顶层
  soc_demo_tb.sv  自检 Testbench
docs/
  git-acceptance.md  网页 Git 和 IP 集成验收步骤
Makefile          本地测试入口
```

两个 IP 共用时钟和高有效同步复位，各自有独立使能。此 Demo 没有总线接口，不是实际芯片或签核工程。

## 本地验证

已安装 Icarus Verilog 时，在仓库根目录运行：

```sh
make test
```

应看到 `[PASS] All 8 checks succeeded.`；波形为 `build/soc_demo.vcd`。
8 项检查覆盖复位、计数、GPIO 写入、并行更新、保持、复位优先级、计数上界和回绕。失败以 `$fatal` 退出，另设超时看门狗。

已安装 Verilator 时可另行执行 `make lint`。

## 在 ChipCrab 中使用

1. 新建一个 **SoC 项目**，名称可填 `Git 集成 Demo`。
2. 在「项目文件」的 `/workspace` 根目录上传 `soc/` 里的 **4 个 `.sv` 文件**并保存。
3. 在「Git 仓库」绑定以下信息（需要管理员先配置此项目的仓库读写授权）：

| 配置 | 值 |
| --- | --- |
| 仓库地址 | `https://github.com/Aluk-cmyk/ttttcod.git` |
| 分支 | `main` |
| 仓库内映射目录 | `soc` |

网页管理的 `/workspace` 对应仓库的 `soc/`；根目录 README、Makefile 和 docs 不在同步范围内。
本地开发可通过 SSH 推送；ChipCrab 服务端使用独立的 HTTPS 授权，本机 SSH 登录不能替代该授权。

后续操作见 [验收步骤](docs/git-acceptance.md)。普通保存只保存 ChipCrab Workspace；明确点击确认推送才修改 GitHub。

<!-- E2E concurrent remote update: preserve this line after retry. -->
