function Write-Color-MatchContext() {
    param (
        [Parameter(Mandatory=$True)] $display,
        [Parameter(Mandatory=$True)] $filename,
        [Parameter(Mandatory=$True)] $start
    )

    $display | foreach {
        Write-Host "  ${filename}" -foregroundcolor $global:PSColor.Context.Path.Color -noNewLine
        Write-Host ":" -foregroundcolor $global:PSColor.Context.Default.Color -NoNewline
        Write-Host "$start" -foregroundcolor $global:PSColor.Context.LineNumber.Color -noNewLine
        Write-Host ":" -foregroundcolor $global:PSColor.Context.Default.Color -NoNewline
        write-host "$_" -foregroundcolor $global:PSColor.Context.Line.Color
        $start++
    }
}

function MatchInfo {
    param (
        [Parameter(Mandatory=$True,Position=1)] $match
    )

    if ($match.Context) {
        Write-Color-MatchContext $match.Context.DisplayPreContext $match.RelativePath($pwd) `
                     ($match.LineNumber - $match.Context.DisplayPreContext.Count)
    }

    Write-host $match.RelativePath($pwd) -foregroundcolor $global:PSColor.Match.Path.Color -noNewLine
    Write-host ':' -foregroundcolor $global:PSColor.Match.Default.Color -noNewLine
    Write-host $match.LineNumber -foregroundcolor $global:PSColor.Match.LineNumber.Color -noNewLine
    Write-host ':' -foregroundcolor $global:PSColor.Match.Default.Color -noNewLine
    Write-host $match.Line -foregroundcolor $global:PSColor.Match.Line.Color

    if ($match.Context) {
        Write-Color-MatchContext $match.Context.DisplayPostContext $match.RelativePath($pwd) `
                     ($match.LineNumber + 1)
    }
}