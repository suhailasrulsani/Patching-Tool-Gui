$ScriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# Hide PowerShell Console
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 0)

Function Cleantxt
{
    Clear-Content -Path "$ScriptDir\Script\Ping\servers.txt" -Force
    Clear-Content -Path "$ScriptDir\Script\Uptime\servers.txt" -Force
    Clear-Content -Path "$ScriptDir\Script\StartAutoService\servers.txt" -Force
    Clear-Content -Path "$ScriptDir\Script\ExchangePostPatch\servers.txt" -Force
    Clear-Content -Path "$ScriptDir\Script\SQLPostPatch\servers.txt" -Force
    Clear-Content -Path "$ScriptDir\Script\Globalnet\servers.txt" -Force
    Clear-Content -Path "$ScriptDir\Script\Rge\servers.txt" -Force
    Clear-Content -Path "$ScriptDir\Script\AV\servers.txt" -Force
    Clear-Content -Path "$ScriptDir\Script\Logoff\servers.txt" -Force
    Clear-Content -Path "$ScriptDir\Script\CheckTitusService\servers.txt" -Force
    Clear-Content -Path "$ScriptDir\Script\CheckDLPServiceRunOnly\servers.txt" -Force
    Clear-Content -Path "$ScriptDir\Script\Restart\servers.txt" -Force
    Clear-Content -Path "$ScriptDir\Script\Explore\servers.txt" -Force
}

Add-Type -AssemblyName System.Windows.Forms
 
 #region Form
$Form = New-Object system.Windows.Forms.Form
$Form.Text = "Patching Team"
$Form.TopMost = $true
$Form.Width = 630
$Form.Height = 300
$Form.FormBorderStyle = "Fixed3D"
$form.StartPosition = "centerScreen"
$form.ShowInTaskbar = $true
 #endregion Form

#region ServerList_Label
$label3 = New-Object system.windows.Forms.Label
$label3.Text = "SERVER LIST"
$label3.AutoSize = $true
$label3.Width = 25
$label3.Height = 10
$label3.location = new-object system.drawing.point(10, 19)
$label3.Font = "Trebuchet MS,10,style=Bold"
$Form.controls.Add($label3)
#endregion ServerList_Label


#region Report_Label
$label3 = New-Object system.windows.Forms.Label
$label3.Text = "REPORT"
$label3.AutoSize = $true
$label3.Width = 25
$label3.Height = 10
$label3.location = new-object system.drawing.point(273, 19)
$label3.Font = "Trebuchet MS,10,style=Bold"
$Form.controls.Add($label3)
#endregion Report_Label


#region RDP_Label
$label3 = New-Object system.windows.Forms.Label
$label3.Text = "RDP"
$label3.AutoSize = $true
$label3.Width = 25
$label3.Height = 10
$label3.location = new-object system.drawing.point(370, 19)
$label3.Font = "Trebuchet MS,10,style=Bold"
$Form.controls.Add($label3)
#endregion RDP_Label

#region Tools_Label
$label3 = New-Object system.windows.Forms.Label
$label3.Text = "Tools"
$label3.AutoSize = $true
$label3.Width = 25
$label3.Height = 10
$label3.location = new-object system.drawing.point(460, 19)
$label3.Font = "Trebuchet MS,10,style=Bold"
$Form.controls.Add($label3)
#endregion Tools_Label

#region TextBox
$InputBox = New-Object system.windows.Forms.TextBox
$InputBox.Multiline = $true
$InputBox.BackColor = "#A7D4F7"
$InputBox.Width = 150
$InputBox.Height = 200
$InputBox.ScrollBars = "Vertical"
$InputBox.location = new-object system.drawing.point(10, 40)
$InputBox.Font = "Trebuchet MS,10,style=Bold"
$Form.controls.Add($inputbox)
#endregion TextBox

