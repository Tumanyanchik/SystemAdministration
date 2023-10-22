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

    foreach ($folder in $Folders) {
        if ($folder -in $Exclude) {
            continue
        }

        $foldersForClean = GetEmptySubfolders -Folder $folder

        foreach ($cleanFolder in $foldersForClean) {
            Write-Host ("FOR CLEAN: $($cleanFolder.FullName)")
            $removedFolders = RemoveEmptySubfolders -Folder $cleanFolder.FullName `
                                -RootFolder $folder `
                                -Exclude $Exclude
            Write-Host ("WERE REMOVED: $removedFolders")
        }
    }

    foreach ($folder in $removedFolders) {
        if ($folder -in $Folders){
            $Folders.Remove($folder) *> $null
        }
    }

    if ($removedFolders) {
        $removedFolders.Clear()
    }
    
    return $Folders
}

function GetEmptySubfolders {
    param (
        [Parameter (Mandatory=$true)][String] $Folder
    )
   
    if ( -not (Test-Path $Folder) -or (-not ((Get-Item $Folder).PSIsContainer)) ) {
        Write-Warning "$Folder must be existing container"
        return
    }

    $treeSubfolders = Get-ChildItem $Folder -recurse | Where-Object { $_.PSIsContainer }
    $emptySubfolders = $treeSubfolders | Where-Object { -not ($_.GetFileSystemInfos()) } 
    return $emptySubfolders
}


function RemoveEmptySubfolders {
    param (
        [Parameter (Mandatory=$true)][String] $Folder,
        [Parameter (Mandatory=$true)][String] $RootFolder,
        [System.Collections.Generic.List[System.String]] $RemovedFolders,
        [System.Collections.Generic.List[System.String]] $Exclude
    )

    if (-not $RemovedFolders) {
        [System.Collections.Generic.List[System.String]] $RemovedFolders = [System.Collections.Generic.List[System.String]]::new()
    }

    if ($Folder -in $Exclude) {
        return $RemovedFolders
    }

    if (-not (Get-Item $Folder).GetFileSystemInfos()) {
        $parentFolder = (Get-Item $Folder).Parent.FullName
        Remove-Item $Folder -Force *> $null
        $RemovedFolders.Add($Folder)
        if ($RootFolder -ne $Folder){
            Write-Host "PARENT FOR REMOVED: $parentFolder"
            $RemovedFolders = RemoveEmptySubfolders -Folder $parentFolder `
                                -RootFolder $RootFolder `
                                -RemovedFolders $RemovedFolders `
                                -Exclude $Exclude
        }
    }

    return $RemovedFolders
}
