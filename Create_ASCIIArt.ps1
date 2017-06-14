[int] $width = 200 #Final output width

Add-type -Path "$PSScriptRoot\ASCIIArt\bin\Debug\ASCIIArt.dll"

function ASCII {
    param (
        [float] $brightness
    )
    $scale = ("$","@","B","%","8","&","W","M","#","*","o","a","h","k","b","d","p","q","w","m","Z","O","0","Q","L","C","J","U","Y","X","z","c","v","u","n","x","r","j","f","t","/","\","|","(",")","1","{","}","[","]","?","-","_","+","~","<",">","i","!","l","I",";",":",",","`"","^","``","'","."," ");
    [int] $num = [math]::Round($brightness / 3.68)
    $index = [Core.VarOps]::Clamp($num,0,69);
    $scale[$index];
}

Function Get-FileName($initDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initDirectory
    $OpenFileDialog.filter = "BMP,JPG,GIF (*.bmp;*.jpg;*.gif)| *.csv;*.jpg;*.gif"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
}

$FilePath = Get-FileName $env:HOMEPATH



[int] $width = 300
[System.Drawing.Bitmap] $img = $FilePath

if ($img -eq $null) {exit}

$newHeight = ($img.Height * ($width / $img.Width) * .65)
$img = [ASCIIArt.ImageTools]::ResizeImage($img,$width,$newHeight)
$Map = [ASCIIArt.ImageTools]::GetPixelBrightness($img)
$Line = ""
if (gc -Path "$FilePath") {
        Out-File -FilePath "$FilePath.txt" -Force 
    }
for($i = 1; $i -le $Map.Count; $i++) {
    if ($i % $width -eq 0) {
         $Line | Out-File -FilePath "$FilePath.txt" -Append 
         write-host $Line
         $Line = ""
    }
    $char = ASCII($Map[$i-1])
    $Line = $Line + $char
}