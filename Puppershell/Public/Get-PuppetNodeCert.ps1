function Get-PuppetNodeCert {
    [CmdletBinding()]
    param (
        # The name of the node to search for
        [Parameter(Mandatory=$false)]
        [String]
        $NodeName,
        # The name of the Puppet Master Server to query
        [Parameter(Mandatory=$false)]
        [String]
        $Master,
        # Skip certificate validation
        [Parameter(Mandatory=$false)]
        [switch]
        $SkipCertificateCheck
    )
    <#
    .SYNOPSIS
        Search for node certificates that belong to a given Puppet Master
    .DESCRIPTION
        This cmdlet can be used to find the certificate status for nodes that
        are joined to a Puppet master, or nodes that have requested a certificate
        to join the master. It will search for a specific node name, or it can
        return all nodes, or it can do wildcard filters. Matching on server names
        is accomplished via the -match PowerShell operator.
    .EXAMPLE
        PS C:\> Get-PuppetNodeCert
        Return all nodes joined to the master that is configured in the current
        machines puppet.conf file.
    .EXAMPLE
        PS C:\> Get-PuppetNodeCert -Master mypuppetmaster.mycorp.com
        Return all nodes joined to an arbitrary Puppet master server. Useful if
        you have more than one Puppet master in your environemnt.
    .EXAMPLE
        PS C:\> Get-PuppetNodeCert -NodeName myawesomeserver.mycorp.com
        Return the certificate for a specific server.
    .EXAMPLE
        PS C:\> Get-PuppetNodeCert -NodeName *web*
        Return certificates for all servers joined to the default Puppet master
        that have the word 'web' in the name.
    #>
    begin {
    }

    process {

        $params = @{
            endpoint             = 'puppet-ca/v1/certificate_status'
            method               = 'Get'
            SkipCertificateCheck = $SkipCertificateCheck
            Port                 = 8140
        }

        if($MyInvocation.BoundParameters.ContainsKey('NodeName')){
            $params.endpoint += "/$nodeName"
        } else {
            # The end point is pluralized for the searching function.
            $params.endpoint += "es/any_key"
        }

        $params.endpoint += '?environment=production'

        if($MyInvocation.BoundParameters.ContainsKey('master')){
            $params.server = $master
        }

        Invoke-PuppetAPIRequest @params
    }

    end {
    }
}
