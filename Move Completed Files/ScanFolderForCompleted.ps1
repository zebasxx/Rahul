#Set the destination pathe below:
$PathToScan = 'C:\HomeFolder'

Function Scan-Folder {
    param([Object[]] $FileList)
    foreach ($File in $FileList)
    {
        if ($File.Name -match 'completed' -and (-not ($File.Directory.FullName -match 'completed')) )
        {
            $TimeStamp = (Get-Date).tostring("MM-dd-yyyy-hh-mm")
            $Destination = $File.Directory.FullName+'\Completed\'+$File.BaseName+'_'+$TimeStamp+$File.Extension
            Move-Item -Path $File.FullName -Destination $Destination
        }
    }
}

$Files = Get-ChildItem -Path $PathToScan -File -Recurse
Scan-Folder $Files