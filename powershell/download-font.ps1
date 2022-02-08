# This piece of function was copied from https://mickitblog.blogspot.com/2021/06/powershell-install-fonts.html
# $FontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip"

$FontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip"

function Install-Font {
  param
  (
    [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()][System.IO.FileInfo]$FontFile
  )

  #Get Font Name from the File's Extended Attributes
  $oShell = new-object -com shell.application
  $Folder = $oShell.namespace($FontFile.DirectoryName)
  $Item = $Folder.Items().Item($FontFile.Name)
  $FontName = $Folder.GetDetailsOf($Item, 21)
  try {
    switch ($FontFile.Extension) {
      ".ttf" { $FontName = $FontName + [char]32 + '(TrueType)' }
      ".otf" { $FontName = $FontName + [char]32 + '(OpenType)' }
    }
    $Copy = $true
    Write-Host ('Copying' + [char]32 + $FontFile.Name + '.....') -NoNewline
    Copy-Item -Path $fontFile.FullName -Destination ("C:\Windows\Fonts\" + $FontFile.Name) -Force

    #Test if font is copied over
    If ((Test-Path ("C:\Windows\Fonts\" + $FontFile.Name)) -eq $true) {
      Write-Host ('Success') -Foreground Yellow
    }
    else {
      Write-Host ('Failed') -ForegroundColor Red
    }
    $Copy = $false

    #Test if font registry entry exists
    If ($null -ne (Get-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -ErrorAction SilentlyContinue)) {
      #Test if the entry matches the font file name
      If ((Get-ItemPropertyValue -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts") -eq $FontFile.Name) {
        Write-Host ('Adding' + [char]32 + $FontName + [char]32 + 'to the registry.....') -NoNewline
        Write-Host ('Success') -ForegroundColor Yellow
      }
      else {
        $AddKey = $true
        Remove-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -Force
        Write-Host ('Adding' + [char]32 + $FontName + [char]32 + 'to the registry.....') -NoNewline
        New-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $FontFile.Name -Force -ErrorAction SilentlyContinue | Out-Null
        If ((Get-ItemPropertyValue -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts") -eq $FontFile.Name) {
          Write-Host ('Success') -ForegroundColor Yellow
        }
        else {
          Write-Host ('Failed') -ForegroundColor Red
        }
        $AddKey = $false
      }
    }
    else {
      $AddKey = $true
      Write-Host ('Adding' + [char]32 + $FontName + [char]32 + 'to the registry ...') -NoNewline
      New-ItemProperty -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $FontFile.Name -Force -ErrorAction SilentlyContinue | Out-Null
      If ((Get-ItemPropertyValue -Name $FontName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts") -eq $FontFile.Name) {
        Write-Host ('Success') -ForegroundColor Yellow
      }
      else {
        Write-Host ('Failed') -ForegroundColor Red
      }
      $AddKey = $false
    }
  }
  catch {
    If ($Copy -eq $true) {
      Write-Host ('Failed') -ForegroundColor Red
      $Copy = $false
    }
    If ($AddKey -eq $true) {
      Write-Host ('Failed') -ForegroundColor Red
      $AddKey = $false
    }
    Write-Warning $_.exception.message
  }
  Write-Host
}

$Path = "C:\Users\$env:UserName\Desktop"

Invoke-WebRequest $FontUrl -OutFile $Path\font.zip
Get-ChildItem $Path -Filter *.zip | Expand-Archive -DestinationPath $Path\Font -Force

foreach ($FontItem in (Get-ChildItem -Path $Path\Font | Where-Object {
($_.Name -like '*.ttf') -or ($_.Name -like '*.OTF')
    })) {
  Install-Font -FontFile $FontItem
}
