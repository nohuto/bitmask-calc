#    Powershell - Bitwise Operation Examples
#    Copyright (C) 2025 Noverse
#
#    This program is proprietary software: you may not copy, redistribute, or modify
#    it in any way without prior written permission from Noverse.
#
#    Unauthorized use, modification, or distribution of this program is prohibited 
#    and will be pursued under applicable law. This software is provided "as is," 
#    without warranty of any kind, express or implied, including but not limited to 
#    the warranties of merchantability, fitness for a particular purpose, and 
#    non-infringement.
#
#    For permissions or inquiries, contact: https://discord.gg/E2ybG4j9jU

$nv = "Authored by Noxi-Hu - (C) 2025 Noverse"
sv -Scope Global -Name "erroractionpreference" -Value "stop"
sv -Scope Global -Name "progresspreference" -Value "silentlycontinue"
iwr 'https://github.com/5Noxi/5Noxi/releases/download/Logo/nvbanner.ps1' -o "$env:temp\nvbanner.ps1";. $env:temp\nvbanner.ps1
$host.UI.RawUI.BackgroundColor='Black'
$host.UI.RawUI.WindowTitle='Noverse Bitwise Operation Examples'
clear
bannercyan
Write-Host " Input path or string:"
Write-Host " >> " -NoNewline -ForegroundColor Blue
$nvi = Read-Host
echo ""
# would use eg write-host as path if not tested
if ($nvi -match '\\') {$lines = Get-Content $nvi} else {$lines = @($nvi)}
Write-Host " Output path:"
Write-Host " >> " -NoNewline -ForegroundColor Blue
$nvo = Read-Host
echo ""
Write-Host " Bitwise operator:"
$bitops = @("band", "bor", "bxor", "bnot", "shl", "shr")
for ($i = 0; $i -lt $bitops.Length; $i++) {Write-Host -NoNewline " [";Write-Host ($i + 1) -NoNewline -ForegroundColor Blue;Write-Host "] $($bitops[$i])"}
Write-Host " >> " -ForegroundColor Blue -NoNewline
$choice = Read-Host
$op = $bitops[$choice - 1]
$rnd = New-Object System.Random
$changed = @()
foreach ($line in $lines) {
    $obf = $line.ToCharArray() | % {
        $ascii = [int][char]$_
        $expr = $null
        while (-not $expr) {
            $mask = $rnd.Next($ascii, [int]::MaxValue)
            switch ($op) {
                'band' {if (($ascii -band $mask) -eq $ascii) {$expr = "([char]($ascii -band $mask))"}}
                'bor'  {$bor = $rnd.Next(1, 256); if (($ascii -bor $bor) -eq $ascii) {$expr = "([char]($ascii -bor $bor))"}}
                'bxor' {$key = $rnd.Next(1, 256); $obf = $ascii -bxor $key; if (($obf -bxor $key) -eq $ascii) {$expr = "([char]($obf -bxor $key))"}}
                'shl'  {$shift = $rnd.Next(1, 4); $obf = $ascii -shr $shift; if (($obf -shl $shift) -eq $ascii) {$expr = "([char](($obf -shl $shift)))"}}
                'shr'  {$shift = $rnd.Next(1, 4); $obf = $ascii -shl $shift; if (($obf -shr $shift) -eq $ascii) {$expr = "([char](($obf -shr $shift)))"}}
                'bnot' {$num = -($ascii +1);$expr = "([char](-bnot $num))"} # most simple way of doing it
            }
        }
        if (-not $expr) {Write-Host "Failed" -ForegroundColor Red}
        $expr
    }
    # &([char]105+[char]101+[char]120) is the same as iex
    $content = "&([char]105+[char]101+[char]120)("+($obf -join '+')+")"
    $changed += $content
}

bannercyan
if ($nvo) {sc -Path $nvo -Value $changed
Write-Host " Saved" -ForegroundColor Green -NoNewline
Write-Host " - $nvo" -ForegroundColor DarkGray} else {
echo ""
Write-Host "$changed" -ForegroundColor Yellow}
echo ""
Write-Host " Press any key to exit" -ForegroundColor DarkGray
[system.console]::readkey($true) | Out-Null;exit