# DataNexa JRE

Builds and publishes the platform-specific Java 21 runtime used by DataNexa
JDBC. The repository publishes JRE archives only; the JDBC sidecar is built
and shipped by the main DataNexa repository.

Each JDK update is published as an immutable versioned release, for example
`jre-21.0.8+9`. A separate moving `jre-latest` release contains only the
signed `jre-manifest.json` and its detached Minisign signature.

The application reads:

```text
https://github.com/MingoZacwu/DataNexa-JRE/releases/download/jre-latest/jre-manifest.json
```

## Required release secrets

Configure these repository secrets before running the release workflow:

- `JRE_MINISIGN_SECRET_KEY`: complete Minisign secret-key file contents
- `JRE_MINISIGN_PASSWORD`: password for the secret key

The corresponding public key is compiled into DataNexa. Never commit the
secret key or password to this repository.

The workflow produces `.tar.gz` archives for all supported platforms so the
application can use one extraction path on macOS and Windows.
