$processes=Get-Process | Where-Object CPU -GE 4  
$total=$processes.Count
$i = 0
while ($i -lt 100)
{
  Write-Progress -Activity "Starting Cherry OK..." -Status "$i%" -PercentComplete $i
  Start-Sleep -Milliseconds 50
  $i++
}