#BUTTON COLUMN 1
#region Ping_Button
$Pingbutton = New-Object system.windows.Forms.Button
$Pingbutton.BackColor = "#5bd22c"
$Pingbutton.Text = "Ping"
$Pingbutton.Width = 80
$Pingbutton.Height = 40
$Pingbutton.location = new-object system.drawing.point(170, 40)
$Pingbutton.Font = "Trebuchet MS,8,style=bold"
$Pingbutton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 36)
$Pingbutton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$Pingbutton.Cursor = [System.Windows.Forms.Cursors]::Hand
$Pingbutton.Add_Click( { pingInfo }) 
$Form.controls.Add($Pingbutton)
#endregion Ping_Button

#region Uptime_Button
$Uptimebutton = New-Object system.windows.Forms.Button
$Uptimebutton.BackColor = "#5bd22c"
$Uptimebutton.Text = "Uptime"
$Uptimebutton.Width = 80
$Uptimebutton.Height = 40
$Uptimebutton.location = new-object system.drawing.point(170, 80)
$Uptimebutton.Font = "Trebuchet MS,8,style=bold"
$Uptimebutton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 36)
$Uptimebutton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$Uptimebutton.Cursor = [System.Windows.Forms.Cursors]::Hand
$Uptimebutton.Add_Click( { UptimeInfo }) 
$Form.controls.Add($Uptimebutton)
#endregion Uptime_Button

#region StartAutoService_Button
$StartAutoServicebutton = New-Object system.windows.Forms.Button
$StartAutoServicebutton.BackColor = "#5bd22c"
$StartAutoServicebutton.Text = "Start Auto Service"
$StartAutoServicebutton.Width = 80
$StartAutoServicebutton.Height = 40
$StartAutoServicebutton.location = new-object system.drawing.point(170, 120)
$StartAutoServicebutton.Font = "Trebuchet MS,8,style=bold"
$StartAutoServicebutton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 36)
$StartAutoServicebutton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$StartAutoServicebutton.Cursor = [System.Windows.Forms.Cursors]::Hand
$StartAutoServicebutton.Add_Click( { StartAutoServiceInfo }) 
$Form.controls.Add($StartAutoServicebutton)
#endregion StartAutoService_Button

#region Logoff_Button
$Logoffbutton = New-Object system.windows.Forms.Button
$Logoffbutton.BackColor = "#5bd22c"
$Logoffbutton.Text = "Logoff"
$Logoffbutton.Width = 80
$Logoffbutton.Height = 40
$Logoffbutton.location = new-object system.drawing.point(170, 160)
$Logoffbutton.Font = "Trebuchet MS,8,style=bold"
$Logoffbutton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 36)
$Logoffbutton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$Logoffbutton.Cursor = [System.Windows.Forms.Cursors]::Hand
$Logoffbutton.Add_Click( { LogoffInfo }) 
$Form.controls.Add($Logoffbutton)
#endregion Logoff_Button

#region Explore_Button
$Explorebutton = New-Object system.windows.Forms.Button
$Explorebutton.BackColor = "#5bd22c"
$Explorebutton.Text = "Explore"
$Explorebutton.Width = 80
$Explorebutton.Height = 40
$Explorebutton.location = new-object system.drawing.point(170, 200)
$Explorebutton.Font = "Trebuchet MS,8,style=bold"
$Explorebutton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 36)
$Explorebutton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$Explorebutton.Cursor = [System.Windows.Forms.Cursors]::Hand
$Explorebutton.Add_Click( { ExploreInfo }) 
$Form.controls.Add($Explorebutton)
#endregion Explore_Button

#BUTTON COLUMN 2
#region ExchangePostPatch_Button
$ExchangePostPatchbutton = New-Object system.windows.Forms.Button
$ExchangePostPatchbutton.BackColor = "#5bd22c"
$ExchangePostPatchbutton.Text = "Exchange Post Patch"
$ExchangePostPatchbutton.Width = 80
$ExchangePostPatchbutton.Height = 40
$ExchangePostPatchbutton.location = new-object system.drawing.point(260, 40)
$ExchangePostPatchbutton.Font = "Trebuchet MS,8,style=bold"
$ExchangePostPatchbutton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 36)
$ExchangePostPatchbutton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$ExchangePostPatchbutton.Cursor = [System.Windows.Forms.Cursors]::Hand
$ExchangePostPatchbutton.Add_Click( { ExchangePostPatchInfo }) 
$Form.controls.Add($ExchangePostPatchbutton)
#endregion ExchangePostPatch_Button

