function New-Ulid {
    param(
        $Time,
        [switch] $Lowercase
    )

    if (!$Time) {
        $Time = Get-Now
    }
    if ($Lowercase) {
        $Encoding = $Encoding.toLower()
    }

    $Timestamp = Convert-Time -Time $Time
    $Randomness = Convert-Random -Length 16
    $String = $Timestamp + $Randomness

    $Object = [PSCustomObject]@{
        'Timestamp'  = $Timestamp
        'Randomness' = $Randomness
        'Ulid'       = $String
    }

    return $Object
}
