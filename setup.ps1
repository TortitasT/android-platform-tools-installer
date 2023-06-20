function AddToPath {
  param (
    [Parameter(Mandatory = $true)]
    [string]$path
  )

  $current_Path = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path

  if ($current_Path -like "*$path*") {
    Write-Host "$path already in PATH"
    return
  }

  $new_Path = "$current_Path;$path"

  [Environment]::SetEnvironmentVariable("PATH", $new_Path, "Machine")

  Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $new_Path

  Write-Host "Added $path to PATH"
}

Remove-Item -Path "C:\platform-tools.zip" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\platform-tools" -Force -Recurse -ErrorAction SilentlyContinue

$web_Client = New-Object System.Net.WebClient

$web_Client.DownloadFile("https://dl.google.com/android/repository/platform-tools-latest-windows.zip", "C:\platform-tools.zip")

Expand-Archive -Path "C:\platform-tools.zip" -DestinationPath "C:\" -Force

Remove-Item -Path "C:\platform-tools.zip" -Force

AddToPath "C:\platform-tools"


