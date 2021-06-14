Clear-Host
#region Variable
$dt = (Get-Date).ToString("ddMMyyyy_HHmmss")
$ScriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$servers = @(get-content -Path "$ScriptDir\servers.txt")
#$Passexchange = ConvertTo-SecureString -AsPlainText -Force -String "Welcome12"
#$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "globalnet\suhail_asrulsani-ops",$Passexchange
#endregion Variable

Try
{
    Remove-Item -Path "$ScriptDir\Report\DLPService.html" -Force -ErrorAction Stop
}

Catch {}

#region Header
$Header = @"
<p> Hi All </p>
<p> Below servers should show <run>'Running'</run> state for WDP and DLP </p>
<p> Kindly troubleshoot for the server that having issue in <em>RED</em>  </p>
&nbsp;
<style>

table 
{
    font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
    border-collapse: collapse;
    font-size: 12px;
    #width: 100%;
}

td, th
{
	#border: 1px solid #ddd;
    border: 2px solid black;
	padding-top: 0;
    padding-bottom: 0;
}

tr:nth-child(even) {background-color: #f2f2f2;}

tr:hover {background-color: #ddd;}

th
{
    padding-top: 0;
    padding-bottom: 0;
    text-align: left;
    background-color: #4CAF50;
    color:white;
}

p
{
    margin-top: 0;
    margin-bottom: 0;
}

h4
{
    margin-bottom: 0;
}

.StopStatus
{
    Background-color: red;
}

.StopPendingStatus
{
    Background-color: red;
}

.StopPendingStatus2
{
    Background-color: red;
}

.DisabledStatus
{
    Background-color: red;
}

.ErrorStatus
{
    Background-color: red;
}

.RunningStatus
{
    Background-color: green;
}

em
{
    color: red;
    font-style: normal;
    font-weight: normal;
}

run
{
    color: green;
    font-style: normal;
    font-weight: normal;
}

</style>
"@
#endregion Header

$Services = Foreach ($Server in $servers)
{
    Try
    {
        Start-Sleep -Seconds 5
        $Session = New-PSSession -ComputerName $Server -ErrorAction Stop

        $MyCommands =
        {
            #Set-Service -Name EDPA -StartupType Automatic -ErrorAction SilentlyContinue
            #Start-Service -Name EDPA -ErrorAction SilentlyContinue
            #Set-Service -Name WDP -StartupType Automatic -ErrorAction SilentlyContinue
            #Start-Service -Name WDP -ErrorAction SilentlyContinue
            $Edpa = (Get-Service | Where-Object { ($_.Name -like "*EDPA*") }).Status
            $Wdp = (Get-Service | Where-Object { ($_.Name -like "*WDP*") }).Status

            if (!$Edpa) { $StatusE = "NotExist" }
            if ($Edpa -like "*Running*") { $StatusE = "Running" }
            if ($Edpa -like "*Stopped*") { $StatusE = "Stopped" }
            if ($Edpa -like "*StopPending*") { $StatusE = "StopPending" }
            if ($Edpa -like "*Stop Pending*") { $StatusE = "Stop Pending" }

            if (!$Wdp) { $StatusW = "NotExist" }
            if ($Wdp -like "*Running*") { $StatusW = "Running" }
            if ($Wdp -like "*Stopped*") { $StatusW = "Stopped" }
            if ($Wdp -like "*StopPending*") { $StatusW = "StopPending" }
            if ($Wdp -like "*Stop Pending*") { $StatusW = "Stop Pending" }

            [PSCustomObject]@{
            Server = $env:COMPUTERNAME
            EDPA = $StatusE
            WDP = $StatusW
            }
        }

        Invoke-Command -Session $Session -ScriptBlock $MyCommands
    }

    Catch
    {
        [PSCustomObject]@{
        Server = $Server
        EDPA = 'Error'
        WDP = 'Error'
        }
    }
} 

$Results = $Services | ConvertTo-Html -Property Server, EDPA, WDP -Fragment
$Results = $Results -replace '<td>Stopped</td>','<td class="StopStatus">Stopped</td>'
$Results = $Results -replace '<td>Error</td>','<td class="ErrorStatus">Error</td>'
$Results = $Results -replace '<td></td>','<td class="BlankStatus"></td>'
$Results = $Results -replace '<td>StopPending</td>','<td class="StopPendingStatus">StopPending</td>'
$Results1 = ConvertTo-Html -Body "$Results" -Title "DLPService" -Head $Header | Out-File "$ScriptDir\Report\DLPService.html"

$datetime = Get-Date -Format G
$fromaddress = "noreply@averis.biz"
$toaddress = "suhail_asrulsani@averis.biz, jessey_ui@averis.biz, honwai_Lim@averis.biz, Magaret_Hansen@averis.biz"
#$bccaddress = "jessey_ui@averis.biz, honwai_Lim@averis.biz, Magaret_Hansen@averis.biz"
#$CCaddress = "jessey_ui@averis.biz, honwai_Lim@averis.biz, Magaret_Hansen@averis.biz"
$Subject = "DLP Service Status (Running) $datetime"
#$body = get-content .\ServiceReport.html -Raw
$body = [System.IO.File]::ReadAllText("$ScriptDir\Report\DLPService.html")
#$attachment = "$ScriptDir\Report\DLPService.xlsx"
$smtpserver = "kulavrcasarr01.globalnet.lcl"

####################################

$message = new-object System.Net.Mail.MailMessage
$message.From = $fromaddress
$message.To.Add($toaddress)
#$message.CC.Add($CCaddress)
#$message.Bcc.Add($bccaddress)
$message.IsBodyHtml = $True
$message.Subject = $Subject
#$attach = new-object Net.Mail.Attachment($attachment)
#$message.Attachments.Add($attach)
$message.body = $body
$smtp = new-object Net.Mail.SmtpClient($smtpserver)
$smtp.Send($message)

Get-PSSession | Remove-PSSession