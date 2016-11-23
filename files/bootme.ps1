#ps1

# This script installs puppet 3.x and deploy the manifest using puppet apply -e "include role_deployserver"
# Usage:
# <powershell>
# Set-ExecutionPolicy Unrestricted -Force
# icm $executioncontext.InvokeCommand.NewScriptBlock((New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/relybv/role_deployserver/master/files/bootme.ps1')) -ArgumentList ("role_deployserver")
#</powershell>


  param(
    [string]$role = "role_deployserver",
  )

  $puppet_source = "https://github.com/relybv/beng-role_deployserver.git"
  $MsiUrl = "https://downloads.puppetlabs.com/windows/puppet-3.8.6-x64.msi"

  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  if (! ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))) {
    Write-Host -ForegroundColor Red "You must run this script as an administrator."
    Exit 1
  }

  # Install puppet - msiexec will download from the url
  $install_args = @("/qn", "/norestart","/i", $MsiUrl)
  Write-Host "Installing Puppet. Running msiexec.exe $install_args"
  $process = Start-Process -FilePath msiexec.exe -ArgumentList $install_args -Wait -PassThru
  if ($process.ExitCode -ne 0) {
    Write-Host "Puppet installer failed."
    Exit 1
  }

  Write-Host "Puppet successfully installed."

  $GitUrl = "https://github.com/git-for-windows/git/releases/download/v2.7.2.windows.1/Git-2.7.2-64-bit.exe"
  $TempDir = [System.IO.Path]::GetTempPath()
  $TempGit = $TempDir + "/Git-2.7.2-64-bit.exe"
  Write-Host "Downloading Git to $TempGit"
  $client = new-object System.Net.WebClient
  $client.DownloadFile( $GitUrl, $TempGit )
  $install_args = @("/SP","/VERYSILENT","/SUPPRESSMSGBOXES","/CLOSEAPPLICATIONS","/NOICONS")
  $process = Start-Process -FilePath $TempGit -ArgumentList $install_args -Wait -PassThru
  if ($process.ExitCode -ne 0) {
    Write-Host "Git installer failed."
    Exit 1
  }

  Write-Host "Git successfully installed."
 
  if (Test-Path "${Env:ProgramFiles(x86)}\Git\bin\git.exe") {
    $clone_args = @("clone",$puppet_source,"C:\ProgramData\PuppetLabs\puppet\etc\modules" )
    Write-Host "Cloning $clone_args"
    $process = Start-Process -FilePath "${Env:ProgramFiles(x86)}\Git\bin\git.exe" -ArgumentList $clone_args -Wait -PassThru
    if ($process.ExitCode -ne 0) {
      Write-Host "Git clone failed."
      Exit 1
    }
  }

  Write-Host "Repo successfully cloned."

  $puppet_args = @("apply","--modulepath=C:\ProgramData\PuppetLabs\puppet\etc\modules","-e","`"include $role`"" )
  Write-Host "Running puppet $puppet_args"
#  $process = Start-Process -FilePath "${Env:ProgramFiles(x86)}\Puppet Labs\Puppet\bin\puppet.bat" -ArgumentList $puppet_args -Wait -PassThru
  $process = Start-Process -FilePath "C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat" -ArgumentList $puppet_args -Wait -PassThru
  if ($process.ExitCode -ne 0) {
    Write-Host "Puppet apply failed."
    Exit 1
  }
