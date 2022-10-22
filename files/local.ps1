$apache_ver = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion | where { $_.DisplayName -match 'Apache' } | select DisplayVersion | ft -HideTableHeaders | findstr '.'

if ($NULL -eq $apache_ver) { $apache_ver = 'Apache_not_installed' }

@{
    local = @{
        local_facts = @{
          apache = $apache_ver
      }
    }
}

