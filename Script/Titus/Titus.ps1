Clear-Host
#region Variable
Get-PSSession | Remove-PSSession
Remove-Variable * -ErrorAction SilentlyContinue; $Error.Clear();
$ScriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$Servers = @(get-content -Path "$ScriptDir\Servers.txt")
$datetime = Get-Date -Format G
$dt = (Get-Date).ToString("ddMMyyyy_HHmmss")
Remove-Item -Path "$ScriptDir\TitusStatus.xlsx" -Force -ErrorAction SilentlyContinue
#endregion

#region Functions
Function Function_Zero
{
	notepad.exe "$ScriptDir\Servers.txt"
    Get-PSSession | Remove-PSSession
}

Function Function_One
{
    $Servers = @(get-content -Path "$ScriptDir\Servers.txt")
 
	foreach ($Server in $Servers)
    {
        Write-Host "Copying Installer and Cleanup Tool to $Server : " -NoNewline -ForegroundColor Cyan
        Try 
        { 
            New-Item -ItemType Directory -Path "\\$Server\c$\Patches" -Force -ErrorAction Stop | Out-Null
            New-Item -ItemType Directory -Path "\\$Server\c$\Patches\Titus" -Force -ErrorAction Stop | Out-Null
            Copy-Item "$ScriptDir\File\*" -Destination "\\$Server\c$\Patches\Titus" -Force -ErrorAction Stop | Out-Null
            Write-Host "Done" -ForegroundColor Green
        }

        Catch 
        {
            Write-Warning ($_.Exception.Message)
            Continue
        }
        
    }
}

Function Function_Two
{
	$Servers = @(get-content -Path "$ScriptDir\Servers.txt")
 
	foreach ($Server in $Servers)
    {
        Write-Host "`n"
        #region Establishing remote connection to $Server
        Write-Host "Establishing remote connection to $Server : " -NoNewline -ForegroundColor Cyan
        Try
        {
            $MySession = New-PSSession -ComputerName $Server -ErrorAction Stop
            Write-Host "Done" -ForegroundColor Green
        }
        
        Catch 
        {
            Write-Warning ($_.Exception.Message)
            Continue
        }
        #endregion  

        #region Remove
        #Write-Host "Removing Titus : " -NoNewline -ForegroundColor Cyan
        $MyCommands1 =
        {
            cd "c:\patches\titus"
            cmd.exe /c "TITUS-CleanupTool.exe /run"
        }

        Invoke-Command -Session $MySession -ScriptBlock $MyCommands1

        #region Restart
        $Input_restart = Read-Host "Do you want to restart the server now? (y/n)"
        switch ($Input_restart)
        {
            'y'
            {
                Write-Host "Restarting $Server : " -NoNewline
                Try { Restart-Computer -ComputerName $Server -Force -ErrorAction Stop; Write-Host "Done" -ForegroundColor Green }
                Catch { Write-Warning ($_); Continue }
                Finally { $Error.Clear() }
            }

            'n'
            {
                Continue
            }

            Default { Write-Warning "Invalid Input" }
        }
        #endregion Restart

        Get-PSSession | Remove-PSSession
        #endregion
    }
}

