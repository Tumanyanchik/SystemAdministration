<#
    RemoveEmptyFolders - remove empty folders and return List of folders, 
        which were not deleted from source List of folders.
    [System.Collections.Generic.List[System.String]] $Folders - folders for cleaning;
    [System.Collections.Generic.List[System.String]] $Exclude - folders for exclude from cleaning;
#>
function RemoveEmptyFolders {
    param(
        [Parameter (Mandatory=$true)] [System.Collections.Generic.List[System.String]] $Folders,
        [System.Collections.Generic.List[System.String]] $Exclude
    )

    [System.Collections.Generic.List[System.String]] $removedFolders = `
        [System.Collections.Generic.List[System.String]]::new()

    foreach ($folder in $Folders) {
        if ($folder -in $Exclude) {
            continue
        }

        if (-not (Get-Item $folder).GetFileSystemInfos()) {
            Remove-Item $folder -Force *> $null
            $removedFolders.Add($folder)
            $isRemoved = $true
        }
    }

    foreach ($folder in $removedFolders) {
        if ($folder -in $Folders){
            $Folders.Remove($folder) *> $null
        }
    }

    $removedFolders.Clear() 

    if ($isRemoved) {
        $isRemoved = $false
        $Folders = RemoveEmptyFolders -Folders $Folders -Exclude $Exclude
    }

    return $Folders
}
