import { readFileSync, readdirSync, writeFileSync } from "node:fs";
import { join, resolve } from "node:path";

const outputDir = resolve(process.env.ARTIFACT_DIR ?? "dist");
const jreVersion = process.env.JRE_VERSION;
const releaseTag = process.env.RELEASE_TAG;
const repository = process.env.GITHUB_REPOSITORY ?? "MingoZacwu/DataNexa-JRE";
const minAppVersion = process.env.MIN_APP_VERSION ?? "0.8.0";

if (!jreVersion || !releaseTag) throw new Error("JRE_VERSION and RELEASE_TAG are required");

const metadata = readdirSync(outputDir)
  .filter((name) => name.endsWith(".json"))
  .map((name) => JSON.parse(readFileSync(join(outputDir, name), "utf8")));
if (metadata.length === 0) throw new Error("No JRE artifact metadata found");

metadata.sort((left, right) => `${left.platform}-${left.arch}`.localeCompare(`${right.platform}-${right.arch}`));
const targets = metadata.map((item) => `${item.platform}-${item.arch}`);
if (new Set(targets).size !== targets.length) {
  throw new Error(`Duplicate JRE artifact target: ${targets.find((target, index) => targets.indexOf(target) !== index)}`);
}
for (const item of metadata) {
  if (!item.platform || !item.arch || !item.archive || !item.sha256 || !Number.isSafeInteger(item.size) || item.size <= 0) {
    throw new Error(`Invalid JRE artifact metadata: ${JSON.stringify(item)}`);
  }
}

const releaseBase = `https://github.com/${repository}/releases/download/${encodeURIComponent(releaseTag)}`;
const artifacts = Object.fromEntries(metadata.map((item) => [
  `${item.platform}-${item.arch}`,
  {
    url: `${releaseBase}/${encodeURIComponent(item.archive)}`,
    sha256: item.sha256,
    size: item.size,
    archive: item.archive,
  },
]));

const manifest = {
  schema_version: 1,
  java_major: 21,
  java_version: jreVersion,
  release_tag: releaseTag,
  min_app_version: minAppVersion,
  artifacts,
};

writeFileSync(join(outputDir, "jre-manifest.json"), `${JSON.stringify(manifest, null, 2)}\n`);
console.log(`Generated manifest for ${jreVersion}: ${Object.keys(artifacts).join(", ")}`);
