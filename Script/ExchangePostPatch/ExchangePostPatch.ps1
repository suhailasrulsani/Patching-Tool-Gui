Clear-Host
$ScriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$Servers = @(Get-Content -Path "$ScriptDir\servers.txt")

Foreach ($Server in $Servers)
{
    Write-Host "`n"
    Write-Host "$Server : " -NoNewline
    Try
    {
        $Session = New-PSSession -ComputerName $Server -ErrorAction Stop
        $MyCommands =
        {
            Try
            {
            cd "C:\Patches\Script\ExchangePostPatch" -ErrorAction Stop
            powershell.exe -NoProfile -NoLogo -NonInteractive -ExecutionPolicy Bypass -File .\ExchangePostPatch.ps1
            }

            Catch
            {
                Write-Warning ($_)
            }
        }

        Try
        {
            Invoke-Command -Session $Session -ScriptBlock $MyCommands -ErrorAction Stop
        }

        Catch
        {
            Write-Warning ($_)
        }
    }

    Catch
    {
        Write-Warning ($_)
    }
}

Pause