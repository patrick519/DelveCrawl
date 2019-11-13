$global:profileStats = @()
$global:profileStats += ,@("user;projecten;vaardigheden;score;")
$filePath = "C:\Users\patri\Downloads\profiles\"

function profileCrawl{
    Param ($mailList)
    #The CSV input fils contains 1 column named EMAILS
    $csv = Import-Csv -Path $mailList | Select -expandproperty EMAILS
    foreach($emailAdr in $csv){
        $link = "https://snbv-my.sharepoint.com/_layouts/15/me.aspx/?p="+$emailAdr+"&v=profiledetails"
        #Lets open Google Chrome and save with the help of addon SingleFile(autosave active)
        start-process "chrome.exe" $link
        #Sleep for a little time to provoke DDOS
        Start-Sleep -s 10
    }
} #profileCrawl 

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
        $global:profileStats += ,@($user+";1;1;1;")
    }
    elseif ($null -ne $projecten){
        #Write-Output "Contains Projecten"
        $global:profileStats += ,@($user+";1;0;0;")
    }
    elseif ($null -ne $vaardigheden){
        #Write-Output "Contains Vaardigheden"
        $global:profileStats += ,@($user+";0;1;0;")
    }
    else{
        #Write-Output "Not Contains"
        $global:profileStats += ,@($user+";0;0;0;")
    }
} #checkUser

function printStats{
    Param($location)
    $global:profileStats | Out-File $location"delveCrawl.csv"
    #foreach($userStat in $global:profileStats){Write-host ($userStat)}
} #printStats

#main

profileCrawl("C:\Users\patri\Downloads\list.csv")

$files = Get-ChildItem -Path $filePath | Select -expandproperty Name
foreach($userFile in $files){
    checkUser($userFile)
}
printStats(".\")