#region SQLPostPatch_Button
$SQLPostPatchbutton = New-Object system.windows.Forms.Button
$SQLPostPatchbutton.BackColor = "#5bd22c"
$SQLPostPatchbutton.Text = "SQL Post Patch"
$SQLPostPatchbutton.Width = 80
$SQLPostPatchbutton.Height = 40
$SQLPostPatchbutton.location = new-object system.drawing.point(260, 80)
$SQLPostPatchbutton.Font = "Trebuchet MS,8,style=bold"
$SQLPostPatchbutton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 36)
$SQLPostPatchbutton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$SQLPostPatchbutton.Cursor = [System.Windows.Forms.Cursors]::Hand
$SQLPostPatchbutton.Add_Click( { SQLPostPatchInfo }) 
$Form.controls.Add($SQLPostPatchbutton)
#endregion SQLPostPatch_Button

#region TitusService_Button
$TitusServicebutton = New-Object system.windows.Forms.Button
$TitusServicebutton.BackColor = "#5bd22c"
$TitusServicebutton.Text = "Titus Service"
$TitusServicebutton.Width = 80
$TitusServicebutton.Height = 40
$TitusServicebutton.location = new-object system.drawing.point(260, 120)
$TitusServicebutton.Font = "Trebuchet MS,8,style=bold"
$TitusServicebutton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 36)
$TitusServicebutton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$TitusServicebutton.Cursor = [System.Windows.Forms.Cursors]::Hand
$TitusServicebutton.Add_Click( { TitusServiceInfo }) 
$Form.controls.Add($TitusServicebutton)
#endregion TitusService_Button

#region DLPService_Button
$DLPServicebutton = New-Object system.windows.Forms.Button
$DLPServicebutton.BackColor = "#5bd22c"
$DLPServicebutton.Text = "DLP Service"
$DLPServicebutton.Width = 80
$DLPServicebutton.Height = 40
$DLPServicebutton.location = new-object system.drawing.point(260, 160)
$DLPServicebutton.Font = "Trebuchet MS,8,style=bold"
$DLPServicebutton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 36)
$DLPServicebutton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$DLPServicebutton.Cursor = [System.Windows.Forms.Cursors]::Hand
$DLPServicebutton.Add_Click( { DLPServiceInfo }) 
$Form.controls.Add($DLPServicebutton)
#endregion DLPService_Button

#BUTTON COLUMN 3
#region GLOBALNET_Button
$GLOBALNETbutton = New-Object system.windows.Forms.Button
$GLOBALNETbutton.BackColor = "#5bd22c"
$GLOBALNETbutton.Text = "GLOBALNET"
$GLOBALNETbutton.Width = 80
$GLOBALNETbutton.Height = 40
$GLOBALNETbutton.location = new-object system.drawing.point(350, 40)
$GLOBALNETbutton.Font = "Trebuchet MS,8,style=bold"
$GLOBALNETbutton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 36)
$GLOBALNETbutton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$GLOBALNETbutton.Cursor = [System.Windows.Forms.Cursors]::Hand
$GLOBALNETbutton.Add_Click( { GLOBALNETInfo }) 
$Form.controls.Add($GLOBALNETbutton)
#endregion GLOBALNET_Button

#region RGE_Button
$RGEbutton = New-Object system.windows.Forms.Button
$RGEbutton.BackColor = "#5bd22c"
$RGEbutton.Text = "RGE"
$RGEbutton.Width = 80
$RGEbutton.Height = 40
$RGEbutton.location = new-object system.drawing.point(350, 80)
$RGEbutton.Font = "Trebuchet MS,8,style=bold"
$RGEbutton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 36)
$RGEbutton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$RGEbutton.Cursor = [System.Windows.Forms.Cursors]::Hand
$RGEbutton.Add_Click( { RGEInfo }) 
$Form.controls.Add($RGEbutton)
#endregion RGE_Button

