$dir = dir "${env:localappdata}\Google\Chrome\User Data" | ?{$_.PSISContainer}

# Put your URI schemes in like so {"ext": false, "ext2": false}
$incl = ConvertFrom-Json @"
{"excluded_schemes": {"aul": false}}
"@


foreach ($d in $dir){
    $pref = Join-Path -Path $d.FullName -ChildPath "Preferences"
    if(Test-Path $pref -PathType Leaf) {
        $j = Get-Content $pref | ConvertFrom-Json
        $j | Add-Member -Force -Name "protocol_handler" -value $incl -MemberType NoteProperty
        ConvertTo-Json $j | Set-Content $pref
    }
}
