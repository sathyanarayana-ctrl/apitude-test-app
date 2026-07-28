Write-Host "=== Publish to Google Firebase Hosting ===" -ForegroundColor Cyan

$projectPath = Split-Path -Parent $PSScriptRoot
Set-Location $projectPath

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Host "Flutter not found. Install from https://docs.flutter.dev/get-started/install/windows" -ForegroundColor Red
    exit 1
}

if (-not (Get-Command firebase -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Firebase CLI..." -ForegroundColor Yellow
    npm install -g firebase-tools
}

Write-Host "Step 1/5: Flutter pub get..." -ForegroundColor Yellow
flutter pub get

Write-Host "Step 2/5: Creating web platform..." -ForegroundColor Yellow
flutter create . --platforms=web

Write-Host "Step 3/5: Building web release..." -ForegroundColor Yellow
flutter build web --release

Write-Host "Step 4/5: Deploying Firestore rules..." -ForegroundColor Yellow
firebase deploy --only firestore:rules

Write-Host "Step 5/5: Deploying to Firebase Hosting..." -ForegroundColor Yellow
firebase deploy --only hosting

Write-Host ""
Write-Host "Published! Open your Firebase Hosting URL from the output above." -ForegroundColor Green
Write-Host "Format: https://YOUR-PROJECT-ID.web.app" -ForegroundColor Green
