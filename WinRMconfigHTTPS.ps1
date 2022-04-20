# HTTPS listener
# STEP 1 - Get the computer name and the certificate thumbprint
$computerName = $Env:Computername
$domainName = $Env:UserDnsDomain
#write-host "CN=$computername.$domainname"
$cn = "$computername.$domainname"
$getThumb = Get-ChildItem -path cert:\LocalMachine\My | where { $_.Subject -match "CN\=$Computername\.$DomainName" } | Select-Object -last 1
#$getThumb.thumbprint
$winrmexist = "C:\Intel\winrmok.txt"
# STEP 2 - Is there a winrmok.txt file?
if (!(Test-Path $winrmexist)) 
    {
		# STEP 3 - Compose the command
        $part1 = "winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=" + [char]34 + $env:Computername+"."+$Env:UserDnsDomain + [char]34
        $part2 = '; CertificateThumbprint="' + $getThumb.thumbprint
        $part3 = '"}'
        $command = $part1 + $part2 + $part3
		#$command
		# STEP 4 - Create a bat file and execute the command in cmd
        Out-File -FilePath C:\Intel\rmtp.bat -InputObject $command -Encoding ASCII -Width 50
        Start-Process -FilePath "C:\Windows\System32\cmd.exe" -verb runas -ArgumentList {/c C:\Intel\rmtp.bat}
        # STEP 5 - Save the thumbprint to the winrmok.txt file
		Out-File -FilePath 'C:\Intel\winrmok.txt' -InputObject $getThumb.thumbprint -Encoding ASCII -Width 50
    }
else 
    {
		# STEP 6 - Check whether the certificate has not been automatically renewed
		$latestcertthumb = $getThumb.thumbprint
        Get-Content -Path C:\Intel\winrmok.txt
        $currently_configured = Get-Content -Path C:\Intel\winrmok.txt
            if ($latestcertthumb -eq $currently_configured) 
                {
					#Write-Output "ok, let's clean up"
					# STEP 7 - Possibly clean up
                    $FileName = "C:\Intel\rmtp.bat"
                        if (Test-Path $FileName) 
                        {
                            Remove-Item $FileName
                        }
                }
            else 
                {
					# STEP 8 - Compose the command with new thumbprint
                    $part1 = "winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=" + [char]34 + $env:Computername+"."+$Env:UserDnsDomain + [char]34
                    $part2 = '; CertificateThumbprint="' + $getThumb.thumbprint
                    $part3 = '"}'
                    $command = $part1 + $part2 + $part3
					#$command
					# STEP 9 - Create a bat and execute the command in cmd
                    Out-File -FilePath C:\Intel\rmtp.bat -InputObject $command -Encoding ASCII -Width 50
                    Start-Process -FilePath "C:\Windows\System32\cmd.exe" -verb runas -ArgumentList {/c C:\Intel\rmtp.bat}
                    # STEP 10 - Save the thumbprint to the winrmok.txt file
					Out-File -FilePath 'C:\Intel\winrmok.txt' -InputObject $getThumb.thumbprint -Encoding ASCII -Width 50
                }
  }