Function Function_Three
{
	$Servers = @(get-content -Path "$ScriptDir\Servers.txt")
 
	foreach ($Server in $Servers)
    {
        Write-Host "`n"
        #region Establishing remote connection to $Server
        Write-Host "Establishing remote connection to $Server : " -NoNewline -ForegroundColor Cyan
        Try
        {
            $MySession = New-PSSession -ComputerName $Server -ErrorAction Stop
            Write-Host "Done" -ForegroundColor Green
        }
        
        Catch 
        {
            Write-Warning ($_.Exception.Message)
            Continue
        }
        #endregion  

        #region Check for server OS architecture
        $MyCommands1 =
        {
            Write-Host "Checking OS Architecture : " -NoNewline -ForegroundColor Cyan
            $OS = (Get-WmiObject Win32_OperatingSystem).OsArchitecture
            If ($OS -eq "64-bit")
            {
                Write-Host "64bit" -ForegroundColor Green
                
                #region Check office bitness
                Write-Host "Checking Office Bitness : " -NoNewline -ForegroundColor Cyan
                Try
                {
                    $Bitness = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\16.0\Outlook" -ErrorAction Stop).Bitness
                    If ($Bitness -eq "x64")
                    {
                        Write-Host "64bit" -ForegroundColor Green

                        #region Installing VC_redist.x64 and VC_redist.x86
                        Write-Host "Installing VC_redist.x64.exe and VC_redist.x86.exe : " -NoNewline -ForegroundColor Cyan
                        cd "C:\Patches\Titus\"
                        cmd.exe /c "VC_redist.x64.exe /q /norestart" > $null 2>&1
                        cmd.exe /c "VC_redist.x86.exe /q /norestart" > $null 2>&1
                        Write-Host "Done" -ForegroundColor Green
                        #endregion Installing VC_redist.x64 and VC_redist.x86

                        #region Installing Titus
                        Write-Host "Installing Titus : " -NoNewline -ForegroundColor Cyan
                        cd "C:\Patches\Titus\"
                        cmd.exe /c "msiexec.exe /i TITUS_Classification_Setup_x64.msi INSTALLCLIENT_TMC=0 INSTALLCLIENT_TCO=1 INSTALLCLIENT_TCD=1 OUTLOOK_BITNESS=x64 OFFICE_BITNESS=x64 CONFIGURATIONFILE=https://hkdc2vmtt02.globalnet.lcl/TITUS.prod.tcpg CONFIGLOCATION=https://hkdc2vmtt02.globalnet.lcl/TITUS.prod.tcpg COLLECTORLOCATION=https://hkdc2vmtt02.globalnet.lcl  /qn" > $null 2>&1
                        Write-Host "Done" -ForegroundColor Green
                        #endregion Installing Titus

                        #region Restarting explorer and Titus.Enterprise.Client.Service
                        Write-Host "Restarting Explorer : " -NoNewline -ForegroundColor Cyan
                        Write-Host "Done" -ForegroundColor Green
                        Write-Host "Restarting Titus.Enterprise.Client.Service : " -NoNewline -ForegroundColor Cyan
                        Try
                        {
                            Restart-Service -Name Titus.Enterprise.Client.Service -Force -ErrorAction Stop
                            Write-Host "Done" -ForegroundColor Green
                        }

                        Catch
                        {
                            Write-Warning ($_.Exception.Message)
                        }
                        #endregion Restarting explorer and Titus.Enterprise.Client.Service
                    }

                    ElseIf ($Bitness -eq "x86")
                    {
                        Write-Host "32bit" -ForegroundColor Green

                        #region Installing VC_redist.x64 and VC_redist.x86
                        Write-Host "Installing VC_redist.x86.exe and VC_redist.x64.exe : " -NoNewline -ForegroundColor Cyan
                        cd "C:\Patches\Titus\"
                        cmd.exe /c "VC_redist.x86.exe /q /norestart" > $null 2>&1
                        cmd.exe /c "VC_redist.x64.exe /q /norestart" > $null 2>&1
                        Write-Host "Done" -ForegroundColor Green
                        #endregion Installing VC_redist.x64 and VC_redist.x86

                        #region Installing Titus
                        Write-Host "Installing Titus : " -NoNewline -ForegroundColor Cyan
                        cd "C:\Patches\Titus\"
                        cmd.exe /c "msiexec.exe /i TITUS_Classification_Setup_x64.msi INSTALLCLIENT_TMC=0 INSTALLCLIENT_TCO=0 INSTALLCLIENT_TCD=1 OUTLOOK_BITNESS=x86 OFFICE_BITNESS=x86 CONFIGURATIONFILE=https://hkdc2vmtt02.globalnet.lcl/TITUS.prod.tcpg CONFIGLOCATION=https://hkdc2vmtt02.globalnet.lcl/TITUS.prod.tcpg COLLECTORLOCATION=https://hkdc2vmtt02.globalnet.lcl /qn" > $null 2>&1
                        cmd.exe /c "msiexec.exe /i TITUS_Classification_Setup_x86.msi INSTALLCLIENT_TMC=0 INSTALLCLIENT_TCO=1 INSTALLCLIENT_TCD=0 OUTLOOK_BITNESS=x86 OFFICE_BITNESS=x86 /qn" > $null 2>&1
                        Write-Host "Done" -ForegroundColor Green
                        #endregion Installing Titus

                        #region Restarting explorer and Titus.Enterprise.Client.Service
                        Write-Host "Restarting Explorer : " -NoNewline -ForegroundColor Cyan
                        Write-Host "Done" -ForegroundColor Green
                        Write-Host "Restarting Titus.Enterprise.Client.Service : " -NoNewline -ForegroundColor Cyan
                        Try
                        {
                            Restart-Service -Name Titus.Enterprise.Client.Service -Force -ErrorAction Stop
                            Write-Host "Done" -ForegroundColor Green
                        }

                        Catch
                        {
                            Write-Warning ($_.Exception.Message)
                        }
                        #endregion Restarting explorer and Titus.Enterprise.Client.Service
                    }
                }

                Catch
                {
                    Write-Warning ($_.Exception.Message)
                }
                #endregion   
            }

            ElseIf ($OS -eq "32-bit")
            {
                Write-Host "32bit" -ForegroundColor Green

                #region Check office bitness
                Write-Host "Checking Office Bitness : " -NoNewline -ForegroundColor Cyan
                Try
                {
                    $Bitness = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Office\16.0\Outlook" -ErrorAction Stop).Bitness
                    If ($Bitness -eq "x86")
                    {
                        Write-Host "32bit" -ForegroundColor Green

                        #region Installing VC_redist.x86
                        Write-Host "Installing VC_redist.x86.exe : " -NoNewline -ForegroundColor Cyan
                        cd "C:\Patches\Titus\"
                        cmd.exe /c "VC_redist.x86.exe /q /norestart" > $null 2>&1
                        Write-Host "Done" -ForegroundColor Green
                        #endregion Installing VC_redist.x86

                        #region Installing Titus
                        Write-Host "Installing Titus : " -NoNewline -ForegroundColor Cyan
                        cd "C:\Patches\Titus\"
                        cmd.exe /c "msiexec.exe /i TITUS_Classification_Setup_x86.msi INSTALLCLIENT_TMC=0 INSTALLCLIENT_TCO=1 INSTALLCLIENT_TCD=1 OUTLOOK_BITNESS=x86 OFFICE_BITNESS=x86 CONFIGURATIONFILE=https://hkdc2vmtt02.globalnet.lcl/TITUS.prod.tcpg CONFIGLOCATION=https://hkdc2vmtt02.globalnet.lcl/TITUS.prod.tcpg COLLECTORLOCATION=https://hkdc2vmtt02.globalnet.lcl  /qn" > $null 2>&1
                        Write-Host "Done" -ForegroundColor Green
                        #endregion Installing Titus

                        #region Restarting explorer and Titus.Enterprise.Client.Service
                        Write-Host "Restarting Explorer : " -NoNewline -ForegroundColor Cyan
                        Write-Host "Done" -ForegroundColor Green
                        Write-Host "Restarting Titus.Enterprise.Client.Service : " -NoNewline -ForegroundColor Cyan
                        Try
                        {
                            Restart-Service -Name Titus.Enterprise.Client.Service -Force -ErrorAction Stop
                            Write-Host "Done" -ForegroundColor Green
                        }

                        Catch
                        {
                            Write-Warning ($_.Exception.Message)
                        }
                        #endregion Restarting explorer and Titus.Enterprise.Client.Service
                    }
                }

                Catch
                {
                    Write-Warning ($_.Exception.Message)
                }
                #endregion
            }
        }

        Invoke-Command -Session $MySession -ScriptBlock $MyCommands1

        Get-PSSession | Remove-PSSession
        #endregion
    }
}

