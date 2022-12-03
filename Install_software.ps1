Function Get-InstalledSoftware {
    $SoftwareList = New-Object System.Collections.Generic.List[System.Object]
    $OSArch = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
    Switch ($OSArch) {
        "64-Bit" {
            $RegPath = @("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall", "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrenVersion\Uninstall")
        }
        Default {
            $RegPath = @("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall")
        }
    }
    ForEach ($Path in $RegPath) {
        $RegKeys += (Get-ChildItem -Path $Path -ErrorAction SilentlyContinue).Name.Replace("HKEY_LOCAL_MACHINE", "HKLM:")
    }

    ForEach ($Key in $RegKeys) {
        Try {
            $Properties = Get-ItemProperty -Path $Key -ErrorAction SilentlyContinue # A corrupt registry value will cause this to fail.  I

            If ($Properties.DisplayName) {
                $DisplayName = ($Properties.DisplayName).Trim()
            }
            Else {
                $DisplayName = ""
            }

            If ($Properties.DisplayVersion) {
                $DisplayVersion = ($Properties.DisplayVersion -replace "[^a-zA-Z0-9.-_()]").Trim()
            }
            Else {
                $DisplayVersion = ""
            }

            If ($Properties.Publisher) {
                $Publisher = ($Properties.Publisher).Trim()
            }
            Else {
                $Publisher = ""
            }

            If ($Properties.InstallLocation) {
                $InstallLocation = ($Properties.InstallLocation).Trim()
            }
            Else {
                $InstallLocation = ""
            }

            If ($Properties.SystemComponent) {
                $SystemComponent = $Properties.SystemComponent
            }
            Else {
                $SystemComponent = ""
            }

            If ($Properties.ParentKeyName) {
                $ParentKeyName = $Properties.ParentKeyName
            }
            Else {
                $ParentKeyName = ""
            }
        }
        Catch {
            # If above method fails, then do this
            Try {
                $DisplayName = (Get-ItemPropertyValue $Key -Name DisplayName).Trim()
            }
            Catch {
                $DisplayName = ""
            }

            Try {
                $DisplayVersion = (Get-ItemPropertyValue $Key -Name DisplayVersion).Replace("[^a-zA-Z0-9.-_()]", "").Trim()
            }
            Catch {
                $DisplayVersion = ""
            }

            Try {
                $Publisher = (Get-ItemPropertyValue $Key -Name Publisher).Trim()
            }
            Catch {
                $Publisher = ""
            }

            Try {
                $InstallLocation = (Get-ItemPropertyValue $Key -Name InstallLocation).Trim()
            }
            Catch {
                $InstallLocation = ""
            }

            Try {
                $SystemComponent = (Get-ItemPropertyValue $Key -Name SystemComponent).Trim()
            }
            Catch {
                $SystemComponent = ""
            }

            Try {
                $ParentKeyName = (Get-ItemPropertyValue $Key -Name ParentKeyName).Trim()
            }
            Catch {
                $ParentKeyName = ""
            }
        }

        If ($DisplayName -and $SystemComponent -ne 1 -and (-Not($ParentKeyName))) {
            $NewObj = [PSCustomObject]@{
                DisplayName     = $DisplayName
                DisplayVersion  = $DisplayVersion
                Publisher       = $Publisher
                InstallLocation = $InstallLocation
            }
            $SoftwareList.Add($NewObj)
        }
    }

    Return $SoftwareList | Select-Object * -Unique | Sort-Object DisplayName
}
