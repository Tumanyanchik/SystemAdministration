function RemoveEmptyFolders {
    param(
        [Parameter (Mandatory=$true)][System.Collections.Generic.List[System.String]] $Folders,
        [System.Collections.Generic.List[System.String]] $Exclude
    )

    [System.Collections.Generic.List[System.String]] $removedFolders = [System.Collections.Generic.List[System.String]]::new()
    $isFoldersNeedClean = $true
    while ($Folders -and $isFoldersNeedClean) {
        foreach ($folder in $Folders){
            $isFoldersNeedClean = $false

            if($folder -in $Exclude){
                continue
            }

            if (-not (Get-Item $folder).GetFileSystemInfos()){
                Remove-Item $folder -Force *> $null
                $removedFolders.Add($folder)
                $isFoldersNeedClean = $true
            }
        }

        foreach ($folder in $removedFolders){
            if($folder -in $Folders){
                $Folders.Remove($folder) *> $null
            }
        }

        $removedFolders.Clear()
    }
    
    return $Folders
}
