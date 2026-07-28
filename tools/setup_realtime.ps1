Write-Host "=== Aptitude Test App: Real-Time Firebase Setup ===" -ForegroundColor Cyan
Write-Host ""

$projectPath = Split-Path -Parent $PSScriptRoot
Set-Location $projectPath

Write-Host "Step 1/6: Installing Flutter packages..." -ForegroundColor Yellow
flutter pub get
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Step 2/6: Installing FlutterFire CLI..." -ForegroundColor Yellow
dart pub global activate flutterfire_cli

Write-Host "Step 3/6: Configuring Firebase (select your project)..." -ForegroundColor Yellow
flutterfire configure

Write-Host "Step 4/6: Creating platform folders..." -ForegroundColor Yellow
flutter create .

Write-Host "Step 5/6: Running app..." -ForegroundColor Yellow
Write-Host "Use: flutter run -d chrome" -ForegroundColor Green

Write-Host ""
Write-Host "Step 6/6: After Firebase console setup:" -ForegroundColor Yellow
Write-Host "  - Enable Email/Password in Authentication"
Write-Host "  - Create Firestore database"
Write-Host "  - Deploy rules: firebase deploy --only firestore:rules"
Write-Host ""
Write-Host "Done! See docs/REALTIME_SETUP.txt for full guide." -ForegroundColor Green
