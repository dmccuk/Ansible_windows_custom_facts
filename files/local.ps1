## Option 1
$apache_ver = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion | where { $_.DisplayName -match 'Apache' } | select DisplayVersion | ft -HideTableHeaders | findstr '.'

## Option 2
$apache_ver1 = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName | where { $_.DisplayName -match 'Apache' } | ft -HideTableHeaders | findstr 'Apache' | %{ $_.split(' ')[3]; }


if ($NULL -eq $apache_ver)  { $apache_ver = 'Apache_not_installed' }
if ($NULL -eq $apache_ver1) { $apache_ver1 = 'Apache_not_installed' }
if ($NULL -eq $other_ver)   { $other_ver = 'Other_not_installed' }

@{
    local = @{
        local_facts = @{
          apache = $apache_ver
          apache_name = $apache_ver1
          other = $other_ver
      }
    }
}

