#Requires -Version 7.0

$RotationSequence = Get-Content -Path "$PSScriptRoot/input.txt"

$DialPosition = 50
$TimesDialStopsAtZero = 0 # First half of puzzle solution.
$TimesDialAtZero = 0 # Second half of puzzle solution.

foreach ($Rotation in $RotationSequence) {
  $RotationDirection = $Rotation[0]
  $RotationDistance = [int]$Rotation.Substring(1)

  Write-Output "Dial position: $DialPosition`nProcessing rotation: $Rotation`n"

  $Operator = $RotationDirection -eq "L" ? "-" : "+"
  $RotationResult = Invoke-Expression "$DialPosition $Operator $RotationDistance"
  # Ensure result is positive.
  $NewDialPosition = ($RotationResult % 100 + 100) % 100

  # Check if zero is crossed during incomplete rotation.
  if ($RotationDirection -eq "L") {
    if ($NewDialPosition -gt $DialPosition -and $DialPosition -ne 0) {
      $TimesDialAtZero++
    }
  }
  else {
    if ($NewDialPosition -lt $DialPosition -and $NewDialPosition -ne 0) {
      $TimesDialAtZero++
    }
  }

  $DialPosition = $NewDialPosition

  if ($DialPosition -eq 0) {
    $TimesDialStopsAtZero++
    $TimesDialAtZero++
  }

  # Times zero is crossed during complete rotations.
  $TimesDialAtZero += [Math]::Floor($RotationDistance / 100)
}

Write-Output "Times dial stops at zero (first half of solution): $TimesDialStopsAtZero"
Write-Output "Times dial at zero (second half of solution): $TimesDialAtZero"
