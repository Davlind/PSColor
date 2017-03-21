PSColor
=======

Provides color highlighting for some basic PowerShell output. It currently rewrites "Out-Default" to colorize:
* FileInfo & DirectoryInfo objects (Get-ChildItem, dir, ls etc.)
* ServiceController objects (Get-Service)
* MatchInfo objects (Select-String etc.)

## Installation

The easiest way to install, by far, is to use [PsGet](http://psget.net/). Once PsGet is installed you can simply run `Install-Module PSColor`.

Alternativly, you can download the file [PSColor.zip](https://github.com/Davlind/PSColor/raw/master/release/PSColor.zip) and extract it to a folder named `PSColor` in any of your PowerShell module paths. (Run `$env:PSModulePath` to see your paths.)

If you want PSColor to be ran automatically you can add `Import-Module PSColor` to your PowerShell Profile. To locate your profile, run `$profile`

## Configuration

You can configure PSColor by overriding the values of colors, patterns etc. Configurations should be added after `Import-Module PSColor` in your PowerShell profile. The default configuration looks like:

```powershell
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
	NoMatch = @{
        Default    = @{ Color = 'White' }
        Path       = @{ Color = 'Cyan'}
        LineNumber = @{ Color = 'Yellow' }
        Line       = @{ Color = 'White' }
    }
}
```

E.g. if you would like to override the red color for Executables, in favour of blue; you could add the following to your PowerShell profile:

```powershell
$global:PSColor.File.Executable.Color = 'Blue'
```
