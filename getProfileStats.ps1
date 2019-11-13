$global:profileStats = @()
$filePath = "C:\Users\patri\Downloads\"

function checkUser{
    Param ($user)
    $file = $filePath+$user+".html"
    $projecten = Select-String -Path $file -Pattern 'Projecten'
    $vaardigheden = Select-String -Path $file -Pattern 'Vaardigheden'
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

checkUser("rinze")
checkUser("dennis")
printStats

