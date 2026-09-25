# Project006 通讯应用下载页

- 项目编号：006
- 创建日期：2026-09-25
- 项目根目录：`F:\Workspace\Project006通讯应用下载页`
- 目标仓库：`https://github.com/laogui593/FENFA.git`
- 用户目标：为现有通讯应用下载页补充 Dockerfile，并将下载连接集中配置为变量。
- 当前状态：进行中。

## 下载连接变量

统一编辑 `config.js`：

```js
window.DOWNLOAD_LINKS = {
    android: "",
    ios: ""
};
```

## Docker

```bash
docker build -t fenfa-download .
docker run --rm -p 8080:80 \
  -e ANDROID_DOWNLOAD_URL=https://example.com/app.apk \
  -e IOS_DOWNLOAD_URL=https://apps.apple.com/app/id000000000 \
  fenfa-download
```

打开 `http://localhost:8080`。

## 验证边界

所有下载连接均通过 Docker 环境变量注入：`ANDROID_DOWNLOAD_URL` 和 `IOS_DOWNLOAD_URL`。仓库不保存实际下载连接；两个变量任意一个为空时，容器会拒绝启动。
