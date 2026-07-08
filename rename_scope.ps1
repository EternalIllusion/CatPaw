﻿# 将所有 @eterill/catpaw- 替换为 @eterill/catpaw-
# 影响范围：package.json、.ts、.tsx、.js、.md、CHANGELOG.md 等

$root = $PSScriptRoot
$ErrorActionPreference = "Stop"

Write-Host "开始替换 @eterill/catpaw- -> @eterill/catpaw- ..." -ForegroundColor Green

# 收集所有需要处理的文件
$extensions = @("*.json", "*.ts", "*.tsx", "*.js", "*.md", "*.ps1")

$files = Get-ChildItem -Path $root -Recurse -Include $extensions `
    | Where-Object {
        $_.FullName -notmatch "\\node_modules\\" `
        -and $_.FullName -notmatch "\\dist\\" `
        -and $_.FullName -notmatch "\\types\\" `
        -and $_.FullName -notmatch "\\woff2\\assets\\"
    }

$count = 0
foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    if ($content -match "@eterill/catpaw-") {
        $newContent = $content -replace "@eterill/catpaw-", "@eterill/catpaw-"
        Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8 -NoNewline
        Write-Host "  ✓ $($file.FullName.Substring($root.Length))" -ForegroundColor Gray
        $count++
    }
}

Write-Host "`n替换完成！共修改 $count 个文件。" -ForegroundColor Green
Write-Host "请检查变更后提交。" -ForegroundColor Yellow
