<#
.SYNOPSIS
    Verifica que el entorno de este proyecto Cypress este correctamente instalado
    y, de no estarlo, instala lo que falte.

.DESCRIPTION
    Revisa, en orden, cada uno de estos pasos y ejecuta la instalacion
    correspondiente solo si detecta que falta:

        1. Node.js / npm disponibles          (prerrequisito, no se auto-instala)
        2. npm install                        (dependencias de package.json)
        3. npm install cypress / --save-dev   (paquete cypress en node_modules)
        4. npx cypress install                (binario de Cypress en cache)
        5. npm run cypress:open               (script "cypress:open" -> se ejecuta;
                                                 abre el Test Runner de Cypress en
                                                 modo interactivo)
#>

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

function Write-Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Write-Ok($msg)   { Write-Host "    [OK] $msg" -ForegroundColor Green }
function Write-Warn($msg) { Write-Host "    [!] $msg" -ForegroundColor Yellow }
function Write-Err($msg)  { Write-Host "    [ERROR] $msg" -ForegroundColor Red }

function Test-CommandExists($name) {
    return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

$failures = @()

# 1. Prerrequisitos: Node.js y npm ------------------------------------------------
Write-Step "Verificando Node.js y npm"
if (-not (Test-CommandExists "node")) {
    Write-Err "Node.js no esta instalado. Instalalo manualmente desde https://nodejs.org/ (v18+) y vuelve a ejecutar este script."
    exit 1
}
if (-not (Test-CommandExists "npm")) {
    Write-Err "npm no esta disponible en el PATH (deberia venir con Node.js)."
    exit 1
}
Write-Ok "Node $(node -v) / npm $(npm -v) detectados"

# 2. npm install --------------------------------------------------------------------
Write-Step "Verificando dependencias del proyecto (npm install)"
if (-not (Test-Path "node_modules")) {
    Write-Warn "No existe node_modules. Ejecutando 'npm install'..."
    npm install
    if ($LASTEXITCODE -ne 0) { $failures += "npm install" }
} else {
    Write-Ok "node_modules ya existe"
}

# 3. npm install cypress / npm install cypress --save-dev ---------------------------
Write-Step "Verificando paquete cypress en node_modules"
$cypressPkgPath = Join-Path "node_modules" "cypress"
if (-not (Test-Path $cypressPkgPath)) {
    Write-Warn "cypress no esta en node_modules. Instalando como devDependency ('npm install cypress --save-dev')..."
    npm install cypress --save-dev
    if ($LASTEXITCODE -ne 0) { $failures += "npm install cypress --save-dev" }
} else {
    Write-Ok "Paquete cypress ya instalado"
}

# 4. npx cypress install (binario) ---------------------------------------------------
Write-Step "Verificando binario de Cypress (npx cypress install)"
npx cypress install
if ($LASTEXITCODE -ne 0) {
    Write-Err "Fallo la descarga/instalacion del binario de Cypress"
    $failures += "npx cypress install"
} else {
    Write-Ok "Binario de Cypress disponible"
}

# 5. npm run cypress:open ---------------------------------------------------------------
Write-Step "Verificando script 'cypress:open' y ejecutandolo (npm run cypress:open)"
$pkg = Get-Content "package.json" -Raw | ConvertFrom-Json
if ($pkg.scripts."cypress:open") {
    npm run cypress:open
    if ($LASTEXITCODE -ne 0) {
        Write-Err "'npm run cypress:open' finalizo con errores"
        $failures += "npm run cypress:open"
    } else {
        Write-Ok "'npm run cypress:open' finalizo correctamente"
    }
} else {
    Write-Err "No existe un script 'cypress:open' en package.json"
    $failures += "cypress:open (script inexistente)"
}

# Resumen -------------------------------------------------------------------------------
Write-Host ""
if ($failures.Count -eq 0) {
    Write-Host "Todo verificado e instalado correctamente." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Se encontraron problemas en: $($failures -join ', ')" -ForegroundColor Red
    exit 1
}
