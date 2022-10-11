# Define the temporary location to cache the installer.
$TempDirectory = "$ENV:HOMEDRIVE\SCC"
New-Item -ItemType Directory "$TempDirectory" -Force | Out-Null
# Copy File/Folder from SMB 
Copy-Item \\IP\Share\scc-5.5_Windows_bundle.zip -Destination $TempDirectory\scc-5.5_Windows_bundle.zip
# 
Expand-Archive -Path $TempDirectory\scc-5.5_Windows_bundle.zip -DestinationPath $TempDirectory -Force
#Install SCC with default options silently with no GUI shown
#SCC_5.5_Windows_Setup.exe /VERYSILENT
#Install SCC to a given directory with default options silently with no GUI shown
#SCC_5.5_Windows_Setup.exe /VERYSILENT /DIR="C:\SCC"
$filepath = "C:\SCC\scc-5.5_Windows_bundle\scc-5.5_Windows"
cd $filepath
.\SCC_5.5_Windows_Setup.exe /VERYSILENT
