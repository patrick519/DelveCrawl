$global:profileStats = @()
$filePath = "C:\Users\patri\Downloads\in\"

function checkUser{
    #Generate default params
    Param ($userFile)
    $file = $filePath+$userFile
    $user = $userFile -replace ".{22}$"
    $user = $user.substring(8)
    #Write-host ($user)
    $projecten = Select-String -Path $file -Pattern 'Projecten'
    $vaardigheden = Select-String -Path $file -Pattern 'Vaardigheden'
    #Check which stats are filled
    if (($null -ne $projecten) -and ($null -ne $vaardigheden)){
        #Write-Output "Contains Projecten & Vaardigheden"
        $global:profileStats += ,@($user, 1, 1, 1)
    }
    elseif ($null -ne $projecten){
        #Write-Output "Contains Projecten"
        $global:profileStats += ,@($user, 1, 0, 0)
    }
    elseif ($null -ne $vaardigheden){
        #Write-Output "Contains Vaardigheden"
        $global:profileStats += ,@($user, 0, 1, 0)
    }
    else{
        #Write-Output "Not Contains"
        $global:profileStats += ,@($user, 0, 0, 0)
    }
} #checkUser

function printStats{
    Write-Output "user projecten vaardigheden score"
    foreach($userStat in $global:profileStats){
        Write-host ($userStat)
    }
}

#main
$files = Get-ChildItem -Path C:\Users\patri\Downloads\in | Select -expandproperty Name
foreach($userFile in $files){
    checkUser($userFile)
}
printStats

