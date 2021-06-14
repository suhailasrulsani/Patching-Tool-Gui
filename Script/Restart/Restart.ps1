Clear-Host
$ScriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$Servers = @(get-content -Path "$ScriptDir\servers.txt")

$Input_restart = Read-Host "Restart Server Now (y/n)"
    switch ($Input_restart) 
    {
        'y'
         {
            $Serverlist = @(get-content -Path "$ScriptDir\Servers.txt")
            Foreach ($Server in $Servers)
                {
                    Write-Host "Restarting $Server : " -NoNewline 
                    Try { Restart-Computer -ComputerName $Server -Force -ErrorAction Stop; Write-Host "Done" -ForegroundColor Green }
                    Catch { Write-Warning ($_); Continue }
                    Finally { $Error.Clear() }
                }
            }

        'n' 
        { 
            Continue
        }
        Default { Write-Warning "Invalid Input" }
    }
