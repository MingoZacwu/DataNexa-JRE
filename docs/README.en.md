<p align="center">
  <img src="https://raw.githubusercontent.com/MingoZacwu/DataNexa/main/resources/readme/datanexa.png" width="144" alt="DataNexa Logo">
</p>

<h1 align="center">DataNexa JRE</h1>

<p align="center">
  <a href="../README.md">简体中文</a> | English
</p>

<p align="center">
  Cross-platform Java 21 runtime for DataNexa JDBC
</p>

<p align="center">
  <a href="https://github.com/MingoZacwu/DataNexa-JRE/actions/workflows/release.yml"><img src="https://github.com/MingoZacwu/DataNexa-JRE/actions/workflows/release.yml/badge.svg" alt="Release Workflow"></a>
  <a href="https://github.com/MingoZacwu/DataNexa-JRE/releases"><img src="https://img.shields.io/github/v/release/MingoZacwu/DataNexa-JRE?display_name=tag" alt="Latest Release"></a>
</p>

DataNexa-JRE builds and publishes the compact Java 21 runtime used by DataNexa JDBC. The main project ships the JDBC sidecar, while the application downloads the JRE for the current platform when needed.

## Supported Platforms

- macOS arm64
- macOS x86_64
- Windows x86_64

The runtime is built from Temurin JDK 21 with `jlink`. Each release contains platform-specific archives, and the application uses a signed manifest to select and verify the correct archive.

## Releases

JRE versions are published through the `Release JRE` GitHub Actions workflow. Versioned releases contain the platform runtimes, while the moving `jre-latest` release contains the manifest consumed by DataNexa.

## Related Project

- [DataNexa](https://github.com/MingoZacwu/DataNexa)

## License

This project is released together with the main DataNexa project under the MIT License.