Function Function_Four
{
	$Servers = @(get-content -Path "$ScriptDir\Servers.txt")
    $Results1 = Foreach ($Server in $Servers)
    {
        Try
        {
            $MySession = New-PSSession -ComputerName $Server -ErrorAction Stop
            $MyCommands1 =
            {
                #region Checking Version
                $PathVersion = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
                $PathVersion2 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
                $Installed1 = Get-ChildItem -Path $PathVersion | ForEach { Get-ItemProperty $_.PSPath } | Where-Object { $_.Publisher -like "*Titus Inc. (http://www.titus.com)*" }
                $Installed2 = Get-ChildItem -Path $PathVersion2 | ForEach { Get-ItemProperty $_.PSPath } | Where-Object { $_.Publisher -like "*Titus Inc. (http://www.titus.com)*" }

                If ($Installed1) { $Version = ($Installed1).Displayversion }
                ElseIf ($Installed2) { $Version = ($Installed2).Displayversion }
                Else { $Version = "False" }

                If ($Version -eq "20.3.2048.1")
                {
                    $Version1 = "20.3.2048.1"
                }

                Else
                {
                    $Version1 = "Incorrect"
                }
                #endregion Checking Version

                [PSCustomObject]@{
                Server = $env:COMPUTERNAME
                Status = 'Success'
                Version = $Version1
                }
            }
            Invoke-Command -Session $MySession -ScriptBlock $MyCommands1
        }

        Catch
        {
            [PSCustomObject]@{
            Server = $Server
            Status = 'Fail'
            Version = $null
            }
        }
    }

    $ConditionalFormat =$(
    New-ConditionalText -Text Fail -Range 'B:B' -BackgroundColor Red -ConditionalTextColor Black
    New-ConditionalText -Text Incorrect -Range 'C:C' -BackgroundColor Red -ConditionalTextColor Black
)

$results1 | Select-Object Server, Status, Version | Export-Excel -Path "$ScriptDir\TitusStatus.xlsx" -AutoSize -TableName "TitusStatus" -WorksheetName "TitusStatus" -ConditionalFormat $ConditionalFormat -Show -Activate
Get-PSSession | Remove-PSSession
}

