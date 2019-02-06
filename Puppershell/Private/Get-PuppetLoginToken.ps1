function Get-PuppetLoginToken {
    [CmdletBinding()]
    param (
        [pscredential]$credential,
        [string]$server,
        [int]$port = 4433,
        [switch]$SkipCertificateCheck,
        [string]$lifetime
    )

    begin {
    }

    process {

        if($NULL -eq $credential){
            $credential = (Get-Credential)
        }

        $puppetAPIVars = @{
            body = @{
                login    = $credential.username
                password = $credential.GetNetworkCredential().password
            } | ConvertTo-JSON
            endpoint  = 'rbac-api/v1/auth/token'
            method    = 'Post'
            server    = $server
            port      = $port
            SkipCertificateCheck = $SkipCertificateCheck
        }

        if(-not [string]::IsNullOrEmpty($lifetime)) {
            $puppetAPIVars.body.lifetime = $lifetime
        }

        try {
            $authReturn = Invoke-PuppetAPIRequest @puppetAPIVars

            Write-Verbose "Return from auth end point: $($authReturn.token)"

            $Script:authToken = $authReturn.token
        } catch {
            throw $_
        }
    }

    end {
    }
}
