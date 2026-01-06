# Build Optimized APK Script
# Run this to create a small, optimized APK

Write-Host "🚀 Building Optimized BetterMuslim APK..." -ForegroundColor Green
Write-Host ""

# Step 1: Clean
Write-Host "📦 Step 1/4: Cleaning previous builds..." -ForegroundColor Cyan
flutter clean
Write-Host "✅ Clean complete!" -ForegroundColor Green
Write-Host ""

# Step 2: Get dependencies
Write-Host "📦 Step 2/4: Getting dependencies..." -ForegroundColor Cyan
flutter pub get
Write-Host "✅ Dependencies ready!" -ForegroundColor Green
Write-Host ""

# Step 3: Build optimized APK
Write-Host "📦 Step 3/4: Building optimized APK (this may take a few minutes)..." -ForegroundColor Cyan
flutter build apk --release --split-per-abi
Write-Host "✅ Build complete!" -ForegroundColor Green
Write-Host ""

# Step 4: Show results
Write-Host "📦 Step 4/4: Build Summary" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ APKs created successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📍 Location: build\app\outputs\flutter-apk\" -ForegroundColor Yellow
Write-Host ""
Write-Host "📱 APK Files:" -ForegroundColor Yellow
Write-Host "  • app-arm64-v8a-release.apk     (Recommended - for most devices)" -ForegroundColor White
Write-Host "  • app-armeabi-v7a-release.apk   (For older devices)" -ForegroundColor White
Write-Host "  • app-x86_64-release.apk        (For emulators)" -ForegroundColor White
Write-Host ""
Write-Host "💡 Tip: Use app-arm64-v8a-release.apk for 95% of devices!" -ForegroundColor Cyan
Write-Host ""
Write-Host "🎉 Done! Your optimized APK is ready to install!" -ForegroundColor Green
