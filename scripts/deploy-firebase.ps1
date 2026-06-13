# Redeploy Firebase resources (functions, Firestore rules/indexes, Storage rules)
# for DEV or PROD. Run from any directory; resolves repo root automatically.
#
# Usage:
#   .\scripts\deploy-firebase.ps1 dev
#   .\scripts\deploy-firebase.ps1 prod
#   .\scripts\deploy-firebase.ps1 all
#   .\scripts\deploy-firebase.ps1 dev --Only functions
#   .\scripts\deploy-firebase.ps1 prod -NonInteractive
#
# Requires: Node 22, firebase CLI (firebase login), and per-project env files:
#   functions\.env.multichoice-app-develop
#   functions\.env.multichoice-412309

param(
    [Parameter(Position = 0)]
    [ValidateSet('dev', 'prod', 'all')]
    [string] $Environment,

    [string] $Only = 'firestore:rules,firestore:indexes,storage,functions',

    [switch] $NonInteractive
)

$ErrorActionPreference = 'Stop'

$Root = Split-Path -Parent $PSScriptRoot
$DevProject = 'multichoice-app-develop'
$ProdProject = 'multichoice-412309'

function Show-Usage {
    Write-Host @"
Usage: deploy-firebase.ps1 <dev|prod|all> [options]

Deploy Firebase resources defined in firebase.json:
  - Cloud Functions (with predeploy lint + build)
  - Firestore rules and indexes
  - Storage rules

Options:
  -Only <targets>       firebase deploy --only value (default: firestore:rules,firestore:indexes,storage,functions)
  -NonInteractive        Pass --non-interactive to firebase deploy

Examples:
  .\scripts\deploy-firebase.ps1 dev
  .\scripts\deploy-firebase.ps1 prod -Only functions
  .\scripts\deploy-firebase.ps1 all -NonInteractive
"@
}

if (-not $Environment) {
    Write-Error 'Environment required: dev, prod, or all'
    Show-Usage
    exit 1
}

if (-not (Get-Command firebase -ErrorAction SilentlyContinue)) {
    Write-Error 'firebase CLI not found. Install with: npm install -g firebase-tools'
    exit 1
}

function Ensure-FunctionsDeps {
    $nodeModules = Join-Path $Root 'functions\node_modules'
    if (-not (Test-Path $nodeModules)) {
        Write-Host 'Installing functions dependencies...'
        npm --prefix (Join-Path $Root 'functions') ci
        if ($LASTEXITCODE -ne 0) { throw 'npm ci failed in functions/' }
    }
}

function Check-EnvFile {
    param([string] $ProjectId)
    $envFile = Join-Path $Root "functions\.env.$ProjectId"
    if (-not (Test-Path $envFile)) {
        Write-Warning "Missing $envFile"
        Write-Warning "Functions deploy needs EMAIL_USER and EMAIL_PASS for $ProjectId."
        Write-Warning 'See docs/firebase-functions-environments.md'
    }
}

function Deploy-Project {
    param(
        [string] $ProjectId,
        [string] $Label
    )

    Write-Host ''
    Write-Host "=== Deploying $Label ($ProjectId) ==="
    Check-EnvFile -ProjectId $ProjectId
    Ensure-FunctionsDeps

    $firebaseArgs = @(
        'deploy',
        '--only', $Only,
        '--project', $ProjectId
    )
    if ($NonInteractive) {
        $firebaseArgs += '--non-interactive'
    }

    Push-Location $Root
    try {
        & firebase @firebaseArgs
        if ($LASTEXITCODE -ne 0) {
            throw "firebase deploy failed for $ProjectId"
        }
    }
    finally {
        Pop-Location
    }
}

switch ($Environment) {
    'dev' { Deploy-Project -ProjectId $DevProject -Label 'DEV' }
    'prod' { Deploy-Project -ProjectId $ProdProject -Label 'PROD' }
    'all' {
        Deploy-Project -ProjectId $DevProject -Label 'DEV'
        Deploy-Project -ProjectId $ProdProject -Label 'PROD'
    }
}

Write-Host ''
Write-Host "Done. Deployed to: $Environment"
