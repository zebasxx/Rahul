<#
    This funtions returns $true if:
        * If file is not inside "Completed" folder
        * If file is not inside "Duplicate" folder
        * If file is not inside "Modification" folder
        * If file is not inside "Archive" folder
        * if File has "_c" in the name
        * if File has "_d" in the name
        * if File has "_m" in the name
#>
Function Get-FileCandidate($file) {
    $output = $true

    $allDirectories = $file.Directory.FullName -split '\\'

    #Evaluate if file is insider "Completed" or "Duplicate" or "Modification" or "Archive" folder, set output to false   
    foreach($dir in $allDirectories){
        if ( ($dir -eq 'Completed') -or ($dir -eq 'Duplicate') -or ($dir -eq 'Modification') -or ($dir -eq 'Archive') ){
            $output = $false
        }
    }

    #Evaluate if File has "_c" or "_C" or "_d" or "_D" or "_m" or "_M" in the name and if not, set output to false
    if ( (-not ($file.Name -match '_c')) -and (-not ($file.Name -match '_d')) -and (-not ($file.Name -match '_m')) ) {
        $output = $false
    }

    return $output
}

#Clear error variable
$error.clear()

#Path of the folder to be scaned:
$scantarget = '\\phs.corp\departments\Benefits\E-FAX\'
#$scantarget = 'C:\tmp'

#Path for reports to be saved:
$repotrsPath = 'C:\Report\OneDay\'

#Report file name:
$ReportFileName = 'Benefits number of New Files-' + (Get-Date).Date.AddDays(-1).ToString('MM-dd-yyyy') + ".csv"

#Creation of full path names for report files:
$ReportFileNameFullPath = $repotrsPath+$ReportFileName

#initializate Report files, delete exiting reports
if (Test-Path ($ReportFileNameFullPath)) { Remove-Item $ReportFileNameFullPath}
Write-Output "File Name with error:" > $ReportFileNameFullPath

#Process the root directory:
$directoryFullName = $scantarget
$allFiles = Get-ChildItem $directoryFullName -File

foreach ($file in $allFiles){
    if (Get-FileCandidate($file)){
        $origin = $file.Name
        $originFullName = $file.FullName
        $TimeStamp = (Get-Date).tostring("MM-dd-yyyy-hh-mm")

        if ($origin -match '_c'){

            $destination = $file.Directory.FullName+'\Completed\'+$origin.BaseName+'_'+$TimeStamp+$origin.Extension
            Move-Item -Path $originFullName -Destination $destination -EA SilentlyContinue
            if ($error.Count -gt 0){
                Out-file -InputObject $origin $ReportFileNameFullPath -Append
                $error.clear()
            }
        }
        if ($origin -match '_d') {
            $destination = $file.Directory.FullName+'\Duplicate\'+$origin.BaseName+'_'+$TimeStamp+$origin.Extension
            Move-Item -Path $originFullName -Destination $destination -EA SilentlyContinue
            if ($error.Count -gt 0){
                Out-file -InputObject $origin $ReportFileNameFullPath -Append
                $error.clear()
            }
        }
        if ($origin -match '_m') {
            $destination = $file.Directory.FullName+'\Modification\'+$origin.BaseName+'_'+$TimeStamp+$origin.Extension
            Move-Item -Path $originFullName -Destination $destination -EA SilentlyContinue
            if ($error.Count -gt 0){
                Out-file -InputObject $origin $ReportFileNameFullPath -Append
                $error.clear()
            }
        }
    }
}

#Scan all the subfolders inside root directyory
$allDirectories = Get-ChildItem $scantarget -Recurse -Directory
foreach ($directory in $allDirectories){
    $directoryFullName = $directory.FullName
    $allFiles = Get-ChildItem $directoryFullName -File
    foreach ($file in $allFiles){
        if (Get-FileCandidate($file)){
            $origin = $file.Name
            $originFullName = $file.FullName
            $TimeStamp = (Get-Date).tostring("MM-dd-yyyy-hh-mm")

            if ($origin -match '_c'){
                $destination = $file.Directory.FullName+'\Completed\'+$origin.BaseName+'_'+$TimeStamp+$origin.Extension
                Move-Item -Path $originFullName -Destination $destination 
                if ($error.Count -gt 0){
                    Out-file -InputObject $origin $ReportFileNameFullPath -Append
                    $error.clear()
                }
            }
            if ($origin -match '_d') {
                $destination = $file.Directory.FullName+'\Duplicate\'+$origin.BaseName+'_'+$TimeStamp+$origin.Extension
                Move-Item -Path $originFullName -Destination $destination 
                if ($error.Count -gt 0){
                    Out-file -InputObject $origin $ReportFileNameFullPath -Append
                    $error.clear()
                }
            }
            if ($origin -match '_m') {
                $destination = $file.Directory.FullName+'\Modification\'+$origin.BaseName+'_'+$TimeStamp+$origin.Extension
                Move-Item -Path $originFullName -Destination $destination 
                if ($error.Count -gt 0){
                    Out-file -InputObject $origin $ReportFileNameFullPath -Append
                    $error.clear()
                }
            }
        }
    }
}