# 发布所有 @eterill/catpaw-* 包到 npm
Write-Host "Publishing @eterill/catpaw-* packages to npm..." -ForegroundColor Green

$NPM_TOKEN = "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"
$NPM_REGISTRY = "//registry.npmjs.org/"

# 设置 npm token
Write-Host "Setting npm token..." -ForegroundColor Gray
npm config set "${NPM_REGISTRY}:_authToken" $NPM_TOKEN

try {
    $packages = @("common", "element", "excalidraw", "fractional-indexing", "laser-pointer", "math", "utils")

    foreach ($pkg in $packages) {
        $pkgPath = Join-Path $PSScriptRoot "packages\$pkg"
        Write-Host "`nPublishing @eterill/catpaw-$pkg..." -ForegroundColor Cyan
        Set-Location $pkgPath
        npm publish --access public
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ @eterill/catpaw-$pkg published successfully" -ForegroundColor Green
        } else {
            Write-Host "✗ Failed to publish @eterill/catpaw-$pkg" -ForegroundColor Red
        }
    }
} finally {
    # 清除 token
    npm config delete "${NPM_REGISTRY}:_authToken"
    Set-Location $PSScriptRoot
    Write-Host "`nToken cleaned up from npm config." -ForegroundColor Yellow
}

Write-Host "`nAll done!" -ForegroundColor Green
