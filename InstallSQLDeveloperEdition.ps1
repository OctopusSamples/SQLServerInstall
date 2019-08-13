$isoLocation = ## Put the location here
$pathToConfigurationFile = ## Path to original file here
$copyFileLocation = "C:\Temp\ConfigurationFile.ini"

Write-Host "Copying the ini file"

New-Item "C:\Temp" -ItemType "Directory" -Force 
Copy-Item $pathToConfigurationFile $copyFileLocation -Force

Write-Host "Getting the name of the current user to replace in the copy ini file" 

$user = "$env:UserDomain\$env:USERNAME"

write-host $user

Write-Host "Replacing the placehold user name with your username"
$replaceText = (Get-Content -path $copyFileLocation -Raw) -replace "##MyUser##", $user
Set-Content $copyFileLocation $replaceText

Write-Host "Mounting SQL Server Image"
$drive = Mount-DiskImage -ImagePath $isoLocation 

Write-Host "Getting Disk drive of the mounted image"
$disks = Get-WmiObject -Class Win32_logicaldisk -Filter "DriveType = '5'"

foreach ($disk in $disks){
    $driveLetter = $disk.DeviceID
}

if ($driveLetter)
{
    Write-Host "Starting the install of SQL Server"
    Start-Process $driveLetter\Setup.exe "/ConfigurationFile=$copyFileLocation" -Wait
}

Write-Host "Dismounting the drive"

Dismount-DiskImage -InputObject $drive

Write-Host "If no red text then SQL Server Successfully Installed!"