#region AV_Button
$AVbutton = New-Object system.windows.Forms.Button
$AVbutton.BackColor = "#5bd22c"
$AVbutton.Text = "AV"
$AVbutton.Width = 80
$AVbutton.Height = 40
$AVbutton.location = new-object system.drawing.point(350, 120)
$AVbutton.Font = "Trebuchet MS,8,style=bold"
$AVbutton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 36)
$AVbutton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$AVbutton.Cursor = [System.Windows.Forms.Cursors]::Hand
$AVbutton.Add_Click( { AVInfo }) 
$Form.controls.Add($AVbutton)
#endregion AV_Button

#BUTTON COLUMN 4
#region Titus_Button
$Titusbutton = New-Object system.windows.Forms.Button
$Titusbutton.BackColor = "#5bd22c"
$Titusbutton.Text = "Titus"
$Titusbutton.Width = 80
$Titusbutton.Height = 40
$Titusbutton.location = new-object system.drawing.point(440, 40)
$Titusbutton.Font = "Trebuchet MS,8,style=bold"
$Titusbutton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 36)
$Titusbutton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$Titusbutton.Cursor = [System.Windows.Forms.Cursors]::Hand
$Titusbutton.Add_Click( { TitusInfo }) 
$Form.controls.Add($Titusbutton)
#endregion Titus_Button

#region DLP_Button
$DLPbutton = New-Object system.windows.Forms.Button
$DLPbutton.BackColor = "#5bd22c"
$DLPbutton.Text = "DLP"
$DLPbutton.Width = 80
$DLPbutton.Height = 40
$DLPbutton.location = new-object system.drawing.point(440, 80)
$DLPbutton.Font = "Trebuchet MS,8,style=bold"
$DLPbutton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 36)
$DLPbutton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$DLPbutton.Cursor = [System.Windows.Forms.Cursors]::Hand
$DLPbutton.Add_Click( { DLPInfo }) 
$Form.controls.Add($DLPbutton)
#endregion DLP_Button

#BUTTON COLUMN 5
#region Restart_Button
$Restartbutton = New-Object system.windows.Forms.Button
$Restartbutton.BackColor = "#5bd22c"
$Restartbutton.Text = "Restart"
$Restartbutton.Width = 80
$Restartbutton.Height = 40
$Restartbutton.location = new-object system.drawing.point(530, 40)
$Restartbutton.Font = "Trebuchet MS,8,style=bold"
$Restartbutton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(255, 255, 36)
$Restartbutton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$Restartbutton.Cursor = [System.Windows.Forms.Cursors]::Hand
$Restartbutton.Add_Click( { RestartInfo }) 
$Form.controls.Add($Restartbutton)
#endregion Restart_Button


Function pinginfo
{
   Cleantxt
   $Servers = $InputBox.lines.Split("`n")
   Add-Content -Path "$ScriptDir\Script\Ping\servers.txt" -Value $Servers
   start powershell {echo hello; .\Script\Ping\Monitor.ps1; pause}
}

Function Uptimeinfo
{
   Cleantxt
   $Servers = $InputBox.lines.Split("`n")
   Add-Content -Path "$ScriptDir\Script\Uptime\servers.txt" -Value $Servers
   start powershell {echo hello; .\Script\Uptime\Uptime.ps1; pause}
}

Function StartAutoServiceInfo
{
   Cleantxt
   $Servers = $InputBox.lines.Split("`n")
   Add-Content -Path "$ScriptDir\Script\StartAutoService\servers.txt" -Value $Servers
   start powershell {echo hello; .\Script\StartAutoService\StartAutoService.ps1; pause}
}

