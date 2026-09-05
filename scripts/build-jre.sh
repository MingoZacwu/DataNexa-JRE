#!/usr/bin/env bash
set -euo pipefail

jdk_home="${JAVA_HOME:-}"
platform="${JRE_PLATFORM:-}"
arch="${JRE_ARCH:-}"
jre_version="${JRE_VERSION:-}"
output_dir="${OUTPUT_DIR:-dist}"

if [[ -z "$jdk_home" || -z "$platform" || -z "$arch" || -z "$jre_version" ]]; then
  echo "JAVA_HOME, JRE_PLATFORM, JRE_ARCH and JRE_VERSION are required." >&2
  exit 1
fi
if [[ ! -x "$jdk_home/bin/jlink" || ! -x "$jdk_home/bin/java" ]]; then
  echo "A JDK with jlink and java is required." >&2
  exit 1
fi

mkdir -p "$output_dir"
build_parent="$(mktemp -d "${TMPDIR:-/tmp}/datanexa-jre.XXXXXX")"
runtime="$build_parent/jre"
trap 'rm -rf "$build_parent"' EXIT

"$jdk_home/bin/jlink" \
  --add-modules java.base,java.sql,java.naming,java.logging,java.xml,java.management,java.desktop,java.net.http,java.security.jgss,jdk.crypto.ec,jdk.unsupported \
  --strip-debug \
  --no-header-files \
  --no-man-pages \
  --compress=2 \
  --output "$runtime"

"$runtime/bin/java" -version

archive="datanexa-jre-21-${platform}-${arch}.tar.gz"
# Dereference the JDK's legal-file symlinks so the archive can be extracted
# consistently on Windows and macOS without requiring symlink privileges.
tar -czhf "$output_dir/$archive" -C "$runtime" .
sha256sum "$output_dir/$archive" | awk '{print $1}' > "$output_dir/$archive.sha256"
cat > "$output_dir/$archive.json" <<EOF
{
  "platform": "$platform",
  "arch": "$arch",
  "archive": "$archive",
  "sha256": "$(cat "$output_dir/$archive.sha256")",
  "size": $(wc -c < "$output_dir/$archive" | tr -d ' ')
}
EOF

echo "Built $output_dir/$archive"
