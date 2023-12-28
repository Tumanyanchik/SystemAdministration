Describe 'Converter'{
    BeforeAll {
        Import-Module "$PSScriptRoot\..\Converter.psm1"
    }
    
    AfterAll {
        Remove-Module Converter
    }

    Context 'ConvertFromCsvToXlsx' {
        BeforeEach {
            $rootFolder = New-Item -ItemType Directory "$env:Temp\Test" 
            $csv = "$env:Temp\Test\$((get-date).ToString("MMddyy")).csv"
            $xlsx = "$env:Temp\Test\result_$((get-date).ToString("MMddyy")).xlsx"
            Get-Process | 
                Select-Object -Property ID, ProcessName |
                Export-Csv -Path "$env:Temp\Test\$((get-date).ToString("MMddyy")).csv" -NoTypeInformation
        }

        AfterEach {
            Remove-Item $rootFolder -Force -Recurse
        }

        It 'Xlsx was created' {
            ConvertFromCsvToXlsx -csv_path $csv -xlsx_path $xlsx -delimiter "," 
            $xlsx | Should -Exist
        }
    }
}