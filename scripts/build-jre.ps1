param(
  [string]$JdkHome = $env:JAVA_HOME,
  [string]$Platform = $env:JRE_PLATFORM,
  [string]$Arch = $env:JRE_ARCH,
  [string]$JreVersion = $env:JRE_VERSION,
  [string]$OutputDir = $(if ($env:OUTPUT_DIR) { $env:OUTPUT_DIR } else { "dist" })
)

$ErrorActionPreference = "Stop"
if ([string]::IsNullOrWhiteSpace($JdkHome) -or [string]::IsNullOrWhiteSpace($Platform) -or [string]::IsNullOrWhiteSpace($Arch) -or [string]::IsNullOrWhiteSpace($JreVersion)) {
  throw "JdkHome, Platform, Arch and JreVersion are required."
}

$jlink = Join-Path $JdkHome "bin\jlink.exe"
$java = Join-Path $JdkHome "bin\java.exe"
if (-not (Test-Path -LiteralPath $jlink -PathType Leaf) -or -not (Test-Path -LiteralPath $java -PathType Leaf)) {
  throw "A JDK with jlink.exe and java.exe is required."
}

New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
$buildParent = Join-Path ([System.IO.Path]::GetTempPath()) ("datanexa-jre-" + [guid]::NewGuid().ToString("N"))
$runtime = Join-Path $buildParent "jre"
New-Item -ItemType Directory -Path $buildParent -Force | Out-Null
try {
  & $jlink `
    --add-modules java.base,java.sql,java.naming,java.logging,java.xml,java.management,java.desktop,java.net.http,java.security.jgss,jdk.crypto.ec,jdk.unsupported `
    --strip-debug `
    --no-header-files `
    --no-man-pages `
    --compress=2 `
    --output $runtime
  if ($LASTEXITCODE -ne 0) { throw "jlink failed." }
  & $java -version 2>&1 | Select-Object -First 1

  $archive = "datanexa-jre-21-$Platform-$Arch.tar.gz"
  tar.exe -czf (Join-Path $OutputDir $archive) -C $runtime .
  if ($LASTEXITCODE -ne 0) { throw "tar failed." }
  $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $OutputDir $archive)).Hash.ToLowerInvariant()
  Set-Content -NoNewline -Path (Join-Path $OutputDir "$archive.sha256") -Value $hash
  $size = (Get-Item -LiteralPath (Join-Path $OutputDir $archive)).Length
  @{
    platform = $Platform
    arch = $Arch
    archive = $archive
    sha256 = $hash
    size = $size
  } | ConvertTo-Json | Set-Content -Path (Join-Path $OutputDir "$archive.json")
} finally {
  if (Test-Path -LiteralPath $buildParent) { Remove-Item -LiteralPath $buildParent -Recurse -Force }
}