Function ExchangePostPatchInfo
{
   Cleantxt
   $Servers = $InputBox.lines.Split("`n")
   Add-Content -Path "$ScriptDir\Script\ExchangePostPatch\servers.txt" -Value $Servers
   start powershell {echo hello; .\Script\ExchangePostPatch\ExchangePostPatch.ps1; pause}
}

Function SQLPostPatchInfo
{
   Cleantxt
   $Servers = $InputBox.lines.Split("`n")
   Add-Content -Path "$ScriptDir\Script\SQLPostPatch\servers.txt" -Value $Servers
   start powershell {echo hello; .\Script\SQLPostPatch\SQLPostPatch.ps1; pause}
}

Function GLOBALNETInfo
{
   Cleantxt
   $Servers = $InputBox.lines.Split("`n")
   Add-Content -Path "$ScriptDir\Script\Globalnet\servers.txt" -Value $Servers
   start powershell {echo hello; .\Script\Globalnet\Globalnet.ps1; pause}
}

Function RGEInfo
{
   Cleantxt
   $Servers = $InputBox.lines.Split("`n")
   Add-Content -Path "$ScriptDir\Script\Rge\servers.txt" -Value $Servers
   start powershell {echo hello; .\Script\Rge\Rge.ps1; pause}
}

Function AVInfo
{
   Cleantxt
   $Servers = $InputBox.lines.Split("`n")
   Add-Content -Path "$ScriptDir\Script\AV\servers.txt" -Value $Servers
   start powershell {echo hello; .\Script\AV\AV.ps1; pause}
}

Function LogoffInfo
{
   Cleantxt
   $Servers = $InputBox.lines.Split("`n")
   Add-Content -Path "$ScriptDir\Script\Logoff\servers.txt" -Value $Servers
   start powershell {echo hello; .\Script\Logoff\Logoff.ps1; pause}
}

Function TitusServiceInfo
{
   Cleantxt
   $Servers = $InputBox.lines.Split("`n")
   Add-Content -Path "$ScriptDir\Script\CheckTitusService\servers.txt" -Value $Servers
   start powershell {echo hello; .\Script\CheckTitusService\CheckTitusService.ps1; pause}
}

Function DLPServiceInfo
{
   Cleantxt
   $Servers = $InputBox.lines.Split("`n")
   Add-Content -Path "$ScriptDir\Script\CheckDLPServiceRunOnly\servers.txt" -Value $Servers
   start powershell {echo hello; .\Script\CheckDLPServiceRunOnly\CheckDLPServiceRunOnly.ps1; pause}
}

Function Restartinfo
{
   Cleantxt
   $Servers = $InputBox.lines.Split("`n")
   Add-Content -Path "$ScriptDir\Script\Restart\servers.txt" -Value $Servers
   start powershell {echo hello; .\Script\Restart\Restart.ps1; pause}
}

Function TitusInfo
{
   Cleantxt
   $Servers = $InputBox.lines.Split("`n")
   Add-Content -Path "$ScriptDir\Script\Titus\servers.txt" -Value $Servers
   start powershell {echo hello; .\Script\Titus\Titus.ps1; pause}
}

Function ExploreInfo
{
   Cleantxt
   $Servers = $InputBox.lines.Split("`n")
   Add-Content -Path "$ScriptDir\Script\Explore\servers.txt" -Value $Servers
   start powershell {echo hello; .\Script\Explore\Explore.ps1; pause}
}

<#
function pingInfo {
    $outputBox.Clear()
    $computers = $InputBox.lines.Split("`n")
    foreach ($computer in $computers) {
        if (Test-Connection $computer -Count 1 -Quiet) {
            $outputBox.Font = "Calibri,11,style=Bold"
            $outputBox.SelectionColor = "#007F00"
            $outputBox.AppendText("$computer is Online`n")
        }
        else {
            $outputBox.Font = "Calibri,11,style=Bold"
            $outputBox.SelectionColor = "#FF0000"
            $outputBox.AppendText("$computer is Offline`n")
        } 
    }
}
#>
# show for
[void] $Form.ShowDialog()