$RotationSequence = Get-Content -Path "$PSScriptRoot/input.txt"
$DialMin = 0
$DialMax = 99
$DialPosition = 50
$TimesDialAtZero = 0

foreach ($Rotation in $RotationSequence) {
  $RotationDirection = $Rotation[0]
  $RotationDistance = [int]$Rotation.Substring(1)

  Write-Output "Dial position: $DialPosition`nProcessing rotation: $Rotation`n"

  $Operator = $RotationDirection -eq "L" ? "-" : "+"
  $RotationResult = Invoke-Expression "$DialPosition $Operator $RotationDistance"

  while ($RotationResult -lt $DialMin) {
    $RotationResult += 100
  }
  while ($RotationResult -gt $DialMax) {
    $RotationResult -= 100
  }

  $DialPosition = $RotationResult

  if ($DialPosition -eq 0) {
    $TimesDialAtZero++
  }
}

Write-Output "Times dial at zero: $TimesDialAtZero"
