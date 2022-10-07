# Define the temporary location to cache the installer.
$TempDirectory = "$ENV:HOMEDRIVE\Software"

New-Item -ItemType Directory "$TempDirectory" -Force | Out-Null

# Requires url.txt file into Directory where the Script is Running .

$urls = Get-Content $PSScriptRoot\url.txt

foreach ($link in $urls)
{$filename = $link.split('/')[-1]
(New-Object System.Net.WebClient).DownloadFile($Link,"$TempDirectory\$filename")
 Write-Host "Download success for" $filename "!" -ForegroundColor Green
}