$proPlusThemeValue = 7;
$OfficeThemeRegKey = 'HKCU:\Software\Microsoft\Office\16.0\Common'

Set-ItemProperty -Path $OfficeThemeRegKey -Name 'UI Theme' -Value $proPlusThemeValue -Type DWORD

# Set your identity
Get-ChildItem -Path ($OfficeThemeRegKey + "\Roaming\Identities\") | ForEach-Object {
  $identityPath = ($_.Name.Replace('HKEY_CURRENT_USER', 'HKCU:') + "\Settings\1186\{00000000-0000-0000-0000-000000000000}");

  if (Get-ItemProperty -Path $identityPath -Name 'Data' -ErrorAction Ignore) {
    Write-Verbose $identityPath

    Set-ItemProperty -Path $identityPath -Name 'Data' -Value ([byte[]]($proPlusThemeValue, 0, 0, 0)) -Type Binary
  }
}