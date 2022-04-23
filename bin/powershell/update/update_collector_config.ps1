
$UserPropertiesHash = ConvertFrom-StringData( Get-Content ./collector.properties -raw )

foreach ($h in $UserPropertiesHash.GetEnumerator()) {
    if ( $h.Name -like 'cpuTarget' ) {
        Write-Host "$($h.Name): $($h.Value)"
    }
}

$ExistingKey = $args[0]
$NewValue = $args[1]

if ($UserPropertiesHash.ContainsKey($TestKey)) {
    Write-Host $UserPropertiesHash[$TestKey]
}

$UserPropertiesHash[$TestKey] = NewValue

foreach ($h in $UserPropertiesHash.GetEnumerator()) {
    if ( $h.Name -like 'cpuTarget' ) {
        Write-Host "$($h.Name): $($h.Value)"
    }
}

foreach ($h in $UserPropertiesHash.GetEnumerator()) {
    Write-Host "$($h.Name): $($h.Value)"
}


$convertDate = Get-Date -format "yyyyMMdd"

$inputFile = $args[0]

$FullPathName = Resolve-Path $inputFile | %{ $_.Path }
$backupFile = $FullPathName.$convertDate.txt

$ExistingKey = $args[1]
$NewValue = $args[2]

Copy-Item -Path $inputFile -Destination $backupFile

$UserPropertiesHash = ConvertFrom-StringData( Get-Content $inputFile -raw )
$UserPropertiesHash[$TestKey] = NewValue
$UserPropertiesHash.GetEnumerator() | % { "$($_.Name)=$($_.Value)" } > $inputFile

