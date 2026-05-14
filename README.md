# 🌍 speedtest-mjj (MJJ 专属测速节点雷达)

[![Bash](https://img.shields.io/badge/Language-Bash-4EAA25?style=flat-square&logo=gnu-bash)](#)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](#)

> **极简、零依赖、交互式。专为 VPS 玩家和 MJJ 打造的测速节点狙击手。**

刚秒了一台高配小鸡，面对复杂的官方测速命令和寻找目标节点 ID 的痛苦？**speedtest-mjj** 告别繁琐，一键呼出交互式菜单，精准查询全球各大机房的 Speedtest 官方测速节点 ID。

## ✨ 核心特性

* **🤖 纯净防脏部署**：如果没有安装 `speedtest`，脚本会自动判断架构 (x86_64 / arm64) 并为您下载**免依赖绿色单文件版**，绝对不污染你那纯净的 Debian/Ubuntu 系统环境。
* **⚡ 极致轻量**：纯 Bash 编写，仅依赖系统自带的 `curl` 和 `awk`，没有任何花里胡哨的 Python/Nodejs 依赖。
* **🎯 交互式操作**：预设美西、亚太、欧洲等热门机房区域，支持一键选中。
* **🔍 自定义探测**：支持直接输入全球任意城市的英文或拼音进行动态抓取。
* **📊 优雅排版**：自动提取原生 JSON 数据并强制格式化为等宽表格，告别乱码。

## 🚀 一键召唤雷达 (One-Click Run)

无需下载脚本，直接在您的 Linux 小鸡终端里粘贴这行代码，回车即可拔剑：

```bash
bash <(curl -sL https://raw.githubusercontent.com/starshine369/speedtest-mjj/main/speedtest-mjj.sh)
```

*(如果提示 curl 不存在，请先执行 `apt install curl` 或 `yum install curl`)*

## 📸 战斗演示

1. 唤出主菜单并选择地区（例如选择 `1` 洛杉矶）。
2. 脚本将自动从 Ookla 官方 API 抓取当前存活的机房节点，并整理出优雅的表格：
   ```text
   节点 ID  | 赞助商 (机房 / 运营商)              | 物理位置
   ---------|-------------------------------------|-----------------
   60392    | Misaka Network, Inc.                | Los Angeles, CA
   40781    | ReliableSite Hosting                | Los Angeles, CA
   17782    | IGKbet                              | Los Angeles, CA
   ```
3. 复制心仪的节点 ID，直接使用原生命令榨干带宽：
   ```text
   speedtest -s 60392
   ```
## 🛠️ 支持的环境

* Debian 9+ / Ubuntu 18.04+
* CentOS 7+ / AlmaLinux / Rocky Linux
* 架构支持：`x86_64` / `aarch64 (arm64)`

## 📜 许可协议

本项目基于 [MIT License](LICENSE) 开源。欢迎提交 PR 或 Issue。
Made with ❤️ by [starshine369](https://github.com/starshine369)
