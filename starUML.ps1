#Requires -RunAsAdministrator

function Navigate-To {
    param (
        [string]$dir
    )
    
    if (!(Test-Path -Path $dir -PathType Container)) {
        Write-Host "Directory $dir not found! Please provide the correct path to the StarUML directory."
        exit 1
    }
    Set-Location -Path $dir
    Write-Host "[1] Navigated to $dir"
}


function Copy-Files {
    param (
        [string]$sourceDir,
        [string]$destinationDir
    )
    
    Write-Host "[5] Copying files from $sourceDir to $destinationDir..."
    Copy-Item -Path "$sourceDir\*" -Destination $destinationDir -Recurse -Force -ErrorAction Stop
}


function NPM-Check-And-Install {
    param (
        [string]$packageName
    )
    
    Write-Host "[2] Checking if $packageName is already installed..."
    
    if (!(Get-Command $packageName -ErrorAction SilentlyContinue)) {
        Write-Host "$packageName is not installed. Installing..."
        npm install -g $packageName -ErrorAction Stop
    }
}


function Extract-Asar {
    Write-Host "[3] Extracting app.asar..."xx
    & "asar" extract app.asar app
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to extract app.asar!"
        exit 1
    }
}


function Pack-Asar {
    Write-Host "[6] Packing app.asar..."
    & "asar" pack app app.asar
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Failed to pack app.asar!"
        exit 1
    }
}


function Check-Version {
    param (
        [string]$packageJsonPath,
        [string]$expectedVersion
    )
    
    if (Test-Path $packageJsonPath) {
        $jsonContent = Get-Content -Path $packageJsonPath -Raw | ConvertFrom-Json
        $version = $jsonContent.version
        Write-Host "[4] Checking StarUML version expected: $expectedVersion..."
        
        if ($version -ne $expectedVersion) {
            Write-Host "The version found in package.json is $version."
            $choice = Read-Host "Do you want to continue with the patch? (Y/N, default is Y)"
            if ($choice -match '^[Nn]') {
                Write-Host "Exiting."
                exit 1
            }
        }
    }
    else {
        Write-Host "package.json not found at $packageJsonPath!"
        exit 1
    }
}



# MAIN
$scriptDir = (Get-Location).Path

if ($args.Count -gt 0) {
    $starumlDir = $args[0]
} else {
    $starumlDir = Get-ChildItem -Path "C:\Program Files" -Recurse -Directory -Filter "StarUML" -ErrorAction SilentlyContinue | Select-Object -First 1
}

if (-not $starumlDir) {
    Write-Host "StarUML directory not found! Please provide the valid path to the StarUML editing $resourcesDir"
    exit 1
} else {
    Write-Host "StarUML directory provided: $starumlDir"
}



$resourcesDir = "C:\Program Files\StarUML\resources"

Navigate-To -dir $resourcesDir
NPM-Check-And-Install -packageName "asar"
Extract-Asar

Check-Version -packageJsonPath "$resourcesDir\app\package.json" -expectedVersion "6.3.0"

Copy-Files -sourceDir "$scriptDir\patch" -destinationDir "$resourcesDir\app\src\engine"
Pack-Asar

Write-Host "`nStarUML successfully patched!"
