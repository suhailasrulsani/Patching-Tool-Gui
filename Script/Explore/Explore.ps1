$ScriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$Servers = @(Get-Content -Path "$ScriptDir\servers.txt")

Foreach ($Server in $Servers)
{
        Write-Host "Opening C:\patches at $Server : " -NoNewline
        try { Invoke-Item \\$Server\c$ -ErrorAction Stop; Write-Host "Done" -ForegroundColor Green }
        catch { Write-Warning ($_); Continue }
        Finally { $Error.Clear() }
}
pause
