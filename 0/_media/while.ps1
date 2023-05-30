$ms=$args[1]
$processes=Get-Process | Where-Object CPU -GE 4  
$total=$processes.Count
$i = 0
#$title = "hi"
#$ms = 1000
while ($i -lt 100)
{
  Write-Progress -Activity "$title" -Status "$i%" -PercentComplete $i
  Start-Sleep -Milliseconds $ms/100
  $i++
}