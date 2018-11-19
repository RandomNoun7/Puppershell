function Get-PuppetMasterName {
    [CmdletBinding()]
    param (

    )

    begin {
    }

    process {
        if(-not (Get-Command puppet)) {
            Write-Error 'Puppet command not found.'
            return
        }

        Write-Output (puppet config print server)
    }

    end {
    }
}
