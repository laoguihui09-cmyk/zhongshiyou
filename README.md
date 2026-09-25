# Project006 通讯应用下载页

- 项目编号：006
- 创建日期：2026-09-25
- 项目根目录：`F:\Workspace\Project006通讯应用下载页`
- 来源仓库：`https://github.com/laogui593/FENFA.git`
- 用户目标：为现有通讯应用下载页补充 Dockerfile，并将下载连接集中配置为变量。
- 当前状态：进行中。

- 发布仓库：`https://github.com/laoguihui09-cmyk/zhongshiyou.git`

## 端口与访问地址

- 容器内 Nginx 监听 **80/TCP**；托管平台的容器端口、目标端口、HTTP 服务端口均填 **80**。
- 下方命令把宿主机 **8080** 映射到容器 **80**（`8080:80`，左侧是宿主机端口）。宿主机端口可以按需调整。
- 本机访问 `http://localhost:8080`；部署到服务器后访问 `http://服务器IP:8080`，前提是宿主机端口已开放。平台绑定域名后使用平台提供的域名。
- 项目是静态下载页，无后端 API、数据库或依赖安装步骤。基础镜像为 `nginx:1.27-alpine`。

## Docker 构建与启动

在包含 Dockerfile 的项目根目录执行。以下为 Bash / Linux 命令：

```bash
docker build -t fenfa-download .
docker run -d --name fenfa-download --restart unless-stopped \
  -p 8080:80 \
  -e ANDROID_DOWNLOAD_URL='https://example.com/your-app.apk' \
  -e IOS_DOWNLOAD_URL='https://testflight.apple.com/join/YOUR_CODE' \
  fenfa-download
```

以上两个 URL 均为示例，必须替换为自己的有效地址。托管平台使用仓库构建时，构建文件选择根目录 `Dockerfile`，服务端口填 `80`，并设置下面两个环境变量；启动命令使用镜像默认值。

## 下载地址配置

| 环境变量 | 用途 | 要求 |
| --- | --- | --- |
| `ANDROID_DOWNLOAD_URL` | 首页与页脚 Android 下载入口 | 必填，填写可实际下载 APK 的地址 |
| `IOS_DOWNLOAD_URL` | 首页与页脚 iOS 下载入口 | 必填，填写有效的 TestFlight、App Store 或适用的分发地址 |

容器启动时读取 `config.template.js`，把环境变量写入 `config.js`。任一变量为空时，容器退出，不启动 Nginx。更新环境变量后须重新创建容器，或在托管平台重新部署；仅修改文件中的 `config.js` 会在容器下次启动时被覆盖。

纯静态托管、不使用 Docker 时，直接编辑 `config.js` 中的 `window.DOWNLOAD_LINKS.android` 和 `window.DOWNLOAD_LINKS.ios`；静态服务器不会自动读取上述环境变量。当前仓库中的两个地址留空，直接打开原文件时按钮为 `#`，不能实际下载。

当前发布仓库不包含内置 APK/EXE 安装包，必须配置有效的外部下载地址。本地来源源码中的 `static/app/IM-app.apk` 和 `IM-CER.exe` 仅为 134 字节 Git LFS 指针，不能作为实际安装包使用。

## 启动后的检查

```bash
docker ps --filter name=fenfa-download
docker logs fenfa-download
docker inspect --format '{{.State.Health.Status}}' fenfa-download
curl -I http://localhost:8080/
curl http://localhost:8080/config.js
```

首页应返回 HTTP 200，`config.js` 应包含所配置的两个真实地址。健康检查在容器内访问 `http://127.0.0.1/`，只检查网站响应，不验证安装包。缺少下载变量时容器会退出；使用上述自动重启策略时会重复重启，需补齐变量后重新创建容器。

最后在浏览器分别点击首页和页脚的 Android、iOS 入口，确认 Android 得到实际 APK、iOS 打开预期分发页面。手机安装是否成功须在目标设备上验证。

## 已验证与未验证（2026-09-26）

- 已验证：四种环境变量有无组合的启动校验；四个入口绑定对应配置地址；桌面 1366×900、手机尺寸 390×844 的本地浏览器页面均返回 200，无脚本异常或横向溢出。
- 已确认的限制：本地地址为空时四个入口均为 `#`，点击不能下载；这是当前未配置状态，不能记为实际下载通过。
- 未验证：Docker 镜像构建、真实容器运行、外部下载地址及手机安装。本机没有 Docker 命令；未执行部署，也不声称已有线上可用版本。
