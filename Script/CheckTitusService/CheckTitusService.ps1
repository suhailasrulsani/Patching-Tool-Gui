Clear-Host
#region Variable
$dt = (Get-Date).ToString("ddMMyyyy_HHmmss")
$ScriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$servers = @(get-content -Path "$ScriptDir\servers.txt")
#endregion Variable

#region Cleanup report
Remove-Item -Path "$ScriptDir\Report\TitusService.html" -Force -ErrorAction SilentlyContinue
#endregion Cleanup report

#region Header
$Header = @"
<p> Hi All </p>
<p> Below servers should show 'Running' state both Titus services </p>
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

.StopPendingStatus1
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

em
{
    color: red;
    font-style: normal;
    font-weight: normal;
}

</style>
"@
#endregion Header

#region Services
$ResultsService = Foreach ($Server in $servers)
{
    Try
    {
        Start-Sleep -Seconds 5
        $Session = New-PSSession -ComputerName $Server -ErrorAction Stop

        $MyCommands =
        {
            $Titus1 = (Get-Service -ErrorAction Stop | Where-Object { ($_.Name -like "*Titus.Enterprise.Client.Service*") }).Status
            $Titus2 = (Get-Service -ErrorAction Stop | Where-Object { ($_.Name -like "*Titus.Enterprise.HealthMonitor.Service*") }).Status
            if (!$Titus1) { $StatusE = "NotExist" }
            if ($Titus1 -like "*Running*") { $StatusE = "Running" }
            if ($Titus1 -like "*Stopped*") { $StatusE = "Stopped" }
            if ($Titus1 -like "*Stop Pending*") { $StatusE = "Stop Pending" }
            if ($Titus1 -like "*StopPending*") { $StatusE = "StopPending" }
        
            if (!$Titus2) { $StatusW = "NotExist" }
            if ($Titus2 -like "*Running*") { $StatusW = "Running" }
            if ($Titus2 -like "*Stopped*") { $StatusW = "Stopped" }
            if ($Titus2 -like "*Stop Pending*") { $StatusW = "Stop Pending" }
            if ($Titus2 -like "*StopPending*") { $StatusW = "StopPending" }

            [PSCustomObject]@{
            Server = $env:COMPUTERNAME
            'Titus Enterprise Client Service' = $StatusE
            'Titus Enterprise Health Monitor Service' = $StatusW
            }
        }

        Invoke-Command -Session $Session -ScriptBlock $MyCommands
    }

    Catch
    {
        [PSCustomObject]@{
        Server = $Server
        'Titus Enterprise Client Service' = 'Error'
        'Titus Enterprise Health Monitor Service' = 'Error'
        }
    }
}

$Results1 = $ResultsService | ConvertTo-Html -Property Server,'Titus Enterprise Client Service','Titus Enterprise Health Monitor Service' -Fragment -PreContent "<h4> Titus Services </h4>"
$Results1 = $Results1 -replace '<td>Stopped</td>','<td class="StopStatus">Stopped</td>'
$Results1 = $Results1 -replace '<td>StopPending</td>','<td class="StopPendingStatus1">StopPending</td>'
$Results1 = $Results1 -replace '<td>Stop Pending</td>','<td class="StopPendingStatus2">Stop Pending</td>'
$Results1 = $Results1 -replace '<td>Disabled</td>','<td class="DisabledStatus">Disabled</td>'
$Results1 = $Results1 -replace '<td>Error</td>','<td class="ErrorStatus">Error</td>'
#endregion Services

#region Export html
$Report = ConvertTo-Html -Body "$Results1" -Title "TitusService" -Head $Header | Out-File "$ScriptDir\Report\TitusService.html" 
#endregion Export html

#region Send Email
$datetime = Get-Date -Format G
$ReportFileName = "$ScriptDir\Report\TitusService.html"
$EmailTo = 'suhail_asrulsani@averis.biz','jessey_ui@averis.biz', 'honwai_Lim@averis.biz', 'Magaret_Hansen@averis.biz'
$EmailFrom = 'noreply@averis.biz'
$date = ( get-date ).ToString('MM/dd/yyyy')
$EmailSubject = "Titus Service Status (Running) $datetime"
$SMTPServer = "kulavrcasarr01.globalnet.lcl"

$BodyReport = Get-Content "$ReportFileName" -Raw
Send-MailMessage -To $EmailTo `
-Subject $EmailSubject `
-From $EmailFrom `
-SmtpServer $SMTPServer `
-BodyAsHtml -Body $BodyReport `
#-Port "587" `
#-Credential $cred `
#-UseSsl
#endregion Send Email