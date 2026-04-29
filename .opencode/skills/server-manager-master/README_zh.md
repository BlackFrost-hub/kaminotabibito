# Server Manager | 服务器管理器

后台启动、追踪、关闭开发服务器，不阻塞 AI 对话。

## 解决的问题

在 AI 终端里运行 `npm run dev` 会一直占用终端，无法继续对话。本 skill 实现**完全不阻塞**的后台服务器管理。

## 安装

下载整个 `server-manager/` 文件夹到你的 skills 目录：

- **全局安装**：`~/.config/opencode/skills/server-manager/`
- **项目安装**：项目根目录的 `.opencode/skills/server-manager/`

## 支持的技术栈

任何监听端口的开发服务器：Next.js、Vite、HyperFrames、Remotion、Streamlit、Flask、Django、Go、Rust 等。

## 命令

| 命令 | 说明 |
|------|------|
| `start-server` | 启动服务器（不阻塞） |
| `stop-server` | 停止单个服务器 |
| `stop-all` | 停止所有服务器 |
| `list-servers` | 列出活跃服务器 |
| `health-server` | HTTP 健康检查 |
| `tail-server` | 查看日志末尾 |
| `grep-server` | 搜索日志关键词 |
