# Legt die Verknüpfung "Quest" auf dem Desktop und im Startmenü an.
# Ausführen: powershell -ExecutionPolicy Bypass -File desktop\install_shortcut.ps1
$here   = Split-Path -Parent $MyInvocation.MyCommand.Path
$script = Join-Path $here 'quest_desktop.py'
$icon   = Join-Path $here 'quest.ico'
$pyw    = (Get-Command pythonw.exe -ErrorAction Stop).Source

$shell = New-Object -ComObject WScript.Shell
$targets = @(
  (Join-Path ([Environment]::GetFolderPath('Desktop')) 'Quest.lnk'),
  (Join-Path ([Environment]::GetFolderPath('Programs')) 'Quest.lnk')
)
foreach ($path in $targets) {
  $lnk = $shell.CreateShortcut($path)
  $lnk.TargetPath       = $pyw
  $lnk.Arguments        = "`"$script`""
  $lnk.WorkingDirectory = $here
  if (Test-Path $icon) { $lnk.IconLocation = $icon }
  $lnk.Description      = 'Quest - Aufgaben, Fokus und Quest-Stunden'
  $lnk.Save()
  Write-Output "Verknuepfung angelegt: $path"
}
