# 发布所有 @eterill/* 包到 npm
Write-Host "Publishing @eterill/* packages to npm..." -ForegroundColor Green

$packages = @("common", "element", "excalidraw", "fractional-indexing", "laser-pointer", "math", "utils")

foreach ($pkg in $packages) {
    $pkgPath = Join-Path $PSScriptRoot "packages\$pkg"
    Write-Host "`nPublishing @eterill/$pkg..." -ForegroundColor Cyan
    Set-Location $pkgPath
    npm publish --access public
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ @eterill/$pkg published successfully" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to publish @eterill/$pkg" -ForegroundColor Red
    }
}

Set-Location $PSScriptRoot
Write-Host "`nAll packages published!" -ForegroundColor Green
