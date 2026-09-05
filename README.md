<p align="center">
  <img src="https://raw.githubusercontent.com/MingoZacwu/DataNexa/main/resources/readme/datanexa.png" width="144" alt="DataNexa Logo">
</p>

<h1 align="center">DataNexa JRE</h1>

<p align="center">
  简体中文 | <a href="docs/README.en.md">English</a>
</p>

<p align="center">
  DataNexa JDBC 使用的跨平台 Java 21 运行环境
</p>

<p align="center">
  <a href="https://github.com/MingoZacwu/DataNexa-JRE/actions/workflows/release.yml"><img src="https://github.com/MingoZacwu/DataNexa-JRE/actions/workflows/release.yml/badge.svg" alt="Release Workflow"></a>
  <a href="https://github.com/MingoZacwu/DataNexa-JRE/releases"><img src="https://img.shields.io/github/v/release/MingoZacwu/DataNexa-JRE?display_name=tag" alt="Latest Release"></a>
</p>

DataNexa-JRE 独立构建并发布 DataNexa JDBC 所需的精简 Java 21 运行环境。主项目负责 JDBC sidecar，应用运行时按当前平台下载对应的 JRE。

## 支持平台

- macOS arm64
- macOS x86_64
- Windows x86_64

JRE 基于 Temurin JDK 21，并使用 `jlink` 生成精简运行环境。每个版本发布独立的 JRE 压缩包，应用通过签名清单选择平台并校验文件完整性。

## 发布

JRE 版本通过 GitHub Actions 的 `Release JRE` workflow 发布。发布后，版本化 Release 保存平台 JRE，`jre-latest` Release 提供应用读取的最新清单。

## 相关项目

- [DataNexa](https://github.com/MingoZacwu/DataNexa)

## 许可证

本项目与 DataNexa 主项目一起按 MIT License 发布。
