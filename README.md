# ChipCrab IP / SoC 目录保护验收

这是独立验收分支，不是产品源码。请不要合并到 main。

- IP 项目选择 `acceptance_0916/ip/counter`，只能修改 Counter。
- SoC 项目选择整个工程，可以修改 `acceptance_0916/soc`，Counter 只读。
- SoC 在 IP 集成中选择 Counter IP 项目；关联不会复制代码或运行仿真。
- `soc_demo_tb` 仅供可选仿真，本次目录保护与关联验收不要求仿真。
- 普通 SoC 拉取若包含 Counter 改动，本阶段整次拒绝；不是自动升级 IP。

专用路径避免认领原测试仓库中的 `soc/` 目录。
