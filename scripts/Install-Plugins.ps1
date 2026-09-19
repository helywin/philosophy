$ErrorActionPreference = 'Stop'
$vaultRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$lockPath = Join-Path $vaultRoot '.obsidian/plugins.lock.json'
$plugins = Get-Content -LiteralPath $lockPath -Raw -Encoding utf8 | ConvertFrom-Json
foreach ($plugin in $plugins) {
    if ($plugin.id -notmatch '^[a-z0-9-]+$') { throw 'Invalid plugin ID' }
    $directory = Join-Path $vaultRoot ".obsidian/plugins/$($plugin.id)"
    New-Item -ItemType Directory -Path $directory -Force | Out-Null
    foreach ($asset in $plugin.files) {
        if ($asset.name -notin @('main.js', 'manifest.json', 'styles.css')) { throw 'Unexpected asset name' }
        $uri = [uri]$asset.url
        if ($uri.Scheme -ne 'https' -or $uri.Host -ne 'github.com') { throw 'Unexpected download source' }
        $target = Join-Path $directory $asset.name
        if ((Test-Path -LiteralPath $target) -and ((Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash -eq $asset.sha256)) {
            continue
        }
        $temporary = "$target.download"
        Invoke-WebRequest -Uri $asset.url -OutFile $temporary
        if ((Get-FileHash -LiteralPath $temporary -Algorithm SHA256).Hash -ne $asset.sha256) {
            Remove-Item -LiteralPath $temporary
            throw "SHA-256 mismatch: $($plugin.id)/$($asset.name)"
        }
        Move-Item -LiteralPath $temporary -Destination $target -Force
    }
    $manifest = Get-Content -LiteralPath (Join-Path $directory 'manifest.json') -Raw -Encoding utf8 | ConvertFrom-Json
    if ($manifest.id -ne $plugin.id -or $manifest.version -ne $plugin.version) { throw 'Plugin manifest mismatch' }
    Write-Host "$($plugin.name) $($manifest.version): installed and verified"
}
$themeLockPath = Join-Path $vaultRoot '.obsidian/themes.lock.json'
if (Test-Path -LiteralPath $themeLockPath) {
    $themes = Get-Content -LiteralPath $themeLockPath -Raw -Encoding utf8 | ConvertFrom-Json
    foreach ($theme in $themes) {
        if ($theme.name -notmatch '^[a-zA-Z0-9 -]+$') { throw 'Invalid theme name' }
        $directory = Join-Path $vaultRoot ".obsidian/themes/$($theme.name)"
        New-Item -ItemType Directory -Path $directory -Force | Out-Null
        foreach ($asset in $theme.files) {
            if ($asset.name -notin @('theme.css', 'manifest.json')) { throw 'Unexpected theme asset' }
            $uri = [uri]$asset.url
            if ($uri.Scheme -ne 'https' -or $uri.Host -ne 'github.com') { throw 'Unexpected theme source' }
            $target = Join-Path $directory $asset.name
            if ((Test-Path -LiteralPath $target) -and ((Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash -eq $asset.sha256)) { continue }
            $temporary = "$target.download"
            Invoke-WebRequest -Uri $asset.url -OutFile $temporary
            if ((Get-FileHash -LiteralPath $temporary -Algorithm SHA256).Hash -ne $asset.sha256) {
                Remove-Item -LiteralPath $temporary
                throw "Theme SHA-256 mismatch: $($asset.name)"
            }
            Move-Item -LiteralPath $temporary -Destination $target -Force
        }
        $manifest = Get-Content -LiteralPath (Join-Path $directory 'manifest.json') -Raw -Encoding utf8 | ConvertFrom-Json
        if ($manifest.name -ne $theme.name -or $manifest.version -ne $theme.version) { throw 'Theme manifest mismatch' }
        Write-Host "$($theme.name) $($manifest.version): installed and verified"
    }
}
Write-Host 'Open or reload this vault in Obsidian to load the plugins and theme.'
