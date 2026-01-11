# Quick Release Build Script
# Run this to build your Play Store release

Write-Host "🚀 Building Indian Constitution Vault for Play Store Release" -ForegroundColor Green
Write-Host ""

# Navigate to mobile directory
Set-Location -Path "d:\development\workspace\Constitution_app\mobile"

Write-Host "📦 Cleaning previous builds..." -ForegroundColor Yellow
flutter clean

Write-Host "📥 Getting dependencies..." -ForegroundColor Yellow
flutter pub get

Write-Host ""
Write-Host "🏗️  Building App Bundle for Play Store..." -ForegroundColor Cyan
flutter build appbundle --release

Write-Host ""
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Build Successful!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📍 App Bundle Location:" -ForegroundColor Yellow
    Write-Host "   mobile\build\app\outputs\bundle\release\app-release.aab" -ForegroundColor White
    Write-Host ""
    Write-Host "📊 File Info:" -ForegroundColor Yellow
    $bundlePath = "build\app\outputs\bundle\release\app-release.aab"
    if (Test-Path $bundlePath) {
        $size = (Get-Item $bundlePath).Length / 1MB
        Write-Host "   Size: $([math]::Round($size, 2)) MB" -ForegroundColor White
    }
    Write-Host ""
    Write-Host "🎯 Next Steps:" -ForegroundColor Cyan
    Write-Host "   1. Test the app: flutter install" -ForegroundColor White
    Write-Host "   2. Go to Play Console: https://play.google.com/console" -ForegroundColor White
    Write-Host "   3. Upload the AAB file" -ForegroundColor White
    Write-Host "   4. Fill in release notes" -ForegroundColor White
    Write-Host "   5. Submit for review" -ForegroundColor White
    Write-Host ""
    Write-Host "📖 Full guide: PLAY_STORE_RELEASE_GUIDE.md" -ForegroundColor Yellow
} else {
    Write-Host "❌ Build Failed!" -ForegroundColor Red
    Write-Host "Check the error messages above." -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 Common fixes:" -ForegroundColor Yellow
    Write-Host "   - Ensure key.properties exists in android/" -ForegroundColor White
    Write-Host "   - Check keystore file path" -ForegroundColor White
    Write-Host "   - Verify all dependencies are installed" -ForegroundColor White
    Write-Host "   - Run: flutter doctor -v" -ForegroundColor White
}

Write-Host ""
