$RootPath = Split-Path -Path $PSScriptRoot
$ModulePath = Join-Path -Path $RootPath -ChildPath "ULID.psm1"

Remove-Module ULID -ErrorAction SilentlyContinue -WarningAction SilentlyContinue
Import-Module $ModulePath

InModuleScope ULID {
    Describe 'ULID Unit Tests' {
        Context 'Get-Now' {
            It 'Should be [UInt64]' {
                Get-Now | Should BeOfType [UInt64]
            }

            It 'Should convert to [DateTime]' {
                $Now = Get-Now
                $Epoch = Get-Date -Date "1/1/1970"
                $Result = $Epoch.AddMilliseconds($Now)
                $Result | Should BeOfType [DateTime]
            }
        }

        Context 'Convert-Time' {
            $Time = 1497346166809
            $TimeLength = 10
            $TestEncodedTime = "01BJGCJM0S"

            It 'Should be equal to test case' {
                $EncodedTime = Convert-Time -Time $Time -Length $TimeLength
                $EncodedTime | Should Be $TestEncodedTime
            }

            It 'Should change length properly' {
                $EncodedTime = Convert-Time -Time $Time -Length 12
                $EncodedTime | Should Be "0001BJGCJM0S"
            }

            It 'Should truncate time if not enough length' {
                $EncodedTime = Convert-Time -Time $Time -Length 8
                $EncodedTime | Should Be "BJGCJM0S"
            }

            It 'Should return correct length' {
                $Result = Convert-Random -Length $TimeLength
                $Result.Length | Should Be $TimeLength
            }
        }

        Context 'Convert-Random' {
            It 'Should return correct length' {
                $Length = 12

                $Result = Convert-Random -Length $Length

                $Result.Length | Should Be $Length
            }

            It 'Should NOT have two equal values' {
                $Rnd1 = Convert-Random
                $Rnd2 = Convert-Random

                ($Rnd1 -eq $Rnd2) | Should Be $False
            }
        }

        Context 'New-Ulid' {
            It 'Should NOT throw' {
                { New-Ulid -ErrorAction Stop } | Should Not Throw
            }

            It 'Should NOT return $Null or empty' {
                New-Ulid | Should Not BeNullOrEmpty
            }

            It 'Should return correct length' {
                $Result = (New-Ulid).Ulid

                $Result.Length | Should Be 26
            }

            It 'Should function with -Time variable' {
                $Time = 1497346166809

                New-Ulid -Time $Time | Should Be $True
            }

            It 'Should give the same time component' {
                $Time = 1497346166809

                $Ulid1 = (New-Ulid -Time $Time).Timestamp
                $Ulid2 = (New-Ulid -Time $Time).Timestamp

                ($Ulid1 -eq $Ulid2) | Should Be $True
            }

            It 'Should convert to lowercase with -Lowercase' {
                $Result = New-Ulid -Lowercase

                $Result.Ulid -cmatch "[A-Z]" | Should Be $False
                $Result.Timestamp -cmatch "[A-Z]" | Should Be $False
                $Result.Randomness -cmatch "[A-Z]" | Should Be $False
            }
        }

        Context 'ULID.psm1' {
            It 'Should import' {
                {
                    $RootPath = Split-Path -Path $PSScriptRoot
                    $ModulePath = Join-Path -Path $RootPath -ChildPath "ULID.psm1"
                    Import-Module $ModulePath -ErrorAction Stop
                } | Should Not Throw
            }

            It 'Should only expose certain functions' {
                $ModuleContent = Get-Module ULID
                ($ModuleContent.ExportedCommands).Count | Should Be 1
            }
        }
    }
}
