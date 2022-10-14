# Automatically generates the document json from provided script and saves the document in the documents folder.

param (
    [Parameter(Mandatory=$True)]
        [string]$ScriptPath,
    [Parameter(Mandatory=$True)]
        [string]$Description
)

$Prefix = @"
{
    "schemaVersion": "1.2",
    "description": "$($Description)",
    "runtimeConfig": {
      "aws:runPowerShellScript": {
        "properties": [
          {
            "id": "0.aws:runPowerShellScript",
            "timeoutSeconds": "7200",
            "runCommand":
"@
$Suffix = @"
        }
    ]
  }
}
}
"@

If ((Test-Path $ScriptPath)) {
    $JsonCode = Get-Content $($ScriptPath) | ForEach-Object { "$($_)".ToString() } | ConvertTo-Json
    $Prefix + $JsonCode + $Suffix | Out-File "./documents/$((Get-ChildItem $ScriptPath).BaseName.ToLower()).json" -Encoding ASCII
}

 
