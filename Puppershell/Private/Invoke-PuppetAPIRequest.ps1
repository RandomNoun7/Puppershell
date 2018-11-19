function Invoke-PuppetAPIRequest {
    [CmdletBinding()]
    param (
        [string]$server,
        [int]$port = 4433,
        [switch]$ignoreSSL,
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

        $requestVars = @{
            uri                  = "https://$server`:$port/$endpoint"
            contentType          = 'application/json'
            method               = $method
            SkipCertificateCheck = $ignoreSSL
            headers              = @{}
        }

        if(![string]::IsNullOrEmpty($body)) {
            $requestVars.body = $body
        }

        if($PSBoundParameters.ContainsKey('headers')){
            $requestVars.headers = $headers
        }

        if(![string]::IsNullOrEmpty($Script:AuthToken)){
            Write-Verbose 'Authentication Header Found.'
            $requestVars.headers.'X-Athentication' = $Script:AuthToken
        }

        try {
            Invoke-RestMethod @requestVars
        } catch {
            throw $_
        }
    }

    end {
    }
}
