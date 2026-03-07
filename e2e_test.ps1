<#
.SYNOPSIS
    Runs the full end-to-end test suite for Storybook locally (Windows).
.DESCRIPTION
    This script:
    1. Spins up a PostgreSQL test container via docker-compose.
    2. Runs backend NestJS integration tests against the test DB.
    3. Starts backend + frontend servers locally.
    4. Runs Playwright UI tests against the live servers.
    5. Tears down all services and containers.
#>

$ErrorActionPreference = "Stop"

# Bypass Execution Policy for npm scripts
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# ── Configuration ──────────────────────────────────────────
$ProjectRoot = (Get-Item -Path ".\").FullName
$BackendDir = Join-Path $ProjectRoot "backend"
$WebUIDir = Join-Path $ProjectRoot "web-ui"

$TEST_DB_URL = "postgresql://storybook_test:password_test@localhost:5433/storybook_test"
$JWT_SECRET = "test-secret"
$BACKEND_PORT = "3001"
$FRONTEND_PORT = "8081"

# ── Helper ─────────────────────────────────────────────────
function Cleanup {
    Write-Host ">>> Tearing down test environment..." -ForegroundColor Cyan

    # Stop node processes that we spawned
    if ($script:BackendProcess -and -not $script:BackendProcess.HasExited) {
        Stop-Process -Id $script:BackendProcess.Id -Force -ErrorAction SilentlyContinue
    }
    if ($script:FrontendProcess -and -not $script:FrontendProcess.HasExited) {
        Stop-Process -Id $script:FrontendProcess.Id -Force -ErrorAction SilentlyContinue
    }
    # Kill any orphan node processes from npm
    Get-Process node -ErrorAction SilentlyContinue |
    Where-Object { $_.MainWindowTitle -eq "" } |
    Stop-Process -Force -ErrorAction SilentlyContinue

    # Tear down the test DB container
    Push-Location $ProjectRoot
    docker-compose -f docker-compose.test.yml down -v 2>$null
    Pop-Location

    # Remove temporary .env.local file
    $envFile = Join-Path $WebUIDir ".env.local"
    if (Test-Path $envFile) { Remove-Item $envFile -Force }
}

# ── 0. Start Test PostgreSQL ────────────────────────────────
Write-Host ">>> Starting test PostgreSQL container..." -ForegroundColor Cyan
Push-Location $ProjectRoot
docker-compose -f docker-compose.test.yml down -v 2>$null
docker-compose -f docker-compose.test.yml up -d db-test
Pop-Location

# Wait for Postgres to be ready
Write-Host ">>> Waiting for PostgreSQL to accept connections..." -ForegroundColor Yellow
$pgReady = $false
for ($i = 0; $i -lt 30; $i++) {
    try {
        $result = docker exec (docker-compose -f docker-compose.test.yml ps -q db-test) pg_isready -U storybook_test 2>$null
        if ($LASTEXITCODE -eq 0) {
            $pgReady = $true
            break
        }
    }
    catch {}
    Start-Sleep -Seconds 1
    Write-Host "." -NoNewline
}
Write-Host ""
if (-not $pgReady) {
    Write-Host "PostgreSQL failed to start within 30 seconds." -ForegroundColor Red
    Cleanup
    exit 1
}
Write-Host ">>> PostgreSQL is ready!" -ForegroundColor Green

# ── 1. Set Environment ──────────────────────────────────────
$Env:DATABASE_URL = $TEST_DB_URL
$Env:JWT_SECRET = $JWT_SECRET
$Env:MOCK_LLM = "true"
$Env:PORT = $BACKEND_PORT

# ── 2. Run Backend Integration Tests ────────────────────────
Write-Host ">>> Running Backend Integration Tests..." -ForegroundColor Cyan
Push-Location $BackendDir
try {
    npm run test:e2e
    if ($LASTEXITCODE -ne 0) { throw "Backend tests exited with code $LASTEXITCODE" }
}
catch {
    Write-Host "Backend tests failed! $_" -ForegroundColor Red
    Pop-Location
    Cleanup
    exit 1
}
Write-Host ">>> Backend tests passed!" -ForegroundColor Green

# ── 3. Start Backend Server ─────────────────────────────────
Write-Host ">>> Starting Backend Server (Port $BACKEND_PORT)..." -ForegroundColor Cyan
$script:BackendProcess = Start-Process -FilePath "npm.cmd" -ArgumentList "run", "start:dev" `
    -WorkingDirectory $BackendDir -PassThru -NoNewWindow

# Wait for backend to be ready
Write-Host ">>> Waiting for Backend at http://localhost:$BACKEND_PORT/api/v1/health..." -ForegroundColor Yellow
$backendReady = $false
for ($i = 0; $i -lt 30; $i++) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:$BACKEND_PORT/api/v1/health" -UseBasicParsing -ErrorAction SilentlyContinue
        if ($response.StatusCode -eq 200) {
            $backendReady = $true
            break
        }
    }
    catch {}
    Start-Sleep -Seconds 2
    Write-Host "." -NoNewline
}
Write-Host ""
if (-not $backendReady) {
    Write-Host "Backend failed to start." -ForegroundColor Red
    Pop-Location
    Cleanup
    exit 1
}
Write-Host ">>> Backend is ready!" -ForegroundColor Green
Pop-Location

# ── 4. Start Frontend Server ────────────────────────────────
Write-Host ">>> Starting Frontend Server (Port $FRONTEND_PORT)..." -ForegroundColor Cyan
# Write .env.local file for Vite to pick up test API URL (no BOM)
$envFilePath = Join-Path $WebUIDir ".env.local"
[System.IO.File]::WriteAllText($envFilePath, "VITE_API_URL=http://localhost:$BACKEND_PORT/api/v1`n")
$Env:VITE_API_URL = "http://localhost:$BACKEND_PORT/api/v1"
$script:FrontendProcess = Start-Process -FilePath "npm.cmd" -ArgumentList "run", "dev", "--", "--port", $FRONTEND_PORT `
    -WorkingDirectory $WebUIDir -PassThru -NoNewWindow

# Wait for frontend
Write-Host ">>> Waiting for Frontend at http://localhost:$FRONTEND_PORT..." -ForegroundColor Yellow
$frontendReady = $false
for ($i = 0; $i -lt 30; $i++) {
    try {
        $tcp = Test-NetConnection -ComputerName localhost -Port $FRONTEND_PORT -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
        if ($tcp.TcpTestSucceeded) {
            $frontendReady = $true
            break
        }
    }
    catch {}
    Start-Sleep -Seconds 2
    Write-Host "." -NoNewline
}
Write-Host ""
if (-not $frontendReady) {
    Write-Host "Frontend failed to start." -ForegroundColor Red
    Cleanup
    exit 1
}
Write-Host ">>> Frontend is ready!" -ForegroundColor Green

# ── 5. Run Playwright UI Tests ──────────────────────────────
Write-Host ">>> Running Playwright UI Tests..." -ForegroundColor Cyan
Push-Location $WebUIDir
$Env:PLAYWRIGHT_TEST_BASE_URL = "http://localhost:$FRONTEND_PORT"
$Env:VITE_API_URL = "http://localhost:$BACKEND_PORT/api/v1"
try {
    if (-not (Test-Path "node_modules\.bin\playwright")) {
        npx playwright install chromium
    }
    npx playwright test
    $TestExitCode = $LASTEXITCODE
}
catch {
    Write-Host "Playwright execution error: $_" -ForegroundColor Red
    $TestExitCode = 1
}
Pop-Location

# ── 6. Teardown ──────────────────────────────────────────────
Cleanup

if ($TestExitCode -eq 0) {
    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Green
    Write-Host "  ALL TESTS PASSED SUCCESSFULLY!          " -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Green
    exit 0
}
else {
    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Red
    Write-Host "  SOME TESTS FAILED (exit code: $TestExitCode)  " -ForegroundColor Red
    Write-Host "==========================================" -ForegroundColor Red
    exit $TestExitCode
}
