#Sleep to allow Test Logs to be flushed if executing right after
Start-Sleep -s 10

$buildId = $(Build.BuildId);
$user = "$(apiUser)"
$token = "$(personalAccessToken)"
$buildDetailsUri = "https://microsoft.visualstudio.com/DefaultCollection/Universal%20Store/_apis/build/builds/$buildId/timeline?api-version=2.0";
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$token)))
$buildDetails = Invoke-RestMethod -Uri $buildDetailsUri -Method Get -ContentType "application/json" -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}

$testLogRegEx = "Total tests: (?<Total>[\d]+)\. Passed: (?<Passed>[\d]+)\. Failed: (?<Failed>[\d]+)\. Skipped: (?<Skipped>[\d]+)\.";

$logUrls = $buildDetails.records | ? { $_.task.name -eq "VsTest" } | select -ExpandProperty log | select -ExpandProperty url;
$logs = $logUrls | % { Invoke-WebRequest $_ -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}} 

Write-Host Iterating Test Executions
foreach ($log in $logs){
    $res = $log | Select-String $testLogRegEx
    if ($res -eq $null){
        Write-Host "No Test Assemblies Found"
        exit 1
    }

    $totalTests = [int]($res.Matches[0].Groups | ? { $_.Name -eq "Total" } | select -ExpandProperty Value)
    if ($totalTests -eq 0){
        Write-Host "Found Execution with 0 tests"
        exit 1
    }
    else{
        Write-Host "Found $totalTests tests in execution"
    }
}

exit 0
