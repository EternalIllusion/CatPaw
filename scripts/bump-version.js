const fs = require("fs");
const path = require("path");

const PACKAGES_DIR = path.resolve(__dirname, "../packages");
const PACKAGES = [
  "common",
  "fractional-indexing",
  "laser-pointer",
  "math",
  "element",
  "excalidraw",
  "utils",
];

function bumpPatch(version) {
  const parts = version.split(".");
  parts[2] = String(Number(parts[2]) + 1);
  return parts.join(".");
}

// 1. 读取所有包信息
const packageDataMap = new Map();
for (const pkg of PACKAGES) {
  const pkgPath = path.join(PACKAGES_DIR, pkg, "package.json");
  const raw = fs.readFileSync(pkgPath, "utf-8");
  const data = JSON.parse(raw);
  packageDataMap.set(pkg, { pkgPath, raw, data });
}

// 2. 计算新版本
const versionMap = new Map();
for (const [pkg, { data }] of packageDataMap) {
  const oldVersion = data.version;
  const newVersion = bumpPatch(oldVersion);
  versionMap.set(data.name, { old: oldVersion, new: newVersion });
  console.log(`${data.name}: ${oldVersion} -> ${newVersion}`);
}

// 3. 更新版本号 + 内部依赖引用
for (const [pkg, { pkgPath, raw, data }] of packageDataMap) {
  data.version = versionMap.get(data.name).new;

  if (data.dependencies) {
    for (const [depName, ver] of Object.entries(data.dependencies)) {
      if (versionMap.has(depName)) {
        data.dependencies[depName] = versionMap.get(depName).new;
      }
    }
  }

  // 写入时不带 BOM
  fs.writeFileSync(pkgPath, JSON.stringify(data, null, 2) + "\n", "utf8");
}

console.log("\nDone! All versions bumped.");
