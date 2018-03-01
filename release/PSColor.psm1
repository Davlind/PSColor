
Add-Type -assemblyname System.ServiceProcess

. "$PSScriptRoot\PSColorHelper.ps1"
. "$PSScriptRoot\FileInfo.ps1"
. "$PSScriptRoot\ServiceController.ps1"
. "$PSScriptRoot\MatchInfo.ps1"
. "$PSScriptRoot\ProcessInfo.ps1"

$global:PSColor = @{
    File = @{
        Default    = @{ Color = 'White' }
        Directory  = @{ Color = 'Cyan'}
        Hidden     = @{ Color = 'DarkGray'; Pattern = '^\.' } 
        Code       = @{ Color = 'Magenta'; Pattern = '\.(java|c|cpp|cs|js|css|html)$' }
        Executable = @{ Color = 'Red'; Pattern = '\.(exe|bat|cmd|py|pl|ps1|psm1|vbs|rb|reg)$' }
        Text       = @{ Color = 'Yellow'; Pattern = '\.(txt|cfg|conf|ini|csv|log|config|xml|yml|md|markdown)$' }
        Compressed = @{ Color = 'Green'; Pattern = '\.(zip|tar|gz|rar|jar|war)$' }
    }
    Service = @{
        Default = @{ Color = 'White' }
        Running = @{ Color = 'DarkGreen' }
        Stopped = @{ Color = 'DarkRed' }     
    }
    Match = @{
        Default    = @{ Color = 'White' }
        Path       = @{ Color = 'Cyan'}
        LineNumber = @{ Color = 'Yellow' }
        Line       = @{ Color = 'White' }
    }
}

$script:showHeader=$true

function Out-Default {
    [CmdletBinding(HelpUri='http://go.microsoft.com/fwlink/?LinkID=113362', RemotingCapability='None')]
    param(
        [switch]
        ${Transcript},

        [Parameter(Position=0, ValueFromPipeline=$true)]
        [psobject]
        ${InputObject})

    begin
    {
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Core\Out-Default', [System.Management.Automation.CommandTypes]::Cmdlet)
            $scriptCmd = {& $wrappedCmd @PSBoundParameters }

            $steppablePipeline = $scriptCmd.GetSteppablePipeline()
            $steppablePipeline.Begin($PSCmdlet)
        } catch {
            throw
        }
    }

    process
    {
        try {
            if(($_ -is [System.IO.DirectoryInfo]) -or ($_ -is [System.IO.FileInfo]))
            {
                FileInfo $_
                $_ = $null
            }

            elseif($_ -is [System.ServiceProcess.ServiceController])
            {
                ServiceController $_
                $_ = $null
            }

            elseif($_ -is [Microsoft.Powershell.Commands.MatchInfo])
            {
                MatchInfo $_
                $_ = $null
            }
            else {
                $steppablePipeline.Process($_)
            }
        } catch {
            throw
        }
    }

    end
    {
        try {
            write-host ""
            $script:showHeader=$true
            $steppablePipeline.End()
        } catch {
            throw
        }
    }
    <#

    .ForwardHelpTargetName Out-Default
    .ForwardHelpCategory Function

    #>
}

Export-ModuleMember Out-Default