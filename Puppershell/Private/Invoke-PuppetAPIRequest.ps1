function Invoke-PuppetAPIRequest {
    [CmdletBinding()]
    param (
        [string]$server,
        [int]$port = 4433,
        [switch]$SkipCertificateCheck,
        [string]$endpoint,
        [string]$method,
        [PSObject]$body,
        [hashtable]$headers
    )

    begin {
    }

    process {

        if([string]::IsNullOrEmpty($server)){
            $server = Get-PuppetMasterName
        }

        if($port -ne 443) {
            $serverport += "$server`:$port"
        } else {
            $serverport = $server
        }

        $requestVars = @{
            uri                  = "https://$serverport/$endpoint"
            contentType          = 'application/json'
            method               = $method
            SkipCertificateCheck = $SkipCertificateCheck
            headers              = @{}
        }

        if(![string]::IsNullOrEmpty($body)) {
            $requestVars.body = $body
        }

        if($PSBoundParameters.ContainsKey('headers')){
            $requestVars.headers = $headers
        }

        if(([string]::IsNullOrEmpty($Script:AuthToken)) -and ($endpoint -ne 'rbac-api/v1/auth/token')){
            Write-Verbose 'Authentication token not found. Requesting a new one.'
            Get-PuppetLoginToken -server $server -SkipCertificateCheck:$SkipCertificateCheck
        }

        if($endpoint -ne 'rbac-api/v1/auth/token') {
            $requestVars.headers.'X-Athentication' = $Script:AuthToken
        }

        try {
            Write-Verbose $requestVars.uri
            Invoke-RestMethod @requestVars
        } catch {
            throw $_
        }
    }

    end {
    }
}
