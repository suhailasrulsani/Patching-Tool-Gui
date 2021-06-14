Clear-Host
#region Variable
$dt = (Get-Date).ToString("ddMMyyyy_HHmmss")
$ScriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$Servers = @(Get-Content -Path "$ScriptDir\Servers.txt")
#endregion Variable

#region Header
$Header = @"
<h4> Citrix Server Post Patch </h4>
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

</style>
"@
#endregion Header

#region Uptime
$ResultsUptime = Foreach ($Server in $Servers)
{
    Try
    {
        $Bootuptime = (Get-CimInstance -ComputerName $Server -ClassName Win32_OperatingSystem -ErrorAction Stop).LastBootUpTime
        $CurrentDate = Get-Date
        $Uptime = $CurrentDate - $Bootuptime

        [PSCustomObject]@{
        Server = $Server
        Days = $Uptime.Days
        Hours = $Uptime.Hours
        Minutes = $Uptime.Minutes
        }
    }

    Catch
    {
        [PSCustomObject]@{
            Server = $Server
            Days = 'Error'
            Hours = 'Error'
            Minutes = 'Error'
        }
    }
}
$Results1 = $ResultsUptime | ConvertTo-Html -Property  Server,Days,Hours,Minutes -Fragment -PreContent "<h4>Uptime</h4>"
$Results1 = $Results1 -replace '<td>Error</td>','<td class="ErrorStatus">Error</td>'
#endregion Uptime

#region AutoService
$ResultsAutoService = Foreach ($Server in $Servers)
{
    Try
    {
        $Services = Get-Service -ComputerName $Server -ErrorAction Stop | Where-Object { $_.StartType -like "*Automatic*" -and $_.Status -like "*Stopped*" }

        Foreach ($Service in $Services)
        {
            [PSCustomObject]@{
                Server = $Server
                Name = $Service.Name
                DisplayName = $Service.DisplayName
                StartType = $Service.StartType
                Status = $Service.Status
            }
        }
        
    }

    Catch
    {
        [PSCustomObject]@{
            Server = $Server
            Name = 'Error'
            DisplayName = 'Error'
            StartType = 'Error'
            Status = 'Error'
        }
    }
}
$Results2 = $ResultsAutoService | ConvertTo-Html -Property  Server,Name,DisplayName,StartType,Status -Fragment -PreContent "<h4>Automatic Services</h4>"
$Results2 = $Results2 -replace '<td>Stopped</td>','<td class="StopStatus">Stopped</td>'
$Results2 = $Results2 -replace '<td>StopPending</td>','<td class="StopPendingStatus1">StopPending</td>'
$Results2 = $Results2 -replace '<td>Stop Pending</td>','<td class="StopPendingStatus2">Stop Pending</td>'
$Results2 = $Results2 -replace '<td>Disabled</td>','<td class="DisabledStatus">Disabled</td>'
$Results2 = $Results2 -replace '<td>Error</td>','<td class="ErrorStatus">Error</td>'
#endregion AutoService

#region Citrix Service
$ResultsCitrixService = Foreach ($Server in $Servers)
{
    Try
    {
        $Services = Get-Service -ComputerName $Server -ErrorAction Stop | Where-Object { $_.DisplayName -like "*Citrix*" }

        Foreach ($Service in $Services)
        {
            [PSCustomObject]@{
                Server = $Server
                Name = $Service.Name
                DisplayName = $Service.DisplayName
                StartType = $Service.StartType
                Status = $Service.Status
            }
        }
        
    }

    Catch
    {
        [PSCustomObject]@{
            Server = $Server
            Name = 'Error'
            DisplayName = 'Error'
            StartType = 'Error'
            Status = 'Error'
        }
    }
}
$Results3 = $ResultsCitrixService | ConvertTo-Html -Property  Server,Name,DisplayName,StartType,Status -Fragment -PreContent "<h4>SQL Services</h4>"
$Results3 = $Results3 -replace '<td>Stopped</td>','<td class="StopStatus">Stopped</td>'
$Results3 = $Results3 -replace '<td>StopPending</td>','<td class="StopPendingStatus1">StopPending</td>'
$Results3 = $Results3 -replace '<td>Stop Pending</td>','<td class="StopPendingStatus2">Stop Pending</td>'
$Results3 = $Results3 -replace '<td>Disabled</td>','<td class="DisabledStatus">Disabled</td>'
$Results3 = $Results3 -replace '<td>Error</td>','<td class="ErrorStatus">Error</td>'
#endregion CitrixService

#region Uniprint Service
$ResultsUniprintService = Foreach ($Server in $Servers)
{
    Try
    {
        $Services = Get-Service -ComputerName $Server -ErrorAction Stop | Where-Object { $_.DisplayName -like "*Uniprint*" }

        Foreach ($Service in $Services)
        {
            [PSCustomObject]@{
                Server = $Server
                Name = $Service.Name
                DisplayName = $Service.DisplayName
                StartType = $Service.StartType
                Status = $Service.Status
            }
        }
        
    }

    Catch
    {
        [PSCustomObject]@{
            Server = $Server
            Name = 'Error'
            DisplayName = 'Error'
            StartType = 'Error'
            Status = 'Error'
        }
    }
}
$Results4 = $ResultsUniprintService | ConvertTo-Html -Property  Server,Name,DisplayName,StartType,Status -Fragment -PreContent "<h4>Uniprint Services</h4>"
$Results4 = $Results4 -replace '<td>Stopped</td>','<td class="StopStatus">Stopped</td>'
$Results4 = $Results4 -replace '<td>StopPending</td>','<td class="StopPendingStatus1">StopPending</td>'
$Results4 = $Results4 -replace '<td>Stop Pending</td>','<td class="StopPendingStatus2">Stop Pending</td>'
$Results4 = $Results4 -replace '<td>Disabled</td>','<td class="DisabledStatus">Disabled</td>'
$Results4 = $Results4 -replace '<td>Error</td>','<td class="ErrorStatus">Error</td>'
#endregion UniprintService

#region Export html
$Report = ConvertTo-Html -Body "$Results1 $Results2 $Results3 $Results4" -Title "Citrix Server Post Patch" -Head $Header | Out-File "$ScriptDir\Report\Citrix.html" 
#endregion Export html

#region Send Email
$datetime = Get-Date -Format G
$ReportFileName = "$ScriptDir\Report\Citrix.html"
$EmailTo = 'suhail_asrulsani@averis.biz'#,'jessey_ui@averis.biz', 'honwai_Lim@averis.biz', 'Magaret_Hansen@averis.biz'
$EmailFrom = 'noreply@averis.biz'
$date = ( get-date ).ToString('MM/dd/yyyy')
$EmailSubject = "Citrix Server Post Patch $datetime"
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

Get-PSSession | Remove-PSSession

