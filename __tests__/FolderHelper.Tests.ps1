Describe 'FolderHelper'{
    BeforeAll {
        Import-Module "$PSScriptRoot\..\FolderHelper.psm1"
    }
    
    AfterAll {
        Remove-Module FolderHelper
    }
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
        
        It 'Default' {
            $List = [System.Collections.Generic.List[System.String]]::new()
            $List.Add($rootFolder)
            $List.Add($subfolder)
            $List.Add($subInternalfolder)

            RemoveEmptyFolders -Folders $List -Exclude $rootFolder | Should -Be $List($rootFolder)
        }
    }
}