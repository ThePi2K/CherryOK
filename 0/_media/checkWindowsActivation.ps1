cd..
$ActivationStatus = Get-CimInstance SoftwareLicensingProduct -Filter "Name like 'Windows%'" | Where-Object { $_.PartialProductKey } | Select-Object LicenseStatus       

        $LicenseResult = switch($ActivationStatus.LicenseStatus){
          0	{"Unlicensed"}
          1	{"Licensed"}
          2	{"OOBGrace"}
          3	{"OOTGrace"}
          4	{"NonGenuineGrace"}
          5	{"Not Activated"}
          6	{"ExtendedGrace"}
          default {"unknown"}
        }
 $LicenseResult | Out-File -Encoding "ASCII" tmp