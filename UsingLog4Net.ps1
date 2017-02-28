# an example of how to add Log4Net capability into powershell 


$ariesoGeoBin = "C:\Program Files\Arieso\ariesoGEO\bin\"
$ariesoLogFolder = "C:\ariesoGEO Logs\Normal\"
$tempConfigFile = "$env:TEMP\ariesoGEOmod.log"


# load the Log4Net DLL
If ( Test-Path $($ariesoGeoBin + "log4netClient.dll") ) { Add-Type -Path $($ariesoGeoBin + "log4netClient.dll") }
ElseIf ( Test-Path $($ariesoGeoBin + "log4net.dll") ) { Add-Type -Path $($ariesoGeoBin + "log4net.dll") }
Else {Write-host "Exiting. Log4Net Library cannot be found in folder" $ariesoGeoBin ; Exit}


# need to modify the Log4Net XML config a bit so that it will dump the logfile into a properly 
# named file. 
[xml]$xmlConfigFile = Get-Content $($ariesoBin + "ariesoGEO.log")
$nodeAllLog = $xmlConfigFile.log4net.appender | where {$_.name -eq "AllLogs"}
$nodeAllLog.file.value = $($ariesoLogFolder + "BulkNetworkLoader.log")
$xmlConfigFile.Save($tempConfigFile) 
$configFile = Get-Item $tempConfigFile
[log4net.Config.XmlConfigurator]::Configure($configFile)


# Use it
$logger = [log4net.LogManager]::GetLogger($script:myInvocation.MyCommand.Name)
$logger.Info("testing")


# at the end, delete the config file
Remove-Item $tempConfigFile
