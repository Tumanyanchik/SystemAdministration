BeforeAll {
    Import-Module "$PSScriptRoot\..\FolderHelper.psm1"
}

AfterAll {
    Remove-Module FolderHelper
}

Describe 'FolderHelper'{

    Context 'ClearFolders' {
        BeforeEach {
            $rootFolder = New-Item -ItemType Directory "$env:Temp\Test"
            $subfolder = New-Item -ItemType Directory "$env:Temp\Test\Sub"
            $subInternalfolder = New-Item -ItemType Directory "$env:Temp\Test\Sub\Internal"
            $file = New-Item -ItemType File "$env:Temp\Test\$((get-date).ToString("MMddyy")).txt"
        }

        AfterEach {
            Remove-Item $rootFolder -Force -Recurse
        }
        
        It 'Folders (nested) -> Folderts not empty' {
            $Folders = [System.Collections.Generic.List[System.String]]::new()
            $Folders.Add($rootFolder)
            $Folders.Add($subfolder)
            $Folders.Add($subInternalfolder)

            $expected_values = @{
                executionTime = [double] 1
                FoldersOfFolders = @("$rootFolder")
            }

            $startTime = (Get-Date)
            RemoveEmptyFolders -Folders $Folders -Exclude $rootFolder | Should -Be $expected_values.FoldersOfFolders
            $endTime = (Get-Date)

            $executionTime = ($endTime-$startTime).TotalSeconds
            Write-Host("$executionTime sec")
            $executionTime | Should -BeLessOrEqual $expected_values.executionTime          
        }
    }
}