Function Function_Five
{
	$Servers = @(get-content -Path "$ScriptDir\Servers.txt")
    Foreach ($Server in $Servers)
    {
        Write-Host "Removing C:\Patches\Titus\ in $Server : " -NoNewline -ForegroundColor Cyan
        Try
        {
            Remove-Item -Path "\\$Server\c$\Patches\Titus\" -Recurse -Force -ErrorAction Stop
            Write-Host "Done" -ForegroundColor Green
        }
        
        Catch
        {
            Write-Warning ($_.Exception.Message)
        }    
    }
}
#endregion Functions

#region Menu
function Show-Menu
{
	param ([string]$Title = 'Menu')
	Clear-Host
	Write-Host "Please select"
	Write-Host "`n"
    Write-Host " 0 - Load Server List"
	Write-Host " 1 - Copy installer and cleanup tool"
	Write-Host " 2 - Remove"
    Write-Host " 3 - Install"
    Write-Host " 4 - Verify Installation"
    Write-Host " 5 - Cleanup"
	Write-Host "`n"
	Write-Host " [Q] Exit"
	Write-Host "`n"
}

Do
{
	Show-Menu
	Write-Host "Please make a selection: " -ForegroundColor Yellow -NoNewline
	$input = Read-Host
	Write-Host "`n"
	switch ($input)
	{
        '0' { Function_Zero }
		'1' { Function_One }
		'2' { Function_Two }
        '3' { Function_Three }
        '4' { Function_Four }
        '5' { Function_Five }
		'q' { Write-Host "The script has been canceled" -BackgroundColor Red -ForegroundColor White }
		Default { Write-Host "Your selection = $input, is not valid. Please try again." -BackgroundColor Red -ForegroundColor White }
	}
	pause
}
until ($input -eq 'q')
Get-PSSession | Remove-PSSession
#endregion Menu